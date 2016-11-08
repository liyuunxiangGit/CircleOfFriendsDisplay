//
//  DFToolUtil.m
//  DFWeChatView
//
//  Created by Allen Zhong on 15/10/3.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "DFToolUtil.h"
#import <CommonCrypto/CommonDigest.h>

@implementation DFToolUtil


+(NSString *)md5:(NSString *)str
{
    if (str == nil) {
        return @"";
    }
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];

}
+(NSString *) md5WithVideoPath:(NSString*)path
{
    
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:path];
    
    if( handle== nil ) {
        
        return nil;
        
    }
    
    CC_MD5_CTX md5;
    
    CC_MD5_Init(&md5);
    
    BOOL done = NO;
    
    while(!done)
        
    {
        
        NSData* fileData = [handle readDataOfLength: 256 ];
        
        CC_MD5_Update(&md5, [fileData bytes], (CC_LONG)[fileData length]);
        
        if( [fileData length] == 0 ) done = YES;
        
    }
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5_Final(digest, &md5);
    
    NSString* s = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                   
                   digest[0], digest[1],
                   
                   digest[2], digest[3],
                   
                   digest[4], digest[5],
                   
                   digest[6], digest[7],
                   
                   digest[8], digest[9],
                   
                   digest[10], digest[11],
                   
                   digest[12], digest[13],
                   
                   digest[14], digest[15]];
    
    
    return s;
    
}


+(NSString *)preettyTime:(long long)ts
{
    //原有时间
    NSString *firstDateStr=[DFToolUtil FormatTime:@"yyyy-MM-dd" timeInterval:ts];
    NSArray *firstDateStrArr=[firstDateStr componentsSeparatedByString:@"-"];
    
    //现在时间
    NSDate *now = [NSDate date];
    NSDateComponents *componentsNow = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:now];
    NSString *nowDateStr = [NSString stringWithFormat:@"%ld-%ld-%ld", (long)[componentsNow year], (long)[componentsNow month], (long)[componentsNow day]];
    NSArray *nowDateStrArr = [nowDateStr componentsSeparatedByString:@"-"];
    
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:ts/1000];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    
    //同年
    if ([firstDateStrArr[0] intValue] == [nowDateStrArr[0] intValue]){
        
        //当天
        if( [firstDateStrArr[1] intValue] == [nowDateStrArr[1] intValue] && [nowDateStrArr[2] intValue]== [firstDateStrArr[2] intValue]){
            [dateformatter setDateFormat:@"HH:mm"];
            return [NSString stringWithFormat:@"%@", [dateformatter stringFromDate:date]];
        }
        
        //昨天
        if( [firstDateStrArr[1] intValue]==[nowDateStrArr[1] intValue] && ([nowDateStrArr[2] intValue]-[firstDateStrArr[2] intValue]==1)){
            [dateformatter setDateFormat:@"HH:mm"];
            return [NSString stringWithFormat:@"昨天 %@", [dateformatter stringFromDate:date]];
            
        }else{//昨天之前
            [dateformatter setDateFormat:@"MM-dd HH:mm"];
            return  [dateformatter stringFromDate:date];
        }
        
    }else{
        [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        return [dateformatter stringFromDate:date];
    }

}

+ (NSString *)FormatTime:(NSString *)format timeInterval:(double)value;
{
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:value / 1000];
    [dateformatter setDateFormat:format];
    return [dateformatter stringFromDate:date];
}

@end
