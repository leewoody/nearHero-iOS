//
//  WebViewController.m
//  nearhero
//
//  Created by apple on 4/26/17.
//  Copyright © 2017 TBoxSolutionz. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.webView.delegate = self;
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    BOOL isAvailable = [appDelegate isNetworkAvailable];
    if(isAvailable){
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
        [self.webView loadRequest:request];
        [self checkNetwork];
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Try Later" message:@"Internet Connection Problem" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];

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

#pragma mark - Helper methods

-(void)checkNetwork{
    Reachability *reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    reach.reachableBlock = ^(Reachability * reachability){
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Block Says Reachable");
        });
    };
    
    reach.unreachableBlock = ^(Reachability * reachability){
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Try Later" message:@"Internet Connection Problem" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];

                    [self.view hideToastActivity];
            return ;
        });
    };
    [reach startNotifier];
}
- (IBAction)goBack:(id)sender {
    [self.view removeFromSuperview];
}

#pragma mark - UIwebView Delegate
-(void)webViewDidStartLoad:(UIWebView *)webView{
    [self.view makeToastActivity];
    
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.view  hideToastActivity];
}
@end



