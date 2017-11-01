//
//  JobsListViewController.h
//  nearhero
//
//  Created by Irfan Malik on 6/14/16.
//  Copyright © 2016 TBoxSolutionz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JobsListViewController : UIViewController
- (IBAction)postJob:(id)sender;
- (IBAction)moveBack:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tabel;
@end
