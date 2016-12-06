//
//  DynamicCell.h
//  CircleOfFriendsDisplay
//
//  Created by 李云祥 on 16/9/22.
//  Copyright © 2016年 李云祥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DynamicItem.h"
#import "UIImageView+WebCache.h"

@class DynamicCell;
@protocol DynamicCellDelegate <NSObject>

- (void)onPressZanBtnOnDynamicCell:(DynamicCell *)cell;
- (void)onPressReplyBtnOnDynamicCell:(DynamicCell *)cell;
//- (void)onLongPressReplyBtnOnDynamicCell:(DynamicCell *)cell;
- (void)onPressReplyLabelView:(UIView *)view onDynamicCell:(DynamicCell *)cell;
- (void)onLongPressReplyLabelView:(UIView *)view onDynamicCell:(DynamicCell *)cell;
- (void)onPressDeleteBtnOnDynamicCell:(DynamicCell *)cell;
- (void)onPressImageView:(UIImageView *)imageView onDynamicCell:(DynamicCell *)cell;
- (void)onPressUrlOnDynamicCell:(DynamicCell *)cell;

- (void)onPressMoreBtnOnDynamicCell:(DynamicCell *)cell;
- (void)onLongPressText:(NSString *)text onDynamicCell:(DynamicCell *)cell;
- (void)onLongPressImageView:(UIImageView *)imageView onDynamicCell:(DynamicCell *)cell;
- (void)onLongPressShareUrlOnDynamicCell:(DynamicCell *)cell;
- (void)onPressShareUrlOnUrl:(NSURL *)url;
- (void)onPressReSendOnDynamicCell:(DynamicCell *)cell;

@end



@interface DynamicCell : UITableViewCell
@property(nonatomic,strong)UIImageView *headView;
@property(nonatomic,strong)UIButton *deleteBtn;
@property(nonatomic,strong)UIView *bodyView;
@property(nonatomic,strong)UIView *zanBarView;
@property(nonatomic,strong)UIView *footView;
@property(nonatomic,strong)UILabel *fromName;
@property(nonatomic,strong)DynamicItem *data;

@property(nonatomic,strong)UIImageView *zanBtn;
@property(nonatomic,strong)UIImageView *replyBtn;
@property(nonatomic,strong)NSDictionary *dynamicPower;

@property(nonatomic,weak)id<DynamicCellDelegate> delegate;
@property(nonatomic,strong)NSMutableArray *imgArray;
@property(nonatomic,strong)NSMutableArray *imgViewArray;
@end
