//
//  DFImageHelper.m
//  DFCommon
//
//  Created by Allen Zhong on 15/10/4.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "DFImageHelper.h"

@implementation DFImageHelper

+ (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize,image.size.height*scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height *scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

@end
