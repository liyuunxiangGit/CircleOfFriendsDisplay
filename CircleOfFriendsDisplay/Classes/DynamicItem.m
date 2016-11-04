//
//  DynamicItem.m
//  CircleOfFriendsDisplay
//
//  Created by 李云祥 on 16/9/22.
//  Copyright © 2016年 李云祥. All rights reserved.
//

#import "DynamicItem.h"

@implementation DynamicItem
-(id)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
+(id)dynamicWithDict:(NSDictionary *)dict
{
    return [[self alloc]initWithDict:dict];
}
//- (void)setValue:(id)value forUndefinedKey:(NSString *)key  {
//    if([key isEqualToString:@"id"])
//        self.userid = value;
//}
@end
