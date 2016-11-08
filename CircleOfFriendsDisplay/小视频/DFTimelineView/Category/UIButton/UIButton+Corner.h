//
//  UILabel+Corner.h
//  coder
//
//  Created by Allen Zhong on 15/5/7.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Corner)

+(UIButton *) cornerButton:(UIColor *) bgColor text:(NSString *) text font:(UIFont *)font textColor:(UIColor *) textColor;
+(UIButton *) cornerButton:(UIColor *) bgColor text:(NSString *) text font:(UIFont *)font;
+(UIButton *) cornerButton:(UIColor *) bgColor text:(NSString *) text;

@end
