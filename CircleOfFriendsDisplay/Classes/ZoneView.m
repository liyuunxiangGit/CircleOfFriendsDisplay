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
#import "ZoneReplyView.h"
#define Tag_MyReplySheetShow 0x01
#define Tag_LongPressTextSheetShow 0x02
#define Tag_LongPressPicSheetShow 0x03
#define Tag_CoverViewSheetShow 0x04
#define Tag_LongPressShareUrlShow 0x05
#define Tag_CopyMyReplySheetShow 0x06

//获取屏幕 宽度、高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
@interface ZoneView()<UITableViewDataSource,UITableViewDelegate,DynamicCellDelegate,IDMPhotoBrowserDelegate,LCActionSheetDelegate,ZoneReplyViewDelegate,UITextFieldDelegate>

@property(nonatomic,strong)UITableView *zoneTableView;
@property(nonatomic,strong)NSMutableArray *dynamics;
@property(nonatomic,strong)ZoneReplyView *replyView;

@end
@implementation ZoneView

-(void)setZoneInfo:(NSArray *)zoneInfo
{
    _zoneInfo = zoneInfo;
    [self setViewWithInfo:zoneInfo];
}
-(void)setViewWithInfo:(NSArray *)fakeDatasource
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
        [self getListWithArray:fakeDatasource];

    }
}
- (void)getListWithArray:(NSArray *)fakeDatasource
{
    if (_dynamics == nil) {
        _dynamics = [[NSMutableArray alloc]init];
    }
    
    NSMutableArray *data = [NSMutableArray array];
    for (NSDictionary *dict in fakeDatasource) {
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
        [photoArray addObject:photo];
    }
    
    IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc]initWithPhotos:photoArray animatedFromView:imageView];
    browser.doneButtonImage = [UIImage imageNamed:@"图片返回"];
    [browser setInitialPageIndex:imageView.tag];
    browser.delegate = self;
    browser.displayActionButton = YES;
    browser.displayArrowButton = NO;
    browser.displayCounterLabel = YES;
//    browser.useWhiteBackgroundColor = YES;
    browser.actionButtonTitles = @[@"转发到聊天",@"转发到公告",@"收藏",@"保存到手机" ];
    [_fVC presentViewController:browser animated:YES completion:nil ];
}
- (void)onLongPressText:(NSString *)text onDynamicCell:(DynamicCell *)cell{
    LCActionSheet *sheet = [LCActionSheet sheetWithTitle:nil buttonTitles:@[@"收藏", @"转发到聊天", @"转发到公告"] redButtonIndex:-1 delegate:self];

    sheet.tag = Tag_LongPressTextSheetShow;
    [sheet show];

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



- (void)showReplyViewWithCell:(DynamicCell *)cell andLabelView:(UIView *)view{
    ZoneReplyView *replyView = [self getReplyView];
    if (_replyView.isShow == YES) {
        [_replyView.input resignFirstResponder];
        _replyView.isShow = NO;
        return;
    }
    CGRect frame = replyView.frame;
    replyView.replyCell = cell;
    replyView.replyLabelView = view;
    
    frame.origin.y = SCREEN_HEIGHT - 46 - 248;
    replyView.frame = frame;
    [self addSubview:replyView];
    [replyView.input becomeFirstResponder];
}
- (ZoneReplyView *)getReplyView{
    if (_replyView == nil) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"ZoneReply" owner:self options:nil];
        _replyView  = [nib objectAtIndex:0];
        _replyView.frame = CGRectMake(0, SCREEN_HEIGHT - 46 - 248, SCREEN_WIDTH, 46);
        _replyView.delegate = self;
        _replyView.input.delegate=self;
        _replyView.isShow = NO;
    }
    return _replyView;
}
#pragma mark - cell委托
- (void)onPressReplyBtnOnDynamicCell:(DynamicCell *)cell{
    [self showReplyViewWithCell:cell andLabelView:nil];
}
#pragma mark - 推送处理

- (void)onReceiveNewDynamic:(NSDictionary *)dic{
    [_zoneTableView headerBeginRefreshing];
}

@end
