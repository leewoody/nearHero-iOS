//
//  BaseViewController.m
//  nearhero
//
//  Created by apple on 10/19/16.
//  Copyright © 2016 TBoxSolutionz. All rights reserved.
//

#import "BaseViewController.h"
#import "AppDelegate.h"
#import "UserReviewController.h"
#import "HomeViewController.h"
@interface BaseViewController ()
{
    CGRect screenRect;
    CGFloat screenHeight;
    double prevYloc;
}
@end

@implementation BaseViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    screenRect = [[UIScreen mainScreen] bounds];
    screenHeight = screenRect.size.height;
    prevYloc = 0.0;
    

}
-(void)addSliderGesture{
    panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveDown:)];
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    [panRecognizer setDelegate:self];
    [self.view addGestureRecognizer:panRecognizer];
}

-(void)viewWillAppear:(bool)animated{
    [super viewWillAppear:animated];
    [self addSliderGesture];
    
    
}
-(void)method{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    double h = screenHeight/4.0 * 2;
    if(self.view.frame.origin.y >= h)
    {
        [self.view setCenter:CGPointMake(self.view.center.x, self.view.frame.size.height)];
        [self.view removeFromSuperview];
        [self dismissViewControllerAnimated:YES completion:nil];
        
        
    }
    else{
        [self.view setFrame:CGRectMake(self.view.frame.origin.x,
                                       0.0f,
                                       self.view.frame.size.width,
                                       self.view.frame.size.height)];
    }
}

-(void)hideTransparentView{
//    if (self.transView) {
//        [self.transView setAlpha:0.0];
//    }
//    if (self.transperentView) {
//        [self.transperentView setAlpha:0.0];
//    }
//    if (self.tview) {
//        [self.tview setAlpha:0.0];
//    }
//    if (self.topView) {
//        [self.topView setAlpha:0.0];
//    }
//
}
-(void)showTransparentView{
//    if (self.transView) {
//        [self.transView setAlpha:1.0];
//    }
//    if (self.transperentView) {
//        [self.transperentView setAlpha:1.0];
//    }
//    if (self.tview) {
//        [self.tview setAlpha:1.0];
//    }
//    if (self.topView) {
//        [self.topView setAlpha:1.0];
//    }
    
    
}
- (void)moveDown:(UILongPressGestureRecognizer *)sender {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    UIView *view = sender.view;
    double h = screenHeight/4.0 *3;
    
    CGPoint point = [sender locationInView:view];
    
    if (sender.state == UIGestureRecognizerStateChanged) {
        [self.view endEditing:YES];

        CGFloat newYLoc = self.view.frame.origin.y + (point.y-tapStartPoint.y);
            if(newYLoc >= 0)
            {
            //[self hideTransparentView];
                
            [self.view setFrame:CGRectMake(self.view.frame.origin.x,
                                           newYLoc,
                                           self.view.frame.size.width,
                                           self.view.frame.size.height)];
                
                double alpha =  [(HomeViewController*)(((MainViewController*)kMainViewController).rootViewController) tView].alpha;
                if(newYLoc > prevYloc && alpha > 0.0 && !self.isLayer)
                {
                   
                    [[(HomeViewController*)(((MainViewController*)kMainViewController).rootViewController) tView] setAlpha:alpha-0.01];
                    
                }
                else if (newYLoc < prevYloc && alpha < 0.6 && !self.isLayer){
                    double alpha =  [(HomeViewController*)(((MainViewController*)kMainViewController).rootViewController) tView].alpha;
                    [[(HomeViewController*)(((MainViewController*)kMainViewController).rootViewController) tView] setAlpha:alpha+0.01];

                    
                }
                

                        if(self.view.frame.origin.y-50 >= h)
                        {
                            
                            
                            [UIView animateWithDuration:0.3
                                                  delay:0
                                                options:UIViewAnimationOptionLayoutSubviews
                                             animations:^{
                                                 [self.view endEditing:YES];
                                                 if(!self.isLayer)
                                                  [[(HomeViewController*)(((MainViewController*)kMainViewController).rootViewController) tView] setAlpha:0.0];

                                                 
                                                }
                             
                             
                             
                                             completion:^(BOOL finished) {
                                               
                                                [self.view setCenter:CGPointMake(self.view.center.x, self.view.frame.size.height)];
                                                 
                                                 [self.view removeFromSuperview];
                                                 if(!self.isLayer)
                                                 [(HomeViewController*)(((MainViewController*)kMainViewController).rootViewController) hideView];
                                                 [(HomeViewController*)(((MainViewController*)kMainViewController).rootViewController) enableSearchBtn];
                                                 [self dismissViewControllerAnimated:YES completion:nil];
                                             }];
            
                        }
                prevYloc = newYLoc;

            
        }
        else{
            [self.view setFrame:CGRectMake(self.view.frame.origin.x,
                                           0.0f,
                                           self.view.frame.size.width,
                                           self.view.frame.size.height)];
           // [self showTransparentView];

            
        }
    }else if (sender.state == UIGestureRecognizerStateBegan &&  CGPointEqualToPoint(tapStartPoint, CGPointZero)){
        tapStartPoint=point;
    }else if (sender.state == UIGestureRecognizerStateEnded ){
        prevYloc = 0.0;
        if(self.view.frame.origin.y <= screenHeight/2){
            [self moveUp];

        }
        else{
            [self removeView];
        }
    }
}
-(void)removeView{
    
   
       [UIView animateWithDuration:0.8
                          delay:0
                        options:UIViewAnimationOptionLayoutSubviews
                     animations:^{
                         [self.view endEditing:YES];
                         if(!self.isLayer)
                         [[(HomeViewController*)(((MainViewController*)kMainViewController).rootViewController) tView] setAlpha:0.0];
                         [self.view setFrame:CGRectMake(self.view.frame.origin.x,
                                                        screenHeight,
                                                        self.view.frame.size.width,
                                                        self.view.frame.size.width)];
                         
                     }

     
                     completion:^(BOOL finished) {
                         if(!self.isLayer)
                          [(HomeViewController*)(((MainViewController*)kMainViewController).rootViewController) hideView];
                          [(HomeViewController*)(((MainViewController*)kMainViewController).rootViewController) enableSearchBtn];
                         [self.view removeFromSuperview];
                         [self dismissViewControllerAnimated:YES completion:nil];
                         
                     }];
}
-(void)moveUp{
    tapStartPoint = CGPointMake(0,0);
    [UIView animateWithDuration:1.0
                          delay:0
                        options:UIViewAnimationOptionLayoutSubviews
                     animations:^{
                         if(!self.isLayer)
                          [[(HomeViewController*)(((MainViewController*)kMainViewController).rootViewController) tView] setAlpha:0.6];
                         [self.view setFrame:CGRectMake(self.view.frame.origin.x,
                                                        0,
                                                        self.view.frame.size.width,
                                                        self.view.frame.size.height)];
                     }
                     completion:^(BOOL finished) {
                         if(_searchView){
                             [self.searchView becomeFirstResponder];
                         }
                     //    [self showTransparentView];
                       
                         
                         
                     }];
    
}

@end
