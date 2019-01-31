//
//  Macro.h
//

#ifndef Macro_h
#define Macro_h
#define  WEAKSELF  __weak __typeof(self)weakSelf = self;
// device verson float value
#define CURRENT_SYS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]



#define UIColorFromRGB2(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


// image
#define STRETCH_IMAGE(image, top, left, bottom, right) (CURRENT_SYS_VERSION < 6.0 ? [image stretchableImageWithLeftCapWidth:left topCapHeight:top] : [image resizableImageWithCapInsets:UIEdgeInsetsMake(top, left, bottom, right) resizingMode:UIImageResizingModeStretch])

#define XH_STRETCH_IMAGE(image, edgeInsets) (CURRENT_SYS_VERSION < 6.0 ? [image stretchableImageWithLeftCapWidth:edgeInsets.left topCapHeight:edgeInsets.top] : [image resizableImageWithCapInsets:edgeInsets resizingMode:UIImageResizingModeStretch])

//判断是否是11位手机号
#define IsValidPhoneNum(phoneNum)\
[[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^\\d{11}$"] evaluateWithObject:[NSString stringWithFormat:@"%@",phoneNum]]



//颜色
#define UIColorFromRGB2(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//获取屏幕 宽度、高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define  YBSCREEN    [UIScreen mainScreen].bounds.size

#define CC_MD5_DIGEST_LENGTH 32





#endif /* Macro_h */
