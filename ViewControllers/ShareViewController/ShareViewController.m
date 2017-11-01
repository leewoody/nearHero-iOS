
//  ShareViewController.m
//  nearhero
//
//  Created by apple on 9/20/16.
//  Copyright © 2016 TBoxSolutionz. All rights reserved.
//

#import "ShareViewController.h"
#import "UserInfo.h"
#import "Constants.h"
#import "InviteHelper.h"
#import "ShareViewCell.h"

#import "URLBuilder.h"
#import "Utility.h"
#import "GenericFetcher.h"
#import "UserInfo.h"
#import "Constants.h"
#import "UserSettings.h"
#import "Toast+UIView.h"
#import "UIViewController+MJPopupViewController.h"
#import "HomeViewController.h"
#import "AppDelegate.h"
#import <AddressBook/ABAddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

//for sms sending

#import "MessageViewController.h"
#import <MessageUI/MessageUI.h>
#import "MessageViewController.h"
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

@import Contacts;
@import ContactsUI;


@interface ShareViewController ()<UITableViewDelegate, UITableViewDataSource,MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate>
{
    UserInfo *userInfo;
}
@end

@implementation ShareViewController{
    NSMutableArray* arr;
    NSMutableArray* names;
    NSMutableArray* emails;
    NSString* friendNames;
    NSMutableArray* friendNamesArray;
    NSMutableArray* emailsAndNames;
    NSMutableArray* phoneAndNames;
    NSMutableArray* invitationEmailArray;
    NSMutableArray* invitationPhoneArray;
    NSMutableArray* phoneArray;
    NSMutableArray* invitationUserArray; //for showing user names on tableview
    NSMutableArray* emailswithnames;
    NSMutableArray *contacts;
    NSMutableDictionary *indexChecker;
    NSMutableDictionary *contactIndexChecker;
    NSMutableArray *selectedContacts;
    ShareViewCell *cell;
    int arrayIndex;
    bool isInviteCalled;
    InviteHelper *ih;
    
    //for sms feature
    NSIndexPath* checkedIndexPath;
    
    //gesture recognizer
     UIGestureRecognizer *singleFingertapper;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    names=[[NSMutableArray alloc] init];
    isInviteCalled=false;
    //[self getContactsOniOS10];
    NSLog(@"%@",names);
    //by ahmad, to change profile image....
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(change:)
                                                 name:@"change" object:nil];
    //end...
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showContactsOnTable)
                                                 name:@"ShowContactsOnTable" object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateContactInviteStatus)
                                                 name:@"updateContactInviteStatus" object:nil];
    
    //by ahmad to change profile image...
    [self.noCantactLbl setHidden:YES];
    contacts = [[NSMutableArray alloc] init];
    selectedContacts = [[NSMutableArray alloc] init];
    contactIndexChecker = [[NSMutableDictionary alloc] init];
        UserInfo *userinfo = [UserInfo instance];
        setImageUrl(self.imageView, userinfo.imageUrl);
    makeViewRound(self.imageContainer);
 
    //end...
    indexChecker = [[NSMutableDictionary alloc]init];
    // Do any additional setup after loading the view from its nib.
    
    arr = [[NSMutableArray alloc]init];
    
    for ( int i=0; i<5; i++){
                arr[i] = @"hello";
    }
    //gesture recognizer code...
    
    self.contactTable.dataSource = self;
    self.contactTable.delegate = self;
    singleFingertapper = [[UITapGestureRecognizer alloc]
                          
                          initWithTarget:self action:@selector(removeShareView)];

    [self.topView addGestureRecognizer:singleFingertapper];
    
    UITapGestureRecognizer *_singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(removeShareView)];
    [self.transView addGestureRecognizer:_singleFingerTap];
   [self requestContactAuthorization];
}

-(void)updateContactInviteStatus
{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    BOOL isAvailable = [appDelegate isNetworkAvailable];
    if(isAvailable)
    {
    
        [self.view makeToastActivity];
        fetcher = [[GenericFetcher alloc]init];
        //if there is a POST request send params in the fetcher method, if get request send nil to that
        // if there is a GET request send params in the urlbuilder method and nil to the fetcher method
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:invitationPhoneArray,kphone_no, nil];
        [fetcher fetchWithUrl:[URLBuilder urlForMethod:kupdate_invite_status withParameters:nil]
                   withMethod:POST_REQUEST withParams:dict completionBlock:^(NSDictionary *_dict) {
                       NSLog(@"my api result%@",_dict);
                       int status = [[_dict valueForKey:kstatus] intValue];
                     
                       if (status == 1) {
                           NSLog(@"Contacts status is updated");
                       }
                       else
                       {
                           UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:[_dict valueForKey:kerror] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                           [alert show];
                           [self.view hideToastActivity];
                       }
                       [self.view hideToastActivity];
                   }
                   errorBlock:^(NSError *error) {
                       [self.view hideToastActivity];
//                       UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Try Later" message:@"Internet Connection Problem" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//                       [alert show];
                       NSLog(@"no internet");
                       NSLog(@"%@",error);
                   }];
    }
}


-(void)getContacts
{
   if(((ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized)))
   {
       AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
       BOOL isAvailable = [appDelegate isNetworkAvailable];
       if(isAvailable)
       {
            userInfo = [UserInfo instance];
            arrayIndex = 0;
            ih = [[InviteHelper alloc]init];
            names = [ih getUserNames];
               int c = [names count];
               NSLog(@"%@",names);
            emails = [ih sendInvitation];
               NSLog(@"%@",emails);
            friendNames = @"";
            friendNamesArray = [[NSMutableArray alloc]init];
            invitationEmailArray = [[NSMutableArray alloc]init];
            invitationPhoneArray = [[NSMutableArray alloc]init];
            invitationUserArray = [[NSMutableArray alloc]init];
        
            //api call for retrieving emails
            [self.view makeToastActivity];
            fetcher = [[GenericFetcher alloc]init];
            //if there is a POST request send params in the fetcher method, if get request send nil to that
            // if there is a GET request send params in the urlbuilder method and nil to the fetcher method
            NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:names,kcontact_detail, nil];
            [fetcher fetchWithUrl:[URLBuilder urlForMethod:kinvite_phone withParameters:nil]
                       withMethod:POST_REQUEST withParams:dict completionBlock:^(NSDictionary *_dict) {
                           NSLog(@"my api result%@",_dict);
                           int status = [[_dict valueForKey:kstatus] intValue];
                           
                               if(_dict == nil)
                               {
                                   if (!isInviteCalled) {
                                       isInviteCalled=YES;
                                       [self.view hideToastActivity];
                                       [self getContacts];
                                       return;

                                  }
                                   

                               }
                               if (status == 1) {
                                   isInviteCalled=false;
                                   NSDictionary *response = [_dict valueForKey:kresponse];
                                   NSArray *uninvited_users = [response valueForKey:kUn_Invited_Users];
                                   NSArray *invited_users = [response valueForKey:kInvited_Users];
                                   contacts =[invited_users arrayByAddingObjectsFromArray:uninvited_users];
                                   
                                   int i = contacts.count;
                                   
                                   NSLog(@"my contacts%@",contacts);
                                   [self.contactTable reloadData];
                                   
                                   
                                   
                                   
                               }
                                        [self.view hideToastActivity];
                           
                           

                                            }
                       errorBlock:^(NSError *error) {
                           [self.view hideToastActivity];

                           NSLog(@"no internet");
                           NSLog(@"%@",error);
                       }];
       }
    }
    
}


//by ahmad to change profile image...

-(void) change:(NSNotification *) notification{
    UserInfo *userinfo = [UserInfo instance];
    setImageUrl(self.imageView, userinfo.imageUrl);
}

//end...


//code for gesture recognizer
-(void)removeShareView{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;

    NSLog(@"Remove share view");
    [UIView
     animateWithDuration:0.2
     delay:0.0
     options:nil
     animations:^{ self.transView.alpha = 0.0;
         self.topView.alpha = 0.0;
     }
     completion:^(BOOL finished){
         [UIView animateWithDuration: 1.0
                               delay:0
                             options:UIViewAnimationOptionOverrideInheritedOptions
                          animations:^{
                              if(!self.isLayer)
                               [(HomeViewController*)(((MainViewController*)kMainViewController).rootViewController) tView].alpha = 0.0;
                              [self.view setFrame:CGRectMake(self.view.frame.origin.x,screenHeight,self.view.frame.size.width,self.view.frame.size.height)];
                          }
                          completion:^(BOOL finished) {
                              if(!self.isLayer)
                               [(HomeViewController*)(((MainViewController*)kMainViewController).rootViewController) hideView];
                              [self.view removeFromSuperview];
                          }];
         
     }];

        [self dismissViewControllerAnimated:YES completion:nil];

    }

//end


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)requestContactAuthorization{
    
    ABAddressBookRef allPeople;
    allPeople = ABAddressBookCreateWithOptions(NULL, NULL);
     if(ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized){
        [self getContacts];
     }

    else if ((ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined)) {
        ABAddressBookRequestAccessWithCompletion(allPeople, ^(bool granted, CFErrorRef error) {
            if (allPeople) CFRelease(allPeople);
            if(((ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized))){
//
                AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                             [appDelegate loadContacts];
                
            }
            else{

                [self.noCantactLbl setHidden:NO];
            }
            
        });
    }
    else{
        [self changePermissions];
    }
}
-(void)showContactsOnTable{
    [self getContacts];
}
-(void)changePermissions{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Enable Contact Access" message:@"Please allow NearHero to access your contacts" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Settings", nil];
    [alert setTag:0];
    // Alert style customization
  //  alert.tintColor = [UIColor blueColor];
    [alert show];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return contacts.count;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
    //return 78;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    static NSString *simpleTableIdentifier = @"ShareViewCell";
    
    //[self.tabel reloadData];
    ShareViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ShareViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
    }
    
//    NSString* cellText = [invitationUserArray objectAtIndex:indexPath.row];
//    cell.name.text = cellText;
   //cell.name.text = [[invitationUserArray objectAtIndex:indexPath.row] capitalizedString];
//   
//    NSMutableArray *arr = [[NSMutableArray alloc]init];
//    for ( int i=0; i<5; i++){
//        arr[i] = @"hello";
//    }
    //cell.name.text = [[emails objectAtIndex:indexPath.row] capitalizedString];
    [cell.inviteStatusLabel setHidden:YES];

    cell.name.text = [[[contacts objectAtIndex:indexPath.row] valueForKey:kusername ] capitalizedString];
    if([[[contacts objectAtIndex:indexPath.row] valueForKey:kstatus ] isEqualToString:@"Yes"])
    {
        [cell.inviteStatusLabel setHidden:NO];
         cell.userInteractionEnabled = NO;
    }
    NSString *index = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    if ([indexChecker objectForKey:index]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }

    
    
        return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //indexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
    //static NSString *simpleTableIdentifier = @"ShareViewCell";
    
    //[self.tabel reloadData];
    //cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
//    UITableViewCell *myCell = [tableView cellForRowAtIndexPath:indexPath];
//    myCell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    
    //code for selecting and unselecting uitableviewcell
    
    
//    if(checkedIndexPath)
//    {
//        UITableViewCell* uncheckCell = [tableView
//                                        cellForRowAtIndexPath:checkedIndexPath];
//        uncheckCell.accessoryType = UITableViewCellAccessoryNone;
//    }
    
    
    //[indexChecker setObject:cell.name.text forKey:indexPath];
    
    //int i = indexPath.row;
    NSString *index = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    ShareViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([indexChecker objectForKey:index]){
        [contactIndexChecker removeObjectForKey:index];
        selectedContacts = [contactIndexChecker allValues];
        [indexChecker removeObjectForKey:index];
        friendNamesArray = [indexChecker allValues];
        NSString *friendNames = [friendNamesArray componentsJoinedByString:@","];
        _friendsList.text = friendNames;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else{
        NSString *n = cell.name.text;
        [indexChecker setObject:n forKey:index];
        friendNamesArray = [indexChecker allValues];
        NSString *friendNames = [friendNamesArray componentsJoinedByString:@","];
        _friendsList.text = friendNames;
        NSDictionary *obj = [contacts objectAtIndex:indexPath.row];
        [contactIndexChecker setObject:obj forKey:index];
        selectedContacts = [contactIndexChecker allValues];
        _friendsList.text = friendNames;

        
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    

}

-(NSMutableArray*)getUserNames{
    emailsAndNames = [ih getEmailAndNames];
    
    int i =0;
    int invitationIndex = 0;
    int count = [friendNamesArray count];
    
    for (NSMutableDictionary *emNames in emailsAndNames){
        if(i < count){
            NSString *invitationEmail = [emNames objectForKey:friendNamesArray[i]];
            
            
            if ([invitationEmail length] != 0){
                invitationEmailArray[invitationIndex] = invitationEmail;
                invitationIndex++;
                i++;
            }
        }
    }
    
    return invitationEmailArray;
}

#pragma mark - sms feature

- (IBAction)inviteButton:(id)sender {
  
    
        phoneAndNames = [ih getPhoneNumbers];
    
    BOOL isSimCardAvailable = YES;
    CTTelephonyNetworkInfo* info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier* carrier = info.subscriberCellularProvider;
    if(carrier.mobileNetworkCode == nil || [carrier.mobileNetworkCode isEqualToString:@""])
    {
        isSimCardAvailable = NO;
    }
    
    
   // if(!isSimCardAvailable)
    //{
        int count = [selectedContacts count];
        int invitationIndex = 0;
        for(int i = 0; i < count; i++)
        {
            NSString *invitationPhone = [[selectedContacts objectAtIndex:i] valueForKey:kphone_no];
            if ([invitationPhone length] != 0)
            {
                invitationPhoneArray[invitationIndex] = invitationPhone;
                invitationIndex++;
            }

        }

        NSLog(@"%@", invitationPhoneArray);

        if(count > 0 )
        {
           
            
           
            MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
            if([MFMessageComposeViewController canSendText])
            {
                
                controller.body = @"Hey, heard you were looking for work.Try NearHero and connect with professionals near you.\n https://itunes.apple.com/us/app/nearhero/id1178883512?ls=1&mt=8";
                controller.recipients = [invitationPhoneArray copy];
                controller.messageComposeDelegate = self;
                [self presentModalViewController:controller animated:YES];

               
            }
        }
        else
        {
            UIAlertView *alertMsg = [[UIAlertView alloc] initWithTitle:@"" message:@"Please select contact to invite" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [alertMsg show];
        }
   // }
//    //else
//    {
//        UIAlertView *alertMsg = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Sim Card is not available!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [alertMsg show];
//        
//    }
    //end code for sms feature.
    
    
}

//for sending sms feature

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{

    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            

            break;
        }
            
        case MessageComposeResultSent:
        {
            
            AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
           // [appDelegate updateContactInviteStatus];
           [(HomeViewController*)(((MainViewController*)kMainViewController).rootViewController) openMessageViewController];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self updateContactInviteStatus];
            });

            break;

        }
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma alertView delegate methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag==0){
        
        if(buttonIndex == 0)
        {
        }
        else if(buttonIndex == 1)
        {
            BOOL canOpenSettings = (&UIApplicationOpenSettingsURLString != NULL);
            if (canOpenSettings) {
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                [[UIApplication sharedApplication] openURL:url];
            }
        }
   
    }
}

- (IBAction)shareButtonAction:(id)sender {
    
    NSArray *activityItems;
    NSString *texttoshare = @"Hey, heard you were looking for work.Try NearHero and connect with professionals near you.\n https://itunes.apple.com/us/app/nearhero/id1178883512?ls=1&mt=8";
    activityItems = @[texttoshare];
    self.activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    [self.activityViewController setValue:@"NearHero" forKey:@"subject"];
    [self presentViewController:self.activityViewController animated:YES completion:nil];
}

-(void)getContactsOniOS10
{
    
    CNContactStore *store = [[CNContactStore alloc] init];
    [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted == YES) {
            //keys with fetching properties
            NSArray *keys = @[CNContactFamilyNameKey, CNContactGivenNameKey, CNContactPhoneNumbersKey, CNContactImageDataKey];
            NSString *containerId = store.defaultContainerIdentifier;
            NSPredicate *predicate = [CNContact predicateForContactsInContainerWithIdentifier:containerId];
            NSError *error;
            NSArray *cnContacts = [store unifiedContactsMatchingPredicate:predicate keysToFetch:keys error:&error];
            if (error) {
                NSLog(@"error fetching contacts %@", error);
            } else {
                for (CNContact *contact in cnContacts)
                {
                    // copy data to my custom Contacts class.
                    NSMutableDictionary *newContact = [[NSMutableDictionary alloc] init];
                    [newContact setValue:[NSString stringWithFormat:@"%@%@",contact.givenName,contact.familyName] forKey:@"username"];
                    for (CNLabeledValue *label in contact.phoneNumbers) {
                        NSLog(@"%@",contact.phoneNumbers);
                        NSString *phone = [label.value stringValue];
                        if ([phone length] > 0) {
                            [newContact setValue:phone forKey:@"phone_no"];
                            [names addObject:newContact];
                            break;
                        }
                    }

                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self getContacts];
                            });
            }
        }
    }];
   

}
@end
