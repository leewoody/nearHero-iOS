//
//  SPHViewController.h
//  SPHChatBubble
//
//  Created by Siba Prasad Hota  on 10/18/13.
//  Copyright (c) 2013 Wemakeappz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPGrowingTextView.h"
#import "MNMPullToRefreshManager.h"
#import "BaseViewController.h"
//#import "NHXMPPMessageArchivingCoreDataStorage.h"
#import <CoreData/CoreData.h>
@class QBPopupMenu;

@interface SPHViewController : BaseViewController<HPGrowingTextViewDelegate,UIGestureRecognizerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MNMPullToRefreshManagerClient,NSFetchedResultsControllerDelegate>
{
     NSMutableArray *sphBubbledata;
     UIView *containerView;
     HPGrowingTextView *textView;
     NSFetchedResultsController *fetchedResultsController;

     int selectedRow;
     BOOL newMedia;
}
@property (strong,nonatomic) NSString *user_id;
@property (weak, nonatomic) IBOutlet UIView *transView;
@property (weak, nonatomic) IBOutlet UIView *transperentView;
@property (strong, nonatomic) IBOutlet UIView *secondTransView;
- (IBAction)showMessages:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *rating;
@property (nonatomic, readwrite, assign) NSUInteger reloads;
@property (strong, nonatomic) IBOutlet UIImageView *userPhoto;
@property (strong, nonatomic) IBOutlet UIView *userView;
@property (nonatomic, readwrite, strong) MNMPullToRefreshManager *pullToRefreshManager;
@property (strong, nonatomic) IBOutlet UIView *imageContainer;
@property (strong, nonatomic) IBOutlet UIView *userTappingView;
//@property (weak, nonatomic) IBOutlet UIView *tview;

@property (weak, nonatomic) IBOutlet UIImageView *Uploadedimage;
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (nonatomic, strong) QBPopupMenu *popupMenu;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *distance;
@property (weak, nonatomic) IBOutlet UITableView *sphChatTable;
@property (strong, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UIView *imageContainerView;
@property (strong, nonatomic) IBOutlet UILabel *profession;
@property (nonatomic, retain) UIImagePickerController *imgPicker;
@property (nonatomic, retain) NSString *chatPartner;
//@property (nonatomic, retain)NHXMPPMessageArchivingCoreDataStorage *nearHeroStorage;
- (IBAction)endViewedit:(id)sender;
- (void) handleURL:(NSURL *)url;

@end
