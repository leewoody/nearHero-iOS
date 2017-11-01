//
//  AppDelegate.h
//  nearhero
//
//  Created by Dilawer Hussain on 6/2/16.
//  Copyright © 2016 TBoxSolutionz. All rights reserved.
//
////////////XMPP Integration////////////////
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "XMPPFramework.h"
#import "XMPPMessageArchivingCoreDataStorage.h"
#import "NHXMPPMessageArchivingCoreDataStorage.h"
#import "XMPPMessageArchiving.h"
#import <CoreLocation/CoreLocation.h>
/////////////////////////////////////////////
#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import "JASidePanelController.h"
#import <linkedin-sdk/LISDK.h>
#import "RageIAPHelper.h" 


@import GoogleMobileAds;
@import FirebaseInstanceID;
@import FirebaseMessaging;

@import UserNotifications;



#define kMainViewController                            (MainViewController *)[UIApplication sharedApplication].delegate.window.rootViewController
@protocol onlineBuddiesDelegate
- (void)newBuddyOnline:(NSString *)buddyName;
- (void)buddyWentOffline:(NSString *)buddyName;
@end
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
@interface AppDelegate : UIResponder <UIApplicationDelegate, UNUserNotificationCenterDelegate, FIRMessagingDelegate,UIApplicationDelegate, XMPPRosterDelegate,NSXMLParserDelegate,CLLocationManagerDelegate>
#endif
//@interface AppDelegate : UIResponder <UIApplicationDelegate, XMPPRosterDelegate,NSXMLParserDelegate,CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    BOOL isLoadingUserMessages;
    int currentRosterIndex;
    NSMutableArray *timeStamps;
    //////////XMPP Integration//////////
    XMPPStream *xmppStream;
    XMPPReconnect *xmppReconnect;
    XMPPRoster *xmppRoster;
    XMPPRosterCoreDataStorage *xmppRosterStorage;
    XMPPvCardCoreDataStorage *xmppvCardStorage;
    XMPPvCardTempModule *xmppvCardTempModule;
    XMPPvCardAvatarModule *xmppvCardAvatarModule;
    XMPPCapabilities *xmppCapabilities;
    XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage;
    ////////////////CoreData
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    
    id chatDelegate;
    NSString *password;
    
    BOOL customCertEvaluation;
    
    BOOL isXmppConnected;
    /////////////////////////////////////
}
///////////////////////////XMPP Integration//////////////////////////
@property (nonatomic, strong, readonly) XMPPStream *xmppStream;
@property (nonatomic, strong, readonly) XMPPReconnect *xmppReconnect;
@property (nonatomic, strong, readonly) XMPPRoster *xmppRoster;
@property (nonatomic, strong, readonly) XMPPRosterCoreDataStorage *xmppRosterStorage;
@property (nonatomic, strong, readonly) XMPPvCardTempModule *xmppvCardTempModule;
@property (nonatomic, strong, readonly) XMPPvCardAvatarModule *xmppvCardAvatarModule;
@property (nonatomic, strong, readonly) XMPPCapabilities *xmppCapabilities;
@property (nonatomic, strong, readonly) XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage;
@property (nonatomic, strong) IBOutlet UINavigationController *navigationController;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *loginButton;
@property (nonatomic, strong) XMPPMessageArchiving* xmppMessageArchivingModule;
//@property (nonatomic, strong) NHXMPPMessageArchivingCoreDataStorage* xmppMessageArchivingStorage;
@property (nonatomic, strong) XMPPMessageArchivingCoreDataStorage* xmppMessageArchivingStorage;
@property (nonatomic, strong) NSMutableArray *userRosterList;
@property (nonatomic,assign) BOOL isConnectedToOF;
//Core Data Stack
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
-(void)sendMessage:(NSString*)messageStr:(NSString*)receiver;
- (NSManagedObjectContext *)managedObjectContext_roster;
- (NSManagedObjectContext *)managedObjectContext_capabilities;
- (NSManagedObjectContext *)managedObjectContext;
-(void)updateUserLocation;
-(void)loadContacts;
-(BOOL)isNetworkAvailable;

- (BOOL)connect;
- (void)disconnect;
//////////////////////////////////////////////////////////////////////
@property (strong, nonatomic) JASidePanelController *rootViewController;
@property (strong, nonatomic) IBOutlet UIWindow *window;
@property (strong, atomic) NSArray *products;

- (NSURL *)applicationDocumentsDirectory;
-(void)setHomeMenu;
-(void)setIntroMenu;
-(void)getHistory;
-(void)goOffline;
- (void) createVcard;
-(void)updateContactInviteStatus;
-(void)insertLatestMessagesInXMPP:(NSMutableDictionary*)msg;
-(void)updateFcmDeviceToken:(NSString*)str;
-(void)loadFeedBacks:(NSDictionary*)obj;
-(void)getMessagesFromServer;
- (void) setDelegate:(id)newDelegate;
-(void)stopUpdatingLoc;

@end

