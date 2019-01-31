//


#import "YBNetWorkInfo.h"
#import "AppDelegate.h"
@implementation YBNetWorkInfo

+ (NSString *)getNetInfomation{
    CTTelephonyNetworkInfo *networkStatus = [[CTTelephonyNetworkInfo alloc]init];  //创建一个CTTelephonyNetworkInfo对象
    NSString *currentStatus  = networkStatus.currentRadioAccessTechnology; //获取当前网络描述
    NSLog(@"currentStatus=%@",networkStatus.currentRadioAccessTechnology);
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevA"]){
        //CDMA的EVDORevA(应该也算3G吧?)
        return @"CDMAEVDORevA";
    }
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevB"]){
        //CDMA的EVDORev0(应该还是算3G吧?)
        return @"CDMAEVDORevB";
    }
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyeHRPD"]){
        //HRPD网络
        return @"HRPD";
    }
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyLTE"]){
        //LTE4G网络
        return @"LTE";
    }
    
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyGPRS"]){
        //GPRS网络
        return @"GPRS";
    }
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyEdge"]){
        //2.75G的EDGE网络
        return @"EDGE";
    }
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyWCDMA"]){
        //3G WCDMA网络
        return @"WCDMA";
    }
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSDPA"]){
        //3.5G网络
        return @"HSDPA";
    }
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSUPA"]){
        //3.5G网络
        return @"HSUPA";
    }
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMA1x"]){
        //CDMA2G网络
        return @"CDMA1x";
    }
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORev0"]){
        //CDMA的EVDORev0(应该算3G吧?)
        return @"EVDORev0";
    }

    return currentStatus;
}

+ (NSString *)getNowUserNetInfomation{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    
    NSLog(@"当前  网络  是:%@",delegate.netType);
    
    
    return delegate.netType;
}
+ (NSString *)getid{
    return @"hahha";
}
@end
