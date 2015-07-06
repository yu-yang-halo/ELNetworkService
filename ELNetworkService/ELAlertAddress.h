//
//  ELAlertAddress.h
//  objectc_ehome
//
//  Created by admin on 14-10-28.
//  Copyright (c) 2014年 cn.lztech  合肥联正电子科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#define ADDRESS_TYPE_EMAIL 0
#define ADDRESS_TYPE_SHMSG 1
@interface ELAlertAddress : NSObject
@property(nonatomic,assign) NSInteger alertId;
@property(nonatomic,assign) NSInteger addressType;
@property(nonatomic,retain) NSString* address;
@property(nonatomic,assign) BOOL activeYn;
@end
