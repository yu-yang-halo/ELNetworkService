//
//  ELScenarioDetail.h
//  objectc_ehome
//
//  Created by admin on 14-10-12.
//  Copyright (c) 2014年 cn.lztech  合肥联正电子科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ELScenarioDetail : NSObject
@property(nonatomic,assign) NSInteger scenarioId;
@property(nonatomic,retain) NSString *name;
@property(nonatomic,assign) BOOL activeYN;
@property(nonatomic,assign) NSInteger imageId;
@property(nonatomic,retain) NSArray *taskList;
@end
