//
//  HMModel.h
//  Listening
//
//  Created by ethan on 1/25/15.
//  Copyright (c) 2015 ethan. All rights reserved.
//

#import <Foundation/Foundation.h>

///所有对象模型的基类

@interface HMModel : NSObject

/**
 获取对象的所有属性
 **/
- (NSDictionary *)objProperties;
/**
 获取对象的所有方法
 **/
-(void)printMethodList;

/**
 对象描述
 **/
//- (NSString *)description;

@end
