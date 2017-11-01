//
//  ChatViewController.h
//  nearhero
//
//  Created by Irfan Malik on 6/13/16.
//  Copyright (c) 2016 TBoxSolutionz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatViewController : UIViewController
{
    NSMutableArray *sphBubbledata;
}
@property (strong, nonatomic) IBOutlet UILabel *distance;
- (IBAction)showMessages:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet UIView *imageContainer;
- (IBAction)moveBack:(id)sender;

@property (strong, nonatomic) IBOutlet UITableView *chattingView;
- (IBAction)dismissView:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UIImageView *userPhoto;
@property (strong, nonatomic) IBOutlet UILabel *profession;
@property (strong, nonatomic) IBOutlet UILabel *date;

@end
