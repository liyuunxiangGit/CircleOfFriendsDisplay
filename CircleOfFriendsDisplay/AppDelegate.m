//
//  AppDelegate.m
//  CircleOfFriendsDisplay
//
//  Created by 李云祥 on 16/9/22.
//  Copyright © 2016年 李云祥. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "YBNetWorkInfo.h"
#define kNotifierNetStatus @"NetStatusMonitor"
#define kNotifierBeginAllTask @"beginAllTask"
#define kNotifierNetValid @"kNotifierNetValid"
#define  WEAKSELF  __weak __typeof(self)weakSelf = self;

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    UINavigationController *nav = [[UINavigationController alloc]init];
    ViewController *vc = [[ViewController alloc]init];
    [nav addChildViewController:vc];
    self.window.rootViewController = nav;
    
    return YES;
}
- (void)setNetMonitor{
    WEAKSELF;
    [[AFNetworkReachabilityManager sharedManager]setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        //       DDLogInfo(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        NSDictionary *dic = @{@"status":[NSNumber numberWithInteger:status]};
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifierNetStatus object:dic];
        
        if (status == AFNetworkReachabilityStatusReachableViaWiFi) {
            weakSelf.netType = @"wifi";
        }else if (status == AFNetworkReachabilityStatusReachableViaWWAN){
            weakSelf.netType = [YBNetWorkInfo getNetInfo];
        }else{
            weakSelf.netType = @"invalid";
        }
        if (status == AFNetworkReachabilityStatusReachableViaWWAN || status == AFNetworkReachabilityStatusReachableViaWiFi) {
            //发送网络可用通知
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotifierNetValid object:nil];
        }
    }];
    
    [[AFNetworkReachabilityManager sharedManager]startMonitoring];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
