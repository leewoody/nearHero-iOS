
//  HomeViewController.m
//  nearhero
//
//  Created by Dilawer Hussain on 6/2/16.
//  Copyright © 2016 TBoxSolutionz. All rights reserved.
//

#import "HomeViewController.h"
#import "AppDelegate.h"
#import "JobsListViewController.h"
#import "SideMenuViewController.h"
#import "Constants.h"
#import "UserInfo.h"
#import "URLBuilder.h"
#import "GenericFetcher.h"
#import "InviteViewController.h"
#import "MapUserAnnotation.h"
#import "MMPulseView.h"
#import "ChatViewController.h"
#import "SearchOptionViewController.h"
#import "NearHeroProViewController.h"
//for searching by ahmad.
#import "SearchViewController.h"
#import "UnlockProViewController.h"
#import "MessageViewController.h"

#import "UserSettings.h"
#import "Toast+UIView.h"
#import <Crashlytics/Crashlytics.h>
#import "ClusterAnnotationView.h"
@import GoogleMobileAds;
static double mercadorRadius = 85445659.44705395;
static double mercadorOffset = 268435456;
//static NSString *subscriberSearchRange = @"7916";
//static NSString *nonSubscriberSearchRange = @"10.0";

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)




static NSInteger kMaxObjectsCount = 1000;
inline static CLLocationCoordinate2D referenceLocation()
{
    return CLLocationCoordinate2DMake(50, 14.42);
}
inline static CLLocationDegrees degreesDispersion()
{
    return 0.5;
}

@interface HomeViewController ()
{
    double zoomLevel;
}
@property (nonatomic,strong) MMPulseView *loadingPulseView;
@property (nonatomic,strong) CLLocationManager *locationManager;
@end

@implementation HomeViewController{
    bool isUpdateLocationClicked;
    NSString *cityName ;
    UserSettings *userSettings;
   // ADInterstitialAd* _interstitial;
    BOOL _requestingAd;
 //   GADInterstitial *interstitial;
    NSString *searchStr;
    BOOL isSearchCalledFirstTime;

}
-(AppDelegate *)appDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}
#pragma mark - delegate SelectJobTitleViewController
-(void)getStartedTapped{
    [jobTitleVC.view removeFromSuperview];
}

#pragma mark - delegate UserLocationViewController
-(void)allowTapped{
    [userlocationVC.view removeFromSuperview];
}


#pragma mark -
-(void)firstTimeLoad{
    
    jobTitleVC = [[SelectJobTitleViewController alloc]initWithNibName:@"SelectJobTitleViewController" bundle:nil];
    [jobTitleVC setDelegate:self];
    [jobTitleVC.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:jobTitleVC.view];
}
-(void)setupProfileImage{
    UserInfo *userinfo = [UserInfo instance];
    setImageUrl(self.img_profile, userinfo.imageUrl);
    makeViewRound(profile_img_container);
    //The setup code (in viewDidLoad in your view controller)
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(openSideMenu:)];
    [profile_img_container addGestureRecognizer:singleFingerTap];
}
-(void)addAnnotations{
    
    
    CLLocationCoordinate2D coord = {.latitude =  12.3456, .longitude =  -7.890};
    MKCoordinateSpan span = {.latitudeDelta =  0.07, .longitudeDelta =  0.07};
    MKCoordinateRegion region = {coord, span};

    [self.mapView setDelegate:self];
    [self.mapView setRegion:region];


    MapUserAnnotation *ann = [[MapUserAnnotation alloc] init];
    ann.title=@"put title here";
    ann.coordinate = region.center;
    [self.mapView addAnnotation:ann];

}

-(void)setMapRegion{
    CLLocationCoordinate2D coord = {.latitude =  _mapView.userLocation.coordinate.latitude, .longitude =  _mapView.userLocation.coordinate.longitude};
    MKCoordinateSpan span = {.latitudeDelta =  0.01f, .longitudeDelta =  0.01f};
    MKCoordinateRegion region = {coord, span};
    [self.mapView setRegion:region animated:YES];
}

-(void)loadUsersOnMap:(NSArray*)users{
    UserInfo *userInfo = [UserInfo instance];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^
                   {
                       
                       MapUserAnnotation* showUser = [MapUserAnnotation new];
                       [showUser setUserData:[users objectAtIndex:0]];
                          showUser.coordinate = CLLocationCoordinate2DMake([[showUser.userData valueForKey:kLat] floatValue],[[showUser.userData valueForKey:kLong] floatValue]);
                       CLLocationCoordinate2D showUserCoordinate = showUser.coordinate;
                       srand48(time(0));
                      
                       for( NSUInteger i = 0; i < users.count; ++i )
                       {
                           
                          if(! [[[users objectAtIndex:i] valueForKey:kid] isEqualToString:[userInfo valueForKey:kuu_id]])
                           {
                               MapUserAnnotation* object = [MapUserAnnotation new];
                               object.index=i;
                               
                               [object setUserData:[users objectAtIndex:i]];
                               object.coordinate = CLLocationCoordinate2DMake([[object.userData valueForKey:kLat] floatValue],[[object.userData valueForKey:kLong] floatValue]);
                               CLLocationCoordinate2D userCoordinate = object.coordinate;
                               
                               [self.qTree insertObject:object];
                           }

                           dispatch_async(dispatch_get_main_queue(), ^
                                          {
                                              [self reloadAnnotations];
                                              if(![searchStr isEqualToString:@" "])
                                              {
                                                  MKCoordinateSpan span = {.latitudeDelta =  0.01f, .longitudeDelta =  0.01f};
                                                  MKCoordinateRegion region = {showUserCoordinate, span};
                                                  [self.mapView setRegion:region animated:YES];
   
                                              }
                                              else{
                                                                    [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];

                                              }
                                            
                                          });
                       }
                       
//                       MKCoordinateSpan span = {.latitudeDelta =  0.01f, .longitudeDelta =  0.01f};
//                       MKCoordinateRegion region = {showUserCoordinate, span};
//                       [self.mapView setRegion:region animated:YES];
//
                       
//                       [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];

                       //to move on the user location.
                       
                       
                       //  int distance = 10000;
                
//                       int distance = 5000;
//      /Users/apple/Documents/nearhero-ios/nearhero/View/Categories/NSMutableURLRequest+Parameters.m:85:51: Values of type 'NSUInteger' should not be used as format arguments; add an explicit cast to 'unsigned long' instead                 MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(showUserCoordinate, distance, distance);
//                       MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:region];
//                       [self.mapView setRegion:adjustedRegion animated:YES];
                      
                      
                   });
}


#pragma mark - location manager delegate and functions
- (void)locationManager:(CLLocationManager *)manager
didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    if (status == kCLAuthorizationStatusAuthorized ||
        status == kCLAuthorizationStatusAuthorizedAlways ||
        status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        self.mapView.showsUserLocation = YES;

    }
    else if(status == kCLAuthorizationStatusDenied){
        self.mapView.showsUserLocation = NO;
    }
}

- (void)requestAlwaysAuthorization
{
    CLAuthorizationStatus authorizationStatus= [CLLocationManager authorizationStatus];
    if (authorizationStatus == kCLAuthorizationStatusAuthorized ||
        authorizationStatus == kCLAuthorizationStatusAuthorizedAlways ||
        authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse) {
        self.mapView.showsUserLocation = YES;

    }
    else{
        [self.locationManager requestAlwaysAuthorization];
    }

    
}

-(void)ChangeProfileImage{
    UserInfo *userinfo = [UserInfo instance];
    setImageUrl(self.img_profile, userinfo.imageUrl);
}


-(void) change:(NSNotification *) notification{
    UserInfo *userinfo = [UserInfo instance];
    setImageUrl(self.img_profile, userinfo.imageUrl);
}


-(void)showView{
    [self.tView setHidden:NO];
}
-(void)switchToUserProfileImage{
    
    UserInfo *userInfo = [UserInfo instance];
    MKAnnotationView *userLocationAnnotation;
    userLocationAnnotation = [self.mapView viewForAnnotation:self.mapView.userLocation];

    UIView * pulseContainer = [userLocationAnnotation viewWithTag:10001];
    UIView * profileImgContinaer = [pulseContainer viewWithTag:10002];
    UIImageView *imgView = [profileImgContinaer viewWithTag:100002];
    
    imgView.contentMode = UIViewContentModeCenter;
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    imgView.clipsToBounds = YES;

    if(userSettings.showMeOnMapFlag){
        [imgView sd_setImageWithURL:[NSURL URLWithString:[userInfo valueForKey:kImageUrl]] completed:nil];
    }
    else
        imgView.image = [UIImage imageNamed:@"face_1"];{

        }
    
}
-(void)hideView{
    //[self.tView setAlpha:0.0];
    [self.tView setHidden:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tView setHidden:YES];
//    [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    self.mapView.showsUserLocation = YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.didUserLoad = true;
    self.flag = true;
    userSettings = [UserSettings instance];
//    if( !(userSettings.isSubscribed) &&!(userSettings.showAdd))
//   [self createAndLoadInterstitial];

    //self.tView.alpha = 0.6;
    //[self showFullScreenAd];
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0"))
        [self.mapView setShowsCompass:NO];

    [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
   
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(change:)
                                                 name:@"change" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"search" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(searchUser:)
                                                 name:@"search"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(switchToUserProfileImage)
                                                 name:@"ShowMeOnMap" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadLocationAnnotaion)
                                                 name:kkreloadLocationAnnotationOnMap object:nil];

    isSearchCalledFirstTime = true;
    
    zoomLevel = 32186 ;
    [profileVC setControllerDelegate:self];
    
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager setDelegate:self];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;

    [self requestAlwaysAuthorization];
    UserInfo *userInfo = [UserInfo instance];
    NSString *profession = [userInfo valueForKey:kprofession];
    if(profession == nil || [profession isEqualToString:@""]) {
        [self performSelector:@selector(firstTimeLoad) withObject:nil afterDelay:0.1];
    }
    [self setupProfileImage];
    [self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate animated:YES];

    self.qTree = [QTree new];
    search_bar.hidden = YES;
    
    
            _loadingPulseView = [MMPulseView new];
            _loadingPulseView.frame = CGRectMake(0,0,120,120);
    
            _loadingPulseView.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    _loadingPulseView.colors =  @[(__bridge id)[UIColor colorWithRed:139.0/255.0 green:196.0/255.0 blue:250.0/255.0 alpha:0.7].CGColor,(__bridge id)[UIColor colorWithRed:139.0/255.0 green:196.0/255.0 blue:250.0/255.0 alpha:0.7].CGColor];
    
            _loadingPulseView.minRadius = 10;
            _loadingPulseView.maxRadius = 40;
    
            _loadingPulseView.duration = 3;
            _loadingPulseView.count = 1;
            _loadingPulseView.lineWidth = 40.0f;
    

}
//- (IBAction)crashButtonTapped:(id)sender {
//    [[Crashlytics sharedInstance] crash];
//}

-(void) reloadLocationAnnotaion
{
    CLLocationCoordinate2D tempCoord;
    
    //[self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate];
    tempCoord.latitude = 51.477385;
    tempCoord.longitude = 7.216587;
    [_mapView setCenterCoordinate:tempCoord];
    MKCoordinateSpan span = {.latitudeDelta =  0.01f, .longitudeDelta =  0.01f};
    MKCoordinateRegion region = {tempCoord, span};
    [self.mapView setRegion:region];
    [self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate];


    

   // [self setMapRegion];
  //  [_mapView removeAnnotation:self.mapView.userLocation];
   // [_mapView addAnnotation:self.mapView.userLocation];
}
- (void)createAndLoadInterstitial {
    userSettings.showAdd = YES;
    [userSettings saveUserSettings];
    self.interstitial =
    [[GADInterstitial alloc] initWithAdUnitID:@"ca-app-pub-3940256099942544/4411468910"];
    self.interstitial.delegate = self;

    
    GADRequest *request = [GADRequest request];
    // Request test ads on devices you specify. Your test device ID is printed to the console when
    // an ad request is made.
    request.testDevices = @[
                            @"2077ef9a63d2b398840261c8221a0c9a"  // Eric's iPod Touch
                            ];//@[ kGADSimulatorID, @"2077ef9a63d2b398840261c8221a0c9a" ];
    [self.interstitial loadRequest:request];
}


#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                        
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    if (currentLocation != nil) {
    }
}
-(void)reloadAnnotations
{
    if( !self.isViewLoaded ) {
        return;
    }
    
    const MKCoordinateRegion mapRegion = self.mapView.region;
    BOOL useClustering = YES;
    const CLLocationDegrees minNonClusteredSpan = useClustering ? MIN(mapRegion.span.latitudeDelta, mapRegion.span.longitudeDelta) / 5
    : 0;
    NSArray* objects = [self.qTree getObjectsInRegion:mapRegion minNonClusteredSpan:minNonClusteredSpan];
    
    NSMutableArray* annotationsToRemove = [self.mapView.annotations mutableCopy];
    [annotationsToRemove removeObject:self.mapView.userLocation];
    [annotationsToRemove removeObjectsInArray:objects];
    [self.mapView removeAnnotations:annotationsToRemove];
    
    NSMutableArray* annotationsToAdd = [objects mutableCopy];
    [annotationsToAdd removeObjectsInArray:self.mapView.annotations];
    
    [self.mapView addAnnotations:annotationsToAdd];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(IBAction)openSideMenu:(id)sender{
    [kMainViewController showLeftViewAnimated:YES completionHandler:nil];
    
}

- (IBAction)openJobsList:(UIButton *)sender {
    
    [self viewinvitescreen:NO];
}
//#pragma mark UISearchbar delegate
//
//- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
//    NSString *search_text = searchBar.text;
//    [searchBar setText:@""];
//}
//
//- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
//    [self searchClick:nil];
//}
- (void)searchUser:(NSNotification *)notification
{
    if ([[notification name] isEqualToString:@"search"]) {
        NSMutableArray* annotationsToRemove = [self.mapView.annotations mutableCopy];
        [annotationsToRemove removeObject:self.mapView.userLocation];
        for(int i = 0; i < annotationsToRemove.count; i++)
        {
            [self.qTree removeObject:[annotationsToRemove objectAtIndex:i]];
            
        }
        [self.mapView removeAnnotations:annotationsToRemove];


        NSMutableDictionary *dict = [notification userInfo];
        NSString *searchString = [dict valueForKey:kkeyword];
        if([UserSettings instance].isSubscribed)
            [self searchUsers:searchString:subscriberSearchRange];
        else
            [self searchUsers:searchString:nonSubscriberSearchRange];
    }
   
}

-(void)searchUsers:(NSString*)searchString:(NSString*)radius{

    
    searchStr = searchString;
    self.qTree = [[QTree alloc] init];
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    BOOL isAvailable = [appDelegate isNetworkAvailable];
    if(isAvailable)
    {
        //[self startPulseLoading];
        [self.view makeToastActivity];
        //This is my web api code for search...
        NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
        [params setValue:searchString forKey:kkeyword];
        [params setValue:radius forKey:kradius];
        [params setValue:[NSString stringWithFormat:@"%f",_mapView.userLocation.coordinate.latitude]  forKey:klat];
        [params setValue:[NSString stringWithFormat:@"%f",_mapView.userLocation.coordinate.longitude] forKey:klng];


        //[params setObject:password forKey:@"password"];
        GenericFetcher *fetcher = [[GenericFetcher alloc]init];
        //if there is a POST request send params in the fetcher method, if get request send nil to that
        // if there is a GET request send params in the urlbuilder method and nil to the fetcher method
        [fetcher fetchWithUrl:[URLBuilder urlForMethod:ksearch_user withParameters:nil]
                   withMethod:POST_REQUEST withParams:params completionBlock:^(NSDictionary *dict) {
                       NSLog(@"%@",dict);
                       isSearchCalledFirstTime = false;
                       NSMutableDictionary *response = [dict valueForKey:kresponse];
                       int status = [[dict valueForKey:kstatus] intValue];
                       if (status == 1) {
                           [self.view hideToastActivity];
                           NSArray *users = [response valueForKey:kusers];
                           [self loadUsersOnMap:users];
                           
                           
                       }
                       else
                       {
                           [self.view hideToastActivity];


                          if(![searchString isEqualToString:@" "] )//&&(!userSettings.isSubscribed))

                          {
                              if((!userSettings.isSubscribed)){
                                   SearchOptionViewController *searchOVC = [[SearchOptionViewController alloc]initWithNibName:@"SearchOptionViewController" bundle:nil];
                                   [searchOVC.view setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
                                   searchOVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                                   searchOVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
                                   [self presentViewController:searchOVC animated:YES completion:nil];
                              }
                              else{
                                  
                                  UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"No user found against your search" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                                  [alert show];
                              }
                           }
                         
                       }
                      
                   }
                   errorBlock:^(NSError *error) {
                     //  [self stopPulseLoading];
                       [self.view hideToastActivity];

                       NSLog(@"no internet");
                       NSLog(@"%@",error);
                       if(!isSearchCalledFirstTime){
                           UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Try Later" message:@"Internet Connection Problem" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                           [alert show];}
                       isSearchCalledFirstTime = false;

                   }];
    }
    
    else{
        if(!isSearchCalledFirstTime){
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Try Later" message:@"Internet Connection Problem" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
        }
        isSearchCalledFirstTime = false;
    }

}

- (IBAction)searchClick:(id)sender {
    [kMainViewController hideLeftViewAnimated:YES completionHandler:nil];
    [self.searchBtn setUserInteractionEnabled:NO];
    svc =[[SearchViewController alloc]initWithNibName:@"SearchViewController" bundle:nil];
    svc.isLayer = NO;
    [self.tView setAlpha:0.6];
    [self showView];
    [self.tView setAlpha:0.6];

    [svc.view setCenter:CGPointMake(self.view.center.x, self.view.center.y*2)];
    [svc.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
   
    [self.view addSubview:svc.view];
}

#pragma mark MapView Delegate

#pragma mark MKMapViewDelegate
-(void)mapView:(MKMapView*)mapView regionDidChangeAnimated:(BOOL)animated
{
    NSLog(@"long-->%f lat-->%f ",mapView.region.span.longitudeDelta,mapView.region.span.latitudeDelta);
    MKMapRect mRect = self.mapView.visibleMapRect;
    MKMapPoint eastMapPoint = MKMapPointMake(MKMapRectGetMinX(mRect), MKMapRectGetMidY(mRect));
    MKMapPoint westMapPoint = MKMapPointMake(MKMapRectGetMaxX(mRect), MKMapRectGetMidY(mRect));
    
    double distance = MKMetersBetweenMapPoints(eastMapPoint, westMapPoint);
     if(!_didUserLoad){
       if(distance > 16093 && distance > zoomLevel){
         //  [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
           if (!userSettings.isSubscribed)
           {
                [self openProScreen];
                [self setMapRegion];
           }

       }

    }
    zoomLevel = distance;
    [self reloadAnnotations];
  
}


-(MKAnnotationView*)mapView:(MKMapView*)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    static NSString * const identifier = @"myMapUserAnnotation";
    
    UserInfo *userInfo = [UserInfo instance];
    userSettings = [UserSettings instance];
    if( [annotation isKindOfClass:[QCluster class]] )
    {
        ClusterAnnotationView* annotationView = (ClusterAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:[ClusterAnnotationView reuseId]];
        if( !annotationView ) {
            annotationView = [[ClusterAnnotationView alloc] initWithCluster:(QCluster*)annotation];
        }
        annotationView.cluster = (QCluster*)annotation;
        return annotationView;
    }
    else if([annotation isKindOfClass:[MKUserLocation class]]){
        
        MapUserAnnotation *ann = (MapUserAnnotation*)annotation;
        
        MKAnnotationView* annotationView = [_mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        
        if (annotationView)
            annotationView.annotation = ann;
        else{
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:ann reuseIdentifier:identifier];
            UITapGestureRecognizer *pinTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pinTapped:)];
            [annotationView addGestureRecognizer:pinTap];

        }
        
        
        
        UIImageView* imgView=nil;
        UIImageView* shadowImgView = nil;
        
        UIView *img_container=nil;
        UIView *shadowImgContainer = nil;
        if (![annotationView viewWithTag:10001]) {
            shadowImgContainer = [[UIView alloc] init];
            CGRect r = shadowImgContainer.frame;
            r.size.width = 120;
            r.size.height = 120;
            shadowImgContainer.frame = r;
            [shadowImgContainer setTag:10001];
            img_container = [[UIView alloc]init];
            r = img_container.frame;
            r.size.width = 37;
            r.size.height = 38;
            r.origin.x = 41.5;
            r.origin.y = 41.5;
            img_container.frame = r;
            [img_container setTag:10002];
            
            shadowImgView = [[UIImageView alloc] init];
            r = shadowImgView.frame;
            r.size.width = 60;
            r.size.height = 67;
            shadowImgView.frame = r;
            [shadowImgView setTag:100001];
            [shadowImgContainer addSubview:shadowImgView];
            shadowImgView.image = nil;

            
            imgView = [[UIImageView alloc] init];
            r = imgView.frame;
            r.origin.x = 0;
            r.origin.y = 0;
            r.size.width = 37;
            r.size.height = 38;
            imgView.frame = r;
            [imgView setTag:100002];
            imgView.contentMode = UIViewContentModeScaleToFill;
            [img_container addSubview:imgView];


            makeViewRound(img_container);
            [imgView setUserInteractionEnabled:YES];
            
            
            
        }else{
            shadowImgContainer = [annotationView viewWithTag:10001];
            shadowImgView = [shadowImgContainer viewWithTag:100001];

            img_container = [shadowImgContainer viewWithTag:10002];
            imgView = [img_container viewWithTag:100002];
            //  if (![imgView isKindOfClass:[UIView class]])
            
            // [imgView sd_setImageWithURL:[NSURL URLWithString:[userInfo valueForKey:kImageUrl]] completed:nil];
            // else
            CGRect r = shadowImgContainer.frame;
            r.size.width = 120;
            r.size.height = 120;
            shadowImgContainer.frame = r;
            r = img_container.frame;
            r.size.width = 37;
            r.size.height = 38;
            r.origin.x = 41.5;
            r.origin.y = 41.5;
            img_container.frame = r;
            NSLog(@"TEST");
        }
        
       // [img_container setUserInteractionEnabled:YES];
        
        CGRect r=annotationView.frame;
        r.size.width = 67;
        r.size.height = 67;
        [annotationView setFrame:r];
        [annotationView addSubview:shadowImgContainer];
        //        _loadingPulseView = [MMPulseView new];
        //        _loadingPulseView.frame = CGRectMake(0,0,120,120);
        //
        //        _loadingPulseView.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        //        _loadingPulseView.colors =  @[(__bridge id)[UIColor colorWithRed:139.0/255.0 green:196.0/255.0 blue:250.0/255.0 alpha:0.7].CGColor,(__bridge id)[UIColor colorWithRed:139.0/255.0 green:196.0/255.0 blue:250.0/255.0 alpha:0.7].CGColor];
        //        //@[(__bridge id)[UIColor colorWithRed:0.0 green:0.478 blue:0.984 alpha:0.7].CGColor,(__bridge id)[UIColor colorWithRed:0.0 green:0.478 blue:0.984 alpha:0.7].CGColor];
        //
        //
        //
        //        _loadingPulseView.minRadius = 10;
        //        _loadingPulseView.maxRadius = 40;
        //
        //        _loadingPulseView.duration = 3;
        //        _loadingPulseView.count = 1;
        //        _loadingPulseView.lineWidth = 40.0f;
        [_loadingPulseView startAnimation];
        [_loadingPulseView setCenter:shadowImgContainer.center];
        
        [shadowImgContainer addSubview:_loadingPulseView];
        [shadowImgContainer addSubview:img_container];
        
        imgView.contentMode = UIViewContentModeScaleToFill;
        if(userSettings.showMeOnMapFlag)
            [imgView sd_setImageWithURL:[NSURL URLWithString:[userInfo valueForKey:kImageUrl]] completed:nil];
        else
            imgView.image = [UIImage imageNamed:@"face_1"];
        shadowImgView.image = nil;
        CGRect r1 = shadowImgContainer.frame;
        CGRect r2 = img_container.frame;
        CGRect r3 = shadowImgView.frame;
        CGRect r4 = imgView.frame;
       
        return annotationView;
        
    }
    else
    {
        MapUserAnnotation *ann = (MapUserAnnotation*)annotation;
        
        MKAnnotationView* annotationView = [_mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        annotationView = nil;
        if (annotationView){
            annotationView.annotation = ann;

        }
        
        else{
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:ann reuseIdentifier:identifier];
            UITapGestureRecognizer *pinTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pinTapped:)];
            [annotationView addGestureRecognizer:pinTap];

        }
        
        NSDictionary *userData = nil;
        
        if (![annotation isKindOfClass:[MKUserLocation class]])
            userData =[ann userData];
        
        
        
        UIImageView* imgView=nil;
        UIImageView* shadowImgView = nil;
        
        UIView *img_container=nil;
        UIView *shadowImgContainer = nil;
        if (![annotationView viewWithTag:10001]) {
            shadowImgContainer = [[UIView alloc] init];
            CGRect r = shadowImgContainer.frame;
            r.size.width = 60;
            r.size.height = 67;
            shadowImgContainer.frame = r;
            [shadowImgContainer setTag:10001];
            
            
            shadowImgView = [[UIImageView alloc] init];
            r = shadowImgView.frame;
            r.size.width = 60;
            r.size.height = 67;
            shadowImgView.frame = r;
            [shadowImgView setTag:100001];
            [shadowImgContainer addSubview:shadowImgView];
            shadowImgView.image = [UIImage imageNamed:@"shadow"];
            
            img_container = [[UIView alloc]init];
            r = img_container.frame;
            r.size.width = 37;
            r.size.height = 38;
            r.origin.x = 9;
            r.origin.y = 0;
            img_container.frame = r;
            [img_container setTag:10002];
            
            
            
            imgView = [[UIImageView alloc] init];
            r = imgView.frame;
            r.size.width = 37;
            r.size.height = 38;
            imgView.frame = r;
            [imgView setTag:100002];
            imgView.contentMode = UIViewContentModeScaleToFill;
            [img_container addSubview:imgView];
            [shadowImgContainer addSubview:img_container];

            makeViewRound(img_container);
            [imgView setUserInteractionEnabled:YES];
            [imgView sd_setImageWithURL:[NSURL URLWithString:[userData valueForKey:kprofile_image]] completed:nil];
            
            
            
        }else{
            shadowImgContainer = [annotationView viewWithTag:10001];
            shadowImgView = [shadowImgContainer viewWithTag:100001];
            img_container = [shadowImgContainer viewWithTag:10002];
            imgView = [img_container viewWithTag:100002];
            CGRect r = shadowImgContainer.frame;
            r.size.width = 60;
            r.size.height = 67;
            shadowImgContainer.frame = r;
            r = img_container.frame;
            r.size.width = 37;
            r.size.height = 38;
            r.origin.x = 9;
            r.origin.y = 0;
            img_container.frame = r;
            shadowImgView.image = [UIImage imageNamed:@"shadow"];

            [imgView sd_setImageWithURL:[NSURL URLWithString:[userData valueForKey:kprofile_image]] completed:nil];
            NSLog(@"TEST");
            [_loadingPulseView stopAnimation];
        }
        
        [img_container setUserInteractionEnabled:YES];
        CGRect r1 = shadowImgContainer.frame;
        CGRect r2 = img_container.frame;
        CGRect r3 = shadowImgView.frame;
        CGRect r4 = imgView.frame;
        CGRect r=annotationView.frame;
        r.size.width = 60;
        r.size.height = 67;
        [annotationView setFrame:r];
        [annotationView addSubview:shadowImgContainer];
        shadowImgView.image = [UIImage imageNamed:@"shadow"];
        imgView.contentMode = UIViewContentModeScaleToFill;
        [imgView sd_setImageWithURL:[NSURL URLWithString:[userData valueForKey:kprofile_image]] completed:nil];
        
        return annotationView;
    }
    return nil;
}
-(IBAction)pinTapped:(UITapGestureRecognizer *)sender {
    MKAnnotationView *view = (MKAnnotationView *)sender.view;
    
    if ([view.annotation isKindOfClass:[MapUserAnnotation class]]) {
      //  [self.mapView setUserInteractionEnabled:NO];
        MapUserAnnotation *ann = (MapUserAnnotation*)view.annotation;
        NSDictionary *user_data = ann.userData;
//        [NSTimer scheduledTimerWithTimeInterval:2.0
//                                         target:self
//                                       selector:@selector(enableInteraction)
//                                       userInfo:nil
//                                        repeats:NO];
        [self openUserProfile:user_data: NO];
    }else if([view.annotation isKindOfClass:[MKUserLocation class]]){
        if(userSettings.showMeOnMapFlag){
          //  [self.mapView setUserInteractionEnabled:NO];
            
            UserInfo *userInfo = [UserInfo instance];
            NSMutableDictionary *user_data = [[NSMutableDictionary alloc] init];
            [user_data setValue:[userInfo valueForKey:kuu_id] forKey:kid];
            [user_data setValue:[userInfo valueForKey:kname] forKey:kname];
            [user_data setValue:[userInfo valueForKey:kprofession] forKey:kprofession];
            [user_data setValue:[userInfo valueForKey:klocation] forKey:klocation];
            [user_data setValue:[userInfo valueForKey:kImageUrl] forKey:kprofile_image];
            [self openUserProfile:user_data: NO];
//            [NSTimer scheduledTimerWithTimeInterval:2.0
//                                             target:self
//                                           selector:@selector(enableInteraction)
//                                           userInfo:nil
//                                            repeats:NO];
//            
        }
    }
   
}
-(void)showSubscriptionView{
    if(_didUserLoad && (self.mapView.userLocation.coordinate.latitude != 0.00 && self.mapView.userLocation.coordinate.longitude != 0.00)){
        _didUserLoad = false;
        if([UserSettings instance].isSubscribed)
            [self searchUsers:@" ":subscriberSearchRange];
        else
            [self searchUsers:@" ":nonSubscriberSearchRange];
        [self getCityName];
    }
}
- (void)mapViewDidFinishRenderingMap:(MKMapView *)mapView fullyRendered:(BOOL)fullyRendered{
    [self performSelector:@selector(showSubscriptionView) withObject:nil afterDelay:0.2];
}

-(void)mapView:(MKMapView*)mapView didSelectAnnotationView:(MKAnnotationView*)view{
    id<MKAnnotation> annotation = view.annotation;
    if( [annotation isKindOfClass:[QCluster class]] ) {
        QCluster* cluster = (QCluster*)annotation;
        [mapView setRegion:MKCoordinateRegionMake(cluster.coordinate, MKCoordinateSpanMake(2.5 * cluster.radius, 2.5 * cluster.radius))
                  animated:YES];
    }
//    if ([view.annotation isKindOfClass:[MapUserAnnotation class]]) {
//        [self.mapView setUserInteractionEnabled:NO];
//        MapUserAnnotation *ann = (MapUserAnnotation*)view.annotation;
//        NSDictionary *user_data = ann.userData;
//        [NSTimer scheduledTimerWithTimeInterval:2.0
//                                         target:self
//                                       selector:@selector(enableInteraction)
//                                       userInfo:nil
//                                        repeats:NO];
//        [self openUserProfile:user_data: NO];
//    }else if([view.annotation isKindOfClass:[MKUserLocation class]]){
//        if(userSettings.showMeOnMapFlag){
//            [self.mapView setUserInteractionEnabled:NO];
//
//            UserInfo *userInfo = [UserInfo instance];
//            NSMutableDictionary *user_data = [[NSMutableDictionary alloc] init];
//            [user_data setValue:[userInfo valueForKey:kuu_id] forKey:kid];
//            [user_data setValue:[userInfo valueForKey:kname] forKey:kname];
//            [user_data setValue:[userInfo valueForKey:kprofession] forKey:kprofession];
//            [user_data setValue:[userInfo valueForKey:klocation] forKey:klocation];
//            [user_data setValue:[userInfo valueForKey:kImageUrl] forKey:kprofile_image];
//            [self openUserProfile:user_data: NO];
//            [NSTimer scheduledTimerWithTimeInterval:2.0
//                                             target:self
//                                           selector:@selector(enableInteraction)
//                                           userInfo:nil
//                                            repeats:NO];
//
//        }
//    }
    [mapView deselectAnnotation:view.annotation animated:NO];

}
-(void)enableInteraction{
    [self.mapView setUserInteractionEnabled:YES];
}

-(void)set{
    [profileVC.containerView setCenter:CGPointMake(self.view.center.x, self.view.center.y*2)];
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionLayoutSubviews
                     animations:^{
                        [profileVC.containerView setCenter:CGPointMake(self.view.center.x, self.view.center.y*2)];
                     }
                     completion:^(BOOL finished) {
                     }];

}

-(void)openHalfProfileScreen:(NSDictionary*)user_data{
    
    
//    [kMainViewController removePanGesture];
//    
//    halfProfileVC =[[HalfProfileViewController alloc]initWithNibName:@"HalfProfileViewController" bundle:nil];
//    halfProfileVC.user_data = user_data;
//    halfProfileVC.user_id = [user_data valueForKey:kid];
//    halfProfileVC.api_key = @"";
//    
//    //[messagesVC.view setCenter:CGPointMake(self.view.center.x, self.view.center.y*2)];
//    //self.view.frame.size.height+60
//    [halfProfileVC.view setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
//   
//    
//    
//    [self.view addSubview:halfProfileVC.view];
//    
//    [UIView animateWithDuration:0.5
//                          delay:0
//                        options:UIViewAnimationOptionLayoutSubviews
//                     animations:^{
//                         [halfProfileVC.view setCenter:CGPointMake(self.view.center.x, self.view.center.y)];
//                         //                         [profile_VC.containerView setCenter:self.view.center];
//                     }
//                     completion:^(BOOL finished) {
////                         [halfProfileVC.containerView setFrame:CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height)];
//                     }];
//    
//    [self.view addSubview:halfProfileVC.view];
    
    
}

-(void)openUserProfile:(NSMutableDictionary*)user : (BOOL) isLayer{
    profileVC = [[ProfileViewController alloc]initWithNibName:@"ProfileViewController" bundle:nil];
    profileVC.profileUser = user;
    profileVC.user_id = [user valueForKey:kid];
    profileVC.isLayer = isLayer;
    [self showView];
    //by ahmad.
    [profileVC setDelegate:self];
    
    [profileVC.view setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
    
    [UIView animateWithDuration:0.7
                          delay:0
                        options:UIViewAnimationOptionLayoutSubviews
                     animations:^{
                         [self.tView setAlpha:0.6];
                         [profileVC.view setCenter:CGPointMake(self.view.center.x, self.view.center.y)];
                         
                     }
                     completion:^(BOOL finished) {
                       
                     }];
    [self.view addSubview:profileVC.view];
}

#pragma mark - pulse loading view
-(void)startPulseLoading{
    _loadingPulseView = [MMPulseView new];
    _loadingPulseView.frame = CGRectMake(0,0,200,200);
    
    _loadingPulseView.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    _loadingPulseView.colors = @[(__bridge id)[UIColor colorWithRed:0.0 green:0.478 blue:0.984 alpha:0.7].CGColor,(__bridge id)[UIColor colorWithRed:0.0 green:0.478 blue:0.984 alpha:0.7].CGColor];
    
    CGRect screenRect = [UIScreen mainScreen].bounds;
    CGFloat posY = (CGRectGetHeight(screenRect)-320)/2/CGRectGetHeight(screenRect);
    _loadingPulseView.startPoint = CGPointMake(0.5, posY);
    _loadingPulseView.endPoint = CGPointMake(0.5, 1.0f - posY);
    
    _loadingPulseView.minRadius = 10;
    _loadingPulseView.maxRadius = 100;
    
    _loadingPulseView.duration = 7;
    _loadingPulseView.count = 5;
    _loadingPulseView.lineWidth = 20.0f;
    [_loadingPulseView startAnimation];
    [_loadingPulseView setCenter:self.view.center];
    [self.view addSubview:_loadingPulseView];
}

-(void)stopPulseLoading{
    [_loadingPulseView removeFromSuperview];
}

-(void)viewSettingScreen{
    [kMainViewController showHideLeftViewAnimated:YES completionHandler:nil];
    settingsVC =[[SettingViewController alloc]initWithNibName:@"SettingViewController" bundle:nil];
    [settingsVC.view setCenter:CGPointMake(self.view.center.x, self.view.center.y*2)];
    [settingsVC.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self showView];
    [self.tView setAlpha:0.6];

        [self.view addSubview:settingsVC.view];
    
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionLayoutSubviews
                     animations:^{
                         [settingsVC.view setCenter:CGPointMake(self.view.center.x, self.view.center.y)];

                     }
                     completion:^(BOOL finished) {
                        
                     }];
}

-(void)viewinvitescreen:(BOOL)isLayer{
    
    [kMainViewController hideLeftViewAnimated:YES completionHandler:nil];
    shareVC =[[ShareViewController alloc]initWithNibName:@"ShareViewController" bundle:nil];
    [shareVC.view setCenter:CGPointMake(self.view.center.x, self.view.center.y*2)];
    [shareVC.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    shareVC.isLayer = isLayer;
    [self showView];
    [self.tView setAlpha:0.6];
    [self.view addSubview:shareVC.view];
    

}

-(void)viewAllMessages{

    [kMainViewController showHideLeftViewAnimated:YES completionHandler:nil];
    ConversationalViewController *messagesVC = [[ConversationalViewController alloc]initWithNibName:@"ConversationalViewController" bundle:nil];
    [messagesVC.view setCenter:CGPointMake(self.view.center.x, self.view.center.y*2)];
    [messagesVC.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self showView];
    [self.tView setAlpha:0.6];

    [self.view addSubview:messagesVC.view];
    
    
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionLayoutSubviews
                     animations:^{
                         [messagesVC.view setCenter:CGPointMake(self.view.center.x, self.view.center.y)];
                     }
                     completion:^(BOOL finished) {
                     }];
    
}
-(void)showUserChat:(NSString*)chatPartner{
    
    [kMainViewController hideLeftViewAnimated:YES completionHandler:nil];
    [kMainViewController removePanGesture];
    sPHViewController = [[SPHViewController alloc] initWithNibName:@"SPHViewController" bundle:nil];
    sPHViewController.chatPartner = chatPartner;
    sPHViewController.isLayer = NO;
    
    [sPHViewController.view setCenter:CGPointMake(self.view.center.x, self.view.center.y*2)];

    [sPHViewController.view setFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height)];
    [self showView];
    [self.tView setAlpha:0.6];

    [self.view addSubview:sPHViewController.view];
    
    
    [UIView animateWithDuration:0.7
                          delay:0
                        options:UIViewAnimationOptionLayoutSubviews
                     animations:^{
                         [sPHViewController.view setCenter:CGPointMake(self.view.center.x, self.view.center.y)];
                         
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}
-(void)openMessageViewController{
    [kMainViewController hideLeftViewAnimated:YES completionHandler:nil];

    MessageViewController * mvc = [[MessageViewController alloc]initWithNibName:@"MessageViewController" bundle:nil];
    [mvc.view setCenter:CGPointMake(self.view.center.x, self.view.center.y)];
    [mvc.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    mvc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    mvc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:mvc animated:YES completion:nil];
}

-(void)showChatView:(NSString*)chatPartner{
    [kMainViewController removePanGesture];
    
    SPHViewController *sPHViewController = [[SPHViewController alloc] initWithNibName:@"SPHViewController" bundle:nil];
    sPHViewController.chatPartner = chatPartner;
    sPHViewController.isLayer = YES;
    [sPHViewController.view setFrame:CGRectMake(0,self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
    [self showView];
    [UIView animateWithDuration:0.7
                          delay:0
                        options:UIViewAnimationOptionLayoutSubviews
                     animations:^{
                         [self.tView setAlpha:0.6];
                         [sPHViewController.view setCenter:CGPointMake(self.view.center.x, self.view.center.y)];
                         
                     }
                     completion:^(BOOL finished) {
                         
                     }];
    [self.view addSubview:sPHViewController.view];
}

- (IBAction)showUserOnMap:(id)sender {
   [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];    isUpdateLocationClicked = true;
   [self setMapRegion];
   
  }

-(void)getCityName{
    UserInfo *userInfo = [UserInfo instance];
    CLLocationCoordinate2D myCoordinate = self.mapView.userLocation.location.coordinate;
    [userInfo setLatitude:_mapView.userLocation.location.coordinate.latitude];
    [userInfo setLongitude:_mapView.userLocation.location.coordinate.longitude];
    [userInfo saveUserInfo];
   
    
    
    CLGeocoder *ceo = [[CLGeocoder alloc]init];
   CLLocation *loc = [[CLLocation alloc]initWithLatitude:myCoordinate.latitude longitude:myCoordinate.longitude];
    
    
    [ceo reverseGeocodeLocation: loc completionHandler:
     ^(NSArray *placemarks, NSError *error) {
         CLPlacemark *placemark = [placemarks objectAtIndex:0];
         NSLog(@"placemark %@",placemark);
         cityName = [NSString stringWithFormat:@"%@,%@",[placemark.addressDictionary valueForKey:@"City"], [placemark.addressDictionary valueForKey:@"State"]];
         NSLog(@"addressDictionary %@", placemark.addressDictionary);
         
//         NSLog(@"placemark %@",placemark.region);
//         NSLog(@"placemark %@",placemark.country);  // Give Country Name
//         NSLog(@"placemark %@",placemark.locality); // Extract the city name
//         NSLog(@"location %@",placemark.name);
//         NSLog(@"location %@",placemark.ocean);
//         NSLog(@"location %@",placemark.postalCode);
//         NSLog(@"location %@",placemark.subLocality);
//         
//         NSLog(@"location %@",placemark.location);
//         //Print the location to console
//         NSLog(@"I am currently at %@",locatedAt);
         
         
    }];
    [self performSelector:@selector(saveLocationOnServer) withObject:nil afterDelay:6.0];
}


-(void)saveLocationOnServer{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    BOOL isAvailable = [appDelegate isNetworkAvailable];
    if(isAvailable){
        UserSettings *userSettings = [UserSettings instance];
        CLLocationCoordinate2D myCoordinate = self.mapView.userLocation.location.coordinate;
        NSString *lat;
        NSString *lng;
       
        UserInfo *userInfo = [UserInfo instance];
        userInfo.location = cityName;
        [userInfo saveUserInfo];
        
        lat = [NSString stringWithFormat:@"%.8f", myCoordinate.latitude];
        lng = [NSString stringWithFormat:@"%.8f", myCoordinate.longitude];
        GenericFetcher *fetcher = [[GenericFetcher alloc]init];
        UserInfo *userinfo = [UserInfo instance];
        NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
        [params setValue:[userinfo valueForKey:kapikey] forKey:kapi_key];
        [params setValue:lat forKey:klat];
        [params setValue:lng forKey:klng];
        [params setValue:cityName forKey:klocation];

        [fetcher fetchWithUrl:[URLBuilder urlForMethod:kupdate_location withParameters:nil] withMethod: POST_REQUEST withParams:params
              completionBlock:^(NSDictionary *dict){
                  NSLog(@"%@", dict);
                  int status = [[dict valueForKey:kstatus] intValue];
                  if(status == 1){
                      NSLog(@"updated successfully");
                      if(isUpdateLocationClicked == true){
                          NSString* successMessage = [dict valueForKey:kuser_info];
                      
                      }
                      
                  }
                  else
                  {
                      NSLog(@"Not Updated");
                  }
              }
            errorBlock:^(NSError* error)
            {
                NSLog(@"no internet");
                NSLog(@"%@", error);
            }];
    }
}

-(CLLocationCoordinate2D) getCoordinates{
    CLLocationCoordinate2D myCoordinate = self.mapView.userLocation.location.coordinate;
    return myCoordinate;
}

-(void)viewProfileScreen{
    [kMainViewController hideLeftViewAnimated:YES completionHandler:nil];
    [kMainViewController removePanGesture];
    [self.tView setHidden:NO];
    
    profileVC =[[ProfileViewController alloc]initWithNibName:@"ProfileViewController" bundle:nil];
    UserInfo *userinfo = [UserInfo instance];
    profileVC.user_id = [userinfo valueForKey:kuu_id];
    profileVC.api_key = [userinfo valueForKey:kapikey];
    profileVC.isLayer = NO;

    [profileVC.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    [self showView];
    [self.tView setAlpha:0.6];

    [self.view addSubview:profileVC.view];
    
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionLayoutSubviews
                     animations:^{
                         [profileVC.view setCenter:self.view.center];
                     }
                     completion:^(BOOL finished) {
                         [profileVC.containerView setFrame:CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height)];
                     }];
    
}

-(void)openWebView:(NSString*)url{
    WebViewController *webVC =[[WebViewController alloc]initWithNibName:@"WebViewController" bundle:nil];
    webVC.url = url;
    [webVC.view setCenter:CGPointMake(self.view.center.x, self.view.center.y*2)];
    [webVC.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:webVC.view];
}

-(void)openProScreen{
    [kMainViewController hideLeftViewAnimated:YES completionHandler:nil];
    NearHeroProViewController *nhProVC =[[NearHeroProViewController alloc]initWithNibName:@"NearHeroProViewController" bundle:nil];
   
    [nhProVC.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    nhProVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    nhProVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:nhProVC animated:YES completion:nil];
}
- (BOOL)testInternetConnection{
    __block BOOL status;
    internetReachableFoo = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    internetReachableFoo.reachableBlock = ^(Reachability*reach){
        dispatch_async(dispatch_get_main_queue(), ^{
            status = YES;
            NSLog(@"Yayyy, we have the interwebs!");
        });
    };
    internetReachableFoo.unreachableBlock = ^(Reachability*reach){
        dispatch_async(dispatch_get_main_queue(), ^{
            status = NO;
            NSLog(@"Someone broke the internet :(");
        });
    };
    return status;
}
- (double) getZoomLevel{
    return 21.00 - log2(self.mapView.region.span.longitudeDelta * mercadorRadius * M_PI / (180.0 * self.mapView.bounds.size.width));
}
-(void) enableSearchBtn{
    self.searchBtn.userInteractionEnabled = YES;
    
}
- (BOOL)connected{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}

#pragma mark Interstitial Ad
- (void)interstitialDidReceiveAd:(GADInterstitial *)ad{
    [self.interstitial presentFromRootViewController:self];
}

@end

