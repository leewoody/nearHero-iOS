

//  AppDelegate.m
//  nearhero
//
//  Created by Dilawer Hussain on 6/2/16.
//  Copyright © 2016 TBoxSolutionz. All rights reserved.
//
#import "Constants.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "IntroViewController.h"
#import "SideMenuViewController.h"
#import "HomeViewController.h"
#import "UserSettings.h"
#import "URLBuilder.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "NSString+MD5.h"


/////////////////////XMPP Integration////////////////////
#import "GCDAsyncSocket.h"
#import "XMPP.h"
#import "XMPPLogging.h"
#import "XMPPReconnect.h"
#import "XMPPCapabilitiesCoreDataStorage.h"
#import "XMPPRosterCoreDataStorage.h"
#import "XMPPvCardAvatarModule.h"
#import "XMPPvCardCoreDataStorage.h"
#import "XMPPvCardTemp.h"
#import "XMPPvCardTempModule.h"
#import "XMPPvCardCoreDataStorage.h"
#import "XMPPMessageDeliveryReceipts.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

//#import "XMPPMessageArchivingCoreDataStorage.h"
#import "UserInfo.h"
#import "DDLog.h"
#import "DDTTYLogger.h"
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <CFNetwork/CFNetwork.h>
#import "XMPPMessage+XEP_0184.h"
//@import UserNotifications;
@import Firebase;
@import GoogleMobileAds;
@import FirebaseInstanceID;
@import FirebaseMessaging;
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif

//constant define...
#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
//end...


#ifndef NSFoundationVersionNumber_iOS_9_x_Max
#define NSFoundationVersionNumber_iOS_9_x_Max 1299
#endif

// Log levels: off, error, warn, info, verbose
#if DEBUG
static const int ddLogLevel = XMPP_LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = XMPP_LOG_LEVEL_INFO;
#endif
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

////////////////////////////////////////////////////////
@interface AppDelegate ()
{
    NSString *myJID;
    NSString *myPassword;
    UserInfo *userInfo;
    NSDictionary *notifiedUser;
    NSMutableArray *timeList;
    //////////////Parser
    NSMutableArray *dataArray;
    NSMutableDictionary *dataDict;
    NSMutableDictionary *subcatDict;
    NSMutableArray *subCatArray;
    NSString *currentElement;
    NSMutableDictionary *body;
    NSMutableArray *messageBodies;
    //for saving user location...
    CLLocation * newLocation;
    NSString *cityName ;
    UNUserNotificationCenter *center;
    NSMutableDictionary *parameters;
    int badgenumber;
    IntroViewController * introViewController;

    
    
}
/////////////////////XMPP Integration///////////////////
- (void)setupStream;
- (void)teardownStream;

- (void)goOnline;
////////////////////////////////////////////////////////

@end

@implementation AppDelegate

///////////////////XMPP Integration/////////////////////
@synthesize xmppStream;
@synthesize xmppReconnect;
@synthesize xmppRoster;
@synthesize xmppRosterStorage;
@synthesize xmppvCardTempModule;
@synthesize xmppvCardAvatarModule;
@synthesize xmppCapabilities;
@synthesize xmppCapabilitiesStorage;

@synthesize window;
@synthesize navigationController;
@synthesize loginButton;
-(void)testLoadContacts{
    dispatch_async(dispatch_get_main_queue(),^{

        [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowContactsOnTable" object:nil];});
}


#pragma mark - network availability
-(BOOL)isNetworkAvailable
{
    Reachability *internetReachable = [Reachability
                                       reachabilityForInternetConnection];
    [internetReachable startNotifier];
    NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
    switch (internetStatus)
    
    {
        case NotReachable:
        {
            return NO;
            break;
        }
        case ReachableViaWiFi:
        {
            return YES;
            break;
            
        }
        case ReachableViaWWAN:
        {
            return YES;
            break;
            
        }
    }
    return NO;
}

-(void)loadContacts{
    [self performSelectorOnMainThread:@selector(testLoadContacts) withObject:nil waitUntilDone:NO];
//    [self performSelector:@selector(testLoadContacts) withObject:nil afterDelay:1];
}
-(void)updateContactStatus{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateContactInviteStatus" object:nil];
}
-(void)updateContactInviteStatus{
    [self performSelectorOnMainThread:@selector(updateContactStatus) withObject:nil waitUntilDone:NO];
}
-(void)loadFeedBacks:(NSDictionary*)obj{
    [self performSelectorOnMainThread:@selector(testLoadFeedBacks:) withObject:obj waitUntilDone:NO];

}
-(void)testLoadFeedBacks:(NSDictionary*)obj{
     [[NSNotificationCenter defaultCenter] postNotificationName:@"updateReviews" object:nil userInfo:obj];

}
///////////////////////////////////////////////////////
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    ///////fcm
   // [FIRApp configure];

    ///////////iCloud
    NSUbiquitousKeyValueStore* store = [NSUbiquitousKeyValueStore
                                        defaultStore];
    if (store) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(storeChanged:)
                                                     name:NSUbiquitousKeyValueStoreDidChangeExternallyNotification
                                                   object:store];
        [store synchronize];
    }
    [RageIAPHelper sharedInstance];
    
    [self addSkipBackupAttributeToItemAtURL:[self applicationDocumentDirectory]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *iCloudURL = [fileManager URLForUbiquityContainerIdentifier:nil];
    NSLog(@"%@", [iCloudURL absoluteString]);
    
    if(iCloudURL){
        NSUbiquitousKeyValueStore *iCloudStore = [NSUbiquitousKeyValueStore defaultStore];
        [iCloudStore setString:kSuccess forKey:kiCloudStatus];
        [iCloudStore synchronize]; // For Synchronizing with iCloud Server
        NSLog(@"iCloud status : %@", [iCloudStore stringForKey:kiCloudStatus]);
    }
    [self loadProducts];
    ////////////////////
    
    
    
    
    NSString *str = [[NSUserDefaults standardUserDefaults] valueForKey:@"HasLaunchedOnce"];
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"HasLaunchedOnce"] == nil)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"HasLaunchedOnce"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        UserSettings *userSetting = [UserSettings instance];
        [userSetting setMessagesFlag:YES];
        [userSetting setShowMeOnMapFlag:YES];
        [userSetting saveUserSettings];
    }
    else{
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"HasLaunchedOnce"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"10.0"))
    {
        
        center = [UNUserNotificationCenter currentNotificationCenter];
        UNAuthorizationOptions options = UNAuthorizationOptionAlert + UNAuthorizationOptionSound + UNAuthorizationOptionBadge;
        [center requestAuthorizationWithOptions:options
                              completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                  if (!error) {
                                      NSLog(@"Something went wrong");
                                      [[UIApplication sharedApplication] registerForRemoteNotifications];

                                  }
                              }];
        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            if (settings.authorizationStatus != UNAuthorizationStatusAuthorized) {
                // Notifications not allowed
            }
        }];
    }
    else
    {
        if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)])
        {
            
            [application registerUserNotificationSettings:[UIUserNotificationSettings
                                                           settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|
                                                           UIUserNotificationTypeSound categories:nil]];
        }
    }
    
   // [launchOptions valueForKey:UIApplicationLaunchOptionsLocalNotificationKey];

    
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    introViewController = [self getController];
    UINavigationController * mainNavCont = [[UINavigationController alloc]initWithRootViewController:introViewController];
    mainNavCont.navigationBarHidden = YES;
    //////////XMPP////////////
    
    [self setupStream];
    //self.xmppMessageArchivingStorage = [NHXMPPMessageArchivingCoreDataStorage sharedInstance];
    self.xmppMessageArchivingStorage = [XMPPMessageArchivingCoreDataStorage sharedInstance];
    
    self.xmppMessageArchivingModule = [[XMPPMessageArchiving alloc] initWithMessageArchivingStorage:self.xmppMessageArchivingStorage];
    [self.xmppMessageArchivingModule setClientSideMessageArchivingOnly:YES];
    
    [self.xmppMessageArchivingModule activate:xmppStream];
    [self.xmppMessageArchivingModule  addDelegate:self delegateQueue:dispatch_get_main_queue()];
    /////////////////////////
    [self.window makeKeyAndVisible];
    [self.window setRootViewController:mainNavCont];
    
    [FIRApp configure];
    
    [GADMobileAds configureWithApplicationID:@"ca-app-pub-8845201596497802~6970384773sendmessa"];

    
    badgenumber = 0;
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_9_x_Max) {
        UIUserNotificationType allNotificationTypes =
        (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings =
        [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    } else {
        // iOS 10 or later
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
        UNAuthorizationOptions authOptions =
        UNAuthorizationOptionAlert
        | UNAuthorizationOptionSound
        | UNAuthorizationOptionBadge;
        [[UNUserNotificationCenter currentNotificationCenter]
         requestAuthorizationWithOptions:authOptions
         completionHandler:^(BOOL granted, NSError * _Nullable error) {
             if( !error ){
                 [[UIApplication sharedApplication] registerForRemoteNotifications];


            
             }
         }
         ];
        
        // For iOS 10 display notification (sent via APNS)
        [[UNUserNotificationCenter currentNotificationCenter] setDelegate:self];
        // For iOS 10 data message (sent via FCM)
        [[FIRMessaging messaging] setRemoteMessageDelegate:self];
#endif
    }
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];

    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];


    
    // Add observer for InstanceID token refresh callback.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tokenRefreshNotification:)
                                                 name:kFIRInstanceIDTokenRefreshNotification object:nil];
    
    [Fabric with:@[[Crashlytics class]]];
    // TODO: Move this to where you establish a user session
 //   [self logUser];

       return YES;

    
}
- (IntroViewController*) getController {

    if (introViewController == nil) {
        IntroViewController *loginVC = [[IntroViewController alloc]initWithNibName:@"IntroViewController" bundle:nil];
        return loginVC;
    }
    return introViewController;
}

- (void) logUser {
    // TODO: Use the current user's information
    // You can call any combination of these three methods
    [CrashlyticsKit setUserIdentifier:@"12345"];
    [CrashlyticsKit setUserEmail:@"user@fabric.io"];
    [CrashlyticsKit setUserName:@"Test User"];
}

-(void)setHomeMenu
{
    UserSettings *userSettings = [UserSettings instance];
    NSUbiquitousKeyValueStore* store = [NSUbiquitousKeyValueStore
                                        defaultStore];
    if(store)
    {
        NSMutableDictionary *appstate = [store objectForKey:kappState];
        if(appstate)
        {
            NSDate *expireDate = [appstate valueForKey:kExpireDate];
            NSDate *c = [NSDate date];
            if ([expireDate compare:c] == NSOrderedDescending) {
                userSettings.isSubscribed = YES;
            } else if ([expireDate compare:[NSDate date]] == NSOrderedAscending) {
                userSettings.isSubscribed = NO;
            } else {
                userSettings.isSubscribed = NO;
            }
        }
        else
        {
            userSettings.isSubscribed = NO;
        }
        [userSettings saveUserSettings];
    }
    


    HomeViewController *viewController = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
    viewController.didUserLoad = true;
    //    NavigationController *navigationController = [[NavigationController alloc] initWithRootViewController:viewController];
    MainViewController *mainViewController = nil;
    
    mainViewController = [[MainViewController alloc] initWithRootViewController:viewController
                                                              presentationStyle:LGSideMenuPresentationStyleSlideAbove
                                                                           type:0];
    
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    
    window.rootViewController = mainViewController;
    
    [UIView transitionWithView:window
                      duration:0.3
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:nil    

                    completion:nil];
}

-(void)setIntroMenu
{
    IntroViewController *viewController = [self getController];
    //    NavigationController *navigationController = [[NavigationController alloc] initWithRootViewController:viewController];
    MainViewController *mainViewController = nil;
    
    mainViewController = [[MainViewController alloc] initWithRootViewController:viewController
                                                              presentationStyle:LGSideMenuPresentationStyleSlideAbove
                                                                           type:0];
    
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    window.rootViewController = mainViewController;
//    
//    [UIView transitionWithView:window
//                      duration:0.3
//                       options:UIViewAnimationOptionTransitionCrossDissolve
//                    animations:nil
//                    completion:nil];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];

    UserInfo *userInfo = [UserInfo instance];
    UserSettings *userSettings = [UserSettings instance];
    if(userInfo.isLogin && userSettings.showMeOnMapFlag){
        [self updateUserLocation];
        
    }
    [self.window endEditing:YES];
    [[FIRMessaging messaging] disconnect];


}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  //  [[UIApplication sharedApplication] cancelAllLocalNotifications];

    badgenumber = 0;
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];

    [[NSNotificationCenter defaultCenter] postNotificationName:kcheckSubscription object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:kkreloadLocationAnnotationOnMap object:nil];
}

//- (void)applicationapplicationIconBadgeNumberActive:(UIApplication *)application {
//    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//    badgenumber = 0;
//    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
//    UserInfo *userInfo = [UserInfo instance];
//    UserSettings *userSettings = [UserSettings instance];
//    if(userInfo.isLogin && userSettings.showMeOnMapFlag){
//        [self updateUserLocation];
//    }
//   [self connectToFcm];
//    [FBSDKAppEvents activateApp];
//
//}
- (void)applicationDidBecomeActive:(UIApplication *)application{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
        UserInfo *userInfo = [UserInfo instance];
        UserSettings *userSettings = [UserSettings instance];
        if(userInfo.isLogin && userSettings.showMeOnMapFlag){
            [self updateUserLocation];
        }
       [self connectToFcm];
        [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self disconnect];
    [self teardownStream];

}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    if ([LISDKCallbackHandler shouldHandleUrl:url]) {
        return [LISDKCallbackHandler application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    }
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

//******************************************************//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Core Data
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSManagedObjectContext *)managedObjectContext_roster
{
    return [xmppRosterStorage mainThreadManagedObjectContext];
}

- (NSManagedObjectContext *)managedObjectContext_capabilities
{
    return [xmppCapabilitiesStorage mainThreadManagedObjectContext];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Private
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)setupStream
{
    NSAssert(xmppStream == nil, @"Method setupStream invoked multiple times");
    
    // Setup xmpp stream
    //
    // The XMPPStream is the base class for all activity.
    // Everything else plugs into the xmppStream, such as modules/extensions and delegates.
    
    xmppStream = [[XMPPStream alloc] init];
    
#if !TARGET_IPHONE_SIMULATOR
    {
        // Want xmpp to run in the background?
        //
        // P.S. - The simulator doesn't support backgrounding yet.
        //        When you try to set the associated property on the simulator, it simply fails.
        //        And when you background an app on the simulator,
        //        it just queues network traffic til the app is foregrounded again.
        //        We are patiently waiting for a fix from Apple.
        //        If you do enableBackgroundingOnSocket on the simulator,
        //        you will simply see an error message from the xmpp stack when it fails to set the property.
        xmppStream.enableBackgroundingOnSocket = YES;

        
    }
#endif
    
    // Setup reconnect
    //
    // The XMPPReconnect module monitors for "accidental disconnections" and
    // automatically reconnects the stream for you.
    // There's a bunch more information in the XMPPReconnect header file.
    
    xmppReconnect = [[XMPPReconnect alloc] init];
    // Setup roster
    //
    // The XMPPRoster handles the xmpp protocol stuff related to the roster.
    // The storage for the roster is abstracted.
    // So you can use any storage mechanism you want.
    // You can store it all in memory, or use core data and store it on disk, or use core data with an in-memory store,
    // or setup your own using raw SQLite, or create your own storage mechanism.
    // You can do it however you like! It's your application.
    // But you do need to provide the roster with some storage facility.
    
    xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] init];
    //	xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] initWithInMemoryStore];
    
    xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:xmppRosterStorage];
    
    xmppRoster.autoFetchRoster = YES;
    xmppRoster.autoAcceptKnownPresenceSubscriptionRequests = YES;
    
    // Setup vCard support
    //
    // The vCard Avatar module works in conjuction with the standard vCard Temp module to download user avatars.
    // The XMPPRoster will automatically integrate with XMPPvCardAvatarModule to cache roster photos in the roster.
    
    xmppvCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
    xmppvCardTempModule = [[XMPPvCardTempModule alloc] initWithvCardStorage:xmppvCardStorage];
    
    xmppvCardAvatarModule = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:xmppvCardTempModule];
    
    // Setup capabilities
    //
    // The XMPPCapabilities module handles all the complex hashing of the caps protocol (XEP-0115).
    // Basically, when other clients broadcast their presence on the network
    // they include information about what capabilities their client supports (audio, video, file transfer, etc).
    // But as you can imagine, this list starts to get pretty big.
    // This is where the hashing stuff comes into play.
    // Most people running the same version of the same client are going to have the same list of capabilities.
    // So the protocol defines a standardized way to hash the list of capabilities.
    // Clients then broadcast the tiny hash instead of the big list.
    // The XMPPCapabilities protocol automatically handles figuring out what these hashes mean,
    // and also persistently storing the hashes so lookups aren't needed in the future.
    //
    // Similarly to the roster, the storage of the module is abstracted.
    // You are strongly encouraged to persist caps information across sessions.
    //
    // The XMPPCapabilitiesCoreDataStorage is an ideal solution.
    // It can also be shared amongst multiple streams to further reduce hash lookups.
    
    xmppCapabilitiesStorage = [XMPPCapabilitiesCoreDataStorage sharedInstance];
    xmppCapabilities = [[XMPPCapabilities alloc] initWithCapabilitiesStorage:xmppCapabilitiesStorage];
    
    xmppCapabilities.autoFetchHashedCapabilities = YES;
    xmppCapabilities.autoFetchNonHashedCapabilities = NO;
    
    // Activate xmpp modules
    
    [xmppReconnect         activate:xmppStream];
    [xmppRoster            activate:xmppStream];
    [xmppvCardTempModule   activate:xmppStream];
    [xmppvCardAvatarModule activate:xmppStream];
    [xmppCapabilities      activate:xmppStream];
    
    // Add ourself as a delegate to anything we may be interested in
    
    [xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    // Optional:
    //
    // Replace me with the proper domain and port.
    // The example below is setup for a typical google talk account.
    //
    // If you don't supply a hostName, then it will be automatically resolved using the JID (below).
    // For example, if you supply a JID like 'user@quack.com/rsrc'
    // then the xmpp framework will follow the xmpp specification, and do a SRV lookup for quack.com.
    //
    // If you don't specify a hostPort, then the default (5222) will be used.
    
    [xmppStream setHostName:SERVER_ADDRESS];
    [xmppStream setHostPort:5222];
    
    
    // You may need to alter these settings depending on the server you're connecting to
    customCertEvaluation = YES;
}

- (void)teardownStream
{
    [xmppStream removeDelegate:self];
    [xmppRoster removeDelegate:self];
    
    [xmppReconnect         deactivate];
    [xmppRoster            deactivate];
    [xmppvCardTempModule   deactivate];
    [xmppvCardAvatarModule deactivate];
    [xmppCapabilities      deactivate];
    
    [xmppStream disconnect];
    
    xmppStream = nil;
    xmppReconnect = nil;
    xmppRoster = nil;
    xmppRosterStorage = nil;
    xmppvCardStorage = nil;
    xmppvCardTempModule = nil;
    xmppvCardAvatarModule = nil;
    xmppCapabilities = nil;
    xmppCapabilitiesStorage = nil;
}

// It's easy to create XML elments to send and to read received XML elements.
// You have the entire NSXMLElement and NSXMLNode API's.
//
// In addition to this, the NSXMLElement+XMPP category provides some very handy methods for working with XMPP.
//
// On the iPhone, Apple chose not to include the full NSXML suite.
// No problem - we use the KissXML library as a drop in replacement.
//
// For more information on working with XML elements, see the Wiki article:
// https://github.com/robbiehanson/XMPPFramework/wiki/WorkingWithElements

- (void)goOnline
{
    XMPPPresence *presence = [XMPPPresence presence]; // type="available" is implicit
    
    NSString *domain = [xmppStream.myJID domain];
    
    //Google set their presence priority to 24, so we do the same to be compatible.
    
    if([domain isEqualToString:@"gmail.com"]
       || [domain isEqualToString:@"gtalk.com"]
       || [domain isEqualToString:@"talk.google.com" ]
       || [domain isEqualToString:SERVER_ADDRESS])
    {
        NSXMLElement *priority = [NSXMLElement elementWithName:@"priority" stringValue:@"24"];
        [presence addChild:priority];
    }
    
    [[self xmppStream] sendElement:presence];

    [self sendNotifications];
    
}

- (void)goOffline
{
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    
    [[self xmppStream] sendElement:presence];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Connect/disconnect
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)connect
{
   
    if (![xmppStream isDisconnected]) {
        self.xmppStream.enableBackgroundingOnSocket = YES;

        return YES;
    }
    
//#if !TARGET_IPHONE_SIMULATOR
//    {
//        self.xmppStream.enableBackgroundingOnSocket = YES;
//    }
//#endif
    UserInfo *userInfo = [UserInfo instance];
    myJID = [userInfo valueForKey:kuu_id];
    myPassword = [userInfo valueForKey:kjidPassword];
    
    
    //
    // If you don't want to use the Settings view to set the JID,
    // uncomment the section below to hard code a JID and password.
    //
    // myJID = @"user@gmail.com/xmppframework";
    // myPassword = @"";
    
    if (myJID == nil || myPassword == nil) {
        return NO;
    }
    
    //[xmppStream setMyJID:[XMPPJID jidWithString:myJID]];
    
    
    [xmppStream setMyJID:[XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@",myJID,SERVER_ADDRESS]]];
    
    password = myPassword;
    
    NSError *error = nil;
    if (![xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error connecting"
                                                            message:@"See console for error details."
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        
        DDLogError(@"Error connecting: %@", error);
        
        return NO;
    }
    self.xmppStream.enableBackgroundingOnSocket = YES;
    XMPPMessageDeliveryReceipts* xmppMessageDeliveryRecipts = [[XMPPMessageDeliveryReceipts alloc] initWithDispatchQueue:dispatch_get_main_queue()];
    xmppMessageDeliveryRecipts.autoSendMessageDeliveryReceipts = YES;
    xmppMessageDeliveryRecipts.autoSendMessageDeliveryRequests = YES;
    [xmppMessageDeliveryRecipts activate:self.xmppStream];
    return YES;

}

- (void)disconnect
{
    [self goOffline];
    [xmppStream disconnect];
    
}



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark XMPPStream Delegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)xmppStream:(XMPPStream *)sender socketDidConnect:(GCDAsyncSocket *)socket
{
    
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    [socket performBlock:^{
        [socket enableBackgroundingOnSocket];
    }];
}

- (void)xmppStream:(XMPPStream *)sender willSecureWithSettings:(NSMutableDictionary *)settings
{
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
    NSString *expectedCertName = [xmppStream.myJID domain];
    if (expectedCertName)
    {
        settings[(NSString *) kCFStreamSSLPeerName] = expectedCertName;
    }
    
    if (customCertEvaluation)
    {
        settings[GCDAsyncSocketManuallyEvaluateTrust] = @(YES);
    }
}

/**
 * Allows a delegate to hook into the TLS handshake and manually validate the peer it's connecting to.
 *
 * This is only called if the stream is secured with settings that include:
 * - GCDAsyncSocketManuallyEvaluateTrust == YES
 * That is, if a delegate implements xmppStream:willSecureWithSettings:, and plugs in that key/value pair.
 *
 * Thus this delegate method is forwarding the TLS evaluation callback from the underlying GCDAsyncSocket.
 *
 * Typically the delegate will use SecTrustEvaluate (and related functions) to properly validate the peer.
 *
 * Note from Apple's documentation:
 *   Because [SecTrustEvaluate] might look on the network for certificates in the certificate chain,
 *   [it] might block while attempting network access. You should never call it from your main thread;
 *   call it only from within a function running on a dispatch queue or on a separate thread.
 *
 * This is why this method uses a completionHandler block rather than a normal return value.
 * The idea is that you should be performing SecTrustEvaluate on a background thread.
 * The completionHandler block is thread-safe, and may be invoked from a background queue/thread.
 * It is safe to invoke the completionHandler block even if the socket has been closed.
 *
 * Keep in mind that you can do all kinds of cool stuff here.
 * For example:
 *
 * If your development server is using a self-signed certificate,
 * then you could embed info about the self-signed cert within your app, and use this callback to ensure that
 * you're actually connecting to the expected dev server.
 *
 * Also, you could present certificates that don't pass SecTrustEvaluate to the client.
 * That is, if SecTrustEvaluate comes back with problems, you could invoke the completionHandler with NO,
 * and then ask the client if the cert can be trusted. This is similar to how most browsers act.
 *
 * Generally, only one delegate should implement this method.
 * However, if multiple delegates implement this method, then the first to invoke the completionHandler "wins".
 * And subsequent invocations of the completionHandler are ignored.
 **/
- (void)xmppStream:(XMPPStream *)sender didReceiveTrust:(SecTrustRef)trust
 completionHandler:(void (^)(BOOL shouldTrustPeer))completionHandler
{
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
    // The delegate method should likely have code similar to this,
    // but will presumably perform some extra security code stuff.
    // For example, allowing a specific self-signed certificate that is known to the app.
    
    dispatch_queue_t bgQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(bgQueue, ^{
        
        SecTrustResultType result = kSecTrustResultDeny;
        OSStatus status = SecTrustEvaluate(trust, &result);
        
        if (status == noErr && (result == kSecTrustResultProceed || result == kSecTrustResultUnspecified)) {
            completionHandler(YES);
        }
        else {
            completionHandler(NO);
        }
    });
}

- (void)xmppStreamDidSecure:(XMPPStream *)sender
{
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
    isXmppConnected = YES;
    self.isConnectedToOF = YES;
    
    NSError *error = nil;
    
    if (![[self xmppStream] authenticateWithPassword:password error:&error])
    {
        DDLogError(@"Error authenticating: %@", error);
    }
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    [self createVcard];
    [self goOnline];


}
- (void) createVcard{
    if ([xmppStream isAuthenticated]) {
        NSLog(@"authenticated");
        dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_PRIORITY_DEFAULT);
        dispatch_async(queue, ^{
            
            //            XMPPvCardCoreDataStorage * xmppvCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
            //            XMPPvCardTempModule * xmppvCardTempModule = [[XMPPvCardTempModule alloc] initWithvCardStorage:xmppvCardStorage];
            [xmppvCardTempModule  activate:[self xmppStream]];
            userInfo = [UserInfo instance];
            XMPPvCardTemp *myVcardTemp = [xmppvCardTempModule myvCardTemp];
            
            if (!myVcardTemp) {
                NSLog(@"TEST FOR VCARD");
                
                NSXMLElement *vCardXML = [NSXMLElement elementWithName:@"vCard" xmlns:@"vcard-temp"];
                XMPPvCardTemp *newvCardTemp = [XMPPvCardTemp vCardTempFromElement:vCardXML];
                NSXMLElement *name = [NSXMLElement elementWithName:kname stringValue:[userInfo valueForKey:kname]];
                NSXMLElement *email = [NSXMLElement elementWithName:kemail stringValue:[userInfo valueForKey:kemailAddress]];
                NSXMLElement *imageURL = [NSXMLElement elementWithName:kprofile_image stringValue:[userInfo valueForKey:kImageUrl]];
                [vCardXML addChild:imageURL];
                [vCardXML addChild:name];
                [vCardXML addChild:email];
                [xmppvCardTempModule updateMyvCardTemp:newvCardTemp];
            }else{
                //Set Values as normal
                NSXMLElement *vCardXML = [NSXMLElement elementWithName:@"vCard" xmlns:@"vcard-temp"];
                NSXMLElement *name = [NSXMLElement elementWithName:kname stringValue:[userInfo valueForKey:kname]];
                NSXMLElement *email = [NSXMLElement elementWithName:kemail stringValue:[userInfo valueForKey:kemailAddress]];
                NSXMLElement *imageURL = [NSXMLElement elementWithName:kprofile_image stringValue:[userInfo valueForKey:kImageUrl]];
                [vCardXML addChild:imageURL];
                [vCardXML addChild:name];
                [vCardXML addChild:email];
                XMPPvCardTemp *newvCardTemp = [XMPPvCardTemp vCardTempFromElement:vCardXML];
                [xmppvCardTempModule updateMyvCardTemp:newvCardTemp];
                
            }
            
        });
    }
    
    
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error
{
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq
{
    
    NSString *s = [[NSUserDefaults standardUserDefaults] valueForKey:@"HasLaunchedOnce"];
        DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
        NSXMLElement *queryElement = [iq elementForName: @"list" xmlns: @"urn:xmpp:archive"];
        NSXMLElement *chatQueryElement = [iq elementForName: @"chat" xmlns: @"urn:xmpp:archive"];
        NSXMLElement *rosterElement = [iq elementForName:@"query" xmlns: @"jabber:iq:roster"];
    int timestampId;
    NSMutableDictionary *msg = [[NSMutableDictionary alloc] init];
    
        if(rosterElement)
        {
            
            if (!isLoadingUserMessages) {
                _userRosterList = [self loadUserRoster:rosterElement];
                
                if (_userRosterList.count) {
                    isLoadingUserMessages=YES;
                    currentRosterIndex=0;
                    [self getTimeStampFor:[_userRosterList objectAtIndex:currentRosterIndex]];
                }
            }
            
            //else
            //{
              //      [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
                //    [[NSUserDefaults standardUserDefaults] synchronize];
            //}
           
        }
        else if (queryElement)
        {
            
//                NSXMLElement *set = [queryElement elementForName:@"set" xmlns: @"http://jabber.org/protocol/rsm"];
                timeStamps = [[NSMutableArray alloc]initWithArray:[queryElement elementsForName: @"chat"]];
            if([timeStamps count] == 0){
                
                    currentRosterIndex++;
                    
                    if (currentRosterIndex<_userRosterList.count) {
                        [self getTimeStampFor:[_userRosterList objectAtIndex:currentRosterIndex]];
                    }
                    else{
                        isLoadingUserMessages=false;
                    }
            }
            else{
                for (int i=0; i<[timeStamps count]; i++)
                {
                        NSString *timeStamp=[[[timeStamps objectAtIndex:i] attributeForName:@"start"] stringValue];
                        [self getMessagesFromServerForRoster:[_userRosterList objectAtIndex:currentRosterIndex] andForTimestamp:timeStamp forTimeStampIndex:i];
                }
            }
            
        }
        else if(chatQueryElement)
        {
           


                NSXMLElement *set = [chatQueryElement elementForName:@"set" xmlns: @"http://jabber.org/protocol/rsm"];
               // NSArray *messagesFrom = [chatQueryElement elementsForName:@"from"];
               // NSArray *messagesTo = [chatQueryElement elementsForName:@"to"];
                NSString *time = [[chatQueryElement attributeForName:@"start"] stringValue];
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
            [dateFormat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
            NSDate *date=[dateFormat dateFromString:[NSString stringWithFormat:@"%@",time]];
                NSString *chatPartner = [[chatQueryElement attributeForName:@"with"] stringValue];
               // NSDate *date = [self timeZoneConversionToUTC:time];
                int index = [[[iq attributeForName:@"id"] stringValue] integerValue];

                 timestampId = [[[iq attributeForName:@"id"] stringValue] integerValue];
            dataDict = nil;
            messageBodies = nil;
            subcatDict = nil;
            subCatArray = nil;
                NSXMLNode *xmlNode = (NSXMLNode*)chatQueryElement;
                NSString* string = [xmlNode XMLStringWithOptions:NSXMLNodePrettyPrint];

                NSData* xmlData = [string dataUsingEncoding:NSUTF8StringEncoding];

                NSXMLParser *parser = [[NSXMLParser alloc] initWithData:xmlData];
                parser.delegate = self;
                [parser parse];
                //NSMutableDictionary *msg = [[NSMutableDictionary alloc] init];

                NSArray *_messageBodies  = [[NSArray alloc ] initWithArray:messageBodies ];
                NSArray *_array = [[NSArray alloc] initWithArray:subCatArray];
                NSDate* newDate = [[NSDate alloc]init];
                newDate = date;
                for (int i = 0; i < _array.count; i++) {
                    
                    [msg removeAllObjects];
                    msg = [[NSMutableDictionary alloc] init];
                        NSMutableDictionary *dict = [_array objectAtIndex:i];
                        float secs = [[dict valueForKey:@"secs"]floatValue];
                        newDate = [newDate dateByAddingTimeInterval:secs];
                    
                        NSString *jid = [dict valueForKey:kjid];
                        if(jid == nil)
                        {
                                [msg setValue:@"1" forKey:@"outgoing"];
                        }
                        else
                        {
                                [msg setValue:@"0" forKey:@"outgoing"];
                        }
                        [msg setValue:chatPartner forKey:kchatPartner];
                        [msg setValue:[_messageBodies objectAtIndex:i] forKey:@"body"];
                        [msg setValue:newDate forKey:@"timestamp"];
                   // [self performSelectorOnMainThread:@selector(insertMessagesInXMPP:) withObject:msg waitUntilDone:NO];
                   // dispatch_async(dispatch_get_main_queue(), ^{

                        [self insertMessagesInXMPP:msg];//});
                        NSLog(@"Hello");
                }

            if ((timeStamps.count-1)<=timestampId) {
              //  [self performSelectorOnMainThread:@selector(insertLatestMessagesInXMPP:) withObject:msg waitUntilDone:NO];
              //  dispatch_async(dispatch_get_main_queue(), ^{

                [self insertLatestMessagesInXMPP:msg];
                //});
                currentRosterIndex++;
                
                if (currentRosterIndex<_userRosterList.count) {
                    [self getTimeStampFor:[_userRosterList objectAtIndex:currentRosterIndex]];
                }else{
                    isLoadingUserMessages=false;
                }
                
            }

                        
        }
    
    
    return YES;

}
-(void)sendMessage:(NSString*)messageStr:(NSString*)receiver;
{
    if([messageStr length] > 0)
    {
        UserInfo *userInfo = [UserInfo instance];
        parameters = [[NSMutableDictionary alloc] init];
        [parameters setValue:userInfo.apiKey forKey:kapi_key];
        [parameters setValue:userInfo.name forKey:kntitle];
        [parameters setValue:messageStr forKey:kmsg_body];
        [parameters setValue:receiver forKey:kid];


            NSString *messageID=[xmppStream generateUUID];

        
            NSDateFormatter *formatter = [NSDateFormatter new];
            [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
        
        // Add this part to your code
            NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
            [formatter setTimeZone:timeZone];
        
            NSDate *now = [NSDate date];
            NSString *dateAsString = [formatter stringFromDate:now];
        /////MD5 encryption
            NSString *myString = [NSString stringWithFormat:@"%@%@",userInfo.uu_id,dateAsString];
            NSString *md5 = [myString MD5String];
        
            NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
            [body setStringValue:[NSString stringWithFormat:@"%@%@",messageStr,md5]];
            NSXMLElement *timestamp = [NSXMLElement elementWithName:@"timestamp"];
            [timestamp setStringValue:dateAsString];
            NSXMLElement *messageSender = [NSXMLElement elementWithName:@"sender"];
            [messageSender setStringValue:[NSString stringWithFormat:@"%@@%@",userInfo.uu_id,SERVER_DOMAIN]];

        
            NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
            [message addAttributeWithName:@"type" stringValue:@"chat"];
            [message addAttributeWithName:@"id" stringValue:messageID];
            [message addAttributeWithName:@"from" stringValue:[NSString stringWithFormat:@"%@@%@",userInfo.uu_id,SERVER_DOMAIN]];

            [message addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"%@@%@",receiver,SERVER_DOMAIN]];

            NSXMLElement *msgId = [NSXMLElement elementWithName:@"id"];
            [msgId setStringValue:messageID];        
            [message addChild:body];
            [message addChild:messageSender];
            [message addChild:timestamp];
            [message addChild:msgId];
            [self.xmppStream sendElement:message];
            [self  sendOfflineMsgNotification];
            [self sendNotifications];

        

      }
}
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    
    if([message elementForName:@"received"] != nil){
        NSXMLElement *received =[message elementForName:@"received"];
        NSString *msgId = [[received attributeForName:@"id"] stringValue];
       // [self performSelectorOnMainThread:@selector(updateMessageDeliveryStatus:) withObject:msgId waitUntilDone:NO];

        [self updateMessageDeliveryStatus:msgId];
        return;
        
    }
    
    
       DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
        UserInfo *userInfo = [UserInfo instance];
        if ([message isChatMessageWithBody])
        {
            XMPPUserCoreDataStorageObject *user = [xmppRosterStorage userForJID:[message from]
                                                                     xmppStream:xmppStream
                                                           managedObjectContext:[self managedObjectContext_roster]];
            
            NSString *fullbody = [[message elementForName:@"body"] stringValue];
            NSString *body = [fullbody substringToIndex:[fullbody length]-32];
            NSString *chatPartner = [[message elementForName:@"sender"]stringValue];
            //[[message attributeForName:@"from"] stringValue];
            NSString *time = [[message elementForName:@"timestamp"]stringValue];
            NSString *date = [[message elementForName:@"date"] stringValue];
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"dd-MM-yyyy"];
            NSDate *_date = [dateFormat dateFromString:date];
    
            

          //  NSString *displayName = [user displayName];
            
            
            if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive)
            {                
                    NSMutableDictionary *chatMsg = [[NSMutableDictionary alloc] init];
                    [chatMsg setValue:body forKey:@"sms"];
                    [chatMsg setValue:chatPartner forKey:kchatPartner];
                    //[chatMsg setValue:time forKey:ktime];
                dispatch_async(dispatch_get_main_queue(),^{

                    [[NSNotificationCenter defaultCenter] postNotificationName:@"myNotification" object:nil userInfo:chatMsg];});
                
            }
            else
            {
                    UserSettings *userSettings = [UserSettings instance];
                    // We are not active, so use a local notification instead
                    if(userSettings.messagesFlag)
                    {
                        

                        
                            XMPPJID *msgFrom  =  [XMPPJID jidWithString:chatPartner];
                            XMPPvCardTemp *vCard =[self.xmppvCardTempModule vCardTempForJID:msgFrom shouldFetch:YES];
                        
                        
                    }

            }
            [self sendNotifications];

       }
        
    
   
}
- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence
{
    DDLogVerbose(@"%@: %@ - %@", THIS_FILE, THIS_METHOD, [presence fromStr]);
    NSString *presenceType = [presence type]; // online/offline
    NSString *myUsername = [[sender myJID] user];
    NSString *presenceFromUser = [[presence from] user];
    
    
    if (![presenceFromUser isEqualToString:myUsername]) {
        
        if ([presenceType isEqualToString:@"available"]) {
                [chatDelegate newBuddyOnline:[NSString stringWithFormat:@"%@@%@", presenceFromUser, @"nea.nearhero.com"]];
            
        } else if ([presenceType isEqualToString:@"unavailable"]) {
            
                [chatDelegate buddyWentOffline:[NSString stringWithFormat:@"%@@%@", presenceFromUser, @"nea.nearhero.com"]];
            
        }
        
    }
    
}


- (void)xmppStream:(XMPPStream *)sender didReceiveError:(id)error
{
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
    
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
    if (!isXmppConnected)
    {
        DDLogError(@"Unable to connect to server. Check xmppStream.hostName");
    }
    [self.xmppReconnect activate:self.xmppStream];
    [self.xmppReconnect addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark XMPPRosterDelegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence{
    [sender acceptPresenceSubscriptionRequestFrom:[presence from] andAddToRoster:YES];
}

- (void)xmppRoster:(XMPPRoster *)sender didReceiveBuddyRequest:(XMPPPresence *)presence
{
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
    XMPPUserCoreDataStorageObject *user = [xmppRosterStorage userForJID:[presence from]
                                                             xmppStream:xmppStream
                                                   managedObjectContext:[self managedObjectContext_roster]];
    
    NSString *displayName = [user displayName];
    NSString *jidStrBare = [presence fromStr];
    NSString *body = nil;
    
    if (![displayName isEqualToString:jidStrBare])
    {
        body = [NSString stringWithFormat:@"Buddy request from %@ <%@>", displayName, jidStrBare];
    }
    else
    {
        body = [NSString stringWithFormat:@"Buddy request from %@", displayName];
    }
    
    
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:displayName
                                                            message:body
                                                           delegate:nil
                                                  cancelButtonTitle:@"Not implemented"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
    else
    {
        // We are not active, so use a local notification instead
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.alertAction = @"Not implemented";
        localNotification.alertBody = body;
        
        [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
    }
    
}
- (void)xmppReconnect:(XMPPReconnect *)sender didDetectAccidentalDisconnect:(SCNetworkReachabilityFlags)connectionFlags
{
    NSLog(@"didDetectAccidentalDisconnect:%u",connectionFlags);
}
- (BOOL)xmppReconnect:(XMPPReconnect *)sender shouldAttemptAutoReconnect:(SCNetworkReachabilityFlags)reachabilityFlags
{
    NSLog(@"shouldAttemptAutoReconnect:%u",reachabilityFlags);
    return YES;
}
-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{


    
}




#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
-(NSManagedObjectContext *)managedObjectContext {
    
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel {
    
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    
    managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    return managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"app.sqlite"];
    
    NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return persistentStoreCoordinator;
}


/////////get chat history from openfire
-(void)sendNotifications
{

        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshTable" object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadLatestMessages" object:nil userInfo:nil];
}
-(void)insertMessagesInXMPP:(NSMutableDictionary*)msg
{
    static NSString *fetchRequest = @"fetchRequest";
    @synchronized (fetchRequest){
    NSDate *time = (NSDate *)[msg valueForKey:@"timestamp"];
    NSMutableDictionary *body = [msg valueForKey:@"body"];
    NSString *encryptedId = [[body valueForKey:@"body"] substringFromIndex: [[body valueForKey:@"body"] length] - 32];

    XMPPMessageArchivingCoreDataStorage *storage = [XMPPMessageArchivingCoreDataStorage sharedInstance];
    NSManagedObjectContext *moc = [storage mainThreadManagedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Message_CoreDataObject"
                                                         inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSSortDescriptor *sd1 = [[NSSortDescriptor alloc] initWithKey:@"encryptedId" ascending:NO];
    
    NSString *predicateFrmt = @"encryptedId == %@"; //AND body == %@";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFrmt,encryptedId];//, [msg valueForKey:@"body"]];
    request.predicate = predicate;
    NSArray *sortDescriptors = @[sd1];    [request setSortDescriptors:sortDescriptors];
    
    [request setEntity:entityDescription];
   __block NSError *error;
   __block  NSArray *messages_arc;
        [moc performBlockAndWait:^{

    messages_arc = [moc executeFetchRequest:request error:&error];
        }];
    if([messages_arc count] == 0)
    {
        XMPPMessageArchiving_Message_CoreDataObject *message = [NSEntityDescription insertNewObjectForEntityForName:@"XMPPMessageArchiving_Message_CoreDataObject"
                                                                                             inManagedObjectContext:moc];
        message.bareJid = [XMPPJID jidWithString:[msg valueForKey:kchatPartner]];
        message.bareJidStr = [msg valueForKey:kchatPartner];
        message.body = [[body valueForKey:@"body"] substringToIndex:[[body valueForKey:@"body"] length] - 32];
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        f.numberStyle = NSNumberFormatterDecimalStyle;
        message.outgoing = [f numberFromString:[msg valueForKey:@"outgoing"]];
        message.streamBareJidStr = [NSString stringWithFormat:@"%@@%@",myJID,@"nea.nearhero.com"];
        message.timestamp = time;
        message.isDelivered = YES;
        message.encryptedId = encryptedId;
        __block NSError *error;
        [moc performBlockAndWait:^{

        if (![moc save:&error]) {
            NSLog(@"Failed to save - error: %@", [error localizedDescription]);
        }
        }];
    }
    else
    {
        XMPPMessageArchiving_Message_CoreDataObject *obj = [messages_arc lastObject];
        if(obj != nil){
            obj.isDelivered=YES;
            [moc performBlockAndWait:^{

            if (![moc save:&error]) {
                NSLog(@"Failed to save - error: %@", [error localizedDescription]);
            }
            }];
        }
    }
    }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"messageIsDelivered" object:nil userInfo:nil];

}
- (void)updateMessageDeliveryStatus:(NSString*)msgId{
    static NSString *fetchRequest = @"fetchRequest";
 //   @synchronized (fetchRequest){

    XMPPMessageArchivingCoreDataStorage *storage = [XMPPMessageArchivingCoreDataStorage sharedInstance];
    NSManagedObjectContext *moc = [storage mainThreadManagedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Message_CoreDataObject"
                                                         inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    
    NSString *predicateFrmt = @"msgId like %@ ";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFrmt,msgId];
    request.predicate = predicate;
    
    [request setEntity:entityDescription];
   __block NSError *error;
     __block   XMPPMessageArchiving_Message_CoreDataObject *obj;
        [moc performBlockAndWait:^{

            obj = [[moc executeFetchRequest:request error:&error] lastObject];}];
            
    if(obj != nil){
        obj.isDelivered=YES;
        [moc performBlockAndWait:^{

        if (![moc save:&error]) {
            NSLog(@"Failed to save - error: %@", [error localizedDescription]);
        }}];
 //   }
    }

        [[NSNotificationCenter defaultCenter] postNotificationName:@"messageIsDelivered" object:nil userInfo:nil];
}
-(void)insertLatestMessagesInXMPP:(NSMutableDictionary*)msg
{

    static NSString *fetchRequest = @"fetchRequest";
   // @synchronized (fetchRequest){

    XMPPMessageArchivingCoreDataStorage *storage = [XMPPMessageArchivingCoreDataStorage sharedInstance];
    NSManagedObjectContext *moc = [storage mainThreadManagedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Contact_CoreDataObject"
                                                         inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    
    NSString *predicateFrmt = @"bareJidStr like %@ ";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFrmt,[msg valueForKey:kchatPartner]];
    request.predicate = predicate;

    [request setEntity:entityDescription];
   __block NSError *error;
    __block NSArray *messages_arc;
    [moc performBlockAndWait:^{

    messages_arc = [moc executeFetchRequest:request error:&error];
    }];
    if([messages_arc count] == 0)
    {
        XMPPMessageArchiving_Contact_CoreDataObject *message = [NSEntityDescription insertNewObjectForEntityForName:@"XMPPMessageArchiving_Contact_CoreDataObject"
                                                                                             inManagedObjectContext:moc];
        message.bareJid = [XMPPJID jidWithString:[msg valueForKey:kchatPartner]];
        NSMutableDictionary *body =     [msg valueForKey:@"body"];
        message.bareJidStr = [msg valueForKey:kchatPartner];
        message.mostRecentMessageBody =  [[body valueForKey:@"body"] substringToIndex:[[body valueForKey:@"body"] length] - 32];
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        f.numberStyle = NSNumberFormatterDecimalStyle;
        message.mostRecentMessageOutgoing = [f numberFromString:[msg valueForKey:@"outgoing"]];
        message.streamBareJidStr = [NSString stringWithFormat:@"%@@%@",myJID,@"nea.nearhero.com"];
        message.mostRecentMessageTimestamp = [msg valueForKey:@"timestamp"];
       __block NSError *error;
        [moc performBlockAndWait:^{

        if (![moc save:&error]) {
            NSLog(@"Failed to save - error: %@", [error localizedDescription]);
        }}];
    }else{
        XMPPMessageArchiving_Contact_CoreDataObject *obj = [[moc executeFetchRequest:request error:&error] lastObject];
        if(obj != nil){
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
            [dateFormat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];

            NSDate *date1= obj.mostRecentMessageTimestamp;
            NSString *s = [msg valueForKey:@"timestamp"];
            NSDate *date2 =[msg valueForKey:@"timestamp"];
            NSComparisonResult result = [date1 compare:date2];
            if(result == NSOrderedAscending)
            {
                NSLog(@"date1 is later than date2");
                NSMutableDictionary *body =  [msg valueForKey:@"body"];
                obj.mostRecentMessageBody=[[body valueForKey:@"body"] substringToIndex:[[body valueForKey:@"body"] length] - 32];;
                obj.mostRecentMessageTimestamp = [msg valueForKey:@"timestamp"];
            }
            
            [moc performBlockAndWait:^{

           
            if (![moc save:&error]) {
                NSLog(@"Failed to save - error: %@", [error localizedDescription]);
            }
            }];
        }

    }
 //   [self sendNotifications];
    
    
}
-(void)getTimeStampFor:(NSString*)roster
{
    
        NSXMLElement *iq1 = [NSXMLElement elementWithName:@"iq"];
        [iq1 addAttributeWithName:@"type" stringValue:@"get"];
        [iq1 addAttributeWithName:@"id" stringValue:@"pk1"];
        
        NSXMLElement *list = [NSXMLElement elementWithName:@"list"];
        [list addAttributeWithName:@"xmlns" stringValue:@"urn:xmpp:archive"];
        [list addAttributeWithName:@"with" stringValue:roster];
        
        
        NSXMLElement *set = [NSXMLElement elementWithName:@"set"];
        [set addAttributeWithName:@"xmlns" stringValue:@"http://jabber.org/protocol/rsm"];
        
        NSXMLElement *max = [NSXMLElement elementWithName:@"max" stringValue:@"100000"];
       // [max addAttributeWithName:@"xmlns" stringValue:@"http://jabber.org/protocol/rsm"];

        //NSXMLElement *after = [NSXMLElement elementWithName:@"after" stringValue:@"19"];
        
        [set addChild:max];
        // [set addChild:after];
        [list addChild:set];
        [iq1 addChild:list];
        
        [xmppStream sendElement:iq1];
    
}

-(void)getMessagesFromServerForRoster:(NSString*)roster andForTimestamp:(NSString*)timeStamp forTimeStampIndex:(int)index
{
//        for(int i = 0; i < [timeList count]; i++)
//        {
    
//                NSString *start = [timeList objectAtIndex:i];
                NSXMLElement *iq1 = [NSXMLElement elementWithName:@"iq"];
                [iq1 addAttributeWithName:@"type" stringValue:@"get"];
                [iq1 addAttributeWithName:@"id" stringValue:[NSString stringWithFormat:@"%d",index]];
            
                NSXMLElement *retrieve = [NSXMLElement elementWithName:@"retrieve"];
                [retrieve addAttributeWithName:@"xmlns" stringValue:@"urn:xmpp:archive"];
                [retrieve addAttributeWithName:@"with" stringValue:roster];
                [retrieve addAttributeWithName:@"start" stringValue:timeStamp];

                NSXMLElement *set = [NSXMLElement elementWithName:@"set"];
                [set addAttributeWithName:@"xmlns" stringValue:@"http://jabber.org/protocol/rsm"];
            
                NSXMLElement *max = [NSXMLElement elementWithName:@"max" stringValue:@"100000"];
                //NSXMLElement *after = [NSXMLElement elementWithName:@"after" stringValue:@"19"];
            
                [set addChild:max];
               // [set addChild:after];
                [retrieve addChild:set];
                [iq1 addChild:retrieve];
                
                [xmppStream sendElement:iq1];
            
//        }
    
}

- (void) setDelegate:(id)newDelegate{
    chatDelegate = newDelegate;
}
-(NSMutableArray*)loadUserRoster:(NSXMLElement*)rosterElement
{
    NSArray *itemElements = [rosterElement elementsForName: @"item"];
    NSMutableArray *rosters = [[NSMutableArray alloc] init];
    for (int i=0; i<[itemElements count]; i++)
    {
        
        NSString *jid=[[[itemElements objectAtIndex:i] attributeForName:@"jid"] stringValue];
        [rosters addObject:jid];
        //                        [timeList addObject:list];
    }
    
    return rosters;
//    NSManagedObjectContext *moc = [self managedObjectContext_roster];
//    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"XMPPUserCoreDataStorageObject"
//                                                         inManagedObjectContext:moc];
//    NSFetchRequest *request = [[NSFetchRequest alloc]init];
//    [request setEntity:entityDescription];
//    NSError *error;
//    NSArray *roster = [moc executeFetchRequest:request error:&error];
//    return [[NSMutableArray alloc]initWithArray:roster];
}
-(NSDate*)timeZoneConversionToUTC:(NSString*)str
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    NSDate *dateFromString = [dateFormatter dateFromString:str];
    
    NSDate* sourceDate = dateFromString;
    
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"PKT"];
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:sourceDate];
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate];
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    
    NSDate* destinationDate = [[NSDate alloc] initWithTimeInterval:interval sinceDate:sourceDate];
    return destinationDate;
    
}
#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}
#pragma mark - XML Parsing methods
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    currentElement = elementName;
    if([elementName isEqualToString:@"chat"]){
        dataDict = [[NSMutableDictionary alloc] init];
    }
    else if ([elementName isEqualToString:@"to"] || [elementName isEqualToString:@"from"]) {
        if(!subCatArray) {
            subCatArray = [[NSMutableArray alloc] init];
        }
        subcatDict = [[NSMutableDictionary alloc] init];
        NSString *sec = [attributeDict objectForKey:@"secs"];
        NSString *jid = [attributeDict objectForKey:@"jid"];
        [subcatDict setValue:sec forKey:@"secs"];
        [subcatDict setValue:jid forKey:@"jid"];

    }
    else if ([elementName isEqualToString:@"body"]) {
        if(!messageBodies) {
            messageBodies = [[NSMutableArray alloc] init];
        }
        body = [[NSMutableDictionary alloc] init];
        
    }
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if(dataDict && !subCatArray){
        [dataDict setObject:string forKey:currentElement];
    }
    else if(subCatArray && subcatDict) {
        [subcatDict setObject:string forKey:currentElement];
    }
    if([currentElement isEqualToString:@"body"])
    {
        [body setObject:string forKey:currentElement];
    }
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if([elementName isEqualToString:@"chat"]){
        [dataDict setObject:subCatArray forKey:@"message"];
        [dataArray addObject:dataDict];
        dataDict = nil;
    }
    else if([elementName isEqualToString:@"to"] || [elementName isEqualToString:@"from"]){
        [subCatArray addObject:subcatDict];
        subcatDict = nil;
    }
    else if([elementName isEqualToString:@"body"] ){
        [messageBodies addObject:body];
        body = nil;
    }
   
}
-(void)deleteChatFromServer{
    
//    NSXMLElement *iq1 = [NSXMLElement elementWithName:@"iq"];
//    [iq1 addAttributeWithName:@"type" stringValue:@"set"];
//    [iq1 addAttributeWithName:@"id" stringValue:@"remove6"];
//    NSXMLElement *list = [NSXMLElement elementWithName:@"remove"];
//    [list addAttributeWithName:@"xmlns" stringValue:@"urn:xmpp:archive"];
//    //[list addAttributeWithName:@"with" stringValue:@"abeera@apples-macbook-pro-2.local"];
//    //[list addAttributeWithName:@"open" stringValue:@"true"];
//    [iq1 addChild:list];
//    [xmppStream sendElement:iq1];
    
    NSXMLElement *iq1 = [NSXMLElement elementWithName:@"iq"];
    [iq1 addAttributeWithName:@"from" stringValue:@"maaz@apples-MacBook-Pro-2.local"];
    [iq1 addAttributeWithName:@"id" stringValue:@"discol"];
    [iq1 addAttributeWithName:@"to" stringValue:@"abeera@apples-MacBook-Pro-2.local"];



        [iq1 addAttributeWithName:@"type" stringValue:@"get"];
        NSXMLElement *query = [NSXMLElement elementWithName:@"query"];
        [query addAttributeWithName:@"xmlns" stringValue:@"http://jabber.org/protocol/disco#info"];
    
   // NSXMLElement *feature = [NSXMLElement elementWithName:@"feature"];
   // [feature addAttributeWithName:@"var" stringValue:@"urn:xmpp:receipts"];
    
    //[query addChild:feature];
        [iq1 addChild:query];
        [xmppStream sendElement:iq1];

    
}

#pragma mark getting user city name
-(void)getCityName{
    UserInfo *userInfo = [UserInfo instance];
    //CLLocationCoordinate2D myCoordinate = self.mapView.userLocation.location.coordinate;
    [userInfo setLatitude:newLocation.coordinate.latitude];
    [userInfo setLongitude:newLocation.coordinate.longitude];
    [userInfo saveUserInfo];
    
    
    CLGeocoder *ceo = [[CLGeocoder alloc]init];
    //CLLocation *loc = [[CLLocation alloc]initWithLatitude:myCoordinate.latitude longitude:myCoordinate.longitude];
    
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
    
    
    
    [ceo reverseGeocodeLocation: loc completionHandler:
     ^(NSArray *placemarks, NSError *error) {
         CLPlacemark *placemark = [placemarks objectAtIndex:0];
         NSLog(@"placemark %@",placemark);
         //String to hold address
         NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
         //commented by ahmad...
         cityName = locatedAt;
         //end code commented by ahmad...
         
         //new editing:
         //cityName = [NSString stringWithFormat:@"%@,%@", placemark.country, placemark.locality];
         //end...
         NSLog(@"addressDictionary %@", placemark.addressDictionary);
         
         NSLog(@"placemark %@",placemark.region);
         NSLog(@"placemark %@",placemark.country);  // Give Country Name
         NSLog(@"placemark %@",placemark.locality); // Extract the city name
         NSLog(@"location %@",placemark.name);
         NSLog(@"location %@",placemark.ocean);
         NSLog(@"location %@",placemark.postalCode);
         NSLog(@"location %@",placemark.subLocality);
         
         NSLog(@"location %@",placemark.location);
         //Print the location to console
         NSLog(@"I am currently at %@",locatedAt);
         
         
         //         NSArray* myArray = [locatedAt  componentsSeparatedByString:@","];
         //         cityName = [myArray objectAtIndex:1];
     }];
     //[NSThread sleepForTimeInterval:4];
    
    //[self performSelector:@selector(saveLocationOnServer) withObject:nil afterDelay:6.0];
}


#pragma mark location update delegates
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
        newLocation = [locations lastObject];
        UserInfo *_userInfo = [UserInfo instance];

    //ahmad's code for updating user's location only once...
        //[self performSelector:@selector(getCityName) withObject:nil afterDelay:2.0];
    
    
   // [self getCityName];
        NSArray* strings = [cityName componentsSeparatedByString:@","];
        NSString* location = [NSString stringWithFormat:@"%@,%@", strings[1], strings[2]];

    //AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    BOOL isAvailable = [self isNetworkAvailable];
    if(isAvailable){
    if(userInfo.apiKey != nil){

        NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
        [params setObject:_userInfo.apiKey forKey:kapi_key];
            [params setObject:[NSString stringWithFormat:@"%f",newLocation.coordinate.latitude] forKey:klat];
            [params setObject:[NSString stringWithFormat:@"%f",newLocation.coordinate.longitude] forKey:klng];
            [params setObject:location forKey:klocation];
                GenericFetcher *fetcher = [[GenericFetcher alloc]init];
                //if there is a POST request send params in the fetcher method, if get request send nil to that
                // if there is a GET request send params in the urlbuilder method and nil to the fetcher method
                [fetcher fetchWithUrl:[URLBuilder urlForMethod:kupdate_location withParameters:nil]
                           withMethod:POST_REQUEST withParams:params completionBlock:^(NSDictionary *dict) {
                               NSLog(@"%@",dict);
                               int status = [[dict valueForKey:kstatus] intValue];
                               if (status == 1) {
                                   NSLog(@"user location updated successfully");
                               }
                               else
                               {
                                   NSLog(@"user location have not been updated");
                               }
                           }
                           errorBlock:^(NSError *error) {
                               NSLog(@"no internet");
                           }];
    }
   
    }
}

#pragma mark update location function
-(void)updateUserLocation{
    UserSettings *settings = [UserSettings instance];
    if ([settings showMeOnMapFlag]) {
        if (!locationManager) {
            locationManager = [[CLLocationManager alloc] init];
            locationManager.delegate = self;
            locationManager.distanceFilter = kCLDistanceFilterNone;
            locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
                [locationManager requestWhenInUseAuthorization];
        }
        [locationManager startUpdatingLocation];
        
    }
    
}
-(void)stopUpdatingLoc{
    [locationManager stopUpdatingLocation];
}
#pragma mark iCloud Helper Methods
- (void)storeChanged:(NSNotification*)notification {
    
    NSDictionary *userInfo = [notification userInfo];
    NSNumber *reason = [userInfo
                        objectForKey:NSUbiquitousKeyValueStoreChangeReasonKey];
    
    if (reason) {
        NSInteger reasonValue = [reason integerValue];
        NSLog(@"storeChanged with reason %d", reasonValue);
        
        if ((reasonValue == NSUbiquitousKeyValueStoreServerChange) ||
            (reasonValue == NSUbiquitousKeyValueStoreInitialSyncChange)) {
            
            NSArray *keys = [userInfo
                             objectForKey:NSUbiquitousKeyValueStoreChangedKeysKey];
            NSUbiquitousKeyValueStore *store = [NSUbiquitousKeyValueStore defaultStore];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            
            for (NSString *key in keys) {
                id value = [store objectForKey:key];
                [userDefaults setObject:value forKey:key];
                NSLog(@"storeChanged updated value for %@",key);
            }
        }
    }
}
-(void)loadProducts
{
    [[RageIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        if (success) {
            _products = products;
        }
    }];
}


- (NSURL *)applicationDocumentDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    
    NSError *error = nil;
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    if(!success){
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;
}

////////fcm
#pragma mark - UNUserNotificationCenter Delegate // >= iOS 10

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    
    
    NSDictionary *userInfo = notification.request.content.userInfo;
    NSLog(@"User Info = %@",notification.request.content.userInfo);
    NSLog(@"Message ID: %@", userInfo[@"gcm.message_id"]);
    NSMutableDictionary* aps = [userInfo valueForKey:@"aps"];
    NSMutableDictionary* alert = [userInfo valueForKey:@"alert"];
    NSString* bodyText  = [alert valueForKey:@"body"];
    NSString* title = [alert valueForKey:@"title"];
   // [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];

      // [self generateLocalNotification:bodyText:title];
    

 

    

    
    
    
    completionHandler(UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound);
}
//// Handle notification messages after display notification is tapped by the user.
//
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{
    
    NSLog(@"User Info = %@",response.notification.request.content.userInfo);
    completionHandler();
}




#pragma mark -Firebase methods

- (void)tokenRefreshNotification:(NSNotification *)notification {
    // Note that this callback will be fired everytime a new token is generated, including the first
    // time. So if you need to retrieve the token as soon as it is available this is where that
    // should be done.
    NSString *refreshedToken = [[FIRInstanceID instanceID] token];
    NSLog(@"InstanceID token: %@", refreshedToken);
    [userInfo setValue:refreshedToken forKey:kfcm_device_token];
    [userInfo saveUserInfo];
    [self updateFcmDeviceToken:@"update"];
    [self connectToFcm];
        
    
}
- (void)connectToFcm {
    // Won't connect since there is no token
    if (![[FIRInstanceID instanceID] token]) {
        return;
    }
    // Disconnect previous FCM connection if it exists.
    [[FIRMessaging messaging] disconnect];
    
    [[FIRMessaging messaging] connectWithCompletion:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Unable to connect to FCM. %@", error);
        } else {
            NSLog(@"Connected to FCM.");
        }
    }];
}

// With "FirebaseAppDelegateProxyEnabled": NO
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    //NSString *strData = [[NSString alloc]initWithData:deviceToken encoding:NSUTF8StringEncoding];
    NSLog(@"Device token%@", deviceToken);
    [[FIRInstanceID instanceID] setAPNSToken:deviceToken
                                        type:FIRInstanceIDAPNSTokenTypeSandbox];
    [[FIRInstanceID instanceID] setAPNSToken:deviceToken
                                        type:FIRInstanceIDAPNSTokenTypeProd];


}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // If you are receiving a notification message while your app is in the background,
    // this callback will not be fired till the user taps on the notification launching the application.
    // TODO: Handle data of notification
    
    // Print message ID.
    if (userInfo[@"gcm.message_id"]) {
        NSLog(@"Message ID: %@", userInfo[@"gcm.message_id"]);
    }
    
    // Print full message.
    NSLog(@"My full data%@", userInfo);
    
    NSMutableDictionary* aps = [userInfo valueForKey:@"aps"];
    NSMutableDictionary* alert = [userInfo valueForKey:@"alert"];
    NSString* bodyText  = [alert valueForKey:@"body"];
    NSString* title = [alert valueForKey:@"title"];

       //   [[UIApplication sharedApplication] setApplicationIconBadgeNumber:7];


    
    UIApplicationState appState = UIApplicationStateActive;
    if ([application respondsToSelector:@selector(applicationState)])
        appState = application.applicationState;
//    [self generateLocalNotification:bodyText:title];

    
    if (appState == UIApplicationStateBackground)
        
    {
//        badgenumber=badgenumber+1;
//        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:badgenumber];
    }
    
    

    completionHandler(UIBackgroundFetchResultNewData);
}


#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
// Receive data message on iOS 10 devices while app is in the foreground.
- (void)applicationReceivedRemoteMessage:(FIRMessagingRemoteMessage *)remoteMessage {
    // Print full message
    NSLog(@"This is the message whole structure%@", remoteMessage.appData);
    
}
#endif
//AppDelegate.m

#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    //handle the actions
    if ([identifier isEqualToString:@"declineAction"]){
    }
    else if ([identifier isEqualToString:@"answerAction"]){
    }
}
#endif
#pragma mark -
#pragma mark - Push Notification Methods


- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to get token, error: %@", error);
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //if (userInfo[kGCMMessageIDKey]) {
    //NSLog(@"UserInfo object is : - %@", userInfo);
    //print message id.
    if (userInfo[@"gcm.message_id"]) {
        NSLog(@"Message ID: %@", userInfo[@"gcm.message_id"]);
    }
    
    // Print full message.
    NSLog(@"simple didReceiveRemoteNotification%@", userInfo);
    NSLog(@"Message ID: %@", userInfo[@"gcm.message_id"]);
    
    
    NSMutableDictionary* aps = [userInfo valueForKey:@"aps"];
    NSMutableDictionary* alert = [userInfo valueForKey:@"alert"];
    NSString* bodyText  = [alert valueForKey:@"body"];
    NSString* title = [alert valueForKey:@"title"];

    
   // [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
   // [self generateLocalNotification:bodyText :title];
    
}


-(void)generateLocalNotification:(NSString*)bText:(NSString*)title
{
    UserSettings *userSettings = [UserSettings instance];
    
    if(userSettings.messagesFlag)
    {
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate =[NSDate dateWithTimeIntervalSinceNow:1];
        localNotification.timeZone = [NSTimeZone defaultTimeZone];

            localNotification.alertTitle = title;
            localNotification.alertAction = @"Ok";
            localNotification.alertBody = bText;
            localNotification.soundName = UILocalNotificationDefaultSoundName;

            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        
        
                [NSTimer scheduledTimerWithTimeInterval:1.5
                                                 target:self
                                               selector:@selector(cancelNotification)
                                               userInfo:nil
                                                repeats:NO];
                
          
            
    }
    
}
-(void) updateFcmDeviceToken:(NSString*)str{
    
    BOOL isAvailable = [self isNetworkAvailable];
    UserInfo *userInfo = [UserInfo instance];
    if(userInfo.isLogin){
    if(isAvailable){
        userInfo = [UserInfo instance];
        if(userInfo.apiKey != nil){
        NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
        [params setValue:userInfo.apiKey forKey:kapi_key];

        if([str isEqualToString:@"logout"])
            [params setValue:@" " forKey:kfcm_device_token];

        else
        {
            NSString *deviceId = [FIRInstanceID instanceID];
            if(deviceId == nil)
                [params setValue:@" " forKey:kfcm_device_token];
            else
            [params setValue:[[FIRInstanceID instanceID] token] forKey:kfcm_device_token];
        }
        GenericFetcher *fetcher = [[GenericFetcher alloc]init];
        //if there is a POST request send params in the fetcher method, if get request send nil to that
        // if there is a GET request send params in the urlbuilder method and nil to the fetcher method
        [fetcher fetchWithUrl:[URLBuilder urlForMethod:kupdate_fcm_token withParameters:nil]
                   withMethod:POST_REQUEST withParams:params completionBlock:^(NSDictionary *dict) {
                       NSLog(@"%@",dict);
                       int status = [[dict valueForKey:kstatus] intValue];
                       if (status == 1) {
                           NSLog(@"fcm device token updated successfully");
                           if([str isEqualToString:@"logout"]){

                           }

                       }
                       else
                       {
                           NSLog(@"fcm device token not updated");
                       }
                   }
                   errorBlock:^(NSError *error) {
                       NSLog(@"no internet");
                   }];
        }
        
    }
    }

    
}
-(void)cancelNotification{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];

   [[UIApplication sharedApplication] cancelAllLocalNotifications];
}
-(void)sendOfflineMsgNotification
{
    
    NSLog(@"%@",parameters);
    BOOL isAvailable = [self isNetworkAvailable];
        if(isAvailable){
        
            GenericFetcher *fetcher = [[GenericFetcher alloc]init];
            [fetcher fetchWithUrl:[URLBuilder urlForMethod:ksend_notification withParameters:nil]
                       withMethod:POST_REQUEST withParams:parameters completionBlock:^(NSDictionary *dict) {
                           NSLog(@"%@",dict);
                           int status = [[dict valueForKey:kstatus] intValue];
                           if (status == 1) {
                               NSLog(@"fcm notification sent sucessfully");
                           }
                           else
                           {
                               NSLog(@"error occured while sending");
                           }
                       }
                       errorBlock:^(NSError *error) {
                           NSLog(@"no internet");
                       }];
            
        }

}

@end
