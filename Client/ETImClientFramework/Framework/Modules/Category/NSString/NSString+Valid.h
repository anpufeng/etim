//
//  NSString+Valid.h
//  ETImClientFramework
//
//  Created by xuqing on 15/7/10.
//  Copyright (c) 2015年 ethan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Valid)

-(BOOL)isBlank;
-(BOOL)isValid;
- (NSString *)removeWhiteSpacesFromString;

- (BOOL)containsOnlyNumbers;

- (BOOL)isValidEmail;
- (BOOL)isValidPhoneNumber;
- (BOOL)isValidUrl;

//add by ethan

- (BOOL)isValidIPAddress;
- (BOOL)isValidHostPort;

@end
