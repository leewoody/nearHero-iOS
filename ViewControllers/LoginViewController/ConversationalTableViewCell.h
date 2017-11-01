//
//  ConversationalTableViewCell.h
//  
//
//  Created by Irfan Malik on 6/13/16.
//
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@interface ConversationalTableViewCell : SWTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *onlineImg;
@property (strong, nonatomic) IBOutlet UILabel *latestMessage;
@property (strong, nonatomic) IBOutlet UIImageView *profileImage;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *dt;
@property (strong, nonatomic) IBOutlet UIView *imgContainer;
//@property (strong, nonatomic) IBOutlet UILabel *list;
//@property (weak, nonatomic) IBOutlet UIImageView *image;
//@property (weak, nonatomic) IBOutlet UILabel *name;
//@property (weak, nonatomic) IBOutlet UILabel *date;

@end