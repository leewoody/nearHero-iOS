//
//  SelectJobTitleViewController.h
//  nearhero
//
//  Created by Irfan Malik on 6/9/16.
//  Copyright © 2016 TBoxSolutionz. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SelectJobTitleViewControllerDelegate;

@interface SelectJobTitleViewController : UIViewController < UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UILabel *profession;
@property (strong, nonatomic) IBOutlet UILabel *userProfileName;
@property (weak, nonatomic) IBOutlet UIView *radus;
@property (weak, nonatomic) IBOutlet UIView *image_container;
@property (weak, nonatomic) IBOutlet UIImageView *profile_image;
@property (assign, nonatomic) id<SelectJobTitleViewControllerDelegate> delegate;

@property (strong, nonatomic) IBOutlet UITextField *professionEditor;
- (IBAction)getStaredSearch:(UIButton *)sender;
- (IBAction)moveBack:(id)sender;
- (IBAction)clickProfession:(id)sender;

@end

@protocol SelectJobTitleViewControllerDelegate<NSObject>
-(void)getStartedTapped;
@end