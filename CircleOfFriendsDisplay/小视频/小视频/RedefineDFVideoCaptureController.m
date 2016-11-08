//
//  RedefineDFVideoCaptureController.m
//  YBT_iOS_tch
//
//  Created by shaveKevin on 16/4/21.
//  Copyright © 2016年 郭顺. All rights reserved.
//

#import "RedefineDFVideoCaptureController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

#import "DFVideoPreViewController.h"

#define SHOWRATE 1
#define Press_Button_Height 120*SHOWRATE
#define Max_Viedo_Length 8
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)

#define Color_Green [UIColor colorWithRed:9/255.0 green:187/255.0 blue:7/255.0 alpha:1.0]
#define Color_Red [UIColor colorWithRed:225/255.0 green:53/255.0 blue:0/255.0 alpha:1.0]

@interface RedefineDFVideoCaptureController()<AVCaptureFileOutputRecordingDelegate>

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureDeviceInput *videoDeviceInput;
@property (nonatomic, strong) AVCaptureDeviceInput *audioDeviceInput;
@property (nonatomic, strong) AVCaptureMovieFileOutput *movieFileOutput;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) UIButton *pressButton;
@property (nonatomic, strong) UIView *timeBar;

@property (nonatomic, strong) UILabel *releaseTipLabel;

@property (nonatomic, strong) UILabel *timeShort;//视频时间太短

@property (strong,nonatomic) NSTimer *timer;

@property (assign, nonatomic) CGFloat length;

@property (assign, nonatomic) BOOL isFinished;

@end

@implementation RedefineDFVideoCaptureController


- (instancetype)init
{
    self = [super init];
    if (self) {
        _length = 0;
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self prepare];
    
    [self initUI];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [_session startRunning];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [_session stopRunning];
}


-(void) initUI
{
    self.view.backgroundColor = [UIColor blackColor];
    
    CGFloat x, y, width, height;
    x = 0;
    y = 64;
    width = self.view.frame.size.width;
    height = width *0.75;
    
    //取消按钮
    _cancelButton  = [[UIButton alloc]initWithFrame:CGRectMake(7, 28, 60, 24)];
    [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [_cancelButton addTarget:self action:@selector(cancel_click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cancelButton];
    
    
    //预览窗口
    _previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_session];
    _previewLayer.frame = CGRectMake(x, y, width, height);
    _previewLayer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    [self.view.layer insertSublayer:_previewLayer atIndex:0];
    
    //时间状态条
    x=0;
    y= CGRectGetMaxY(_previewLayer.frame);
    width = self.view.frame.size.width;
    height = 3;
    _timeBar = [[UIView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    _timeBar.backgroundColor = Color_Green;
    _timeBar.hidden = YES;
    [self.view addSubview:_timeBar];
    
    //提示上移释放label
    width = 80;
    height = 20;
    x = (self.view.frame.size.width - width)/2;
    y = CGRectGetMaxY(_previewLayer.frame) - height - 5;
    _releaseTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
    _releaseTipLabel.backgroundColor = Color_Red;
    _releaseTipLabel.text = @"上移取消";
    _releaseTipLabel.textAlignment = NSTextAlignmentCenter;
    _releaseTipLabel.textColor = [UIColor whiteColor];
    _releaseTipLabel.font = [UIFont systemFontOfSize:13];
    _releaseTipLabel.hidden = YES;
    _releaseTipLabel.layer.cornerRadius = 2;
    _releaseTipLabel.layer.masksToBounds = YES;
    [self.view addSubview:_releaseTipLabel];
    
    
    //按钮
    width = Press_Button_Height;
    height = width;
    x = (self.view.frame.size.width - width)/2;
    if(SCREEN_WIDTH == 320){
        y = CGRectGetMaxY(_previewLayer.frame) + 30;
    }else{
        y = CGRectGetMaxY(_previewLayer.frame) + 60;
    }
    
    _pressButton = [UIButton buttonWithType: UIButtonTypeCustom];
    _pressButton.frame = CGRectMake(x, y, width, height);
    [_pressButton setTitle:@"按住拍" forState:UIControlStateNormal];
    [_pressButton setTitleColor:Color_Green forState:UIControlStateNormal];
    [_pressButton setBackgroundImage:[UIImage imageNamed:@"绿圈"] forState:UIControlStateNormal];
    [_pressButton addTarget:self action:@selector(onVoiceButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [_pressButton addTarget:self action:@selector(btnDragged:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [_pressButton addTarget:self action:@selector(btnDragged:withEvent:) forControlEvents:UIControlEventTouchDragOutside];
    [_pressButton addTarget:self action:@selector(btnTouchUp:withEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_pressButton addTarget:self action:@selector(btnTouchUp:withEvent:) forControlEvents:UIControlEventTouchUpOutside];
    [self.view addSubview:_pressButton];
    
    
    //录制时间太短label
    width = 80;
    height = 20;
    x = (self.view.frame.size.width - width)/2;
    y = CGRectGetMaxY(_previewLayer.frame) +20;
    _timeShort = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
    _timeShort.backgroundColor = Color_Red;
    _timeShort.text = @"录制时间太短";
    _timeShort.textAlignment = NSTextAlignmentCenter;
    _timeShort.textColor = [UIColor whiteColor];
    _timeShort.font = [UIFont systemFontOfSize:13];
    _timeShort.hidden = YES;
    _timeShort.layer.cornerRadius = 2;
    _timeShort.layer.masksToBounds = YES;
    [self.view addSubview:_timeShort];
    
    
    
}
-(void)cancel_click{
    
   
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
-(void) prepare
{
    _session = [[AVCaptureSession alloc] init];
    if ([_session canSetSessionPreset:AVCaptureSessionPreset640x480]) {
        _session.sessionPreset = AVCaptureSessionPreset640x480;
    }
    
    AVCaptureDevice *videoDeivice = [self getCameraDeviceWithPosition:AVCaptureDevicePositionBack];
    
    NSError *error = nil;
    _videoDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:videoDeivice error: &error];
    
    if (error) {
        NSLog(@"添加Video设备异常");
    }
    
    
    if ([_session canAddInput:_videoDeviceInput]) {
        [_session addInput:_videoDeviceInput];
    }
    
    
    AVCaptureDevice *audioDevice = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio] firstObject];
    _audioDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:audioDevice error:&error];
    if (error) {
        NSLog(@"添加Audio设备异常");
    }
    
    
    if ([_session canAddInput:_audioDeviceInput]) {
        [_session addInput:_audioDeviceInput];
    }
    
    
    _movieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
    
    
    if ([_session canAddOutput:_movieFileOutput]) {
        [_session addOutput:_movieFileOutput];
    }
}

-(AVCaptureDevice *)getCameraDeviceWithPosition:(AVCaptureDevicePosition )position{
    NSArray *cameras= [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *camera in cameras) {
        if ([camera position]==position) {
            return camera;
        }
    }
    return nil;
}




#pragma mark - Button Action

- (void)btnDragged:(UIButton *)sender withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGFloat boundsExtension = 5.0f;
    CGRect outerBounds = CGRectInset(sender.bounds, -1 * boundsExtension, -1 * boundsExtension);
    BOOL touchOutside = !CGRectContainsPoint(outerBounds, [touch locationInView:sender]);
    if (touchOutside) {
        BOOL previewTouchInside = CGRectContainsPoint(outerBounds, [touch previousLocationInView:sender]);
        if (previewTouchInside) {
            NSLog(@"移出区域");
            // UIControlEventTouchDragExit
            
            _timeBar.backgroundColor = Color_Red;
            _releaseTipLabel.hidden = NO;
            [_releaseTipLabel setText:@"松开取消"];

        } else {
            // UIControlEventTouchDragOutside
            
        }
    } else {
        BOOL previewTouchOutside = !CGRectContainsPoint(outerBounds, [touch previousLocationInView:sender]);
        if (previewTouchOutside) {
            // UIControlEventTouchDragEnter
            NSLog(@"移入区域");
            [_releaseTipLabel setText:@"上移取消"];
            _timeBar.backgroundColor = Color_Green;
            _releaseTipLabel.hidden = NO;
        } else {
            // UIControlEventTouchDragInside
        }
    }
}




- (void)btnTouchUp:(UIButton *)sender withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGFloat boundsExtension = 5.0f;
    CGRect outerBounds = CGRectInset(sender.bounds, -1 * boundsExtension, -1 * boundsExtension);
    BOOL touchOutside = !CGRectContainsPoint(outerBounds, [touch locationInView:sender]);
    if (touchOutside) {
        // UIControlEventTouchUpOutside
        [self onVoiceButtonTouchUpOutside];
    } else {
        // UIControlEventTouchUpInside
        [self onVoiceButtonTouchUpInside];
    }
}


-(void) onVoiceButtonTouchDown:(UIButton *) button
{
    NSLog(@"按下拍摄按钮");
    _length = 0;
    _isFinished = NO;
    
    [self hidePressButton];
    [self changeTimeBarwidth:1.0];
    _timeBar.hidden = NO;
    _timeBar.backgroundColor = Color_Green;
    [_releaseTipLabel setText:@"上移取消"];
    _releaseTipLabel.hidden = NO;
    
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(onCapture:) userInfo:nil repeats:YES];
    }
    
    [self startCapture];
    
}

-(void) onVoiceButtonTouchUpOutside
{
    NSLog(@"从外部释放");
    if (_length >= Max_Viedo_Length) {
        return;
    }
    
    //取消拍摄
    [self stopCapture];
}



-(void) onVoiceButtonTouchUpInside
{
    NSLog(@"从内部释放");
    if (_length >= Max_Viedo_Length) {
        return;
    }
    
    //完成拍摄
    [self stopCapture];
    
    if (_length > 1.0) {
        _isFinished = YES;
    }
}


#pragma mark - Method


-(void) hidePressButton
{
    [UIView animateWithDuration:0.5 animations:^{
        CGFloat x, y, width, height;
        width = Press_Button_Height *1.5;
        height = width;
        x = _pressButton.center.x - width/2;
        y = _pressButton.center.y - height/2;
        _pressButton.frame = CGRectMake(x, y, width, height);
        _pressButton.alpha = 0.0;
    }];
    
}

-(void) showPressButton
{
    CGFloat x, y, width, height;
    width = Press_Button_Height;
    height = width;
    x = (self.view.frame.size.width - width)/2;
    y = CGRectGetMaxY(_previewLayer.frame) + 60;
    _pressButton.frame = CGRectMake(x, y, width, height);
    _pressButton.alpha = 1.0;
}

-(void) changeTimeBarwidth:(CGFloat)rate
{
    CGFloat x, y, width, height;
    y=_timeBar.frame.origin.y;
    height = _timeBar.frame.size.height;
    width = self.view.frame.size.width * (1-rate);
    x= (self.view.frame.size.width - width)/2;
    _timeBar.frame = CGRectMake(x, y, width, height);
    
}

-(void) onCapture:(NSTimer *) timer
{
    _length = timer.timeInterval + _length;
    
    [self changeTimeBarwidth:_length/Max_Viedo_Length];
    
    if (_length >= Max_Viedo_Length) {
        NSLog(@"时间到 完成拍摄");
        
        [self stopCapture];
        _isFinished = YES;
        
        return;
    }
    
}

-(void) restore
{
    NSLog(@"恢复现场");
    [self showPressButton];
    _timeBar.hidden = YES;
    
    _releaseTipLabel.hidden = YES;
    [self stopTimer];
}

-(void) stopTimer
{
    [_timer invalidate];
    _timer = nil;
}


#pragma mark - Capture

-(void) startCapture
{
    AVCaptureConnection *captureConnection=[_movieFileOutput connectionWithMediaType:AVMediaTypeVideo];
    if ([captureConnection isVideoStabilizationSupported ]) {
        captureConnection.preferredVideoStabilizationMode=AVCaptureVideoStabilizationModeAuto;
    }
    
    if (![_movieFileOutput isRecording]) {
        captureConnection.videoOrientation=[_previewLayer connection].videoOrientation;
        NSString *filePath=[NSTemporaryDirectory() stringByAppendingString:@"temp.mov"];
        NSURL *url=[NSURL fileURLWithPath:filePath];
        [_movieFileOutput startRecordingToOutputFileURL:url recordingDelegate:self];
    }
    
}

-(void) stopCapture
{
    [self restore];
    
    if ([_movieFileOutput isRecording]) {
        [_movieFileOutput stopRecording];
    }
}

-(void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections
{
    NSLog(@"开始录制");
}

-(void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error
{
    NSLog(@"结束录制");
    
    NSLog(@"文件路径: %@", outputFileURL);
    
    NSData *data = [NSData dataWithContentsOfURL:outputFileURL];
    NSLog(@"文件大小: %luk", (unsigned long)([data length]/1024));
    
    if (_isFinished) {
        NSLog(@"开始处理视频");
        NSString *filename= [NSString stringWithFormat:@"%d.mp4", (int)[NSDate timeIntervalSinceReferenceDate]];
        NSString *scaledFilePath=[NSTemporaryDirectory() stringByAppendingString:filename];
        [self scaleAndPress:outputFileURL savePath:scaledFilePath];
    }else if(_length < 1.0){//录制时间小于1秒
        [_timeShort setHidden:NO];
        [self performSelector:@selector(timeShortHide) withObject:nil afterDelay:1.0f];
    }else{//正常取消
       NSLog(@"不用处理视频");
    }
}
-(void)timeShortHide{
    [_timeShort setHidden:YES];
}

-(void) scaleAndPress:(NSURL *) url savePath:(NSString *) savePath
{

    AVAsset *asset = [AVAsset assetWithURL:url];
    AVAssetTrack *clipVideoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    AVMutableVideoComposition* videoComposition = [AVMutableVideoComposition videoComposition];
    videoComposition.frameDuration = CMTimeMake(1, 30);
    
    //CGRect rect = CGRectMake(64, 0, clipVideoTrack.naturalSize.height, clipVideoTrack.naturalSize.height);
    
    CGFloat newHeight = clipVideoTrack.naturalSize.height*4/3;
    
    videoComposition.renderSize = CGSizeMake(clipVideoTrack.naturalSize.height,newHeight);
    
    AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    instruction.timeRange = CMTimeRangeMake(kCMTimeZero, asset.duration);
    
    AVMutableVideoCompositionLayerInstruction *layerInstruction = [AVMutableVideoCompositionLayerInstruction
                                                                   videoCompositionLayerInstructionWithAssetTrack:clipVideoTrack];
    
    //[layerInstruction setCropRectangle:rect atTime:kCMTimeZero];
    
//    CGAffineTransform rotationTransform = CGAffineTransformMakeRotation(M_PI*0.5);
//    CGAffineTransform rotateTranslate = CGAffineTransformTranslate(rotationTransform,0, -rect.size.width);
    
    //[layerInstruction setTransform:rotateTranslate atTime:kCMTimeZero];
    [layerInstruction setTransform:clipVideoTrack.preferredTransform atTime:kCMTimeZero];
    
    instruction.layerInstructions = [NSArray arrayWithObject:layerInstruction];
    videoComposition.instructions = [NSArray arrayWithObject: instruction];
    
    AVAssetExportSession *avAssetExportSession = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetMediumQuality];
    [avAssetExportSession setVideoComposition:videoComposition];
    [avAssetExportSession setOutputURL:[NSURL fileURLWithPath:savePath]];
    //[avAssetExportSession setOutputFileType:AVFileTypeQuickTimeMovie];
    [avAssetExportSession setOutputFileType:AVFileTypeMPEG4];
    [avAssetExportSession setShouldOptimizeForNetworkUse:YES];
    [avAssetExportSession exportAsynchronouslyWithCompletionHandler:^(void){
        switch (avAssetExportSession.status) {
            case AVAssetExportSessionStatusFailed:
                NSLog(@"处理失败 %@",[avAssetExportSession error]);
                break;
            case AVAssetExportSessionStatusCompleted:
                NSLog(@"处理成功");
                
                [self handleViedo:savePath];
                
                break;
            case AVAssetExportSessionStatusCancelled:
                NSLog(@"处理取消");
                break;
            default:
                break;
        }
    }];
}


-(void) handleViedo:(NSString *) filePath
{
    //开始截图
    NSData *data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:filePath]];
    NSLog(@"处理后文件大小: %luk", (unsigned long)([data length]/1024));
    
    
    UIImage *screenShot = [self generateScreenshot:[NSURL fileURLWithPath:filePath]];
    
    if (_delegate && [_delegate respondsToSelector:@selector(onCaptureVideo:screenShot:)]) {
        [self dismissViewControllerAnimated:NO completion:^{
            [_delegate onCaptureVideo:filePath screenShot:screenShot];
            
        }];
    }else{
        [self onCaptureVideo:filePath screenShot:screenShot];
        //李云祥   2016-11-2  用于测试
        DFVideoPreViewController *mv = [[DFVideoPreViewController alloc]init];
        mv.filePath = filePath;
    [self presentViewController:mv animated:YES completion:nil];
    }
    
}


-(void)onCaptureVideo:(NSString *)filePath screenShot:(UIImage *)screenShot
{
    NSLog(@"系统默认回调");
    DFVideoPreViewController *mv = [[DFVideoPreViewController alloc]init];
    mv.filePath = filePath;
    [self presentViewController:mv animated:YES completion:nil];

}

-(UIImage *) generateScreenshot:(NSURL *) url
{
    AVURLAsset *urlAsset=[AVURLAsset assetWithURL:url];
    AVAssetImageGenerator *imageGenerator=[AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
    
    NSError *error=nil;
    CMTime time=CMTimeMakeWithSeconds(1, 10);
    CMTime actualTime;
    CGImageRef cgImage= [imageGenerator copyCGImageAtTime:time actualTime:&actualTime error:&error];
    if(error){
        NSLog(@"截取视频缩略图时发生错误，错误信息：%@",error.localizedDescription);
        return nil;
    }
    CMTimeShow(actualTime);
    UIImage *image=[UIImage imageWithCGImage:cgImage];
    //保存到相册
    //UIImageWriteToSavedPhotosAlbum(image,nil, nil, nil);
    CGImageRelease(cgImage);
    
    return image;
}



@end
