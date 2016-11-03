//
//  DynamicCell.m
//  CircleOfFriendsDisplay
//
//  Created by 李云祥 on 16/9/22.
//  Copyright © 2016年 李云祥. All rights reserved.
//

#import "DynamicCell.h"
#import "TTTAttributedLabel.h"
#import "Masonry.h"

//获取屏幕 宽度、高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define kPicDiv 4.0f
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
    CGFloat bodyViewWidth = SCREEN_WIDTH - 60 - 32;
    CGFloat bodyViewAddHight = 0;
    
    NSString *content = _data.content;
    TTTAttributedLabel * contentLabel = [[TTTAttributedLabel alloc]initWithFrame:CGRectMake(0, 0, bodyViewWidth, 0)];
    contentLabel.numberOfLines = 0;
    if (content != nil && content.length > 0 ) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
//        paragraphStyle.lineHeightMultiple = 10.f;
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
        contentLabel.textColor = [UIColor blackColor];
        CGSize size = CGSizeMake(bodyViewWidth, 1000.0f);
        CGSize finalSize = [contentLabel sizeThatFits:size];
        contentLabel.frame = CGRectMake(0, 0, finalSize.width, finalSize.height);
        
        contentLabel.userInteractionEnabled = YES;
        UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressText:)];
        [contentLabel addGestureRecognizer:longTap];
        

        contentLabel.frame = CGRectMake(0, 0, finalSize.width, finalSize.height);
        
        bodyViewAddHight = 0;
   
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

    self.bodyView = nil;
    self.bodyView = [[UIView alloc]initWithFrame:CGRectMake(_fromName.frame.origin.x, _fromName.frame.origin.y + _fromName.frame.size.height + 10, bodyViewWidth, bodyHight)];
    [self.contentView addSubview:self.bodyView];
    
    if(contentLabel != nil){
        [self.bodyView addSubview:contentLabel];
    }
    for (UIImageView *iv in _imgViewArray) {
        
        [self.bodyView addSubview:iv];
    }

}
- (void)longPressText:(UILongPressGestureRecognizer *)sender{
    NSLog(@"长按");
//    if (sender.state == UIGestureRecognizerStateBegan){
//        if (_delegate && [_delegate respondsToSelector:@selector(onLongPressText:onDynamicCell:)]) {
//            TTTAttributedLabel *label = (TTTAttributedLabel *)sender.view;
//            [_delegate onLongPressText:label.text onDynamicCell:self];
//        }
//    }
}

-(void)setFootView
{
    CGFloat bodyViewWidth = SCREEN_WIDTH - 60 - 10;
     _footView =  [[UIView alloc]initWithFrame:CGRectMake(0, _bodyView.frame.size.height + _bodyView.frame.origin.y, SCREEN_WIDTH, 36)];
    UILabel *timeLabel = [[UILabel alloc]init];
    timeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_footView addSubview:timeLabel];
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
        make.left.equalTo(_footView.mas_left).with.offset(60);
        make.centerY.equalTo(_footView.mas_centerY).with.offset(0);
        make.width.mas_equalTo(rect.size.width+8);
        
    }];
    timeLabel.textColor = [UIColor colorWithRed: 115.0/255 green:115.0/255 blue:115.0/255
                                          alpha:1];
    timeLabel.font = fontsize;
    
    timeLabel.text = _data.time;
    [self.contentView addSubview:_footView];

    
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

        return CGSizeMake(SCREEN_WIDTH, _footView.frame.size.height +  _footView.frame.origin.y+10);
    
}
@end
