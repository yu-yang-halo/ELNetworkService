//
//  ELDeviceInfo.h
//  objectc_ehome
//
//  Created by admin on 14-11-2.
//  Copyright (c) 2014年 cn.lztech  合肥联正电子科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ELDeviceInfo : NSObject
@property(nonatomic,assign) NSInteger clientId;
@property(nonatomic,retain) NSString* sn;
@property(nonatomic,assign) NSInteger productId;
@end
