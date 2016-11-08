//
//  UILabel+Corner.m
//  coder
//
//  Created by Allen Zhong on 15/5/7.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "UILabel+Corner.h"
#import "MLLabel+Size.h"

@implementation UIBarButtonItem (Lite)

+(UIBarButtonItem *) text:(NSString *)text selector:(SEL)selecor target:(id)target
{
    CGFloat width = [MLLabel getViewSizeByString:text font:[UIFont systemFontOfSize:15]].width;
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, 30)];
    [button setTitle:text forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button addTarget:target action:selecor forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
    
}
+(UIBarButtonItem *) icon:(NSString *)icon selector:(SEL)selecor target:(id)target
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    [button setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [button addTarget:target action:selecor forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}


+(UIBarButtonItem *) back:(NSString *)title selector:(SEL)selecor target:(id)target
{
    CGFloat width = [MLLabel getViewSizeByString:title font:[UIFont systemFontOfSize:15]].width+20;
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, 30)];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button addTarget:target action:selecor forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"back-arrow"] forState:UIControlStateNormal];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
    [button setImageEdgeInsets:UIEdgeInsetsMake(1, -15, 0, 0)];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

@end
