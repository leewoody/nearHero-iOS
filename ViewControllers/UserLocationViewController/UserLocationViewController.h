//
//  UserLocationViewController.h
//  nearhero
//
//  Created by Irfan Malik on 6/13/16.
//  Copyright (c) 2016 TBoxSolutionz. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol UserLocationViewControllerDelegate;

@interface UserLocationViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *radus;
@property (assign, nonatomic) id<UserLocationViewControllerDelegate> delegate;


- (IBAction)moveBack:(id)sender;

- (IBAction)moveToHomeScreen:(UIButton *)sender;
@end

@protocol UserLocationViewControllerDelegate<NSObject>
-(void)allowTapped;
@end
