//
//  Created by 刘超 on 15/4/26.
//  Copyright (c) 2015年 Leo. All rights reserved.
//
//  Email:  leoios@sina.com
//  GitHub: http://github.com/LeoiOS
//  如有问题或建议请给我发Email, 或在该项目的GitHub主页lssues我, 谢谢:)
//

#import "LCActionSheet.h"

// 按钮高度
#define BUTTON_H 49.0f
// 屏幕尺寸
#define SCREEN_SIZE [UIScreen mainScreen].bounds.size
// 颜色
#define LCColor(r, g, b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0f]

@interface LCActionSheet () {
    
    /** 所有按钮 */
    NSArray *_buttonTitles;
    
    /** 暗黑色的view */
    UIView *_darkView;
    
    /** 所有按钮的底部view */
    UIView *_bottomView;
    
    /** 代理 */
    id<LCActionSheetDelegate> _delegate;
}

@property (nonatomic, strong) UIWindow *backWindow;


@end

@implementation LCActionSheet

+ (instancetype)sheetWithTitle:(NSString *)title buttonTitles:(NSArray *)titles redButtonIndex:(NSInteger)buttonIndex delegate:(id<LCActionSheetDelegate>)delegate {
    
    return [[self alloc] initWithTitle:title buttonTitles:titles redButtonIndex:buttonIndex delegate:delegate];
}

// 下方方法是做类似于系统样式的actionSheet

//- (instancetype)initWithTitle:(NSString *)title
//                 buttonTitles:(NSArray *)titles
//               redButtonIndex:(NSInteger)buttonIndex
//                     delegate:(id<LCActionSheetDelegate>)delegate {
//    
//    if (self = [super init]) {
//        
//        _delegate = delegate;
//        
//        // 暗黑色的view
//        UIView *darkView = [[UIView alloc] init];
//        [darkView setAlpha:0];
//        [darkView setUserInteractionEnabled:NO];
//        [darkView setFrame:(CGRect){0, 0, SCREEN_SIZE}];
//        [darkView setBackgroundColor:LCColor(46, 49, 50)];
//        [self addSubview:darkView];
//        _darkView = darkView;
//        
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss:)];
//        [darkView addGestureRecognizer:tap];
//        
//        // 所有按钮的底部view
//        UIView *bottomView = [[UIView alloc] init];
//        [bottomView setBackgroundColor:[UIColor clearColor]];
//        //[bottomView setBackgroundColor:LCColor(233, 233, 238)];
//        [self addSubview:bottomView];
//        _bottomView = bottomView;
//        
//        if (title) {
//            
//            // 标题
//            UILabel *label = [[UILabel alloc] init];
//            [label setText:title];
//            [label setTextColor:LCColor(111, 111, 111)];
//            [label setTextAlignment:NSTextAlignmentCenter];
//            [label setFont:[UIFont systemFontOfSize:13.0f]];
//            [label setBackgroundColor:[UIColor whiteColor]];
//            [label setFrame:CGRectMake(0, 0, SCREEN_SIZE.width-40, BUTTON_H)];
//            [bottomView addSubview:label];
//        }
//        //增加的代码
//        UIView *whiteBottom = [[UIView alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, BUTTON_H*titles.count-10)];
//        whiteBottom.backgroundColor = [UIColor whiteColor];
//        whiteBottom.layer.cornerRadius = 10;
//        whiteBottom.clipsToBounds = YES;
//        [bottomView addSubview:whiteBottom];
//
//        if (titles.count) {
//            
//            _buttonTitles = titles;
//            
//            for (int i = 0; i < titles.count; i++) {
//                
//                // 所有按钮
//                UIButton *btn = [[UIButton alloc] init];
//                [btn setTag:i];
//                [btn setBackgroundColor:[UIColor whiteColor]];
//                [btn setTitle:titles[i] forState:UIControlStateNormal];
//              //  [btn setTintColor:UIColorFromRGB2(50, 124, 248)];
//                [[btn titleLabel] setFont:[UIFont italicSystemFontOfSize:20.0]];
//               // [[btn titleLabel] setFont:[UIFont systemFontOfSize:19.0f]];
//                btn.layer.cornerRadius = 10;
//                btn.clipsToBounds = YES;
//                
//                UIColor *titleColor = nil;
//                if (i == buttonIndex) {
//                    
//                    titleColor = LCColor(50, 124, 248);
//                    //titleColor = UIColorFromRGB(333333);
//                    
//                } else {
//                    titleColor = LCColor(50, 124, 248);
//                    //titleColor = [UIColor blackColor] ;
//                }
//                [btn setTitleColor:titleColor forState:UIControlStateNormal];
//                
//                [btn setBackgroundImage:[UIImage imageNamed:@"bgImage_HL"] forState:UIControlStateHighlighted];
//                [btn addTarget:self action:@selector(didClickBtn:) forControlEvents:UIControlEventTouchUpInside];
//                
//                CGFloat btnY = BUTTON_H * (i + (title ? 1 : 0));
//                [btn setFrame:CGRectMake(10, btnY-10, SCREEN_SIZE.width-20, BUTTON_H)];
//                
//                [bottomView addSubview:btn];
//            }
//            
//            
//            //增加的内容
////            UIButton *buttn = [[UIButton alloc]init];
////            [buttn setTag:titles.count];
////            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:buttn.bounds byRoundingCorners:UIRectCornerTopLeft || UIRectCornerTopRight cornerRadii:CGSizeMake(10,10)];
////            
////            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
////            
////            maskLayer.frame = buttn.bounds;
////            
////            maskLayer.path = maskPath.CGPath;
////            
////            buttn.layer.mask = maskLayer;
//            
//            //线条<增加的内容>
//            for (int j = 0; j<titles.count-1; j++) {
//                UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10, BUTTON_H - 10+j*BUTTON_H, SCREEN_WIDTH - 20, 1.0f)];
//                [lineView setContentMode:UIViewContentModeCenter];
//                lineView.backgroundColor = UIColorFromRGB2(246, 246, 246);
//                //lineView.backgroundColor = [UIColor lightGrayColor];
//                [bottomView addSubview:lineView];
//
//            }
//            
//            
//            
//            
//            for (int i = 0; i < titles.count; i++) {
//                
//                // 所有线条
//                UIImageView *line = [[UIImageView alloc] init];
//                [line setImage:[UIImage imageNamed:@"cellLine"]];
//                [line setContentMode:UIViewContentModeCenter];
//                CGFloat lineY = (i + (title ? 1 : 0)) * BUTTON_H;
//                [line setFrame:CGRectMake(0, BUTTON_H-10, SCREEN_SIZE.width-200, 1.0f)];
//                //[bottomView addSubview:line];
//            }
//        }
//        
//        // 取消按钮
//        UIButton *cancelBtn = [[UIButton alloc] init];
//        cancelBtn.layer.cornerRadius = 10;
//        cancelBtn.clipsToBounds = YES;
//        [cancelBtn setTag:titles.count];
//        [cancelBtn setBackgroundColor:[UIColor whiteColor]];
//        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
//        //[[cancelBtn titleLabel] setFont:[UIFont systemFontOfSize:18.0f]];
//        [[cancelBtn titleLabel] setFont:[UIFont fontWithName:@"Helvetica-Bold" size:19.0f]];
//        [cancelBtn setTitleColor:LCColor(50, 124, 248) forState:UIControlStateNormal];
//        [cancelBtn setBackgroundImage:[UIImage imageNamed:@"bgImage_HL"] forState:UIControlStateHighlighted];
//        [cancelBtn addTarget:self action:@selector(didClickCancelBtn) forControlEvents:UIControlEventTouchUpInside];
//        
//        CGFloat btnY = BUTTON_H * (titles.count + (title ? 1 : 0)) + 5.0f;
//        [cancelBtn setFrame:CGRectMake(10, btnY-10, SCREEN_SIZE.width-20, BUTTON_H)];
//        [bottomView addSubview:cancelBtn];
//        
//        CGFloat bottomH = (title ? BUTTON_H : 0) + BUTTON_H * titles.count + BUTTON_H + 5.0f;
//        [bottomView setFrame:CGRectMake(0, SCREEN_SIZE.height, SCREEN_SIZE.width, bottomH)];
//        
//        [self setFrame:(CGRect){0, 0, SCREEN_SIZE}];
//        [self.backWindow addSubview:self];
//    }
//    
//    return self;
//}

    //三方库自己的旧版本
- (instancetype)initWithTitle:(NSString *)title
                 buttonTitles:(NSArray *)titles
               redButtonIndex:(NSInteger)buttonIndex
                     delegate:(id<LCActionSheetDelegate>)delegate {
    
    if (self = [super init]) {
        
        _delegate = delegate;
        
        // 暗黑色的view
        UIView *darkView = [[UIView alloc] init];
        [darkView setAlpha:0];
        [darkView setUserInteractionEnabled:NO];
        [darkView setFrame:(CGRect){0, 0, SCREEN_SIZE}];
        [darkView setBackgroundColor:LCColor(46, 49, 50)];
        [self addSubview:darkView];
        _darkView = darkView;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss:)];
        [darkView addGestureRecognizer:tap];
        
        // 所有按钮的底部view
        UIView *bottomView = [[UIView alloc] init];
        [bottomView setBackgroundColor:LCColor(233, 233, 238)];
        [self addSubview:bottomView];
        _bottomView = bottomView;
        
        if (title) {
            
            // 标题
            UILabel *label = [[UILabel alloc] init];
            [label setText:title];
            [label setTextColor:LCColor(111, 111, 111)];
            [label setTextAlignment:NSTextAlignmentCenter];
            [label setFont:[UIFont systemFontOfSize:13.0f]];
            [label setBackgroundColor:[UIColor whiteColor]];
            [label setFrame:CGRectMake(0, 0, SCREEN_SIZE.width, BUTTON_H)];
            [bottomView addSubview:label];
        }
        
        if (titles.count) {
            
            _buttonTitles = titles;
            
            for (int i = 0; i < titles.count; i++) {
                
                // 所有按钮
                UIButton *btn = [[UIButton alloc] init];
                [btn setTag:i];
                [btn setBackgroundColor:[UIColor whiteColor]];
                [btn setTitle:titles[i] forState:UIControlStateNormal];
                [[btn titleLabel] setFont:[UIFont systemFontOfSize:16.0f]];
                
                UIColor *titleColor = nil;
                if (i == buttonIndex) {
                    
                    titleColor = LCColor(255, 10, 10);
                    
                } else {
                    
                    titleColor = [UIColor blackColor] ;
                }
                [btn setTitleColor:titleColor forState:UIControlStateNormal];
                
                [btn setBackgroundImage:[UIImage imageNamed:@"bgImage_HL"] forState:UIControlStateHighlighted];
                [btn addTarget:self action:@selector(didClickBtn:) forControlEvents:UIControlEventTouchUpInside];
                
                CGFloat btnY = BUTTON_H * (i + (title ? 1 : 0));
                [btn setFrame:CGRectMake(0, btnY, SCREEN_SIZE.width, BUTTON_H)];
                [bottomView addSubview:btn];
            }
            
            for (int i = 0; i < titles.count; i++) {
                
                // 所有线条
                UIImageView *line = [[UIImageView alloc] init];
                [line setImage:[UIImage imageNamed:@"cellLine"]];
                [line setContentMode:UIViewContentModeCenter];
                CGFloat lineY = (i + (title ? 1 : 0)) * BUTTON_H;
                [line setFrame:CGRectMake(0, lineY, SCREEN_SIZE.width, 1.0f)];
                [bottomView addSubview:line];
            }
        }
        
        // 取消按钮
        UIButton *cancelBtn = [[UIButton alloc] init];
        [cancelBtn setTag:titles.count];
        [cancelBtn setBackgroundColor:[UIColor whiteColor]];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [[cancelBtn titleLabel] setFont:[UIFont systemFontOfSize:16.0f]];
        [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cancelBtn setBackgroundImage:[UIImage imageNamed:@"bgImage_HL"] forState:UIControlStateHighlighted];
        [cancelBtn addTarget:self action:@selector(didClickCancelBtn) forControlEvents:UIControlEventTouchUpInside];
        
        CGFloat btnY = BUTTON_H * (titles.count + (title ? 1 : 0)) + 5.0f;
        [cancelBtn setFrame:CGRectMake(0, btnY, SCREEN_SIZE.width, BUTTON_H)];
        [bottomView addSubview:cancelBtn];
        
        CGFloat bottomH = (title ? BUTTON_H : 0) + BUTTON_H * titles.count + BUTTON_H + 5.0f;
        [bottomView setFrame:CGRectMake(0, SCREEN_SIZE.height, SCREEN_SIZE.width, bottomH)];
        
        [self setFrame:(CGRect){0, 0, SCREEN_SIZE}];
        [self.backWindow addSubview:self];
    }
    
    return self;
}

- (UIWindow *)backWindow {
    
    if (_backWindow == nil) {
        
        _backWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _backWindow.windowLevel       = UIWindowLevelStatusBar;
        _backWindow.backgroundColor   = [UIColor clearColor];
        _backWindow.hidden = NO;
    }
    
    return _backWindow;
}


- (void)didClickBtn:(UIButton *)btn {
    
    [self dismiss:nil];
    
    if ([_delegate respondsToSelector:@selector(actionSheet:didClickedButtonAtIndex:)]) {
        
        [_delegate actionSheet:self didClickedButtonAtIndex:btn.tag];
    }
}

- (void)dismiss:(UITapGestureRecognizer *)tap {
    
    [UIView animateWithDuration:0.3f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         [_darkView setAlpha:0];
                         [_darkView setUserInteractionEnabled:NO];
                         
                         CGRect frame = _bottomView.frame;
                         frame.origin.y += frame.size.height;
                         [_bottomView setFrame:frame];
                         
                     }
                     completion:^(BOOL finished) {
                         
                         _backWindow.hidden = YES;
                         
                         [self removeFromSuperview];
                     }];
}

- (void)didClickCancelBtn {
    
    [UIView animateWithDuration:0.3f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         [_darkView setAlpha:0];
                         [_darkView setUserInteractionEnabled:NO];
                         
                         CGRect frame = _bottomView.frame;
                         frame.origin.y += frame.size.height;
                         [_bottomView setFrame:frame];
                         
                     }
                     completion:^(BOOL finished) {
                         
                         _backWindow.hidden = YES;
                         
                         [self removeFromSuperview];
                         
                         if ([_delegate respondsToSelector:@selector(actionSheet:didClickedButtonAtIndex:)]) {
                             
                             [_delegate actionSheet:self didClickedButtonAtIndex:_buttonTitles.count];
                         }
                     }];
}

- (void)show {
    
    _backWindow.hidden = NO;
    
    [UIView animateWithDuration:0.3f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         [_darkView setAlpha:0.4f];
                         [_darkView setUserInteractionEnabled:YES];
                         
                         CGRect frame = _bottomView.frame;
                         frame.origin.y -= frame.size.height;
                         [_bottomView setFrame:frame];
                         
                     }
                     completion:nil];
}

@end
