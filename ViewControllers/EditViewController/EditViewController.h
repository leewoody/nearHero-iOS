//
//  EditViewController.h
//  nearhero
//
//  Created by apple on 9/26/16.
//  Copyright © 2016 TBoxSolutionz. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ProfileViewControllerDelegate<NSObject>;
@end

@protocol changeProfileDelegate <NSObject>
-(void)changeprofileWithImage;
@end
@interface EditViewController : UIViewController <UITextFieldDelegate> 
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *profession;
@property (strong, nonatomic) IBOutlet UIView *infoView;
@property (strong, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) IBOutlet UITextField *editedProfession;
@property (weak, nonatomic) IBOutlet UIView *imageContainer;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UIView *transView;
@property (nonatomic, strong) id<changeProfileDelegate> controllerDelegate;

- (IBAction)DoneButtonAction:(id)sender;
- (IBAction)cameraBtnAction:(id)sender;

@end
