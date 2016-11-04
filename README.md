# CircleOfFriendsDisplay
######一直在更新，欢迎star   欢迎提bug以便改进  以便互相进步
#####朋友圈的做法


![展示图](https://github.com/liyuunxiangGit/CircleOfFriendsDisplay/blob/master/动图/111.gif)
####[我的博客](http://blog.csdn.net/liyunxiangrxm)
##运用MVC设计模式
####`MVC` 是苹果公司最热衷的一种架构模式<br>
* `M`: model的缩写  模型层的简称<br>
 * model层用来存放整个工程中需要的所有数据 (实体类的创建、数据的请求、数据持久性存储等操作都是写在model层的)<br>
* `C`: controller的缩写 控制层的简称<br>
 * controller层用来将model上的数据显示在view上（controller层实时监控model上的数据变化 指挥view视图显示model上的数据）<br>
* 【注意】model层和view视图不能直接通信 必须借助controller层<br>
* `V`: view的缩写 视图层的简称<br>
 * view层主要听从controller的指挥显示model层的数据<br>

####app中用到的MVC设计模式详解
* 在ViewController控制其中，我么只做了两件事情
  * 1、通过数据请求的类`GetInfoSection`将数据请求下来保存在数组当中
  * 2、new一个view`ZoneView`并加载在该控制器当中，然后给该view传递数据过去。<br>
  这样就可以做到`隔离数据模型model 和view界面  遵循了低耦合的设计思想`

```
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
    _zoneView.zoneInfo = Info;
}
```

##上下拉刷新功能
* 上下拉刷新用的是MJRefresh 
* [MJRefresh](https://github.com/CoderMJLee/MJRefresh#Support%20what%20kinds%20of%20controls%20to%20refresh) 点击看详情
* ```
  //首页动态的下拉与上拉
        [_zoneTableView addHeaderWithTarget:self action:@selector(dynamicTableViewheaderRereshing) dateKey:@"ClassZonedynamicTableView"];
        [_zoneTableView addFooterWithTarget:self action:@selector(dynamicTableViewfooterRereshing)];
        _zoneTableView.headerPullToRefreshText = @"下拉刷新";
        _zoneTableView.headerReleaseToRefreshText = @"松开刷新";
        _zoneTableView.headerRefreshingText = @"正在加载";
        
        _zoneTableView.footerPullToRefreshText = @"加载更多";
        _zoneTableView.footerReleaseToRefreshText = @"松开加载";
        _zoneTableView.footerRefreshingText = @"加载中";
         _zoneTableView.fd_debugLogEnabled = YES;
*```
* 然后再dynamicTableViewheaderRereshing方法中进行数据请求，最终增加到总得数组中，然后tableView reloadDate.

##消息传递的做法（我用的是推送，个推）
* 做朋友圈当然要进行消息的传递（例如评论，点赞等）
* 我的想法就是当我们评论完成点击发送或者return的时候：
 *  


##   
![欢迎star](https://github.com/liyuunxiangGit/CircleOfFriendsDisplay/blob/master/动图/1708447-5ec5b979baec85ae.gif)
