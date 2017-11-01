//
//  WebViewController.h
//  nearhero
//
//  Created by apple on 4/26/17.
//  Copyright © 2017 TBoxSolutionz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Toast+UIView.h"
#import "Reachability.h"

@interface WebViewController : UIViewController<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
- (IBAction)goBack:(id)sender;
@property (strong,nonatomic) NSString *url;

@end
