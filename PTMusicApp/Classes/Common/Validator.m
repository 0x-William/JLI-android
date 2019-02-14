//
//  Validator.m
//  FruityBase
//
//  Created by Dang Luu on 3/11/13.
//  Copyright (c) 2013 Fruity Solution. All rights reserved.
//

#import "Validator.h"
#import "Macros.h"

@implementation Validator

+ (Validator *)sharedInstance {
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [[self alloc] init];
    });
}

#pragma mark Validator functions
+ (BOOL)validateEmail:(NSString*)email
{
	email = [email lowercaseString];
    NSString *emailRegEx =
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    
    NSPredicate *regExPredicate =
    [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    return [regExPredicate evaluateWithObject:email];
}

+ (BOOL)validateUrl:(NSString *)candidate {
    if (candidate.length == 0) {
        return YES;
    }
    if ([candidate rangeOfString:@"http"].location == NSNotFound) {
        candidate = [NSString stringWithFormat:@"http://%@", candidate];
    }
    NSString *urlRegEx =
    @"^(http(?:s)?\\:\\/\\/[a-zA-Z0-9\\-]+(?:\\.[a-zA-Z0-9\\-]+)*\\.[a-zA-Z]{2,6}(?:\\/?|(?:\\/[\\w\\-]+)*)(?:\\/?|\\/\\w+\\.[a-zA-Z]{2,4}(?:\\?[\\w]+\\=[\\w\\-]+)?)?(?:\\&[\\w]+\\=[\\w\\-]+)*)$";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    return [urlTest evaluateWithObject:candidate];
}

#pragma mark Get values
+ (NSString*)getString:(NSInteger)i {
    return [[NSNumber numberWithInt:i] stringValue];
}


+ (NSInteger)getSafeInt:(id)obj {
    
    if (obj == nil || [obj isKindOfClass:[NSNull class]]) {
        return 0;
    }
    if ([obj isKindOfClass:[NSNumber class]]) {
        return [obj integerValue];
    }
    if ([obj length] == 0) {
        return 0;
    }
    if ([obj isKindOfClass:[NSDictionary class]]) {
        return 0;
    }
    return [obj intValue];
}

+ (float)getSafeFloat:(id)obj {
    
    if (obj == nil || [obj isKindOfClass:[NSNull class]]) {
        return 0.0;
    }
    if ([obj isKindOfClass:[NSNumber class]]) {
        return [obj floatValue];
    }
    if ([obj length] == 0) {
        return 0.0;
    }
    if ([obj isKindOfClass:[NSDictionary class]]) {
        return 0.0;
    }
    return [obj floatValue];
}

+ (BOOL)getSafeBool:(id)obj {
    if (obj == nil || [obj isKindOfClass:[NSNull class]]) {
        return FALSE;
    }
    if ([obj isKindOfClass:[NSNumber class]]) {
        return [obj boolValue];
    }
    if ([obj length] == 0) {
        return FALSE;
    }
    if ([obj isKindOfClass:[NSDictionary class]]) {
        return FALSE;
    }
    return [obj boolValue];
}

+ (NSString *)getSafeString:(id)obj {
    if (obj == nil || [obj isKindOfClass:[NSNull class]]) {
        return @"";
    }
    if ([obj isKindOfClass:[NSString class]]) {
        return obj;
    }
    if ([obj isKindOfClass:[NSDictionary class]]) {
        return @"";
    }
    return [obj stringValue];
}


#pragma mark Checking functions
+ (BOOL)isNullOrNilObject:(id)object
{
    if ([object isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if (object == nil) {
        return YES;
    }
    if ([object isKindOfClass:[NSString class]]) {
        if ([object isEqualToString:@"nil"]) {
            return YES;
        }
    }
    return NO;
}

+ (BOOL)isValidObject:(id)object
{
    return ![Validator isNullOrNilObject:object];
}

@end
