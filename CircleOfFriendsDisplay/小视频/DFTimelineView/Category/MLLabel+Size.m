//
//  MLLabel+Size.m
//  DFWeChatView
//
//  Created by Allen Zhong on 15/10/3.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "MLLabel+Size.h"

@implementation MLLabel (Size)


+(CGSize)getViewSize:(NSAttributedString *)attributedText maxWidth:(CGFloat)maxWidth font:(UIFont *) font lineHeight:(CGFloat) lineHeight lines:(NSUInteger)lines
{
    if ([attributedText.string isEqualToString:@""]) {
        return CGSizeMake(0, 0.0);
    }
    MLLinkLabel *label = [MLLinkLabel new];
    label.font = font;
    label.numberOfLines = lines;
    label.adjustsFontSizeToFitWidth = NO;
    label.textInsets = UIEdgeInsetsZero;
    label.lineHeightMultiple = lineHeight;
    
    label.dataDetectorTypes = MLDataDetectorTypeAll;
    label.allowLineBreakInsideLinks = NO;
    label.linkTextAttributes = nil;
    label.activeLinkTextAttributes = nil;
    label.attributedText = attributedText;
    [label sizeToFit];
    return [label preferredSizeWithMaxWidth:maxWidth];
    
}


+(CGSize)getViewSizeByString:(NSString *)text maxWidth:(CGFloat)maxWidth font:(UIFont *)font lineHeight:(CGFloat)lineHeight lines:(NSUInteger)lines
{
    if ([text isEqualToString:@""]) {
        return CGSizeMake(0, 0.0);
    }
    MLLabel *label = [MLLabel new];
    label.font = font;
    label.numberOfLines = lines;
    label.adjustsFontSizeToFitWidth = NO;
    label.textInsets = UIEdgeInsetsZero;
    label.lineHeightMultiple = lineHeight;
    label.text = text;
    [label sizeToFit];
    return [label preferredSizeWithMaxWidth:maxWidth];
    
}

+(CGSize)getViewSizeByString:(NSString *)text maxWidth:(CGFloat)maxWidth font:(UIFont *)font
{
    return [MLLabel getViewSizeByString:text maxWidth:maxWidth font:font lineHeight:1.0 lines:1];
}


+(CGSize)getViewSizeByString:(NSString *)text font:(UIFont *)font
{
    return [MLLabel getViewSizeByString:text maxWidth:320.0f font:font lineHeight:1.0 lines:1];
}



@end
