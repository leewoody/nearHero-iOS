//
//  MessageViewController.m
//  nearhero
//
//  Created by apple on 8/16/16.
//  Copyright © 2016 TBoxSolutionz. All rights reserved.
//

#import "MessageViewController.h"

@interface MessageViewController ()

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

- (IBAction)cancelBtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)shareProfileBtnAction:(id)sender {
    NSArray *activityItems;
    NSString *texttoshare = @"Hey, heard you were looking for work.Try NearHero and connect with professionals near you.";
    activityItems = @[texttoshare];
    self.activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    [self.activityViewController setValue:@"NearHero" forKey:@"subject"];
    [self presentViewController:self.activityViewController animated:YES completion:nil];

}

@end
