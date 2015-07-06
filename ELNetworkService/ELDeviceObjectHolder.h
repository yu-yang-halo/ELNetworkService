//
//  ELDeviceObjectHolder.h
//  objectc_ehome
//
//  Created by admin on 14-10-11.
//  Copyright (c) 2014年 cn.lztech  合肥联正电子科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface RepeatObj :NSObject
@property(nonatomic,assign) BOOL isAC;//空调
@property(nonatomic,assign) BOOL isAudio;//音响
@property(nonatomic,assign) BOOL isTV;//电视
@end

@interface ELDeviceObjectHolder : NSObject
@property(nonatomic,assign) NSInteger classId;
@property(nonatomic,assign) NSInteger objectId;
@property(nonatomic,retain) NSString *name;
@property(nonatomic,assign) BOOL isCk;
@property(nonatomic,assign) BOOL isOnOff;
@property(nonatomic,assign) BOOL isAlert;
@property(nonatomic,assign) NSInteger allNums;
@property(nonatomic,assign) NSInteger currentNums;
@property(nonatomic,retain) NSMutableIndexSet *repeatCollections;
//@property(nonatomic,assign) NSDictionary *fieldMap;
@property(nonatomic,retain) NSString *otherInfo;
@end

