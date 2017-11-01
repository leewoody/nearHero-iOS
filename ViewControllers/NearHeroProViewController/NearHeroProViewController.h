//
//  NearHeroProViewController.h
//  nearhero
//
//  Created by apple on 11/10/16.
//  Copyright © 2016 TBoxSolutionz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NearHeroProViewController : UIViewController<UIPageViewControllerDataSource,UIScrollViewDelegate,UIPageViewControllerDelegate,UIScrollViewAccessibilityDelegate>
{
    NSArray  *_products;
}
@property (weak, nonatomic) IBOutlet UIButton *continueBtn;

@property (weak, nonatomic) IBOutlet UIPageControl *pageController;
@property (weak, nonatomic) IBOutlet UIView *image_container;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UIButton *oneMonthSub;
@property (weak, nonatomic) IBOutlet UIButton *sixMonthSub;
@property (weak, nonatomic) IBOutlet UIButton *twelveMonthSub;
@property (weak, nonatomic) IBOutlet UIView *transparentView;
@property (weak, nonatomic) IBOutlet UILabel *lblTwo;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIView *scrollContainerView;
@property (weak, nonatomic) IBOutlet UILabel *lbl;
@property (weak, nonatomic) IBOutlet UIButton *sixMonthSubs;
@property (weak, nonatomic) IBOutlet UIButton *twelveMonthSubs;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *scview;
@property (weak, nonatomic) IBOutlet UILabel *proLbl;
@property (weak, nonatomic) IBOutlet UIButton *oneMonthSubs;
- (IBAction)continueBtnAction:(id)sender;
- (IBAction)restorePurchaseBtnAction:(id)sender;
- (IBAction)enableOneMonSub:(id)sender;
- (IBAction)enableSixMonSub:(id)sender;
- (IBAction)enableTwelveMonSub:(id)sender;
- (IBAction)changeScreen:(id)sender;
- (IBAction)showTermsAndConditions:(id)sender;


@end
