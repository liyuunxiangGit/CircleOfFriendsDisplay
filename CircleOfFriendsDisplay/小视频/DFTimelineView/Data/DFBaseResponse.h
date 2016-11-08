//
//  HCBaseResponse.h
//  Heacha
//
//  Created by Allen Zhong on 15/1/13.
//  Copyright (c) 2015年 Datafans Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DFBaseResponse : NSObject
@property (nonatomic, strong) id data;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger errorCode;
@property (nonatomic, strong) NSString *errorMsg;

- (instancetype)initWithData:(NSDictionary *)dic;

@end
