//
//  ELFieldValue.h
//  objectc_ehome
//
//  Created by admin on 14-11-5.
//  Copyright (c) 2014年 cn.lztech  合肥联正电子科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ELFieldValue : NSObject
@property(nonatomic,assign) NSInteger fieldId;
@property(nonatomic,retain) NSString *value;
@property(nonatomic,retain) NSString *fieldName;
-(instancetype)initFieldId:(NSInteger)fieldId withValue:(NSString *)value;
@end
