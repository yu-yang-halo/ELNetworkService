//
//  ELAlertSchedule.h
//  objectc_ehome
//
//  Created by admin on 14-10-28.
//  Copyright (c) 2014年 cn.lztech  合肥联正电子科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ELAlertSchedule : NSObject
@property(nonatomic,assign) NSInteger alertId;
@property(nonatomic,assign) NSInteger startHour;
@property(nonatomic,assign) NSInteger startMin;
@property(nonatomic,assign) NSInteger endHour;
@property(nonatomic,assign) NSInteger endMin;
@end
