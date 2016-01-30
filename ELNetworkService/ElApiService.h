//
//  ElApiService.h
//  ehome
//
//  Created by admin on 14-7-21.
//  Copyright (c) 2014年 cn.lztech  合肥联正电子科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
const static NSString   *webServiceIP=@"121.41.15.186";
const static NSUInteger  webServicePOST=8080;
#define KEY_LOGINNAME @"elian_loginname_key"
#define KEY_PASSWORD  @"elian_loginpass_key"

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
@class ELCcsClientInfo;
@class GDataXMLElement;

static ElApiService* shareService=nil;
@interface ElApiService : NSObject{
    
}

@property(nonatomic,retain) NSString *connect_header;
@property(nonatomic,retain) NSString *sysApiUrl;

+(ElApiService *) shareElApiService;

/*
 **********************************
 *
 *  E联webservice 最新版本的接口
 **********************************
 */
-(ELUserInfo *)findUserInfo:(NSString *)loginName withEmail:(NSString *)email;
-(BOOL)updateUser:(NSString *)password email:(NSString *)email number:(NSString *)phoneNumber;
#pragma api appUserLogin
-(BOOL)loginByUsername:(NSString *)username andPassword:(NSString *)password appId:(int)appId;
#pragma  getObjectList
-(NSMutableDictionary *)getObjectList;
#pragma mark getObjectValue
-(ELDeviceObject *)getObjectValue:(NSInteger)objectId;
-(BOOL)updateObject:(ELDeviceObject *)deviceObject;
#pragma mark 默认参数accessYN=false connType=0
-(NSInteger)createObject:(int)classId name:(NSString *)name ccsClientSn:(NSString *)ccsClientSn clientId:(int)ccsClientId;
#pragma mark getCcsDeviceBySn
-(ELCcsClientInfo *)getCcsDeviceBySn:(NSString *)ccsClientSn;
#pragma mark addTagToDevObject
-(BOOL)addTagToDevObject:(int)objectId tagSetId:(int)tagSetId tag:(NSString *)tag;
-(BOOL)deleteObject:(NSInteger)objectId;
#pragma mark setFieldValue
-(BOOL)setFieldValue:(NSString *)fieldValue forFieldId:(NSInteger)fieldId toDevice:(NSInteger)objectId withYN:(BOOL)sendToDeviceYN;
#pragma mark --getFieldValue
-(NSString *)getFieldValue:(NSInteger)fieldId withDevice:(NSInteger)objectId;

#pragma mark create user elsysapi 提供
-(BOOL)createUser:(NSString *)userName password:(NSString *)_pass email:(NSString *)_email phoneNumber:(NSString *)phnumber appId:(int)appId;


#pragma mark sendShortMsgCodeByUser  type 0用户注册的验证码 1随机密码 （有问题暂时无法使用）
-(BOOL)sendShortMsgCodeByUser:(NSString *)userName type:(int)type;
#pragma mark getShortMsgCodeByUser（有问题暂时无法使用）
-(NSString *)getShortMsgCodeByUser:(NSString *)userName;
#pragma mark sendEmailShortMsg（有问题暂时无法使用） addressType  1:shormessage
-(BOOL)sendEmailShortMsg:(NSString *)address withType:(NSInteger)addressType andText:(NSString *)text;
-(NSArray *)getAlertEventListByDevice:(NSInteger)objectId withMax:(NSInteger)maxNum;
-(NSArray *)getShotImgNameList:(NSInteger)objectId withMaxNum:(NSInteger)maxNum;
-(NSString *)getShotImgByName:(NSInteger)objectId withName:(NSString *)name;
-(ELDeviceObject *)parseXmlToDeviceObject:(GDataXMLElement *)element;

@end

