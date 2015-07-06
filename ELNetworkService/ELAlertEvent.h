//
//  ELAlertEvent.h
//  objectc_ehome
//
//  Created by admin on 14-10-28.
//  Copyright (c) 2014年 cn.lztech  合肥联正电子科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ELAlertEvent : NSObject
@property(nonatomic,assign) NSInteger number;
@property(nonatomic,assign) NSInteger eventId;
@property(nonatomic,assign) NSInteger objectId;
@property(nonatomic,assign) NSInteger alertId;
@property(nonatomic,assign) BOOL sentNotificationYN;
@property(nonatomic,retain) NSString *fieldValue;
@property(nonatomic,retain) NSString *description;
@property(nonatomic,retain) NSString *createTime;
@property(nonatomic,retain) NSString *emailAddress;
@property(nonatomic,retain) NSString *cellPhoneNum;
@property(nonatomic,retain) NSString *sentMsg;
@end
