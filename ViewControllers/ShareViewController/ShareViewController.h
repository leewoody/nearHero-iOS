//
//  ShareViewController.h
//  nearhero
//
//  Created by apple on 9/20/16.
//  Copyright © 2016 TBoxSolutionz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareViewCell.h"
#import "GenericFetcher.h"
#import "BaseViewController.h"

static GenericFetcher *fetcher;
@interface ShareViewController : BaseViewController{
//     GenericFetcher *fetcher ;
}
@property (weak, nonatomic) IBOutlet UITableView *contactTable;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *imageContainer;
@property (strong, nonatomic) IBOutlet UIView *transView;
@property (weak, nonatomic) IBOutlet UIButton *inviteBtn;
- (IBAction)inviteBtnAction:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *friendsList;
-(NSMutableArray*)getUserNames;
- (IBAction)inviteButton:(id)sender;
//@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UIView *rightView;
@property (strong, nonatomic) IBOutlet UIView *leftView;
@property (strong, nonatomic) UIActivityViewController *activityViewController;
@property (weak, nonatomic) IBOutlet UILabel *noCantactLbl;

- (IBAction)shareButtonAction:(id)sender;

@end
