 //
//  ProfileViewController.m
//  nearhero
//
//  Created by Irfan Malik on 6/10/16.
//  Copyright (c) 2016 TBoxSolutionz. All rights reserved.
//

#import "ProfileViewController.h"
#import "ProfileTableViewCell.h"
#import "PCollectionViewCell.h"
#import "HomeViewController.h"
#import "GenericFetcher.h"
#import "URLBuilder.h"
#import "UserInfo.h"
#import "AppDelegate.h"
#import "Constants.h"
#import <UIKit/UIKit.h>
#import "XMPPFramework.h"
#import "DDLog.h"
#import "XMPPvCardAvatarModule.h"
#import "XMPPvCardCoreDataStorage.h"
#import "XMPPvCardTemp.h"
#import "XMPPvCardTempModule.h"
#import "XMPPvCardCoreDataStorage.h"
#import "Toast+UIView.h"
#import "UIViewController+MJPopupViewController.h"
#import "UserReviewController.h"
#import "EditViewController.h"
#import "AMRatingControl.h"
#import "ReportViewController.h"
#import "InviteViewController.h"
#import "UICustomActionSheet.h"
//for fetching facebook friendslist
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
typedef NS_ENUM(NSInteger, FieldTag) {
    FieldTagHorizontalLayout = 1001,
    FieldTagVerticalLayout,
    FieldTagMaskType,
    FieldTagShowType,
    FieldTagDismissType,
    FieldTagBackgroundDismiss,
    FieldTagContentDismiss,
    FieldTagTimedDismiss,
};


typedef NS_ENUM(NSInteger, CellType) {
    CellTypeNormal = 0,
    CellTypeSwitch,
};


@interface ProfileViewController ()
{
    NSMutableArray *feedBacks;
    ProfileViewController *connectionProfileVC;
    UserInfo *userInfo;
    NSMutableArray *connections;
    NSMutableArray *_connections;
    NSMutableDictionary *rUser;
    NSMutableDictionary *userInReviews;
    PCollectionViewCell *selCell;
    UIImage *chosenImage;
    int cellNo;
    NSString *reviewerId;
}
@end

@implementation ProfileViewController

{

    NSArray *name;
    NSArray *image;
    NSArray *detail_name;
    NSInteger _numberOfCells;
    NSMutableArray *friendProfileImages;

    

}
-(AppDelegate *)appDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

-(void)openProfile:(UIGestureRecognizer*)gesture{
    [self.table setUserInteractionEnabled:NO];
    int _tag = [gesture.view tag] -10000;
    userInReviews=[feedBacks objectAtIndex:_tag];
    NSMutableDictionary *user = [[NSMutableDictionary alloc] init];
    [user setValue:[userInReviews valueForKey:kreviewer_id] forKey:kid];
    [user setValue:[userInReviews valueForKey:kname] forKey:kname];
    [user setValue:[userInReviews valueForKey:klocation] forKey:klocation];
    [user setValue:[userInReviews valueForKey:kprofession] forKey:kprofession];
    [user setValue:[userInReviews valueForKey:kprofile_image] forKey:kprofile_image];
      
    [(HomeViewController*)(((MainViewController*)kMainViewController).rootViewController) openUserProfile : user : YES];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(enableInteraction) userInfo:nil repeats:NO];

}

-(void)processDoubleTap:(UIGestureRecognizer*)gesture{
    
    [self.myCollectionView setUserInteractionEnabled:NO];
    
    int _tag = [gesture.view tag] -10000;
    if(_tag == 0 && [[userInfo valueForKey:kuu_id]isEqualToString:_user_id])
    {
        [self.view setHidden:YES];
       // [self removeProfileView];
        [self dismissViewControllerAnimated:YES completion:nil];

        [(HomeViewController*)(((MainViewController*)kMainViewController).rootViewController) viewinvitescreen:self.isLayer];
        
    }
    else
    {
        if([[userInfo valueForKey:kuu_id]isEqualToString:_user_id])
            _tag--;
        rUser=[_connections objectAtIndex:_tag];
        NSString *id = [rUser valueForKey:kid];
        [(HomeViewController*)(((MainViewController*)kMainViewController).rootViewController) openUserProfile : rUser : YES];
    }
    NSTimer *aTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(enableInteraction) userInfo:nil repeats:NO];
}
-(void)getUserRating{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    BOOL isAvailable = [appDelegate isNetworkAvailable];
    if(isAvailable){
        NSMutableDictionary *params = [[NSMutableDictionary alloc]init];

        UserInfo *userInfo = [UserInfo instance];
        if([self.user_id isEqualToString:[userInfo valueForKey:kuu_id]])
            [params setValue:userInfo.apiKey forKey:kapi_key];
        else
            [params setValue:@"" forKey:kapi_key];

        [params setValue:self.user_id forKey:kid];
        
        
        GenericFetcher *fetcher = [[GenericFetcher alloc]init];
        
        [fetcher fetchWithUrl:[URLBuilder urlForMethod:kget_profile withParameters:nil]
                   withMethod:POST_REQUEST withParams:params completionBlock:^(NSDictionary *dict) {
                       NSLog(@"%@",dict);
                       int status = [[dict valueForKey:kstatus] intValue];
                       if (status == 1) {
                           
                           
                           NSDictionary *user = [dict valueForKey:kuser_info];
                           
                           CGPoint point = CGPointMake(0,0);
                           
                           NSInteger *rating = [[user valueForKey:krating] intValue];
                           UIColor *color;
                           float rd = 225.00/255.00;
                           float gr = 177.00/255.00;
                           float bl = 140.00/255.00;
                           
                           AMRatingControl *coloredRatingControl = [[AMRatingControl alloc] initWithLocation:point
                                                                                                  emptyColor:[UIColor colorWithRed:230.00/255.00 green:230.00/255.00 blue:235.00/255.00 alpha:1.0]            solidColor:[UIColor colorWithRed:243.00/255.00 green:195.00/255.00 blue:68.00/255.00 alpha:1.0]
                                                                                                andMaxRating:5];
                           [coloredRatingControl setRating:rating];
                           [coloredRatingControl setStarSpacing:1];
                           [self.ratingView addSubview:coloredRatingControl];
                           
                       }
                       else
                       {
//                           UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:[dict valueForKey:kerror] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//                           [alert show];
                       }
                       
                       
                   }
                   errorBlock:^(NSError *error) {
                       NSLog(@"no internet");
                       NSLog(@"%@",error);
                   }];
    }

}
-(void)setProfileInfo{
    
    userInfo = [UserInfo instance];
    if([self.user_id isEqualToString:[userInfo valueForKey:kuu_id]])
    {
      
                UserInfo *userInfo = [UserInfo instance];
                self.full_name.text = [userInfo valueForKey:kname];
                self.profession.text = [userInfo valueForKey:kprofession];
                if( [[userInfo valueForKey:klocation] isEqualToString:@"(null),(null)"])
                        self.location.text = @"";
                else
                    self.location.text = [userInfo valueForKey:klocation];
                makeViewRound(self.imageContainerView);
                setImageUrl(self.imageView,userInfo.imageUrl);
                [self getUserRating];
    }
    else{
        self.full_name.text = [_profileUser valueForKey:kname];
        self.profession.text = [_profileUser valueForKey:kprofession];
        makeViewRound(self.imageContainerView);
        setImageUrl(self.imageView,[_profileUser valueForKey:kprofile_image]);
        
        if( [[_profileUser valueForKey:klocation] isEqualToString:@"(null),(null)"])
            self.location.text = @"";
        else
            _location.text = [_profileUser valueForKey:klocation];
        if([_profileUser valueForKey:krating] == nil){
                [self getUserRating];
        }
       else{

           CGPoint point = CGPointMake(0,0);
           
            NSInteger *rating = [[_profileUser valueForKey:krating] intValue];
            UIColor *color;
            float rd = 225.00/255.00;
            float gr = 177.00/255.00;
            float bl = 140.00/255.00;
            
            AMRatingControl *coloredRatingControl = [[AMRatingControl alloc] initWithLocation:point
                                                                                   emptyColor:[UIColor colorWithRed:230.00/255.00 green:230.00/255.00 blue:235.00/255.00 alpha:1.0]            solidColor:[UIColor colorWithRed:243.00/255.00 green:195.00/255.00 blue:68.00/255.00 alpha:1.0]
                                                                                 andMaxRating:5];
            [coloredRatingControl setRating:rating];
            [coloredRatingControl setStarSpacing:1];

         
            [self.ratingView addSubview:coloredRatingControl];
       }

        

    }



}
-(void)gettingLatestConnections{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    BOOL isAvailable = [appDelegate isNetworkAvailable];
    if(isAvailable){
        UserInfo *userInfo = [UserInfo instance];
        [self.view makeToastActivity];
        NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
        //NSString *s = [userInfo valueForKey:kuu_id];
       // [params setValue:[userInfo valueForKey:kuu_id] forKey:kid];
        [params setValue:self.user_id forKey:kid];
        
        GenericFetcher *fetcher = [[GenericFetcher alloc]init];
        
        [fetcher fetchWithUrl:[URLBuilder urlForMethod:klatest_connections withParameters:nil]
                   withMethod:POST_REQUEST withParams:params completionBlock:^(NSDictionary *dict) {
                        NSLog(@"%@",dict);
                       
                          NSMutableDictionary *roster = [dict valueForKey:kroster];
                           NSArray *connection = [roster valueForKey:krosterItem];
                         _connections = [[NSMutableArray alloc] initWithArray:connection];
                       if([_connections count] == 0){
                           [_connectionLabel setHidden:NO];
                       }
                           
                           [self.myCollectionView reloadData];
                       
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

-(void)gettingFeedback{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    BOOL isAvailable = [appDelegate isNetworkAvailable];
    if(isAvailable){
    
       
          //  [self.view makeToastActivity];
        NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
        
        [params setValue:self.user_id forKey:kid];
        GenericFetcher *fetcher = [[GenericFetcher alloc]init];
        
        [fetcher fetchWithUrl:[URLBuilder urlForMethod:kget_feedback withParameters:nil]
                   withMethod:POST_REQUEST withParams:params completionBlock:^(NSDictionary *dict) {
                        NSLog(@"%@",dict);
                       int status = [[dict valueForKey:kstatus] intValue];
                       NSArray *feedback = [dict valueForKey:kfeedback];
                       feedBacks = [[NSMutableArray alloc] initWithArray:feedback];
                       
                       
                       if (status == 1) {
                           
    //                       NSArray *feedback = [dict valueForKey:kfeedback];
    //                       feedBacks = [[NSMutableArray alloc] initWithArray:feedback];
                           if([feedBacks count] == 0)
                               [_noReviewLabel setHidden:NO];
                           
                           [self.table reloadData];
                          

                       }
                       else
                       {
                           [self.table reloadData];
                           if([feedBacks count] == 0){
                               [_noReviewLabel setHidden:NO];
                           }
//                           UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:[dict valueForKey:kerror] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//                           [alert show];
                       //    [self.view hideToastActivity];

                       }
                       //[self.view hideToastActivity];

                   }
                   errorBlock:^(NSError *error) {
                      // [self.view hideToastActivity];
//                       UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Try Later" message:@"Internet Connection Problem" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//                       [alert show];
                         //  [self.view hideToastActivity];
                           

                       NSLog(@"no internet");
                       NSLog(@"%@",error);
                       
                   }];
    }
}


-(void)slideUpContainer:(UISwipeGestureRecognizer*)swipeGesture{
    NSLog(@"test");
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionOverrideInheritedOptions
                     animations:^{
                         [self.view setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.7]];
                         [self.containerView setCenter:CGPointMake(self.view.center.x, self.view.center.y)];
                     }
                     completion:^(BOOL finished) {
                     }];
}
-(void)removeProfileView{
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;

         [UIView animateWithDuration:1.0
                               delay:0
                             options:UIViewAnimationOptionOverrideInheritedOptions
                          animations:^{
                              if(!self.isLayer)
                                  [[(HomeViewController*)(((MainViewController*)kMainViewController).rootViewController) tView] setAlpha:0.0];
                              [self.view setFrame:CGRectMake(self.view.frame.origin.x,
                                                             screenHeight,
                                                             self.view.frame.size.width,
                                                             self.view.frame.size.height)];
                          }
                          completion:^(BOOL finished) {
                              if(!self.isLayer){
                                  [(HomeViewController*)(((MainViewController*)kMainViewController).rootViewController) hideView];
                              }
                              [self.view removeFromSuperview];
                              HomeViewController* hc = [[HomeViewController alloc]init];
                              [hc ChangeProfileImage];
                          }];
         
   

    [self dismissViewControllerAnimated:YES completion:nil];
   
}


-(void)addGestures{
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(slideUpContainer:)];
    swipeUp.delegate=self;
    swipeUp.numberOfTouchesRequired = 1;
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    //[self.basicInfoContainer addGestureRecognizer:swipeUp];
    
    
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(removeProfileView)];
    [self.transperentView addGestureRecognizer:singleFingerTap];
    UITapGestureRecognizer *_singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(removeProfileView)];
    [self.transView addGestureRecognizer:_singleFingerTap];
    
    UITapGestureRecognizer *camera =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(showCameraOption)];
    [self.imageContainerView addGestureRecognizer:camera];
}

-(void)showCameraOption{
    if([self.user_id isEqualToString:[userInfo valueForKey:kuu_id]]){
    [self showActionSheet];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    //by ahmad, to update reviews in tableview...
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateReviews:)
                                                 name:@"updateReviews" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateImage:)
                                                 name:@"change" object:nil];

    //end...
    

    
    //by ahmad, to change profession
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeProfession:)
                                                 name:@"changeProfession" object:nil];
    //end...
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addGesture:)
                                                 name:@"addGesture"
                                               object:nil];

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateReviews" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"change" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeProfession" object:nil];
     [[NSNotificationCenter defaultCenter] removeObserver:self name:@"addGesture" object:nil];
}
//
//
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    [self.transView setHidden:NO];
//    [self.transperentView setHidden:NO];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _full_name.adjustsFontSizeToFitWidth = YES;
    _profession.adjustsFontSizeToFitWidth = YES;
    _location.adjustsFontSizeToFitWidth = YES;
    [_connectionLabel setHidden:YES];
    [_noReviewLabel setHidden:YES];
    self.table.separatorColor = [UIColor clearColor];

    //for a device if it has no camera.
    self.table.dataSource = self;
    friendProfileImages = [[NSMutableArray alloc]init];
    [self.table registerNib:[UINib nibWithNibName:@"ProfileTableViewCell" bundle:nil]
         forCellReuseIdentifier:@"Cell"];


    [self viewWillAppear:YES];
    [self addGestures];
    [self gettingFeedback];
    self.table.delegate = self;
    [self gettingLatestConnections];
    [self setProfileInfo];
    _myCollectionView.delegate = self;
    _myCollectionView.dataSource = self;
   [self.myCollectionView registerClass:[PCollectionViewCell class] forCellWithReuseIdentifier:@"PCollectionViewCell"];
    
    UINib *cellNib = [UINib nibWithNibName:@"PCollectionViewCell" bundle:nil];
    [self.myCollectionView registerNib:cellNib forCellWithReuseIdentifier:@"PCollectionViewCell"];
    self.myCollectionViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    [self.myCollectionViewFlowLayout setItemSize:CGSizeMake(50, 50)];
    [self.myCollectionViewFlowLayout setSectionInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.myCollectionViewFlowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    self.myCollectionView.alwaysBounceHorizontal = YES;
    self.myCollectionViewFlowLayout.minimumLineSpacing = 0;
    self.myCollectionViewFlowLayout.minimumInteritemSpacing = 0;
    
    _numberOfCells = 3;
    self.navigationController.navigationBarHidden = true;
    
    
    // Load the file content and read the data into arrays
    [self.table reloadData];
    [self showButtonsOnMyProfile];
    [self.myCollectionView reloadData];
     self.table.allowsMultipleSelectionDuringEditing = NO;
   
}


-(void) changeProfession:(NSNotification *) notification{
    UserInfo *userinfo = [UserInfo instance];
    if([self.user_id isEqualToString:[userinfo valueForKey:kuu_id]]){
        self.profession.text = [userinfo valueForKey:kprofession];
    }
}



-(void) addGesture:(NSNotification *) notification{
    [self.view addGestureRecognizer:self->panRecognizer];
}

-(void) updateReviews:(NSNotification *) notification{
    NSMutableDictionary *dict = [notification userInfo];
   // if(dict != nil){
        if([[dict valueForKey:kid]isEqualToString:_user_id]){
                [self gettingFeedback];
        }
        
   // }
}
-(void) updateImage:(NSNotification *) notification{
    UserInfo *userInfo = [UserInfo instance];
    if([[userInfo valueForKey:kuu_id]isEqualToString:_user_id])
        setImageUrl(self.imageView, userInfo.imageUrl);

}
- (void)showButtonsOnMyProfile{
    userInfo = [UserInfo instance];
    if(![self.user_id isEqualToString:[userInfo valueForKey:kuu_id]])
    {
        [self.editButton setHidden:YES];
        [self.cameraButton setHidden:YES];
        [self.shareProfileButton setHidden:YES];
        [self.reviewLabel setHidden:YES];
        [self.writeReviewBtn setHidden:NO];
        [self.messageButton setHidden:NO];
        
      
        
    }
    else
    {
        [self.messageButton setHidden:YES];
        [self.writeReviewBtn setHidden:YES];
        [self.reviewLabel setHidden:NO];
        [self.editButton setHidden:NO];
        [self.cameraButton setHidden:NO];
        [self.shareProfileButton setHidden:NO];
        
        
    }
    

}
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if([[userInfo valueForKey:kuu_id]isEqualToString:_user_id])
        return [_connections count]+1;
    else
        return [_connections count];
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    int i = indexPath.row;
       PCollectionViewCell *cell = (PCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"PCollectionViewCell" forIndexPath:indexPath];
       if([[userInfo valueForKey:kuu_id]isEqualToString:_user_id] && (indexPath.row == 0))
       {
           cell.image.image = [UIImage imageNamed:@"gray+"];
           
       }
       else
       {
           if([[userInfo valueForKey:kuu_id]isEqualToString:_user_id])
               i--;
           
           NSDictionary *conn = [_connections objectAtIndex:i];

           makeViewRound(cell.imageContainerView);
           setImageUrl(cell.image,[conn valueForKey:kprofile_image]);

       }
    UIGestureRecognizer *tapper = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self action:@selector(processDoubleTap:)];
    tapper.cancelsTouchesInView = NO;
    [cell addGestureRecognizer:tapper];
    [cell setTag:(10000+indexPath.row)];
    return cell;

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
    return [feedBacks count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 76;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"Cell";
    
    ProfileTableViewCell * cell = (ProfileTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];


    if(cell == nil)
    {
        NSArray * nibObjects = [[NSBundle mainBundle] loadNibNamed:@"ProfileTableViewCell" owner:nil options:nil];
        
                cell = [nibObjects objectAtIndex:0];
//                cell.accessoryType = UITableViewCellAccessoryNone;
//                [cell setDelegate:self];
//                tableView.allowsSelection = NO;
//                makeViewRound(cell.imageContainerView);
//                cell.name.numberOfLines = 1;
//                cell.name.minimumFontSize = 10;
//                cell.name.adjustsFontSizeToFitWidth = YES;
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    [cell setDelegate:self];
    tableView.allowsSelection = NO;
    makeViewRound(cell.imageContainerView);
    cell.name.numberOfLines = 1;
    cell.name.minimumFontSize = 10;
    cell.name.adjustsFontSizeToFitWidth = YES;

    if([feedBacks count] == 0){
        [self.noReviewLabel setHidden:NO];
    }
    else{
        [self.noReviewLabel setHidden:YES];
    NSDictionary *feedBack = [feedBacks objectAtIndex:indexPath.row];
//    userInReviews = feedBack;
    userInfo = [UserInfo instance];
        reviewerId = [feedBack valueForKey:kreviewer_id];
    if(([[userInfo valueForKey:kuu_id]isEqualToString:_user_id] || [[feedBack valueForKey:kreviewer_id] isEqualToString:[userInfo valueForKey:kuu_id]]))
                cell.rightUtilityButtons = [self rightButtons];
    else
            cell.rightUtilityButtons = nil;

    //cell.date.text = [feedBack valueForKey:kdate];
    //date formatting...
    NSString *sDate = [feedBack valueForKey:kdate];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"MM-dd-YYYY"];
//    NSDate *d  = [dateFormatter dateFromString:sDate];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
     NSDate *date = [dateFormatter dateFromString:sDate];
    [dateFormatter setDateFormat:@"MMM d , yyyy"];
    NSString * newDate = [dateFormatter stringFromDate:date];
    
    cell.date.text = newDate;
    //end of date formatting...
    cell.name.text = [feedBack valueForKey:kname];
    cell.feedback.text = [feedBack valueForKey:kfeedback_msg];
    //ranging feedback section...
        cell.feedback.textContainer.maximumNumberOfLines = 3;
    //end...
        
    //cell.image.image = [UIImage imageNamed:[image objectAtIndex:0]];
    setImageUrl(cell.image,[feedBack valueForKey:kprofile_image]);
        
    //ahmad's code for open user profile in review section in profile screen, tapping on profile image.
    UIGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self action:@selector(openProfile:)];
    tap.cancelsTouchesInView = NO;
    [cell.imageContainerView addGestureRecognizer:tap];
    [cell.imageContainerView setTag:(10000+indexPath.row)];
    //end code...
        
    CGPoint point = CGPointMake(4,0);

    NSInteger *rating = [[feedBack valueForKey:krating] intValue];
    UIColor *color;
    float rd = 225.00/255.00;
    float gr = 177.00/255.00;
    float bl = 140.00/255.00;
    
    AMRatingControl *coloredRatingControl = [[AMRatingControl alloc] initWithLocation:point
                                                                           emptyColor:[UIColor colorWithRed:230.00/255.00 green:230.00/255.00 blue:235.00/255.00 alpha:1.0]
                                                                           solidColor:[UIColor colorWithRed:243.00/255.00 green:195.00/255.00 blue:68.00/255.00 alpha:1.0]
                                                                         andMaxRating:5];
    [coloredRatingControl setRating:rating];
    
    [cell.ratingView addSubview:coloredRatingControl];
    

    
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}


- (IBAction)moveBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)slideView:(id)sender {
 
}
- (NSArray *)rightButtons
{
   NSMutableArray* rightUtilityButtons = [[NSMutableArray alloc] init];

   
    userInfo = [UserInfo instance];

    
    if([[userInfo valueForKey:kuu_id]isEqualToString:_user_id])
    {
        [rightUtilityButtons sw_addUtilityButtonWithColor:
         [UIColor colorWithRed:1.0f green:0.5843f blue:0.0 alpha:1.0]
                                                    title:@"Report"];
    }
    else if([reviewerId isEqualToString:[userInfo valueForKey:kuu_id]])
    {
    
        [rightUtilityButtons sw_addUtilityButtonWithColor:
         [UIColor colorWithRed:0.9960f green:0.247f blue:0.207 alpha:1.0f]
                                                    title:@"Trash"];
    }
    return rightUtilityButtons;
}


- (IBAction)shareProfile:(id)sender {
    
    NSArray *activityItems;
    NSString *texttoshare = @"Hey, heard you were looking for work.Try NearHero and connect with professionals near you.\n https://itunes.apple.com/us/app/nearhero/id1178883512?ls=1&mt=8";
    activityItems = @[texttoshare];
    self.activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    [self.activityViewController setValue:@"NearHero" forKey:@"subject"];
    [self presentViewController:self.activityViewController animated:YES completion:nil];
}

-(void)showActionSheet{
    //checking if device has a camera.r
//    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
//    {
//        
//        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
//                                    
//                                                              message:@"Device has no camera"
//                                                             delegate:nil
//                                                    cancelButtonTitle:@"OK"
//                                                    otherButtonTitles: nil];
//        
//        [myAlertView show];
//    }
//    else{
       UIActionSheet *mymenu = [[UIActionSheet alloc]
                             initWithTitle:nil
                             delegate:self
                             cancelButtonTitle:@"Cancel"
                             destructiveButtonTitle:nil
                             otherButtonTitles: @"Take a Photo", @"Choose From Library" , nil];

        [mymenu showInView:self.view];
//    }
    
    
   

}
- (IBAction)cameraBtnClick:(id)sender {
    [self showActionSheet];
}

-(void) changeImage{
    [self.controllerDelegate changeprofileWithImage];
}

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    
  
            switch (buttonIndex) {
//                case 0:
//                    if ([FBSDKAccessToken currentAccessToken]) {
//                        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{ @"fields" : @"picture.width(100).height(100)"}]startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
//                            if (!error) {
//                                 UserInfo *userinfo = [UserInfo instance];
//                               // NSString *nameOfLoginUser = [result valueForKey:@"name"];
//                                NSString *imageStringOfLoginUser = [[[result valueForKey:@"picture"] valueForKey:@"data"] valueForKey:@"url"];
////                                NSURL *url = [[NSURL alloc] initWithURL: imageStringOfLoginUser];
//                                NSString *userImageURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [userinfo uu_id]];
//                                //[self.imageView setImageWithURL: userImageURL];
//                                chosenImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:userImageURL]]];
//                                //[self.imageView setImageWithURL:userImageURL];
//                                [self uploadImage];
//                               // [userinfo setValue:userImageURL forKey:kImageUrl];
//                                  //                              [userinfo setProfileimageLink:userImageURL];
//                                //[userinfo saveUserInfo];
//                                
//                               // [[NSNotificationCenter defaultCenter] postNotificationName:@"change" object:nil];
//                                //[self changeImage];
//                            }
//                        }];
//                   
//                    
//                    }
//
//                    break;
                case 0:{
                    //Take a photo
                    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                    picker.delegate = self;
                    picker.allowsEditing = YES;
                    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                    
                    [self presentViewController:picker animated:YES completion:NULL];
                }
                    break;
                case 1:
                    //Select photo...
                {
                    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                    picker.delegate = self;
                    picker.allowsEditing = YES;
                    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    
                    [self presentViewController:picker animated:YES completion:NULL];
                }
                    break;
                case 2:
                    //[self saveContent];
                    break;
                case 3:
                    //[self rateAppYes];
                    break;
                default:
                    break;
       
    }
}

#pragma mark - updateprofile api
typedef void(^addressCompletion)(NSString *);

-(void)getAddressFromLocation:(CLLocation *)location complationBlock:(addressCompletion)completionBlock
{
    __block CLPlacemark* placemark;
    __block NSString *address = nil;
    
    CLGeocoder* geocoder = [CLGeocoder new];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (error == nil && [placemarks count] > 0)
         {
             placemark = [placemarks lastObject];
             address = [NSString stringWithFormat:@"%@, %@ %@", placemark.name, placemark.postalCode, placemark.locality];
             completionBlock(address);
         }
     }];
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    chosenImage = info[UIImagePickerControllerEditedImage];
    [self uploadImage];
 
    
//     NSURL* localUrl = (NSURL *)[info valueForKey:UIImagePickerControllerReferenceURL];
////    NSString *u= (NSString*)[info valueForKey:UIImagePickerControllerReferenceURL];
//////    NSURL *myURL = [myURL URLByAppendingPathComponent:u];
////    NSURL *yourURL = [[NSURL alloc]initWithString:u];
//    NSLog(@"%@", localUrl);
//    //NSURL *fileURL = [NSURL fileURLWithPath:localUrl];
//    [self updateProfileImage];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

-(void)uploadImage{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    BOOL isAvailable = [appDelegate isNetworkAvailable];
    if(isAvailable){
    
        [self.view makeToastActivity];

        GenericFetcher *fetcher = [[GenericFetcher alloc]init];
        
        NSString *apiKey = [[UserInfo instance] apiKey];
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        //    [param setValue:apiKey forKey:kapi_key];
        [param setValue:chosenImage forKey:kImage];
        
        //if there is a POST request send params in the fetcher method, if get request send nil to that
        // if there is a GET request send params in the urlbuilder method and nil to the fetcher method
        
        [fetcher PostImageToUrl:[URLBuilder urlForMethod:[NSString stringWithFormat:kupdate_profile_image, apiKey] withParameters:nil] withMethod:@"POST" withParams:param completionBlock:^(NSDictionary *dict) {
            NSLog(@"%@",dict);
            
            int status = [[dict valueForKey:@"status"] intValue];
            NSLog(@"Status of Image API: %d", status);
            
            if (status == 1) {
                self.imageView.image = chosenImage;
                
                UserInfo *userinfo = [UserInfo instance];
                
                NSString* pImageLink = [dict valueForKey:kprofile_image];
                [userinfo setValue:pImageLink forKey:kImageUrl];
                
                [userinfo setProfileimageLink:[dict valueForKey:kprofile_image]];
                [userinfo saveUserInfo];
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"change" object:nil];
                [self.view hideToastActivity];
                [appDelegate createVcard];

                
            }else {
                
                [self.view hideToastActivity];
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Error" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert show];
                
            }
        }
                     errorBlock:^(NSError *error) {
                         [self.view hideToastActivity];
                         UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"no internet." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                         [alert show];
                     }];
    }
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
- (IBAction)messageButtonAction:(id)sender {
    [self.messageButton setUserInteractionEnabled:NO];
   NSTimer *aTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(enableInteraction) userInfo:nil repeats:NO];

        [(HomeViewController*)(((MainViewController*)kMainViewController).rootViewController) showChatView:
         [NSString stringWithFormat:@"%@@%@",self.user_id,SERVER_DOMAIN]];

}
-(void)enableInteraction{
    [self.messageButton setUserInteractionEnabled:YES];
    [self.myCollectionView setUserInteractionEnabled:YES];
    [self.table setUserInteractionEnabled:YES];
    
}
-(NSString *) getProfileUrl :(NSString *)id
{
    return [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?width=200&height=200",id];
}
- (IBAction)addReview:(id)sender {
    
    
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:_user_id forKey:kid];
        [dict setValue:_full_name.text forKey:kname];
        [dict setValue:_profession.text forKey:kprofession];
        [dict setValue:[_profileUser valueForKey:kprofile_image] forKey:kprofile_image];
        
        [self.view removeGestureRecognizer:self->panRecognizer];

        UserReviewController *reviewVC = [[UserReviewController alloc]initWithNibName:@"UserReviewController" bundle:nil];
        reviewVC.user = dict;
    [reviewVC.view setCenter:CGPointMake(self.view.center.x, self.view.center.y)];
    [reviewVC.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    [self.view addSubview:reviewVC.view];
    
   }
- (IBAction)editButtonAction:(id)sender {
     EditViewController *editVC = [[EditViewController alloc]initWithNibName:@"EditViewController" bundle:nil];
    [editVC.view setCenter:CGPointMake(self.view.center.x, self.view.center.y)];
    [editVC.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    editVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    editVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:editVC animated:YES completion:nil];

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
    userInfo = [UserInfo instance];
    NSIndexPath *indexPath = [self.table indexPathForCell:cell];
    NSMutableDictionary *feedback = [feedBacks objectAtIndex:indexPath.row];
    switch (index) {
        case 0:
        {
        
            if(!([[userInfo valueForKey:kuu_id]isEqualToString:_user_id]))
            {
                cell.UserInteractionEnabled = false;
 
               [self.view makeToastActivity];
                AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                BOOL isAvailable = [appDelegate isNetworkAvailable];
                if(isAvailable){
                    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
                    [params setValue:[feedback valueForKey:kfeedback_msg] forKey:kfeedback];
                    [params setValue:_user_id forKey:kid];
                    [params setValue:[feedback valueForKey:kreviewer_id] forKey:kreviewer_id];
                    [params setValue:[feedback valueForKey:kreview_id] forKey:kreview_id];

                    [params setValue:[feedback valueForKey:krating] forKey:krating];
                    
                    
                    GenericFetcher *fetcher = [[GenericFetcher alloc]init];
                    
                    [fetcher fetchWithUrl:[URLBuilder urlForMethod:kdelete_review withParameters:nil]
                               withMethod:POST_REQUEST withParams:params completionBlock:^(NSDictionary *dict) {
                                   NSLog(@"%@",dict);
                                   int status = [[dict valueForKey:kstatus] intValue];
                                   NSMutableDictionary *obj = [[NSMutableDictionary alloc] init];
                                   [obj setValue:_user_id forKey:kid];
                                   if (status == 1) {
                                       
                                       [[NSNotificationCenter defaultCenter] postNotificationName:@"updateReviews" object:nil userInfo:obj];

//                                       [self gettingFeedback];
//                                       [self.table reloadData];
                                       [NSTimer scheduledTimerWithTimeInterval:2.0
                                                                        target:self
                                                                      selector:@selector(targetMethod)
                                                                      userInfo:nil
                                                                       repeats:NO];
                                      // [self.view hideToastActivity];

                                   }
                                   else
                                   {
                                       UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:[dict valueForKey:kerror] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                                       [alert show];
                                       [self.table reloadData];
                                       [self.view hideToastActivity];

                                   }
                                   
                                   cell.userInteractionEnabled = true;

                               }
                               errorBlock:^(NSError *error) {
                                  [self.view hideToastActivity];
                                                                 NSLog(@"no internet");
                                   NSLog(@"%@",error);
                                   cell.userInteractionEnabled = true;

                               }];
                }

            }
            else
            {
                AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                BOOL isAvailable = [appDelegate isNetworkAvailable];
                if(isAvailable){
                    cell.userInteractionEnabled = false;

                    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
                    [self.view makeToastActivity];
                    [params setValue:[feedback valueForKey:kfeedback_msg] forKey:kfeedback];
                    [params setValue:[userInfo valueForKey:kuu_id] forKey:kid];
                    [params setValue:[feedback valueForKey:kreviewer_id] forKey:kreviewer_id];
                    [params setValue:[feedback valueForKey:krating] forKey:krating];
                    [params setValue:[feedback valueForKey:kreview_id] forKey:kreview_id];
                    
                    
                    GenericFetcher *fetcher = [[GenericFetcher alloc]init];
                    
                    [fetcher fetchWithUrl:[URLBuilder urlForMethod:kreport_review withParameters:nil]
                               withMethod:POST_REQUEST withParams:params completionBlock:^(NSDictionary *dict) {
                                   NSLog(@"%@",dict);
                                   int status = [[dict valueForKey:kstatus] intValue];
                                   cell.userInteractionEnabled = true;

                                   if (status == 1) {                        
                                       [self.view hideToastActivity];
                                       
                                       ReportViewController *reportVC = [[ReportViewController alloc]initWithNibName:@"ReportViewController" bundle:nil];
                                       [reportVC.view setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
                                       reportVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                                       reportVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
                                       [self presentViewController:reportVC animated:YES completion:nil];
                                     
                                   }
                                   else
                                   {
                                       [self.view hideToastActivity];

//                                       UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:[dict valueForKey:kerror] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//                                       [alert show];
     
                                   }
                                   
                               }
                               errorBlock:^(NSError *error) {
                                   [self.view hideToastActivity];
//                                   UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Try Later" message:@"Internet Connection Problem" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//                                   [alert show];
                                   NSLog(@"no internet");
                                   NSLog(@"%@",error);
                                   cell.userInteractionEnabled = true;

                               }];
                
                }
            }
            break;
        }
        case 1:
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Trash button was pressed" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
            break;
        }
        default:
            break;
    }
}
-(void)openReportView{
  ReportViewController *reportVC = [[ReportViewController alloc]initWithNibName:@"ReportViewController" bundle:nil];
    [reportVC.view setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
    reportVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    reportVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:reportVC animated:YES completion:nil];
}
-(void)targetMethod{
    [self.view hideToastActivity];
}
@end

