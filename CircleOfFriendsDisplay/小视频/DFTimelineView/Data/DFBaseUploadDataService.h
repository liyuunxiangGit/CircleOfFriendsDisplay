//
//  DFBaseUploadDataService.h
//  coder
//
//  Created by Allen Zhong on 15/5/22.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "DFBaseDataService.h"

@interface DFBaseUploadDataService : DFBaseDataService

-(void) upload:(NSData *) data success:(RequestSuccess) success;

-(NSString *) getFileType;

@end
