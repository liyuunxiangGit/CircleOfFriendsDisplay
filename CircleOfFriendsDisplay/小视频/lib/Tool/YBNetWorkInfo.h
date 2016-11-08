//
//  YBNetWorkInfo.h
//  YBT_iOS_tch
//
//  Created by 郭顺 on 16/1/11.
//  Copyright © 2016年 郭顺. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
@interface YBNetWorkInfo : NSObject

+ (NSString *)getNetInfo;
+ (NSString *)getCurrentUserNetInfo;

@end
