//
//  ZoneReplyView.m


//

#import "ZoneReplyView.h"

@interface ZoneReplyView ()<UITextFieldDelegate>
@end

@implementation ZoneReplyView


- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _input.delegate = self;
    }
    return self;
}

- (IBAction)press_send:(id)sender {
    NSLog(@"发送");
    if (_input.text <= 0) {
        return;
    }
    
    if (_delegate != nil && [_delegate respondsToSelector:@selector(ZoneReplyView:onPressText:)]) {
        [_delegate ZoneReplyView:self onPressText:_input.text];
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (_input.text <= 0) {
        return YES;
    }
    
    if (_delegate != nil && [_delegate respondsToSelector:@selector(ZoneReplyView:onPressText:)]) {
        [_delegate ZoneReplyView:self onPressText:_input.text];
    }
    return YES;
}


@end
