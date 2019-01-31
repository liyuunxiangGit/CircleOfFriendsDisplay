//
//  DFVideoPlayController.m

//

#import "DFVideoPlayController.h"
#import <AVFoundation/AVFoundation.h>

#define UIColorFromRGB2(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
@interface DFVideoPlayController()

@property (nonatomic, strong) NSString *filePath;

@property (strong, nonatomic) AVPlayer *player;

@end

@implementation DFVideoPlayController

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
    
    NSURL *fileUrl=[NSURL fileURLWithPath:_filePath];
    AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:fileUrl];
    
    _player = [[AVPlayer alloc] initWithPlayerItem:playerItem];
    
    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:_player];
    CGFloat x, y, width, height;
    x=0;
    width = self.view.frame.size.width;
    height = width*0.75;
    y = (self.view.frame.size.height - height)/2;
    
    layer.frame = CGRectMake(x,y,width,height);
    [self.view.layer addSublayer:layer];
    layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-40, layer.frame.origin.y+height+50, 80, 20)];
    [label setText:@"轻触退出"];
    [label setTextColor:UIColorFromRGB2(153, 153, 153)];
    [label setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:label];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [button addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
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
