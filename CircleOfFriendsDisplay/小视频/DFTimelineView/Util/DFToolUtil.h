//
//  DFToolUtil.h
//  DFWeChatView
//
//  Created by Allen Zhong on 15/10/3.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DFToolUtil : NSObject

+(NSString *) md5:(NSString *) str;
+(NSString *) md5WithVideoPath:(NSString*)path;

+(NSString *) preettyTime:(long long) ts;


@end
