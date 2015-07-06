//
//  ELUserInfo.h
//  objectc_ehome
//
//  Created by admin on 14-10-31.
//  Copyright (c) 2014年 cn.lztech  合肥联正电子科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ELUserInfo : NSObject
@property(nonatomic,assign) NSInteger userId;
@property(nonatomic,retain) NSString *loginName;
@property(nonatomic,retain) NSString *password;
@property(nonatomic,retain) NSString *realName;
@property(nonatomic,retain) NSString *email;
@property(nonatomic,retain) NSString *phoneNumber;
@property(nonatomic,retain) NSString *regTime;
@property(nonatomic,retain) NSString *expirationTime;
@property(nonatomic,assign) NSInteger extraObjId;
@property(nonatomic,assign) NSInteger serviceId;
@property(nonatomic,assign) NSInteger type;
@property(nonatomic,assign) NSInteger appId;
@end
