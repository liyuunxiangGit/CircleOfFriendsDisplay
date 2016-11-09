//
//  DFVideoPlayController.m
//  MongoIM
//
//  Created by Allen Zhong on 16/2/14.
//  Copyright © 2016年 MongoIM. All rights reserved.
//


#import "DFVideoPreViewController.h"
#import "DQAlertView.h"
#import <AVFoundation/AVFoundation.h>
#import "YBNetWorkInfo.h"

@interface DFVideoPreViewController()

#define SHOWRATE   1
#define Press_Button_Height 80*SHOWRATE
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@property (strong, nonatomic) AVPlayer *player;
@property (nonatomic, strong) UIButton *cancelButton;

@end

@implementation DFVideoPreViewController

- (instancetype)initWithFile:(NSString *) filePath
{
    self = [super init];
    if (self) {
        _filePath = filePath;
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    [self addNotification];
    
    [_player play];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self removeNotification];
    
    [_player pause];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;
    
    self.view.backgroundColor = [UIColor blackColor];
    
    
    //取消按钮
    _cancelButton  = [[UIButton alloc]initWithFrame:CGRectMake(7, 28, 60, 24)];
    [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [_cancelButton addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cancelButton];
    
    NSURL *fileUrl=[NSURL fileURLWithPath:_filePath];
    AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:fileUrl];
    
    _player = [[AVPlayer alloc] initWithPlayerItem:playerItem];
    
    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:_player];
    CGFloat x, y, width, height;
    x=0;
    width = self.view.frame.size.width;
    height = width*0.75;
    y = 64;
    
    layer.frame = CGRectMake(x,y,width,height);
    [self.view.layer addSublayer:layer];
    layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    
    //重拍按钮
    width = Press_Button_Height;
    height = width;
    x = self.view.frame.size.width/4 - width/2;
    if(SCREEN_WIDTH == 320){
        y = CGRectGetMaxY(layer.frame) + 70;
    }else{
        y = CGRectGetMaxY(layer.frame) + 120;
    }
    
    UIButton  *retakeBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    retakeBtn.frame = CGRectMake(x, y, width, height);
    //[retakeBtn setTitle:@"重拍" forState:UIControlStateNormal];
    [retakeBtn setBackgroundColor:[UIColor redColor]];
    [retakeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [retakeBtn setBackgroundImage:[UIImage imageNamed:@"重拍默认"] forState:UIControlStateNormal];
//    [retakeBtn setBackgroundImage:[UIImage imageNamed:@"重拍绿"] forState:UIControlStateHighlighted];
    [retakeBtn setTitle:@"重拍" forState:UIControlStateNormal];
    [retakeBtn setBackgroundImage:[UIImage imageNamed:@"重拍"] forState:UIControlStateHighlighted];
    
    [retakeBtn addTarget:self action:@selector(retakeBtn_click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:retakeBtn];

    //发送按钮
    x = self.view.frame.size.width*3/4 - width/2;
    UIButton  *sendBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    sendBtn.frame = CGRectMake(x, y, width, height);
    //[sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [sendBtn setBackgroundImage:[UIImage imageNamed:@"发送默认"] forState:UIControlStateNormal];
//    [sendBtn setBackgroundImage:[UIImage imageNamed:@"发送绿"] forState:UIControlStateHighlighted];
    [sendBtn setBackgroundColor:[UIColor greenColor]];
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [sendBtn setBackgroundImage:[UIImage imageNamed:@"发送"] forState:UIControlStateHighlighted];
    
    [sendBtn addTarget:self action:@selector(sendBtn_click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendBtn];
    
//    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//    [button addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button];
}
//重拍
-(void)retakeBtn_click:(id)sender{
    
    [self dismissViewControllerAnimated:NO completion:^{
        if(_delegate && [_delegate respondsToSelector:@selector(pressRetakeBtn:)]){
            [_delegate pressRetakeBtn:_filePath];
        }
    }];
    
}
//发送
-(void)sendBtn_click:(id)sender{
    NSString *netType = [YBNetWorkInfo getCurrentUserNetInfo];

    if(![netType isEqualToString:@"wifi"]){//不是wifi环境，提醒用户
        DQAlertView *alertDialog = [[DQAlertView alloc]initWithTitle:nil message:@"非wifi环境下发布，需消耗流量，是否继续发布？"  cancelButtonTitle:@"取消" otherButtonTitle:@"确定"];
        alertDialog.titleHeight = 0;
        alertDialog.messageLabel.font = [UIFont systemFontOfSize:16];
        [alertDialog.cancelButton setTitleColor:UIColorFromRGB(0x32CFAB) forState:UIControlStateNormal];
        [alertDialog.otherButton setTitleColor:UIColorFromRGB(0x32CFAB) forState:UIControlStateNormal];
        [alertDialog actionWithBlocksCancelButtonHandler:^{
        } otherButtonHandler:^{
            
            [self dismissViewControllerAnimated:NO completion:^{
                if(_delegate && [_delegate respondsToSelector:@selector(PressSendBtn:)]){
                    [_delegate PressSendBtn:_filePath];
                }
            }];

        }];
        [alertDialog show];
    }else{//wifi环境，直接发送
        [self dismissViewControllerAnimated:NO completion:^{
            if(_delegate && [_delegate respondsToSelector:@selector(PressSendBtn:)]){
                [_delegate PressSendBtn:_filePath];
            }
        }];
  
    }

    
    
}
-(void) close:(id) sender
{
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
}

-(void)removeNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)playbackFinished:(NSNotification *)notification{
    [_player seekToTime:CMTimeMake(0, 1)];
    [_player play];
}

@end
