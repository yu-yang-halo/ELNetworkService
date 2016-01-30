//
//  Util.m
//  objectc_ehome
//
//  Created by admin on 14-10-15.
//  Copyright (c) 2014年 cn.lztech  合肥联正电子科技有限公司. All rights reserved.
//

#import "Util.h"
#import "ELClass.h"
#import "ELShareContext.h"
#import "WsqMD5Util.h"
#import "ElApiService.h"
static NSString* snFlags[]={
    @"1001",@"1011",@"1012",@"1013",@"1014",@"1015",@"1016",@"1017",
    @"1018",@"1019",@"101A",@"101B",@"101C",@"101D",@"101E",@"101F",
    @"1022",@"1023",@"1024",@"1025",@"1026",@"1027",@"1028",@"1201",
    @"102A",@"102C"
};
@implementation Util
+(NSArray *)snAnalysis:(NSString *)sn{
    NSMutableArray *nameClassIds=[[[NSMutableArray alloc] init] autorelease];
   if(sn.length>=11){

    NSString *snFlag=[sn substringWithRange:(NSMakeRange(7,4))];
   
    if([snFlag isEqualToString:snFlags[0]]){
        [nameClassIds addObject:@"网关"];
        [nameClassIds addObject:[NSString stringWithFormat:@"%d",ELDEVICECLASSTYPE_GATEWAY]];
    }else if([snFlag isEqualToString:snFlags[1]]){
        [nameClassIds addObject:@"门磁"];
        [nameClassIds addObject:[NSString stringWithFormat:@"%d",ELDEVICECLASSTYPE_DOORSENSOR]];
    }else if([snFlag isEqualToString:snFlags[2]]){
        [nameClassIds addObject:@"智能计量插座"];
        [nameClassIds addObject:[NSString stringWithFormat:@"%d",ELDEVICECLASSTYPE_POWERMET]];
    }else if([snFlag isEqualToString:snFlags[3]]){
        [nameClassIds addObject:@"空调"];
        [nameClassIds addObject:[NSString stringWithFormat:@"%d",ELDEVICECLASSTYPE_AC]];
    }else if([snFlag isEqualToString:snFlags[4]]){
        [nameClassIds addObject:@"红外温度感应器"];
        [nameClassIds addObject:[NSString stringWithFormat:@"%d",ELDEVICECLASSTYPE_ELMOTIONDET]];
    }else if([snFlag isEqualToString:snFlags[5]]){
        [nameClassIds addObject:@"烟雾报警器"];
        [nameClassIds addObject:[NSString stringWithFormat:@"%d",ELDEVICECLASSTYPE_SMOKEDETECTOR]];
    }else if([snFlag isEqualToString:snFlags[6]]){
        [nameClassIds addObject:@"血压计"];
        [nameClassIds addObject:[NSString stringWithFormat:@"%d",ELDEVICECLASSTYPE_BPMONITOR]];
    }else if([snFlag isEqualToString:snFlags[7]]){
        [nameClassIds addObject:@"视频监控器"];
        [nameClassIds addObject:[NSString stringWithFormat:@"%d",ELDEVICECLASSTYPE_IPCAMERA]];
    }else if([snFlag isEqualToString:snFlags[8]]){
        [nameClassIds addObject:@"远程电源开关"];
        [nameClassIds addObject:[NSString stringWithFormat:@"%d",ELDEVICECLASSTYPE_POWERCTRL]];
    }else if([snFlag isEqualToString:snFlags[9]]){
        [nameClassIds addObject:@"CO报警器"];
        [nameClassIds addObject:[NSString stringWithFormat:@"%d",ELDEVICECLASSTYPE_CODETECTOR]];
    }else if([snFlag isEqualToString:snFlags[11]]){
        [nameClassIds addObject:@"窗帘"];
        [nameClassIds addObject:[NSString stringWithFormat:@"%d",ELDEVICECLASSTYPE_CURTAIN]];
    }else if([snFlag isEqualToString:snFlags[12]]){
        [nameClassIds addObject:@"投影仪幕"];
        [nameClassIds addObject:[NSString stringWithFormat:@"%d",ELDEVICECLASSTYPE_PROJECTORSCREEN]];
    }else if([snFlag isEqualToString:snFlags[13]]){
        [nameClassIds addObject:@"紧急按钮"];
        [nameClassIds addObject:[NSString stringWithFormat:@"%d",ELDEVICECLASSTYPE_EMERGENCYBUTTON]];
    }else if([snFlag isEqualToString:snFlags[14]]){
        [nameClassIds addObject:@"煤气报警器"];
        [nameClassIds addObject:[NSString stringWithFormat:@"%d",ELDEVICECLASSTYPE_GASDETECTOR]];
    }else if([snFlag isEqualToString:snFlags[15]]){
        [nameClassIds addObject:@"墙壁插座"];
        [nameClassIds addObject:[NSString stringWithFormat:@"%d",ELDEVICECLASSTYPE_WALLPOWERCTRL]];
    }else if([snFlag isEqualToString:snFlags[16]]){
        [nameClassIds addObject:@"墙壁开关"];
        [nameClassIds addObject:[NSString stringWithFormat:@"%d",ELDEVICECLASSTYPE_WALLSWITCH]];
    }else if([snFlag isEqualToString:snFlags[17]]){
        [nameClassIds addObject:@"水浸报警器"];
        [nameClassIds addObject:[NSString stringWithFormat:@"%d",ELDEVICECLASSTYPE_WATERDETECTOR]];
    }else if([snFlag isEqualToString:snFlags[18]]){
        [nameClassIds addObject:@"温湿度传感器"];
        [nameClassIds addObject:[NSString stringWithFormat:@"%d",ELDEVICECLASSTYPE_TEMPHUMISENSOR]];
    }else if([snFlag isEqualToString:snFlags[20]]){
        [nameClassIds addObject:@"场景控制开关"];
        [nameClassIds addObject:[NSString stringWithFormat:@"%d",ELDEVICECLASSTYPE_SCENARIOSWITCH]];
    }else if([snFlag isEqualToString:snFlags[21]]){
        [nameClassIds addObject:@"温控器"];
        [nameClassIds addObject:[NSString stringWithFormat:@"%d",ELDEVICECLASSTYPE_THERMOSTAT]];
    }else if([snFlag isEqualToString:snFlags[22]]){
        [nameClassIds addObject:@"明火报警器"];
        [nameClassIds addObject:[NSString stringWithFormat:@"%d",ELDEVICECLASSTYPE_FIREDETECTOR]];
    }else if([snFlag isEqualToString:snFlags[24]]){
        [nameClassIds addObject:@"空调风机控制器"];
        [nameClassIds addObject:[NSString stringWithFormat:@"%d",ELDEVICECLASSTYPE_ACFAN]];
    }else if([snFlag isEqualToString:snFlags[25]]){
        [nameClassIds addObject:@"红外转发器"];
        [nameClassIds addObject:[NSString stringWithFormat:@"%d",ELDEVICECLASSTYPE_REPEATER]];
    }
   }
//    NSLog(@"sn analysis -> %@ : %@",nameClassIds[0],nameClassIds[1]);
    return nameClassIds;
}
+(BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    //@"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    NSString * MOBILE = @"\\d{11}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
+(BOOL)isEmail:(NSString *)_email{
    NSString *_EM=@"^([a-z0-9A-Z]+[-|._]?)+[a-z0-9A-Z]@([a-z0-9A-Z]+(-[a-z0-9A-Z]+)?.)+[a-zA-Z]{2,}$";
    //^[a-zA-Z][a-zA-Z0-9_.-]*@[0-9a-zA-Z]+(.[a-zA-Z]+)+$
    NSPredicate *regexEmail = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", _EM];
    
    if ([regexEmail evaluateWithObject:_email] == YES){
        return YES;
    }else{
        return NO;
    }
}
+(BOOL)isAgeNumber:(NSString *)_num{
    NSString *_EM=@"^[1]{0,1}[1-9][0-9]$";
    //^[a-zA-Z][a-zA-Z0-9_.-]*@[0-9a-zA-Z]+(.[a-zA-Z]+)+$
    NSPredicate *regexEmail = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", _EM];
    
    if ([regexEmail evaluateWithObject:_num] == YES){
        return YES;
    }else{
        return NO;
    }
}
+(NSString *)getVeriCodeByClientSN:(NSString *)SN{
    NSString *md5SN=[WsqMD5Util getmd5WithString:SN];
    ;
    NSString *responseData=[NSString stringWithFormat:@"%c%c%c",[md5SN characterAtIndex:4],[md5SN characterAtIndex:9],[md5SN characterAtIndex:13]];
    return [responseData lowercaseString];
}
+(BOOL)isDeviceSN:(NSString *)SN{
    NSString *_EM=@"^[A-Z0-9]{6,}$";
    NSPredicate *regexEmail = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", _EM];
    
    if ([regexEmail evaluateWithObject:SN] == YES){
        return YES;
    }else{
        return NO;
    }
}
+(BOOL)isCharacter:(NSString *)_str rangeMin:(NSInteger)_min andMax:(NSInteger)_max{
    NSString *_CHAR=[NSString stringWithFormat:@"^\\w{%d,%d}$",_min,_max] ;
    NSPredicate *regexChar = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", _CHAR];
    if ([regexChar evaluateWithObject:_str] == YES){
        return YES;
    }else{
        return NO;
    }
}
+(BOOL)isEmpty:(NSString *)_str{
    if(_str==nil){
        return YES;
    }
    return [[_str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""];
}
+(NSString *)trim:(NSString *)_str{
    return [[_str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] stringByReplacingOccurrencesOfString:@" " withString:@""];
}
+(void)sendMsgToMobileNumber{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *_mobileNumber=[ELShareContext defaultContext].mobileNumber;
        NSLog(@"发送到手机号： %@",_mobileNumber);
        BOOL sendYN=[[ElApiService shareElApiService] sendShortMsgCodeByUser:_mobileNumber withType:SHORT_MESSAGE_TYPE_VCODE];
        dispatch_async(dispatch_get_main_queue(), ^{
            if(!sendYN){
                //[OMGToast showWithText:@"短信发送失败"];
            }
        });
    });
}
+(NSString *)encodeToPercentEscapeString: (NSString *) input
{
    // Encode all the reserved characters, per RFC 3986
    // (<http://www.ietf.org/rfc/rfc3986.txt>)
    NSString *outputStr = (NSString *)
    CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                            (CFStringRef)input,
                                            NULL,
                                            (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                            kCFStringEncodingUTF8);
    return outputStr;
}

+(NSString *)decodeFromPercentEscapeString: (NSString *) input
{
    NSMutableString *outputStr = [NSMutableString stringWithString:input];
    [outputStr replaceOccurrencesOfString:@"+"
                               withString:@" "
                                  options:NSLiteralSearch
                                    range:NSMakeRange(0, [outputStr length])];
    
    return [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
+(NSDate *)formatDateString:(NSString *)_dateStr{
    NSDateFormatter* formater = [[[NSDateFormatter alloc] init] autorelease];
    [formater setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    NSLocale *locale = [[[NSLocale alloc] initWithLocaleIdentifier:@"zh-Hans"] autorelease];
    [formater setLocale:locale];
    [formater setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'+08:00'"];
    
    NSDate* date = [formater dateFromString:_dateStr];
    return date;
}
+(NSString *)getCharacterAndNumber:(NSInteger)length{
    NSMutableString *val=[[[NSMutableString alloc] init] autorelease];
    for(int i=0;i<length;i++){
        /*
        NSString *charOrNum=arc4random()%2==0?@"char":@"num";
        if([charOrNum isEqualToString:@"char"]){
            int choice=arc4random()%2==0?65:97;
            [val appendFormat:@"%c",choice+arc4random()%26];
            
        }else if([charOrNum isEqualToString:@"num"]){
            [val appendFormat:@"%d",arc4random()%10];
        }*/
        [val appendFormat:@"%d",arc4random()%10];
    }
    return val;
}

+(NSString *)formatDateToString:(NSDate *)_date{
    NSDateFormatter* formater = [[[NSDateFormatter alloc] init] autorelease];
    [formater setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    NSLocale *locale = [[[NSLocale alloc] initWithLocaleIdentifier:@"zh-Hans"] autorelease];
    [formater setLocale:locale];
    
    [formater setDateFormat:@"MM-dd HH:mm:ss"];
    
    NSString *dateStr=[formater stringFromDate:_date];
    return dateStr;
}
+(void)printFrameLog:(CGRect)frame withName:(NSString *)_name{
    NSLog(@"[%@] x:%f,y:%f,h:%f,w:%f",_name,frame.origin.x,frame.origin.y,frame.size.height,frame.size.width);
}
+(NSString *)encodeToBase64String:(UIImage *)image format:(NSString *)PNGorJPEG{
    if([PNGorJPEG isEqualToString:@"PNG"]){
        return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    }else{
        return [UIImageJPEGRepresentation(image,0) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    }
    
}
+(UIImage *)decodeBase64ToImage:(NSString *)strEncodeData{
    NSData *data=[[NSData alloc] initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}
+(Byte *)intToBytes:(NSInteger)_number{
    Byte* bArr;
    for (int i=0;i<4;i++) {
        bArr[i]=_number>>(4-i-1)*8&0xFF;
    }
    return bArr;
}
+(NSInteger)bytesToInt:(Byte *)bytes withLength:(NSInteger)len{
    NSInteger _numbers=0;
    for (int i=0;i<len;i++) {
        _numbers+=(bytes[i]<<(len-i-1)*8)&[Util hexWithbits:(len-i)];
    }
    return _numbers;
}
+(NSInteger)hexWithbits:(NSInteger)bits{
    NSInteger hex_num=0;
    switch (bits) {
        case 4:
            hex_num=0xFF000000;
            break;
        case 3:
            hex_num=0xFF0000;
            break;
        case 2:
            hex_num=0xFF00;
            break;
        case 1:
            hex_num=0xFF;
            break;
    }
    return hex_num;
}
+(BOOL)isNumberCharacterSet:(NSString *)string{
    if(string==nil){
        return NO;
    }
    string=[string stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(string.length>0){
        return NO;
    }
    return YES;
}
#pragma mark sort by locID 大小排序
+(NSArray *)sortByLocId:(NSArray *)_locs{
    return  [_locs sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if([[obj1 objectForKey:@"locId"] integerValue]>[[obj2 objectForKey:@"locId"] integerValue]){
            return NSOrderedDescending;
        }else{
            return NSOrderedAscending;
        }
        
    }];
}
@end
