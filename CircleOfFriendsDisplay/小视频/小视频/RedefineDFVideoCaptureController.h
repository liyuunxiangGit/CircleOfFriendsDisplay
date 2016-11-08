//
//  RedefineDFVideoCaptureController.h
//  YBT_iOS_tch
//
//  Created by shaveKevin on 16/4/21.
//  Copyright © 2016年 郭顺. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RedefineDFVideoCaptureControllerDelegate <NSObject>

@optional

-(void) onCaptureVideo:(NSString *) filePath screenShot:(UIImage *) screenShot;

@end

@interface RedefineDFVideoCaptureController : UIViewController

@property (nonatomic, assign) id<RedefineDFVideoCaptureControllerDelegate> delegate;

-(void) onCaptureVideo:(NSString *) filePath screenShot:(UIImage *) screenShot;

@end
