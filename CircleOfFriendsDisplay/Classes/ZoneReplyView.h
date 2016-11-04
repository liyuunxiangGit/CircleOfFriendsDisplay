//
//  ZoneReplyView.h
//  YBT_iOS_tch
//
//  Created by 郭顺 on 15/11/6.
//  Copyright © 2015年 郭顺. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DynamicCell.h"

@class ZoneReplyView;
@protocol ZoneReplyViewDelegate <NSObject>

//- (void)sendText:(NSString *)text;
- (void)ZoneReplyView:(ZoneReplyView *)zview onPressText:(NSString *)text;

@end

@interface ZoneReplyView : UIView
@property(nonatomic,weak)DynamicCell *replyCell;
@property(nonatomic,weak)UIView *replyLabelView;
@property (weak, nonatomic) IBOutlet UITextField *input;
@property(nonatomic,assign)BOOL isShow;

@property(nonatomic,weak)id<ZoneReplyViewDelegate> delegate;
- (IBAction)press_send:(id)sender;

@end
