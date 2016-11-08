//
//  NSMutableDictionary+JSON.h
//  DFCommon
//
//  Created by Allen Zhong on 15/4/12.
//  Copyright (c) 2015年 Datafans Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (JSON)

-(NSString*) dic2jsonString:(id)object;
-(NSData *) dic2jsonData:(id)object;

@end
