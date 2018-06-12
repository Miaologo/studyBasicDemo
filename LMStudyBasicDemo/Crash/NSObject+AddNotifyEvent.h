//
//  NSObject+AddNotifyEvent.h
//  LMStudyBasicDemo
//
//  Created by Tim on 2018/6/12.
//  Copyright © 2018年 LM. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^LMNotifyBlock)(NSNotification *note, id object);

@interface NSObject (AddNotifyEvent)

- (void)addNotifyObject:(id)object eventName:(NSString *)name block:(void (^)(NSNotification *note, id object))block;
- (void)addNotifyObject:(id)object eventName:(NSString *)name level:(int)level block:(void (^)(NSNotification *note, id object))block;

@end


@interface LMNotificationAssocater : NSObject

@property (nonatomic, weak) id observerObject;
@property (nonatomic, strong) NSMutableDictionary *notifyMap;

- (instancetype)initWithObserverObject:(id)observerObject;

- (void)addNotifyEvent:(NSString *)event watchObject:(id)watchObject observerObject:(id)observerObject level:(int)level block:(LMNotifyBlock)block;

@end

@interface LMNotificationInfo : NSObject


@end
