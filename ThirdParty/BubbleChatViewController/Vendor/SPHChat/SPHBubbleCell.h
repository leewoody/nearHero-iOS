//
//  SPHBubbleCell.h
//  ChatBubble
//
//  Created by ivmac on 10/2/13.
//  Copyright (c) 2013 Conciergist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPHChatData.h"
#import "SPHMacro.h"

#import "SPHChatData.h"
#import "JSQMessages.h"
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>



@interface SPHBubbleCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *Avatar_Image;
@property (strong, nonatomic) IBOutlet UIView *imageContainer;
@property (strong, nonatomic) JSQMessagesBubbleImage *incomingBubbleImageData;
@property (weak, nonatomic) IBOutlet UILabel *time_Label;

-(void)SetCellData:(SPHChatData *)feed_data targetedView:(id)ViewControllerObject Atrow:(NSInteger)indexRow;

@end
