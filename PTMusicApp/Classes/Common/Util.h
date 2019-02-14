//
//  Util.h
//  Ligue1
//
//  Created by hieunguyen on 8/9/14.
//  Copyright (c) 2014 FRUITYSOLUTION. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AppDelegate.h"
@interface Util : NSObject

+ (Util *)sharedUtil;

+(BOOL)isConnectNetwork;
+ (NSString *) durationToString: (float) duration;


+ (void)removeObjectForKey:(NSString *)key;
+(BOOL)getBoolForKey:(NSString *)key;
+ (BOOL) isMusicPlaying;

+(void)setBool:(BOOL)obj forKey:(NSString *)key;
+ (id)objectForKey:(NSString *)key;
+ (void)setObject:(id)obj forKey:(NSString *)key;
+ (UIColor *)colorFromHexString:(NSString *)hexString andAlpha:(float) alpha;


+(NSString *)stringFromDate:(NSDate *)date format:(NSString *)format;
+(NSDate *)dateFromString:(NSString *)date format:(NSString *)format;

//Alert functions
+ (void)showMessage:(NSString *)message withTitle:(NSString *)title;
+ (void)showMessage:(NSString *)message withTitle:(NSString *)title andDelegate:(id)delegate;
+ (void)showMessage:(NSString *)message withTitle:(NSString *)title delegate:(id)delegate andTag:(NSInteger)tag;
+ (void)showMessage:(NSString *)message withTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelTitle otherButtonTitles:(NSString *)otherTitle delegate:(id)delegate andTag:(NSInteger)tag;


+(CGRect )viewUp:(UIView *)view Up:(int)height;

+(CGRect )viewDown:(UIView *)view Down:(int)height;


+ (UIButton *) drawButton: (UIButton *)button;


@end
