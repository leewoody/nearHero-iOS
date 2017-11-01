//
//  UserReviewController.h
//  nearhero
//
//  Created by apple on 9/24/16.
//  Copyright © 2016 TBoxSolutionz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserReviewController : UIViewController <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *ratingReview;
@property (weak, nonatomic) IBOutlet UIView *imageContainerView;
@property (weak, nonatomic) IBOutlet UIView *ratingParentView;
@property (weak, nonatomic) IBOutlet UIView *transView;
@property (strong, nonatomic) IBOutlet NSMutableDictionary *user;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UITextView *review;
-(void)changeprofileWithImage;
@property (weak, nonatomic) IBOutlet UILabel *profession;
- (IBAction)sendButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *numOfChar;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end
