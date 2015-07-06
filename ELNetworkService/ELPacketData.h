//
//  ELPacketData.h
//  objectc_ehome
//
//  Created by admin on 14-11-7.
//  Copyright (c) 2014年 cn.lztech  合肥联正电子科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ELPacketData : NSObject
@property(nonatomic,retain) NSArray *macArr;
@property(nonatomic,retain) NSString *sn;
@property(nonatomic,retain) NSArray *ipArr;
@property(nonatomic,retain) NSArray *gwArr;
@property(nonatomic,assign) NSInteger dhcp;
@property(nonatomic,retain) NSArray *subMaskArr;
@property(nonatomic,assign) NSInteger bUserDns;
@property(nonatomic,retain) NSArray *serverIPArr;
@property(nonatomic,retain) NSArray *serverDns;
@end
