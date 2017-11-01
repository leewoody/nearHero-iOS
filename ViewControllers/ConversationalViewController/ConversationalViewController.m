//
//  ConversationalViewController.m
//  nearhero
//
//  Created by Irfan Malik on 6/13/16.
//  Copyright (c) 2016 TBoxSolutionz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "ConversationalViewController.h"
#import "ConversationalTableViewCell.h"
#import "SWTableViewCell.h"
#import "ChatViewController.h"
#import "GenericFetcher.h"
#import "HomeViewController.h"
#import "AppDelegate.h"
#import "URLBuilder.h"
#import "UserInfo.h"
#import "Constants.h"
#import "Toast+UIView.h"
/////////////////XMPP Integration////////////
#import "XMPPFramework.h"
#import "DDLog.h"
#import "XMPPvCardAvatarModule.h"
#import "XMPPvCardCoreDataStorage.h"
#import "XMPPvCardTemp.h"
#import "XMPPvCardTempModule.h"
#import "XMPPvCardCoreDataStorage.h"
#import "XMPPMessageArchiving_Contact_CoreDataObject.h"



// Log levels: off, error, warn, info, verbose
#if DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_INFO;
#endif

/////////////////////////////////////////////
@interface ConversationalViewController ()
{
    UserInfo *userInfo;
}
@end

@implementation ConversationalViewController

{
    
    NSArray *messages;
    NSArray *chatusers;
    NSArray *xmppmsgs;
    NSMutableArray *latestMessages;
    NSString *msgsFrom;
    UIGestureRecognizer *singleFingertapper ;

}



- (AppDelegate *)appDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

-(void)loadMessages{
    //[self.view makeToastActivity];
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    BOOL isAvailable = [appDelegate isNetworkAvailable];
    if(isAvailable){
        NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
        GenericFetcher *fetcher = [[GenericFetcher alloc]init];
        [fetcher fetchWithUrl:[URLBuilder urlForMethod:kget_user_messages withParameters:nil]
                   withMethod:POST_REQUEST withParams:params completionBlock:^(NSDictionary *dict){
                       
                       NSLog(@"%@",dict);
                       int status = [[dict valueForKey:kstatus] intValue];
                       if (status == 1) {
                           NSLog(@"%@",dict);

                             messages = [dict valueForKey:kmessages];
                             [self.tabel reloadData];
                       }
                       else{
                           UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:[dict valueForKey:kerror] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                           [alert show];
                           //[self.view hideToastActivity];
                       }
                       //[self.view hideToastActivity];
                   }
                   errorBlock:^(NSError *error) {
                       //[self.view hideToastActivity];
                       // TODO: Abeera stop progress spinner here for failure response
                       NSLog(@"no internet");
                       NSLog(@"%@",error);
                       //[self.view hideToastActivity];
                   }];
        }

}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    latestMessages = [[NSMutableArray alloc]init];
    latestMessages = [(NHXMPPMessageArchivingCoreDataStorage*)[NHXMPPMessageArchivingCoreDataStorage sharedInstance]
                      loadLatestMessage:0];
   // [self performSelectorOnMainThread:@selector(reloadLatestMessages) withObject:nil waitUntilDone:NO];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:@"ReloadLatestMessages"
                                               object:nil];

    singleFingertapper = [[UITapGestureRecognizer alloc]
              initWithTarget:self action:@selector(dismissView:)];
    singleFingertapper.cancelsTouchesInView = NO;
    [self.transperentView addGestureRecognizer:singleFingertapper];
    [self loadMessages];
    self.navigationController.navigationBarHidden = true;
    [NSTimer scheduledTimerWithTimeInterval:5.0f
                                     target:self
                                   selector:@selector(reloadLatestMessagesOnMainTraed)
                                   userInfo:nil
                                    repeats:YES];

    
}
-(void)reloadLatestMessagesOnMainTraed{
    [self reloadLatestMessages];
//[self performSelectorOnMainThread:@selector(reloadLatestMessages) withObject:nil waitUntilDone:NO];
}

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.9960f green:0.247f blue:0.207 alpha:1.0f]
                                                title:@"Trash"];

    return rightUtilityButtons;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)removeMessagesView{
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Title" message:@"inside 4s condition" preferredStyle:UIAlertControllerStyleAlert];
//    
//            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
//            [alertController addAction:ok];
//            

    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    
//    [UIView
//     animateWithDuration:0.2
//     delay:0.0
//     options:nil
//     animations:^{
//         self.transperentView.alpha = 0.0;
//     }
     //completion:^(BOOL finished){
         [UIView animateWithDuration:1.0
                               delay:0
                             options:UIViewAnimationOptionOverrideInheritedOptions
                          animations:^{
                              [(HomeViewController*)(((MainViewController*)kMainViewController).rootViewController) tView].alpha = 0.0;
                              [self.view setFrame:CGRectMake(self.view.frame.origin.x, screenHeight,self.view.frame.size.width,self.view.frame.size.height)];
                              
                          }
                          completion:^(BOOL finished) {
                              [(HomeViewController*)(((MainViewController*)kMainViewController).rootViewController) hideView];
                              [self.view removeFromSuperview];
                              
                          }];
         
    // }];

    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Title" message:@"inside 4s condition" preferredStyle:UIAlertControllerStyleAlert];
    
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:ok];
    

    // Dispose of any resources that can be recreated.
}




- (IBAction)dismissView:(id)sender {
    
    [self removeMessagesView];
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
//////////////////////////////XMPP Integration///////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark NSFetchedResultsController
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    //Abeera code...
    //[[self tabel] reloadData];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark UITableViewCell helpers
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)configurePhotoForCell:(UITableViewCell *)cell user:(XMPPUserCoreDataStorageObject *)user
{
    // Our xmppRosterStorage will cache photos as they arrive from the xmppvCardAvatarModule.
    // We only need to ask the avatar module for a photo, if the roster doesn't have it.
    
    if (user.photo != nil)
    {
        cell.imageView.image = user.photo;
    }
    else
    {
        NSData *photoData = [[[self appDelegate] xmppvCardAvatarModule] photoDataForJID:user.jid];
        
        if (photoData != nil)
            cell.imageView.image = [UIImage imageWithData:photoData];
        else
            cell.imageView.image = [UIImage imageNamed:@"defaultPerson"];
    }
}

/////////////////////////////////////////////////////////////////////////////

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [latestMessages count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (ConversationalTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"ConversationalTableViewCell";
    
    ConversationalTableViewCell *cell = (ConversationalTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ConversationalTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
        makeViewRound(cell.imgContainer);
        cell.rightUtilityButtons = [self rightButtons];
        cell.accessoryType = UITableViewCellAccessoryNone;
        [cell setDelegate:self];
        
    }
    
        XMPPMessageArchiving_Contact_CoreDataObject *user_latest_chat = [latestMessages objectAtIndex:indexPath.row];
        XMPPJID *jid  =  [XMPPJID jidWithString:user_latest_chat.bareJidStr];
        XMPPvCardTemp *vCard =[[self appDelegate].xmppvCardTempModule vCardTempForJID:jid shouldFetch:YES];
    
    
        cell.name.text = [[vCard elementForName:kname] stringValue];
        NSDate  *date = user_latest_chat.mostRecentMessageTimestamp;

        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        NSString *messageTime = [dateFormatter stringFromDate:date];
        
        NSString *str = [self relativeDateStringForDate:date];
        
        if([str isEqualToString:@"Today"])
            cell.dt.text = messageTime;
        else if([str isEqualToString:@"Yesterday"])
             cell.dt.text = @"Yesterday";
        else
            cell.dt.text = [NSDateFormatter localizedStringFromDate:date
                                                          dateStyle:NSDateFormatterShortStyle
                                                          timeStyle:nil];
    
        setImageUrl(cell.profileImage, [[vCard elementForName:kprofile_image]stringValue]);
        NSArray *brokenByLines=[user_latest_chat.mostRecentMessageBody componentsSeparatedByString:@"\n"];
    
        NSString *sms = [brokenByLines objectAtIndex:0];
    if( [sms length] > 34 ){
        
        cell.latestMessage.text = [NSString stringWithFormat:@"%@...",[user_latest_chat.mostRecentMessageBody substringToIndex:34]];
    }
    else{
        cell.latestMessage.text = sms;
    }
    
    //separator line
    
    //[self.tabel setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    //int width = cell.frame.size.width;
//    [self.tabel setSeparatorStyle:UITableViewCellSeparatorStyleNone];
//    UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(28, cell.frame.size.height-0.4, cell.bounds.size.width, 0.5)];/// change size as you need.
//    //cell.frame.size.width
//    separatorLineView.backgroundColor = [UIColor colorWithRed:0.90 green:0.91 blue:0.92 alpha:1.0];// you can also put image here
//    [cell.contentView addSubview:separatorLineView];
    
    //end
        return cell;

   }

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[self removeMessagesView];
    [self.tabel setUserInteractionEnabled:NO];
    NSTimer *aTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(enableIneraction) userInfo:nil repeats:NO];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    XMPPMessageArchiving_Contact_CoreDataObject *user_latest_chat = [latestMessages objectAtIndex:indexPath.row];
    NSString *chatPartner = user_latest_chat.bareJidStr;
    [(HomeViewController*)(((MainViewController*)kMainViewController).rootViewController)showChatView:chatPartner];

    
}
-(void)enableIneraction{
    [self.tabel setUserInteractionEnabled:YES];
}
#pragma mark - SWTableViewDelegate

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
            NSLog(@"check button was pressed");
            break;
        case 1:
            NSLog(@"clock button was pressed");
            break;
        case 2:
            NSLog(@"cross button was pressed");
            break;
        case 3:
            NSLog(@"list button was pressed");
        default:
            break;
    }
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    
    NSIndexPath *indexPath = [self.tabel indexPathForCell:cell];
    userInfo = [UserInfo instance];
    switch (index) {
            
        case 0:
        {
            XMPPMessageArchiving_Contact_CoreDataObject *user_latest_chat = [latestMessages objectAtIndex:indexPath.row];

            
            NSString *userJid = user_latest_chat.bareJidStr;
            NSString *userJid1 = [NSString stringWithFormat: @"%@@%@",[userInfo valueForKey:kuu_id],@"nea.nearhero.com"];
            
            NSFetchRequest *messagesCoreD = [[NSFetchRequest alloc] init];
            NSManagedObjectContext *context=[[self appDelegate].xmppMessageArchivingStorage mainThreadManagedObjectContext];
            NSEntityDescription *messageEntity = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Contact_CoreDataObject" inManagedObjectContext:context];
            [messagesCoreD setEntity:messageEntity];
            [messagesCoreD setIncludesPropertyValues:NO]; //only fetch the managedObjectID
            NSString *predicateFrmt = @"bareJidStr == %@";
            NSString *predicateFrmt1 = @"streamBareJidStr == %@";
            NSPredicate *predicateName = [NSPredicate predicateWithFormat:predicateFrmt,userJid];
            NSPredicate *predicateSSID = [NSPredicate predicateWithFormat:predicateFrmt1,userJid1];
            
            NSArray *subPredicates = [NSArray arrayWithObjects:predicateName, predicateSSID, nil];
            
            NSPredicate *orPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:subPredicates];
            
            messagesCoreD.predicate = orPredicate;
            NSError * error = nil;
            NSArray * messages = [context executeFetchRequest:messagesCoreD error:&error];
            //error handling goes here
            [self.tabel reloadData];
            for (NSManagedObject * message in messages)
            {
                [context deleteObject:message];
                latestMessages = [(NHXMPPMessageArchivingCoreDataStorage*)[NHXMPPMessageArchivingCoreDataStorage sharedInstance]
                                  loadLatestMessage:0];
                [self.tabel reloadData];
            }
            NSEntityDescription *messageEntity1 = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Message_CoreDataObject" inManagedObjectContext:context];
            [messagesCoreD setEntity:messageEntity1];
            [messagesCoreD setIncludesPropertyValues:NO]; //only fetch the managedObjectID
            messagesCoreD.predicate = orPredicate;
            NSArray * messages1 = [context executeFetchRequest:messagesCoreD error:&error];
            //error handling goes here
            latestMessages = [(NHXMPPMessageArchivingCoreDataStorage*)[NHXMPPMessageArchivingCoreDataStorage sharedInstance]
                              loadLatestMessage:0];
            [self.tabel reloadData];
            for (NSManagedObject * message in messages1)
            {
                [context deleteObject:message];
                latestMessages = [(NHXMPPMessageArchivingCoreDataStorage*)[NHXMPPMessageArchivingCoreDataStorage sharedInstance]
                                  loadLatestMessage:0];
                [self.tabel reloadData];
            }
            
            NSError *saveError = nil;
            [context save:&saveError];
            break;
        }
               default:
            break;
    }
}
- (void)receiveNotification:(NSNotification *)notification{
    if ([[notification name] isEqualToString:@"ReloadLatestMessages"]){
        [self reloadLatestMessages];
      //  [self performSelectorOnMainThread:@selector(reloadLatestMessages) withObject:nil waitUntilDone:NO];

//        latestMessages = [(NHXMPPMessageArchivingCoreDataStorage*)[NHXMPPMessageArchivingCoreDataStorage sharedInstance] loadLatestMessage:0];
//        [self.tabel reloadData];
    }
}
-(void)reloadLatestMessages{

    latestMessages = [(NHXMPPMessageArchivingCoreDataStorage*)[NHXMPPMessageArchivingCoreDataStorage sharedInstance] loadLatestMessage:0];
    [self.tabel reloadData];
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






@end
