//
//  ElApiService.h
//  ehome
//
//  Created by admin on 14-7-21.
//  Copyright (c) 2014年 cn.lztech  合肥联正电子科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#define ELSERVICE_URL @"42.121.126.156"
#define DEVELOPER_URL @"121.199.40.249"
#define TEST_URL      @"192.168.2.111"

//E联易家   42.121.126.156  api.elnet.cn
//开发平台  121.199.40.249  api2.elnet.cn
#define ELSERVICE_PORT 8080
#define KEY_LOGINNAME @"elian_loginname_key"
#define KEY_PASSWORD  @"elian_loginpass_key"
#define DEMO_ACCOUNT_NAME @"hyldemo"
#define SHORT_MESSAGE_TYPE_VCODE 0
#define SHORT_MESSAGE_TYPE_PASS 1
//错误处理
extern NSString *kErrorCodeKey;
extern NSString *kErrorAlertNotification;

@class ElApiService;
@class ELDeviceObject;
@class ELSimpleTask;
@class ELScenarioDetail;
@class ELAlertCondition;
@class ELScheduleTask;
@class ELAlertAddress;
@class ELAlertSchedule;
@class ELUserInfo;
@class ELClassField;
@class ELClassObject;

typedef NS_ENUM(NSInteger, HYLPLATFORM){
   HYLPLATFORM_ELHOME,
   HYLPLATFORM_DEVELOPER,
    HYLPLATFORM_TEST,
};

static ElApiService* shareService=nil;
@interface ElApiService : NSObject{
    
}

@property(nonatomic,retain) NSString* connect_header;
+(void)setPlatformType:(HYLPLATFORM) platform;

+(ElApiService *) shareElApiService;
#pragma mark appUserLogin
-(BOOL)loginByUsername:(NSString *)username andPassword:(NSString *)password;

#pragma getObjectListAndFieldsByUser
-(NSDictionary *)getObjectListAndFieldsByUser;

#pragma mark --getFieldValue
-(NSString *)getFieldValue:(NSInteger)fieldId withDevice:(NSInteger)objectId;

#pragma mark setFieldValue
-(BOOL)setFieldValue:(NSString *)fieldValue forFieldId:(NSInteger)fieldId toDevice:(NSInteger)objectId withYN:(BOOL)sendToDeviceYN;

#pragma mark task
-(BOOL)activateTask:(NSInteger)taskId withYN:(BOOL)activeYN;
-(NSArray *)getTaskListByObject:(NSInteger)objectId;
-(BOOL)updateTask:(ELScheduleTask *)task;
-(BOOL)createTask:(ELScheduleTask *)task;
-(BOOL)deleteTask:(NSInteger)taskId;
#pragma mark getObjectValue
-(ELDeviceObject *)getObjectValue:(NSInteger)objectId;
-(BOOL)updateObject:(ELDeviceObject *)deviceObject;

#pragma mark executeScenario  getScenarioListByUser de
-(BOOL)executeScenario:(NSInteger)scenarioId;
-(BOOL)deleteScenario:(NSInteger)scenarioId;
-(NSInteger)createScenario:(NSString *)name withImageId:(NSInteger)imageId;
-(BOOL)addTaskToScenario:(NSInteger)scenarioId withTask:(ELSimpleTask *)task;
-(ELScenarioDetail *)getScenarioDetail:(NSInteger)scenarioId;
-(NSArray *)getScenarioListByUser;
#pragma mark alert
-(ELAlertCondition *)getAlertByObjectId:(NSInteger)objectId;
-(BOOL)setAlertMode:(NSInteger) objectId withMode:(NSInteger)mode;
-(NSInteger)getAlertMode:(NSInteger)objectId;
-(NSArray *)getAlertEventListByDevice:(NSInteger)objectId withMax:(NSInteger)maxNum;
-(NSArray *)getAlertAddressList:(NSInteger)alertId;
-(NSArray *)getAlertSchedule:(NSInteger)alertId;
-(BOOL)addAlertAddress:(ELAlertAddress *)alertAddress;
-(BOOL)deleteAlertAddress:(NSInteger)alertId withType:(NSInteger)addressType;
-(BOOL)addAlertSchedule:(ELAlertSchedule *)alertSchedule;
-(BOOL)deleteAlertSchedule:(NSInteger)alertId;

#pragma mark phone register
-(NSString *)getShortMsgCodeByUser:(NSString *)userName;
-(BOOL)sendShortMsgCodeByUser:(NSString *)userName withType:(NSInteger)type;
-(BOOL)createUser:(NSString *)userName password:(NSString *)_pass email:(NSString *)_email;
-(BOOL)sendEmailShortMsg:(NSString *)address withType:(NSInteger)addressType andText:(NSString *)text;

#pragma mark getLocationList
-(NSArray *)getLocationList;
#pragma mark getObjectListByClass
-(NSArray *)getObjectListByClass:(NSInteger)classId;

#pragma mark user info
-(ELUserInfo *)findUserInfo:(NSString *)loginName;
-(ELUserInfo *)findUserInfo:(NSString *)loginName withEmail:(NSString *)email;
-(BOOL)updateUser:(ELUserInfo *)userInfo;
-(BOOL)updateUserPass:(NSString *)password byLoginName:(NSString *)loginName;

#pragma mark device manager
-(NSInteger)createObject:(ELDeviceObject *)devObj;
-(BOOL)deleteObject:(NSInteger)objectId;

-(NSArray *)getGatewayListByIP:(NSString *)ipAddress;
-(NSArray *)getChildDevicesByGW:(NSInteger)gwClientId;
-(BOOL)createAlert:(ELAlertCondition *)alert toDevice:(NSInteger)objectId;

-(NSArray *)getShotImgNameList:(NSInteger)objectId withMaxNum:(NSInteger)maxNum;
#pragma mark image stream to base64String
-(NSString *)getShotImgByName:(NSInteger)objectId withName:(NSString *)name;



@end

@interface ElApiService (ClassData)

-(ELClassObject *)getClassById:(NSInteger)classId;

@end
