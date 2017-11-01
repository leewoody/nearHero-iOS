#include <UIKit/UIDevice.h>
#import "UIImageView+WebCache.h"

//#define API_BASE_ADDRESS        @"http://tboxsolutionz.com/nearhero/api"
 #define API_BASE_ADDRESS       @"http://www.nearhero.com/nearhero/api/"
#define SERVER_ADDRESS          @"nearhero.com"
#define SERVER_DOMAIN            @"nea.nearhero.com"




#define setImageUrl(img_view,imgurl ) \
{\
[img_view sd_setImageWithURL:[NSURL URLWithString:imgurl]];\
}
#define makeViewRound(view) \
{\
view.layer.cornerRadius = view.bounds.size.width/2;\
view.layer.masksToBounds = YES;\
}

#define IS_IPHONE (!IS_IPAD)
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPhone)


#if DEVELOPER
#define DLog(...) NSLog(__VA_ARGS__)
#else
#define DLog(...) / /
#endif

//API methods
#define klogin_with_fb      @"/login_with_fb"
#define klogin_with_li      @"/login_with_li"
#define ktest      @"/test"
#define kget_profile    @"get_profile"
#define kupdate_profile @"/update_profile"
#define kget_user_messages @"/get_user_messages"
#define kget_feedback       @"/get_feedback"
#define klatest_connections      @"latest_connections"
#define kuser_location_services @"/user_location_services"
#define kadd_review     @"/add_review"
#define kdelete_review     @"/delete_review"
#define kreport_review      @"/report_review"
#define kadd_roster         @"/add_roster"
#define kupdate_location    @"update_location"
#define kupdate_fcm_token   @"update_fcm_token"
#define ksend_notification  @"send_notification"


static NSString *subscriberSearchRange = @"12450.0";
static NSString *nonSubscriberSearchRange = @"5.0";


#define kdelete_account  @"delete_account"


#define question_categories      @"question_categories"
#define states_with_cities       @"states_with_cities"
#define category_detail        @"category_detail?"
#define user_registration       @"user_registration"
#define attorneys       @"attorneys?"
#define save_fav_advisor        @"save_fav_advisor?"


//API Keys
#define kntitle @"Title"
#define kmessages   @"messages"
#define kfcm_device_token       @"fcm_device_token"
#define location_service_status @"location_service_status"
#define klatest_message   @"latest_message"
#define kdate_time @"date_time"
#define kusers @"users"
#define kuser_id    @"user_id"
#define kfirstName   @"firstName"
#define klastName   @"lastName"
#define kheadline   @"headline"
#define kmsg_body   @"msg_body"
#define kemailAddress      @"emailAddress"
#define kprofession  @"profession"
#define klocation_service_status    @"location_service_status"
#define kli_token  @"li_token"
#define kpictureUrl @"pictureUrl"
#define kfeedback_msg   @"feedback_msg"
#define kfeedback @"feedback"
#define kname   @"name"
#define kfb_token   @"fb_token"
#define kid   @"id"
#define kdate   @"date"
#define kradius @"radius"
#define kprofile_image   @"profile_image"
//#define kconnections        @"connections"
#define kroster         @"roster"
#define krosterItem     @"rosterItem"
#define kjid            @"jid"
#define klocation @"location"
#define klatitude   @"latitude"
#define klat        @"lat"
#define klng        @"lng"
#define klongitude   @"longitude"
#define kfull_name @"full_name"
#define klocation_service_status  @"location_service_status"
#define kusername   @"username"
#define kusers   @"users"
#define kpassword   @"password"
#define kemail  @"email"
#define kphone  @"phone"
#define kResult @"Result"
#define kresult @"result"
#define krating @"rating"
#define kreviewer_id    @"reviewer_id"
#define kreview_id      @"review_id"
#define kstatename @"state_name"
#define kfrom     @"from"
#define kcategories   @"categories"
#define kcategory_id  @"category_id"
#define kquestion   @"question"
#define kstates     @"states"
#define kcategory_questions @"category_questions"
#define kcategory_name   @"category_name"
#define kcities     @"cities"
#define kcity   @"city"
#define kcity_id    @"city_id"
#define kapi_key    @"api_key"
#define kkeyword    @"keyword"
#define kresponse @"response"
#define kattorneys @"attorneys"
#define kadvisor_id     @"advisor_id"
#define kpositve_feedbacks      @"positive_feedbacks"
#define kgraduation_year    @"graduation_year"
#define kfirst_name     @"first_name"
#define klast_name      @"last_name"
#define kapi_secret_token       @"api_secret_token"
#define klatestsms      @"latestsms"
#define ksenderJid      @"senderJid"
#define kreceiverJid    @"receiverJid"
#define kchatPartner    @"chatPartner"
#define ktime           @"time"
#define kuserJid        @"userJid"
#define kinvite         @"invite"
#define kinvite_phone   @"invite_phone"
#define kcontact_detail @"contact_detail"
#define kUn_Invited_Users   @"not_invited_users"
#define kInvited_Users    @"invited_users"
#define kphone_no       @"phone_no"
#define kusername @"username"
#define kupdate_invite_status   @"update_invite_status"


#define kstatus   @"status"
#define kerror   @"error"
#define kuser_info   @"user_info"
#define ksearch_user @"/search_user"
#define ksearch_user @"/search_user"
#define kupdate_profile_image @"update_profile_image/%@"

#define kkreloadLocationAnnotationOnMap     @"reloadLocationAnnotationOnMap"
///IAP
#define kresetRemainingDays         @"resetRemainingDays"
#define ksubscribedToExpand         @"isSubscribedToExpand"
#define kcheckSubscription          @"checkSubscription"
///IAP Notifications
#define ksubscribedToExpand         @"isSubscribedToExpand"
#define kcheckSubscription          @"checkSubscription"
#define kuserIsSubscribed         @"userIsSubscribed"
#define ksubscriptionIsRestored   @"subscriptionIsRestored"
#define kcallLoginAfterExpire       @"callLoginAfterExpire"



///iCloud keys
#define ksubscriptionDate       @"subscriptionDate"
#define kremainingDays          @"remainingDays"
#define kappState               @"appState"
#define kSuccess                @"Success"
#define kiCloudStatus           @"iCloudStatus"
#define kiCloudSyncTitle        @"iCloud Sync"
#define kiCloudSyncMessage      @"Please Sign In iCloud to retrieve previous subscription."
#define kproductIdentifier      @"productIdentifier"

//User defaults
#define kisAppLatestVersion         @"isAppLatestVersion"
#define kisNotFirstTimeRun          @"isNotFirstTimeRun"
#define kExpireDate                 @"kExpireDate"
