//
//  SPHBubbleCellOther.m
//  ChatBubble
//
//  Created by ivmac on 10/2/13.
//  Copyright (c) 2013 Conciergist. All rights reserved.
//

#import "SPHBubbleCellOther.h"
#import "SPHMacro.h"

#define message_Width 230


@implementation SPHBubbleCellOther

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        
        
    }
    return self;
}

-(void)SetCellData:(SPHChatData *)feed_data targetedView:(id)ViewControllerObject Atrow:(NSInteger)indexRow;
{
    
    
    
    UIImage *mockImage = [UIImage imageNamed:@"Bubbletyperight2"];
        self.outgoingBubbleImageData =  [[JSQMessagesBubbleImage alloc] initWithMessageBubbleImage:mockImage highlightedImage:mockImage];
    JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
    
     self.outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleBlueColor]];
    
    
    
    
    
    
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:16]};
    // NSString class method: boundingRectWithSize:options:attributes:context is
    // available only on ios7.0 sdk.
   
    
    CGSize boundingSize = CGSizeMake(message_Width-20, 10000000);

    
    NSString *messageText = feed_data.messageText;
    CGRect cgrect = [messageText boundingRectWithSize:boundingSize
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:attributes
                                             context:nil];
    CGSize itemTextSize = cgrect.size;
//    CGSize itemTextSize = [messageText sizeWithFont:[UIFont systemFontOfSize:16]
//                                  constrainedToSize:boundingSize
//                                      lineBreakMode:NSLineBreakByWordWrapping];
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
    
    
    
    
    CGRect screenRect = [UIScreen mainScreen].bounds;
    UIImageView *bubbleImage=[[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"Bubbletyperight2"] stretchableImageWithLeftCapWidth:32 topCapHeight:17]];
    bubbleImage.contentMode = UIViewContentModeScaleToFill;
    bubbleImage.tag=55;
     [self.contentView addSubview:bubbleImage];
//    [bubbleImage setFrame:CGRectMake(screenRect.size.width-itemTextSize.width-60,16,itemTextSize.width+14,textHeight+4)];
 //       [bubbleImage setFrame:CGRectMake(screenRect.size.width-itemTextSize.width-25,16,itemTextSize.width+25,textHeight+8)];
 //   [bubbleImage setBackgroundColor:[UIColor blackColor]];
//    UITextView *messageTextview=[[UITextView alloc]initWithFrame:CGRectMake(screenRect.size.width - itemTextSize.width-60,13,itemTextSize.width+10, textHeight-2)];
   //  UITextView *messageTextview=[[UITextView alloc]initWithFrame:CGRectMake(screenRect.size.width - itemTextSize.width-20,13,itemTextSize.width+14, textHeight-2)];
    
    UITextView *messageTextview=[[UITextView alloc]initWithFrame:CGRectMake((screenRect.size.width - itemTextSize.width-30)+5 ,17,itemTextSize.width+10, textHeight)];
    CGRect f1 = messageTextview.frame;
    CGRect f2 = bubbleImage.frame;

    [messageTextview setScrollEnabled:YES];

    messageTextview.font=[UIFont fontWithName:@"Helvetica Neue" size:16.0];
  //  messageTextview.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    messageTextview.dataDetectorTypes=UIDataDetectorTypeAll;
    messageTextview.textAlignment=NSTextAlignmentLeft;
     messageTextview.backgroundColor=[UIColor clearColor];
    // messageTextview.backgroundColor=[UIColor brownColor];

    messageTextview.tag=indexRow;
    messageTextview.textColor = [UIColor whiteColor];
    messageTextview.text = messageText;
    [messageTextview sizeToFit];
    CGRect f3 = messageTextview.frame;
    [bubbleImage setFrame:CGRectMake(screenRect.size.width-itemTextSize.width-30,16,itemTextSize.width+25,messageTextview.frame.size.height+4)];
     [messageTextview setScrollEnabled:NO];

    messageTextview.editable=NO;

    //self.Avatar_Image.image=[UIImage imageNamed:@"Customer_icon"];
    [self.contentView addSubview:messageTextview];

    self.time_Label.text=feed_data.messageTime;
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    messageTextview.scrollEnabled=NO;
    bubbleImage.image =   self.outgoingBubbleImageData.messageBubbleImage;
    
    if ([feed_data.messagestatus isEqualToString:kStatusDelivered]) {
        
        self.statusindicator.alpha=0.0;
        [self.statusindicator stopAnimating];
        //self.statusImage.alpha=1.0;
        //[self.statusImage setImage:[UIImage imageNamed:@"success"]];
        self.statusImage.hidden = YES;
        self.dstatus.text = @"Delivered";
        
        
        
    }else  if ([feed_data.messagestatus isEqualToString:kStatusSeding])
    {
        self.statusImage.alpha=0.0;
        self.statusindicator.alpha=1.0;
        [self.statusindicator startAnimating];
        self.dstatus.text = @"Sending";
        
    }
    else
    {
        self.statusindicator.alpha=0.0;
        [self.statusindicator stopAnimating];
        self.statusImage.alpha=1.0;
        [self.statusImage setImage:[UIImage imageNamed:kStatusFailed]];
        self.dstatus.text = @"Pending";

    }
    
    self.Avatar_Image.layer.cornerRadius = 20.0;
    self.Avatar_Image.layer.masksToBounds = YES;
    self.Avatar_Image.layer.borderColor = [UIColor whiteColor].CGColor;
    self.Avatar_Image.layer.borderWidth = 2.0;
    
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:ViewControllerObject action:@selector(tapRecognized:)];
    [messageTextview addGestureRecognizer:singleFingerTap];
    singleFingerTap.delegate = ViewControllerObject;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
