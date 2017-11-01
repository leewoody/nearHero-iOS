//
//  HomeViewController.h
//  nearhero
//
//  Created by Dilawer Hussain on 6/2/16.
//  Copyright © 2016 TBoxSolutionz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectJobTitleViewController.h"
#import "ShareViewController.h"
#import "UserLocationViewController.h"
#import "HalfProfileViewController.h"
#import "ProfileViewController.h"
#import "ConversationalViewController.h"
#import "SettingViewController.h"
#import <MapKit/MKMapView.h>
#import <MapKit/MKUserLocation.h>
#import "SettingViewController.h"
#import "SPHViewController.h"
#import "Reachability.h"
#import "ShareViewController.h"
#import "UserReviewController.h"
#import "SearchViewController.h"
#import "NearHeroProViewController.h"
#import <iAd/iAd.h>
#import "WebViewController.h"


//#import "HACMKMapView.h"

#import "QTree.h"
#import "QCluster.h"
@import GoogleMobileAds;

typedef enum {
    SUBSCRIBED,
    NOT_SUBSCRIBED,
    PREVIOUS_STATE_NULL
} SubscriptionState;


@interface HomeViewController : UIViewController<SelectJobTitleViewControllerDelegate,UserLocationViewControllerDelegate, UISearchBarDelegate,ProfileViewControllerDelegate,MKMapViewDelegate,CLLocationManagerDelegate,changeProfileDelegate,ADInterstitialAdDelegate>{
    SelectJobTitleViewController *jobTitleVC;
    UserLocationViewController *userlocationVC;
    ProfileViewController *profileVC;
    //HalfProfileViewController *halfProfileVC;
    SettingViewController *settingsVC;
    ShareViewController *shareVC;
    SearchViewController *svc;
    UserReviewController *reviewVC;
    SPHViewController *sPHViewController;
    
    Reachability *internetReachableFoo;
    IBOutlet UIButton *searchbtn;
    IBOutlet UIBarButtonItem *searchItem;
    IBOutlet UISearchBar *search_bar;
    IBOutlet UIView *profile_img_container;
  //  BOOL didUserLoad;
}
/// The interstitial ad.
@property(nonatomic, strong) GADInterstitial *interstitial;
@property (weak, nonatomic) IBOutlet UIImageView *img_profile;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property(nonatomic, strong) QTree* qTree;
@property (nonatomic,strong) IBOutlet MKMapView *mapView;
@property(weak,nonatomic) NSString* userId;
@property BOOL didUserLoad;
@property BOOL flag;



@property (weak,nonatomic) IBOutlet UIView *tView;


- (IBAction)searchClick:(id)sender;
-(void)viewAllMessages;
-(void)openHalfProfileScreen:(NSString*)user_id;
-(void)openUserProfile:(NSMutableDictionary*)user : (BOOL)isLayer;
-(CLLocationCoordinate2D) getCoordinates;
-(void)hideView;
-(void)showView;
-(void)saveLocationOnServer;
-(void)viewSettingScreen;
-(void)viewinvitescreen:(BOOL)isLayer;
-(void)viewProfileScreen;
-(void)searchUsers:(NSString*)searchString:(NSString*)radius;
-(void)showChatView;
//By ahmad.
-(void)ChangeProfileImage;
-(void)enableSearchBtn;
-(BOOL)connected;
-(void)startPulseLoading;
-(void)stopPulseLoading;
-(void)openProScreen;
-(void)openMessageViewController;
//end
//-(void)searchUsers:(NSString*)searchString;
-(void)ShowAddReviewScreen:(NSMutableDictionary *)user;
- (IBAction)showUserOnMap:(id)sender;
-(void)showUserChat:(NSString*)chatPartner;
-(void)showChatView:(NSString*)chatPaartner;
-(void)loadUsersOnMap:(NSArray*)users;
-(void)openWebView:(NSString*)url;


@end
