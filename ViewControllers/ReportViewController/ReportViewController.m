//
//  ReportViewController.m
//  nearhero
//
//  Created by apple on 9/28/16.
//  Copyright © 2016 TBoxSolutionz. All rights reserved.
//

#import "ReportViewController.h"
#import "UIViewController+MJPopupViewController.h"

@interface ReportViewController ()
{
    UITapGestureRecognizer *singleFingertapper ;

}
@end

@implementation ReportViewController

- (void)viewDidLoad {
  
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    singleFingertapper = [[UITapGestureRecognizer alloc]
                          initWithTarget:self action:@selector(removeReportView)];
    singleFingertapper.cancelsTouchesInView = NO;
    [self.transView addGestureRecognizer:singleFingertapper];
//
//    CGRect frame = self.reportView.frame;
    //frame.origin.x =
}

-(void)removeReportView{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
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



- (IBAction)okBtnAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
   
}
@end
