//
//  ProfileTableViewCell.h
//  
//
//  Created by Irfan Malik on 6/13/16.
//
//

#import <UIKit/UIKit.h>

@interface HalfProfileTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIView *imageContainerView;
@property (weak, nonatomic) IBOutlet UIView *ratingReview;
@property (strong, nonatomic) IBOutlet UITextView *detail_name;


@end
