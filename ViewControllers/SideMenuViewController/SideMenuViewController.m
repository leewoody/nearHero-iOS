    //
//  SideMenuViewController.m
//  Pro Ptv Sports
//
//  Created by Irfan Malik on 6/2/16.
//  Copyright © 2016 Techvista. All rights reserved.
//

#import "SideMenuViewController.h"
#import "ShareViewController.h"
#import "SideMenuTableViewCell.h"
#import "AppDelegate.h"
#import "ProfileViewController.h"
#import "ConversationalViewController.h"
#import "SettingViewController.h"
#import "InviteViewController.h"
#import "HomeViewController.h"
#import "GenericFetcher.h"
#import "Constants.h"
#import "URLBuilder.h"
#import "UserInfo.h"
#import <QuartzCore/QuartzCore.h>
#import <sys/utsname.h>
#include <sys/types.h>
#include <sys/sysctl.h>
////////////////xmpp
#import "XMPPFramework.h"
#import "DDLog.h"
#import "XMPPvCardAvatarModule.h"
#import "XMPPvCardCoreDataStorage.h"
#import "XMPPvCardTemp.h"
#import "XMPPvCardTempModule.h"
#import "XMPPvCardCoreDataStorage.h"
#import "XMPPMessageArchiving_Contact_CoreDataObject.h"
#import "XMPPUserCoreDataStorageObject.h"


//for message sending
#import "InviteHelper.h"
#import <MessageUI/MessageUI.h>
#import "MessageViewController.h"
#import "MessageViewController.h"

#if DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_INFO;
#endif
@interface SideMenuViewController () <MFMailComposeViewControllerDelegate>
{
    NSArray *messages;
    NSMutableArray *latestMessages;
    UserInfo *userinfo;
    NSArray *chatusers;
    BOOL *status;
    // NSArray *titles;
    //NSArray *selectors;
}
@end

@implementation SideMenuViewController
- (AppDelegate *)appDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

-(void)loadRecentMessages{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    BOOL isAvailable = [appDelegate isNetworkAvailable];
    if(isAvailable){
        NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
        NSError* jsonError =nil;
        GenericFetcher *fetcher = [[GenericFetcher alloc]init];
        [fetcher fetchWithUrl:[URLBuilder urlForMethod:kget_user_messages withParameters:nil]
                   withMethod:POST_REQUEST withParams:params completionBlock:^(NSDictionary *dict){
                       
                       NSLog(@"%@",dict);
                       int status = [[dict valueForKey:kstatus] intValue];
                       if (status == 1) {
                           messages = [dict valueForKey:kmessages];
                           [self.table reloadData];
                       }
                       else{
                           UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:[dict valueForKey:kerror] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                           [alert show];
                           //[self.view hideToastActivity];
                       }
                   }
                   errorBlock:^(NSError *error) {
                       //[self.view hideToastActivity];
                       // TODO: Abeera stop progress spinner here for failure response
                       NSLog(@"no internet");
                       NSLog(@"%@",error);
                   }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(openProfile)];
    [self.userView addGestureRecognizer:singleFingerTap];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //by ahmad, to change profession in tableview...
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeProfession:)
                                                 name:@"changeProfession" object:nil];
    //end...
    
    //by ahmad, to change profile image....
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(change:)
                                                 name:@"change" object:nil];
    //end...
    [[self appDelegate] setDelegate:self];
    _onlineBuddies = [[NSMutableArray alloc] init];
    
//    [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
//
    latestMessages = [(NHXMPPMessageArchivingCoreDataStorage*)[NHXMPPMessageArchivingCoreDataStorage sharedInstance] loadLatestMessage:3];
//    }];
   // [self performSelectorOnMainThread:@selector(reloadLatestMessages) withObject:nil waitUntilDone:NO];
    
    [NSTimer scheduledTimerWithTimeInterval:5.0f
                                     target:self
                                   selector:@selector(reloadLatestMessagesOnMainThread)
                                   userInfo:nil
                                    repeats:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:@"RefreshTable"
                                               object:nil];
    
    userinfo = [UserInfo instance];
    setImageUrl(self.profileImage, userinfo.imageUrl);
   
    self.profileImage.layer.cornerRadius=self.profileImage.frame.size.height/2;
    //self.profileImage.layer.borderWidth=2.0;
    self.profileImage.layer.masksToBounds = YES;
    self.userName.adjustsFontSizeToFitWidth = YES;
    self.profession.adjustsFontSizeToFitWidth = YES;
    //makeViewRound(self.imgContainer);
    self.profession.text = [userinfo valueForKey:kprofession];
    
    self.userName.text = userinfo.name;
    
    //set delegate for table to self...
    //self.table.delegate = self;
    [self.table setDelegate:self];
    [self.table setDataSource:self];
    //end...
    
    self.navigationController.navigationBarHidden = true;
}

//for changing profile image...
-(void) change:(NSNotification *) notification{
    UserInfo *userinfo = [UserInfo instance];
   setImageUrl(self.profileImage, userinfo.imageUrl);
}

//end...

//for changing profile image...
-(void) changeProfession:(NSNotification *) notification{
    UserInfo *userinfo = [UserInfo instance];
    self.profession.text = [userinfo valueForKey:kprofession];
}

//end...

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UserInfo *userinfo = [UserInfo instance];

    
//    UserInfo *userInfo = [UserInfo instance];
//    makeViewRound(_iv_containerView);
//    setImageUrl(self.iv_profile,[userInfo valueForKey:kImageUrl]);
//    [_lbl_name setText:[userInfo valueForKey:kname]];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return [messages count];
    return [latestMessages count];

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *simpleTableIdentifier = @"SideMenuTableViewCell";
    
    SideMenuTableViewCell *cell = (SideMenuTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SideMenuTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        makeViewRound(cell.imageContainer);
        
    }
    
    cell.msgImage.image = [UIImage imageNamed:@"shape"];

    XMPPMessageArchiving_Contact_CoreDataObject *user_latest_chat = [latestMessages objectAtIndex:indexPath.row];
    XMPPJID *jid  =  [XMPPJID jidWithString:user_latest_chat.bareJidStr];
    XMPPvCardTemp *vCard =[[self appDelegate].xmppvCardTempModule vCardTempForJID:jid shouldFetch:YES];
    setImageUrl(cell.profileImageView, [[vCard elementForName:kprofile_image]stringValue]);
       cell.lbl.text = user_latest_chat.mostRecentMessageBody;
    

     if(  [_onlineBuddies indexOfObject:user_latest_chat.bareJidStr] != NSNotFound)
     {
               cell.onlineImage.image = [UIImage imageNamed:@"green"];

     }
    else
    {
              cell.onlineImage.image = [UIImage imageNamed:@"grey"];
    }
       return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    XMPPMessageArchiving_Contact_CoreDataObject *user_latest_chat = [latestMessages objectAtIndex:indexPath.row];
    NSString *chatPartner = user_latest_chat.bareJidStr;
    [(HomeViewController*)(((MainViewController*)kMainViewController).rootViewController)showUserChat:chatPartner];

    
    //for message sending
   // NSString *selectedFile = [_file objectAtIndex:indexPath.row];
    //NSString *selectedFile;
    //[self showSMS:selectedFile];
    
    //end
    
//        AppDelegate *app = [UIApplication sharedApplication].delegate;
//        [[app rootViewController] showCenterPanelAnimated:YES];
//        ConversationalViewController *conversationalVC = [[ConversationalViewController     alloc]initWithNibName:@"ConversationalViewController" bundle:nil];
//        UINavigationController *navController=[[UINavigationController alloc]initWithRootViewController:conversationalVC];
//            [[app rootViewController] setCenterPanel:navController];
    
}
- (void)newBuddyOnline:(NSString *)buddyName {
    
        [self.onlineBuddies addObject:buddyName];
        [self.table reloadData];
}

- (void)buddyWentOffline:(NSString *)buddyName {
    
        [self.onlineBuddies removeObject:buddyName];
        [self.table reloadData];
}

- (IBAction)viewMyProfile:(UIButton *)sender {
    [(HomeViewController*)(((MainViewController*)kMainViewController).rootViewController)
     viewProfileScreen];
    
}

-(void)openProfile{
    [(HomeViewController*)(((MainViewController*)kMainViewController).rootViewController)
     viewProfileScreen];
}

- (IBAction)showSettingVC:(UIButton *)sender {
    
    [(HomeViewController*)(((MainViewController*)kMainViewController).rootViewController) viewSettingScreen];
   
}
-(void) reloadLatestMessagesOnMainThread{
   // [self performSelectorOnMainThread:@selector(reloadLatestMessages) withObject:nil waitUntilDone:NO];
    [self reloadLatestMessages];

}
- (void)receiveNotification:(NSNotification *)notification
{
    if ([[notification name] isEqualToString:@"RefreshTable"])
    {
        
     //   [self performSelectorOnMainThread:@selector(reloadLatestMessages) withObject:nil waitUntilDone:NO];

        latestMessages = [(NHXMPPMessageArchivingCoreDataStorage*)[NHXMPPMessageArchivingCoreDataStorage sharedInstance] loadLatestMessage:3];
        [self.table reloadData];

    }
}

-(void)reloadLatestMessages{
    latestMessages = [(NHXMPPMessageArchivingCoreDataStorage*)[NHXMPPMessageArchivingCoreDataStorage sharedInstance] loadLatestMessage:3];
    [self.table reloadData];
}

- (IBAction)showInviteVC:(id)sender {
    
    [(HomeViewController*)(((MainViewController*)kMainViewController).rootViewController) viewinvitescreen:NO];
    
}

- (IBAction)viewAllMessages:(id)sender{
    [(HomeViewController*)(((MainViewController*)kMainViewController).rootViewController) viewAllMessages];
}
#pragma mark NSFetchedResultsController
- (NSFetchedResultsController *)fetchedResultsController
{
    if (fetchedResultsController == nil)
    {
        NSManagedObjectContext *moc = [[self appDelegate] managedObjectContext_roster];
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"XMPPUserCoreDataStorageObject"
                                                  inManagedObjectContext:moc];
        
         NSSortDescriptor *sd1 = [[NSSortDescriptor alloc] initWithKey:@"sectionNum" ascending:YES];
        NSSortDescriptor *sd2 = [[NSSortDescriptor alloc] initWithKey:@"displayName" ascending:YES];
        
       NSArray *sortDescriptors = @[sd1, sd2];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        [fetchRequest setEntity:entity];
        [fetchRequest setSortDescriptors:sortDescriptors];
        [fetchRequest setFetchBatchSize:10];

        fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                       managedObjectContext:moc
                                                                         sectionNameKeyPath:@"sectionNum"
                                                                                  cacheName:nil];
        [fetchedResultsController setDelegate:self];
        
        
        NSError *error = nil;
        if (![fetchedResultsController performFetch:&error])
        {
            DDLogError(@"Error performing fetch: %@", error);
        }
        
    }
    
    return fetchedResultsController;
}
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [[self table] reloadData];
}

-(void)isUserAvailable:(NSString*)jid
{
    NSString *url = [NSString stringWithFormat:@"http://nearhero.com:9090/plugins/presence/status?jid=%@%@",jid,@"&type=text"];

    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]  queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if(connectionError==nil)
            NSLog(@"plugins response ===%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        if([[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] isEqualToString: @"Unavailable"])
        {
            status = NO;
            [self.table reloadData];
            
        }
        else
        {
             status = YES;
            [self.table reloadData];
        }
        
    }];
  
}


@end
