//
//  ViewController.m
//  CircleOfFriendsDisplay
//
//  Created by 李云祥 on 16/9/22.
//  Copyright © 2016年 李云祥. All rights reserved.
//

#import "ViewController.h"
#import "ZoneView.h"
#import "Masonry.h"
@interface ViewController ()
@property(nonatomic,strong)ZoneView *zoneView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     [self getZonInfo];

}
-(void)getZonInfo
{
    //这里进行数据请求，并将数据传到zoneView(这里传递的数据可以是身份信息，例如id)然后在zoneView中根据该id进行
    if (_zoneView == nil) {
        _zoneView = [[ZoneView alloc]init];
//        _zoneView.fVC = self;
        _zoneView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:_zoneView];
        [_zoneView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));//60,0,0,0
        }];
    }
    
    _zoneView.zoneInfo = nil;
    
    _zoneView.fVC = self;
    
}
@end
