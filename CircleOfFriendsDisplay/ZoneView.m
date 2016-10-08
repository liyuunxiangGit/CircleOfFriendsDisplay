//
//  ZoneView.m
//  CircleOfFriendsDisplay
//
//  Created by 李云祥 on 16/9/22.
//  Copyright © 2016年 李云祥. All rights reserved.
//

#import "ZoneView.h"
#import "DynamicItem.h"
#import "Masonry.h"
#import "DynamicCell.h"
#import "MJRefresh.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "IDMPhotoBrowser.h"

#define Tag_MyReplySheetShow 0x01
#define Tag_LongPressTextSheetShow 0x02
#define Tag_LongPressPicSheetShow 0x03
#define Tag_CoverViewSheetShow 0x04
#define Tag_LongPressShareUrlShow 0x05
#define Tag_CopyMyReplySheetShow 0x06
@interface ZoneView()<UITableViewDataSource,UITableViewDelegate,DynamicCellDelegate,IDMPhotoBrowserDelegate,LCActionSheetDelegate>

@property(nonatomic,strong)UITableView *zoneTableView;
@property(nonatomic,strong)NSMutableArray *dynamics;
/**
 *  模拟数据
 */
@property(nonatomic,strong)NSArray *fakeDatasource;
@end
@implementation ZoneView

-(void)setZoneInfo:(NSDictionary *)zoneInfo
{
    _zoneInfo = zoneInfo;
    [self setView];
}
-(void)setView
{
    [_dynamics removeAllObjects];
//    [self reflushData];
    
    if (_zoneTableView == nil) {
        _zoneTableView = [[UITableView alloc]init];
        _zoneTableView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_zoneTableView];
        _zoneTableView.delegate = self;
        _zoneTableView.dataSource = self;
        [_zoneTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(0);
            make.left.equalTo(self.mas_left).with.offset(0);
            make.right.equalTo(self.mas_right).with.offset(0);
            make.bottom.equalTo(self.mas_bottom).with.offset(0);
        }];
        [_zoneTableView setNeedsLayout];
        [_zoneTableView setNeedsDisplay];
        [_zoneTableView registerClass:[DynamicCell class]
               forCellReuseIdentifier:@"zoneCell"];
        [self setExtraCellLineHidden:_zoneTableView];
        
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
        [self getList];

    }
}
- (void)getList{
    if (_dynamics == nil) {
        _dynamics = [[NSMutableArray alloc]init];
    }
    
    NSMutableArray *data = [NSMutableArray array];
    for (NSDictionary *dict in self.fakeDatasource) {
        DynamicItem *item = [DynamicItem dynamicWithDict:dict];
        [data addObject:item];
    }
    [_dynamics addObjectsFromArray:data];
}
- (void)dynamicTableViewheaderRereshing{
    [self getNewList];
}
- (void)dynamicTableViewfooterRereshing{
    [self getPreList];
}
- (void)getNewList{
    
//    WEAKSELF;
//    ZoneDynamicListSection *dysection = [[ZoneDynamicListSection alloc]initWithQid:[NSNumber numberWithInteger:m_qId] RefMsgId:[self getMaxId] Rirection:@1 Page:nil PageSize:nil UseCache:NO ResultBlock:^(NSDictionary *dynamic) {
//        NSInteger resultCode = [[dynamic objectForKey:@"resultCode"]integerValue];
//        if (resultCode == 1) {
//            DynamicList *list = [DynamicList objectWithKeyValues:dynamic];
//            [weakSelf addDyListWithArray:list.resultList];
//        }
        [_zoneTableView headerEndRefreshing];
    //    }];
//    [dysection exec];
}
- (void)getPreList{
     [_dynamics addObjectsFromArray:self.dynamics];
//    WEAKSELF;
//    ZoneDynamicListSection *dysection = [[ZoneDynamicListSection alloc]initWithQid:[NSNumber numberWithInteger:m_qId] RefMsgId:[self getMinId] Rirection:@-1 Page:nil PageSize:nil UseCache:YES ResultBlock:^(NSDictionary *dynamic) {
//        NSInteger resultCode = [[dynamic objectForKey:@"resultCode"]integerValue];
//        if (resultCode == 1) {
//            DynamicList *list = [DynamicList objectWithKeyValues:dynamic];
//            [weakSelf addDyListWithArray:list.resultList];
//        }
        [_zoneTableView footerEndRefreshing];
       [_zoneTableView reloadData];

//    }];
//    [dysection exec];
}




#pragma mark - tableviewdelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dynamics.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"zoneCell" forIndexPath:indexPath];
    DynamicItem *item = _dynamics[indexPath.row];
    cell.delegate = self;
    cell.data = item;
    cell.fd_enforceFrameLayout = YES;
    return cell;
}
 
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    DynamicItem *item = [_dynamics objectAtIndex:indexPath.row];
    
    //    NSLog(@"indexpath.row=%d",indexPath.row);
    CGFloat height ;
    @try {
        
       
        height = [tableView fd_heightForCellWithIdentifier:@"zoneCell" cacheByIndexPath:indexPath configuration:^(DynamicCell *cell) {
            //         cell = [[DynamicCell alloc]init];
            cell.fd_enforceFrameLayout = YES;
            cell.data = item;
        }];
        
        //        height = [tableView fd_heightForCellWithIdentifier:@"zoneCell" configuration:^(id cell) {
        ////
        //            DynamicCell * cll =  (DynamicCell *) cell;
        //            cll.fd_enforceFrameLayout = YES;
        //                        cll.dynamicPower = _zoneInfo;
        //                        cll.data = item;
        ////            (DynamicCell *) view = cell;
        //        }];
        
        
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
        //        NSLog(@"%@",exception.description);
        
        height = 150;
    } @finally {
        
    }
    return height+6;
}

- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}
- (void)onPressImageView:(UIImageView *)imageView onDynamicCell:(DynamicCell *)cell{
    DynamicItem *item = cell.data;
    if (item == nil) {
        return;
    }
//    NSMutableArray *imgArray = [NSMutableArray array];
//    [imgArray addObject:item.imgs];
    
    
    NSMutableArray * photoArray = [[NSMutableArray alloc]init];
    for (int i=0; i<[item.imgs count]; i++) {
        NSString * FileUrl = item.imgs[i];
        NSURL * url = [NSURL URLWithString:FileUrl];
        IDMPhoto *photo = [IDMPhoto photoWithURL:url];
         photo.caption = @"you can do it!I think you!";
        [photoArray addObject:photo];
    }
    
    IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc]initWithPhotos:photoArray animatedFromView:imageView];
    browser.doneButtonImage = [UIImage imageNamed:@"图片返回"];
    [browser setInitialPageIndex:imageView.tag];
    browser.delegate = self;
    browser.displayActionButton = YES;
     browser.displayArrowButton = NO;
    browser.displayCounterLabel = YES;
    browser.displayToolbar = YES;

    browser.actionButtonTitles = @[@"转发到聊天",@"转发到公告",@"收藏",@"保存到手机" ];
    [_fVC presentViewController:browser animated:YES completion:nil ];
}
- (void)onLongPressImageView:(UIImageView *)imageView onDynamicCell:(DynamicCell *)cell{
    LCActionSheet *sheet = [LCActionSheet sheetWithTitle:nil buttonTitles:@[@"收藏", @"转发到聊天", @"转发到公告"] redButtonIndex:-1 delegate:self];
    sheet.userObj = imageView;
    sheet.userObj2 = cell;
    sheet.tag = Tag_LongPressPicSheetShow;
    [sheet show];
}

#pragma mark - 图片浏览器代理
-(void)photoBrowser:(IDMPhotoBrowser *)photoBrowser didShowPhotoAtIndex:(NSUInteger)index{
    
}

-(void)photoBrowser:(IDMPhotoBrowser *)photoBrowser didDismissAtPageIndex:(NSUInteger)index{
    
}

-(void)photoBrowser:(IDMPhotoBrowser *)photoBrowser didDismissActionSheetWithButtonIndex:(NSUInteger)buttonIndex photoIndex:(NSUInteger)photoIndex{
    if(buttonIndex == 0){
        //转发到聊天
        //        [photoBrowser dismissViewControllerAnimated:YES completion:^{
        //            [self didsendToChatWithPicIndex:photoIndex];
        
        
        IDMPhoto *photo = (IDMPhoto *)[photoBrowser photoAtIndex:photoIndex];
        
        
        
        //             Msg *dict = item.msg;
//        F_Photo *fowardPic = [[F_Photo alloc]init];
//        fowardPic.url = [NSString stringWithFormat:@"%@",photo.photoURL];
//        fowardPic.PhotoId = [NSString stringWithFormat:@"%@",photo.picId];
//        
//        
//        [FowardCommonClass FowardTo:chat F_data:fowardPic msgType:fowardTypePhoto currentVC:[self viewController] FowardDic:nil];
//        
//        [photoBrowser closeBroswer];
        //        }];
        
    }else if(buttonIndex == 1){
        //转发到公告
        IDMPhoto *photo = (IDMPhoto *)[photoBrowser photoAtIndex:photoIndex];
        
//        [self transToNoticeWithPicId:[photo.picId integerValue] andUrl:[photo.photoURL absoluteString]];
        [photoBrowser closeBroswer];
    }else if(buttonIndex == 2){
        //收藏
//        IDMPhoto *photo = (IDMPhoto *)[photoBrowser photoAtIndex:photoIndex];
//        [self savePicWithPicId:[photo.picId integerValue]];
    }else if(buttonIndex == 3){
        //保存到手机
//        IDMPhoto *photo = (IDMPhoto *)[photoBrowser photoAtIndex:photoIndex];
//        [self didSaveToPhoneWithImage:[photo getImage]];
    }
}

-(void)didSaveToPhoneWithImage:(UIImage *)image{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    });
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
//    if (error) {
//        [_fVC showErrorHubContent:@"保存失败"];
//    } else {
//        [_fVC showSuccessHubContent:@"已成功保存到相册"];
//    }
}














/**
 *  模拟数据
 *
 */
- (NSArray *)fakeDatasource {
    if (_fakeDatasource) {
        return _fakeDatasource;
    }
    _fakeDatasource = @[
                        @{
                            @"name": @"SIZE潮流生活",
                            @"avatar": @"http://tp2.sinaimg.cn/1829483361/50/5753078359/1",
                            @"content": @"近日[心]，adidas Originals为经典鞋款Stan Smith打造Primeknit版本，并带来全新的“OG”系列。简约的鞋身采用白色透气Primeknit针织材质制作，再将Stan Smith代表性的绿、红、深蓝三个元年色调融入到鞋舌和后跟点缀，最后搭载上米白色大底来保留其复古风味。据悉该鞋款将在今月登陆全球各大adidas Originals指定店舖。",
                            @"date": @"1459668442",
                            @"time":@"08/29 10:25",
                            @"imgs": @[@"http://ww2.sinaimg.cn/mw690/6d0bb361gw1f2jim2hgxij20lo0egwgc.jpg",
                                    @"http://ww3.sinaimg.cn/mw690/6d0bb361gw1f2jim2hsg6j20lo0egwg2.jpg",
                                    @"http://ww1.sinaimg.cn/mw690/6d0bb361gw1f2jim2d7nfj20lo0eg40q.jpg",
                                    @"http://ww1.sinaimg.cn/mw690/6d0bb361gw1f2jim2hka3j20lo0egdhw.jpg",
                                    @"http://ww2.sinaimg.cn/mw690/6d0bb361gw1f2jim2hq61j20lo0eg769.jpg"
                                    ],
                            @"statusID": @"1",
                            @"commentList": @[
                                    @{
                                        @"from": @"SIZE潮流生活",
                                        @"to": @"",
                                        @"content": @"使用LWAsyncDisplay来实现图文混排。享受如丝般顺滑的滚动体验。"
                                        },
                                    @{
                                        @"from": @"waynezxcv",
                                        @"to": @"SIZE潮流生活",
                                        @"content": @"哈哈哈哈"
                                        },
                                    @{
                                        @"from": @"SIZE潮流生活",
                                        @"to": @"waynezxcv",
                                        @"content": @"nice~使用LWAsyncDisplayView。支持异步绘制，让滚动如丝般顺滑。并且支持图文混排[心]和点击链接#LWAsyncDisplayView#"
                                        }
                                    ]
                            },
                        @{
                            @"name": @"妖妖小精",
                            @"avatar": @"http://tp2.sinaimg.cn/2185608961/50/5714822219/0",
                            @"content": @"出国留学的儿子为思念自己的家人们寄来一个用自己照片做成的人形立牌",
                            @"date": @"1459668442",
                            @"time":@"08/29 10:25",
                            @"imgs": @[
                                    @"http://ww3.sinaimg.cn/mw690/8245bf01jw1f2jhh2ohanj20jg0yk418.jpg",
                                    @"http://ww4.sinaimg.cn/mw690/8245bf01jw1f2jhh34q9rj20jg0px77y.jpg",
                                    @"http://ww1.sinaimg.cn/mw690/8245bf01jw1f2jhh3grfwj20jg0pxn13.jpg",
                                    @"http://ww4.sinaimg.cn/mw690/8245bf01jw1f2jhh3ttm6j20jg0el76g.jpg",
                                    @"http://ww3.sinaimg.cn/mw690/8245bf01jw1f2jhh43riaj20jg0pxado.jpg",
                                    @"http://ww2.sinaimg.cn/mw690/8245bf01jw1f2jhh4mutgj20jg0ly0xt.jpg",
                                    @"http://ww3.sinaimg.cn/mw690/8245bf01jw1f2jhh4vc7pj20jg0px41m.jpg",
                                    @"http://ww4.sinaimg.cn/mw690/8245bf01jw1f2jhh2mgkgj20jg0pxn2z.jpg"
                                    ],
                            @"statusID": @"2",
                            @"commentList": @[
                                    @{
                                        @"from": @"waynezxcv",
                                        @"to": @"妖妖小精",
                                        @"content": @"[心]"
                                        }
                                    ]
                            },
                        @{
                            @"name": @"Instagram热门",
                            @"avatar": @"http://tp4.sinaimg.cn/5074408479/50/5706839595/0",
                            @"content": @"Austin Butler & Vanessa Hudgens  想试试看扑到一个一米八几的人怀里是有多舒服[心]",
                            @"date": @"1459668442",
                            @"time":@"08/29 10:25",
                            @"imgs": @[
                                    @"http://ww1.sinaimg.cn/mw690/005xpHs3gw1f2jg132p3nj309u0goq62.jpg",
                                    @"http://ww3.sinaimg.cn/mw690/005xpHs3gw1f2jg14per3j30b40ctmzp.jpg",
                                    @"http://ww3.sinaimg.cn/mw690/005xpHs3gw1f2jg14vtjjj30b40b4q5m.jpg",
                                    @"http://ww1.sinaimg.cn/mw690/005xpHs3gw1f2jg15amskj30b40f1408.jpg",
                                    @"http://ww3.sinaimg.cn/mw690/005xpHs3gw1f2jg16f8vnj30b40g4q4q.jpg",
                                    @"http://ww4.sinaimg.cn/mw690/005xpHs3gw1f2jg178dxdj30am0gowgv.jpg",
                                    @"http://ww2.sinaimg.cn/mw690/005xpHs3gw1f2jg17c5urj30b40ghjto.jpg",
                                    @"http://ww4.sinaimg.cn/mw690/005xpHs3gw1f2jg18p02pj30b40fdmz4.jpg"
                                    ],
                            @"statusID": @"3"
                            },
                        @{
                            @"name": @"头条新闻",
                            @"avatar": @"http://tp1.sinaimg.cn/1618051664/50/5735009977/0",
                            @"content": @"#万象# 【熊孩子！4名小学生铁轨上设障碍物逼停火车】4名小学生打赌，1人认为火车会将石头碾成粉末，其余3人不信，认为只会碾碎，于是他们将道碴摆放在铁轨上。火车司机发现前方不远处的铁轨上，摆放了影响行车安全的障碍物，于是紧急采取制动，列车中途停车13分钟。O4名学生铁轨上设障碍物逼停火车",
                            @"date": @"1459668442",
                            @"time":@"08/29 10:25",
                            @"imgs": @[
                                    @"http://ww2.sinaimg.cn/mw690/60718250jw1f2jg46smtmj20go0go77r.jpg"
                                    ],
                            @"statusID": @"4"
                            },
                        @{
                            @"name": @"优酷",
                            @"avatar": @"http://tp2.sinaimg.cn/1642904381/50/5749093752/1",
                            @"content": @"1000杯拿铁，幻化成一生挚爱。两个人，不远万里来相遇、相识、相知，直至相守，小小拿铁却是大大的世界。 L如何用 1000 杯拿铁表达爱",
                            @"date": @"1459668442",
                            @"time":@"08/29 10:25",
                            @"imgs": @[
                                    @"http://ww1.sinaimg.cn/mw690/61ecbb3dgw1f2jfeqmwskg208w04wwvj.gif"
                                    ],
                            @"statusID": @"5"
                            },
                        @{
                            @"name": @"Kindle中国",
                            @"avatar": @"http://tp1.sinaimg.cn/3262223112/50/5684307907/1",
                            @"content": @"#只限今日#《简单的逻辑学》作者D.Q.麦克伦尼在书中提出了28种非逻辑思维形式，抛却了逻辑学一贯的刻板理论，转而以轻松的笔触带领我们畅游这个精彩无比的逻辑世界；《蝴蝶梦》我错了，我曾以为付出自己就是爱你。全球公认20世纪伟大的爱情经典，大陆独家合法授权。",
                            @"date": @"",
                            @"time":@"08/29 10:25",
                            @"imgs": @[
                                    @"http://ww2.sinaimg.cn/mw690/c2719308gw1f2hav54htyj20dj0l00uk.jpg",
                                    @"http://ww4.sinaimg.cn/mw690/c2719308gw1f2hav47jn7j20dj0j341h.jpg"
                                    ],
                            @"statusID": @"6"
                            },
                        @{
                            @"name": @"G-SHOCK",
                            @"avatar": @"http://tp3.sinaimg.cn/1595142730/50/5691224157/1",
                            @"content": @"就算平时没有时间，周末也要带着G-SHOCK到户外走走，感受大自然的满满正能量！",
                            @"date": @"1459668442",
                            @"time":@"08/29 10:25",
                            @"imgs": @[
                                    @"http://ww2.sinaimg.cn/mw690/5f13f24ajw1f2hc1r6j47j20dc0dc0t4.jpg"
                                    ],
                            @"statusID": @"7"
                            },
                        @{
                            @"name": @"型格志style",
                            @"avatar": @"http://tp4.sinaimg.cn/5747171147/50/5741401933/0",
                            @"content": @"春天卫衣的正确打开方式~",
                            @"date": @"1459668442",
                            @"time":@"08/29 10:25",
                            @"imgs": @[
                                    @"http://ww2.sinaimg.cn/mw690/006gWxKPgw1f2jeloxwhnj30fu0g0ta5.jpg",
                                    @"http://ww3.sinaimg.cn/mw690/006gWxKPgw1f2jelpn9bdj30b40gkgmh.jpg",
                                    @"http://ww1.sinaimg.cn/mw690/006gWxKPgw1f2jelriw1bj30fz0g175g.jpg",
                                    @"http://ww3.sinaimg.cn/mw690/006gWxKPgw1f2jelt1kh5j30b10gmt9o.jpg",
                                    @"http://ww4.sinaimg.cn/mw690/006gWxKPgw1f2jeluxjcrj30fw0fz0tx.jpg",
                                    @"http://ww3.sinaimg.cn/mw690/006gWxKPgw1f2jelzxngwj30b20godgn.jpg",
                                    @"http://ww2.sinaimg.cn/mw690/006gWxKPgw1f2jelwmsoej30fx0fywfq.jpg",
                                    @"http://ww4.sinaimg.cn/mw690/006gWxKPgw1f2jem32ccrj30xm0sdwjt.jpg",
                                    @"http://ww4.sinaimg.cn/mw690/006gWxKPgw1f2jelyhutwj30fz0fxwfr.jpg",
                                    
                                    ],
                            @"statusID": @"8"
                            },
                        @{
                            @"name": @"数字尾巴",
                            @"avatar": @"http://tp1.sinaimg.cn/1726544024/50/5630520790/1",
                            @"content": @"外媒 AndroidAuthority 日前曝光诺基亚首款回归作品 NOKIA A1 的渲染图，手机的外形很 N 记，边框控制的不错。这是一款纯正的 Android 机型，传闻手机将采用 5.5 英寸 1080P 屏幕，搭载骁龙 652，Android 6.0 系统，并使用了诺基亚自家的 Z 启动器，不过具体发表的时间还是未知。尾巴们你会期待吗？",
                            @"date": @"1459668442",
                            @"time":@"08/29 10:25",
                            @"imgs": @[
                                    @"http://ww3.sinaimg.cn/mw690/66e8f898gw1f2jck6jnckj20go0fwdhb.jpg"
                                    ],
                            @"statusID": @"9"
                            },
                        @{
                            @"name": @"欧美街拍XOXO",
                            @"avatar": @"http://tp4.sinaimg.cn/1708004923/50/1283204657/0",
                            @"content": @"3.31～4.2 肯豆",
                            @"date": @"1459668442",
                            @"imgs": @[
                                    @"http://ww2.sinaimg.cn/mw690/65ce163bjw1f2jdkd2hgjj20cj0gota8.jpg",
                                    @"http://ww1.sinaimg.cn/mw690/65ce163bjw1f2jdkjdm96j20bt0gota9.jpg",
                                    @"http://ww2.sinaimg.cn/mw690/65ce163bjw1f2jdkvwepij20go0clgnd.jpg",
                                    @"http://ww4.sinaimg.cn/mw690/65ce163bjw1f2jdl2ao77j20ci0gojsw.jpg",
                                    
                                    ],
                            @"statusID": @"10"
                            },
                        
                        ];
    return _fakeDatasource;
}

@end
