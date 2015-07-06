//
//  ELShareContext.h
//  objectc_ehome
//
//  Created by admin on 14-10-12.
//  Copyright (c) 2014年 cn.lztech  合肥联正电子科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ELScenario;
@class ELDeviceObject;
@interface ELShareContext : NSObject

@property(nonatomic,retain) NSMutableDictionary *deviceList;
@property(nonatomic,readonly) NSArray *sceneIcons;
@property(nonatomic,readonly) NSDictionary *errorCodeMap;
@property(nonatomic,retain) NSArray *allLocations;

@property(nonatomic,retain) ELScenario *elscenarioParam;
@property(nonatomic,retain) NSString *mobileNumber;
@property(nonatomic,retain) ELDeviceObject *currentObject;

@property(nonatomic,assign) BOOL isfilterLocationYN;
@property(nonatomic,assign) NSInteger ccsGatewayId;
@property(nonatomic,assign) NSInteger videoType;
+(ELShareContext *)defaultContext;

@end
