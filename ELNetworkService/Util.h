//
//  Util.h
//  objectc_ehome
//
//  Created by admin on 14-10-15.
//  Copyright (c) 2014年 cn.lztech  合肥联正电子科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Util : NSObject
+(NSArray *)snAnalysis:(NSString *)sn;
+(BOOL)isMobileNumber:(NSString *)mobileNum;
+(BOOL)isEmail:(NSString *)_email;
+(BOOL)isCharacter:(NSString *)_str rangeMin:(NSInteger)_min andMax:(NSInteger)_max;
+(BOOL)isAgeNumber:(NSString *)_num;
+(BOOL)isDeviceSN:(NSString *)SN;
+(NSString *)getVeriCodeByClientSN:(NSString *)SN;

+(NSString *)encodeToPercentEscapeString: (NSString *) input;
+(NSString *)decodeFromPercentEscapeString: (NSString *) input;

+(NSString *)trim:(NSString *)_str;
+(BOOL)isEmpty:(NSString *)_str;

+(void)sendMsgToMobileNumber;
+(NSDate *)formatDateString:(NSString *)_dateStr;
+(NSString *)formatDateToString:(NSDate *)_date;
+(void)printFrameLog:(CGRect)frame withName:(NSString *)_name;

+(NSString *)getCharacterAndNumber:(NSInteger)length;

+(NSString *)encodeToBase64String:(UIImage *)image format:(NSString *)PNGorJPEG;
+(UIImage *)decodeBase64ToImage:(NSString *)strEncodeData;
+(Byte *)intToBytes:(NSInteger)_number;
+(NSInteger)bytesToInt:(Byte *)bytes withLength:(NSInteger)len;
+(BOOL)isNumberCharacterSet:(NSString *)string;
+(NSArray *)sortByLocId:(NSArray *)_locs;
@end
