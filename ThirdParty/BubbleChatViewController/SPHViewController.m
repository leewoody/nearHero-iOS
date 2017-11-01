//
//  SPHViewController.m
//  SPHChatBubble
//
//  Created by Siba Prasad Hota  on 10/18/13.
//  Copyright (c) 2013 Wemakeappz. All rights reserved.
//

#import "SPHViewController.h"
#import "SPHChatData.h"
#import "SPHChatData.h"
#import "SPHBubbleCell.h"
#import "SPHBubbleCellImage.h"
#import "SPHBubbleCellImageOther.h"
#import "SPHBubbleCellOther.h"
#import <QuartzCore/QuartzCore.h>
#import "AsyncImageView.h"
#import "MHFacebookImageViewer.h"
#import "QBPopupMenu.h"
#import "AppDelegate.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "HomeViewController.h"
//#import "SPHAppDelegate.h"
#import "SPHMacro.h"

#import "ConversationalViewController.h"
#import "UserInfo.h"
#import "Constants.h"
/////////////////XMPP Integration////////////
#import "XMPPFramework.h"
#import "DDLog.h"
#import "XMPPvCardAvatarModule.h"
#import "XMPPvCardCoreDataStorage.h"
#import "XMPPvCardTemp.h"
#import "XMPPvCardTempModule.h"
#import "XMPPvCardCoreDataStorage.h"
#import <CoreData/CoreData.h>
#import "Constants.h"
#import "UserInfo.h"
#import "GenericFetcher.h"
#import "URLBuilder.h"
#import "AMRatingControl.h"
#import <CoreLocation/CoreLocation.h>
#import "Toast+UIView.h"


@interface SPHViewController (){
    NSString *chatMessage;
    NSString *imgUrl;
    UserInfo *userinfo;
    NSMutableArray *userChat;
    int index;
    BOOL *stop;
    UITapGestureRecognizer *singleTapForOpenProfile;
    NSString *msgReceiver;
    BOOL delivered;
}

@end

@implementation SPHViewController{
    UITapGestureRecognizer *singleFingertapper;
    UIButton *doneBtn;
    NSString *userProfileId;
    NSDictionary *user;
}

@synthesize pullToRefreshManager = pullToRefreshManager_;
@synthesize reloads = reloads_;

@synthesize imgPicker;
@synthesize Uploadedimage;
-(AppDelegate *)appDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    delivered = false;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.userTappingView setUserInteractionEnabled:NO];

    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //by ahmad, to change profile image....
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(change:)
                                                 name:@"change" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadTable)
                                                 name:@"messageIsDelivered"
                                               object:nil];

    //end...
    
    stop = false;
    _name.adjustsFontSizeToFitWidth = YES;
    _profession.adjustsFontSizeToFitWidth = YES;
    [self setProfile];
    userinfo = [UserInfo instance];
    ////////////getting vcard
    index = 4;
    XMPPJID *jid  =  [XMPPJID jidWithString:_chatPartner];
    XMPPvCardTemp *vCard =[[self appDelegate].xmppvCardTempModule vCardTempForJID:jid shouldFetch:YES];
    imgUrl = [[vCard elementForName:kprofile_image] stringValue];
    ///////////notification for gettinh sms
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:@"myNotification"
                                               object:nil];
    NSArray *array = [_chatPartner componentsSeparatedByString:@"@"];
    msgReceiver = [array objectAtIndex:0];

    CGRect frame = self.imageContainer.frame;
    frame.size.height = 30;
    frame.size.width = 30;
    self.imageContainer.frame = frame;
    makeViewRound(self.imageContainer);

    
    sphBubbledata=[[NSMutableArray alloc]init];

    [self getEarlierMessages];
   // [self performSelectorOnMainThread:@selector(getEarlierMessages) withObject:nil waitUntilDone:NO];

    
    
    [self performSelector:@selector(setUpTextFieldforIphone) withObject:nil afterDelay:0.5];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

    pullToRefreshManager_ = [[MNMPullToRefreshManager alloc] initWithPullToRefreshViewHeight:60.0f
                                                                                   tableView:self.sphChatTable
                                                                                  withClient:self];
    UIView* bview = [[UIView alloc] init];
    bview.backgroundColor = [UIColor whiteColor];
    [self.sphChatTable setBackgroundView:bview];
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(removeChatView)];
    [self.transperentView addGestureRecognizer:singleFingerTap];
    
    UITapGestureRecognizer *_singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(removeChatView)];
    [self.transView addGestureRecognizer:_singleFingerTap];
    
    UITapGestureRecognizer *singleFingerTapSecond =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(removeChatView)];
    [self.secondTransView addGestureRecognizer:singleFingerTapSecond];

    singleTapForOpenProfile =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(openProfile)];
    [self.userTappingView addGestureRecognizer:singleTapForOpenProfile];
 
//    [self setUpDummyMessages];
    
	// Do any additional setup after loading the view, typically from a nib.
    
//    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate ;
//    [appDelegate sendMessage:@"I'm from nearhero" :@"abeera"];
}


//for changing profile image...
-(void) change:(NSNotification *) notification{
    UserInfo *userinfo = [UserInfo instance];
    setImageUrl(self.userPhoto, userinfo.imageUrl);
}

//end...

-(void)openProfile{
    [self.userTappingView removeGestureRecognizer:singleTapForOpenProfile];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(enableInteraction) userInfo:nil repeats:NO];
    [self.view endEditing:YES];
    [(HomeViewController*)(((MainViewController*)kMainViewController).rootViewController) openUserProfile:user:YES];
    

}
-(void)enableInteraction{
    [self.userTappingView addGestureRecognizer:singleTapForOpenProfile];
}
-(void)removeChatView{
    

    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    [UIView animateWithDuration:1.0
                               delay:0
                             options:UIViewAnimationOptionOverrideInheritedOptions
                          animations:^{
                              if(!self.isLayer)
                                [(HomeViewController*)(((MainViewController*)kMainViewController).rootViewController) tView].alpha = 0.0;
                              [self.view setFrame:CGRectMake(self.view.frame.origin.x, screenHeight, self.view.frame.size.width, self.view.frame.size.height)];
                          }
                          completion:^(BOOL finished) {
                              if(!self.isLayer)
                              [(HomeViewController*)(((MainViewController*)kMainViewController).rootViewController) hideView];
                              [self.view removeFromSuperview];
                          }];

    [self dismissViewControllerAnimated:YES completion:nil];

}


#pragma mark MNMBottomPullToRefreshManagerClient

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [pullToRefreshManager_ tableViewScrolled];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView.contentOffset.y >=360.0f)
    {
    }
    else
    {
        if (!([sphBubbledata count] < index-4))
                [pullToRefreshManager_ tableViewReleased];
    }
}

- (void)pullToRefreshTriggered:(MNMPullToRefreshManager *)manager
{
    reloads_++;
    //[self performSelector:@selector(getEarlierMessages) withObject:nil afterDelay:0.0f];
  //  [self performSelectorOnMainThread:@selector(getEarlierMessages) withObject:nil waitUntilDone:NO];
    [self getEarlierMessages];

}

-(void)getEarlierMessages
{
    if(delivered)
        index = index-4;
    NSLog(@"get Earlier Messages And Append to Array");
    
    NSMutableArray *array = [(NHXMPPMessageArchivingCoreDataStorage*)[NHXMPPMessageArchivingCoreDataStorage sharedInstance] loadArchiveMessage:self.chatPartner:index];
        NSMutableArray *previousChat = [[NSMutableArray alloc] init];
        for (XMPPMessageArchiving_Message_CoreDataObject *message in array)
        {
           
            NSLog(@"%@",message.message);
            NSLog(@"%@",message.composing);
            NSLog(@"%@",message.messageStr);
            NSLog(@"%@",message.streamBareJidStr);
            NSLog(@"%@",message.msgId);
            int d = [message.delivered intValue];


            NSDate  *date = message.timestamp;
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            // display in 12HR/24HR (i.e. 11:25PM or 23:25) format according to User Settings
            [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
            NSString *messageTime = [dateFormatter stringFromDate:date];
            
            NSString *str = [self relativeDateStringForDate:date];
            
            
            SPHChatData *feed_data=[[SPHChatData alloc]init];
            feed_data.messageText = message.body;
            feed_data.messageImageURL = message.body;
            feed_data.messageImage = Uploadedimage.image;
            if([str isEqualToString:@"Today"])
                feed_data.messageTime = messageTime;
            else if([str isEqualToString:@"Yesterday"])
                feed_data.messageTime = str;
            else
                feed_data.messageTime = [NSDateFormatter localizedStringFromDate:date
                                                                                               dateStyle:NSDateFormatterShortStyle
                                                                                               timeStyle:nil];
            if([message.outgoing intValue] == 1){
                feed_data.messageType = ktextByme;
                if([message.delivered intValue] == 1)
                    feed_data.messagestatus = @"Delivered";
                else
                    feed_data.messagestatus = @"Failed";


            }
            else{
                feed_data.messageType = ktextbyother;
            
                feed_data.messagestatus = @"Sent";
            }
            [previousChat addObject:feed_data];
            
            
        }
        previousChat = [[previousChat reverseObjectEnumerator] allObjects];
    sphBubbledata = previousChat;
       // sphBubbledata = [[sphBubbledata reverseObjectEnumerator] allObjects];
        // sphBubbledata = [previousChat arrayByAddingObjectsFromArray:sphBubbledata];


        [self.sphChatTable reloadData];
        [self performSelector:@selector(loadfinished) withObject:nil afterDelay:1];
   // if(index == 4 || delivered)
    if(index == 4)
        [self performSelector:@selector(scrollTableview) withObject:nil afterDelay:0.5];

//        [self.sphChatTable scrollRectToVisible:CGRectMake(0, self.sphChatTable.contentSize.height - self.sphChatTable.bounds.size.height, self.sphChatTable.bounds.size.width, self.sphChatTable.bounds.size.height) animated:YES];

         index = index+4;
    delivered = false;
}

-(void)loadfinished
{
    [pullToRefreshManager_ tableViewReloadFinishedAnimated:YES];
    [self.sphChatTable reloadData];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setUpTextFieldforIphone
{
    containerView = [[UIView alloc] initWithFrame:CGRectMake(0,self.view.frame.size.height-40, self.view.frame.size.width, 40)];
    textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(10, 3, self.view.frame.size.width-63, 40)];
    textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    
	textView.minNumberOfLines = 1;
	textView.maxNumberOfLines = 6;
	textView.returnKeyType = UIReturnKeyDefault; //just as an example
	textView.font = [UIFont systemFontOfSize:16.0f];
	textView.delegate = self;
    textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    textView.backgroundColor = [UIColor whiteColor];
    textView.placeholder = @"Message";
    

    // textView.text = @"test\n\ntest";
	// textView.animateHeightChange = NO; //turns off animation
    
    [self.view addSubview:containerView];
	
//    UIImage *rawEntryBackground = [UIImage imageNamed:@"MessageEntryInputField.png"];
//    UIImage *entryBackground = [rawEntryBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
 //   UIImageView *entryImageView = [[UIImageView alloc] initWithImage:entryBackground];
    UIImageView *entryImageView = [[UIImageView alloc] init];
    entryImageView.frame = CGRectMake(40, 0,self.view.frame.size.width-114, 40);
    entryImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
//    UIImage *rawBackground = [UIImage imageNamed:@"MessageEntryBackground.png"];
   // UIImage *background = [rawBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
  //  UIImageView *imageView = [[UIImageView alloc] initWithImage:background];
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0, 0, containerView.frame.size.width, containerView.frame.size.height);
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    // view hierachy
    [containerView setBackgroundColor:[UIColor whiteColor]];
    [containerView addSubview:imageView];
    [containerView addSubview:textView];
    [containerView addSubview:entryImageView];
    
//    UIImage *sendBtnBackground = [[UIImage imageNamed:@"MessageEntrySendButton.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
//    
//    UIImage *camBtnBackground = [[UIImage imageNamed:@"cam.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
//    
//    
//    UIImage *selectedSendBtnBackground = [[UIImage imageNamed:@"MessageEntrySendButton.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
    
	doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	doneBtn.frame = CGRectMake(containerView.frame.size.width - 63, 3, 63, 40);
    doneBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
	[doneBtn setTitle:@"Send" forState:UIControlStateNormal];
    [doneBtn setBackgroundColor:[UIColor whiteColor]];
    
    //[doneBtn setTitleShadowColor:[UIColor colorWithWhite:0 alpha:0.4] forState:UIControlStateNormal];
    //doneBtn.titleLabel.shadowOffset = CGSizeMake (0.0, -1.0);
    //doneBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];

    [doneBtn.titleLabel setFont:[UIFont systemFontOfSize:17 ]];
    
//    [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //UIColor *color = [self colorWithHexString:@"abc9ea"];
    [doneBtn setTitleColor:[UIColor colorWithRed:0.67 green:0.79 blue:0.92 alpha:1.0] forState:UIControlStateNormal];
	[doneBtn addTarget:self action:@selector(resignTextView) forControlEvents:UIControlEventTouchUpInside];
    //[doneBtn setBackgroundImage:sendBtnBackground forState:UIControlStateNormal];
    //[doneBtn setBackgroundImage:selectedSendBtnBackground forState:UIControlStateSelected];
	[containerView addSubview:doneBtn];
    
 
//    
//    UIButton *doneBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
//	doneBtn2.frame = CGRectMake(containerView.frame.origin.x+1,2, 35,40);
//    doneBtn2.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
//	[doneBtn2 setTitle:@"" forState:UIControlStateNormal];
//    
//    [doneBtn2 setTitleShadowColor:[UIColor colorWithWhite:0 alpha:0.4] forState:UIControlStateNormal];
//    doneBtn2.titleLabel.shadowOffset = CGSizeMake (0.0, -1.0);
//    doneBtn2.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
//    
//    [doneBtn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//	[doneBtn2 addTarget:self action:@selector(uploadImage:) forControlEvents:UIControlEventTouchUpInside];
    //[doneBtn2 setBackgroundImage:camBtnBackground forState:UIControlStateNormal];
    
    //[doneBtn2 setBackgroundImage:selectedSendBtnBackground forState:UIControlStateSelected];
    
	//[containerView addSubview:doneBtn2];
    
    //int width = doneBtn.frame.size.width+30;
    int width = doneBtn.frame.size.width+30;
    containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;

    // Top border
    UIView *topBorder = [[UIView alloc]
                         initWithFrame:CGRectMake(0,
                                                  3,
                                                  containerView.frame.size.width+width,
                                                  0.5f)];
    topBorder.backgroundColor = [UIColor colorWithRed:160/255.0f
                                                green:160/255.0f
                                                 blue:160/255.0f
                                                alpha:1.0f];
    [containerView addSubview:topBorder];
    
    
    
    
}

-(void)growingTextViewDidBeginEditing:(HPGrowingTextView *)growingTextView{
    NSLog(@"character enters.");
    [textView becomeFirstResponder];
}

-(void)growingTextViewDidChange:(HPGrowingTextView *)growingTextView{
    if([growingTextView.text length] > 0){
         [doneBtn setTitleColor:[UIColor colorWithRed:3.00/255.00 green:122.00/255.00 blue:254.00/255.00 alpha:1.0] forState:UIControlStateNormal];
      //  [doneBtn setBackgroundColor:[UIColor colorWithRed:3.00/255.00 green:122.00/255.00 blue:254.00/255.00 alpha:1.0] ];

    }else{
         [doneBtn setTitleColor:[UIColor colorWithRed:0.67 green:0.79 blue:0.92 alpha:1.0] forState:UIControlStateNormal];
        [doneBtn setBackgroundColor:[UIColor whiteColor]];

    }
}

-(void)resignTextView{
    if ([textView.text length]<1) {
        chatMessage = textView.text;
    }
    else
    {
        [[self appDelegate] sendMessage:textView.text :msgReceiver];

        chatMessage = textView.text;

        NSString *chat_Message=textView.text;
        textView.text=@"";
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        [formatter setDateFormat:@"hh:mm a"];
       
        NSString *rowNumber=[NSString stringWithFormat:@"%d",(int)sphBubbledata.count];
        
            [self adddBubbledata:ktextByme mtext:chat_Message mtime:[formatter stringFromDate:date] mimage:Uploadedimage.image msgstatus:kStatusSeding];
      //
      //[self performSelector:@selector(messageSent:) withObject:rowNumber afterDelay:0.0];
       // [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(messageSent:) userInfo:rowNumber repeats:NO];
}

}

-(IBAction)messageSent:(NSTimer*)theTimer
{
   // if([self appDelegate].isConnectedToOF)
   // {
       // [[self appDelegate] sendMessage:chatMessage :msgReceiver];
      int n = [[theTimer userInfo] intValue];
        //NSLog(@"row= %@", sender);
    if(n > -1 && n < sphBubbledata.count){
        SPHChatData *feed_data=[[SPHChatData alloc]init];
        feed_data=[sphBubbledata objectAtIndex:n];
        feed_data.messagestatus=@"Sent";
        [sphBubbledata replaceObjectAtIndex:n withObject:feed_data ];

        NSIndexPath* rowToReload = [NSIndexPath indexPathForRow:n inSection:0];
        NSArray* rowsToReload = [NSArray arrayWithObjects:rowToReload, nil];
        [self.sphChatTable reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationNone];
    }
    //}
}


-(IBAction)uploadImage:(id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        UIImagePickerController *imagePicker =
        [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType =
        UIImagePickerControllerSourceTypePhotoLibrary;
        imgPicker.mediaTypes = [NSArray arrayWithObjects:
                                (NSString *) kUTTypeImage,
                                nil];
        imagePicker.allowsEditing = NO;
        [self presentViewController:imagePicker animated:YES completion:nil];
        newMedia = NO;
    }
}

//http://www.binarytribune.com/wp-content/uploads/2013/06/india_binary_options-274x300.png

-(void)imagePickerControllerDidCancel:
(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}



-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info
                           objectForKey:UIImagePickerControllerMediaType];
    
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = [info
                          objectForKey:UIImagePickerControllerOriginalImage];
        
        
        Uploadedimage.image=image;
        
        if (newMedia)
            UIImageWriteToSavedPhotosAlbum(image,
                                           self,
                                           @selector(image:finishedSavingWithError:contextInfo:),
                                           nil);
    }
    else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
		// Code here to support video if enabled
	}
    
   [self performSelector:@selector(uploadToServer) withObject:nil afterDelay:0.0];
}

-(void)uploadToServer
{
//    NSString *chat_Message=textView.text;
//    textView.text=@"";
//    NSDate *date = [NSDate date];
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    
//    [formatter setDateFormat:@"hh:mm a"];
//    
//    NSString *rowNumber=[NSString stringWithFormat:@"%d",(int)sphBubbledata.count];
//    
//    if (sphBubbledata.count%2==0) {
//        [self adddBubbledata:kImageByme mtext:chat_Message mtime:[formatter stringFromDate:date] mimage:Uploadedimage.image msgstatus:kStatusSeding];
//    }else{
//        [self adddBubbledata:kImageByOther mtext:chat_Message mtime:[formatter stringFromDate:date] mimage:Uploadedimage.image msgstatus:kStatusSeding];
//        
//    }
    
    //[self performSelector:@selector(messageSent:) withObject:rowNumber afterDelay:2.0];
}



-(void)image:(UIImage *)image
finishedSavingWithError:(NSError *)error
 contextInfo:(void *)contextInfo
{
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Save failed"
                              message: @"Failed to save image"\
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return sphBubbledata.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SPHChatData *feed_data=[[SPHChatData alloc]init];
    feed_data=[sphBubbledata objectAtIndex:indexPath.row];
    
    if ([feed_data.messageType isEqualToString:ktextByme]||[feed_data.messageType isEqualToString:ktextbyother])
    {
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:16.5]};
        float cellHeight;
        // text
        NSString *messageText = feed_data.messageText;
        //
        CGSize boundingSize = CGSizeMake(message_Width-20, 10000000);
        CGRect cgrect = [messageText boundingRectWithSize:boundingSize
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:attributes
                                                  context:nil];
        CGSize itemTextSize = cgrect.size;
      //  CGSize itemTextSize = [messageText sizeWithFont:[UIFont systemFontOfSize:17]
                                    //  constrainedToSize:boundingSize
                                      //    lineBreakMode:NSLineBreakByWordWrapping];
        
        // plain text
        cellHeight = itemTextSize.height+20;
        
//        if (cellHeight<25) {
//            
//            cellHeight=25;
//        }
//        return cellHeight+40;
//        //return cellHeight+40;
        
        
        
        UITextView *messageTextview=[[UITextView alloc]initWithFrame:CGRectMake(0,17,itemTextSize.width+10, itemTextSize.height+7)];
    
        
        [messageTextview setScrollEnabled:YES];
        
        messageTextview.font=[UIFont fontWithName:@"Helvetica Neue" size:16.0];
        //  messageTextview.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
        messageTextview.dataDetectorTypes=UIDataDetectorTypeAll;
        messageTextview.textAlignment=NSTextAlignmentLeft;
        messageTextview.backgroundColor=[UIColor clearColor];
        // messageTextview.backgroundColor=[UIColor brownColor];
        
        messageTextview.textColor = [UIColor whiteColor];
        messageTextview.text = messageText;
        [messageTextview sizeToFit];
        int k = messageTextview.frame.size.height+55;
        return k;
    }
    else{
        return 180;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.sphChatTable deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SPHChatData *feed_data=[[SPHChatData alloc]init];
    feed_data=[sphBubbledata objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier1 = @"Cell1";
    static NSString *CellIdentifier2 = @"Cell2";
    static NSString *CellIdentifier3 = @"Cell3";
    static NSString *CellIdentifier4 = @"Cell4";
    
    if ([feed_data.messageType isEqualToString:ktextByme])
    {
        SPHBubbleCellOther  *cell = (SPHBubbleCellOther *)[self.sphChatTable dequeueReusableCellWithIdentifier:CellIdentifier1];
        if (cell == nil) {
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SPHBubbleCellOther" owner:self options:nil];
            cell = [topLevelObjects objectAtIndex:0];
        }
        [cell SetCellData:feed_data targetedView:self Atrow:indexPath.row];
        setImageUrl(cell.Avatar_Image,[userinfo valueForKey:kImageUrl]);
        [cell.Avatar_Image setupImageViewer];
        return cell;
    }
    
    if ([feed_data.messageType isEqualToString:ktextbyother])
    {
        SPHBubbleCell  *cell = (SPHBubbleCell *)[self.sphChatTable dequeueReusableCellWithIdentifier:CellIdentifier2];
        if (cell == nil)
        {
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SPHBubbleCell" owner:self options:nil];
            cell = [topLevelObjects objectAtIndex:0];
        }
        //our's image.
        setImageUrl(cell.Avatar_Image,imgUrl);
        [cell SetCellData:feed_data targetedView:self Atrow:indexPath.row];
        [cell.Avatar_Image setupImageViewer];
        return cell;
    }
    
    if ([feed_data.messageType isEqualToString:kImageByme])
    {
        SPHBubbleCellImage  *cell = (SPHBubbleCellImage *)[self.sphChatTable dequeueReusableCellWithIdentifier:CellIdentifier3];
        if (cell == nil)
        {
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SPHBubbleCellImage" owner:self options:nil];
            cell = [topLevelObjects objectAtIndex:0];
        }
        [cell SetCellData:feed_data];
        setImageUrl(cell.Avatar_Image,[userinfo valueForKey:kImageUrl]);
        [cell.Avatar_Image setupImageViewer];
        cell.message_Image.image=Uploadedimage.image;
        [cell.message_Image setupImageViewer];
        return cell;
    }
    
    SPHBubbleCellImageOther  *cell = (SPHBubbleCellImageOther *)[self.sphChatTable dequeueReusableCellWithIdentifier:CellIdentifier4];
    if (cell == nil)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SPHBubbleCellImageOther" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    setImageUrl(cell.Avatar_Image,imgUrl);
    [cell.message_Image setupImageViewer];
    [cell.Avatar_Image setupImageViewer];
     cell.message_Image.imageURL=[NSURL URLWithString:@"http://www.binarytribune.com/wp-content/uploads/2013/06/india_binary_options-274x300.png"];
    return cell;
}


-(void)adddBubbledata:(NSString*)messageType  mtext:(NSString*)messagetext mtime:(NSString*)messageTime mimage:(UIImage*)messageImage  msgstatus:(NSString*)status;
{
    SPHChatData *feed_data=[[SPHChatData alloc]init];
    feed_data.messageText=messagetext;
    feed_data.messageImageURL=messagetext;
    feed_data.messageImage=messageImage;
    feed_data.messageTime=messageTime;
    feed_data.messageType=messageType;
    feed_data.messagestatus=status;
    NSArray *insertIndexPaths = [NSArray arrayWithObject:
                                 [NSIndexPath indexPathForRow:
                                  [sphBubbledata count] // is also 1 now, hooray
                                                    inSection:0]];
    
     [sphBubbledata addObject:feed_data];
    [[self sphChatTable] insertRowsAtIndexPaths:insertIndexPaths
                            withRowAnimation:UITableViewRowAnimationNone];
    [self performSelector:@selector(scrollTableview) withObject:nil afterDelay:0.2];
    NSString *rowNumber=[NSString stringWithFormat:@"%d",(int)(sphBubbledata.count-1)];
    if(![messageType isEqualToString:ktextbyother])
        [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(messageSent:) userInfo:rowNumber repeats:NO];
    //    [self performSelector:@selector(messageSent:) withObject:rowNumber afterDelay:0.0];
}

-(void)adddBubbledataatIndex:(NSInteger)rownum messagetype:(NSString*)messageType  mtext:(NSString*)messagetext mtime:(NSString*)messageTime mimage:(UIImage*)messageImage  msgstatus:(NSString*)status;
{
    SPHChatData *feed_data=[[SPHChatData alloc]init];
    feed_data.messageText=messagetext;
    feed_data.messageImageURL=messagetext;
     feed_data.messageImage=messageImage;
    feed_data.messageTime=messageTime;
    feed_data.messageType=messageType;
    feed_data.messagestatus=status;
    [sphBubbledata  replaceObjectAtIndex:rownum withObject:feed_data];
   
    NSIndexPath* rowToReload = [NSIndexPath indexPathForRow:rownum inSection:0];
    NSArray* rowsToReload = [NSArray arrayWithObjects:rowToReload, nil];
    [self.sphChatTable reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationNone];

    
    
    [self performSelector:@selector(scrollTableview) withObject:nil afterDelay:0.2];
}




-(void)tapRecognized:(UITapGestureRecognizer *)tapGR

{
//    UITextView *theTextView = (UITextView *)tapGR.view;
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:theTextView.tag inSection:0];
//    SPHChatData *feed_data=[[SPHChatData alloc]init];
//    feed_data=[sphBubbledata objectAtIndex:indexPath.row];
//    selectedRow=(int)indexPath.row;
//    [self.sphChatTable reloadData];
//    
//    if ([feed_data.messageType isEqualToString:ktextByme])
//    {
//        SPHBubbleCellOther *mycell=(SPHBubbleCellOther*)[self.sphChatTable cellForRowAtIndexPath:indexPath];
////        UIImageView *bubbleImage=(UIImageView *)[mycell viewWithTag:55];
////        bubbleImage.image=[[UIImage imageNamed:@"Bubbletyperight_highlight"] stretchableImageWithLeftCapWidth:21 topCapHeight:14];
//        
//    }else
//        if ([feed_data.messageType isEqualToString:ktextbyother])
//        {
//            SPHBubbleCell *mycell=(SPHBubbleCell*)[self.sphChatTable cellForRowAtIndexPath:indexPath];
////            UIImageView *bubbleImage=(UIImageView *)[mycell viewWithTag:56];
////            bubbleImage.image=[[UIImage imageNamed:@"Bubbletypeleft_highlight"] stretchableImageWithLeftCapWidth:21 topCapHeight:14];
//        }
//    CGPoint touchPoint = [tapGR locationInView:self.view];
//    [self.popupMenu showInView:self.view atPoint:touchPoint];
//    
//    
//    [self.sphChatTable selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
//    [self.sphChatTable.delegate tableView:self.sphChatTable didSelectRowAtIndexPath:indexPath];
}

-(IBAction)bookmarkClicked:(id)sender
{
    NSLog( @"Book mark clicked at row : %d",selectedRow);
}

-(void)dismissKeyboard
{
    [self.view endEditing:YES];
}


-(void)scrollTableview
{
    if (sphBubbledata.count<3)
        return;
    
    NSInteger lastSection=[self.sphChatTable numberOfSections]-1;
    NSInteger lastRowNumber = [self.sphChatTable numberOfRowsInSection:lastSection]-1;
    NSIndexPath* ip = [NSIndexPath indexPathForRow:lastRowNumber inSection:lastSection];
    [self.sphChatTable scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
}

-(void) keyboardWillShow:(NSNotification *)note
{
    
//    if (sphBubbledata.count>2)
//        [self performSelector:@selector(scrollTableview) withObject:nil afterDelay:0.0];
    
    
    // get keyboard size and loctaion
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    // get a rect for the textView frame
    CGRect containerFrame = containerView.frame;
    containerFrame.origin.y =containerFrame.origin.y - keyboardBounds.size.height;
    [containerView setFrame:containerFrame];
    
    CGRect tableviewframe=self.sphChatTable.frame;
    //tableviewframe.origin.y = self.userView.frame.origin.y;
    tableviewframe.origin.y = self.userView.frame.origin.y+self.userView.frame.size.height;
    tableviewframe.size.height=tableviewframe.size.height - keyboardBounds.size.height;
    //ahmad editing:
  
    //end
    [self.sphChatTable setFrame:tableviewframe];
    
     [self.sphChatTable scrollRectToVisible:CGRectMake(0, self.sphChatTable.contentSize.height - self.sphChatTable.bounds.size.height, self.sphChatTable.bounds.size.width, self.sphChatTable.bounds.size.height) animated:YES];
    

    //+self.userView.frame.size.height
//
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationBeginsFromCurrentState:YES];
//    [UIView setAnimationDuration:[duration doubleValue]];
//    [UIView setAnimationCurve:[curve intValue]];
//    self.view.frame = containerFrame;
//    self.sphChatTable.frame=tableviewframe;
//    
//    [UIView commitAnimations];
    
//    [self.userView setFrame:CGRectMake(self.userView.frame.origin.x, self.userView.frame.origin.y-50, self.userView.frame.size.width, self.userView.frame.size.height)];
//    
//    [self.imageContainer setFrame:CGRectMake(self.imageContainer.frame.origin.x, self.imageContainer.frame.origin.y-50, self.imageContainer.frame.size.width, self.imageContainer.frame.size.height)];
    
    //[self.sphChatTable setFrame:CGRectMake(self.sphChatTable.frame.origin.x, self.sphChatTable.frame.origin.y-50, self.sphChatTable.frame.size.width, self.sphChatTable.frame.size.height)];
	
}

-(void) keyboardWillHide:(NSNotification *)note
{
//    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
//    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
//    CGRect keyboardBounds;
//    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
//    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
//    // get a rect for the textView frame
    CGRect containerFrame = CGRectMake(0,self.view.frame.size.height-40, self.view.frame.size.width, 40);
    
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    CGRect tableviewframe=self.sphChatTable.frame;
    tableviewframe.origin.y = self.userView.frame.origin.y+self.userView.frame.size.height;
    tableviewframe.size.height=tableviewframe.size.height + keyboardBounds.size.height;
    //-self.userView.frame.size.height
    [self.sphChatTable setFrame:tableviewframe];
    
//    CGRect tableviewframe=self.sphChatTable.frame;
//    tableviewframe.size.height+=160;
//    
//    
//    // animations settings
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationBeginsFromCurrentState:YES];
//    [UIView setAnimationDuration:[duration doubleValue]];
//    [UIView setAnimationCurve:[curve intValue]];
//    // set views with new info
//    self.sphChatTable.frame=tableviewframe;
    containerView.frame = containerFrame;
//    // commit animations
//    [UIView commitAnimations];
//    
//    [self.userView setFrame:CGRectMake(self.userView.frame.origin.x, self.userView.frame.origin.y+50, self.userView.frame.size.width, self.userView.frame.size.height)];
//    
//    [self.imageContainer setFrame:CGRectMake(self.imageContainer.frame.origin.x, self.imageContainer.frame.origin.y+50, self.imageContainer.frame.size.width, self.imageContainer.frame.size.height)];
    
//    [self.sphChatTable setFrame:CGRectMake(self.sphChatTable.frame.origin.x, self.sphChatTable.frame.origin.y+50, self.sphChatTable.frame.size.width, self.sphChatTable.frame.size.height)];
	
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
	CGRect r = containerView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
	containerView.frame = r;
}




- (IBAction)endViewedit:(id)sender {
    [self.view endEditing:YES];
}
/////////receiving notification
- (void)receiveNotification:(NSNotification *)notification
{
    if ([[notification name] isEqualToString:@"myNotification"]) { NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"hh:mm a"];
        
        NSMutableDictionary *dict = [notification userInfo];
        NSString *s = [dict valueForKey:kchatPartner];
        NSString *s1 = self.chatPartner;
        if([[dict valueForKey:kchatPartner] isEqualToString: self.chatPartner]){
        [self adddBubbledata:ktextbyother mtext:[dict valueForKey:@"sms"] mtime:[formatter stringFromDate:date] mimage:Uploadedimage.image msgstatus:kStatusSeding];
        }
        
        
    }
}
#pragma mark - dismissview
- (IBAction)dismissView:(id)sender {
//[UIView animateWithDuration:0.5
//                      delay:0
//                    options:UIViewAnimationOptionOverrideInheritedOptions
//                 animations:^{
//                     [self.view setCenter:CGPointMake(self.view.center.x, self.view.frame.size.height)];
//                 }
//                 completion:^(BOOL finished) {
//                     [self.view removeFromSuperview];
//                     //                         [kMainViewController addPanGesture];
//                 }];
}
- (IBAction)showMessages:(id)sender {
    
    
//     ConversationalViewController *messagesVC = [[ConversationalViewController alloc]initWithNibName:@"ConversationalViewController" bundle:nil];
//    [self presentViewController:messagesVC animated:YES completion:nil];
//
}


- (NSString *)relativeDateStringForDate:(NSDate *)date
{
    NSCalendarUnit units = NSCalendarUnitDay | NSCalendarUnitWeekOfYear |
    NSCalendarUnitMonth | NSCalendarUnitYear;
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components1 = [cal components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:[NSDate date]];
    NSDate *today = [cal dateFromComponents:components1];
    
    components1 = [cal components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:date];
    NSDate *thatdate = [cal dateFromComponents:components1];
    // if `date` is before "now" (i.e. in the past) then the components will be positive
    NSDateComponents *components = [[NSCalendar currentCalendar] components:units
                                                                   fromDate:thatdate
                                                                     toDate:today
                                                                    options:0];
    
    if (components.year > 0) {
        return [NSString stringWithFormat:@"%ld years ago", (long)components.year];
    } else if (components.month > 0) {
        return [NSString stringWithFormat:@"%ld months ago", (long)components.month];
    } else if (components.weekOfYear > 0) {
        return [NSString stringWithFormat:@"%ld weeks ago", (long)components.weekOfYear];
    } else if (components.day > 0) {
        if (components.day > 1) {
            return [NSString stringWithFormat:@"%ld days ago", (long)components.day];
        } else {
            return @"Yesterday";
        }
    } else {
        return @"Today";
    }
}
-(void) reloadTable{
    delivered = true;
    //[self performSelectorOnMainThread:@selector(getEarlierMessages) withObject:nil waitUntilDone:NO];
    [self getEarlierMessages];

}

-(void) setProfile{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    BOOL isAvailable = [appDelegate isNetworkAvailable];
    if(isAvailable)
    {

        NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
        
        NSArray *array = [_chatPartner componentsSeparatedByString:@"@"];
        [params setValue:@"" forKey:kapi_key];
        [params setValue:[array objectAtIndex:0] forKey:kid];
        
        [self.view makeToastActivity];
        //[self startPulseLoading];
        GenericFetcher *fetcher = [[GenericFetcher alloc]init];
        
        [fetcher fetchWithUrl:[URLBuilder urlForMethod:kget_profile withParameters:nil]
                   withMethod:POST_REQUEST withParams:params completionBlock:^(NSDictionary *dict) {
                       NSLog(@"%@",dict);
                       int status = [[dict valueForKey:kstatus] intValue];
                       if (status == 1) {
                           
                           [self.userTappingView setUserInteractionEnabled:YES];
                           user = [dict valueForKey:kuser_info];
                           userProfileId = [user valueForKey:kid];
                           self.name.text = [user valueForKey:kname];
                           self.profession.text  = [user valueForKey:kprofession];
                           makeViewRound(_imageContainerView);
                           setImageUrl(self.userPhoto,[user valueForKey:kprofile_image]);
                           CGPoint point = CGPointMake(0 ,0);
                           
                         
                           UIColor *color;
                           float rd = 225.00/255.00;
                           float gr = 177.00/255.00;
                           float bl = 140.00/255.00;
                           
                           AMRatingControl *coloredRatingControl = [[AMRatingControl alloc] initWithLocation:point
                                                                                                  emptyColor:[UIColor colorWithRed:230.00/255.00 green:230.00/255.00 blue:235.00/255.00 alpha:1.0]  
                                                                                                  solidColor:[UIColor colorWithRed:243.00/255.00 green:195.00/255.00 blue:68.00/255.00 alpha:1.0]
                                                                                                andMaxRating:5];
                           [coloredRatingControl setRating:[[user valueForKey:krating] intValue]];
                           [coloredRatingControl setStarSpacing:1];
                           [self.rating addSubview:coloredRatingControl];
                           
                           
                           CLLocation *locA = [[CLLocation alloc] initWithLatitude:[[user valueForKey:klat] floatValue]longitude:[[user valueForKey:klng] floatValue]];
                           CLLocation *locB = [[CLLocation alloc] initWithLatitude:userinfo.latitude longitude:userinfo.longitude];
                           CLLocationDistance distance = [locB distanceFromLocation:locA];
                           double dist = distance/1609.344;
                           _distance.text = [NSString stringWithFormat:@"%.1f miles away",dist];
                           
                           [self.view hideToastActivity];

                           

                           
                       }
                       else
                       {
                           [self.view hideToastActivity];
                           
                           
//                           UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Try Later" message:@"Internet Connection Problem" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//                           [alert show];

                           
                       }
                       
                       
                   }

                   errorBlock:^(NSError *error) {
                       [self.view hideToastActivity];
//                       makeViewRound(_imageContainerView);
//                       self.userPhoto.image = [UIImage imageNamed:@"dummy"];

//                       UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Try Later" message:@"Network error occcured" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//                       [alert show];
                       NSLog(@"no internet");
                       NSLog(@"%@",error);
                   }];
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Try Later" message:@"Internet Connection Problem" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
//        makeViewRound(_imageContainerView);
//        self.userPhoto.image = [UIImage imageNamed:@"dummy"];
    }


}

@end
