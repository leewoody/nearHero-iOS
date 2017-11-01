//
//  SelectJobTitleViewController.m
//  nearhero
//
//  Created by Irfan Malik on 6/9/16.
//  Copyright © 2016 TBoxSolutionz. All rights reserved.
//

#import "AppDelegate.h"
#import "SelectJobTitleViewController.h"
#import "UserLocationViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UserInfo.h"
#import "Constants.h"
#import "GenericFetcher.h"
#import "URLBuilder.h"
#import "Toast+UIView.h"
#import <sys/utsname.h>
#include <sys/types.h>
#include <sys/sysctl.h>

@interface SelectJobTitleViewController ()
{
    UserInfo *userInfo;
}
@end

@implementation SelectJobTitleViewController
@synthesize professionEditor;

NSString* machineName()
{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //by ahmad, to change profile image....
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(change:)
                                                 name:@"change" object:nil];
    //end...
    
    
    userInfo = [UserInfo instance];
    setImageUrl(self.profile_image, userInfo.imageUrl);
    makeViewRound(self.image_container);
    
    self.userProfileName.text = userInfo.name;
    
    
    //code for hiding the profession of user...
    self.profession.hidden = YES;
    
    
    
    self.radus.layer.cornerRadius = 5;
    self.radus.layer.borderWidth = 0.50;
    self.radus.layer.borderColor = [UIColor whiteColor].CGColor;
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"black.jpeg"]];
    
    //for keyboard...
    self.professionEditor.delegate = self;
    
    
    //This code is for settig view up for 4s screen
    
    
    //end of settig view for 4s screen...
}

//for changing profile image...
-(void) change:(NSNotification *) notification{
    UserInfo *userinfo = [UserInfo instance];
    
}

//end...

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    
    NSString *machine = machineName();
    
    
    if([machineName() isEqualToString:@"x86_64"] || [machineName() isEqualToString:@"iPhone4,1"] )
    {
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Title" message:@"inside 4s condition" preferredStyle:UIAlertControllerStyleAlert];
//        
//        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
//        [alertController addAction:ok];
//        
//        [self presentViewController:alertController animated:YES completion:nil];

        //deviceType = @"iPhone 4S";
        
        [self.radus setFrame: CGRectMake(self.radus.frame.origin.x, self.radus.frame.origin.y-80, self.radus.frame.size.width, self.radus.frame.size.height )];
        [self.image_container setFrame: CGRectMake(self.image_container.frame.origin.x, self.image_container.frame.origin.y-80, self.image_container.frame.size.width, self.image_container.frame.size.height )];
        
    }

    return true;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (IBAction)getStaredSearch:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(getStartedTapped)]) {
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        BOOL isAvailable = [appDelegate isNetworkAvailable];
        if(isAvailable){
            userInfo = [UserInfo instance];
            NSString *s = professionEditor.text;
            [userInfo setProfession:professionEditor.text];
            [userInfo saveUserInfo];
            //////////////Abeera
            [self.view makeToastActivity];
            NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
            [params setValue:userInfo.apiKey forKey:kapi_key];
            [params setValue:[userInfo valueForKey:kname] forKey:kname];
            [params setValue:professionEditor.text forKey:kprofession];
            //[self.view makeToastActivity];
            GenericFetcher *fetcher = [[GenericFetcher alloc]init];
            [fetcher fetchWithUrl:[URLBuilder urlForMethod:kupdate_profile withParameters:nil]
                       withMethod:POST_REQUEST withParams:params completionBlock:^(NSDictionary *dict) {
                           NSLog(@"%@",dict);
                           int status = [[dict valueForKey:kstatus] intValue];
                           if (status == 1) {
                               
                               
                               [self.view hideToastActivity];
                               
                           }
                           else
                           {
                               UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:[dict valueForKey:kerror] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                               [alert show];
                                [self.view hideToastActivity];
                               
                           }
                           
                       }
                       errorBlock:^(NSError *error) {
                             [self.view hideToastActivity];
                           NSLog(@"no internet");
                           NSLog(@"%@",error);
                           
                       }];
        }
        //////////////Abeera
        
        [self.delegate getStartedTapped];
    }
//    UserLocationViewController *userLocationVC = [[UserLocationViewController alloc]initWithNibName:@"UserLocationViewController" bundle:nil];
//    [self.navigationController pushViewController:userLocationVC animated:YES];
    
    //[self openMapScreen];
}

//#pragma mark - IBACTIONS
//-(void)openMapScreen{
//    
//    HomeViewController *viewController = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
//    //    NavigationController *navigationController = [[NavigationController alloc] initWithRootViewController:viewController];
//    MainViewController *mainViewController = nil;
//    
//    mainViewController = [[MainViewController alloc] initWithRootViewController:viewController
//                                                              presentationStyle:LGSideMenuPresentationStyleSlideAbove
//                                                                           type:0];
//    
//    UIWindow *window = [UIApplication sharedApplication].delegate.window;
//    
//    window.rootViewController = mainViewController;
//    
//    [UIView transitionWithView:window
//                      duration:0.3
//                       options:UIViewAnimationOptionTransitionCrossDissolve
//                    animations:nil
//                    completion:nil];
//    
//    
//}

    - (IBAction)moveBack:(id)sender {
        [self.navigationController popViewControllerAnimated:YES];
        
    }

//- (IBAction)clickProfession:(id)sender {
////    [self.professionEditor becomeFirstResponder];
////    _professionEditor.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
////    
////    self.professionEditor.inputView = self.datePicker;
//    
//    _professionEditor.hidden = NO;
//    [_professionEditor becomeFirstResponder];
//}

//-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    if([machineName() isEqualToString:@"x86_64"] || [machineName() isEqualToString:@"iPhone4,1"] )
    {
        [self.radus setFrame: CGRectMake(self.radus.frame.origin.x, self.radus.frame.origin.y+80, self.radus.frame.size.width, self.radus.frame.size.height )];
        [self.image_container setFrame: CGRectMake(self.image_container.frame.origin.x, self.image_container.frame.origin.y+80, self.image_container.frame.size.width, self.image_container.frame.size.height )];
    }
    
    [textField resignFirstResponder];
    return YES;
}

//-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
//    if([text isEqualToString:@"\n"]){
//        [self.professionEditor resignFirstResponder];
//        return NO;
//    }
//    else{
//        return YES;
//    }
//}
@end
