//
//  DFVideoDecoder.h

//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@protocol DFVideoDecoderDelegate <NSObject>

@required

-(void) onDecodeFinished;

@end


@interface DFVideoDecoder : NSObject

@property (nonatomic, strong) CAKeyframeAnimation *animation;

@property (nonatomic, weak) id<DFVideoDecoderDelegate> delegate;


- (instancetype)initWithFile:(NSString *) filePath;

-(void) decode;

@end
