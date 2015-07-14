//
//  NSString+Valid.m
//  ETImClientFramework
//
//  Created by xuqing on 15/7/10.
//  Copyright (c) 2015年 ethan. All rights reserved.
//

#import "NSString+Valid.h"

#include <arpa/inet.h>

@implementation NSString (Valid)

// Checking if String is Empty
-(BOOL)isBlank
{
    return ([[self removeWhiteSpacesFromString] isEqualToString:@""]) ? YES : NO;
}
//Checking if String is empty or nil
-(BOOL)isValid
{
    return ([[self removeWhiteSpacesFromString] isEqualToString:@""] || self == nil || [self isEqualToString:@"(null)"]) ? NO :YES;
}

// remove white spaces from String
- (NSString *)removeWhiteSpacesFromString
{
    NSString *trimmedString = [self stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return trimmedString;
}


- (BOOL)containsOnlyNumbers {
    NSCharacterSet *numbersCharacterSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    return ([self rangeOfCharacterFromSet:numbersCharacterSet].location == NSNotFound);
}

// Is Valid Email

- (BOOL)isValidEmail
{
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTestPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [emailTestPredicate evaluateWithObject:self];
}

// Is Valid Phone

- (BOOL)isValidPhoneNumber
{
    NSString *regex = @"[235689][0-9]{6}([0-9]{3})?";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [test evaluateWithObject:self];
}

// Is Valid URL

- (BOOL)isValidUrl
{
    NSString *regex =@"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [urlTest evaluateWithObject:self];
}


- (BOOL)isValidIPAddress
{
    const char *utf8 = [self UTF8String];
    int success;
    
    struct in_addr dst;
    success = inet_pton(AF_INET, utf8, &dst);
    if (success != 1) {
        struct in6_addr dst6;
        success = inet_pton(AF_INET6, utf8, &dst6);
    }
    
    return success == 1;
}

- (BOOL)isValidHostPort {
    if ([self containsOnlyNumbers]) {
        return ([self intValue] >= 0 && [self intValue] <= 65535);
    } else {
        return NO;
    }
}

@end
