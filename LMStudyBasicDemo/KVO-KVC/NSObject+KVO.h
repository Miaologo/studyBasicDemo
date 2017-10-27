//
//  NSObject+KVO.h
//  LMStudyBasicDemo
//
//  Created by Tim on 2017/2/20.
//  Copyright © 2017年 LM. All rights reserved.
//

#import <Foundation/Foundation.h>

//http://tech.glowing.com/cn/implement-kvo/

typedef void (^LMObservingBlock)(id observeObject, NSString *observedKey, id oldValue, id newValue);

@interface NSObject (KVO)

- (void)LM_addObserver:(NSObject *)observer forKey:(NSString *)key withBlock:(LMObservingBlock)block;

- (void)LM_removeObserver:(NSObject *)observer forKey:(NSString *)key;

@end
