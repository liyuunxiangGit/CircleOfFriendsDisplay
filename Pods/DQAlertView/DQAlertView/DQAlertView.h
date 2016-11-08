//
//  DQAlertView.h
//
//  Version 0.1
//
//  Created by Dinh Quan on 1/27/14.
//  Copyright (c) 2014 Dinh Quan. All rights reserved.
//
// This code is distributed under the terms and conditions of the MIT license.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


#import <UIKit/UIKit.h>


@protocol DQAlertViewDelegate;

typedef enum
{
    DQAlertViewAnimationTypeNone        = 0,
    DQAlertViewAnimationTypeDefault     = 1,
    DQAlertViewAnimationTypeFadeIn      = 2,
    DQAlertViewAnimationTypeFaceOut     = 3,
    DQAlertViewAnimationTypeFlyTop      = 4,
    DQAlertViewAnimationTypeFlyBottom   = 5,
    DQAlertViewAnimationTypeFlyLeft     = 6,
    DQAlertViewAnimationTypeFlyRight    = 7,
    DQAlertViewAnimationTypeZoomIn      = 8,
    DQAlertViewAnimationTypeZoomOut     = 9
    
} DQAlertViewAnimationType;

typedef void (^DQAlertViewBlock)(void);

@interface DQAlertView : UIView

#pragma mark - Public Properties

// Set the custom frame for the Alert View, if this property has not been set the Alert will be shown at center of the view. Don't use the default method [UIView setFrame:]
@property (nonatomic, assign) CGRect customFrame; // Default is same as UIAlertView


// Set the content view for the Alert View
// The frame of alert view will be resized based on the frame of content view, so you don't have to set the custom frame. If you want the alert view not shown at center, just set the center of the Alert View
@property (nonatomic, strong) UIView *contentView;


// You can get buttons and labels for customizing their appearance
@property (nonatomic, strong) UIButton * cancelButton; // Default is in blue color and system font 16
@property (nonatomic, strong) UIButton * otherButton; // Default is in blue color and system font 16
@property (nonatomic, strong) UILabel * titleLabel; // Default is in black color and system bold font 16
@property (nonatomic, strong) UILabel * messageLabel; // Default is in gray color and system font 14


// Set the height of title and button; and the padding of elements. The message label height is calculated based on its text and font.
@property (nonatomic, assign) CGFloat buttonHeight; // Default is 44
@property (nonatomic, assign) CGFloat titleHeight; // Default is 34

@property (nonatomic, assign) CGFloat titleTopPadding; //Default is 14
@property (nonatomic, assign) CGFloat titleBottomPadding; // Default is 2
@property (nonatomic, assign) CGFloat messageBottomPadding; // Default is 20
@property (nonatomic, assign) CGFloat messageLeftRightPadding; // Default is 20


// Customize the background and border
@property (nonatomic, strong) UIColor * borderColor; // Default is no border
@property (nonatomic, assign) CGFloat borderWidth; // Default is 0
@property (nonatomic, assign) CGFloat cornerRadius; // Default is 8
// inherits from UIView @property (nonatomic, strong) UIColor * backgroundColor; // Default is same as UIAlertView
@property (nonatomic, strong) UIImage * backgroundImage; // Default is nil


// Customize the seperator
@property (nonatomic, assign) BOOL hideSeperator; // Default is NO
@property (nonatomic, strong) UIColor * separatorColor; // Default is same as UIAlertView


// Customize the appearing and disappearing animations
@property (nonatomic, assign) DQAlertViewAnimationType appearAnimationType;
@property (nonatomic, assign) DQAlertViewAnimationType disappearAnimationType;
@property (nonatomic, assign) NSTimeInterval appearTime; // Default is 0.2
@property (nonatomic, assign) NSTimeInterval disappearTime; // Default is 0.1


// Make the cancel button appear on the right by setting this to YES
@property (nonatomic, assign) BOOL cancelButtonPositionRight; // Default is NO

// Disable the button highlight by setting this property to NO
@property (nonatomic, assign) BOOL buttonClickedHighlight; //Default is YES

// By default the alert will not dismiss if clicked to other button, set this property to YES to change the behaviour
@property (nonatomic, assign) BOOL shouldDismissOnActionButtonClicked; //Default is YES

// If this property is YES, the alert will dismiss when you click on outside (only when dim background is enable)
@property (nonatomic, assign) BOOL shouldDismissOnOutsideTapped; //Default is NO

// When shown in window, the dim background is always enable
@property (nonatomic, assign) BOOL shouldDimBackgroundWhenShowInWindow; //Default is YES

// When shown in view, the dim background is always disable
@property (nonatomic, assign) BOOL shouldDimBackgroundWhenShowInView; //Default is NO

// The default color of dim background is black color with alpha 0.2
@property (nonatomic, assign) CGFloat dimAlpha; //Default is same as UIAlertView

// Delegate
@property (nonatomic, strong) id<DQAlertViewDelegate> delegate;

// Handle the button touching event
@property (readwrite, copy) DQAlertViewBlock cancelButtonAction;
@property (readwrite, copy) DQAlertViewBlock otherButtonAction;


#pragma mark - Public Methods

// Initialize method, same as UIAlertView
// On the current version, the alert does not support more than one other buttons
// If you pass the title by nil, the alert will be no title. If you pass the otherButtonTitle by nil, the alert will only have cancel button. You can remove all buttons by set all buton titles to nil.
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id /*<DQAlertViewDelegate>*/)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...;

// Initialize convenience method
// If you pass the title by nil, the alert will be no title. If you pass the otherButtonTitle by nil, the alert will only have cancel button. You can remove all buttons by set all buton titles to nil.
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitle:(NSString *)otherButtonTitle;


// You can use this methods instead of calling these properties:
// @property (readwrite, copy) DQAlertViewBlock cancelButtonAction;
// @property (readwrite, copy) DQAlertViewBlock otherButtonAction;
- (void)actionWithBlocksCancelButtonHandler:(void (^)(void))cancelHandler otherButtonHandler:(void (^)(void))otherHandler;


// Show in specified view
// If the custom frame has not been set, the alert will be shown at the center of the view
- (void)showInView:(UIView *)view;


// Show in window
// If the custom frame has not been set, the alert will be shown at the center of the window
- (void)show;


// Dismiss the alert
- (void)dismiss;

@end

// DQAlertViewDelegate
@protocol DQAlertViewDelegate <NSObject>

@optional
- (void)willAppearAlertView:(DQAlertView *)alertView;
- (void)didAppearAlertView:(DQAlertView *)alertView;

- (void)cancelButtonClickedOnAlertView:(DQAlertView *)alertView;
- (void)otherButtonClickedOnAlertView:(DQAlertView *)alertView;

@end
