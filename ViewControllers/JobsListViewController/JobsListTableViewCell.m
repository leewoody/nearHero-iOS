//
//  JobsListTableViewCell.m
//  nearhero
//
//  Created by Irfan Malik on 6/15/16.
//  Copyright © 2016 TBoxSolutionz. All rights reserved.
//

#import "JobsListTableViewCell.h"

@implementation JobsListTableViewCell
@synthesize name = name;
@synthesize detail = detail;
@synthesize date = date;
@synthesize image = image;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
