//
//  ELSimpleTask.h
//  objectc_ehome
//
//  Created by admin on 14-10-11.
//  Copyright (c) 2014年 cn.lztech  合肥联正电子科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ELSimpleTask : NSObject
@property(nonatomic,assign) NSInteger taskId;
@property(nonatomic,assign) NSInteger objectId;
@property(nonatomic,assign) NSInteger fieldId;
@property(nonatomic,retain) NSString* fieldValue;
@property(nonatomic,assign) NSInteger alertId;
@property(nonatomic,assign) NSInteger alertMode;
@property(nonatomic,assign) NSInteger taskType;
@end
