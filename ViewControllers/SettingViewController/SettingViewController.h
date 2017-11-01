//
//  SettingViewController.h
//  nearhero
//
//  Created by Irfan Malik on 6/14/16.
//  Copyright © 2016 TBoxSolutionz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "BaseViewController.h"
#import "GADBannerViewController.h"
@import GoogleMobileAds;

//@protocol SettingViewControllerDelegate;
@interface SettingViewController : BaseViewController<UIAlertViewDelegate , UIScrollViewDelegate,ADBannerViewDelegate>
@property (strong, nonatomic) IBOutlet UITextField *email;
@property (strong, nonatomic) IBOutlet UIScrollView *scroller;
@property (strong, nonatomic) IBOutlet UIButton *profileImage;
@property (strong, nonatomic) IBOutlet UILabel *signOut;
@property (strong, nonatomic) IBOutlet UILabel *shareNearHero;
@property (weak, nonatomic) IBOutlet UIView *policyView;
@property (strong, nonatomic) IBOutlet UILabel *DeleteAccount;
@property (weak, nonatomic) IBOutlet UILabel *privacyAndTerms;

@property (weak, nonatomic) IBOutlet UISwitch *mapSwitchControl;

@property (weak, nonatomic) IBOutlet UISwitch *messageSwitchControl;
@property (weak, nonatomic) IBOutlet UISwitch *professionalSwitchControl;

@property (weak, nonatomic) IBOutlet GADBannerView *bannerAdd;
//@property(nonatomic, strong) GADBannerView *bannerAdd;
@property (weak, nonatomic) IBOutlet UIView *ContactViaEmailView;

- (IBAction)showNewMessages:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *writeReview;
//@property (weak, nonatomic) IBOutlet UIView *transperentView;
@property (weak, nonatomic) IBOutlet UIView *privacyView;
@property (weak, nonatomic) IBOutlet UIView *reviewView;
@property (weak, nonatomic) IBOutlet UIView *shareView;
@property (weak, nonatomic) IBOutlet UIView *signoutView;
- (IBAction)showNearProfessionals:(id)sender;
- (IBAction)moveBack:(id)sender;
//@property (strong, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *deleteAccountView;
- (IBAction)showMeOnMap:(id)sender;

- (IBAction)dismissView:(id)sender;
- (IBAction)didTapDeleteAccount:(id)sender;
@end
