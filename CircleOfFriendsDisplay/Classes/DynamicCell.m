//
//  DynamicCell.m
//  CircleOfFriendsDisplay

//

#import "DynamicCell.h"
#import "TTTAttributedLabel.h"
#import "Masonry.h"
#import "WebViewController.h"
//获取屏幕 宽度、高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define kPicDiv 4.0f

@interface DynamicCell()<TTTAttributedLabelDelegate>
@property (strong,nonatomic) UIButton * moreBtn;
@end
@implementation DynamicCell

-(void)setData:(DynamicItem *)data
{
    _data = data;
    for(UIView *view in [self.contentView subviews])
    {
        [view removeFromSuperview];
    }
    [self setHeadView];
    [self setBodyView];
    [self setZanReplyBar];
    [self setFootView];

}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.bounds = [UIScreen mainScreen].bounds;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
-(void)setHeadView
{
    _headView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 14, 40, 40)];
    [self.contentView addSubview:_headView];
    CALayer *layer=[_headView layer];
    //是否设置边框以及是否可见
    [layer setMasksToBounds:YES];
    //设置边框圆角的弧度
    //[layer setCornerRadius:40 / 2.0];
    //设置边框线的宽
    [layer setBorderWidth:1];
    //设置边框线的颜色
    [layer setBorderColor:[[UIColor whiteColor] CGColor]];
    
    CGFloat nameWidth = SCREEN_WIDTH - 60 - 32; //屏幕宽-头像宽-删除按钮
    _fromName = [[UILabel alloc]initWithFrame:CGRectMake(60, 18, nameWidth, 14)];
    [self.contentView addSubview:_fromName];
    _fromName.font = [UIFont systemFontOfSize:14];
    _fromName.textColor = [UIColor colorWithRed:200.0/255 green:148.0/255 blue:70.0/255 alpha:1];
    
    [_headView sd_setImageWithURL:[NSURL URLWithString:_data.avatar]];
    _fromName.text = _data.name;
    

}
-(void)setBodyView
{
    NSString *type = _data.MsgType;
    if ([type isEqualToString:@"text"]) {
        [self setTextBody];
    }else
    {
        [self setNewsBody];
    }
}
-(void)setTextBody
{
    CGFloat bodyViewWidth = SCREEN_WIDTH - 60 - 32;
    CGFloat bodyViewAddHight = 0;
    BOOL showMoreBtn = NO;
    
    NSString *content = _data.content;
    
    TTTAttributedLabel * contentLabel = [[TTTAttributedLabel alloc]initWithFrame:CGRectMake(0, 0, bodyViewWidth, 0)];
    contentLabel.numberOfLines = 0;
    contentLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    contentLabel.delegate = self;
    
    if (content != nil && content.length > 0 ) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.maximumLineHeight = 18.0f;
        paragraphStyle.minimumLineHeight = 16.0f;
        paragraphStyle.firstLineHeadIndent = 0.0f;
        paragraphStyle.lineSpacing = 6.0f;
        paragraphStyle.firstLineHeadIndent = 0.0f;
        paragraphStyle.headIndent = 0.0f;
        paragraphStyle.alignment = NSTextAlignmentLeft;
        //
        UIFont *font = [UIFont systemFontOfSize:14];
        NSDictionary *attributes = @{ NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle};
        contentLabel.attributedText = [[NSAttributedString alloc]initWithString:content attributes:attributes];
        //        contentLabel.textColor = [UIColor blackColor];
        CGSize size = CGSizeMake(bodyViewWidth, 1000.0f);
        CGSize finalSize = [contentLabel sizeThatFits:size];
        contentLabel.frame = CGRectMake(0, 0, finalSize.width, finalSize.height);
        
        //利用富文本实现URL的点击事件http://blog.csdn.net/liyunxiangrxm/article/details/53410919
        contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        contentLabel.linkAttributes = @{(NSString *)kCTUnderlineStyleAttributeName : [NSNumber numberWithBool:YES],
                                        (NSString*)kCTForegroundColorAttributeName : (id)[[UIColor blueColor] CGColor]};
        
        contentLabel.highlightedTextColor = [UIColor whiteColor];
        contentLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentTop;
        // end modify by huangyibiao
        
        // reasion: handle links in chat content, ananylizing each link
        // 提取出文本中的超链接
        NSError *error;
        NSString *regulaStr = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:&error];
        NSArray *arrayOfAllMatches = [regex matchesInString:content
                                                    options:0
                                                      range:NSMakeRange(0, [content length])];
        NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:content];
        for (NSTextCheckingResult *match in arrayOfAllMatches) {
            NSString *substringForMatch = [content substringWithRange:match.range];
            [attribute addAttribute:(NSString *)kCTFontAttributeName value:(id)contentLabel.font range:match.range];
            [attribute addAttribute:(NSString*)kCTForegroundColorAttributeName
                              value:(id)[[UIColor blueColor] CGColor]
                              range:match.range];
            [contentLabel addLinkToURL:[NSURL URLWithString:substringForMatch] withRange:match.range];
        }
        
        
        //文本增加长按手势
        contentLabel.userInteractionEnabled = YES;
        UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressText:)];
        [contentLabel addGestureRecognizer:longTap];
        contentLabel.frame = CGRectMake(0, 0, finalSize.width, finalSize.height);
        bodyViewAddHight = 0;
        
        
        if(finalSize.height > 144.0){
            if (_data.textOpenFlag == NO) {
                contentLabel.frame = CGRectMake(0, 0, finalSize.width, 144);
                _moreBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                _moreBtn.frame = CGRectMake(0, 0, 50, 20);
                [_moreBtn setContentMode:UIViewContentModeLeft];
                _moreBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                [_moreBtn setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
                [_moreBtn addTarget:self action:@selector(showMore) forControlEvents:UIControlEventTouchUpInside];
                UIEdgeInsets titileEdgeInset = UIEdgeInsetsMake(-10, 0, 0, 0);
                _moreBtn.titleEdgeInsets = titileEdgeInset;
                
                CGRect moreBtnFrame = _moreBtn.frame;
                moreBtnFrame.origin.y = contentLabel.frame.origin.y + contentLabel.frame.size.height;
                _moreBtn.frame = moreBtnFrame;
                //                [self.bodyView addSubview:_moreBtn];
                bodyViewAddHight = 20;
                [_moreBtn setTitle:@"全文" forState:UIControlStateNormal];
                showMoreBtn = YES;
            }else{
                contentLabel.frame = CGRectMake(0, 0, finalSize.width, finalSize.height);
                _moreBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                _moreBtn.frame = CGRectMake(0, 0, 30, 20);
                _moreBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                [_moreBtn setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
                [_moreBtn addTarget:self action:@selector(showMore) forControlEvents:UIControlEventTouchUpInside];
                UIEdgeInsets titileEdgeInset = UIEdgeInsetsMake(0, 0, 0, 0);
                _moreBtn.titleEdgeInsets = titileEdgeInset;
                
                CGRect moreBtnFrame = _moreBtn.frame;
                moreBtnFrame.origin.y = contentLabel.frame.origin.y + contentLabel.frame.size.height;
                _moreBtn.frame = moreBtnFrame;
                //                [self.bodyView addSubview:_moreBtn];
                bodyViewAddHight = 20;
                [_moreBtn setTitle:@"收起" forState:UIControlStateNormal];
                showMoreBtn = YES;
            }
        }else{
            contentLabel.frame = CGRectMake(0, 0, finalSize.width, finalSize.height);
            _moreBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            
            bodyViewAddHight = 0;
            showMoreBtn = NO;
        }
        
    }
    
    //调整frame = 内容的frame高度
    
    
    CGFloat bodyHight = contentLabel.frame.size.height + bodyViewAddHight;
    self.bodyView = nil;
    self.bodyView = [[UIView alloc]initWithFrame:CGRectMake(_fromName.frame.origin.x, _fromName.frame.origin.y + _fromName.frame.size.height + 10, bodyViewWidth, bodyHight)];
    [self.contentView addSubview:self.bodyView];
    [self.bodyView addSubview:contentLabel];
    if (showMoreBtn) {
        [self.bodyView addSubview:_moreBtn];
    }

}
-(void)setNewsBody
{
    CGFloat bodyViewWidth = SCREEN_WIDTH - 60 - 32;
    CGFloat bodyViewAddHight = 0;
    BOOL showMoreBtn = NO;
    
    NSString *content = _data.content;
    
    TTTAttributedLabel * contentLabel = [[TTTAttributedLabel alloc]initWithFrame:CGRectMake(0, 0, bodyViewWidth, 0)];
    contentLabel.numberOfLines = 0;
    contentLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    contentLabel.delegate = self;
    
    if (content != nil && content.length > 0 ) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.maximumLineHeight = 18.0f;
        paragraphStyle.minimumLineHeight = 16.0f;
        paragraphStyle.firstLineHeadIndent = 0.0f;
        paragraphStyle.lineSpacing = 6.0f;
        paragraphStyle.firstLineHeadIndent = 0.0f;
        paragraphStyle.headIndent = 0.0f;
        paragraphStyle.alignment = NSTextAlignmentLeft;
        //
        UIFont *font = [UIFont systemFontOfSize:14];
        NSDictionary *attributes = @{ NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle};
        contentLabel.attributedText = [[NSAttributedString alloc]initWithString:content attributes:attributes];
        //        contentLabel.textColor = [UIColor blackColor];
        CGSize size = CGSizeMake(bodyViewWidth, 1000.0f);
        CGSize finalSize = [contentLabel sizeThatFits:size];
        contentLabel.frame = CGRectMake(0, 0, finalSize.width, finalSize.height);
        
        //利用富文本实现URL的点击事件http://blog.csdn.net/liyunxiangrxm/article/details/53410919
        contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        contentLabel.linkAttributes = @{(NSString *)kCTUnderlineStyleAttributeName : [NSNumber numberWithBool:YES],
                                        (NSString*)kCTForegroundColorAttributeName : (id)[[UIColor blueColor] CGColor]};
        
        contentLabel.highlightedTextColor = [UIColor whiteColor];
        contentLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentTop;
        // end modify by huangyibiao
        
        // reasion: handle links in chat content, ananylizing each link
        // 提取出文本中的超链接
        NSError *error;
        NSString *regulaStr = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:&error];
        NSArray *arrayOfAllMatches = [regex matchesInString:content
                                                    options:0
                                                      range:NSMakeRange(0, [content length])];
        NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:content];
        for (NSTextCheckingResult *match in arrayOfAllMatches) {
            NSString *substringForMatch = [content substringWithRange:match.range];
            [attribute addAttribute:(NSString *)kCTFontAttributeName value:(id)contentLabel.font range:match.range];
            [attribute addAttribute:(NSString*)kCTForegroundColorAttributeName
                              value:(id)[[UIColor blueColor] CGColor]
                              range:match.range];
            [contentLabel addLinkToURL:[NSURL URLWithString:substringForMatch] withRange:match.range];
        }
        
        
        //文本增加长按手势
        contentLabel.userInteractionEnabled = YES;
        UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressText:)];
        [contentLabel addGestureRecognizer:longTap];
        contentLabel.frame = CGRectMake(0, 0, finalSize.width, finalSize.height);
        bodyViewAddHight = 0;
        
        
        if(finalSize.height > 144.0){
            if (_data.textOpenFlag == NO) {
                contentLabel.frame = CGRectMake(0, 0, finalSize.width, 144);
                _moreBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                _moreBtn.frame = CGRectMake(0, 0, 50, 20);
                [_moreBtn setContentMode:UIViewContentModeLeft];
                _moreBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                [_moreBtn setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
                [_moreBtn addTarget:self action:@selector(showMore) forControlEvents:UIControlEventTouchUpInside];
                UIEdgeInsets titileEdgeInset = UIEdgeInsetsMake(-10, 0, 0, 0);
                _moreBtn.titleEdgeInsets = titileEdgeInset;
                
                CGRect moreBtnFrame = _moreBtn.frame;
                moreBtnFrame.origin.y = contentLabel.frame.origin.y + contentLabel.frame.size.height;
                _moreBtn.frame = moreBtnFrame;
                //                [self.bodyView addSubview:_moreBtn];
                bodyViewAddHight = 20;
                [_moreBtn setTitle:@"全文" forState:UIControlStateNormal];
                showMoreBtn = YES;
            }else{
                contentLabel.frame = CGRectMake(0, 0, finalSize.width, finalSize.height);
                _moreBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                _moreBtn.frame = CGRectMake(0, 0, 30, 20);
                _moreBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                [_moreBtn setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
                [_moreBtn addTarget:self action:@selector(showMore) forControlEvents:UIControlEventTouchUpInside];
                UIEdgeInsets titileEdgeInset = UIEdgeInsetsMake(0, 0, 0, 0);
                _moreBtn.titleEdgeInsets = titileEdgeInset;
                
                CGRect moreBtnFrame = _moreBtn.frame;
                moreBtnFrame.origin.y = contentLabel.frame.origin.y + contentLabel.frame.size.height;
                _moreBtn.frame = moreBtnFrame;
                //                [self.bodyView addSubview:_moreBtn];
                bodyViewAddHight = 20;
                [_moreBtn setTitle:@"收起" forState:UIControlStateNormal];
                showMoreBtn = YES;
            }
        }else{
            contentLabel.frame = CGRectMake(0, 0, finalSize.width, finalSize.height);
            _moreBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            
            bodyViewAddHight = 0;
            showMoreBtn = NO;
        }
        
    }
    
    
    
    
    
    
    if (_imgArray == nil) {
        _imgArray = [[NSMutableArray alloc]init];
    }
    [_imgArray removeAllObjects];
    
    
    [_imgArray addObjectsFromArray:_data.imgs];
    
    
    if (_imgViewArray == nil) {
        _imgViewArray = [[NSMutableArray alloc]init];
    }
    [_imgViewArray removeAllObjects];
    
    CGFloat fromY = contentLabel == nil?0:contentLabel.frame.size.height+10;
    if (showMoreBtn) {
        fromY += bodyViewAddHight;
    }
    if ([_imgArray count] == 1) {
        
        CGFloat picW = bodyViewWidth/7*3;
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, fromY, picW, picW)];
        imageView.tag = 0;
        imageView.userInteractionEnabled = YES;
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:_imgArray[0]]];
        
        [_imgViewArray addObject:imageView];
        UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onPressImage:)];
        [imageView addGestureRecognizer:tapGesture];
        UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressImage:)];
        [imageView addGestureRecognizer:longTap];
        
    }else if([_imgArray count] == 2){
        CGFloat imgWidth = (bodyViewWidth - 2 * kPicDiv)/3;
        UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, fromY, imgWidth, imgWidth)];
        
        
        
        [imageView1 sd_setImageWithURL:[NSURL URLWithString:_imgArray[0]]];
        
        
        //        [imageView1 sd_setImageWithURL:[NSURL URLWithString:item[@"FileUrl"]]];
        imageView1.tag = 0;
        imageView1.userInteractionEnabled = YES;
        UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onPressImage:)];
        [imageView1 addGestureRecognizer:tapGesture];
        UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressImage:)];
        [imageView1 addGestureRecognizer:longTap];
        [_imgViewArray addObject:imageView1];
        
        UIImageView *imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(imgWidth+kPicDiv,fromY, imgWidth, imgWidth)];
        
        
        
        [imageView2 sd_setImageWithURL:[NSURL URLWithString:_imgArray[1]]];
        
        //        [imageView2 sd_setImageWithURL:[NSURL URLWithString:item[@"FileUrl"]]];
        [_imgViewArray addObject:imageView2];
        imageView2.userInteractionEnabled = YES;
        UITapGestureRecognizer*tapGesture2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onPressImage:)];
        [imageView2 addGestureRecognizer:tapGesture2];
        UILongPressGestureRecognizer *longTap2 = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressImage:)];
        [imageView2 addGestureRecognizer:longTap2];
        imageView2.tag = 1;
    }else if([_imgArray count] == 4){
        CGFloat imgWidth = (bodyViewWidth - 2 * kPicDiv)/3;
        for (int i=0; i<[_imgArray count]; i++) {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((i%2)*(imgWidth+kPicDiv), (i/2)*(imgWidth+kPicDiv) + fromY, imgWidth, imgWidth)];
            
            [imageView sd_setImageWithURL:[NSURL URLWithString:_imgArray[i]]];
            imageView.backgroundColor = [UIColor redColor];
            //            [imageView sd_setImageWithURL:[NSURL URLWithString:item[@"FileUrl"]]];
            imageView.tag = i;
            imageView.userInteractionEnabled = YES;
            [_imgViewArray addObject:imageView];
            UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onPressImage:)];
            [imageView addGestureRecognizer:tapGesture];
            UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressImage:)];
            [imageView addGestureRecognizer:longTap];
        }
    }
    else{
        CGFloat imgWidth = (bodyViewWidth - 2 * kPicDiv)/3;
        for (int i=0; i<[_imgArray count]; i++) {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((i%3)*(imgWidth+kPicDiv), (i/3)*(imgWidth+kPicDiv) + fromY, imgWidth, imgWidth)];
            
            
            [imageView sd_setImageWithURL:[NSURL URLWithString:_imgArray[i]]];
            
            //            [imageView sd_setImageWithURL:[NSURL URLWithString:item[@"FileUrl"]]];
            imageView.tag = i;
            [_imgViewArray addObject:imageView];
            imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onPressImage:)];
            [imageView addGestureRecognizer:tapGesture];
            UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressImage:)];
            [imageView addGestureRecognizer:longTap];
        }
    }
    
    
    
    UIImageView *lastView = [_imgViewArray objectAtIndex:([_imgViewArray count]-1) ];
    CGFloat bodyHight = lastView.frame.size.height + lastView.frame.origin.y;
    if (showMoreBtn) {
        bodyHight += bodyViewAddHight;
    }
    
    self.bodyView = nil;
    self.bodyView = [[UIView alloc]initWithFrame:CGRectMake(_fromName.frame.origin.x, _fromName.frame.origin.y + _fromName.frame.size.height + 10, bodyViewWidth, bodyHight)];
    [self.contentView addSubview:self.bodyView];
    
    if(contentLabel != nil){
        [self.bodyView addSubview:contentLabel];
        if (showMoreBtn) {
            [self.bodyView addSubview:_moreBtn];
        }
        
    }
    for (UIImageView *iv in _imgViewArray) {
        
        [self.bodyView addSubview:iv];
    }
    
}
- (void)showMore{
    if ([_moreBtn.titleLabel.text isEqualToString:@"全文"]) {
        if (_delegate && [_delegate respondsToSelector:@selector(onPressMoreBtnOnDynamicCell:)]) {
            //            [_moreBtn setTitle:@"收起" forState:UIControlStateNormal];
            _data.textOpenFlag = YES;
            [_delegate onPressMoreBtnOnDynamicCell:self];
        }
    }else if ([_moreBtn.titleLabel.text isEqualToString:@"收起"]){
        if (_delegate && [_delegate respondsToSelector:@selector(onPressMoreBtnOnDynamicCell:)]) {
            //            [_moreBtn setTitle:@"更多" forState:UIControlStateNormal];
            _data.textOpenFlag = NO;
            [_delegate onPressMoreBtnOnDynamicCell:self];
        }
    }
}

#pragma mark - TTTAttributedLabelDelegate 点击聊天内容中的超链接
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    NSLog([NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil]);
    if (_delegate && [_delegate respondsToSelector:@selector(onPressShareUrlOnUrl:)]) {
        [_delegate onPressShareUrlOnUrl:url];
    }

    
    
}
- (void)longPressText:(UILongPressGestureRecognizer *)sender{
    NSLog(@"长按");
    if (sender.state == UIGestureRecognizerStateBegan){
        if (_delegate && [_delegate respondsToSelector:@selector(onLongPressText:onDynamicCell:)]) {
            TTTAttributedLabel *label = (TTTAttributedLabel *)sender.view;
            [_delegate onLongPressText:label.text onDynamicCell:self];
        }
    }
}
-(void)setZanReplyBar
{
    _zanBarView =  [[UIView alloc]initWithFrame:CGRectMake(0, _bodyView.frame.size.height + _bodyView.frame.origin.y, SCREEN_WIDTH, 36)];
    UILabel *timeLabel = [[UILabel alloc]init];
    timeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_zanBarView addSubview:timeLabel];
    float tdlength = 8;
    UIFont *fontsize = [UIFont systemFontOfSize:13];
    UIFont *labelfontsize = [UIFont systemFontOfSize:15];
    if(SCREEN_WIDTH == 320){
        tdlength = -8;
        fontsize = [UIFont systemFontOfSize:11];
        labelfontsize = [UIFont systemFontOfSize:13];
    }
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:13]};
    // NSString class method: boundingRectWithSize:options:attributes:context is
    // available only on ios7.0 sdk.
    CGRect rect = [_data.time boundingRectWithSize:CGSizeMake(320, MAXFLOAT)
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:attributes
                                           context:nil];
    //CGSize labelsize = [nowTime sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_zanBarView.mas_left).with.offset(60);
        make.centerY.equalTo(_zanBarView.mas_centerY).with.offset(0);
        make.width.mas_equalTo(rect.size.width+8);
        
    }];
    timeLabel.textColor = [UIColor colorWithRed: 115.0/255 green:115.0/255 blue:115.0/255
                                          alpha:1];
    timeLabel.font = fontsize;
    
    timeLabel.text = _data.time;
    [self.contentView addSubview:_zanBarView];
    
    
#pragma mark 删除按钮
    //删除按钮从headview迁移到zanReplyBar
    _deleteBtn = [[UIButton alloc]init];
    _deleteBtn.translatesAutoresizingMaskIntoConstraints = NO;
    _deleteBtn.userInteractionEnabled = YES;
    [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    _deleteBtn.titleLabel.font = labelfontsize;
    [_deleteBtn setTitleColor:[UIColor colorWithRed:115.0/255 green:115.0/255 blue:115.0/255 alpha:1] forState:UIControlStateNormal];
    
    
    [_zanBarView addSubview:_deleteBtn];
    [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(timeLabel.mas_right).with.offset(tdlength);
        make.centerY.equalTo(_zanBarView.mas_centerY).with.offset(0);
        
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    
    
    [_deleteBtn setContentMode:UIViewContentModeCenter];
    
    [_deleteBtn addTarget:self action:@selector(onPressDelete:) forControlEvents:UIControlEventTouchDown];
    _deleteBtn.hidden = NO;
    
//    NSInteger msgPower = [_dynamicPower[@"msgPower"] integerValue];
//    AccountModel *model = [AccountModel readSingleModelForKey:Key_LoginUserInfo];
//    BOOL isMeSend = false;
//    isMeSend = false;
//    //判断是不是自己发的
//    if (model.accountId == _data.msg.creatorId) {
//        isMeSend = YES;
//    }
//    
//    if (isMeSend) {
//        _deleteBtn.hidden = NO;
//    }else if(msgPower == 2||msgPower == 3){
//        _deleteBtn.hidden = NO;
//    }else{
//        _deleteBtn.hidden = YES;
//    }
    
//    if (_data.msgType == 1) {
//        _deleteBtn.hidden = YES;
//    }

#pragma mark 评论按钮
//    replyPower暂时注释  这里是根据该值的不同是否让评论存在
//    NSInteger replyPower = [[_dynamicPower objectForKey:@"replyPower"]integerValue];
    
    //评论标签添加,gkb
    UILabel *replyLabel = [[UILabel alloc]init];
    [replyLabel setText:@"评论"];
    replyLabel.font = labelfontsize;
    replyLabel.textColor = [UIColor colorWithRed:115.0/255 green:115.0/255 blue:115.0/255 alpha:1];
    replyLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_zanBarView addSubview:replyLabel];
    [replyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_zanBarView.mas_centerY).with.offset(0);
//        if(replyPower == 1 || replyPower == 3)
            make.right.equalTo(_zanBarView.mas_right).with.offset(-10);
//        else
//            make.right.equalTo(_zanBarView.mas_right).with.offset(50);
        make.width.mas_equalTo(38);
        make.height.mas_equalTo(38);
    }];
    [replyLabel setContentMode:UIViewContentModeCenter];
    replyLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer*tapGestureGKB = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onPressReply:)];
    [replyLabel addGestureRecognizer:tapGestureGKB];
    
    
    _replyBtn = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"评论"]];
    _replyBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [_zanBarView addSubview:_replyBtn];
    [_replyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_zanBarView.mas_centerY).with.offset(0);
//        if(replyPower == 1 || replyPower == 3)
            make.right.equalTo(replyLabel.mas_left).with.offset(4);
//        else
//            make.right.equalTo(_zanBarView.mas_right).with.offset(50);
        make.width.mas_equalTo(28);
        make.height.mas_equalTo(28);
    }];
    [_replyBtn setContentMode:UIViewContentModeCenter];
    _replyBtn.userInteractionEnabled = YES;
    UITapGestureRecognizer*tapGesture1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onPressReply:)];
    
    //zanlabel距离评论图标的距离，320*568分辨率特殊处理
    float length = 15;
    if(SCREEN_WIDTH == 320){
        length = 15;
    }
#pragma mark 点赞按钮
    //赞标签添加,gkb
    UILabel *zanLabel = [[UILabel alloc]init];
    [zanLabel setText:@"赞"];
    zanLabel.font = labelfontsize;
    zanLabel.textColor = [UIColor colorWithRed:115.0/255 green:115.0/255 blue:115.0/255 alpha:1];
    zanLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_zanBarView addSubview:zanLabel];
    [zanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_zanBarView.mas_centerY).with.offset(0);
//        if(replyPower == 1 || replyPower == 3)
            make.right.equalTo(_replyBtn.mas_left).with.offset(length);
//        else
//            make.right.equalTo(_zanBarView.mas_right).with.offset(0);
        make.width.mas_equalTo(38);
        make.height.mas_equalTo(38);
    }];
    [zanLabel setContentMode:UIViewContentModeCenter];
    zanLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer*tapGestureGKB2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onPressZan:)];
    [zanLabel addGestureRecognizer:tapGestureGKB2];
    
    [_replyBtn addGestureRecognizer:tapGesture1];
//    if(replyPower == 1 || replyPower == 3)
        _replyBtn.hidden = NO;
//    else
//        _replyBtn.hidden = YES;
    BOOL beZan = [self didZan];
//    NSString *imageName = beZan?@"赞-按下":@"赞";
    NSString *imageName = @"评论-点赞";
    _zanBtn = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
    _zanBtn.translatesAutoresizingMaskIntoConstraints = NO;
    _zanBtn.tag = beZan?1:0;
    [_zanBarView addSubview:_zanBtn];
    [_zanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_zanBarView.mas_centerY).with.offset(0);
//        if(replyPower == 1 || replyPower == 3)
//            make.right.equalTo(zanLabel.mas_left).with.offset(0);
//        else
            make.right.equalTo(_zanBarView.mas_right).with.offset(-95);
        make.width.mas_equalTo(28);
        make.height.mas_equalTo(28);
    }];
    [_zanBtn setContentMode:UIViewContentModeCenter];
    
    _zanBtn.userInteractionEnabled = YES;
    UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onPressZan:)];
    
    [_zanBtn addGestureRecognizer:tapGesture];
    
    [self.contentView addSubview:_zanBarView];
//    if (_data.msgType == 0) {
        _zanBtn.hidden = NO;
//        }else
//        {
//        _zanBtn.hidden = YES;
//        }
//    if ([_data.status isEqualToString:@"2"]) {
//            //显示发送失败
//            UILabel *errLabel = [[UILabel alloc]init];
//            errLabel.backgroundColor = UIColorFromRGB(0xffa3a3);
//            errLabel.font = [UIFont systemFontOfSize:12];
//            errLabel.textColor = [UIColor whiteColor];
//            errLabel.text = @"重新上传";
//            errLabel.layer.cornerRadius = 5;
//            errLabel.clipsToBounds = YES;
//            errLabel.textAlignment = NSTextAlignmentCenter;
//            errLabel.translatesAutoresizingMaskIntoConstraints = NO;
//            [_zanBarView addSubview:errLabel];
//            [errLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.centerY.equalTo(_zanBarView.mas_centerY).with.offset(0);
//                make.left.equalTo(_zanBarView.mas_left).with.offset(60);
//                make.height.mas_equalTo(@20);
//                make.width.mas_equalTo(@60);
//            }];
//            
//            errLabel.userInteractionEnabled = YES;
//            UITapGestureRecognizer*tapGestureRe = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onPressResend)];
//            
//            [errLabel addGestureRecognizer:tapGestureRe];
//        }
//    }
    
}
//是否赞过
- (BOOL)didZan{
//    AccountModel *model = [AccountModel readSingleModelForKey:Key_LoginUserInfo];
//    if (model == nil) {
//        return NO;
//    }
//    for (Zans *zan in _data.zans) {
//        if (zan.creatorId == model.accountId) {
//            return YES;
//        }
//    }
    return NO;
}

-(void)setFootView
{
    
}
- (void)onPressZan:(id)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(onPressZanBtnOnDynamicCell:)]) {
        [_delegate onPressZanBtnOnDynamicCell:self];
    }
}
- (void)onPressDelete:(id)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(onPressDeleteBtnOnDynamicCell:)]) {
        [_delegate onPressDeleteBtnOnDynamicCell:self];
    }
}
- (void)onPressReply:(id)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(onPressReplyBtnOnDynamicCell:)]) {
        [_delegate onPressReplyBtnOnDynamicCell:self];
    }
}
- (void)onPressImage:(UITapGestureRecognizer *)sender{

    UIImageView *imageview = (UIImageView *)sender.view;
    if (_delegate && [_delegate respondsToSelector:@selector(onPressImageView:onDynamicCell:)]) {
        
        [_delegate onPressImageView:imageview onDynamicCell:self];
    }
    
}
- (void)longPressImage:(UILongPressGestureRecognizer *)sender{
    UIImageView *imageView = (UIImageView *)sender.view;
    if (sender.state == UIGestureRecognizerStateBegan){
        if (_delegate && [_delegate respondsToSelector:@selector(onLongPressImageView:onDynamicCell:)]) {
            [_delegate onLongPressImageView:imageView onDynamicCell:self];
        }
    }
}
- (CGSize)sizeThatFits:(CGSize)size{

        return CGSizeMake(SCREEN_WIDTH, _zanBarView.frame.size.height +  _zanBarView.frame.origin.y+10);
    
}
@end
