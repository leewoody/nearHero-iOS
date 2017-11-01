//
//  NearHeroProViewController.m
//  nearhero
//
//  Created by apple on 11/10/16.
//  Copyright © 2016 TBoxSolutionz. All rights reserved.
//

#import "NearHeroProViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "UserInfo.h"
#import "Constants.h"
#import "RageIAPHelper.h"
#import "Reachability.h"
#import "AppDelegate.h"
#import "HomeViewController.h"
#import "Toast+UIView.h"



@interface NearHeroProViewController ()
{
    UserInfo *userInfo;
    Boolean isSelected;
    int c;
    NSString *productId;
    Boolean reqGen;
}

@end

@implementation NearHeroProViewController
-(AppDelegate *)appDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
   // [self loadProducts];
    reqGen = false;
    self.view.autoresizesSubviews = YES;
    userInfo = [UserInfo instance];
    _pageController.transform = CGAffineTransformMakeScale(0.8, 0.8);
    makeViewRound(self.image_container);
    setImageUrl(self.image,[userInfo valueForKey:kImageUrl]);

    [self.oneMonthSubs setHidden:YES];
    [self.sixMonthSub setHidden:NO];
    [self.twelveMonthSubs setHidden:YES];
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(removeView:)];
    c = 1;
    [self.transparentView addGestureRecognizer:singleFingerTap];
    productId = @"com.tbox.nearhero.testproduct";
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    //by ahmad, to update reviews in tableview...
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showAlert:)
                                                 name:kuserIsSubscribed object:nil];
    
    
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    if(screenHeight == 480){
        [self.proLbl setFrame:CGRectMake(_proLbl.frame.origin.x, 15, _proLbl.frame.size.width, _proLbl.frame.size.height)];
        [self.continueBtn setFrame:CGRectMake(32, 480-100, 256,50)];
        [self.containerView setFrame:CGRectMake(32, 94, 256, 282)];
        [self.scview setFrame:CGRectMake(0,40, 256, 139)];


        
    }
   
}
- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    [self setUpPage];
    [self createViewArray];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (void)removeView:(UITapGestureRecognizer *)recognizer {
    [self dismissViewControllerAnimated:NO completion:nil];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)createViewArray{
    
    UIView *ViewOne = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.scrollContainerView.frame.size.width+1, self.scrollView.frame.size.height)];

    UILabel *lbl = [[UILabel alloc] initWithFrame:self.lbl.frame];
    UILabel *lble = [[UILabel alloc] initWithFrame:self.lblTwo.frame];
    UIImageView *image = [[UIImageView alloc] initWithFrame:self.imgView.frame];
    lbl.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
    lbl.adjustsFontSizeToFitWidth = YES;

    lble.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    lble.adjustsFontSizeToFitWidth = YES;

    lble.textColor = [UIColor colorWithRed:99.0/255.0 green:99.0/255.0 blue:99.0/255.0 alpha:1.0] ;
    lbl.textColor = [UIColor colorWithRed:99.0/255.0 green:99.0/255.0 blue:99.0/255.0 alpha:1.0] ;
    lbl.textAlignment = NSTextAlignmentCenter;
    lble.textAlignment = NSTextAlignmentCenter;
    lbl.text = @"Expand Your Search";
    lble.text = @"Connect with professionals around the world";
    image.image = [UIImage imageNamed:@"expand"];
    [ViewOne addSubview:image];
    [ViewOne addSubview:lbl];
    [ViewOne addSubview:lble];

    
    UIView *ViewTwo = [[UIView alloc] initWithFrame:CGRectMake(ViewOne.frame.size.width, 0, self.scrollContainerView.frame.size.width, self.scrollView.frame.size.height)];
    UILabel *lblTwo = [[UILabel alloc] initWithFrame:self.lbl.frame];
    UILabel *lbleTwo = [[UILabel alloc] initWithFrame:self.lblTwo.frame];
    UIImageView *imageTwo = [[UIImageView alloc] initWithFrame:self.imgView.frame];
    lblTwo.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
    lblTwo.adjustsFontSizeToFitWidth = YES;
    lbleTwo.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    lbleTwo.adjustsFontSizeToFitWidth = YES;
    
    lbleTwo.textColor = [UIColor colorWithRed:99.0/255.0 green:99.0/255.0 blue:99.0/255.0 alpha:1.0] ;
    lblTwo.textColor = [UIColor colorWithRed:99.0/255.0 green:99.0/255.0 blue:99.0/255.0 alpha:1.0] ;
    lblTwo.textAlignment = NSTextAlignmentCenter;
    lbleTwo.textAlignment = NSTextAlignmentCenter;
    lblTwo.text = @"Unlock Opportunities";
    lbleTwo.text = @"Get found for potential work around the world";
    imageTwo.contentMode = UIViewContentModeScaleAspectFit;
    imageTwo.image = [UIImage imageNamed:@"unlock"];

    [ViewTwo addSubview:imageTwo];
    [ViewTwo addSubview:lblTwo];
    [ViewTwo addSubview:lbleTwo];
    
    

    UIView *ViewThree = [[UIView alloc] initWithFrame:CGRectMake(ViewOne.frame.size.width*2, 0, self.scrollContainerView.frame.size.width, self.scrollView.frame.size.height)];
    UILabel *lblThree = [[UILabel alloc] initWithFrame:self.lbl.frame];
    UILabel *lbleThree = [[UILabel alloc] initWithFrame:self.lblTwo.frame];
    UIImageView *imageThree = [[UIImageView alloc] initWithFrame:self.imgView.frame];
    imageThree.contentMode = UIViewContentModeScaleAspectFit;

    lblThree.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
    lblThree.adjustsFontSizeToFitWidth = YES;
    lbleThree.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    lbleThree.adjustsFontSizeToFitWidth = YES;
    lbleThree.textAlignment = NSTextAlignmentCenter;
    lblThree.textAlignment = NSTextAlignmentCenter;
    lbleThree.textColor = [UIColor colorWithRed:99.0/255.0 green:99.0/255.0 blue:99.0/255.0 alpha:1.0] ;
    lblThree.textColor = [UIColor colorWithRed:99.0/255.0 green:99.0/255.0 blue:99.0/255.0 alpha:1.0] ;
    lblThree.text = @"No Ads";
    lbleThree.text = @"Upgrade to NearHero Pro Now";
    imageThree.image = [UIImage imageNamed:@"cros"];
    [ViewThree addSubview:imageThree];
    [ViewThree addSubview:lblThree];
    [ViewThree addSubview:lbleThree];
    

    NSMutableArray *viewsArray = [[NSMutableArray alloc] initWithObjects:ViewOne, ViewTwo, ViewThree, nil];
    for(int i = 0; i < viewsArray.count; i++)
    {
        CGRect frame;
        frame.origin.x = (self.scrollContainerView.frame.size.width *i)+1;
        frame.origin.y = 0;
        frame.size = CGSizeMake(self.scrollContainerView.frame.size.width,     self.scrollView.frame.size.height);
        
        NSLog(@"array: %@", [viewsArray objectAtIndex:i]);
        
        UIView *view = [[UIView alloc] initWithFrame:frame];
        view = [viewsArray objectAtIndex:i];
        [self.scrollView addSubview:view];
    }
    [NSTimer scheduledTimerWithTimeInterval:8 target:self selector:@selector(scrollingTimer) userInfo:nil repeats:YES];
}
- (IBAction)continueBtnAction:(id)sender {
    
    
        for (int i=0; i < [self appDelegate].products.count; i++)
        {
            SKProduct *product = [self appDelegate].products[i];
            if([product.productIdentifier isEqualToString:productId])
            {
                if(!reqGen){
                    reqGen = true;
                    NSLog(@"Buying %@...", product.productIdentifier);
                    [[RageIAPHelper sharedInstance] buyProduct:product];
                    [self.view makeToastActivity];
                    break;
                }
            }
        }
    

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kuserIsSubscribed object:nil];
}

- (IBAction)enableOneMonSub:(id)sender {
        [self.oneMonthSub setHidden:YES];
        [self.oneMonthSubs setHidden:NO];
        [self unselectSixMonthSub];
        [self unselectOneYearSub];
        c = 0;
        productId = @"com.tbox.nearhero.subscription";
}
-(void) unselectOneMonthSub{
    [self.oneMonthSubs setHidden:YES];
    [self.oneMonthSub setHidden:NO];
}
-(void) unselectSixMonthSub{
    [self.sixMonthSubs setHidden:YES];
    [self.sixMonthSub setHidden:NO];
}
-(void) unselectOneYearSub{
    [self.twelveMonthSubs setHidden:YES];
    [self.twelveMonthSub setHidden:NO];
}
- (IBAction)enableSixMonSub:(id)sender {
    [self.sixMonthSub setHidden:YES];
    [self.sixMonthSubs setHidden:NO];

    [self unselectOneMonthSub];
    [self unselectOneYearSub];
    c = 1;
    productId = @"com.tbox.nearhero.testproduct";

}

- (IBAction)enableTwelveMonSub:(id)sender {
        [self.twelveMonthSub setHidden:YES];
        [self.twelveMonthSubs setHidden:NO];
        [self unselectOneMonthSub];
        [self unselectSixMonthSub];
    c = 2;
    productId = @"com.tbox.nearhero.oneyearsubscription";

}
-(void)setUpPage{
    self.view.autoresizesSubviews = YES;
    CGRect scrollViewFrame = CGRectMake(0, 0, self.scrollContainerView.frame.size.width, self.scrollContainerView.frame.size.height);
    self.scrollView = [[UIScrollView alloc] initWithFrame:scrollViewFrame];
    self.scrollView.delegate = self;
    [self.scrollContainerView addSubview:self.scrollView];
    CGSize scrollViewContentSize = CGSizeMake(scrollViewFrame.size.width*3, scrollViewFrame.size.height);
    [self.scrollView setContentSize:scrollViewContentSize];
    [self.scrollView setPagingEnabled:YES];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.pageController.numberOfPages = 3;
    self.pageController.currentPage = 0;
}
- (void)scrollingTimer {
  
    int nextPage = self.pageController.currentPage+1;
    if( nextPage!=3 )  {
        [self.scrollView scrollRectToVisible:CGRectMake(nextPage* self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:YES];
        self.pageController.currentPage=nextPage;
    } else {
        [self.scrollView scrollRectToVisible:CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:YES];
        self.pageController.currentPage=0;
    }
}
#pragma mark - UIScrollView Delegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    self.pageController.currentPage = (int)scrollView.contentOffset.x / (int)pageWidth;
}
#pragma mark - Helper Method

-(void)loadProducts
{
    [[RageIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        if (success) {
            _products = products;
        }
    }];
}
#pragma mark - Selector Methods

-(void) showAlert:(NSNotification *) notification{
    [self.view hideToastActivity];

    [self dismissViewControllerAnimated:NO completion:nil];

}

- (IBAction)showTermsAndConditions:(id)sender {
  //  [[UIApplication sharedApplication] openURL: [NSURL URLWithString:@"https://nearhero.com/terms-and-conditions"]];
    //[(HomeViewController*)(((MainViewController*)kMainViewController).rootViewController) openWebView:@"https://nearhero.com/terms-and-conditions"];
    
    WebViewController *webVC =[[WebViewController alloc]initWithNibName:@"WebViewController" bundle:nil];
    webVC.url = @"https://nearhero.com/terms-and-conditions";
    [webVC.view setCenter:CGPointMake(self.view.center.x, self.view.center.y*2)];
    [webVC.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:webVC.view];


}
@end
