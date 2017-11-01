//
//  IntroViewController.h
//  nearhero
//
//  Created by Dilawer Hussain on 6/2/16.
//  Copyright © 2016 TBoxSolutionz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <linkedin-sdk/LISDK.h>
#import <linkedin-sdk/LISDKAPIHelper.h>
#import "GenericFetcher.h"
#import "OAuthLoginView.h"



@interface IntroViewController : UIViewController{
    NSMutableDictionary *params;
    GenericFetcher *linkedInFetcher;
}
@property (weak, nonatomic) IBOutlet UIButton *emailButton;
@property (weak, nonatomic) IBOutlet UIButton *restorePurchaseBtn;
@property (nonatomic,strong) OAuthLoginView *linkedInLoginView;
-(IBAction)loginWithFB:(id)sender;
-(IBAction)loginWithLinkedIn:(id)sender;
- (IBAction)restorePurchase:(id)sender;
@end
