//
//  ELCcsClientInfo.h
//  ELNetworkService
//
//  Created by admin on 16/1/19.
//  Copyright (c) 2016年 LZTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ELCcsClientInfo : NSObject

@property(nonatomic,assign) int clientId;
@property(nonatomic,retain) NSString *clientSn;
@property(nonatomic,retain) NSString *pwd;
@property(nonatomic,assign) int typeCode;
@property(nonatomic,assign) BOOL useFlag;
@property(nonatomic,assign) BOOL accessYN;
@property(nonatomic,assign) int  classId;

@end
