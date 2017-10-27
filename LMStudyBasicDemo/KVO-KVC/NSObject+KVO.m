//
//  NSObject+KVO.m
//  LMStudyBasicDemo
//
//  Created by Tim on 2017/2/20.
//  Copyright © 2017年 LM. All rights reserved.
//

#import "NSObject+KVO.h"
#import <objc/runtime.h>
#import <objc/message.h>

NSString *const kLMKVOClassPrefix = @"LMKVOClassPrefix_";
NSString *const kLMKVOAssociatedObservers = @"LMKVOAssociatedObserver";

@interface LMObservationInfo : NSObject

@property (nonatomic, weak) NSObject *observer;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) LMObservingBlock block;

@end

@implementation LMObservationInfo

- (instancetype)initWithObserver:(NSObject *)observer Key:(NSString *)key block:(LMObservingBlock)block
{
    self = [super init];
    if(self) {
        _observer = observer;
        _key = key;
        _block = block;
    }
    return self;
}

@end

#pragma mark - Debug Help Methods

static NSArray *ClassMethodNames(Class cls)
{
    NSMutableArray *array = [NSMutableArray array];
    unsigned int methodCount = 0;
    Method *methodList = class_copyMethodList(cls, &methodCount);
    for (unsigned int index = 0; index < methodCount; index += 1) {
        [array addObject:NSStringFromSelector(method_getName(methodList[index]))];
    }
    free(methodList);
    return array;
}

static void PrintDescription(NSString *name, id obj)
{
    NSString *str = [NSString stringWithFormat:
                     @"%@: %@\n\tNSObject clas %s\n\tRuntime class %s\n\timplement methods <%@>\n\n",
                     name,
                     obj,
                     class_getName([obj class]),
                     class_getName(objc_getClass((__bridge void *)obj)),
                     [ClassMethodNames(objc_getClass((__bridge void *)obj)) componentsJoinedByString:@", "]];
//    printf(@"%s \n", [str UTF8String]);
    NSLog(@"------------%@", str);
}

static NSString *getterForSetter(NSString *setter)
{
    if (setter.length <= 0 || ![setter hasPrefix:@"set"] || ![setter hasPrefix:@":"]) {
        return nil;
    }
    
    //remove 'set' at the begining and ':' at the end
    NSRange range = NSMakeRange(3, setter.length - 4);
    NSString *key = [setter substringWithRange:range];
    
    // lower case the firt letter
    NSString *firstLetter = [[key substringToIndex:1] lowercaseString];
    key = [key stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:firstLetter];
    return key;
}

static NSString *setterForGetter(NSString *getter)
{
    if (getter.length <= 0) {
        return nil;
    }
    
    // upper case the first letter
    NSString *firstLetter = [[getter substringToIndex:1] uppercaseString];
    NSString *remainingLetters = [getter substringFromIndex:1];
    
    // add 'set' at the begining and ':' at the end
    NSString *setting = [NSString stringWithFormat:@"set%@%@", firstLetter, remainingLetters];
    return setting;
}

#pragma mark -Overridden Methods

static void kvo_setter(id self, SEL _cmd, id newValue)
{
    NSString *setterName = NSStringFromSelector(_cmd);
    NSString *getterName = getterForSetter(setterName);
    if (!getterName) {
        NSString *reson = [NSString stringWithFormat:@"object %@ does not have setter %@", self, setterName];
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:reson userInfo:nil];
        return;
    }
    id oldValue = [self valueForKey:getterName];
    struct objc_super superclazz = {
        .receiver = self,
        .super_class = class_getSuperclass(objc_getClass((__bridge void *)self))
    };
    
    
    // cast our pointer so the compiler won't complain
    void (*obj_msgSendSuperCasted)(void *, SEL, id) = (void *)objc_msgSendSuper;
    
    //call super's setter, which is original class's setter method
    obj_msgSendSuperCasted(&superclazz, _cmd, newValue);
    
    //look up observers and call the blocks
    NSMutableArray *observers = objc_getAssociatedObject(self, (__bridge const void *)(kLMKVOAssociatedObservers));
    for (LMObservationInfo *info in observers) {
        if ([info.key isEqualToString:getterName]) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                info.block(self, getterName, oldValue, newValue);
            });
        }
    }
}
static Class kvo_class(id self, SEL _cmd)
{
    return class_getSuperclass(objc_getClass((__bridge void *)self));
}

#pragma mark - KVO category

@implementation NSObject (KVO)

- (void)LM_addObserver:(NSObject *)observer forKey:(NSString *)key withBlock:(LMObservingBlock)block
{
    SEL setterSelector = NSSelectorFromString(setterForGetter(key));
    Method setterMethod = class_getInstanceMethod([self class], setterSelector);
    
    PrintDescription(@"myobject", self);
    
    if (!setterMethod) {
        NSString *reason = [NSString stringWithFormat:@"object %@ don't have a setter for key %@", self, key];
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:reason userInfo:nil];
        return;
    }
    Class clazz = objc_getClass((__bridge void *)self);
    NSString *clazzName = NSStringFromClass(clazz);
    
    //if not an KVO class  yet
    if (![clazzName hasPrefix:kLMKVOClassPrefix]) {
        clazz = [self makeKVOClassWithOriginalClassName:clazzName];
        object_setClass(self, clazz);
    }
    
    // add our kvo setter if this class (not superClass) doesn't implement the setter?
    if (![self hasSelector:setterSelector]) {
        const char *types = method_getTypeEncoding(setterMethod);
        class_addMethod(clazz, setterSelector, (IMP)kvo_setter, types);
    }
    LMObservationInfo *info = [[LMObservationInfo alloc] initWithObserver:observer Key:key block:block];
    NSMutableArray *observers = objc_getAssociatedObject(self, (__bridge const void *)kLMKVOAssociatedObservers);
    if (!observers) {
        observers = [NSMutableArray array];
        objc_setAssociatedObject(self, (__bridge const void *)kLMKVOAssociatedObservers, observers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    [observers addObject:info];
}

- (void)LM_removeObserver:(NSObject *)observer forKey:(NSString *)key
{
    NSMutableArray *observers = objc_getAssociatedObject(self, (__bridge const void *)kLMKVOAssociatedObservers);
    
    LMObservationInfo *infoRemove;
    for (LMObservationInfo *info in observers) {
        if (info.observer == observer && [info.key isEqual:key]) {
            infoRemove = info;
            break;
        }
    }
    [observers removeObject:infoRemove];
}

- (Class)makeKVOClassWithOriginalClassName:(NSString *)originalClassName
{
    NSString *kvoClassName = [kLMKVOClassPrefix stringByAppendingString:originalClassName];
    Class clazz = NSClassFromString(kvoClassName);
    if (clazz) {
        return clazz;
    }
    
    // class doesn't exist yet, make it
    Class originalClass = objc_getClass((__bridge void *)self);
    Class kvoClass = objc_allocateClassPair(originalClass, kvoClassName.UTF8String, 0);
    
    //grab class method's signature so we can borrow it
    Method classMethod = class_getInstanceMethod(originalClass, @selector(class));
    const char *types = method_getTypeEncoding(classMethod);
    class_addMethod(kvoClass, @selector(class), (IMP)kvo_class, types);
    objc_registerClassPair(kvoClass);
    return kvoClass;
}

- (BOOL)hasSelector:(SEL)selector
{
    Class clazz = object_getClass(self);
    unsigned int methodCount = 0;
    Method *methodList = class_copyMethodList(clazz, &methodCount);
    for (unsigned int index = 0 ; index < methodCount; index += 1) {
        SEL thisSelector = method_getName(methodList[index]);
        if (thisSelector == selector) {
            free(methodList);
            return YES;
        }
    }
    free(methodList);
    return NO;
}

@end
