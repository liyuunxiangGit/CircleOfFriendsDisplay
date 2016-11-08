//
//  AppDelegate.h
//  CircleOfFriendsDisplay
//
//  Created by 李云祥 on 16/9/22.
//  Copyright © 2016年 李云祥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (copy, nonatomic) NSString *netType;  //网络环境 wifi,3g,4g,2g
@end

