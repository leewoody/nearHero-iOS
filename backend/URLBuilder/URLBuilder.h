

#import <Foundation/Foundation.h>

@interface URLBuilder : NSObject

+ (NSURL*)urlForMethod:(NSString*)method withParameters:(NSDictionary*)params;
+ (NSURL*)urlWithBaseAddress:(NSString*)baseAddress ForMethod:(NSString*)method withParameters:(NSDictionary*)params;

@end
