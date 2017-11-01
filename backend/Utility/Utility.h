//
//  Utility.h
//  NewIceApp
//
//  Created by Yunas Qazi on 2/10/12.
//  Copyright (c) 2012 Style360. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface Utility : NSObject

//+(void)setNavigationBarTitle:(NSString*)title forViewController:(UIViewController*)vc;
//+(void)setNavigationBarFor:(UIViewController*)vc WithTitle:(NSString*)title;
+(NSString*)getThumbFullPath:(NSString*)path;
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

+(BOOL) isValidEmail :(NSString *)str;

//+(BOOL) isValidEmail :(NSString *)str;
//+(BOOL) isValidUsername :(NSString *)str;
//+(BOOL)NSStringIsValidTelNum:(NSString*)phoneNumber;
+(NSString*) nullCheck :(NSString *)str;
//+(void)showAlertView:(NSString *)message;
//+(void)showBackButton:(UIViewController *)viewController;

+(NSString *)getCurrentDate;
    
+(void)setBackButton:(UINavigationItem * ) navigationItem withTargetController:(UIViewController *)controller;

@end
