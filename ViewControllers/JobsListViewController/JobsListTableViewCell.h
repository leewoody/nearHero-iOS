//
//  JobsListTableViewCell.h
//  nearhero
//
//  Created by Irfan Malik on 6/15/16.
//  Copyright © 2016 TBoxSolutionz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JobsListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *detail;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *date;
@end
