//
//  BaseViewController.h
//  nearhero
//
//  Created by apple on 10/19/16.
//  Copyright © 2016 TBoxSolutionz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
{
    CGPoint tapStartPoint;
    UIPanGestureRecognizer *panRecognizer;
}
@property (weak, nonatomic) IBOutlet UIView *transView;
@property (weak, nonatomic) IBOutlet UIView *transperentView;
@property (weak, nonatomic) IBOutlet UIView *tview;
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UITextField *searchView;
@property (nonatomic)  BOOL isLayer;

@end
