

#import "URLBuilder.h"
#import "Constants.h"

@implementation URLBuilder



+ (NSURL*)urlForMethod:(NSString*)method withParameters:(NSDictionary*)params{
    
    NSURL* result;
    
    NSMutableString *queryString = [[[NSMutableString alloc] init]autorelease];
    
    for(NSString *key in [params allKeys]){
        
        id object= [params objectForKey:key];
        
        if (object){
            [queryString appendFormat:@"%@=%@&", key, [params objectForKey:key]];
        }else{
            [NSException exceptionWithName:[NSString stringWithFormat:@"%s",__PRETTY_FUNCTION__] reason:@"Invalid key value pair" userInfo:nil]; 
        }          
    }
    
    NSLog(@"%@",queryString);
	if([queryString length]>0)
	{
		queryString =[NSString stringWithFormat:@"%@",[queryString substringToIndex:[queryString length]-1]];
        
	}
    
    
    

    NSString *url=[NSString stringWithFormat:@"%@%@%@",API_BASE_ADDRESS,method,queryString];

    NSLog(@"%@",url);
	NSString *encodedURL=[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    result = [NSURL URLWithString:encodedURL];
    
    return result;         
    
}
+ (NSURL*)urlWithBaseAddress:(NSString*)baseAddress ForMethod:(NSString*)method withParameters:(NSDictionary*)params{
    
    NSURL* result;
    
    NSMutableString *queryString = [[[NSMutableString alloc] init]autorelease];
    
    for(NSString *key in [params allKeys]){
        
        id object= [params objectForKey:key];
        
        if (object){
            [queryString appendFormat:@"%@=%@&", key, [params objectForKey:key]];
        }else{
            [NSException exceptionWithName:[NSString stringWithFormat:@"%s",__PRETTY_FUNCTION__] reason:@"Invalid key value pair" userInfo:nil];
        }
    }
    
	if([queryString length]>0)
	{
		queryString =[NSString stringWithFormat:@"%@",[queryString substringToIndex:[queryString length]-1]];
        
	}
    
    
    
    
    NSString *url=[NSString stringWithFormat:@"%@%@%@",baseAddress,method,queryString];
    
	NSString *encodedURL=[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    result = [NSURL URLWithString:encodedURL];
    
    return result;
    
}


@end
