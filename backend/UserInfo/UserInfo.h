
#import "AbstractObject.h"

#define KStaticImageURL     @"http://www.uberguest.com/uberguest_dev/upload_image/no-image.jpg"

#define kUserInfo           @"userinfo"
#define kuser_info          @"user_info"
#define kname               @"name"
#define kfirst_name         @"first_name"
#define klast_name          @"last_name"
#define kemail_id           @"email"
#define kprofession         @"profession"
#define kjidPassword           @"jidPassword"
#define klatestMsgs         @"latestMsgs"
#define kpassword           @"password"
#define kisPasswordChanged  @"isPasswordChanged"
#define krecentSearch       @"recentSearch"
#define kbirthday           @"birthday"
#define kstate              @"state"
#define kcity               @"city"
#define kcountry            @"country"
#define kcompany            @"company"
#define ktitle              @"title"
#define kcountry            @"country"
#define klikes              @"likes"
#define kdislikes           @"dislikes"
#define kCellNumber         @"phone"
#define kSpecialInterest    @"special_instructions"
#define kSecurityAnswer    @"s_answer"
#define kapikey             @"apiKey"
//#define kapi_key            @"api_secret_token"
#define Kprofile_image      @"profile_image"
#define Kprofile_image1     @"picture"
#define kislogin            @"islogin"
#define kImageUrl           @"imageUrl"
#define kImage              @"image"
#define kvoice              @"voice"
#define klocation           @"location"
#define kfcm_device_token           @"fcm_device_token"


#define kLat           @"lat"
#define kLong          @"lng"
#define kSuperUSer          @"super_user"
#define kPropertyId         @"property_id"
#define kDeviceID           @"device_id"

#define kuu_id               @"uu_id"
#define kmajor              @"major"
#define kmainor              @"mainor"
#define kdistance           @"distance"

//#define kapi_key             @"apiKey"
#define kfbLiToken           @"fbLiToken"

//for searching by ahmad.
#define kuser_all_searches  @"user_all_searches"
#define kmost_recent_search @"most_recent_search"
@interface UserInfo : AbstractObject
@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSString *firstName;
@property (nonatomic,retain) NSString *lastName;
@property (nonatomic,retain) NSString *emailAddress;
@property (nonatomic,retain) NSString *password;
@property (nonatomic,retain) NSString *isPasswordChanged;
@property (nonatomic, retain) NSString *jidPassword;
@property (nonatomic,retain)  NSString *location;
@property (nonatomic,retain)  NSString *fcm_device_token;


@property (nonatomic,retain)  NSString *apiKey;
@property (nonatomic,retain)  NSString *recentSearch;

@property (nonatomic, retain) NSString *fbLiToken;
@property (nonatomic, retain) NSString *campusID;
@property (nonatomic,retain)  NSString *schoolName;
@property (nonatomic,retain)  NSString *campusName;
@property (nonatomic, retain) NSString *imageUrl;
@property (nonatomic, retain) NSString *gender;

@property (nonatomic, retain) NSString *profession;
@property (nonatomic, retain) NSString *birthdays;
@property (nonatomic, retain) NSString *states;
@property (nonatomic, retain) NSString *citys;
@property (nonatomic, retain) NSString *countrys;
@property (nonatomic, retain) NSString *companys;
@property (nonatomic, retain) NSString *titles;
@property (nonatomic, retain) NSString *likes;
@property (nonatomic, retain) NSString *dislikes;

@property (nonatomic, retain) NSString *cellNumber;
@property (nonatomic, retain) NSString *specialInterest;

@property (nonatomic,retain) NSString *profileimageLink;
@property (nonatomic,retain) NSString *userVoiceLink;

@property (nonatomic,retain) NSString *deviceId;
@property (nonatomic,retain) NSString *securityAnswer;

@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;

@property (nonatomic, assign) int propertyId;
@property (nonatomic, assign) int superUser;

@property (nonatomic, retain) NSString *uu_id;
@property (nonatomic, assign) NSString *major;
@property (nonatomic, assign) NSString *mainor;
@property (nonatomic, assign) NSString *distance;

//for searching by ahmad.
@property (nonatomic, retain) NSMutableArray *user_all_searches;
@property (nonatomic, retain) NSMutableArray *most_recent_search;

//@property (nonatomic, strong) NSString *latitude;
//@property (nonatomic, strong) NSString *longitude;
//
//@property (nonatomic, strong) NSString *propertyId;
//@property (nonatomic, strong) NSString *superUser;

@property BOOL isLogin;
+ (UserInfo*)instance;

-(void) loadUserInfo;
-(void) saveUserInfo;
-(void) removeUserInfo;

@end
