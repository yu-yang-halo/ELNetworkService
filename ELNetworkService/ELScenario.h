//
//  ELScenario.h
//  objectc_ehome
//
//  Created by admin on 14-9-27.
//  Copyright (c) 2014年 cn.lztech  合肥联正电子科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ELScenario : NSObject
@property(nonatomic) NSInteger scenarioId;
@property(nonatomic,retain) NSString *name;
@property(nonatomic,assign) BOOL activeYN;
@property(nonatomic) NSInteger creatorId;
@property(nonatomic) NSInteger imageId;
@end
