//
//  DFBaseTabBarController.m
//  coder
//
//  Created by Allen Zhong on 15/5/4.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "DFBaseTabBarController.h"

@implementation DFBaseTabBarController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initTabBar];
    }
    return self;
}


-(void) initTabBar
{
    NSArray *controllers = [self getControllers];
    if (controllers == nil) {
        return;
    }
    
    NSMutableArray *navControllers =[NSMutableArray array];
    
    for (UIViewController *controller in controllers) {
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
        [navControllers addObject:nav];
    }
    
    self.viewControllers = navControllers;
    
    NSArray *items =  self.tabBar.items;
    for (int index = 0; index < items.count; index++) {
        UITabBarItem *item = [items objectAtIndex:index];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[self colorNormal]} forState:UIControlStateNormal];
         [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[self colorSelected]} forState:UIControlStateSelected];
        item.image = [[UIImage imageNamed:[[self getIcons] objectAtIndex:index]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        item.selectedImage = [[UIImage imageNamed:[[self getSelectedIcons] objectAtIndex:index]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
    }
}


-(NSArray *)getControllers
{
    return nil;
}

-(NSArray *) getIcons
{
    return  nil;
}
-(NSArray *) getSelectedIcons
{
    return nil;
}

-(UIColor *) colorNormal
{
    return [UIColor lightGrayColor];
}
-(UIColor *) colorSelected
{
    return [UIColor darkGrayColor];
}
@end
