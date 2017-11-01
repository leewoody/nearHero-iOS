//
//  Utility.m
//  NewIceApp
//
//  Created by Yunas Qazi on 2/10/12.
//  Copyright (c) 2012 Style360. All rights reserved.
//

#import "Utility.h"
#import "Constants.h"

#define kTimeInterval 0.50


@implementation Utility

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+(void)setNavigationBarTitle:(NSString*)title forViewController:(UIViewController*)vc{
    UILabel *lblTitle = (UILabel*)vc.navigationItem.titleView;
    [lblTitle setText:title];
}
+(BOOL) isValidEmail :(NSString *)str{
	BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
	NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
	NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
	NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
	NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
	return [emailTest evaluateWithObject:str];
}
// also setting background
//+(void)setNavigationBarFor:(UIViewController*)vc WithTitle:(NSString*)title{
//    [vc.navigationController.navigationBar setSize:CGSizeMake(320, 45)];
//    UILabel *lblTitle = (UILabel*)[vc.navigationController.navigationItem.titleView viewWithTag:10001];
//    if (!lblTitle) {
//        lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 222, 52)];
//        lblTitle.backgroundColor = [UIColor clearColor];
//        lblTitle.font = [UIFont fontWithName:@"Roboto-Bold" size:20];
//        lblTitle.textAlignment = UITextAlignmentCenter;
//        lblTitle.textColor =[UIColor colorWithRed:85.0/255 green:85.0/255 blue:85.0/255 alpha:1.0];
//        [lblTitle setTag:10001];
//        vc.navigationItem.titleView = lblTitle;
//    }
//    lblTitle.text=title;
//    if ([vc.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
//    {
//        [vc.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bar.png"]
//                                                      forBarMetrics:UIBarMetricsDefault];
//    }
//    [vc.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]]];
//}

+(NSString*)getThumbFullPath:(NSString*)path{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:path];
    return [NSString stringWithFormat:@"%@",fullPath];
}

//
//+(void)showAlertView:(NSString *)message{
//    
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Laywers" 
//                                                   message:message 
//                                                  delegate:nil 
//                                         cancelButtonTitle:@"OK" 
//                                         otherButtonTitles: nil];
//    [alert show];
//    [alert release];
//}
//+(void)showBackButton:(UIViewController *)viewController{
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    UIImage *butImage = [UIImage imageNamed:@"back"];
//    [button setBackgroundImage:butImage forState:UIControlStateNormal];
//    [button addTarget:viewController action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
//    button.frame = CGRectMake(0, 6,51,31);
//    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:button];
//    viewController.navigationItem.leftBarButtonItem = [backButton autorelease];
//}
//
//+(BOOL) isValidEmail :(NSString *)str{
//	BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
//	NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
//	NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
//	NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
//	NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
//	return [emailTest evaluateWithObject:str];
//}
//+(BOOL) isValidUsername :(NSString *)str{
//    //	BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
//	NSString *stricterFilterString = @"[A-Z0-9a-z._]";
//    //	NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
//    //	NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
//	NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stricterFilterString];
//	return [emailTest evaluateWithObject:str];
//}
//
//+(BOOL)NSStringIsValidTelNum:(NSString*)phoneNumber{
//    NSString *phoneRegex = @"[235689][0-9]{6}([0-9]{3})?"; 
//    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex]; 
//    return [test evaluateWithObject:phoneNumber];
//    
//}
//

+(NSString*) nullCheck :(NSString *)str
{
	if (str) {
		return str;
	}
	return @"";
}
+(NSString *)getCurrentDate{
    NSString *requiredDate = nil;
      NSDate *date = [NSDate date];
    
        // format it
        // Convert string to date object
   NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//    [dateFormat setDateFormat:@"yyyyMMdd"];
//    NSDate *date = [dateFormat dateFromString:requiredDate];
//    
    
        // Convert date object to desired output format
    [dateFormat setDateFormat:@"EEEE MMMM d, YYYY"];
    requiredDate = [dateFormat stringFromDate:date];
        //requiredDate = [dateFormat stringFromDate:date];
    
    NSLog(@"%@",requiredDate);
    return  requiredDate;
}
+(void)setBackButton:(UINavigationItem * )navigationItem withTargetController:(UIViewController *)controller{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backBtnImage = [UIImage imageNamed:@"back_btn.png"];
    [backBtn setBackgroundColor:[UIColor clearColor]];
    [backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal];

    [backBtn addTarget:controller action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    UIView *backButtonView = [[UIView alloc] init];

    if (IS_IPHONE) {
        backBtn.frame = CGRectMake(0, 0, 20, 24);
        [backButtonView setFrame:CGRectMake(0, 0, 20+8, 24+8)];
        backButtonView.bounds = CGRectOffset(backButtonView.bounds, -8, -8);
    }else{
        backBtn.frame = CGRectMake(20, 70, 44, 52);
        [backButtonView setFrame:CGRectMake(40, 10, 44+60, 52+70)];
//        backButtonView.bounds = CGRectOffset(backButtonView.bounds, -20, -20);
    }
    
//    [backButtonView setBackgroundColor:[UIColor whiteColor]];
    [backButtonView addSubview:backBtn];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backButtonView];
    navigationItem.leftBarButtonItem = backButton;
}

@end
