//
//  UserReviewController.m
//  nearhero
//
//  Created by apple on 9/24/16.
//  Copyright © 2016 TBoxSolutionz. All rights reserved.
//

#import "UserReviewController.h"
#import "AMRatingControl.h"
#import "UIViewController+MJPopupViewController.h"
#import "GenericFetcher.h"
#import "Constants.h"
#import "Toast+UIView.h"
#import "URLBuilder.h"
#import "UserInfo.h"
#import "AppDelegate.h"





@interface UserReviewController ()
{
    UIGestureRecognizer *singleFingertapper ;
    UIGestureRecognizer *tapper;
    UIGestureRecognizer *tapGesture;
    NSInteger *_rating;
    UIImage *chosenImage;
}

@end

@implementation UserReviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _review.layer.borderWidth = 1.0f;
    _review.layer.borderColor = [[UIColor colorWithRed:229.0/255 green:231.00/255 blue:234.00/255 alpha:0.7] CGColor];
    _review.delegate = self;
    _profession.adjustsFontSizeToFitWidth = YES;
    _name.adjustsFontSizeToFitWidth = YES;

    _name.text = [_user valueForKey:kname];
    _profession.text = [_user valueForKey:kprofession];
    makeViewRound(_imageContainerView);
    setImageUrl(_image,[_user valueForKey:kprofile_image]);
    tapGesture = [[UITapGestureRecognizer alloc]
                          initWithTarget:self action:@selector(hideKeyboard)];
    tapGesture.cancelsTouchesInView = NO;
    [self.containerView addGestureRecognizer:tapGesture];
    

    singleFingertapper = [[UITapGestureRecognizer alloc]
                          initWithTarget:self action:@selector(removeReviewView)];
    singleFingertapper.cancelsTouchesInView = NO;
    [self.transView addGestureRecognizer:singleFingertapper];
    
    tapper = [[UITapGestureRecognizer alloc]
                         initWithTarget:self action:@selector(resignTextView)];
    tapper.cancelsTouchesInView = NO;
    [self.ratingReview addGestureRecognizer:tapper];
    _review.returnKeyType = UIReturnKeyDone;

    
    NSInteger *maxRating = 5;
    _rating = 5;
    CGPoint point = CGPointMake(0,0);
    UIColor *color;
    float rd = 225.00/255.00;
    float gr = 177.00/255.00;
    float bl = 140.00/255.00;
    
    AMRatingControl *coloredRatingControl = [[AMRatingControl alloc] initWithLocation:point
                                                                           emptyColor:[UIColor colorWithRed:230.00/255.00 green:230.00/255.00 blue:235.00/255.00 alpha:1.0]
                                                                           solidColor:[UIColor colorWithRed:243.00/255.00 green:195.00/255.00 blue:68.00/255.00 alpha:1.0]
                                                                         andMaxRating:maxRating];
    [coloredRatingControl setRating:_rating];
    
    [self.ratingParentView addSubview:coloredRatingControl];
    
    coloredRatingControl.editingChangedBlock = ^(NSUInteger rating)
    {
        _rating = rating;
    };
    
    coloredRatingControl.editingDidEndBlock = ^(NSUInteger rating)
    {
        _rating = rating;
    };
    
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

-(void)removeReviewView{
    [self.view hideToastActivity];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"addGesture" object:nil userInfo:nil];
    [self.view removeFromSuperview];
    [self dismissViewControllerAnimated:YES completion:nil];

   
}
- (IBAction)sendButtonAction:(id)sender {
    
   if(!([_review.text isEqualToString:@""] || [_review.text isEqualToString:@"Write a review"]))
   {
       NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
       formatter.dateFormat = @"yyyy-MM-dd";
       NSString *_date = [formatter stringFromDate:[NSDate date]];
       
       AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
       BOOL isAvailable = [appDelegate isNetworkAvailable];
       if(isAvailable){
            UserInfo *userInfo = [UserInfo instance];
            NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
            NSString *r = [NSString stringWithFormat: @"%ld", (long)_rating];
            [params setValue:[_user valueForKey:kid] forKey:kid];
            [params setValue:_review.text forKey:kfeedback];
             [params setValue:_date forKey:kdate];

            [params setValue:[userInfo valueForKey:kuu_id] forKey:kreviewer_id];
            [params setValue:r forKey:krating];
            [self.view makeToastActivity];
            GenericFetcher *fetcher = [[GenericFetcher alloc]init];
            [fetcher fetchWithUrl:[URLBuilder urlForMethod:kadd_review withParameters:nil]
                       withMethod:POST_REQUEST withParams:params completionBlock:^(NSDictionary *dict) {
                           NSLog(@"%@",dict);
                           int status = [[dict valueForKey:kstatus] intValue];
                           if (status == 1) {
                              // [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
                               NSMutableDictionary *obj = [[NSMutableDictionary alloc] init];
                               [obj setValue:[_user valueForKey:kid] forKey:kid];
                               [obj setValue:_review.text forKey:kfeedback_msg];
                               [obj setValue:r forKey:krating];
                               [obj setValue:userInfo.name forKey:kname];
                               [obj setValue:userInfo.imageUrl forKey:kprofile_image];
                               [obj setValue:_date forKey:kdate];
                             //  AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                              // [appDelegate loadFeedBacks:obj];


                               [[NSNotificationCenter defaultCenter] postNotificationName:@"updateReviews" object:nil userInfo:obj];

                                [self.view hideToastActivity];
                               [NSTimer scheduledTimerWithTimeInterval:2.0
                                                                target:self
                                                              selector:@selector(removeReviewView)
                                                              userInfo:nil
                                                               repeats:NO];


                           }
                           else
                           {
                               UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:[dict valueForKey:kerror] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                               [alert show];
                               [self.view hideToastActivity];
                               [self removeReviewView];
                              // [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
                               
                           }
                           
                       }
                       errorBlock:^(NSError *error) {
                           [self.view hideToastActivity];
                           NSLog(@"no internet");
                           NSLog(@"%@",error);
                           [self removeReviewView];
                           //[self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
                           
                    }];
       }
   }
   else
   {
       return;
   }
    

    
}
-(void)hideKeyboard{
    [_review resignFirstResponder];
}
- (void)resignTextView{
    [_review resignFirstResponder];
    
}
- (BOOL) textViewShouldBeginEditing:(UITextView *)textView

{
    if([textView.text isEqualToString:@"Write a review"])
        _review.text = @"";
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {

    if([text isEqualToString:@"\n"]) {
        [_review resignFirstResponder];
        return NO;
    }else if([[_review text] length]-range.length+text.length > 140){
        
        return NO;
    }
    
    return YES;
}

-(void) textViewDidChange:(UITextView *)textView
{
    _numOfChar.text = [NSString stringWithFormat:@"%d", 140 - ([[_review text] length])];
}



@end
