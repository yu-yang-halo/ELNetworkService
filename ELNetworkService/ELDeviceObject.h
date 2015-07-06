//
//  ELDeviceObject.h
//  objectc_ehome
//
//  Created by admin on 14-9-22.
//  Copyright (c) 2014年 cn.lztech  合肥联正电子科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ELDeviceObject : NSObject

@property(nonatomic,assign) NSInteger objectId;
@property(nonatomic,assign) NSInteger classId;
@property(nonatomic,assign) NSInteger netState;
@property(nonatomic,assign) NSInteger locId;
@property(nonatomic,assign) NSInteger ccsClientId;
@property(nonatomic,assign) NSInteger gatewayId;
@property(nonatomic,assign) NSInteger connType;
@property(nonatomic,assign) NSInteger bindVmId;

@property(nonatomic,assign) BOOL accessYN;



@property(nonatomic,retain) NSString *name;
@property(nonatomic,retain) NSString *clientSn;
@property(nonatomic,retain) NSDictionary *fieldMap;

@end
