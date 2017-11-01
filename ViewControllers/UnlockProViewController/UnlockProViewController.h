//
//  UnlockProViewController.h
//  nearhero
//
//  Created by apple on 11/14/16.
//  Copyright © 2016 TBoxSolutionz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UnlockProViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *imgContainer;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
- (IBAction)continueActionMethod:(id)sender;
- (IBAction)restorePurchase:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *seletedOneMonSub;
@property (weak, nonatomic) IBOutlet UIButton *selectedSixMonSub;
@property (weak, nonatomic) IBOutlet UIButton *selectedOneYearSub;
@property (weak, nonatomic) IBOutlet UIButton *oneYearSub;
@property (weak, nonatomic) IBOutlet UIButton *sixMonthSub;
@property (weak, nonatomic) IBOutlet UIButton *oneMonthSub;
- (IBAction)activateOneMonSub:(id)sender;
- (IBAction)activateOneYearSub:(id)sender;
- (IBAction)activateSixYearSub:(id)sender;
@end
