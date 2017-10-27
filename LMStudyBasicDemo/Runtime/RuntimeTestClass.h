//
//  RuntimeTestClass.h
//  LMStudyBasicDemo
//
//  Created by Tim on 2017/3/3.
//  Copyright © 2017年 LM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RuntimeTestClass : NSObject<NSCopying, NSCoding>

@property (nonatomic, strong) NSArray *publicProperty1;
@property (nonatomic, strong) NSString *publicProperty2;

+ (void)classMethod:(NSString *)value;
- (void)publicTestMethod:(NSString *)value1 second:(NSString *)value2;
- (void)publicTestMethod2;

@end
