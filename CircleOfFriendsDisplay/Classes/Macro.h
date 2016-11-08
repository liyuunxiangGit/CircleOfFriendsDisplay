//
//  Macro.h
//  YBT_iOS_tch
//
//  Created by 郭顺 on 15/10/29.
//  Copyright © 2015年 郭顺. All rights reserved.
//

#ifndef Macro_h
#define Macro_h
#define  WEAKSELF  __weak __typeof(self)weakSelf = self;
// device verson float value
#define CURRENT_SYS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

// image
#define STRETCH_IMAGE(image, top, left, bottom, right) (CURRENT_SYS_VERSION < 6.0 ? [image stretchableImageWithLeftCapWidth:left topCapHeight:top] : [image resizableImageWithCapInsets:UIEdgeInsetsMake(top, left, bottom, right) resizingMode:UIImageResizingModeStretch])

#define XH_STRETCH_IMAGE(image, edgeInsets) (CURRENT_SYS_VERSION < 6.0 ? [image stretchableImageWithLeftCapWidth:edgeInsets.left topCapHeight:edgeInsets.top] : [image resizableImageWithCapInsets:edgeInsets resizingMode:UIImageResizingModeStretch])

#define UIColorFromRGB2(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//判断是否是11位手机号
#define IsValidPhoneNum(phoneNum)\
[[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^\\d{11}$"] evaluateWithObject:[NSString stringWithFormat:@"%@",phoneNum]]


//获取屏幕 宽度、高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define  YBSCREEN    [UIScreen mainScreen].bounds.size

#define CC_MD5_DIGEST_LENGTH 32

//颜色
#define UIColorFromRGB2(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]





#define XXTLogError(frmt, ...)   LOG_MAYBE(NO,                LOG_LEVEL_DEF, DDLogFlagError,   0,[YBNetWorkInfo getCurrentUserNetInfo],  __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
#define XXTLogWarn(frmt, ...)    LOG_MAYBE(LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagWarning, 0,[YBNetWorkInfo getCurrentUserNetInfo],  __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
#define XXTLogInfo(frmt, ...)    LOG_MAYBE(LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagInfo,    0,[YBNetWorkInfo getCurrentUserNetInfo],  __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
#define XXTLogDebug(frmt, ...)   LOG_MAYBE(LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagDebug,   0,[YBNetWorkInfo getCurrentUserNetInfo],  __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
#define XXTLogVerbose(frmt, ...) LOG_MAYBE(LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagVerbose, 0,[YBNetWorkInfo getCurrentUserNetInfo],  __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)





#endif /* Macro_h */
