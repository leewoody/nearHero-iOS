//
//  UpdateImageViewController.m
//  nearhero
//
//  Created by APPLE on 29/09/2016.
//  Copyright © 2016 TBoxSolutionz. All rights reserved.
//

#import "UpdateImageViewController.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "UserInfo.h"
#import "UIViewController+MJPopupViewController.h"

@interface UpdateImageViewController ()

@end

@implementation UpdateImageViewController{
    NSString *userImageURL;
    UIGestureRecognizer* singleFingertapper;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
        singleFingertapper = [[UITapGestureRecognizer alloc]
                              initWithTarget:self action:@selector(dismissView:)];
        singleFingertapper.cancelsTouchesInView = NO;
    [self.topView addGestureRecognizer:singleFingertapper];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismissView:(id)sender {
[UIView animateWithDuration:0.5
                      delay:0
                    options:UIViewAnimationOptionOverrideInheritedOptions
                 animations:^{
                     [self.view setCenter:CGPointMake(self.view.center.x, self.view.frame.size.height)];
                 }
                 completion:^(BOOL finished) {
                     [self.view removeFromSuperview];
                 }];
}


- (IBAction)fbImageClick:(id)sender {
    if ([FBSDKAccessToken currentAccessToken]) {
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{ @"fields" : @"picture.width(100).height(100)"}]startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
            if (!error) {
                UserInfo *userinfo = [UserInfo instance];
                // NSString *nameOfLoginUser = [result valueForKey:@"name"];
                NSString *imageStringOfLoginUser = [[[result valueForKey:@"picture"] valueForKey:@"data"] valueForKey:@"url"];
                //                                NSURL *url = [[NSURL alloc] initWithURL: imageStringOfLoginUser];
                userImageURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [userinfo uu_id]];
                //[self.imageView setImageWithURL:userImageURL];
            }
        }];
    }
}

- (IBAction)CameraClick:(id)sender {
    //Take a photo
                        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                        picker.delegate = self;
                        picker.allowsEditing = YES;
                        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
                        [self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)GalleryClick:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                        picker.delegate = self;
                        picker.allowsEditing = YES;
                        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
                        [self presentViewController:picker animated:YES completion:NULL];

}

- (IBAction)CancelClick:(id)sender {
    //[self.containerView setHidden:YES];
    //[self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
     
     [UIView animateWithDuration:0.5
                           delay:0
                         options:UIViewAnimationOptionOverrideInheritedOptions
                      animations:^{
                          [self.view setCenter:CGPointMake(self.view.center.x, self.view.frame.size.height)];
                      }
                      completion:^(BOOL finished) {
                          [self.view removeFromSuperview];
                      }];
}

- (NSString *)returnInfo{
    return userImageURL;
}

@end
