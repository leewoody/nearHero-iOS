

#import "UserInfo.h"



static UserInfo *singletonInstance;
@implementation UserInfo


-(void) copyObject :(UserInfo *) objToCopy{
	//Main
    singletonInstance.name = objToCopy.name;
    singletonInstance.firstName = objToCopy.firstName;
    singletonInstance.lastName  = objToCopy.lastName;
    singletonInstance.password = objToCopy.password;
    singletonInstance.profession = objToCopy.profession;
    singletonInstance.jidPassword = objToCopy.jidPassword;
    singletonInstance.isPasswordChanged = objToCopy.isPasswordChanged;
    singletonInstance.emailAddress = objToCopy.emailAddress;
    singletonInstance.securityAnswer = objToCopy.securityAnswer;
    singletonInstance.apiKey = objToCopy.apiKey;
    singletonInstance.recentSearch = objToCopy.recentSearch;

    singletonInstance.fbLiToken = objToCopy.fbLiToken;
    singletonInstance.isLogin = objToCopy.isLogin;
    singletonInstance.gender=objToCopy.gender;
    singletonInstance.campusID = objToCopy.campusID;
    singletonInstance.imageUrl = objToCopy.imageUrl;
    singletonInstance.schoolName = objToCopy.schoolName;
    singletonInstance.campusName = objToCopy.campusName;
    singletonInstance.location = objToCopy.location;
    singletonInstance.fcm_device_token = objToCopy.fcm_device_token;
    
    //
    singletonInstance.birthdays = objToCopy.birthdays;
    singletonInstance.states = objToCopy.states;
    singletonInstance.citys = objToCopy.citys;
    singletonInstance.countrys = objToCopy.countrys;
    singletonInstance.companys = objToCopy.companys;
    singletonInstance.titles = objToCopy.titles;
    singletonInstance.likes = objToCopy.likes;
    singletonInstance.dislikes = objToCopy.dislikes;
    singletonInstance.cellNumber = objToCopy.cellNumber;
    singletonInstance.specialInterest = objToCopy.specialInterest;
    singletonInstance.profileimageLink = objToCopy.profileimageLink;
    singletonInstance.userVoiceLink = objToCopy.userVoiceLink;
    singletonInstance.longitude = objToCopy.longitude;
    singletonInstance.latitude = objToCopy.latitude;
    singletonInstance.superUser = objToCopy.superUser;
    singletonInstance.propertyId = objToCopy.propertyId;
    
    singletonInstance.deviceId = objToCopy.deviceId;
    
    singletonInstance.uu_id = objToCopy.uu_id;
    singletonInstance.major = objToCopy.major;
    singletonInstance.mainor = objToCopy.mainor;
    singletonInstance.distance = objToCopy.distance;
    
    //for searching by ahmad...
    singletonInstance.user_all_searches = objToCopy.user_all_searches;
    singletonInstance.most_recent_search = objToCopy.most_recent_search;
    
//    [singletonInstance.user_all_searches addObjectsFromArray:objToCopy.user_all_searches];
//    
//    [singletonInstance.most_recent_search addObjectsFromArray:objToCopy.most_recent_search];

}



#pragma mark - Custom Methods

-(void) loadUserInfo{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *myEncodedObject = [defaults objectForKey:kUserInfo];
	[defaults synchronize];
    UserInfo *obj = (UserInfo *)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
	if (obj) {
		[self copyObject:obj];
	}
}

-(void)saveUserInfo{
	NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:singletonInstance];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:myEncodedObject forKey:kUserInfo];
    [defaults synchronize];
}

-(NSString*) nullCheck :(NSString *)str{if (str) {return str;}return @"";}


#pragma mark - Encode Decoder
- (void)encodeWithCoder:(NSCoder *)encoder{
	//Main
    [encoder encodeObject:[self name] forKey:kname];
    [encoder encodeObject:[self firstName] forKey:kfirst_name];
    [encoder encodeObject:[self lastName] forKey:klast_name];
    [encoder encodeObject:[self password] forKey:kpassword];
    [encoder encodeObject:[self profession] forKey:kprofession];
    [encoder encodeObject: [self recentSearch] forKey:krecentSearch];
    [encoder encodeObject:[self isPasswordChanged] forKey:kisPasswordChanged];
    [encoder encodeObject:[self emailAddress] forKey:kemail_id];
    [encoder encodeObject:[self securityAnswer] forKey:kSecurityAnswer];
    [encoder encodeObject:[self apiKey] forKey:kapikey];
    [encoder encodeObject:[self location] forKey:klocation];
    [encoder encodeObject:[self fbLiToken] forKey:kfbLiToken];
    [encoder encodeBool:[self isLogin] forKey:kislogin];
    [encoder encodeObject:[self jidPassword] forKey:kjidPassword];
    [encoder encodeObject:[self fcm_device_token] forKey:kfcm_device_token];
    //...........
    [encoder encodeObject:[self birthdays] forKey:kbirthday];
    [encoder encodeObject:[self imageUrl] forKey:kImageUrl];
    [encoder encodeObject:[self states] forKey:kstate];
    [encoder encodeObject:[self citys] forKey:kcity];
    [encoder encodeObject:[self countrys] forKey:kcountry];
    [encoder encodeObject:[self companys] forKey:kcompany];
    [encoder encodeObject:[self titles] forKey:ktitle];
    [encoder encodeObject:[self likes] forKey:klikes];
    [encoder encodeObject:[self dislikes] forKey:kdislikes];
    [encoder encodeObject:[self cellNumber] forKey:kCellNumber];
    [encoder encodeObject:[self specialInterest] forKey:kSpecialInterest];
    [encoder encodeObject:[self profileimageLink] forKey:Kprofile_image];
    [encoder encodeObject:[self userVoiceLink] forKey:kvoice];
    [encoder encodeObject:[self deviceId] forKey:kDeviceID];
    
    [encoder encodeDouble:[self longitude] forKey:kLong];
    [encoder encodeDouble:[self latitude] forKey:kLat];
    [encoder encodeInt:[self propertyId] forKey:kPropertyId];
    [encoder encodeInt:[self superUser] forKey:kSuperUSer];
    
    [encoder encodeObject:[self uu_id] forKey:kuu_id];
    [encoder encodeObject:[self major] forKey:kmajor];
    [encoder encodeObject:[self mainor] forKey:kmainor];
    [encoder encodeObject:[self distance] forKey:kdistance];
    
    
    //for searching by ahmad...
    [encoder encodeObject:[self user_all_searches] forKey:kuser_all_searches];
    [encoder encodeObject:[self most_recent_search] forKey:kmost_recent_search];

}

- (id)initWithCoder:(NSCoder *)decoder{
	if((self = [super init])) {
        self.name = [decoder decodeObjectForKey:kname];
        self.firstName = [decoder decodeObjectForKey:kfirst_name];
        self.lastName = [decoder decodeObjectForKey:klast_name];
        self.profession = [decoder decodeObjectForKey:kprofession];
        self.password = [decoder decodeObjectForKey:kpassword];
        self.recentSearch = [decoder decodeObjectForKey:krecentSearch];
        self.isPasswordChanged = [decoder decodeObjectForKey:kisPasswordChanged];
        self.emailAddress = [decoder decodeObjectForKey:kemail_id];
        self.location = [decoder decodeObjectForKey:klocation];
        self.securityAnswer = [decoder decodeObjectForKey:kSecurityAnswer];
        self.apiKey = [decoder decodeObjectForKey:kapikey];
        self.fbLiToken = [decoder decodeObjectForKey:kfbLiToken];
        self.profileimageLink = [decoder decodeObjectForKey:Kprofile_image];
        self.isLogin =[decoder decodeBoolForKey:kislogin];
        self.imageUrl =[decoder decodeObjectForKey:kImageUrl];
        self.jidPassword = [decoder decodeObjectForKey:kjidPassword];
        self.fcm_device_token = [decoder decodeObjectForKey:kfcm_device_token];
        //...........
        self.birthdays = [decoder decodeObjectForKey:kbirthday];
        self.states = [decoder decodeObjectForKey:kstate];
        self.citys = [decoder decodeObjectForKey:kcity];
        self.countrys = [decoder decodeObjectForKey:kcountry];
        self.companys = [decoder decodeObjectForKey:kcompany];
        self.titles = [decoder decodeObjectForKey:ktitle];
        self.likes = [decoder decodeObjectForKey:klikes];
        self.dislikes = [decoder decodeObjectForKey:kdislikes];
        self.cellNumber = [decoder decodeObjectForKey:kCellNumber];
        self.specialInterest = [decoder decodeObjectForKey:kSpecialInterest];
        self.userVoiceLink = [decoder decodeObjectForKey:kvoice];
        
        self.deviceId = [decoder decodeObjectForKey:kDeviceID];
        
        self.longitude = [decoder decodeDoubleForKey:kLong];
        self.latitude = [decoder decodeDoubleForKey:kLat];
        
        self.superUser = [decoder decodeIntForKey:kSuperUSer];
        self.propertyId = [decoder decodeIntForKey:kPropertyId];
        
        self.uu_id = [decoder decodeObjectForKey:kuu_id];
        self.major =[decoder decodeObjectForKey:kmajor];
        self.mainor = [decoder decodeObjectForKey:kmainor];
        self.distance = [decoder decodeObjectForKey:kdistance];
        
        
        //for searching by ahmad...
        self.user_all_searches = [decoder decodeObjectForKey:kuser_all_searches];
        self.most_recent_search = [decoder decodeObjectForKey:kmost_recent_search];

    }
	return self;
}

-(void) setUserWithInfo:(NSDictionary *)userDict{
    self.name = [userDict valueForKey:kname];
    self.firstName = [userDict valueForKey:kfirst_name];
    self.lastName = [userDict valueForKey:klast_name];
    self.emailAddress = [userDict valueForKey:kemail_id];
    self.recentSearch = [userDict valueForKey:krecentSearch];
    self.password = [userDict valueForKey:kpassword];
    self.imageUrl = [userDict valueForKey:kImageUrl];
    self.location = [userDict valueForKey:klocation];
    self.isPasswordChanged = [userDict valueForKey:kisPasswordChanged];
    self.securityAnswer = [userDict valueForKey:kSecurityAnswer];
    self.birthdays = [userDict valueForKey:kbirthday];
    self.states = [userDict valueForKey:kstate];
    self.fcm_device_token = [userDict valueForKey:kfcm_device_token];
    self.citys = [userDict valueForKey:kcity];
    self.jidPassword = [userDict valueForKey:kjidPassword];
    self.countrys = [userDict valueForKey:kcountry];
    self.companys = [userDict valueForKey:kcompany];
    self.titles = [userDict valueForKey:ktitle];
    self.likes = [userDict valueForKey:klikes];
    self.dislikes = [userDict valueForKey:kdislikes];
    self.cellNumber = [userDict valueForKey:kCellNumber];
    self.specialInterest = [userDict valueForKey:kSpecialInterest];
    self.isLogin = [[userDict valueForKey:kislogin] boolValue];
    
    self.deviceId = [userDict valueForKey:kDeviceID];
    
    self.apiKey = [userDict valueForKey:kapikey];
    self.fbLiToken = [userDict valueForKey:kfbLiToken];
    self.profileimageLink = [userDict valueForKey:Kprofile_image];
    self.userVoiceLink = [userDict valueForKey:kvoice];
    
    self.longitude = [[userDict valueForKey:kLong] doubleValue];
    self.latitude = [[userDict valueForKey:kLat] doubleValue];
    
    self.superUser = [[userDict valueForKey:kSuperUSer] intValue];
    self.propertyId = [[userDict valueForKey:kPropertyId] intValue];
    
    self.uu_id = [userDict valueForKey:kuu_id];
    self.major = [userDict valueForKey:kmajor];
    self.mainor = [userDict valueForKey:kmainor];
    self.distance = [userDict valueForKey:kdistance];
    
    //for searching by ahmad...
    self.user_all_searches = [userDict valueForKey:kuser_all_searches];
    self.most_recent_search = [userDict valueForKey:kmost_recent_search];

    
    self.isLogin = YES;
//    self.male
}


-(void) removeUserInfo{
    self.name=nil;
    self.firstName=nil;
    self.lastName=nil;
    self.securityAnswer=nil;
  //  self.emailAddress = nil;
//    self.password = nil;
    self.isPasswordChanged =nil;
    self.states =nil;
    self.citys = nil;
    self.recentSearch = nil;
    self.profession = nil;
    self.fcm_device_token = nil;
    self.countrys = nil;
    self.companys = nil;
    self.titles = nil;
    self.likes = nil;
    self.dislikes = nil;
    self.cellNumber = nil;
    self.specialInterest = nil;
    self.deviceId = nil;
    self.apiKey = nil;
    self.isLogin = NO;
    self.profileimageLink = nil;
    self.userVoiceLink=nil;
    self.location = nil;
    self.longitude = 0.0;
    self.latitude = 0.0;
    self.superUser = 0;
    self.propertyId = 0;
    self.imageUrl = nil;
    self.fbLiToken = nil;
    self.uu_id = nil;
    self.major = nil;
    self.mainor = nil;
    self.distance = nil;
    
    
    //for searching by ahmad...
    self.user_all_searches = nil;
    self.most_recent_search = nil;
    [self saveUserInfo];

}

#pragma mark - init
- (id) init {
    if (self = [super init]) {
	}
    self.isLogin= NO;
    return self;
}

#pragma mark - Shared Instance
+ (UserInfo*)instance{
    if(!singletonInstance)
	{
		singletonInstance=[[UserInfo alloc]init];
		[singletonInstance loadUserInfo];
	}
    return singletonInstance;
}
@end
