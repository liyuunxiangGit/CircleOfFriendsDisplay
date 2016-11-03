//
//  ZoneView.h
//  CircleOfFriendsDisplay
//
//  Created by 李云祥 on 16/9/22.
//  Copyright © 2016年 李云祥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
@protocol ZoneViewDelegate <NSObject>

- (void)onPressSend;

@end
@interface ZoneView : UIView
@property(nonatomic,strong)NSArray *zoneInfo;
@property(nonatomic,assign)BOOL canSendNotice;
@property(nonatomic,weak)UIViewController *fVC;
@property(nonatomic,weak)id<ZoneViewDelegate> delegate;

- (void)onReceiveNewDynamic:(NSDictionary *)dic;
- (void)onReceiveZan:(NSDictionary *)dic;
- (void)onReceiveReply:(NSDictionary *)dic;
- (void)setCoverByCoverId:(NSNumber *)coverId;
- (void)deleteDynamicByMsgId:(NSNumber *)msgId;
- (void)deleteZanByMsgId:(NSInteger)msgId ZanId:(NSInteger)zanId;
- (void)deleteReplyByMsgId:(NSInteger)msgId ReplyId:(NSInteger)reply;
@end
