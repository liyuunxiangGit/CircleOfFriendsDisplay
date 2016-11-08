//
//  RRDevice.m
//  PhotoCollage
//
//  Created by Rongrong Lai on 12-3-21.
//  Copyright (c) 2012年 ILRRONG. All rights reserved.
//

#import "RRDevice.h"
#import <sys/sysctl.h>
#import <sys/socket.h>
#import <net/if.h>
#import <net/if_dl.h>

@interface RRDevice (Private)

+ (NSString *)getSysInfoByName:(char *)typeSpecifier;

@end

@implementation RRDevice

+ (BOOL)deviceIsRetina
{
    UIUserInterfaceIdiom userInterfaceIdiom = [[UIDevice currentDevice] userInterfaceIdiom];
    if(userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {
        UIScreen *deviceScreen = [UIScreen mainScreen];
        UIScreenMode *currentMode = [deviceScreen currentMode];
        CGSize modeSize = currentMode.size;
        if(modeSize.width > 480.0 || modeSize.height > 480.0)
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    else if(userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        UIScreen *deviceScreen = [UIScreen mainScreen];
        UIScreenMode *currentMode = [deviceScreen currentMode];
        CGSize modeSize = currentMode.size;
        if(modeSize.width > 1024.0 || modeSize.height > 1024.0)
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    else
    {
        return YES;
    }
}

+ (NSInteger)systemVersionNumber
{
    UIDevice *currentDevice = [UIDevice currentDevice];
    NSString *systemVersion = currentDevice.systemVersion;
    NSRange versionRange = {0, 1};
    NSString *versionString = [systemVersion substringWithRange:versionRange];
    return [versionString integerValue];
}

+ (NSString *)getSysInfoByName:(char *)typeSpecifier
{
	size_t size;
    sysctlbyname(typeSpecifier, NULL, &size, NULL, 0);
    char *answer = malloc(size);
	sysctlbyname(typeSpecifier, answer, &size, NULL, 0);
	NSString *results = [NSString stringWithCString:answer encoding: NSUTF8StringEncoding];
	free(answer);
	return results;
}

+ (RRDeviceIdentifier)getDeviceIdentifier
{
    RRDeviceIdentifier deviceIdentifier = RRDevice_Unknow;
    
    NSString *deviceIdentifierString = [self getSysInfoByName:"hw.machine"];
    
    if([deviceIdentifierString isEqualToString:@"iPhone1,1"])
    {
        deviceIdentifier = RRDevice_iPhone1G;
    }
    else if([deviceIdentifierString isEqualToString:@"iPhone1,2"])
    {
        deviceIdentifier = RRDevice_iPhone3G;
    }
    else if([deviceIdentifierString isEqualToString:@"iPhone2,1"])
    {
        deviceIdentifier = RRDevice_iPhone3GS;
    }
    else if([deviceIdentifierString isEqualToString:@"iPhone3,1"])
    {
        deviceIdentifier = RRDevice_iPhone4;
    }
    else if([deviceIdentifierString isEqualToString:@"iPhone3,3"])
    {
        deviceIdentifier = RRDevice_iPhone4;
    }
    else if([deviceIdentifierString isEqualToString:@"iPhone4,1"])
    {
        deviceIdentifier = RRDevice_iPhone4S;
    }
    else if([deviceIdentifierString isEqualToString:@"iPod1,1"])
    {
        deviceIdentifier = RRDevice_iPodTouch1G;
    }
    else if([deviceIdentifierString isEqualToString:@"iPod2,1"])
    {
        deviceIdentifier = RRDevice_iPodTouch2G;
    }
    else if([deviceIdentifierString isEqualToString:@"iPod3,1"])
    {
        deviceIdentifier = RRDevice_iPodTouch3G;
    }
    else if([deviceIdentifierString isEqualToString:@"iPod4,1"])
    {
        deviceIdentifier = RRDevice_iPodTouch4G;
    }
    else if([deviceIdentifierString isEqualToString:@"iPad1,1"])
    {
        deviceIdentifier = RRDevice_iPad;
    }
    else if([deviceIdentifierString isEqualToString:@"iPad2,1"])
    {
        deviceIdentifier = RRDevice_iPad2;
    }
    else if([deviceIdentifierString isEqualToString:@"iPad2,2"])
    {
        deviceIdentifier = RRDevice_iPad2;
    }
    else if([deviceIdentifierString isEqualToString:@"iPad2,3"])
    {
        deviceIdentifier = RRDevice_iPad2;
    }
    else if([deviceIdentifierString isEqualToString:@"iPad3,1"])
    {
        deviceIdentifier = RRDevice_iPad3;
    }
    else if([deviceIdentifierString isEqualToString:@"iPad3,2"])
    {
        deviceIdentifier = RRDevice_iPad3;
    }
    else if([deviceIdentifierString isEqualToString:@"iPad3,3"])
    {
        deviceIdentifier = RRDevice_iPad3;
    }
    else if([deviceIdentifierString isEqualToString:@"i386"])
    {
        deviceIdentifier = RRDevice_Simulator;
    }
    else
    {
        NSRange range = [deviceIdentifierString rangeOfString:@","];
        if(range.length > 0)
        {
            NSString *string = [deviceIdentifierString substringToIndex:range.location];
            if([string isEqualToString:@"iPhone1"])
            {
                deviceIdentifier = RRDevice_iPhone1G;
            }
            else if([string isEqualToString:@"iPhone2"])
            {
                deviceIdentifier = RRDevice_iPhone3GS;
            }
            else if([string isEqualToString:@"iPhone3"])
            {
                deviceIdentifier = RRDevice_iPhone4;
            }
            else if([string isEqualToString:@"iPhone4"])
            {
                deviceIdentifier = RRDevice_iPhone4S;
            }
            if([string isEqualToString:@"iPod1"])
            {
                deviceIdentifier = RRDevice_iPodTouch1G;
            }
            else if([string isEqualToString:@"iPod2"])
            {
                deviceIdentifier = RRDevice_iPodTouch2G;
            }
            else if([string isEqualToString:@"iPod3"])
            {
                deviceIdentifier = RRDevice_iPodTouch3G;
            }
            else if([string isEqualToString:@"iPod4"])
            {
                deviceIdentifier = RRDevice_iPodTouch4G;
            }
            if([string isEqualToString:@"iPad1"])
            {
                deviceIdentifier = RRDevice_iPad;
            }
            else if([string isEqualToString:@"iPad2"])
            {
                deviceIdentifier = RRDevice_iPad2;
            }
            else if([string isEqualToString:@"iPad3"])
            {
                deviceIdentifier = RRDevice_iPad3;
            }
        }
    }
    
    return deviceIdentifier;
}

+ (BOOL)deviceIsBelowA5CPU
{
    RRDeviceIdentifier deviceIdentifier = [RRDevice getDeviceIdentifier];
    if((deviceIdentifier >= RRDevice_iPhone1G && deviceIdentifier <= RRDevice_iPhone4) || (deviceIdentifier >= RRDevice_iPodTouch1G && deviceIdentifier <= RRDevice_iPodTouch4G) || (deviceIdentifier == RRDevice_iPad))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (BOOL)deviceIsIPhone5
{
    return CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size);
}

+ (BOOL)deviceIsIPhone4
{
    return CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size);
}

+ (UIInterfaceOrientation)deviceInterfaceOrientation
{
    return [UIApplication sharedApplication].statusBarOrientation;
}

//获取当前语言
+ (NSInteger)getCurrentLanguage
{
	NSInteger language = LanguageEnglish; //英文
	NSString *currentLanuage = [[NSLocale preferredLanguages] objectAtIndex:0];
	if ([currentLanuage isEqualToString:@"zh-Hans"])
    {
		language = LanguageZhHans; //简体中文
	}
    else if([currentLanuage isEqualToString:@"zh-Hant"])
    {
		language = LanguageZhHant; //繁体中文
	}
    
	return language;
}

+ (NSString *)appVersion {
    NSDictionary *infoDictionary = [NSBundle mainBundle].infoDictionary;
    NSString *appVersionString = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    if (appVersionString && [appVersionString isKindOfClass:[NSString class]] && appVersionString.length > 0) {
        return appVersionString;
    }
    return @"1.0.0";
}

+ (NSString *)systemVersion
{
    return [UIDevice currentDevice].systemVersion;
}

+ (NSString *)macAddress
{
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return nil;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return nil;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return nil;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        free(buf);
        printf("Error: sysctl, take 2");
        return nil;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return outstring;
}

+ (NSString *)deviceModel
{
    return [self getSysInfoByName:"hw.machine"];
}

+ (BOOL)isJailBroken
{
    NSMutableArray *jailbreakApps = [NSMutableArray array];
    [jailbreakApps addObject:@"/Applications/Cydia.app"];
    [jailbreakApps addObject:@"/Applications/limera1n.app"];
    [jailbreakApps addObject:@"/Applications/greenpois0n.app"];
    [jailbreakApps addObject:@"/Applications/blackra1n.app"];
    [jailbreakApps addObject:@"/Applications/blacksn0w.app"];
    [jailbreakApps addObject:@"/Applications/redsn0w.app"];
    
    for (NSInteger i = 0; i < jailbreakApps.count; i++)
	{
		//检测应用路径的方式来判断是否越狱
		if ([[NSFileManager defaultManager] fileExistsAtPath:[jailbreakApps objectAtIndex:i]])
		{
			return YES;
		}
	}
	
	return NO;
}

@end
