//
//  LMTestKVCObject.m
//  LMStudyBasicDemo
//
//  Created by Tim on 2017/8/11.
//  Copyright © 2017年 LM. All rights reserved.
//

#import "LMTestKVCObject.h"

@implementation LMTestKVCObject

{
    NSString* toSetName;
    NSString* isName;
    //NSString* name;
    NSString* _name;
    NSString* _isName;
}
 -(void)setName:(NSString*)name{
     toSetName = name;
 }
-(NSString*)getName{
    return toSetName;
}
+(BOOL)accessInstanceVariablesDirectly{
    return NO;
}
-(id)valueForUndefinedKey:(NSString *)key{
    NSLog(@"出现异常，该key不存在%@",key);
    return nil;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"出现异常，该key不存在%@",key);
}

@end
