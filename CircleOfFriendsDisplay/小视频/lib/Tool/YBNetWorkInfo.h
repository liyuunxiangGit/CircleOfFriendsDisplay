//

//

#import <Foundation/Foundation.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>


@interface YBNetWorkInfo : NSObject

+ (NSString *)getNetInfo;
+ (NSString *)getCurrentUserNetInfo;

@end
