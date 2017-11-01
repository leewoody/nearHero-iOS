//
//  UnlockProViewController.m
//  nearhero
//
//  Created by apple on 11/14/16.
//  Copyright © 2016 TBoxSolutionz. All rights reserved.
//

#import "UnlockProViewController.h"
#import "Constants.h"
#import "UserInfo.h"

@interface UnlockProViewController ()
{
    UserInfo *userInfo;
}

@end

@implementation UnlockProViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    userInfo = [UserInfo instance];
    makeViewRound(self.imgContainer);
    setImageUrl(self.imgView, [userInfo valueForKey:kImageUrl]);
    [self.seletedOneMonSub setHidden:YES];
    [self.selectedSixMonSub setHidden:YES];
    [self.selectedOneYearSub setHidden:YES];
    [self.oneMonthSub addTarget:self action:@selector(activateOneMonSub:) forControlEvents:UIControlEventTouchUpInside];
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

- (IBAction)continueActionMethod:(id)sender {
}

- (IBAction)restorePurchase:(id)sender {
}

- (IBAction)activateOneMonSub:(id)sender {
    [self.oneMonthSub setHidden:YES];
    [self.seletedOneMonSub setHidden:NO];
}

- (IBAction)activateOneYearSub:(id)sender {
    [self.oneYearSub setHidden:YES];
    [self.selectedOneYearSub setHidden:NO];
}

- (IBAction)activateSixYearSub:(id)sender {
    [self.sixMonthSub setHidden:YES];
    [self.selectedSixMonSub setHidden:NO];
}
@end
