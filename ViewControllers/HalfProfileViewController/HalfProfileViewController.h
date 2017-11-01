//
//  HalfProfileViewController.h
//  nearhero
//
//  Created by apple on 7/29/16.
//  Copyright © 2016 TBoxSolutionz. All rights reserved.
//
#import "HalfProfileTableViewCell.h"
#import "AMRatingControl.h"
#import <UIKit/UIKit.h>
@protocol HalfProfileViewControllerDelegate;
@interface HalfProfileViewController : UIViewController<UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *transView;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UIView *profileImageContainer;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *profession;
@property (weak, nonatomic) IBOutlet UIView *basicInfoContainer;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIView *transperentView;
@property (strong, nonatomic) NSString *user_id;
@property (weak, nonatomic) NSString *api_key;
@property (weak, nonatomic) IBOutlet UILabel *noReviewLabel;
@property (strong, nonatomic) NSDictionary *user_data;
@property (weak, nonatomic) IBOutlet UIView *ratingView;
@property (weak, nonatomic) IBOutlet UILabel *distance;
@property (weak, nonatomic) IBOutlet UIButton *messageButton;

@property (assign, nonatomic) id<HalfProfileViewControllerDelegate> delegate;
- (IBAction)showChatScreen:(id)sender;
-(void)remove_profileView;
@end
@protocol HalfProfileViewControllerDelegate<NSObject>
@end
