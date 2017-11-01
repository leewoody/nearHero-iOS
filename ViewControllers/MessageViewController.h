//
//  MessageViewController.h
//  nearhero
//
//  Created by apple on 8/16/16.
//  Copyright © 2016 TBoxSolutionz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *tick;
@property (strong, nonatomic) UIActivityViewController *activityViewController;

- (IBAction)cancelBtn:(id)sender;
- (IBAction)shareProfileBtnAction:(id)sender;
@end
