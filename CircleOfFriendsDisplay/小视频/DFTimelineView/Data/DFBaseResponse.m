//
//  HCBaseResponse.m
//  Heacha
//
//  Created by Allen Zhong on 15/1/13.
//  Copyright (c) 2015年 Datafans Inc. All rights reserved.
//

#import "DFBaseResponse.h"

@implementation DFBaseResponse

#pragma mark - Lifecycle
- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}


- (instancetype)initWithData:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        
        if (dic && [dic isKindOfClass:[NSDictionary class]]) {
            
            id statusResult = [dic objectForKey:@"status"];
            if (statusResult&& [statusResult isKindOfClass:[NSNumber class]]) {
                self.status = [statusResult integerValue];
            }
            
            id errorCodeResult = [dic objectForKey:@"errorCode"];
            if (errorCodeResult&& [errorCodeResult isKindOfClass:[NSNumber class]]) {
                self.errorCode = [errorCodeResult integerValue];
            }
            
            id errorMsgResult = [dic objectForKey:@"errorMsg"];
            if (errorMsgResult&& [errorMsgResult isKindOfClass:[NSString class]]) {
                self.errorMsg = errorMsgResult;
            }
            
            id dataResult = [dic objectForKey:@"data"];
            if (dataResult) {
                self.data = dataResult;
            }
            
        }

        
    }
    return self;
}

@end
