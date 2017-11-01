//
//  ProfileViewController.h
//  nearhero
//
//  Created by Irfan Malik on 6/10/16.
//  Copyright (c) 2016 TBoxSolutionz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
#import "BaseViewController.h" 
//#import "SampleProtocol.h"

@protocol ProfileViewControllerDelegate<NSObject>;
@end
//by ahmad, change profile image in home controller also...

@protocol changeProfileDelegate <NSObject>
-(void)changeprofileWithImage;
@end

//end...


//@protocol HomeViewControllerDelegate;

//@property (assign, nonatomic) id<HomeViewControllerDelegate> delegate;
//@protocol HomeViewControllerDelegate<NSObject>
//-(void)changeProfileImage;

//@end
@interface ProfileViewController :  BaseViewController< SWTableViewCellDelegate,UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate,UIActionSheetDelegate,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *ratingView;

@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
@property (weak, nonatomic) IBOutlet UIButton *messageButton;
@property (weak, nonatomic) IBOutlet UIButton *writeReviewBtn;
@property (weak, nonatomic) IBOutlet UILabel *reviewLabel;

@property (weak, nonatomic) IBOutlet UIView *collectionViewContainer;
@property (weak, nonatomic) IBOutlet UIView *imageContainerView;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
- (IBAction)editButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *shareProfileButton;
- (IBAction)cameraBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIView *basicInfoContainer;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *buttonContainer;

@property (weak, nonatomic) IBOutlet UILabel *profession;
@property (strong, nonatomic) IBOutlet UIView *internalRatingView;
@property (weak, nonatomic) IBOutlet UILabel *myHero;
@property (weak, nonatomic) IBOutlet UILabel *connectionLabel;
@property (weak, nonatomic) IBOutlet UILabel *noReviewLabel;

@property (strong, nonatomic) UIActivityViewController *activityViewController;
- (IBAction)messageButtonAction:(id)sender;
- (IBAction)addReview:(id)sender;
@property (strong,nonatomic) NSMutableDictionary *profileUser;

@property (strong,nonatomic) NSString *user_id;
@property (strong,nonatomic) NSString *api_key;
@property (strong,nonatomic) NSString *profileUrl;

@property (strong,nonatomic) NSString *str;
@property(strong,nonatomic) UICollectionViewFlowLayout *myCollectionViewFlowLayout;

@property (weak, nonatomic) IBOutlet UILabel *location;

@property (weak, nonatomic) IBOutlet UILabel *full_name;

@property (assign, nonatomic) id<ProfileViewControllerDelegate> delegate;

//by ahmad, change profile image in home controller also...

@property (nonatomic, strong) id<changeProfileDelegate> controllerDelegate;

//end...

@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;
- (IBAction)moveBack:(id)sender;
-(void)hideCollectionView;
-(void)gettingFeedback;
-(void)setUserInfo;

- (IBAction)shareProfile:(id)sender;

- (IBAction)inviteFriends:(id)sender;
@end
