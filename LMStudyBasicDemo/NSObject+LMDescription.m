//
//  NSObject+LMDescription.m
//  LMStudyBasicDemo
//
//  Created by Tim on 2017/8/16.
//  Copyright © 2017年 LM. All rights reserved.
//

#import "NSObject+LMDescription.h"
#import <objc/runtime.h>

@implementation NSObject (LMDescription)

//- (NSString *)description
//{
//    u_int count;
//    objc_property_t *properties = class_copyPropertyList([self class], &count);
//    NSMutableArray *propertiesArr = [NSMutableArray arrayWithCapacity:count];
//    NSMutableArray *propertiesValueArr = [NSMutableArray arrayWithCapacity:count];
//    for (int i = 0; i < count; i++) {
//        const char* propertyName = property_getName(properties[i]);
//        if (strcmp(propertyName, "description") == 0 || strcmp(propertyName, "superclass") == 0 || strcmp(propertyName, "debugDescription") == 0) {
//            continue;
//        }
//        [propertiesArr addObject:[NSString stringWithUTF8String:propertyName]];
//        id propertyValue = [self valueForKey:[NSString stringWithUTF8String:propertyName]];
//        if (propertyValue == nil) {
//            [propertiesValueArr addObject:@""];
//        } else {
//            [propertiesValueArr addObject:propertyValue];
//        }
//    }
//    free(properties);
//    NSString *formatString = @"<%@: %p";
//    NSString *rightFormatString = @"----- %@ = %@";
//    NSString *returnString = [NSString stringWithFormat:formatString, [self class], self];
//    for (int i = 0; i < propertiesValueArr.count; i++) {
//        returnString = [returnString stringByAppendingString:[NSString stringWithFormat:rightFormatString, propertiesArr[i], propertiesValueArr[i]]];
//    }
//    returnString = [returnString stringByAppendingString:@">"];
//    return returnString;
//}

@end
