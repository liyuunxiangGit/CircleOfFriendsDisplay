DQAlertView
===========

The best iOS customizable AlertView.

DQAlertView is the best alternative for UIKit's UIAlertView.
With DQAlertView, you can easily make your desired Alert View in some lines of code.

![](https://dl.dropboxusercontent.com/u/61390634/DQAlertViewPhoto/sm1.png)      ..![](https://dl.dropboxusercontent.com/u/61390634/DQAlertViewPhoto/sm2.png)
..![](https://dl.dropboxusercontent.com/u/61390634/DQAlertViewPhoto/sm3.png)
..![](https://dl.dropboxusercontent.com/u/61390634/DQAlertViewPhoto/sm4.png)

## Getting started

#### Using CocoaPods
Just add the following line in to your pod file:
```
pod 'DQAlertView', '~> 1.1.1'
```
#### Manually
Drag and drop the subfolder named ```DQAlertView``` in your project and you are done.

#### What's new ?
- v1.1.0:  New feature: Customize alert by custom content view
- v1.2.0:  The DQAlertView default appearance is exactly same as UIAlertView

## Feature

With the DQAlertView, you can easily:

- Customize alert appearance: custom frame, background color or background image, border corner, border radius
- Customize title font, color, position
- Customize message font, color, position
- Customize buttons font, color, position
- Customize separator color, hidden or not
- Customize alert appear behaviour and disappear behaviour
- Customize alert by custom content view
- Callbacks and blocks for appearance or button touching event
- And much more ...

## Usage

#### Initilization

Set the title to nil to make the alert be no title.
Remove button by set its title to nil

```objective-c
// Initialize same as UIAlertView
DQAlertView * alertView = [[DQAlertView alloc] initWithTitle:@"Title" message:@"Sample Message" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK"];

// or
DQAlertView * alertView = [[DQAlertView alloc] initWithTitle:@"Title" message:@"Sample Message" cancelButtonTitle:@"Cancel" otherButtonTitle:@"OK"];
```

#### Show and dismiss

```objective-c
// Show in specified view
// If the custom frame has not been set, the alert will be shown at the center of the view
- (void)showInView:(UIView *)view;

// Show in window
// Always show at center
- (void)show;

// Dismiss the alert
- (void)dismiss;

```

#### Button touching event handler

```objective-c

alertView.cancelButtonAction = ^{
    NSLog(@"Cancel Clicked");
};
alertView.otherButtonAction = ^{
    NSLog(@"OK Clicked");
};
    
//    // You can also use:
//    [alertView actionWithBlocksCancelButtonHandler:^{
//        NSLog(@"Cancel Clicked");
//    } otherButtonHandler:^{
//        NSLog(@"OK Clicked");
//    }];
    
```

If you don't want to use blocks, implement ```<DQAlertViewDelegate>``` and use delegate methods:

```objective-c

alertView.delegate = self;

- (void)willAppearAlertView:(DQAlertView *)alertView
{
    NSLog(@"Alert View Will Appear");
}

- (void)didAppearAlertView:(DQAlertView *)alertView
{
    NSLog(@"Alert View Did Appear");
}

- (void)cancelButtonClickedOnAlertView:(DQAlertView *)alertView {
    NSLog(@"Cancel Clicked");
}

- (void)otherButtonClickedOnAlertView:(DQAlertView *)alertView {
    NSLog(@"OK Clicked");
}

```
#### Customization

DQAlertView can be customized with the following properties:

```objective-c

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

```

## Contributing
Contributions for bug fixing or improvements are welcomed. Feel free to submit a pull request.
If you have any questions, feature suggestions or bug reports, please send me an email to dinhquan191@gmail.com.


