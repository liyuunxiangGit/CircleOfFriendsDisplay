//
//  DynamicItem.h
//  CircleOfFriendsDisplay
//
//  Created by 李云祥 on 16/9/22.
//  Copyright © 2016年 李云祥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DynamicItem : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *avatar;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *date;

@property (nonatomic, copy) NSString *time;

@property (nonatomic, strong) NSArray *imgs;

@property (nonatomic, copy) NSString *statusID;

@property (nonatomic, strong) NSArray *commentList;

@property (nonatomic, assign)BOOL textOpenFlag;

-(id)initWithDict:(NSDictionary *)dict;
+(id)dynamicWithDict:(NSDictionary *)dict;

@end
