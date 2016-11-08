//
//  UITabbar+Badge.m
//  coder
//
//  Created by Allen Zhong on 15/8/14.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "UITabbar+Badge.h"

@implementation UITabBar (Badge)

- (void)showBadgeOnItemIndex:(int)index{
    
    [self removeBadgeOnItemIndex:index];
    
    UIView *badgeView = [[UIView alloc]init];
    
    badgeView.tag = 888 + index;
    
    badgeView.layer.cornerRadius = 5;
    
    badgeView.backgroundColor = [UIColor redColor];
    
    CGRect tabFrame = self.frame;
    
    float percentX = (index +0.6) / 4;
    
    CGFloat x = ceilf(percentX * tabFrame.size.width);
    
    CGFloat y = ceilf(0.1 * tabFrame.size.height);
    
    badgeView.frame = CGRectMake(x, y, 10, 10);
    
    [self addSubview:badgeView];
    
}

- (void)hideBadgeOnItemIndex:(int)index{
    
    [self removeBadgeOnItemIndex:index];
    
}

- (void)removeBadgeOnItemIndex:(int)index{
    
    for (UIView *subView in self.subviews) {
        
        if (subView.tag == 888+index) {
            
            [subView removeFromSuperview];
            
        }
    }
}

@end
