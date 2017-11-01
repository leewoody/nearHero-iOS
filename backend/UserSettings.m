//
//  UserSettings.m
//  nearhero
//
//  Created by apple on 8/3/16.
//  Copyright © 2016 TBoxSolutionz. All rights reserved.
//

#import "UserSettings.h"
static UserSettings *singletonInstance;

@implementation UserSettings

-(void) copyObject :(UserSettings *) objToCopy{
    //Main
    singletonInstance.userId = objToCopy.userId;
    singletonInstance.notifications = objToCopy.notifications;
    singletonInstance.showMeOnMapFlag = objToCopy.showMeOnMapFlag;
    singletonInstance.messagesFlag  = objToCopy.messagesFlag;
    singletonInstance.showProfesssionalFlag = objToCopy.showProfesssionalFlag;
    singletonInstance.enableOneYearSub = objToCopy.enableOneYearSub;
    singletonInstance.enableOneMonthSub = objToCopy.enableOneMonthSub;
    singletonInstance.enableSixMonthSub = objToCopy.enableSixMonthSub;
    singletonInstance.showAdd = objToCopy.showAdd;
    singletonInstance.isSubscribed = objToCopy.isSubscribed;
}

#pragma mark - Custom Methods

-(void) loadUserSettings{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *myEncodedObject = [defaults objectForKey:kUserSettings];
    [defaults synchronize];
    UserSettings *obj = (UserSettings *)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
    if (obj) {
        [self copyObject:obj];
    }
}

-(void)saveUserSettings{
    NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:singletonInstance];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:myEncodedObject forKey:kUserSettings];
    [defaults synchronize];
}

-(NSString*) nullCheck :(NSString *)str{if (str) {return str;}return @"";}

#pragma mark - Encode Decoder
- (void)encodeWithCoder:(NSCoder *)encoder{
    //Main
    [encoder encodeBool: [self showMeOnMapFlag] forKey:kshowMeOnMapFlag];
    [encoder encodeObject:[self userId] forKey:kuserId];
    [encoder encodeBool:[self showProfesssionalFlag] forKey:kshowProfessionalsFlag];
    [encoder encodeObject:[self notifications] forKey:knotifications];
    [encoder encodeBool:[self messagesFlag] forKey:kmessagesFlag];
    [encoder encodeBool:[self enableOneMonthSub] forKey:kenableOneMonthSub];
    [encoder encodeBool:[self enableSixMonthSub] forKey:kenableSixMonthSub];
    [encoder encodeBool:[self enableOneYearSub] forKey:kenableOneYearSub];
    [encoder encodeBool:[self showAdd] forKey:kshowAdd];
    [encoder encodeBool:[self isSubscribed] forKey:kisSubscribed];
}
- (id)initWithCoder:(NSCoder *)decoder{
    if((self = [super init])) {
        self.userId = [decoder decodeObjectForKey:kuserId];
        self.showProfesssionalFlag = [decoder decodeBoolForKey:kshowProfessionalsFlag];
        self.showMeOnMapFlag = [decoder decodeBoolForKey:kshowMeOnMapFlag];
        self.messagesFlag = [decoder decodeBoolForKey:kmessagesFlag];
        self.notifications = [decoder decodeObjectForKey:knotifications];
        self.enableOneMonthSub = [decoder decodeBoolForKey:kenableOneMonthSub];
        self.enableSixMonthSub = [decoder decodeBoolForKey:kenableSixMonthSub];
        self.enableOneYearSub = [decoder decodeBoolForKey:kenableOneYearSub];
        self.showAdd = [decoder decodeBoolForKey:kshowAdd];
        self.isSubscribed = [decoder decodeBoolForKey:kisSubscribed];
    }
    return self;
}

-(void) setUserSettings:(NSDictionary *)userDict{
    self.userId = [userDict valueForKey:kuserId];
    self.showMeOnMapFlag = [[userDict valueForKey:kshowMeOnMapFlag]boolValue];
    self.messagesFlag = [[userDict valueForKey:kmessagesFlag]boolValue];
    self.showProfesssionalFlag = [[userDict valueForKey:kshowProfessionalsFlag]boolValue];
    self.notifications = [userDict valueForKey:knotifications];
    self.enableOneMonthSub = [[userDict valueForKey:kenableOneMonthSub]boolValue];
    self.enableSixMonthSub = [[userDict valueForKey:kenableSixMonthSub]boolValue];
    self.enableOneYearSub = [[userDict valueForKey:kenableOneYearSub] boolValue];
    self.showAdd = [[userDict valueForKey:kshowAdd] boolValue];
    self.isSubscribed = [[userDict valueForKey:kisSubscribed] boolValue];
}

-(void) removeUserSettings{
    
    self.userId = nil;
    self.showMeOnMapFlag = nil;
    self.messagesFlag = nil;
    self.showProfesssionalFlag = nil;
    self.notifications = nil;
    self.enableOneYearSub = nil;
    self.enableOneMonthSub = nil;
    self.enableSixMonthSub = nil;
    self.showAdd = nil;
    self.isSubscribed = nil;

    
}


#pragma mark - init
- (id) init {
    if (self = [super init]) {
    }
    return self;
}

#pragma mark - Shared Instance
+ (UserSettings*)instance{
    if(!singletonInstance)
    {
        singletonInstance=[[UserSettings alloc]init];
        [singletonInstance loadUserSettings];
    }
    return singletonInstance;
}

@end
