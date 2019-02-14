//
//  Macros.h
//  Mi6App
//
//  Created by 4G SECURE on 9/1/13.
//  Copyright (c) 2013 4G SECURE. All rights reserved.
//
#import "Util.h"

#ifndef Mi6App_Macros_h
#define Mi6App_Macros_h

#define SetupLanguage(TITLE) AMLocalizedString(TITLE,nil)

#define DELEGATE (AppDelegate*)[[UIApplication sharedApplication] delegate]

#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define START_LOADING [[Util sharedUtil] showLoadingView]
#define SHOW_COMING_SOON [Util showMessage:@"Coming soon" withTitle:@"BMW Car Service"]
#define STOP_LOADING [[Util sharedUtil] hideLoadingView]
#define SHOW_NETWORK_ERROR  [Util showMessage:@"Network connection error" withTitle:@"Error"]
#define SHOW_SERVER_ERROR  [Util showMessage:@"Sorry, there's an error occurred when connecting to server" withTitle:@"Server error"]


#define SYSTEM_VERSION_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


//Lemon add 2013-09-05
#define DEFINE_SHARED_INSTANCE_USING_BLOCK(block) \
static dispatch_once_t pred = 0; \
__strong static id _sharedObject = nil; \
dispatch_once(&pred, ^{ \
_sharedObject = block(); \
}); \
return _sharedObject; \

#define IS_IPAD() (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define NEW_VC(className) [[className alloc] initWithNibName:[Util getXIB:[className class]] bundle:nil]
#define V(x,y) IS_IPAD()?x:y
#define DEVICE_VERSION                      [[[UIDevice currentDevice] systemVersion] floatValue]

#pragma - mark DEVICE INFORMATION

/** String: Identifier **/
#define DEVICE_IDENTIFIER ( ( IS_IPAD ) ? DEVICE_IPAD : ( IS_IPHONE ) ? DEVICE_IPHONE , DEVICE_SIMULATOR )

/** String: iPhone **/
#define DEVICE_IPHONE @"iPhone"

/** String: iPad **/
#define DEVICE_IPAD @"iPad"

/** String: Device Model **/
#define DEVICE_MODEL ( [[UIDevice currentDevice ] model ] )

/** String: Localized Device Model **/
#define DEVICE_MODEL_LOCALIZED ( [[UIDevice currentDevice ] localizedModel ] )

/** String: Device Name **/
#define DEVICE_NAME ( [[UIDevice currentDevice ] name ] )

/** Double: Device Orientation **/
#define DEVICE_ORIENTATION ( [[UIDevice currentDevice ] orientation ] )

/** String: Simulator **/
#define DEVICE_SIMULATOR @"Simulator"

/** String: Device Type **/
#define DEVICE_TYPE ( [[UIDevice currentDevice ] deviceType ] )

/** BOOL: Detect if device is an iPhone or iPod **/
#define IS_IPHONE ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone )

/** BOOL: IS_RETINA **/
#define IS_RETINA ( [[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2 )

/** BOOL: Detect if device is the Simulator **/
#define IS_SIMULATOR ( TARGET_IPHONE_SIMULATOR )

#pragma - mark SYSTEM INFORMATION

/** String: System Name **/
#define SYSTEM_NAME ( [[UIDevice currentDevice ] systemName ] )

/** String: System Version **/
#define SYSTEM_VERSION ( [[UIDevice currentDevice ] systemVersion ] )

#pragma mark - SCREEN INFORMATION

/** Float: Portrait Screen Height **/
#define SCREEN_HEIGHT_PORTRAIT ( [[UIScreen mainScreen ] bounds ].size.height )

/** Float: Portrait Screen Width **/
#define SCREEN_WIDTH_PORTRAIT ( [[UIScreen mainScreen ] bounds ].size.width )

/** Float: Landscape Screen Height **/
#define SCREEN_HEIGHT_LANDSCAPE ( [[UIScreen mainScreen ] bounds ].size.width )

/** Float: Landscape Screen Width **/
#define SCREEN_WIDTH_LANDSCAPE ( [[UIScreen mainScreen ] bounds ].size.height )

/** CGRect: Portrait Screen Frame **/
#define SCREEN_FRAME_PORTRAIT ( CGRectMake( 0, 0, SCREEN_WIDTH_PORTRAIT , SCREEN_HEIGHT_PORTRAIT ) )

/** CGRect: Landscape Screen Frame **/
#define SCREEN_FRAME_LANDSCAPE ( CGRectMake( 0, 0, SCREEN_WIDTH_LANDSCAPE , SCREEN_HEIGHT_LANDSCAPE ) )

/** Float: Screen Scale **/
#define SCREEN_SCALE ([[UIScreen mainScreen] scale ] )

/** CGSize: Screen Size Portrait **/
#define SCREEN_SIZE_PORTRAIT ( CGSizeMake( SCREEN_WIDTH_PORTRAIT * SCREEN_SCALE , SCREEN_HEIGHT_PORTRAIT * SCREEN_SCALE ) )

/** CGSize: Screen Size Landscape **/
#define SCREEN_SIZE_LANDSCAPE ( CGSizeMake( SCREEN_WIDTH_LANDSCAPE * SCREEN_SCALE , SCREEN_HEIGHT_LANDSCAPE * SCREEN_SCALE ) )

#pragma mark - COLOR
/** UIColor: Color From Hex **/

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//RGB color macro with alpha
#define UIColorFromRGBWithAlpha(rgbValue,a) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

/** UIColor: Color from RGB **/
#define colorFromRGB(r, g, b) ( [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1 ] )

#define RGB(r, g, b)                    [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

/** UIColor: Color from RGBA **/

#define colorFromRGBA(r, g, b, a) ( [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a ] )

#define RGBA(r, g, b, a)                [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#pragma mark - DEGREES, RADIANS

/** Degrees to Radian **/
#define degreesToRadians( degrees ) ( ( degrees ) / 180.0 * M_PI )

/** Radians to Degrees **/
#define radiansToDegrees( radians ) ( ( radians ) * ( 180.0 / M_PI ) )

/** Check iPhone5 **/
#define IS_IPHONE_5                     (SCREEN_HEIGHT_PORTRAIT == 568)

#define IS_IOS7        ([[[UIDevice currentDevice] systemVersion] integerValue] >= 7)

#define LSSTRING(str) NSLocalizedString(str, str)

#define NIL_IF_NULL(foo) ((foo == [NSNull null]) ? nil : foo)

#define NULL_IF_NIL(foo) ((foo == nil) ? [NSNull null] : foo)

#define EMPTY_IF_NIL(foo) ((foo == nil) ? @"" : foo)

#define EMPTY_IF_NULL(foo) ((foo == [NSNull null]) ? @"" : foo)

#define EMPTY_IF_NULL_OR_NIL(foo) ((foo == [NSNull null] || foo == nil) ? @"" : foo)



#endif
