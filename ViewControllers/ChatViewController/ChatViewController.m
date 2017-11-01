//
//  ChatViewController.m
//  nearhero
//
//  Created by Irfan Malik on 6/13/16.
//  Copyright (c) 2016 TBoxSolutionz. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import <sys/utsname.h>
#include <sys/types.h>
#include <sys/sysctl.h>
#import "GenericFetcher.h"
#import "Constants.h"
#import "URLBuilder.h"
#import "UserInfo.h"

#import "ChatViewController.h"

// my code
#import "SPHChatData.h"
#import "SPHMacro.h"
#import "SPHViewController.h"

@interface ChatViewController ()

@end

@implementation ChatViewController{
    UIGestureRecognizer *singleFingertapper ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UserInfo *userInfo = [UserInfo instance];
    self.name.text = userInfo.name;
    //self.profession.text = userInfo.profession;
    setImageUrl(self.userPhoto, userInfo.imageUrl);
    makeViewRound(self.imageContainer);
    //Abeera code
//    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate ;
//    [appDelegate sendMessage:@"I'm from nearhero" :@"abeera"];
    
//    singleFingertapper = [[UITapGestureRecognizer alloc]
//                          initWithTarget:self action:@selector(dismissView:)];
//    singleFingertapper.cancelsTouchesInView = NO;
    //[self.view addGestureRecognizer:singleFingertapper];
        SPHViewController *sPHViewController = [[SPHViewController alloc] initWithNibName:@"SPHViewController" bundle:nil];
    
    [sPHViewController.view setFrame:CGRectMake(0, self.chattingView.frame.size.height, self.chattingView.frame.size.width, self.chattingView.frame.size.height)];
    
     [sPHViewController.view setCenter:CGPointMake(self.chattingView.center.x, self.chattingView.center.y)];
//
//    
    [self.chattingView addSubview:sPHViewController.sphChatTable];
    
    //UITableView *table = sPHViewController.sphChatTable;
    
    //if I remove the following two lines, the data remains inconsistent and it vanishes.
    self.chattingView.dataSource = sPHViewController.sphChatTable.dataSource;
    self.chattingView.delegate = sPHViewController.sphChatTable.delegate;
    
    
    //[self.chattingView addSubview:sPHViewController.sphChatTable];
    
//    self.chattingView.dataSource = sPHViewController.sphChatTable.dataSource;
//    self.chattingView.delegate = sPHViewController.sphChatTable.delegate;
    // Do any additional setup after loading the view from its nib.
}

//- (IBAction)dismissView:(id)sender {
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
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//This is my code....

//-(void)adddBubbledata:(NSString*)messageType  mtext:(NSString*)messagetext mtime:(NSString*)messageTime msgstatus:(NSString*)status;
//{
//    SPHChatData *feed_data=[[SPHChatData alloc]init];
//    feed_data.messageText=messagetext;
////    feed_data.messageImageURL=messagetext;
////    feed_data.messageImage=messageImage;
//    feed_data.messageTime=messageTime;
//    feed_data.messageType=messageType;
//    feed_data.messagestatus=status;
//    
//    
//    NSArray *insertIndexPaths = [NSArray arrayWithObject:
//                                 [NSIndexPath indexPathForRow:
//                                  [sphBubbledata count] // is also 1 now, hooray
//                                                    inSection:0]];
//    
//    [sphBubbledata addObject:feed_data];
//    
//    [[self chattingView] insertRowsAtIndexPaths:insertIndexPaths
//                               withRowAnimation:UITableViewRowAnimationNone];
//    
//    [self performSelector:@selector(scrollTableview) withObject:nil afterDelay:0.1];
//}
//
//-(void)setUpDummyMessages
//{
//    NSDate *date = [NSDate date];
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"hh:mm a"];
//    NSString *rowNumber=[NSString stringWithFormat:@"%d",(int)sphBubbledata.count];
//    [self adddBubbledata:ktextByme mtext:@"Hi!!!!!!!" mtime:[formatter stringFromDate:date] msgstatus:kStatusSeding];
//    [self performSelector:@selector(messageSent:) withObject:rowNumber afterDelay:1.0];
////    [self adddBubbledata:ktextbyother mtext:@"Heloo!!!!!" mtime:[formatter stringFromDate:date] mimage:Uploadedimage.image msgstatus:kStatusSent];
////    rowNumber=[NSString stringWithFormat:@"%d",(int)sphBubbledata.count];
////    [self adddBubbledata:ktextByme mtext:@"How are you doing today?" mtime:[formatter stringFromDate:date] mimage:Uploadedimage.image msgstatus:kStatusSeding];
////    [self performSelector:@selector(messageSent:) withObject:rowNumber afterDelay:1.5];
////    [self adddBubbledata:ktextbyother mtext:@"I'm doing great! what abt you?" mtime:[formatter stringFromDate:date] mimage:Uploadedimage.image msgstatus:kStatusSent];
//}
//





















//- (IBAction)moveBack:(id)sender {
//    [self.navigationController popViewControllerAnimated:YES];
//}
//-(void)removeChatView{
//    //    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Title" message:@"inside 4s condition" preferredStyle:UIAlertControllerStyleAlert];
//    //
//    //            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
//    //            [alertController addAction:ok];
//    //
//    
//    [UIView animateWithDuration:0.5
//                          delay:0
//                        options:UIViewAnimationOptionOverrideInheritedOptions
//                     animations:^{
//                         [self.view setCenter:CGPointMake(self.view.center.x, self.view.frame.size.height)];
//                     }
//                     completion:^(BOOL finished) {
//                         [self.view removeFromSuperview];
//                         //                         [kMainViewController addPanGesture];
//                     }];
//}

- (IBAction)showMessages:(id)sender {
}
@end
