//
//  RedefineDFVideoCaptureController.h

//

#import <UIKit/UIKit.h>

@protocol RedefineDFVideoCaptureControllerDelegate <NSObject>

@optional

-(void) onCaptureVideo:(NSString *) filePath screenShot:(UIImage *) screenShot;

@end

@interface RedefineDFVideoCaptureController : UIViewController

@property (nonatomic, assign) id<RedefineDFVideoCaptureControllerDelegate> delegate;

-(void) onCaptureVideo:(NSString *) filePath screenShot:(UIImage *) screenShot;

@end
