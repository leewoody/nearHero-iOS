//
//  SideMenuViewController.h
//  Pro Ptv Sports
//
//  Created by Irfan Malik on 6/2/16.
//  Copyright © 2016 Techvista. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"

@interface SideMenuViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,NSFetchedResultsControllerDelegate,onlineBuddiesDelegate>
{
    NSFetchedResultsController *fetchedResultsController;
}
@property (strong, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) IBOutlet UIImageView *profileImage;
@property (strong, nonatomic) IBOutlet UIView *userView;
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *profession;
@property (strong, nonatomic)     NSMutableArray *onlineBuddies;

//@property (strong, nonatomic) IBOutlet UIView *imgContainer;

- (IBAction)viewMyProfile:(UIButton *)sender;
- (IBAction)showSettingVC:(UIButton *)sender;
- (IBAction)showInviteVC:(id)sender;

@end
