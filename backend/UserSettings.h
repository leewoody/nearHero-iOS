//
//  UserSettings.h
//  nearhero
//
//  Created by apple on 8/3/16.
//  Copyright © 2016 TBoxSolutionz. All rights reserved.
//

#import "AbstractObject.h"

#define kUserSettings           @"usersettings"
#define kshowMeOnMapFlag        @"showMeonMapFlag"
#define knotifications          @"notifications"
#define kuserId                 @"userId"
#define kmessagesFlag           @"messagesFlag"
#define kshowProfessionalsFlag  @"showProfessionalFlag"
#define kenableOneMonthSub      @"enableOneMonthSub"
#define kenableSixMonthSub      @"enableSixMonthSub"
#define kenableOneYearSub       @"enalbeOneYearSub"
#define kshowAdd                @"showAdd"
#define kisSubscribed           @"isSubscribed"



@interface UserSettings : AbstractObject

@property (nonatomic, retain) NSString *userId;
@property (nonatomic, retain) NSString *notifications;
@property (nonatomic,assign) BOOL messagesFlag;
@property (nonatomic,assign) BOOL showProfesssionalFlag;
@property (nonatomic,assign) BOOL showMeOnMapFlag;
@property (nonatomic,assign) BOOL enableOneMonthSub;
@property (nonatomic,assign) BOOL enableSixMonthSub;
@property (nonatomic,assign) BOOL enableOneYearSub;
@property (nonatomic,assign) BOOL showAdd;
@property (nonatomic,assign) BOOL isSubscribed;





+ (UserSettings*)instance;

-(void) loadUserSettings;
-(void) saveUserSettings;
-(void) removeUserSettings;

@end
