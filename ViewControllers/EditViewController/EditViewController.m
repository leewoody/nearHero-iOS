//
//  EditViewController.m
//  nearhero
//
//  Created by apple on 9/26/16.
//  Copyright © 2016 TBoxSolutionz. All rights reserved.
//
#import "AppDelegate.h"
#import "EditViewController.h"
#import "UserInfo.h"
#import "Constants.h"
#import "GenericFetcher.h"
#import "URLBuilder.h"
#import "Toast+UIView.h"
#import "HomeViewController.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
typedef NS_ENUM(NSInteger, FieldTag) {
    FieldTagHorizontalLayout = 1001,
    FieldTagVerticalLayout,
    FieldTagMaskType,
    FieldTagShowType,
    FieldTagDismissType,
    FieldTagBackgroundDismiss,
    FieldTagContentDismiss,
    FieldTagTimedDismiss,
};


typedef NS_ENUM(NSInteger, CellType) {
    CellTypeNormal = 0,
    CellTypeSwitch,
};

@interface EditViewController ()
{
    UserInfo *userInfo;
    UIImage *chosenImage;


}
@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _editedProfession.delegate = self;
    // Do any additional setup after loading the view from its nib.
    _name.adjustsFontSizeToFitWidth = YES;
    _profession.adjustsFontSizeToFitWidth = YES;
    userInfo = [UserInfo instance];
    _name.text = [userInfo valueForKey:kname];
    _profession.text = [userInfo valueForKey:kprofession];
    makeViewRound(_imageContainer);
    setImageUrl(_image,[userInfo valueForKey:kImageUrl]);
            UIGestureRecognizer *singleFingertapper = [[UITapGestureRecognizer alloc]
                                                       initWithTarget:self action:@selector(removeEditView)];
    singleFingertapper.cancelsTouchesInView = NO;
    [self.transView addGestureRecognizer:singleFingertapper];
    UIGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
                  initWithTarget:self action:@selector(hideKeyboard)];
    tapGesture.cancelsTouchesInView = NO;
    [self.infoView addGestureRecognizer:tapGesture];

    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
}

// This method enables or disables the processing of return key
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
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
- (void)removeEditView{
   
   [[NSNotificationCenter defaultCenter] postNotificationName:@"addGesture" object:nil userInfo:nil];
    [self dismissViewControllerAnimated:YES completion:nil];

    
}
- (IBAction)DoneButtonAction:(id)sender {
    
    
    if(!([_editedProfession.text isEqualToString:@""]))
    {
        
        userInfo = [UserInfo instance];
        [userInfo setProfession:_editedProfession.text];
        [userInfo saveUserInfo];

        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        BOOL isAvailable = [appDelegate isNetworkAvailable];
        if(isAvailable){
            [self.view makeToastActivity];
            NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
            [params setValue:[userInfo valueForKey:kapikey] forKey:kapi_key];
            [params setValue:[userInfo valueForKey:kname] forKey:kname];
            [params setValue:_editedProfession.text forKey:kprofession];
            
           
            GenericFetcher *fetcher = [[GenericFetcher alloc]init];
            [fetcher fetchWithUrl:[URLBuilder urlForMethod:kupdate_profile withParameters:nil]
                       withMethod:POST_REQUEST withParams:params completionBlock:^(NSDictionary *dict) {
                           NSLog(@"%@",dict);
                           int status = [[dict valueForKey:kstatus] intValue];
                           if (status == 1) {
                               [self.view hideToastActivity];
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"changeProfession" object:nil];
                               [self removeEditView];

                           }
                           else
                           {
                               UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:[dict valueForKey:kerror] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                               [alert show];
                               [self.view hideToastActivity];
                               [self removeEditView];
                           }
                           
                       }
                       errorBlock:^(NSError *error) {
                             [self.view hideToastActivity];
                           NSLog(@"no internet");
                           NSLog(@"%@",error);
                           [self removeEditView];
                           
                       }];
        }
//        else{
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Internet Connection Problem" message:@"" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//            [alert show];
//        }
    }
    else
    {
        return;
    }
}

- (IBAction)cameraBtnAction:(id)sender {
    [self showActionSheet];
}
-(void)showActionSheet{
    //checking if device has a camera.r
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                    
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
    }
    else{
        UIActionSheet *mymenu = [[UIActionSheet alloc]
                                 initWithTitle:nil
                                 delegate:self
                                 cancelButtonTitle:@"Cancel"
                                 destructiveButtonTitle:nil
                                 otherButtonTitles:@"Take a Photo", @"Choose From Library" , nil];
        
        [mymenu showInView:self.view];
    }
    
}

-(void) changeImage{
    [self.controllerDelegate changeprofileWithImage];
}

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    
    switch (buttonIndex) {
//        case 0:
//            
//            
//            if ([FBSDKAccessToken currentAccessToken]) {
//                [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{ @"fields" : @"picture.width(100).height(100)"}]startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
//                    if (!error) {
//                        UserInfo *userinfo = [UserInfo instance];
//                        // NSString *nameOfLoginUser = [result valueForKey:@"name"];
//                        NSString *imageStringOfLoginUser = [[[result valueForKey:@"picture"] valueForKey:@"data"] valueForKey:@"url"];
//                        //                                NSURL *url = [[NSURL alloc] initWithURL: imageStringOfLoginUser];
//                        NSString *userImageURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [userinfo uu_id]];
//                        //[self.imageView setImageWithURL: userImageURL];
//                        chosenImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:userImageURL]]];
//                        //[self.imageView setImageWithURL:userImageURL];
//                        [self uploadImage];
//                        // [userinfo setValue:userImageURL forKey:kImageUrl];
//                        //                              [userinfo setProfileimageLink:userImageURL];
//                        //[userinfo saveUserInfo];
//                        
//                        // [[NSNotificationCenter defaultCenter] postNotificationName:@"change" object:nil];
//                        //[self changeImage];
//                    }
//                }];
//            }
//            
//            break;
        case 0:{
            //Take a photo
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            [self presentViewController:picker animated:YES completion:NULL];
        }
            break;
        case 1:
            //Select photo...
        {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
            [self presentViewController:picker animated:YES completion:NULL];
        }
            break;
        case 2:
            //[self saveContent];
            break;
        case 3:
            //[self rateAppYes];
            break;
        default:
            break;
            
    }
}
-(void) hideKeyboard{
    [_editedProfession resignFirstResponder];
}
#pragma mark - updateprofile api
typedef void(^addressCompletion)(NSString *);

-(void)getAddressFromLocation:(CLLocation *)location complationBlock:(addressCompletion)completionBlock
{
    __block CLPlacemark* placemark;
    __block NSString *address = nil;
    
    CLGeocoder* geocoder = [CLGeocoder new];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (error == nil && [placemarks count] > 0)
         {
             placemark = [placemarks lastObject];
             address = [NSString stringWithFormat:@"%@, %@ %@", placemark.name, placemark.postalCode, placemark.locality];
             completionBlock(address);
         }
     }];
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    chosenImage = info[UIImagePickerControllerEditedImage];
    [self uploadImage];
    
    
    //     NSURL* localUrl = (NSURL *)[info valueForKey:UIImagePickerControllerReferenceURL];
    ////    NSString *u= (NSString*)[info valueForKey:UIImagePickerControllerReferenceURL];
    //////    NSURL *myURL = [myURL URLByAppendingPathComponent:u];
    ////    NSURL *yourURL = [[NSURL alloc]initWithString:u];
    //    NSLog(@"%@", localUrl);
    //    //NSURL *fileURL = [NSURL fileURLWithPath:localUrl];
    //    [self updateProfileImage];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

-(void)uploadImage{
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    BOOL isAvailable = [appDelegate isNetworkAvailable];
    if(isAvailable){
        [self.view makeToastActivity];
        
        GenericFetcher *fetcher = [[GenericFetcher alloc]init];
        
        NSString *apiKey = [[UserInfo instance] apiKey];
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        //    [param setValue:apiKey forKey:kapi_key];
        [param setValue:chosenImage forKey:kImage];
        
        //if there is a POST request send params in the fetcher method, if get request send nil to that
        // if there is a GET request send params in the urlbuilder method and nil to the fetcher method
        
        [fetcher PostImageToUrl:[URLBuilder urlForMethod:[NSString stringWithFormat:kupdate_profile_image, apiKey] withParameters:nil] withMethod:@"POST" withParams:param completionBlock:^(NSDictionary *dict) {
            NSLog(@"%@",dict);
            
            int status = [[dict valueForKey:@"status"] intValue];
            NSLog(@"Status of Image API: %d", status);
            
            if (status == 1) {
                self.image.image = chosenImage;
                
                UserInfo *userinfo = [UserInfo instance];
                
                NSString* pImageLink = [dict valueForKey:kprofile_image];
                [userinfo setValue:pImageLink forKey:kImageUrl];
                
                [userinfo setProfileimageLink:[dict valueForKey:kprofile_image]];
                [userinfo saveUserInfo];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"change" object:nil];
                [self.view hideToastActivity];
                
                
            }else {
                
                [self.view hideToastActivity];
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Error" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert show];
                
            }
        }
         errorBlock:^(NSError *error) {
             [self.view hideToastActivity];
             UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"no internet." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
             [alert show];
         }];
    }
}

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    for (UIView *subview in actionSheet.subviews) {
        if ([subview isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)subview;
            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }
    }
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

-(NSString *) getProfileUrl :(NSString *)id
{
    return [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?width=200&height=200",id];
}
@end
