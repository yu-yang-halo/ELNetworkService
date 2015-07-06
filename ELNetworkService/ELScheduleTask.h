//
//  ELScheduleTask.h
//  objectc_ehome
//
//  Created by admin on 14-10-22.
//  Copyright (c) 2014年 cn.lztech  合肥联正电子科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#define EXECUTION_TYPE_TIMER 0
#define EXECUTION_TYPE_ALERT_BINDER 1
@interface ELScheduleTask : NSObject
@property(nonatomic,assign) NSInteger taskId;
@property(nonatomic,assign) NSInteger alertId;
@property(nonatomic,assign) NSInteger objectId;
@property(nonatomic,assign) NSInteger fieldId;
@property(nonatomic,retain) NSString *fieldValue;
@property(nonatomic,assign) NSInteger createUserId;
@property(nonatomic,assign) NSInteger executionType;
@property(nonatomic,retain) NSString *executionTime;
@property(nonatomic,assign) NSInteger freq;
@property(nonatomic,assign) BOOL activeYN;
//@property(nonatomic,assign) NSInteger scenarioId;
//@property(nonatomic,assign) BOOL executionScYN;
@end
