

#import "AbstractObject.h"
#import <objc/runtime.h>

@implementation AbstractObject


- (NSString *)description
{
    NSMutableString *str = [[NSMutableString alloc] initWithCapacity:0];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for(i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *propName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        [str appendFormat:@"\n %@ = %@", propName, [self valueForKey:propName]];
    }
    
    free(properties);
    return str;
}
@end
