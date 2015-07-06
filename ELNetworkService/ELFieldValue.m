//
//  ELFieldValue.m
//  objectc_ehome
//
//  Created by admin on 14-11-5.
//  Copyright (c) 2014年 cn.lztech  合肥联正电子科技有限公司. All rights reserved.
//

#import "ELFieldValue.h"

@implementation ELFieldValue
-(instancetype)initFieldId:(NSInteger)fieldId withValue:(NSString *)value{
    self=[super init];
    if(self){
        self.fieldId=fieldId;
        self.value=value;
    }
    return self;
}
@end
