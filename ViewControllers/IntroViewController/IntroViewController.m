
//  IntroViewController.m
//  nearhero
//
//  Created by Dilawer Hussain on 6/2/16.
//  Copyright © 2016 TBoxSolutionz. All rights reserved.
//

#import "IntroViewController.h"
#import "SelectJobTitleViewController.h"
#import "AppDelegate.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

#import "URLBuilder.h"
#import "Utility.h"
#import "UserInfo.h"
#import "Constants.h"
#import "UserSettings.h"
#import "Toast+UIView.h"
#import "UserSettings.h"
#import "HomeViewController.h"
@import FirebaseInstanceID;

@interface IntroViewController ()
{
    NSMutableArray *jid;
}
@end

@implementation IntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    linkedInFetcher = [[GenericFetcher alloc]init];
    [[self.emailButton layer] setBorderWidth:1.0f];
    [[self.emailButton layer] setBorderColor:[UIColor colorWithRed:17/255.0 green:135.0/255.0 blue:247.0/255.0 alpha:1.0].CGColor];
    [self.emailButton setHidden:YES];

    // Do any additional setup after loading the view from its nib.
    UserInfo *userInfo = [UserInfo instance];
        if (userInfo.isLogin){
        
        AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate ;
        [appDelegate connect];
        [appDelegate setHomeMenu];
        return;
    }
    params=nil;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showRestoreAlert:)
                                                 name:kuserIsSubscribed object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kuserIsSubscribed object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(IBAction)loginWithFB:(id)sender{
    //TODO: check login expiration date as well to keep user login
    [self.view makeToastActivity];
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];    
    [login logOut];   //ESSENTIAL LINE OF CODE
    [login logInWithReadPermissions: @[@"public_profile",@"email",@"user_friends",@"user_photos"]
     fromViewController:self
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             NSLog(@"Process error");
         } else if (result.isCancelled) {
             NSLog(@"Cancelled");
         } else {
             NSLog(@"Logged in");

             NSString *fb_token =  result.token.tokenString;
             
             NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
             [parameters setValue:@"id,name,email" forKey:@"fields"];
             
             [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters]
              startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                           id result, NSError *error) {
                  NSDictionary *d = (NSDictionary*)result;
                  NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
                  [param setValue:[d valueForKey:kname] forKey:kname];
                  [param setValue:[d valueForKey:kid] forKey:kid];
                  [param setValue:[d valueForKey:kemail] forKey:kemail];
                  [param setValue:fb_token forKey:kfb_token];
                  NSString* deviceId = [[FIRInstanceID instanceID] token];
                  if(deviceId == nil)
                      [param setValue:@"abcdefgh" forKey:kfcm_device_token];
                  else
                      [param setValue:[[FIRInstanceID instanceID] token] forKey:kfcm_device_token];
                  
                  GenericFetcher *fetcher = [[GenericFetcher alloc]init];
                
                  [fetcher fetchWithUrl:[URLBuilder urlForMethod:klogin_with_fb withParameters:nil]
                             withMethod:POST_REQUEST withParams:param completionBlock:^(NSDictionary *_dict) {
                                NSLog(@"%@",_dict);
                                 int status = [[_dict valueForKey:kstatus] intValue];
                                 NSMutableDictionary *dict1 = [_dict valueForKey:@"response"];
                                 NSMutableDictionary *dict = [dict1 valueForKey:kresult];
                                 if (status == 1) {
                                     UserInfo *userInfo = [UserInfo instance];
                                     [userInfo setName:[dict valueForKey:kname]];
                                     [userInfo setEmailAddress:[dict valueForKey:kemail]];
                                     [userInfo setUu_id:[dict valueForKey:kid]];
                                     [userInfo setFbLiToken:[dict valueForKey:kfb_token]];
                                     [userInfo setImageUrl:[dict valueForKey:kprofile_image]];
                                     [userInfo setJidPassword:[dict valueForKey:kpassword]];
                                     [userInfo setApiKey: [dict valueForKey:kapi_key]];
                                     [userInfo setProfession:[dict valueForKey:kprofession]];
                                     [userInfo setRecentSearch:@""];

                                     userInfo.longitude = [[dict valueForKey:klng] doubleValue];
                                     userInfo.latitude = [[dict valueForKey:klat] doubleValue];
                                
                                     [self getUserFriends];
                                     userInfo.isLogin=YES;
                                     [userInfo saveUserInfo];
                                     UserSettings *userSetting = [UserSettings instance];
                                     userSetting.userId = [dict valueForKey:kid];
                                     [userSetting setShowMeOnMapFlag:[[dict valueForKey:location_service_status]boolValue]];
                                     [userSetting saveUserSettings];
                                     AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
                                     
                                     
                                    [appDelegate setHomeMenu];
                                     [appDelegate connect];
                                     if(userSetting.showMeOnMapFlag)
                                         [appDelegate updateUserLocation];
                                     [self.view hideToastActivity];
                                 }
                                 else{
                                     UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:[dict valueForKey:kerror] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                                     [alert show];
                                     [self.view hideToastActivity];
                                 }
                                 [self.view hideToastActivity];
                             }
                             errorBlock:^(NSError *error) {
                                 [self.view hideToastActivity];
                                 NSLog(@"no internet");
                                 NSLog(@"%@",error);
                             }];
              }];
         }
     }];
}



-(void)loginLinkedIn{
    if (params != nil) {
        [linkedInFetcher fetchWithUrl:[URLBuilder urlForMethod:klogin_with_li withParameters:nil]
                   withMethod:POST_REQUEST withParams:params completionBlock:^(NSDictionary *dict){
             NSLog(@"%@",dict);
             int status = [[dict valueForKey:kstatus] intValue];
             NSMutableDictionary *response = [dict valueForKey:kresponse];
             if (status == 1) {
                 [self performSelector:@selector(gettingLIConnections) withObject:nil afterDelay:12.0];

                 UserInfo *userInfo = [UserInfo instance];
                 [userInfo setName:[response valueForKey:kname]];
                 [userInfo setEmailAddress:[response valueForKey:kemail]];
                 [userInfo setFbLiToken:[response valueForKey:kli_token]];
                 [userInfo setUu_id:[response valueForKey:kid]];
                 [userInfo setProfession:[response valueForKey:kprofession]];
                 [userInfo setImageUrl:[response valueForKey:kprofile_image]];
                 [userInfo setApiKey: [response valueForKey:kapi_key]];
                 
                 userInfo.isLogin=YES;
                 [userInfo saveUserInfo];
                 UserSettings *userSetting = [UserSettings instance];
                 [userSetting setShowMeOnMapFlag:[[dict valueForKey:location_service_status] boolValue]];
                 
                 
                 [userSetting saveUserSettings];
                                  AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate ;
                 [appDelegate setHomeMenu];
                 [appDelegate connect];
                 [self.view hideToastActivity];
                 params=nil;
                 
                 [self performSelector:@selector(saveLocationOnServer) withObject:nil afterDelay:12.0];
                 


                 //for testing
                 NSLog(@"Error inside ");
             }
             else
             {
                 UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:[dict valueForKey:kerror] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                 [alert show];
                 [self.view hideToastActivity];
             }
             
             [self.view hideToastActivity];
             // TODO: Abeera stop progress spinner here for success response
         }
                   errorBlock:^(NSError *error) {
                       [self.view hideToastActivity];
                       // TODO: Abeera stop progress spinner here for failure response
                       NSLog(@"no internet");
                       NSLog(@"%@",error);
                   }];
    }
}

-(IBAction)loginWithLinkedIn:(id)sender{
    [self.view makeToastActivity];
    //comment starts...
    //NSArray *permissions = [NSArray arrayWithObjects: LISDK_BASIC_PROFILE_PERMISSION, nil];
    NSArray *permissions = [NSArray arrayWithObjects:LISDK_EMAILADDRESS_PERMISSION,LISDK_BASIC_PROFILE_PERMISSION, nil];
    [LISDKSessionManager createSessionWithAuth:permissions state:nil showGoToAppStoreDialog:YES successBlock:^(NSString *returnState)
     {
         NSLog(@"%s","success called!");
         LISDKSession *session = [[LISDKSessionManager sharedInstance] session];
         //NSString *url = @"https://api.linkedin.com/v1/people/~/connections?modified=new";
         //NSString *url = @"https://api.linkedin.com/v1/people/~/connections:(id,first-name,last-name,headline,email-address,picture-url,phone-numbers)";
         NSString *url = @"https://api.linkedin.com/v1/people/~:(id,first-name,last-name,headline,email-address,picture-url)";
         
         
         [self performSelector:@selector(loginLinkedIn) withObject:nil afterDelay:6.0];
         
         [[LISDKAPIHelper sharedInstance] getRequest:url
                                             success:^(LISDKAPIResponse *response)
          {
              NSData* data = [response.data dataUsingEncoding:NSUTF8StringEncoding];
              NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
              
              //UserInfo *userInfo = [UserInfo instance];
              NSString* fname = [dictResponse valueForKey:kfirstName];
              NSString* lname = [dictResponse valueForKey:klastName];
              NSString* profession = [dictResponse valueForKey:kheadline];
              NSString* email = [dictResponse valueForKey:kemailAddress];
              NSString* pictureUrl = [dictResponse valueForKey:kpictureUrl];
              NSString* name = [NSString stringWithFormat:@"%@ %@" , fname,lname];
              NSString* li_id = [dictResponse valueForKey:kid];
              
              params = [[NSMutableDictionary alloc]init];
              [params setValue:name forKey:kname];
              [params setValue:li_id forKey:kid];
              [params setValue:email forKey:kemail];
              [params setValue:profession forKey:kprofession];
              [params setValue:pictureUrl forKey:kprofile_image];
              [params setValue:session.accessToken.accessTokenValue forKey:kli_token];
              
          } error:^(LISDKAPIError *apiError)
          {
              NSLog(@"Error : %@", apiError);
          }];
         
     } errorBlock:^(NSError *error)
     {
         NSLog(@"%s","error called!");
     }];
    
}

- (IBAction)restorePurchase:(id)sender {
    self.restorePurchaseBtn.enabled = NO;

    [self.view makeToastActivity];
    [[RageIAPHelper sharedInstance] restoreCompletedTransactions];
}
-(void) getUserFriends{
    UserInfo *userInfo = [UserInfo instance];
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"id,name,email,user_friends" forKey:@"fields"];
    jid = [[NSMutableArray alloc] init];
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me/friends" parameters:parameters]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                  id result, NSError *error) {
         NSLog(@"user uid %@", [userInfo valueForKey:kuu_id]);
         NSMutableArray *friends = [[NSMutableArray alloc]initWithArray:[result valueForKey:@"data"]];
         for (int i = 0; i < [friends count]; i++){
             NSMutableDictionary *friend = [friends objectAtIndex:i];
             NSString *jidStr = [NSString stringWithFormat:@"%@@nea.nearhero.com",[friend valueForKey:kid]];
             [jid addObject:jidStr];
         }
         [self addFriendToRoster];
     }];
}

-(void)addFriendToRoster{
    if([jid count] > 0){
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    UserInfo *userInfo = [UserInfo instance];
    [param setValue:[userInfo valueForKey:kuu_id] forKey:kid];
    [param setValue:jid forKey:kjid];
    GenericFetcher *fetcher = [[GenericFetcher alloc]init];
    
    [fetcher fetchWithUrl:[URLBuilder urlForMethod:kadd_roster withParameters:nil]
               withMethod:POST_REQUEST withParams:param completionBlock:^(NSDictionary *dict) {
                   NSLog(@"%@",dict);
               int status = [[dict valueForKey:kstatus] intValue];
               if (status == 1) {
               }
               else{
                   UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:[dict valueForKey:kerror] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                   [alert show];
                   [self.view hideToastActivity];
               }
           }
           errorBlock:^(NSError *error) {
               [self.view hideToastActivity];
               NSLog(@"no internet");
               NSLog(@"%@",error);
               
           }];
    }
}



-(void)gettingLIConnections{
    _linkedInLoginView = [[OAuthLoginView alloc] init];
    _linkedInLoginView.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self presentViewController:_linkedInLoginView animated:YES completion:nil];
}


#pragma mark iCloud Helper methods
-(void) showRestoreAlert:(NSNotification *) notification{
    [self.view hideToastActivity];
    self.restorePurchaseBtn.enabled = YES;
   // [self dismissViewControllerAnimated:NO completion:nil];
}

-(void)checkSubscription{
    UserSettings *userSettings = [UserSettings instance];
    NSUbiquitousKeyValueStore* store = [NSUbiquitousKeyValueStore
                                        defaultStore];
    if(store){        NSMutableDictionary *appstate = [store objectForKey:kappState];

        if(appstate){
            NSDate *expireDate = [appstate valueForKey:kExpireDate];
            NSDate *c = [NSDate date];
            if ([expireDate compare:c] == NSOrderedDescending) {
                userSettings.isSubscribed = YES;
            } else if ([expireDate compare:[NSDate date]] == NSOrderedAscending) {
                 appstate = nil;
                 [store setObject:appstate forKey:kappState];

                userSettings.isSubscribed = NO;
            } else {
                appstate = nil;
                [store setObject:appstate forKey:kappState];
                userSettings.isSubscribed = NO;
            }
        }
        else{
            appstate = nil;
            [store setObject:appstate forKey:kappState];
            userSettings.isSubscribed = NO;
        }
        [userSettings saveUserSettings];
    }
    

}

-(void)runMethod{
    NSLog(@"data do not exists");
    
    NSUbiquitousKeyValueStore *store = [NSUbiquitousKeyValueStore defaultStore];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary *appState = [[NSMutableDictionary alloc] init];
    
    [appState setValue:[NSDate date] forKey:ksubscriptionDate];
    [appState setValue:[NSString stringWithFormat:@"%d", 365] forKey:kremainingDays];
    
    [defaults setObject:appState forKey:kappState];
    
    if (store) {
        [store setObject:appState forKey:kappState];
    }
    [self.view setUserInteractionEnabled:YES];
}

-(void)storeChanged:(NSNotification*)notification
{
    NSLog(@"keyValueStoreChanged");
    NSNumber *reason = [[notification userInfo] objectForKey:NSUbiquitousKeyValueStoreChangeReasonKey];
    
    if (reason){
        NSInteger reasonValue = [reason integerValue];
        NSLog(@"keyValueStoreChanged with reason %ld", (long)reasonValue);
        
        if (reasonValue == NSUbiquitousKeyValueStoreInitialSyncChange){
            NSLog(@"Initial sync");
            [self checkSubscription];
        }else if (reasonValue == NSUbiquitousKeyValueStoreServerChange){
            NSLog(@"Server change sync");
        }else{
            NSLog(@"Another reason");
        }
    }
}
-(void) sendrequestToOPenfire
{
    
}

@end
