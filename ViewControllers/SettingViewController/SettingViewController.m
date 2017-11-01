

//
//  SettingViewController.m
//  nearhero
//
//  Created by Irfan Malik on 6/14/16.
//  Copyright © 2016 TBoxSolutionz. All rights reserved.
//

#import <sys/utsname.h>
#include <sys/types.h>
#include <sys/sysctl.h>
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "IntroViewController.h"
#import <UIKit/UIKit.h>
#import "URLBuilder.h"
#import "GenericFetcher.h"
#import "SettingViewController.h"
#import "HomeViewController.h"
#import "UserSettings.h"
#import "Toast+UIView.h"
#import "MessageViewController.h"
#import <MessageUI/MessageUI.h>
#import "WebViewController.h"

//#import "UIActivityViewController.h"
//#import "ActiveViewController.h"
//#import "ActivityViewController.h"
#import "UserInfo.h"
#import "Constants.h"
#define URLEMail @"mailto:info@nearhero.com?subject=NearHero&body= "

@import GoogleMobileAds;

@interface SettingViewController ()
{
    UserSettings *userSettings;
    NSTimer *timer;
    int secondsElapsed;
    BOOL pauseTimeCounting;
} 
@end

@implementation SettingViewController
{
    UIGestureRecognizer *singleFingertapper;
}

- (IBAction)didTapDeleteAccount:(id)sender{
    self.deleteAccountView.alpha = 0.3;
   
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Are you sure you want to delete account?"
                                                    message:@"By deleting this account you will no longer be able to use NearHero using this email (until register again) and all the data including chatting history, friends etc will be lost"
                                                   delegate:self
                                          cancelButtonTitle:@"YES"
                                          otherButtonTitles:@"NO",nil];
    alert.tag = 2;
    [alert show];
  

}
-(IBAction)didTapContactView:(id)sender{
    
    
    NSString *url = [URLEMail stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding ];
    if([[UIApplication sharedApplication]  canOpenURL: [NSURL URLWithString: url]])
        [[UIApplication sharedApplication]  openURL: [NSURL URLWithString: url]];
    
//        if([MFMessageComposeViewController canSendText])
//        {
//            NSArray *toRecipents = [[NSArray alloc] initWithObjects:@"info@nearhero.com", nil ];
//            self.ContactViaEmailView.alpha = 0.3;
//            NSString *emailTitle = @"";
//            // Email Content
//            NSString *messageBody =  @"";
//            // To address
//            MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
//            mc.mailComposeDelegate = self;
//            [mc setSubject:emailTitle];
//            [mc setMessageBody:messageBody isHTML:NO];
//            [mc setToRecipients:toRecipents];    
//            // Present mail view controller on screen
//            [self presentViewController:mc animated:YES completion:NULL];
//            [self.navigationController presentViewController:mc animated:YES completion:nil];
//            self.ContactViaEmailView.alpha = 1.0;
//        }
//        else
//        {
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"" message: @"iPhone mail application not found on your device"delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
//            [alert show];
//  
//        }


    
    
}
-(IBAction)didTapSignOutAccount:(id)sender{
    self.signoutView.alpha = 0.3;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"SURE"
                                                    message:@"Are you sure you want to Sign Out?"
                                                   delegate:self
                                          cancelButtonTitle:@"YES"
                                          otherButtonTitles:@"NO",nil];
    alert.tag = 1;
    
    [alert show];

}
-(IBAction)didTapPrivacyAndTerms:(id)sender{
    self.privacyView.alpha = 0.3;
    NSTimer *aTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(disableTouchEffect) userInfo:nil repeats:NO];
    //[[UIApplication sharedApplication] openURL: [NSURL URLWithString:@"https://nearhero.com/privacy-policy/"]];
    [(HomeViewController*)(((MainViewController*)kMainViewController).rootViewController) openWebView:@"https://nearhero.com/privacy-policy/"];

}


-(IBAction)didTapPolicyView:(id)sender{
    self.policyView.alpha = 0.3;
    NSTimer *aTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(disableTouchEffect) userInfo:nil repeats:NO];
   // [[UIApplication sharedApplication] openURL: [NSURL URLWithString:@"https://nearhero.com/terms-of-use/"]];
   
    
    
    [(HomeViewController*)(((MainViewController*)kMainViewController).rootViewController) openWebView:@"https://nearhero.com/terms-of-use/"];


   // [self presentViewController:nav animated:YES completion:nil];
    
}

-(IBAction)didTapShareNearHero:(id)sender{
    self.shareView.alpha = 0.3;
    
    NSString * message = @"Hey, heard you were looking for work.Try NearHero and connect with professionals near you.\n https://itunes.apple.com/us/app/nearhero/id1178883512?ls=1&mt=8";
    
    NSArray * objectsToShare = @[message];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    
    NSArray *excludeActivities = @[UIActivityTypeAirDrop,
                                   UIActivityTypePrint,
                                   UIActivityTypeAssignToContact,
                                   UIActivityTypeAddToReadingList,
                                   UIActivityTypePostToFlickr,
                                   UIActivityTypePostToVimeo];

    [activityVC setValue:@"NearHero" forKey:@"subject"];    
    activityVC.excludedActivityTypes = excludeActivities;
    [activityVC setCompletionHandler:^(NSString *activityType, BOOL completed) {
        self.shareView.alpha = 1.0;
    }];

    
    //if iPhone
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self presentViewController:activityVC animated:YES completion:nil];
    }
    
    //if iPad
    else {
        // Change Rect to position Popover
        UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:activityVC];
        [popup presentPopoverFromRect:CGRectMake(self.view.frame.size.width, self.view.frame.size.height, 0, 0)inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }

    
}
-(void)disableTouchEffect{
    self.shareView.alpha = 1.0;
    self.reviewView.alpha = 1.0;
    self.privacyView.alpha = 1.0;
    self.policyView.alpha = 1.0;
}

-(IBAction)didTapWriteReview:(id)sender{
    self.reviewView.alpha = 0.6;
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(disableTouchEffect) userInfo:nil repeats:NO];
    
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:@"https://itunes.apple.com/us/app/nearhero/id1178883512?ls=1&mt=8"]];
       }
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    //0 means share near hero button...
    if(alertView.tag == 0){
//        if (buttonIndex == [alertView cancelButtonIndex]){
//            NSLog(@"sharenearhero cancel button is clicked...");
//        }
//        else{
//            NSLog(@"sharenearhero other button is clicked...");
//        }
    }
    //1 means sign out button...
    else if(alertView.tag == 1){
        //It means yes clicked...
        if (buttonIndex == [alertView cancelButtonIndex]){
            AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate ;
            [appDelegate updateFcmDeviceToken:@"logout"];
            
            [appDelegate stopUpdatingLoc];
            [appDelegate disconnect];
            [appDelegate setIntroMenu];
            UserInfo *userinfo = [UserInfo instance];
            [userinfo removeUserInfo];
            [userinfo saveUserInfo];
            self.signoutView.alpha = 1.0;
           // self.fadeTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(bortInfo) userInfo:nil repeats:YES];


        }
        else{
            self.signoutView.alpha = 1.0;;
            NSLog(@"signout other button is clicked...");
        }
    }
    //2 means delete account button...
    else if(alertView.tag == 2){
        self.deleteAccountView.alpha = 1.0;;
        if (buttonIndex == [alertView cancelButtonIndex]){
            NSLog(@"delete account YES button is clicked...");
            AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            BOOL isAvailable = [appDelegate isNetworkAvailable];
            if(isAvailable){
                NSUbiquitousKeyValueStore *store = [NSUbiquitousKeyValueStore defaultStore];
                NSMutableDictionary *appstate = [store objectForKey:kappState];
                 appstate = nil;
                if (store) {
                    appstate = nil;
                    [store setObject:appstate forKey:kappState];
                }

                
                
                [self.view makeToastActivity];
                UserInfo *userinfo = [UserInfo instance];
                NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
                [params setValue:[userinfo valueForKey:kuu_id] forKey:kid];
                [params setValue:userinfo.apiKey forKey:kapi_key];
                GenericFetcher *fetcher = [[GenericFetcher alloc]init];
                
                [fetcher fetchWithUrl:[URLBuilder urlForMethod:kdelete_account withParameters:nil]
                           withMethod:POST_REQUEST withParams:params completionBlock:^(NSDictionary *dict) {
                               NSLog(@"%@",dict);
                               int status = [[dict valueForKey:kstatus] intValue];
                               if (status == 1) {
                                   
                                   AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate ;
                                   [appDelegate stopUpdatingLoc];
                                   [appDelegate disconnect];
                                   [appDelegate setIntroMenu];
                                   UserInfo *userinfo = [UserInfo instance];
                                   [userinfo removeUserInfo];
                                   [userinfo saveUserInfo];
                                   [self.view hideToastActivity];
                                   
                               }
                               else
                               {
                                   UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:[dict valueForKey:kerror] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                                   [alert show];
                                   [self.view hideToastActivity];

                               }
                               
                               
                           }
                           errorBlock:^(NSError *error) {
                               
                               NSLog(@"no internet");
                               NSLog(@"%@",error);
                               [self.view hideToastActivity];
                           }];
            
            }

        }
        else{
            self.deleteAccountView.alpha = 1.0;
            NSLog(@"delete account NO button is clicked...");
            
        }
    }
}

-(void) labelsEnabled{
    
    //enabling user interaction...
    self.deleteAccountView.userInteractionEnabled = YES;
    self.signOut.userInteractionEnabled = YES;
    self.shareView.userInteractionEnabled = YES;
    
    //gesture recognizer for delete Account...
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
     initWithTarget:self action:@selector(didTapDeleteAccount:)];
    [self.deleteAccountView addGestureRecognizer:tapGesture];
    
    
    //gesture recognizer for sign out...
    tapGesture = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(didTapSignOutAccount:)];
    [self.signOut addGestureRecognizer:tapGesture];
    
    
    //gesture recognizer for share nearhero...
    tapGesture = [[UITapGestureRecognizer alloc]
                  initWithTarget:self action:@selector(didTapShareNearHero:)];
    [self.shareView addGestureRecognizer:tapGesture];
    //[tapGesture release];
    
    //gesture recognizer for privacy and term conditions...
    tapGesture = [[UITapGestureRecognizer alloc]
                  initWithTarget:self action:@selector(didTapPrivacyAndTerms:)];
    [self.privacyView addGestureRecognizer:tapGesture];
    
    //gesture recognizer for write a review...
    tapGesture = [[UITapGestureRecognizer alloc]
                  initWithTarget:self action:@selector(didTapWriteReview:)];
    [self.reviewView addGestureRecognizer:tapGesture];
    
    //gesture recognizer for sending an email...
    tapGesture = [[UITapGestureRecognizer alloc]
                  initWithTarget:self action:@selector(didTapContactView:)];
    [self.ContactViaEmailView addGestureRecognizer:tapGesture];
    
    tapGesture = [[UITapGestureRecognizer alloc]
                  initWithTarget:self action:@selector(didTapPolicyView:)];
    [self.policyView addGestureRecognizer:tapGesture];


    
}
- (void)createAndLoadBannerAdd {
   self.bannerAdd.adUnitID = @"ca-app-pub-8845201596497802/6830783976";
   //*****Test Ad ID
   // ca-app-pub-3940256099942544/2934735716
    
    
    self.bannerAdd.rootViewController = self;
    GADRequest *request = [GADRequest request];
   
    [self.bannerAdd loadRequest:request];
    request.testDevices = @[
                            @"2077ef9a63d2b398840261c8221a0c9a"  // Eric's iPod Touch
                            ];
    [self.bannerAdd loadRequest:request];
    
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    userSettings = [UserSettings instance];
    if(!userSettings.isSubscribed)
            [self createAndLoadBannerAdd];
    self.scroller.delegate=self;
    self.scroller.contentSize = CGSizeMake(320, 568);
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(showTimerMessage) userInfo:nil repeats:YES];
    secondsElapsed = 0;
    [self labelsEnabled];

    NSLog(@"Hello...");
   
    
    singleFingertapper = [[UITapGestureRecognizer alloc]

                          initWithTarget:self action:@selector(removeSettingsView)];
    
    singleFingertapper.delegate = self;
    singleFingertapper.cancelsTouchesInView = NO;
    [self.transperentView addGestureRecognizer:singleFingertapper];
    self.navigationController.navigationBarHidden = true;
   
}

-(void)removeSettingsView{
    
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenHeight = screenRect.size.height;
        [UIView animateWithDuration:1.0
                                   delay:0
                                 options:UIViewAnimationOptionOverrideInheritedOptions
                              animations:^{
                                 [(HomeViewController*)(((MainViewController*)kMainViewController).rootViewController) tView].alpha = 0.0;
                                  [self.view setFrame:CGRectMake(self.view.frame.origin.x,
                                                                screenHeight,
                                                                self.view.frame.size.width,
                                                                self.view.frame.size.height)];
                              }
                              completion:^(BOOL finished) {
                                  [self.view removeFromSuperview];
                                  [(HomeViewController*)(((MainViewController*)kMainViewController).rootViewController) hideView];
                              }];
    
        [self dismissViewControllerAnimated:YES completion:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    userSettings = [UserSettings instance];
    BOOL mapF = userSettings.showMeOnMapFlag;
    BOOL professionalF = userSettings.showProfesssionalFlag;
    BOOL msgF = userSettings.messagesFlag;
    if(mapF)
        [self.mapSwitchControl setOn:YES animated:YES];
    else
        [self.mapSwitchControl setOn:NO animated:YES];
    if(professionalF)
        [self.professionalSwitchControl setOn:YES animated:YES];
    else
        [self.professionalSwitchControl setOn:NO animated:YES];
    if(msgF)
        [self.messageSwitchControl setOn:YES animated:YES];
    else
        [self.messageSwitchControl setOn:NO animated:YES];

}
-(void) updateSettings:(NSString*)switchVal
{
    if([switchVal isEqualToString:@"Yes"])
    {
        [userSettings setShowMeOnMapFlag:YES];
        [userSettings saveUserSettings];

    }
    else
    {
        [userSettings setShowMeOnMapFlag:NO];
        [userSettings saveUserSettings];

    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowMeOnMap" object:nil userInfo:nil];
}

- (IBAction)showMeOnMap:(id)sender {
    
    NSString *switchVal = [[NSString alloc] init];
       if([sender isOn]){
           switchVal = @"Yes";
           [self.mapSwitchControl setOn:YES];
    
//        [userSettings setShowMeOnMapFlag:YES];
//        [userSettings saveUserSettings];
    }
    else{
        switchVal = @"No";
        [self.mapSwitchControl setOn:NO];
//        [userSettings setShowMeOnMapFlag:NO];
//        [userSettings saveUserSettings];
        
    }
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    BOOL isAvailable = [appDelegate isNetworkAvailable];
    if(isAvailable){
        UserInfo *userinfo = [UserInfo instance];
        NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
        [params setValue:[userinfo valueForKey:kuu_id] forKey:kid];
        [params setValue:switchVal forKey:klocation_service_status];
        [self.view makeToastActivity];
        GenericFetcher *fetcher = [[GenericFetcher alloc]init];
        
        [fetcher fetchWithUrl:[URLBuilder urlForMethod:kuser_location_services withParameters:nil]
                   withMethod:POST_REQUEST withParams:params completionBlock:^(NSDictionary *dict) {
                       NSLog(@"%@",dict);
                       int status = [[dict valueForKey:kstatus] intValue];
                       if (status == 1) {
                           
                           
                               NSDictionary *result = [dict valueForKey:kResult];
                               [self.view hideToastActivity];
                               [self updateSettings:switchVal];

                       }
                       else
                       {
                               [self.view hideToastActivity];
                               UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:[dict valueForKey:kerror] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                               [alert show];
                       }
                       
                   }
                   errorBlock:^(NSError *error) {
                       
                           [self.view hideToastActivity];
                           NSLog(@"no internet");
                           NSLog(@"%@",error);
                   }];
            
      //  [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowMeOnMap" object:nil userInfo:nil];
    }
}
- (IBAction)showNewMessages:(id)sender {
    if([sender isOn]){
        [userSettings setMessagesFlag:YES];
        [userSettings saveUserSettings];
    }
    else{
        [userSettings setMessagesFlag:NO];
        [userSettings saveUserSettings];
    }
}

- (IBAction)showNearProfessionals:(id)sender {
    if([sender isOn]){
        [userSettings setShowProfesssionalFlag:YES];
        [userSettings saveUserSettings];
    }
    else{
        [userSettings setShowProfesssionalFlag:NO];
        [userSettings saveUserSettings];
    }

}
-(void)showTimerMessage{
    if (pauseTimeCounting) {
        secondsElapsed++;
        
       // lblTimerMessage.text = [NSString stringWithFormat:@"You've been viewing this view for %d seconds", self.secondsElapsed];
    }
    else{
        //lblTimerMessage.text = @"Paused to show ad...";
    }
}

#pragma mark - email feature

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Mail Cancelled" message:@"" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
            [alert show];
        }
            break;
        case MFMailComposeResultSaved:
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Mail Saved" message:@"" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
            [alert show];
        }
            break;
        case MFMailComposeResultSent:
        {
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Mail Sent" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
            [alert show];
        }
            break;
        case MFMailComposeResultFailed:
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Mail Sent failure" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
            [alert show];
        }
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}


@end
