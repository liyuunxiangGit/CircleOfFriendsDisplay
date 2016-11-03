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
#import "GetInfoSection.h"
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
    //下方模拟的是数据请求  请求下来数组Info
    NSMutableArray *Info = [GetInfoSection getInfo];
    //将数据传到zoneView(这里传递的数据可以是身份信息，例如id)然后在zoneView中根据该id进行
    if (_zoneView == nil) {
        _zoneView = [[ZoneView alloc]init];
        _zoneView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:_zoneView];
        [_zoneView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
    }
    _zoneView.fVC = self;
    _zoneView.zoneInfo = Info;
}
@end
