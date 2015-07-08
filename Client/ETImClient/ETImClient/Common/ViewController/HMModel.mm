//
//  HMModel.m
//  Listening
//
//  Created by ethan on 1/25/15.
//  Copyright (c) 2015 ethan. All rights reserved.
//

#import "HMModel.h"
#import <objc/runtime.h>

@implementation HMModel

/**
 获取对象的所有属性

**/
- (NSDictionary *)objProperties {
#ifdef DEBUG
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);

    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const char* char_f =property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        id propertyValue = [self valueForKey:(NSString *)propertyName];
        if (propertyValue) [props setObject:propertyValue forKey:propertyName];
    }
    free(properties);

    return props;
#endif
    
    return nil;
}


/**
 获取对象的所有方法
**/

-(void)printMethodList {
#ifdef DEBUG
    unsigned int methCout_f =0;
    Method* methList_f = class_copyMethodList([self class],&methCout_f);

    for(int i = 0; i < methCout_f; i++) {
        Method temp_f = methList_f[i];
        //IMP imp_f = method_getImplementation(temp_f);
        //SEL name_f = method_getName(temp_f);
        const char* name_s =sel_getName(method_getName(temp_f));
        int arguments = method_getNumberOfArguments(temp_f);
        const char* encoding =method_getTypeEncoding(temp_f);
        NSLog(@"方法名：%@,参数个数：%d,编码方式：%@",[NSString stringWithUTF8String:name_s],
              arguments,
              [NSString stringWithUTF8String:encoding]);
    }
    free(methList_f);
#endif
}

/*
#ifdef DEBUG
- (NSString *)description {
    NSDictionary *propertiyDic = [self objProperties];
    NSString *desc = @"";
    NSArray *keyList = [propertiyDic allKeys];
    for (int i = 0; i < [keyList count]; i++) {
        NSString *key = [keyList objectAtIndex:i];
        NSString *value = [self valueForKey:key];
        desc = [desc stringByAppendingString:[NSString stringWithFormat:@" key = %@, value = %@", key, value]];
    }

    return desc;
}
#endif
 */

@end
