//
//  SPHBubbleCellOther.h
//  ChatBubble
//
//  Created by ivmac on 10/2/13.
//  Copyright (c) 2013 Conciergist. All rights reserved.
//

#import "SPHChatData.h"
#import "JSQMessages.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>// phle se tha
#import <CoreLocation/CoreLocation.h>


#import "JSQMessages.h"



@interface SPHBubbleCellOther : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *abc;

@property (weak, nonatomic) IBOutlet UIImageView *Avatar_Image;
@property (weak, nonatomic) IBOutlet UILabel *time_Label;
@property (strong, nonatomic) IBOutlet UILabel *dstatus;


@property (weak, nonatomic) IBOutlet UIImageView *statusImage;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *statusindicator;

@property (strong, nonatomic) IBOutlet UILabel *deliveredStatus;
-(void)SetCellData:(SPHChatData *)feed_data targetedView:(id)ViewControllerObject Atrow:(NSInteger)indexRow;




@property (strong, nonatomic) JSQMessagesBubbleImage *outgoingBubbleImageData;

@end
