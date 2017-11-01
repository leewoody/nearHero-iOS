//
//  UserLocationViewController.m
//  nearhero
//
//  Created by Irfan Malik on 6/13/16.
//  Copyright (c) 2016 TBoxSolutionz. All rights reserved.
//

#import "UserLocationViewController.h"
#import "HomeViewController.h"
#import "AppDelegate.h"
#import "MainViewController.h"
#import "NavigationController.h"
#import <QuartzCore/QuartzCore.h>

@interface UserLocationViewController ()

@end

@implementation UserLocationViewController

- (void)viewDidLoad {
    
    self.radus.layer.cornerRadius = 5;
    self.radus.layer.borderWidth = 0.50;
    self.radus.layer.borderColor = [UIColor whiteColor].CGColor;
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)moveBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];

}

- (IBAction)moveToHomeScreen:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(allowTapped)]) {
        [self.delegate allowTapped];
    }
}
@end
