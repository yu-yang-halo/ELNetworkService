//
//  ELAlertCondition.h
//  objectc_ehome
//
//  Created by admin on 14-10-14.
//  Copyright (c) 2014年 cn.lztech  合肥联正电子科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
static  short CLOSED = 0;
static  short OPENED = 1;
static  short BY_SCHEDULE = 2;
@interface ELAlertCondition : NSObject
@property(nonatomic,assign) NSInteger alertId;
@property(nonatomic,assign) NSInteger objectId;
@property(nonatomic,assign) BOOL useScriptFlag;
@property(nonatomic,assign) NSInteger fieldId;
@property(nonatomic,retain) NSString *Operator;
@property(nonatomic,assign) float threshold;
@property(nonatomic,retain) NSString *conditionScript;
@property(nonatomic,retain) NSString *msgText;
@property(nonatomic,assign) NSInteger autoDisarm;
@property(nonatomic,assign) NSInteger numOfSend;
@property(nonatomic,assign) NSInteger mode;
@property(nonatomic,retain) NSMutableArray *addressList;
@property(nonatomic,retain) NSMutableArray *scheuleList;
@property(nonatomic,retain) NSMutableArray *eventList;
@property(nonatomic,assign) NSInteger sendCount;
@property(nonatomic,retain) NSDate *lastSentTime;
@end
