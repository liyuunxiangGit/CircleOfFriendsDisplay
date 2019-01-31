//
//  DFVideoPlayController.h
//
#import "DFBaseViewController.h"

@protocol DFVideoPreViewControllerDelegate <NSObject>

-(void)pressRetakeBtn:(NSString *)fileName;
-(void)PressSendBtn:(NSString *)fileName;

@end

@interface DFVideoPreViewController : DFBaseViewController

@property(nonatomic,strong)NSString *filePath;
@property(nonatomic,weak)id<DFVideoPreViewControllerDelegate> delegate;

-(instancetype)initWithFile:(NSString *) filePath;

@end
