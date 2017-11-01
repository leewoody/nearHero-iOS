//
//  ReportViewController.h
//  nearhero
//
//  Created by apple on 9/28/16.
//  Copyright © 2016 TBoxSolutionz. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ReportViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *transView;
- (IBAction)okBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *reportView;

@end
