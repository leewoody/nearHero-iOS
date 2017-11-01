//
//  UpdateImageViewController.h
//  nearhero
//
//  Created by APPLE on 29/09/2016.
//  Copyright © 2016 TBoxSolutionz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpdateImageViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet UIView *fbImage;
- (IBAction)fbImageClick:(id)sender;
- (IBAction)CameraClick:(id)sender;
- (IBAction)GalleryClick:(id)sender;
- (IBAction)CancelClick:(id)sender;
- (NSString *)returnInfo;
//- (NSString) getImageUrl;

@end
