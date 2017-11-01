//
//  SPHBubbleself.m
//  ChatBubble
//
//  Created by ivmac on 10/2/13.
//  Copyright (c) 2013 Conciergist. All rights reserved.
//

#import "SPHBubbleCell.h"
#import "Constants.h"


@implementation SPHBubbleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)SetCellData:(SPHChatData *)feed_data targetedView:(id)ViewControllerObject Atrow:(NSInteger)indexRow;
{
    UIImage *mockImage = [UIImage imageNamed:@"Bubbletypeleft"];
    self.incomingBubbleImageData =  [[JSQMessagesBubbleImage alloc] initWithMessageBubbleImage:mockImage highlightedImage:mockImage];
    JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];

    
       self.incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
    

    NSString *messageText = feed_data.messageText;
    CGSize boundingSize = CGSizeMake(message_Width-20, 10000000);
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:16]};
    
    CGRect cgrect = [messageText boundingRectWithSize:boundingSize
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:attributes
                                              context:nil];

//    CGSize itemTextSize = [messageText sizeWithFont:[UIFont systemFontOfSize:17]
//                                  constrainedToSize:boundingSize
//                                      lineBreakMode:NSLineBreakByWordWrapping];
    CGSize itemTextSize = cgrect.size;
    float textHeight = itemTextSize.height+7;
    int x=0;
    if (textHeight>200)
    {
        x=65;
    }else
        if (textHeight>150)
        {
            x=50;
        }
        else if (textHeight>80)
        {
            x=30;
        }else
            if (textHeight>50)
            {
                x=20;
            }else
                if (textHeight>30) {
                    x=8;
                }
    //[bubbleImage setFrame:CGRectMake(265-itemTextSize.width,5,itemTextSize.width+14,textHeight+4)];
    UIImageView *bubbleImage=[[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"Bubbletypeleft"] stretchableImageWithLeftCapWidth:32 topCapHeight:18]];
    [self.contentView addSubview:bubbleImage];
    [bubbleImage setFrame:CGRectMake(45,16,itemTextSize.width+25, textHeight+8)];
    bubbleImage.tag=56;
    bubbleImage.contentMode = UIViewContentModeScaleToFill;
    //CGRectMake(260 - itemTextSize.width+5,2,itemTextSize.width+10, textHeight-2)];
    UITextView *messageTextview=[[UITextView alloc]initWithFrame:CGRectMake(55,17,itemTextSize.width+10, textHeight)];
    
    
    [messageTextview setScrollEnabled:YES];
    
    messageTextview.font=[UIFont fontWithName:@"Helvetica Neue" size:16.0];
   // messageTextview.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    messageTextview.dataDetectorTypes=UIDataDetectorTypeAll;
    // messageTextview.textAlignment=NSTextAlignmentCenter;
    messageTextview.backgroundColor=[UIColor clearColor];
  //  messageTextview.backgroundColor=[UIColor brownColor];

    messageTextview.tag=indexRow;
    messageTextview.textColor = [UIColor blackColor];
    messageTextview.text = messageText;
    [messageTextview sizeToFit];
    [messageTextview setScrollEnabled:NO];
    
    messageTextview.editable=NO;
    
    [self.contentView addSubview:messageTextview];
    [bubbleImage setFrame:CGRectMake(45,16,itemTextSize.width+25,messageTextview.frame.size.height+4)];

    bubbleImage.image = self.incomingBubbleImageData.messageBubbleImage;
    
    //self.Avatar_Image.layer.cornerRadius = 20.0;
    self.Avatar_Image.layer.cornerRadius = self.Avatar_Image.frame.size.width / 2;
    self.Avatar_Image.layer.masksToBounds = YES;
//    self.Avatar_Image.layer.borderColor = [UIColor whiteColor].CGColor;
//    self.Avatar_Image.layer.borderWidth = 2.0;
    
   // makeViewRound(self.imageContainer);
    
    //self.Avatar_Image.image=[UIImage imageNamed:@"my_icon"];
    self.time_Label.text=feed_data.messageTime;
    //self.time_Label.hidden = YES;
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    
    UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:ViewControllerObject action:@selector(tapRecognized:)];
    [messageTextview addGestureRecognizer:singleFingerTap];
    singleFingerTap.delegate = ViewControllerObject;
}

@end
