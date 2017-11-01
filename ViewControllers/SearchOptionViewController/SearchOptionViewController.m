//
//  SearchOptionViewController.m
//  nearhero
//
//  Created by apple on 11/7/16.
//  Copyright © 2016 TBoxSolutionz. All rights reserved.
//

#import "SearchOptionViewController.h"
#import "ShareViewController.h"
#import "HomeViewController.h"
#import "AppDelegate.h"

@interface SearchOptionViewController ()
{
    UITapGestureRecognizer *tapper;
}

@end

@implementation SearchOptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    tapper = [[UITapGestureRecognizer alloc]
                          initWithTarget:self action:@selector(removeView)];
    [self.view addGestureRecognizer:tapper];
               
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
-(void)removeView{
    [self dismissViewControllerAnimated:YES completion:nil];
   

}
- (IBAction)inviteBtnAction:(id)sender {
    [self removeView];
    [(HomeViewController*)(((MainViewController*)kMainViewController).rootViewController) viewinvitescreen:NO];
  
}

- (IBAction)proBtnAction:(id)sender {
    [self removeView];
    [(HomeViewController*)(((MainViewController*)kMainViewController).rootViewController) openProScreen];

}
@end
