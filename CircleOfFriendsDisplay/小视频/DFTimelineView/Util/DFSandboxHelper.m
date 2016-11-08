//
//  DFSandboxHelper.m
//  DFWeChatView
//
//  Created by Allen Zhong on 15/4/21.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "DFSandboxHelper.h"

@implementation DFSandboxHelper


+(NSString *) getDocPath
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

@end
