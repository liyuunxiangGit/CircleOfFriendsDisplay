//
//  DFReachabilityUtil.m
//  Heacha
//
//  Created by Allen Zhong on 15/2/13.
//  Copyright (c) 2015年 Datafans Inc. All rights reserved.
//

#import "DFReachabilityUtil.h"

@implementation DFReachabilityUtil

+(BOOL) isNetworkAvailable
{
    return [Reachability isEnable3G] || [Reachability isEnableWIFI]?YES:NO;
}
@end
