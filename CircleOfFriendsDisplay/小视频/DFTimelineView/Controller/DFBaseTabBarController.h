//
//  DFBaseTabBarController.h
//  coder
//
//  Created by Allen Zhong on 15/5/4.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DFBaseTabBarController : UITabBarController


-(NSArray *) getControllers;

-(NSArray *) getIcons;

-(NSArray *) getSelectedIcons;


-(UIColor *) colorNormal;
-(UIColor *) colorSelected;

@end
