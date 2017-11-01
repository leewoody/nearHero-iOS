//
//  ProfileTableViewCell.h
//  
//
//  Created by Irfan Malik on 6/13/16.
//
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"


@interface ProfileTableViewCell : SWTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIView *imageContainerView;
@property (weak, nonatomic) IBOutlet UILabel *detail_name;
@property (weak, nonatomic) IBOutlet UIView *ratingView;
@property (weak, nonatomic) IBOutlet UITextView *feedback;
@property (weak, nonatomic) IBOutlet UILabel *date;

@end
