//
//  InviteHelper.h
//  nearhero
//
//  Created by APPLE on 19/09/2016.
//  Copyright © 2016 TBoxSolutionz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface InviteHelper : NSObject

-(NSMutableArray*)sendInvitation;
-(NSMutableArray*)getUserNames;
-(NSMutableArray*)getEmailAndNames;
-(NSMutableArray*)getNamesAgainstEmails;
-(NSMutableArray*)getPhoneNumbers;
- (void)getPermissions;
@end