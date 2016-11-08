//
//  DQAlertView.m
//
//  Created by Dinh Quan on 1/27/14.
//  Copyright (c) 2014 Dinh Quan. All rights reserved.
//

#import "DQAlertView.h"

#define DEFAULT_ALERT_WIDTH 270
#define DEFAULT_ALERT_HEIGHT 144

@interface DQAlertView ()
{
    CGRect titleLabelFrame;
    CGRect messageLabelFrame;
    CGRect cancelButtonFrame;
    CGRect otherButtonFrame;
    
    CGRect verticalSeperatorFrame;
    CGRect horizontalSeperatorFrame;
    
    BOOL hasModifiedFrame;
    BOOL hasContentView;
}
@property (nonatomic, strong) UIView * alertContentView;

@property (nonatomic, strong) UIView * horizontalSeparator;
@property (nonatomic, strong) UIView * verticalSeparator;

@property (nonatomic, strong) UIView * blackOpaqueView;

@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * message;
@property (nonatomic, strong) NSString * cancelButtonTitle;
@property (nonatomic, strong) NSString * otherButtonTitle;

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

@property (nonatomic, strong) UIColor *originCancelButtonColor;
@property (nonatomic, strong) UIColor *originOtherButtonColor;

@end

@implementation DQAlertView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// Init method
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id /*<DQAlertViewDelegate>*/)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    NSString *firstOtherButtonTitle;
    
    va_list args;
    va_start(args, otherButtonTitles);
    for (NSString *arg = otherButtonTitles; arg != nil; arg = va_arg(args, NSString*))
    {
        //do something with nsstring
        if (!firstOtherButtonTitle) {
            firstOtherButtonTitle = arg;
            break;
        }
    }
    va_end(args);
    
    if ([self initWithTitle:title message:message cancelButtonTitle:cancelButtonTitle otherButtonTitle:otherButtonTitles]) {
        self.delegate = delegate;
        
        return self;
    }
    
    return nil;
}

// Init method shorter version
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitle:(NSString *)otherButtonTitle
{
    self.width = DEFAULT_ALERT_WIDTH;
    self.height = DEFAULT_ALERT_HEIGHT;
    
    self = [super initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    if (self) {
        // Initialization code
        
        self.clipsToBounds = YES;
        self.title = title;
        self.message = message;
        self.cancelButtonTitle = cancelButtonTitle;
        self.otherButtonTitle = otherButtonTitle;
        self.appearAnimationType = DQAlertViewAnimationTypeDefault;
        self.disappearAnimationType = DQAlertViewAnimationTypeDefault;
        self.cornerRadius = 8;
        self.buttonClickedHighlight = YES;
        
        self.buttonHeight = 44;
        self.titleTopPadding = 14;
        self.titleHeight = 34;
        self.titleBottomPadding = 2;
        self.messageBottomPadding = 20;
        self.messageLeftRightPadding = 20;
        
        self.shouldDimBackgroundWhenShowInWindow = YES;
        self.shouldDismissOnActionButtonClicked = YES;
        self.dimAlpha = 0.4;
        
        [self setupItems];

    }
    return self;
}

#pragma mark - Show the alert view

// Show in specified view
- (void)showInView:(UIView *)view
{
    [self calculateFrame];
    [self setupViews];
    
    if ( ! hasModifiedFrame) {
        self.frame = CGRectMake((view.frame.size.width - self.frame.size.width )/2, (view.frame.size.height - self.frame.size.height) /2, self.frame.size.width, self.frame.size.height);
    }
    UIView *window = [[[UIApplication sharedApplication] delegate] window];

    if (self.shouldDimBackgroundWhenShowInView && view != window) {
        UIView *window = [[[UIApplication sharedApplication] delegate] window];
        self.blackOpaqueView = [[UIView alloc] initWithFrame:window.bounds];
        self.blackOpaqueView.backgroundColor = [UIColor colorWithWhite:0 alpha:self.dimAlpha];
        
        UITapGestureRecognizer *outsideTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(outsideTap:)];
        [self.blackOpaqueView addGestureRecognizer:outsideTapGesture];
        [view addSubview:self.blackOpaqueView];
    }
    
    [self willAppearAlertView];

    [self addThisViewToView:view];
}

// Show in window
- (void)show
{
//    [self calculateFrame];
//    [self setupViews];
    
    UIView *window = [[[UIApplication sharedApplication] delegate] window];
    
    if (self.shouldDimBackgroundWhenShowInWindow) {
        self.blackOpaqueView = [[UIView alloc] initWithFrame:window.bounds];
        self.blackOpaqueView.backgroundColor = [UIColor colorWithWhite:0 alpha:self.dimAlpha];

        UITapGestureRecognizer *outsideTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(outsideTap:)];
        [self.blackOpaqueView addGestureRecognizer:outsideTapGesture];
        [window addSubview:self.blackOpaqueView];
    }
    
    [self showInView:window];
}

- (void)outsideTap:(UITapGestureRecognizer *)recognizer
{
    if (self.shouldDismissOnOutsideTapped) {
        [self dismiss];
    }
}

- (void) addThisViewToView: (UIView *) view
{
    NSTimeInterval timeAppear = ( self.appearTime > 0 ) ? self.appearTime : .2;
    NSTimeInterval timeDelay = 0;

    [view addSubview:self];
    
    if (self.appearAnimationType == DQAlertViewAnimationTypeDefault)
    {
        self.transform = CGAffineTransformMakeScale(1.1, 1.1);
        self.alpha = .6;
        [UIView animateWithDuration:timeAppear delay:timeDelay options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.transform = CGAffineTransformIdentity;
            self.alpha = 1;
            
        } completion:^(BOOL finished){
            [self didAppearAlertView];
        }];
    }
    else if (self.appearAnimationType == DQAlertViewAnimationTypeZoomIn)
    {
        self.transform = CGAffineTransformMakeScale(0.01, 0.01);
        [UIView animateWithDuration:timeAppear delay:timeDelay options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.transform = CGAffineTransformIdentity;
            
        } completion:^(BOOL finished){
            [self didAppearAlertView];
        }];
    }
    else if (self.appearAnimationType == DQAlertViewAnimationTypeFadeIn)
    {
        self.alpha = 0;
        [UIView animateWithDuration:timeAppear delay:timeDelay options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.alpha = 1;
            
        } completion:^(BOOL finished){
            [self didAppearAlertView];
        }];
    }
    else if (self.appearAnimationType == DQAlertViewAnimationTypeFlyTop)
    {
        CGRect tmpFrame = self.frame;
        self.frame = CGRectMake(self.frame.origin.x, - self.frame.size.height - 10, self.frame.size.width, self.frame.size.height);
        [UIView animateWithDuration:timeAppear delay:timeDelay options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.frame = tmpFrame;
            
        } completion:^(BOOL finished){
            [self didAppearAlertView];
        }];
        
    }
    else if (self.appearAnimationType == DQAlertViewAnimationTypeFlyBottom)
    {
        CGRect tmpFrame = self.frame;
        self.frame = CGRectMake( self.frame.origin.x, view.frame.size.height + 10, self.frame.size.width, self.frame.size.height);
        [UIView animateWithDuration:timeAppear delay:timeDelay options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.frame = tmpFrame;
            
        } completion:^(BOOL finished){
            [self didAppearAlertView];
        }];
        
    }
    else if (self.appearAnimationType == DQAlertViewAnimationTypeFlyLeft)
    {
        CGRect tmpFrame = self.frame;
        self.frame = CGRectMake( - self.frame.size.width - 10, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
        [UIView animateWithDuration:timeAppear delay:timeDelay options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.frame = tmpFrame;
            
        } completion:^(BOOL finished){
            [self didAppearAlertView];
        }];
        
    }
    else if (self.appearAnimationType == DQAlertViewAnimationTypeFlyRight)
    {
        CGRect tmpFrame = self.frame;
        self.frame = CGRectMake(view.frame.size.width + 10, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
        [UIView animateWithDuration:timeAppear delay:timeDelay options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.frame = tmpFrame;
            
        } completion:^(BOOL finished){
            [self didAppearAlertView];
        }];
    }
    else if (self.appearAnimationType == DQAlertViewAnimationTypeNone)
    {
        [self didAppearAlertView];
    }
}

// Hide and dismiss the alert
- (void)dismiss
{
    NSTimeInterval timeDisappear = ( self.disappearTime > 0 ) ? self.disappearTime : .08;
    NSTimeInterval timeDelay = .02;
    
    if (self.disappearAnimationType == DQAlertViewAnimationTypeDefault) {
        self.transform = CGAffineTransformIdentity;
        [UIView animateWithDuration:timeDisappear delay:timeDelay options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.alpha = .0;
        } completion:^(BOOL finished){
            [self removeFromSuperview];
        }];
    }
    else if (self.disappearAnimationType == DQAlertViewAnimationTypeZoomOut )
    {
        self.transform = CGAffineTransformIdentity;
        [UIView animateWithDuration:timeDisappear delay:timeDelay options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.transform = CGAffineTransformMakeScale(0.01, 0.01);
            
        } completion:^(BOOL finished){
            [self removeFromSuperview];
        }];
    }
    else if (self.disappearAnimationType == DQAlertViewAnimationTypeFaceOut)
    {
        self.alpha = 1;
        [UIView animateWithDuration:timeDisappear delay:timeDelay options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.alpha = 0;
            
        } completion:^(BOOL finished){
            [self removeFromSuperview];
        }];
    }
    else if (self.disappearAnimationType == DQAlertViewAnimationTypeFlyTop)
    {
        [UIView animateWithDuration:timeDisappear delay:timeDelay options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.frame = CGRectMake(self.frame.origin.x, - self.frame.size.height - 10, self.frame.size.width, self.frame.size.height);
            
        } completion:^(BOOL finished){
            [self removeFromSuperview];
        }];
    }
    else if (self.disappearAnimationType == DQAlertViewAnimationTypeFlyBottom)
    {
        [UIView animateWithDuration:timeDisappear delay:timeDelay options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.frame = CGRectMake( self.frame.origin.x, self.superview.frame.size.height + 10, self.frame.size.width, self.frame.size.height);
            
        } completion:^(BOOL finished){
            [self removeFromSuperview];
        }];
    }
    else if (self.disappearAnimationType == DQAlertViewAnimationTypeFlyLeft)
    {
        [UIView animateWithDuration:timeDisappear delay:timeDelay options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.frame = CGRectMake( - self.frame.size.width - 10, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
            
        } completion:^(BOOL finished){
            [self removeFromSuperview];
        }];
    }
    else if (self.disappearAnimationType == DQAlertViewAnimationTypeFlyRight)
    {
        [UIView animateWithDuration:timeDisappear delay:timeDelay options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.frame = CGRectMake(self.superview.frame.size.width + 10, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
            
        } completion:^(BOOL finished){
            [self removeFromSuperview];
        }];
    }
    else if (self.disappearAnimationType == DQAlertViewAnimationTypeNone)
    {
        [self removeFromSuperview];
    }
    

    if (self.blackOpaqueView) {
        [UIView animateWithDuration:timeDisappear animations:^{
            self.blackOpaqueView.alpha = 0;
        } completion:^(BOOL finished) {
            [self.blackOpaqueView removeFromSuperview];
        }];
    }
}

#pragma mark - Setup the alert view

- (void)setContentView:(UIView *)contentView
{
    if ( ! self.title && ! self.message) {
        self.buttonHeight = 0;
    }
    self.alertContentView = contentView;
    
    hasContentView = YES;
    self.width = contentView.frame.size.width;
    self.height = contentView.frame.size.height + self.buttonHeight;
    
    contentView.frame = contentView.bounds;
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.width, self.height);
    [self addSubview:contentView];
}

- (UIView *)contentView
{
    return self.alertContentView;
}

- (void)setCenter:(CGPoint)center
{
    [super setCenter:center];
    
    hasModifiedFrame = YES;
}

- (void)setCustomFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    self.width = frame.size.width;
    self.height = frame.size.height;
    hasModifiedFrame = YES;

    [self calculateFrame];
}

- (void)calculateFrame
{
    BOOL hasButton = (self.cancelButtonTitle || self.otherButtonTitle);

    if ( ! hasContentView ) {
        if ( ! hasModifiedFrame )
        {
            UIFont * messageFont = self.messageLabel.font ? self.messageLabel.font : [UIFont systemFontOfSize:14];
            //Calculate label size
            //Calculate the expected size based on the font and linebreak mode of your label
            // FLT_MAX here simply means no constraint in height
            CGSize maximumLabelSize = CGSizeMake(self.width - self.messageLeftRightPadding * 2, FLT_MAX);
            //        CGSize expectedLabelSize = [self.message sizeWithFont:messageFont constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByWordWrapping];
            
            CGRect textRect = [self.message boundingRectWithSize:maximumLabelSize
                                                         options:NSStringDrawingUsesLineFragmentOrigin
                                                      attributes:@{NSFontAttributeName:messageFont}
                                                         context:nil];
            
            CGFloat messageHeight = textRect.size.height;
            
            CGFloat newHeight = messageHeight + self.titleHeight + self.buttonHeight + self.titleTopPadding + self.titleBottomPadding + self.messageBottomPadding;
            self.height = newHeight;
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.height);
            
        }
        
        
        if ( ! self.title ) {
            titleLabelFrame = CGRectZero;
        } else {
            titleLabelFrame = CGRectMake(self.messageLeftRightPadding,
                                         self.titleTopPadding,
                                         self.width - self.messageLeftRightPadding * 2,
                                         self.titleHeight);
        }
        if ( ! self.message ) {
            messageLabelFrame = CGRectZero;
        } else if (hasButton) {
            messageLabelFrame = CGRectMake(self.messageLeftRightPadding,
                                           titleLabelFrame.origin.y + titleLabelFrame.size.height + self.titleBottomPadding,
                                           self.width - self.messageLeftRightPadding * 2,
                                           self.height - self.buttonHeight - titleLabelFrame.size.height - self.titleTopPadding - self.titleBottomPadding);
        } else {
            messageLabelFrame = CGRectMake(self.messageLeftRightPadding,
                                           titleLabelFrame.origin.y +  titleLabelFrame.size.height + self.titleBottomPadding,
                                           self.width - self.messageLeftRightPadding * 2,
                                           self.height - titleLabelFrame.size.height - self.titleTopPadding - self.titleBottomPadding);
        }
        
        if ( ! self.title || self.title.length == 0 ) {
            messageLabelFrame = CGRectMake(self.messageLeftRightPadding, 0, self.width - self.messageLeftRightPadding * 2, self.height - self.buttonHeight);
        }

    }
    
    
    if ( self.hideSeperator || ! hasButton ) {
        verticalSeperatorFrame = CGRectZero;
        horizontalSeperatorFrame = CGRectZero;
    } else {
        verticalSeperatorFrame = CGRectMake(self.width / 2,
                                            self.height - self.buttonHeight,
                                            0.5,
                                            self.buttonHeight);
        
        horizontalSeperatorFrame = CGRectMake(0,
                                              self.height - self.buttonHeight,
                                              self.width,
                                              0.5);
    }
    
    if ( ! self.cancelButtonTitle ) {
        cancelButtonFrame = CGRectZero;
    } else if ( ! self.otherButtonTitle ) {
        verticalSeperatorFrame = CGRectZero;
        cancelButtonFrame = CGRectMake(0,
                                       self.height - self.buttonHeight,
                                       self.width,
                                       self.buttonHeight);
    } else if ( ! self.cancelButtonPositionRight ) {
        cancelButtonFrame = CGRectMake(0,
                                       self.height - self.buttonHeight,
                                       self.width / 2,
                                       self.buttonHeight);
    } else {
        cancelButtonFrame = CGRectMake(self.width / 2,
                                       self.height - self.buttonHeight,
                                       self.width / 2,
                                       self.buttonHeight);
    }
    
    if ( ! self.otherButtonTitle ) {
        otherButtonFrame = CGRectZero;
    } else if ( ! self.cancelButtonTitle ) {
        verticalSeperatorFrame = CGRectZero;
        otherButtonFrame = CGRectMake(0,
                                      self.height - self.buttonHeight,
                                      self.width,
                                      self.buttonHeight);
    } else if ( ! self.cancelButtonPositionRight ) {
        otherButtonFrame = CGRectMake(self.width / 2,
                                      self.height - self.buttonHeight,
                                      self.width / 2,
                                      self.buttonHeight);
    } else {
        otherButtonFrame = CGRectMake(0,
                                      self.height - self.buttonHeight,
                                      self.width / 2,
                                      self.buttonHeight);
    }
    
    if ( ! self.otherButtonTitle && ! self.cancelButtonTitle) {
        cancelButtonFrame = CGRectZero;
        otherButtonFrame = CGRectZero;
        
        self.height = self.height - self.buttonHeight;
        self.buttonHeight = 0;
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.height);
    }

}

- (void)setupItems
{
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.messageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.otherButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    // Setup Title Label
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    self.titleLabel.text = self.title;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    
    // Setup Message Label
    self.messageLabel.numberOfLines = 0;
    self.messageLabel.font = [UIFont systemFontOfSize:13];
    self.messageLabel.text = self.message;
    self.messageLabel.textAlignment = NSTextAlignmentCenter;
    self.messageLabel.textColor = [UIColor blackColor];
    self.messageLabel.backgroundColor = [UIColor clearColor];
    
    //Setup Cancel Button
    self.cancelButton.backgroundColor = [UIColor clearColor];
    [self.cancelButton setTitleColor:[UIColor colorWithRed:0 green:0.478431 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    self.cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [self.cancelButton setTitle:self.cancelButtonTitle forState:UIControlStateNormal];
    [self.cancelButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [self.cancelButton addTarget:self action:@selector(cancelButtonTouchBegan:) forControlEvents:UIControlEventTouchDragInside];
//    [self.cancelButton addTarget:self action:@selector(cancelButtonTouchEnded:) forControlEvents:UIControlEventTouchDragOutside];

    //Setup Other Button
    self.otherButton.backgroundColor = [UIColor clearColor];
    [self.otherButton setTitleColor:[UIColor colorWithRed:0 green:0.478431 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    self.otherButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.otherButton setTitle:self.otherButtonTitle forState:UIControlStateNormal];
    [self.otherButton addTarget:self action:@selector(otherButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [self.otherButton addTarget:self action:@selector(otherButtonTouchBegan:) forControlEvents:UIControlEventTouchDragInside];
//    [self.otherButton addTarget:self action:@selector(otherButtonTouchEnded:) forControlEvents:UIControlEventTouchDragOutside];
    
    //Set up Seperator
    self.horizontalSeparator = [[UIView alloc] initWithFrame:CGRectZero];
    self.verticalSeparator = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)setupViews
{
    // Setup Background
    if (self.backgroundImage) {
        [self setBackgroundColor:[UIColor colorWithPatternImage:self.backgroundImage]];
    } else if (self.backgroundColor) {
        [self setBackgroundColor:self.backgroundColor];
    } else {
        [self setBackgroundColor:[UIColor colorWithRed:246.0/255 green:246.0/25 blue:246.0/25 alpha:1.0]];
    }
    
    if (self.borderWidth) {
        self.layer.borderWidth = self.borderWidth;
    }
    if (self.borderColor) {
        self.layer.borderColor = self.borderColor.CGColor;
    } else {
        self.layer.borderColor = [UIColor clearColor].CGColor;
    }
    
    self.layer.cornerRadius = self.cornerRadius;
    
    // Set Frame
    self.titleLabel.frame = titleLabelFrame;
    self.messageLabel.frame = messageLabelFrame;
    self.cancelButton.frame = cancelButtonFrame;
    self.otherButton.frame = otherButtonFrame;
    
    self.horizontalSeparator.frame = horizontalSeperatorFrame;
    self.verticalSeparator.frame = verticalSeperatorFrame;
    
    if (self.separatorColor) {
        self.horizontalSeparator.backgroundColor = self.separatorColor;
        self.verticalSeparator.backgroundColor = self.separatorColor;
    } else {
        self.horizontalSeparator.backgroundColor = [UIColor colorWithRed:196.0/255 green:196.0/255 blue:201.0/255 alpha:1.0];
        self.verticalSeparator.backgroundColor = [UIColor colorWithRed:196.0/255 green:196.0/255 blue:201.0/255 alpha:1.0];
    }
    
    // Make the message fits to it bounds
    if ( self.title ) {
        [self.messageLabel sizeToFit];
        CGRect myFrame = self.messageLabel.frame;
        myFrame = CGRectMake(myFrame.origin.x, myFrame.origin.y, self.width -  2 * self.messageLeftRightPadding, myFrame.size.height);
        self.messageLabel.frame = myFrame;
    }

    // Add subviews
    if ( ! hasContentView) {
        [self addSubview:self.titleLabel];
        [self addSubview:self.messageLabel];
    }

    [self addSubview:self.cancelButton];
    [self addSubview:self.otherButton];
    [self addSubview:self.horizontalSeparator];
    [self addSubview:self.verticalSeparator];
}


#pragma mark - Touch Event

- (void)cancelButtonTouchBegan:(id)sender
{
    self.originCancelButtonColor = [self.cancelButton.backgroundColor colorWithAlphaComponent:0];
    self.cancelButton.backgroundColor = [self.cancelButton.backgroundColor colorWithAlphaComponent:.1];
}

- (void)cancelButtonTouchEnded:(id)sender
{
    self.cancelButton.backgroundColor = self.originCancelButtonColor;
}

- (void)otherButtonTouchBegan:(id)sender
{
    self.originOtherButtonColor = [self.otherButton.backgroundColor colorWithAlphaComponent:0];
    self.otherButton.backgroundColor = [self.otherButton.backgroundColor colorWithAlphaComponent:.1];
}

- (void)otherButtonTouchEnded:(id)sender
{
    self.otherButton.backgroundColor = self.originOtherButtonColor;
}


#pragma mark - Actions

- (void)actionWithBlocksCancelButtonHandler:(void (^)(void))cancelHandler otherButtonHandler:(void (^)(void))otherHandler
{
    self.cancelButtonAction = cancelHandler;
    self.otherButtonAction = otherHandler;
}

- (void)cancelButtonClicked:(id)sender
{
    if (self.buttonClickedHighlight)
    {
        UIColor * originColor = [self.cancelButton.backgroundColor colorWithAlphaComponent:0];
        self.cancelButton.backgroundColor = [self.cancelButton.backgroundColor colorWithAlphaComponent:.1];
        double delayInSeconds = .2;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            self.otherButton.backgroundColor = originColor;
        });
        
    }

    [self dismiss];
    
    if (self.cancelButtonAction) {
        self.cancelButtonAction();
    }
    
    if ([self.delegate respondsToSelector:@selector(cancelButtonClickedOnAlertView:)]) {
        [self.delegate cancelButtonClickedOnAlertView:self];
    }
}

- (void)otherButtonClicked:(id)sender
{
    if (self.buttonClickedHighlight)
    {
        UIColor * originColor = [self.otherButton.backgroundColor colorWithAlphaComponent:0];
        self.otherButton.backgroundColor = [self.otherButton.backgroundColor colorWithAlphaComponent:.1];
        double delayInSeconds = .2;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            self.otherButton.backgroundColor = originColor;
        });
    }
    
    if (self.shouldDismissOnActionButtonClicked) {
        [self dismiss];
    }
    
    if (self.otherButtonAction) {
        self.otherButtonAction();
    }
    
    if ([self.delegate respondsToSelector:@selector(otherButtonClickedOnAlertView:)]) {
        [self.delegate otherButtonClickedOnAlertView:self];
    }
}

- (void)didAppearAlertView
{
    if ([self.delegate respondsToSelector:@selector(didAppearAlertView:)]) {
        [self.delegate didAppearAlertView:self];
    }
}

- (void)willAppearAlertView
{
    if ([self.delegate respondsToSelector:@selector(willAppearAlertView:)]) {
        [self.delegate willAppearAlertView:self];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
