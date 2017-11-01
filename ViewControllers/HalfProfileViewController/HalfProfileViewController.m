//
//  HalfProfileViewController.m
//  nearhero
//
//  Created by apple on 7/29/16.
//  Copyright © 2016 TBoxSolutionz. All rights reserved.
//

#import "HalfProfileViewController.h"
#import "ProfileViewController.h"
#import "ProfileTableViewCell.h"
#import "PCollectionViewCell.h"
#import "GenericFetcher.h"
#import "URLBuilder.h"
#import "UserInfo.h"
#import "HomeViewController.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "AMRatingControl.h"
#import "Toast+UIView.h"
#import <UIKit/UIKit.h>

@interface HalfProfileViewController ()
{
    ProfileViewController *connectionProfileVC;
    NSMutableArray *connections;
    NSMutableArray *feedBacks;
    NSString *jid;
}

@end

@implementation HalfProfileViewController

-(void)setProfileInfo{
    UserInfo *userInfo = [UserInfo instance];
    
    makeViewRound(self.profileImageContainer);
    setImageUrl(self.image,[_user_data valueForKey:kprofile_image]);
    self.name.text = [_user_data valueForKey:kname];
    self.profession.text = [_user_data valueForKey:kprofession];
    NSInteger *rating = [[_user_data valueForKey:krating] intValue];
    CGPoint point = CGPointMake(-10,0);
    UIColor *color;
    float rd = 225.00/255.00;
    float gr = 177.00/255.00;
    float bl = 140.00/255.00;
    
    AMRatingControl *coloredRatingControl = [[AMRatingControl alloc] initWithLocation:point
                                                                           emptyColor:[UIColor colorWithRed:230.00/255.00 green:230.00/255.00 blue:235.00/255.00 alpha:1.0]
                                                                           solidColor:[UIColor colorWithRed:243.00/255.00 green:195.00/255.00 blue:68.00/255.00 alpha:1.0]
                                                                         andMaxRating:5];
    [coloredRatingControl setRating:rating];
    
    [_ratingView addSubview:coloredRatingControl];
    CLLocation *locA = [[CLLocation alloc] initWithLatitude:[[_user_data valueForKey:klat] floatValue]longitude:[[_user_data valueForKey:klng] floatValue]];
    CLLocation *locB = [[CLLocation alloc] initWithLatitude:userInfo.latitude longitude:userInfo.longitude];
    CLLocationDistance distance = [locB distanceFromLocation:locA];
    double dist = distance/1609.344;
    _distance.text = [NSString stringWithFormat:@"%.1f miles away",dist];
    
    
    
}

//for changing profile image...
-(void) change:(NSNotification *) notification{
    UserInfo *userinfo = [UserInfo instance];
    setImageUrl(self.image, userinfo.imageUrl);
}

//end...

-(void)slideUpContainer:(UISwipeGestureRecognizer*)swipeGesture{
    //[self dismissViewControllerAnimated:YES completion:nil];
    [self.view setHidden:YES];
    [(HomeViewController*)(((MainViewController*)kMainViewController).rootViewController) openUserProfile:_user_data : NO];//[_user_data valueForKey:kid]];
    
    [self removeProfileView];
    

}
-(void)remove_profileView{
    [self.view setHidden:YES];
    [self removeProfileView];
    
}
-(void)removeProfileView{
    
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionOverrideInheritedOptions
                     animations:^{
                         [self.view setCenter:CGPointMake(self.view.center.x, self.view.frame.size.height)];
                     }
                     completion:^(BOOL finished) {
                         [self.view removeFromSuperview];
                         //                         [kMainViewController addPanGesture];
                     }];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
-(void)addGestures{
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(slideUpContainer:)];
    swipeUp.delegate=self;
    swipeUp.numberOfTouchesRequired = 1;
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    [self.basicInfoContainer addGestureRecognizer:swipeUp];
    
    
    
    
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(removeProfileView)];
    [self.transperentView addGestureRecognizer:singleFingerTap];
    
    UITapGestureRecognizer *_singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(removeProfileView)];
    [self.transView addGestureRecognizer:_singleFingerTap];
}



-(void)gettingFeedback{
  //  UserInfo *userInfo = [UserInfo instance];
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    BOOL isAvailable = [appDelegate isNetworkAvailable];
    if(isAvailable){
        [self.view makeToastActivity];
        NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
        //NSString *s = [userInfo valueForKey:kuu_id];
        //[params setValue:s forKey:kid];
        [params setValue:self.user_id forKey:kid];
       // [self.view makeToastActivity];
        GenericFetcher *fetcher = [[GenericFetcher alloc]init];
        
        [fetcher fetchWithUrl:[URLBuilder urlForMethod:kget_feedback withParameters:nil]
                   withMethod:POST_REQUEST withParams:params completionBlock:^(NSDictionary *dict) {
                       // NSLog(@"%@",dict);
                       int status = [[dict valueForKey:kstatus] intValue];
                       if (status == 1) {
                           [self.view hideToastActivity];
                           NSArray *feedback = [dict valueForKey:kfeedback];
                           feedBacks = [[NSMutableArray alloc] initWithArray:feedback];
                           if([feedBacks count] == 0)
                               [_noReviewLabel setHidden:NO];

                           [self.tableView reloadData];
                           
                       }
                       else
                       {
                           [self.view hideToastActivity];
                           [_noReviewLabel setHidden:NO];
                           
                       }
                       //[self.view hideToastActivity];
                       
                   }
                   errorBlock:^(NSError *error) {
                       [self.view hideToastActivity];
                       NSLog(@"no internet");
                       NSLog(@"%@",error);
                   }];
    }
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //by ahmad, to change profile image....
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(change:)
                                                 name:@"change" object:nil];
    //end...
    UserInfo *userinfo = [UserInfo instance];
    [self addGestures];
    [self gettingFeedback];
    [self setProfileInfo];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.navigationController.navigationBarHidden = true;
    
    // Load the file content and read the data into arrays
    [self.tableView reloadData];
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    self.tableView.separatorColor = [UIColor clearColor];
    [_noReviewLabel setHidden:YES];
    if([[userinfo valueForKey:kuu_id] isEqualToString:[_user_data valueForKey:kid]])
    {
        [_distance setHidden:YES];
        [_messageButton setHidden:YES];
    }
    
}

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
    static NSString *simpleTableIdentifier = @"HalfProfileTableViewCell";
    
    HalfProfileTableViewCell *cell = (HalfProfileTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HalfProfileTableViewCell" owner:self options:nil];
        
        cell = [nib objectAtIndex:0];
        cell.image.layer.cornerRadius = cell.image.bounds.size.width/2;
        cell.image.layer.masksToBounds = YES;

        makeViewRound(cell.imageContainerView);
    }
    NSDictionary *feedBack = [feedBacks objectAtIndex:indexPath.row];
    
    cell.name.text = [feedBack valueForKey:kname];
    cell.detail_name.text = [feedBack valueForKey:kfeedback_msg];
    //ranging feedback section...
    cell.detail_name.textContainer.maximumNumberOfLines = 3;
    //end...
    setImageUrl(cell.image,[feedBack valueForKey:kprofile_image]);
//    cell.imageContainerView.layer.cornerRadius = cell.imageContainerView.bounds.size.width/2;
//    cell.imageContainerView.layer.masksToBounds = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    CGPoint point = CGPointMake(0,0);
    
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
    
    [cell.ratingReview addSubview:coloredRatingControl];

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return NO;
}

// change the titel of delet buton


//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    NSLog(@"You hit the delete button.");
//    
//}
//-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    
//    return @"Report";
//    
//}



- (IBAction)showChatScreen:(id)sender {
    [self.view setHidden:YES];
    [self removeProfileView];
    UserInfo *userinfo = [UserInfo instance];
    if(![[_user_data valueForKey:kid]isEqualToString:[userinfo valueForKey:kuu_id]]){
    [(HomeViewController*)(((MainViewController*)kMainViewController).rootViewController) showUserChat:
     [NSString stringWithFormat:@"%@@%@",[_user_data valueForKey:kid],SERVER_DOMAIN]];
    }
    //tbox test: 110498896056432
    //dilawer: 10208194151005917
    //ahmed: 603304643166479
    //abeera: 	597942987045064

}
@end
