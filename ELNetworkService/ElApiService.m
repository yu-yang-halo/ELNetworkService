//
//  ElApiService.m
//  ehome
//
//  Created by admin on 14-7-21.
//  Copyright (c) 2014年 cn.lztech  合肥联正电子科技有限公司. All rights reserved.
//

#import "ElApiService.h"
#import "GDataXMLNode.h"
#import "ELSimpleTask.h"
#import "ELScenarioDetail.h"
#import "ELAlertCondition.h"
#import "ELAlertEvent.h"
#import "ELAlertAddress.h"
#import "ELAlertSchedule.h"
#import "Util.h"
#import "WsqMD5Util.h"
#import "ELDeviceInfo.h"
#import "ELScenario.h"
#import "ELScheduleTask.h"
#import "ELDeviceObject.h"
#import "ELClass.h"
#import "ELShareContext.h"
#import "ELUserInfo.h"
#import "ELClassField.h"
#import "ELCcsClientInfo.h"
#import "ELClassObject.h"

#define KEY_USERID @"elian_userId_key"
#define KEY_SECTOKEN @"elian_sectoken_key"
#define KEY_ADMIN_APPID @"elian_admin_appID_key"
#define DEFAULT_TIME_OUT 11

@interface ElApiService()
-(NSData *)requestURLSync:(NSString *)service;
-(NSData *)requestURL:(NSString *)service;
-(GDataXMLElement *)getRootElementByData:(NSData *)data;

#pragma mark 网络错误汇报
-(void)notificationErrorCode:(NSString *)errorCode;

@end

@implementation ElApiService
+(ElApiService *) shareElApiService{
    @synchronized([ElApiService class]){
        if(shareService==nil){
            shareService=[[ElApiService alloc] init];
            shareService.connect_header=[NSString stringWithFormat:@"http://%@:%d/elws/services/elwsapi/",webServiceIP,webServicePOST];
            shareService.sysApiUrl=[NSString stringWithFormat:@"http://%@:%d/elws/services/elsysapi/",webServiceIP,webServicePOST];
        }
        return shareService;
    }
    
}

/*
 *************************************************************
 *
 *  E联webservice 最新版本的接口 begin....
 *
 *************************************************************
 *
 */

-(ELUserInfo *)findUserInfo:(NSString *)loginName withEmail:(NSString *)email{
    
    NSString *userId=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERID];
    NSString *secToken=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SECTOKEN];
    NSMutableString* service=[[NSMutableString alloc] initWithFormat:@"%@findUserInfo?senderId=%@&secToken=%@",self.connect_header,userId,secToken];
    if(loginName!=nil){
        [service appendFormat:@"&loginName=%@",loginName];
    }
    if(email!=nil){
        [service appendFormat:@"&email=%@",email];
    }
    NSLog(@"findUserInfo URL: %@",service);
    NSData *data=[self requestURLSync:service];
    if(data){
        GDataXMLElement *rootElement=[self getRootElementByData:data];
        NSString* errorCodeVal=[[[rootElement elementsForName:@"errorCode"] objectAtIndex:0] stringValue];
        NSString* errorMsg=[[[rootElement elementsForName:@"errorMsg"] objectAtIndex:0] stringValue];
        if([errorCodeVal isEqualToString:@"0"]){
            ELUserInfo *userInfo=[[ELUserInfo alloc] init];
            userInfo.userId=[[[[rootElement elementsForName:@"userId"] objectAtIndex:0] stringValue] integerValue];
            userInfo.loginName=[[[rootElement elementsForName:@"loginName"] objectAtIndex:0] stringValue] ;
            userInfo.password=[[[rootElement elementsForName:@"password"] objectAtIndex:0] stringValue] ;
            userInfo.realName=[[[rootElement elementsForName:@"realName"] objectAtIndex:0] stringValue] ;
            userInfo.email=[[[rootElement elementsForName:@"email"] objectAtIndex:0] stringValue] ;
            userInfo.phoneNumber=[[[rootElement elementsForName:@"phoneNumber"] objectAtIndex:0] stringValue] ;
            userInfo.type=[[[[rootElement elementsForName:@"type"] objectAtIndex:0] stringValue] integerValue];
            userInfo.appId=[[[[rootElement elementsForName:@"appId"] objectAtIndex:0] stringValue] integerValue];
            userInfo.regTime=[[[rootElement elementsForName:@"regTime"] objectAtIndex:0] stringValue] ;
            userInfo.expirationTime=[[[rootElement elementsForName:@"expirationTime"] objectAtIndex:0] stringValue] ;
            userInfo.extraObjId=[[[[rootElement elementsForName:@"extraObjId"] objectAtIndex:0] stringValue] integerValue];
            userInfo.serviceId=[[[[rootElement elementsForName:@"serviceId"] objectAtIndex:0] stringValue] integerValue];
            return userInfo;
            
        }else{
            [self notificationErrorCode:errorMsg];
        }
    }
    return nil;
    
}


-(BOOL)updateUser:(NSString *)password email:(NSString *)email number:(NSString *)phoneNumber{
    NSString *userId=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERID];
    NSString *secToken=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SECTOKEN];
    
    NSMutableString *appendHttpHeader=[[NSMutableString alloc] initWithString:@""];
    if(password!=nil&&![password isEqualToString:@""]){
        [appendHttpHeader appendFormat:@"&password=%@",password];
    }
    if(email!=nil&&![email isEqualToString:@""]){
        [appendHttpHeader appendFormat:@"&email=%@",email];
    }
    if(phoneNumber!=nil&&![phoneNumber isEqualToString:@""]){
        [appendHttpHeader appendFormat:@"&phoneNumber=%@",phoneNumber];
    }
    
    NSString* service=[NSString stringWithFormat:@"%@updateUser?senderId=%@&secToken=%@&userId=%@%@",self.connect_header,userId,secToken,userId,appendHttpHeader];
    
    
    NSLog(@"updateUser URL: %@",service);
    NSData *data=[self requestURLSync:service];
    if(data){
        GDataXMLElement *rootElement=[self getRootElementByData:data];
        NSString* errorCodeVal=[[[rootElement elementsForName:@"errorCode"] objectAtIndex:0] stringValue];
        NSString* errorMsg=[[[rootElement elementsForName:@"errorMsg"] objectAtIndex:0] stringValue];
        if([errorCodeVal isEqualToString:@"0"]){
            return YES;
        }else{
            [self notificationErrorCode:errorMsg];
        }
    }
    return NO;
}

#pragma api appUserLogin
-(BOOL)loginByUsername:(NSString *)username andPassword:(NSString *)password appId:(int)appId{
    NSString* service=[NSString stringWithFormat:@"%@userLogin?name=%@&password=%@&appId=%d&clientEnv=ios&logoutYN=false",self.connect_header,[Util encodeToPercentEscapeString:username],[WsqMD5Util getmd5WithString:password],appId];
    
    NSLog(@"loginByUsername URL: %@",service);
    
    NSData *data=[self requestURLSync:service];
    if(data!=nil){
        GDataXMLElement *rootElement=[self getRootElementByData:data];
        NSString* errorCodeVal=[[[rootElement elementsForName:@"errorCode"] objectAtIndex:0] stringValue];
        NSString* errorMsg=[[[rootElement elementsForName:@"errorMsg"] objectAtIndex:0] stringValue];
        NSString* userIdVal=[[[rootElement elementsForName:@"userId"] objectAtIndex:0] stringValue];
        NSString* secTokenVal=[[[rootElement elementsForName:@"secToken"] objectAtIndex:0] stringValue];
        NSLog(@"errorCode:%@, userId:%@ ,secToken:%@",errorCodeVal,userIdVal,secTokenVal);
        if([errorCodeVal isEqualToString:@"0"]){
            [[NSUserDefaults standardUserDefaults] setObject:userIdVal forKey:KEY_USERID];
            [[NSUserDefaults standardUserDefaults] setObject:secTokenVal forKey:KEY_SECTOKEN];
            [[NSUserDefaults standardUserDefaults] setObject:username forKey:KEY_LOGINNAME];
            [[NSUserDefaults standardUserDefaults] setObject:password forKey:KEY_PASSWORD];
            
            return YES;
        }else{
            [self notificationErrorCode:errorMsg];
        }
    }
    return NO;
}
-(ELDeviceObject *)parseXmlToDeviceObject:(GDataXMLElement *)element{
    ELDeviceObject *deviceObject=[[ELDeviceObject alloc] init];
    deviceObject.objectId=[[[[element elementsForName:@"objectId"] objectAtIndex:0] stringValue] integerValue];
    deviceObject.classId=[[[[element elementsForName:@"classId"] objectAtIndex:0]  stringValue] integerValue];
    if(deviceObject.classId==ELDEVICECLASSTYPE_IPCAMERA){
        deviceObject.netState=1;
    }else{
        deviceObject.netState=[[[[element elementsForName:@"netState"] objectAtIndex:0]  stringValue] integerValue];
    }
    deviceObject.locId=[[[[element elementsForName:@"locId"] objectAtIndex:0]  stringValue] integerValue];
    deviceObject.ccsClientId=[[[[element elementsForName:@"ccsClientId"] objectAtIndex:0]  stringValue] integerValue];
    deviceObject.gatewayId=[[[[element elementsForName:@"gatewayId"] objectAtIndex:0]  stringValue] integerValue];
    
    
    deviceObject.clientSn=[[[element elementsForName:@"clientSn"] objectAtIndex:0] stringValue];
    deviceObject.name=[[[element elementsForName:@"name"] objectAtIndex:0] stringValue];
    NSString *bindVmIDStr=[[[element elementsForName:@"bindVmId"] objectAtIndex:0] stringValue];
    ;
    
    if([Util isNumberCharacterSet:bindVmIDStr]){
        deviceObject.bindVmId=[bindVmIDStr integerValue];
    }
    
    
    NSArray *fieldList=[element elementsForName:@"fieldList"];
    
    if(fieldList==nil||fieldList.count<=0){
        fieldList=[element elementsForName:@"valueList"];
    }
    NSArray *tags=[element elementsForName:@"tags"];
    
    if(fieldList!=nil){
        NSMutableDictionary *_fieldDic=[[[NSMutableDictionary alloc] init] autorelease];
        for (int j=0;j<[fieldList count];j++) {
            GDataXMLElement *fields=[fieldList objectAtIndex:j];
            NSString *_key=[[[fields elementsForName:@"fieldId"] objectAtIndex:0] stringValue];
            NSString *_value=[[[fields elementsForName:@"value"] objectAtIndex:0] stringValue];
            [_fieldDic setObject:_value forKey:[NSString stringWithFormat:@"%@",_key]];
            
        }
        deviceObject.fieldMap=_fieldDic;
    }
    
    if(tags!=nil){
        
        NSMutableArray *tagInfos=[[[NSMutableArray alloc] init] autorelease];
        for (int j=0;j<[tags count];j++) {
            GDataXMLElement *tagsElement=[tags objectAtIndex:j];
            ELTagInfo *tagInfo=[[ELTagInfo alloc] init];
            NSString *setTagId=[[[tagsElement elementsForName:@"setTagId"] objectAtIndex:0] stringValue];
            NSString *tag=[[[tagsElement elementsForName:@"tag"] objectAtIndex:0] stringValue];
           
            [tagInfo setSetTagId:[setTagId integerValue]];
            [tagInfo setTag:tag];
            [tagInfos addObject:tagInfo];
        }
        deviceObject.tags=tagInfos;
        
    }
    
   
    return deviceObject;
}

#pragma  getObjectList
-(NSMutableDictionary *)getObjectList{
    NSMutableDictionary *objectCache=[[[NSMutableDictionary alloc] init] autorelease];
    
    NSString *userId=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERID];
    NSString *secToken=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SECTOKEN];
    NSString* service=[NSString stringWithFormat:@"%@getObjectList?senderId=%@&secToken=%@&userId=%@",self.connect_header,userId,secToken,userId];
    NSLog(@"getObjectList URL: %@",service);
    NSData *data=[self requestURLSync:service];
    if(data){
        GDataXMLElement *rootElement=[self getRootElementByData:data];
        NSString* errorCodeVal=[[[rootElement elementsForName:@"errorCode"] objectAtIndex:0] stringValue];
        NSString* errorMsg=[[[rootElement elementsForName:@"errorMsg"] objectAtIndex:0] stringValue];
        NSArray *valueList=[rootElement elementsForName:@"valueList"];
        
        if([errorCodeVal isEqualToString:@"0"]){
            for(int i=0;i<[valueList count];i++){
                GDataXMLElement *element=[valueList objectAtIndex:i];
                ELDeviceObject *eldevObj=[self parseXmlToDeviceObject:element];
                [objectCache setObject:eldevObj forKey:[NSString stringWithFormat:@"%d",eldevObj.objectId]];
                
            }
        }else{
            [self notificationErrorCode:errorMsg];
        }
    }
    //缓存到本地
    [[ELShareContext defaultContext] setDeviceList:objectCache];
    
    return objectCache;
}


#pragma mark getObjectValue
-(ELDeviceObject *)getObjectValue:(NSInteger)objectId{
    NSString *userId=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERID];
    NSString *secToken=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SECTOKEN];
    NSString* service=[NSString stringWithFormat:@"%@getObjectValue?senderId=%@&secToken=%@&objectId=%d&includeFieldName=%d",self.connect_header,userId,secToken,objectId,NO];
    NSLog(@"getObjectValue URL: %@",service);
    NSData *data=[self requestURLSync:service];
    if(data){
        GDataXMLElement *rootElement=[self getRootElementByData:data];
        NSString* errorCodeVal=[[[rootElement elementsForName:@"errorCode"] objectAtIndex:0] stringValue];
        NSString* errorMsg=[[[rootElement elementsForName:@"errorMsg"] objectAtIndex:0] stringValue];
        if([errorCodeVal isEqualToString:@"0"]){
            ELDeviceObject *deviceObject=[self parseXmlToDeviceObject:rootElement];
            
            return deviceObject;
        }else{
            [self notificationErrorCode:errorMsg];
        }
    }
    return nil;
}
-(BOOL)updateObject:(ELDeviceObject *)deviceObject{
    NSString *userId=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERID];
    NSString *secToken=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SECTOKEN];
    NSMutableString* service=[NSMutableString stringWithFormat:@"%@updateObject?senderId=%@&secToken=%@&objectId=%d&name=%@&desc=%@&clientSn=%@&bindVmId=%d",self.connect_header,userId,secToken,deviceObject.objectId,[Util encodeToPercentEscapeString:deviceObject.name],[Util encodeToPercentEscapeString:deviceObject.name],deviceObject.clientSn,deviceObject.bindVmId];
    
    if(deviceObject.ccsClientId>0){
        [service appendFormat:@"&ccsClientId=%d",deviceObject.ccsClientId];
    }
    if(deviceObject.gatewayId>0){
        [service appendFormat:@"&gatewayId=%d",deviceObject.gatewayId];
    }
    if(deviceObject.locId>0){
        [service appendFormat:@"&locId=%d",deviceObject.locId];
    }
    NSLog(@"updateObject URL: %@",service);
    NSData *data=[self requestURLSync:service];
    if(data){
        GDataXMLElement *rootElement=[self getRootElementByData:data];
        NSString* errorCodeVal=[[[rootElement elementsForName:@"errorCode"] objectAtIndex:0] stringValue];
        NSString* errorMsg=[[[rootElement elementsForName:@"errorMsg"] objectAtIndex:0] stringValue];
        if([errorCodeVal isEqualToString:@"0"]){
            return YES;
        }else{
            [self notificationErrorCode:errorMsg];
        }
    }
    return NO;
}
#pragma mark 默认参数accessYN=false connType=0
-(NSInteger)createObject:(int)classId name:(NSString *)name ccsClientSn:(NSString *)ccsClientSn clientId:(int)ccsClientId{
    NSString *userId=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERID];
    NSString *secToken=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SECTOKEN];
    NSString* service=[NSString stringWithFormat:@"%@createObject?senderId=%@&secToken=%@&ownerUserId=%@&classId=%d&name=%@&desc=%@&ccsClientId=%d&ccsClientSn=%@&accessYN=%d&connType=%d",self.connect_header,userId,secToken,userId,classId,[Util encodeToPercentEscapeString:name],[Util encodeToPercentEscapeString:name],ccsClientId,ccsClientSn,NO,0];
    NSLog(@"createObject URL: %@",service);
    NSData *data=[self requestURLSync:service];
    if(data){
        GDataXMLElement *rootElement=[self getRootElementByData:data];
        NSString* errorCodeVal=[[[rootElement elementsForName:@"errorCode"] objectAtIndex:0] stringValue];
        NSString* errorMsg=[[[rootElement elementsForName:@"errorMsg"] objectAtIndex:0] stringValue];
        if([errorCodeVal isEqualToString:@"0"]){
            return [[[[rootElement elementsForName:@"objectId"] objectAtIndex:0] stringValue] integerValue];
        }else{
            [self notificationErrorCode:errorMsg];
        }
    }
    return -1;
}
-(ELCcsClientInfo *)parseCcsClientInfoNode:(GDataXMLElement *)deviceInfoNode{
   
    if(deviceInfoNode!=nil){
        ELCcsClientInfo *elccsClientInfo=[[ELCcsClientInfo alloc] init];
        NSString *clientId=[[[deviceInfoNode elementsForName:@"clientId"] objectAtIndex:0] stringValue];
        NSString *clientSn=[[[deviceInfoNode elementsForName:@"clientSn"] objectAtIndex:0] stringValue];
        NSString *pwd=[[[deviceInfoNode elementsForName:@"pwd"] objectAtIndex:0] stringValue];
        NSString *useFlag=[[[deviceInfoNode elementsForName:@"useFlag"] objectAtIndex:0] stringValue];
        NSString *accessYN=[[[deviceInfoNode elementsForName:@"accessYN"] objectAtIndex:0] stringValue];
        NSString *typeCode=[[[deviceInfoNode elementsForName:@"typeCode"] objectAtIndex:0] stringValue];
        NSString *classId=[[[deviceInfoNode elementsForName:@"classId"] objectAtIndex:0] stringValue];
        
        [elccsClientInfo setClientId:[clientId integerValue]];
        [elccsClientInfo setClientSn:clientSn];
        [elccsClientInfo setPwd:pwd];
        [elccsClientInfo setUseFlag:[useFlag boolValue]];
        [elccsClientInfo setAccessYN:[accessYN boolValue]];
        [elccsClientInfo setTypeCode:[typeCode integerValue]];
        [elccsClientInfo setClassId:[clientId integerValue]];
        return elccsClientInfo;
    }else{
        return nil;
    }
}

#pragma mark getCcsDeviceBySn
-(ELCcsClientInfo *)getCcsDeviceBySn:(NSString *)ccsClientSn{
    NSString *userId=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERID];
    NSString *secToken=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SECTOKEN];
    NSString* service=[NSString stringWithFormat:@"%@getCcsDeviceBySn?senderId=%@&secToken=%@&sn=%@",self.connect_header,userId,secToken,ccsClientSn];
    NSLog(@"getCcsDeviceBySn URL: %@",service);
    NSData *data=[self requestURLSync:service];
    if(data){
        GDataXMLElement *rootElement=[self getRootElementByData:data];
        NSString* errorCodeVal=[[[rootElement elementsForName:@"errorCode"] objectAtIndex:0] stringValue];
        NSString* errorMsg=[[[rootElement elementsForName:@"errorMsg"] objectAtIndex:0] stringValue];
        if([errorCodeVal isEqualToString:@"0"]){
            GDataXMLElement *deviceInfoNode=[[rootElement elementsForName:@"deviceInfo"] objectAtIndex:0];
            ELCcsClientInfo *elccsClientInfo=[self parseCcsClientInfoNode:deviceInfoNode];
            return elccsClientInfo;
        }else{
            [self notificationErrorCode:errorMsg];
        }
    }
    return nil;

}
#pragma mark addTagToDevObject
-(BOOL)addTagToDevObject:(int)objectId tagSetId:(int)tagSetId tag:(NSString *)tag{
    NSString *userId=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERID];
    NSString *secToken=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SECTOKEN];
    NSString* service=[NSString stringWithFormat:@"%@addTagToDevObject?senderId=%@&secToken=%@&objectId=%d&tagSetId=%d&tag=%@",self.connect_header,userId,secToken,objectId,tagSetId,[Util encodeToPercentEscapeString:tag]];
    NSLog(@"addTagToDevObject URL: %@",service);
    NSData *data=[self requestURLSync:service];
    if(data){
        GDataXMLElement *rootElement=[self getRootElementByData:data];
        NSString* errorCodeVal=[[[rootElement elementsForName:@"errorCode"] objectAtIndex:0] stringValue];
        NSString* errorMsg=[[[rootElement elementsForName:@"errorMsg"] objectAtIndex:0] stringValue];
        if([errorCodeVal isEqualToString:@"0"]){
             return YES;
        }else{
            [self notificationErrorCode:errorMsg];
        }
    }
    return NO;
}

-(BOOL)deleteObject:(NSInteger)objectId{
    NSString *userId=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERID];
    NSString *secToken=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SECTOKEN];
    NSString* service=[NSString stringWithFormat:@"%@deleteObject?senderId=%@&secToken=%@&objectId=%d",self.connect_header,userId,secToken,objectId];
    NSLog(@"deleteObject URL: %@",service);
    NSData *data=[self requestURLSync:service];
    if(data){
        GDataXMLElement *rootElement=[self getRootElementByData:data];
        NSString* errorCodeVal=[[[rootElement elementsForName:@"errorCode"] objectAtIndex:0] stringValue];
        NSString* errorMsg=[[[rootElement elementsForName:@"errorMsg"] objectAtIndex:0] stringValue];
        if([errorCodeVal isEqualToString:@"0"]){
            return YES;
        }else{
            [self notificationErrorCode:errorMsg];
        }
    }
    return NO;
}

#pragma mark setFieldValue
-(BOOL)setFieldValue:(NSString *)fieldValue forFieldId:(NSInteger)fieldId toDevice:(NSInteger)objectId withYN:(BOOL)sendToDeviceYN{
    NSString *userId=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERID];
    NSString *secToken=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SECTOKEN];
    NSString* service=[NSString stringWithFormat:@"%@setFieldValue?senderId=%@&secToken=%@&userId=%@&objectId=%d&fieldId=%d&fieldValue=%@&sendToDeviceYN=%d",self.connect_header,userId,secToken,userId,objectId,fieldId,fieldValue,sendToDeviceYN];
    NSLog(@"setFieldValue URL: %@",service);
    NSData *data=[self requestURLSync:service];
    if(data){
        GDataXMLElement *rootElement=[self getRootElementByData:data];
        NSString* errorCodeVal=[[[rootElement elementsForName:@"errorCode"] objectAtIndex:0] stringValue];
        NSString* errorMsg=[[[rootElement elementsForName:@"errorMsg"] objectAtIndex:0] stringValue];
        if([errorCodeVal isEqualToString:@"0"]){
            return YES;
        }else{
            [self notificationErrorCode:errorMsg];
        }
    }
    return NO;
}


#pragma mark --getFieldValue
-(NSString *)getFieldValue:(NSInteger)fieldId withDevice:(NSInteger)objectId{
    NSString *userId=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERID];
    NSString *secToken=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SECTOKEN];
    NSString* service=[NSString stringWithFormat:@"%@getFieldValue?senderId=%@&secToken=%@&objectId=%d&fieldId=%d",self.connect_header,userId,secToken,objectId,fieldId];
    NSLog(@"getFieldValue URL: %@",service);
    NSData *data=[self requestURLSync:service];
    if(data){
        GDataXMLElement *rootElement=[self getRootElementByData:data];
        NSString* errorCodeVal=[[[rootElement elementsForName:@"errorCode"] objectAtIndex:0] stringValue];
        NSString* errorMsg=[[[rootElement elementsForName:@"errorMsg"] objectAtIndex:0] stringValue];
        if([errorCodeVal isEqualToString:@"0"]){
            return [[[rootElement elementsForName:@"value"] objectAtIndex:0] stringValue];
        }else{
            [self notificationErrorCode:errorMsg];
        }
    }
    return nil;
}
#pragma mark sendShortMsgCodeByUser  type 0用户注册的验证码 1随机密码 （有问题暂时无法使用）
-(BOOL)sendShortMsgCodeByUser:(NSString *)userName type:(int)type{
    NSString *userId=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERID];
    NSString *secToken=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SECTOKEN];
    NSString* service=[NSString stringWithFormat:@"%@sendShortMsgCodeByUser?senderId=%@&secToken=%@&userName=%@&type=%d",self.connect_header,userId,secToken,userName,type];
    
    NSLog(@"sendShortMsgCodeByUser URL: %@",service);
    NSData *data=[self requestURLSync:service];
    if(data){
        GDataXMLElement *rootElement=[self getRootElementByData:data];
        NSString* errorCodeVal=[[[rootElement elementsForName:@"errorCode"] objectAtIndex:0] stringValue];
        NSString* errorMsg=[[[rootElement elementsForName:@"errorMsg"] objectAtIndex:0] stringValue];
        if([errorCodeVal isEqualToString:@"0"]){
            return YES;
        }else{
            [self notificationErrorCode:errorMsg];
        }
    }
    return NO;
}
#pragma mark getShortMsgCodeByUser（有问题暂时无法使用）
-(NSString *)getShortMsgCodeByUser:(NSString *)userName{
    NSString *userId=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERID];
    NSString *secToken=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SECTOKEN];
    NSString* service=[NSString stringWithFormat:@"%@getShortMsgCodeByUser?senderId=%@&secToken=%@&userId=%@&userName=%@",self.connect_header,userId,secToken,userId,userName];
    NSLog(@"getShortMsgCodeByUser URL: %@",service);
    NSData *data=[self requestURLSync:service];
    if(data){
        GDataXMLElement *rootElement=[self getRootElementByData:data];
        NSString* errorCodeVal=[[[rootElement elementsForName:@"errorCode"] objectAtIndex:0] stringValue];
        NSString* errorMsg=[[[rootElement elementsForName:@"errorMsg"] objectAtIndex:0] stringValue];
        if([errorCodeVal isEqualToString:@"0"]){
            return [[[rootElement elementsForName:@"shortMsgCode"] objectAtIndex:0] stringValue];
        }else{
            [self notificationErrorCode:errorMsg];
        }
    }
    return nil;
    
}

#pragma mark sendEmailShortMsg（有问题暂时无法使用） addressType  1:shormessage
-(BOOL)sendEmailShortMsg:(NSString *)address withType:(NSInteger)addressType andText:(NSString *)text{
    NSString *userId=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERID];
    NSString *secToken=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SECTOKEN];
    NSString* service=[NSString stringWithFormat:@"%@sendEmailShortMsg?senderId=%@&secToken=%@&address=%@&addressType=%d&text=%@",self.connect_header,userId,secToken,address,addressType,[Util encodeToPercentEscapeString:text]];
    
    NSLog(@"sendEmailShortMsg URL: %@",service);
    NSData *data=[self requestURLSync:service];
    if(data){
        GDataXMLElement *rootElement=[self getRootElementByData:data];
        NSString* errorCodeVal=[[[rootElement elementsForName:@"errorCode"] objectAtIndex:0] stringValue];
        NSString* errorMsg=[[[rootElement elementsForName:@"errorMsg"] objectAtIndex:0] stringValue];
        if([errorCodeVal isEqualToString:@"0"]){
            return YES;
        }else{
            [self notificationErrorCode:errorMsg];
        }
    }
    return NO;
    
}
-(NSArray *)getAlertEventListByDevice:(NSInteger)objectId withMax:(NSInteger)maxNum{
    NSMutableArray *eventArray=[[NSMutableArray alloc] init];
    NSString *userId=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERID];
    NSString *secToken=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SECTOKEN];
    NSString* service=[NSString stringWithFormat:@"%@getAlertEventListByDevice?senderId=%@&secToken=%@&deviceObjectId=%d&maxNum=%d",self.connect_header,userId,secToken,objectId,maxNum];
    NSLog(@"getAlertEventListByDevice URL: %@",service);
    NSData *data=[self requestURLSync:service];
    if(data){
        GDataXMLElement *rootElement=[self getRootElementByData:data];
        NSString* errorCodeVal=[[[rootElement elementsForName:@"errorCode"] objectAtIndex:0] stringValue];
        NSString* errorMsg=[[[rootElement elementsForName:@"errorMsg"] objectAtIndex:0] stringValue];
        if([errorCodeVal isEqualToString:@"0"]){
            NSArray *eventListElement= [rootElement elementsForName:@"eventList"];
            for(int i=0;i<[eventListElement count];i++){
                ELAlertEvent *alertEvent=[[ELAlertEvent alloc] init];
                alertEvent.eventId=[[[[[eventListElement objectAtIndex:i] elementsForName:@"eventId"] objectAtIndex:0] stringValue] integerValue];
                alertEvent.alertId=[[[[[eventListElement objectAtIndex:i] elementsForName:@"alertId"] objectAtIndex:0] stringValue] integerValue];
                alertEvent.objectId=[[[[[eventListElement objectAtIndex:i] elementsForName:@"objectId"] objectAtIndex:0] stringValue] integerValue];
                alertEvent.sentNotificationYN=[[[[[eventListElement objectAtIndex:i] elementsForName:@"sentNotificationYN"] objectAtIndex:0] stringValue] boolValue];
                alertEvent.fieldValue=[[[[eventListElement objectAtIndex:i] elementsForName:@"fieldValue"] objectAtIndex:0] stringValue];
                alertEvent.createTime=[[[[eventListElement objectAtIndex:i] elementsForName:@"createTime"] objectAtIndex:0] stringValue];
                alertEvent.emailAddress=[[[[eventListElement objectAtIndex:i] elementsForName:@"emailAddress"] objectAtIndex:0] stringValue];
                alertEvent.sentMsg=[[[[eventListElement objectAtIndex:i] elementsForName:@"sentMsg"] objectAtIndex:0] stringValue];
                [eventArray addObject:alertEvent];
                [alertEvent release];
            }
            
        }else{
            [self notificationErrorCode:errorMsg];
        }
    }
    
    return eventArray;
}


-(NSArray *)getShotImgNameList:(NSInteger)objectId withMaxNum:(NSInteger)maxNum{
    NSMutableArray *imageNameList=[[NSMutableArray alloc] init];
    
    NSString *userId=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERID];
    NSString *secToken=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SECTOKEN];
    NSString* service=[NSString stringWithFormat:@"%@getShotImgNameList?senderId=%@&secToken=%@&objectId=%d&maxNum=%d",self.connect_header,userId,secToken,objectId,maxNum];
    NSLog(@"getShotImgNameList URL: %@",service);
    NSData *data=[self requestURLSync:service];
    if(data){
        GDataXMLElement *rootElement=[self getRootElementByData:data];
        NSString* errorCodeVal=[[[rootElement elementsForName:@"errorCode"] objectAtIndex:0] stringValue];
        NSString* errorMsg=[[[rootElement elementsForName:@"errorMsg"] objectAtIndex:0] stringValue];
        if([errorCodeVal isEqualToString:@"0"]){
            NSArray *nameList=[rootElement elementsForName:@"nameList"];
            if(nameList==nil){
                return nil;
            }
            for(int i=0;i<[nameList count];i++){
                [imageNameList addObject:[[nameList objectAtIndex:i] stringValue]];
                
            }
            
            return imageNameList;
        }else{
            [self notificationErrorCode:errorMsg];
        }
    }
    return nil;
}
-(NSString *)getShotImgByName:(NSInteger)objectId withName:(NSString *)name{
    NSString *userId=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERID];
    NSString *secToken=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SECTOKEN];
    NSString* service=[NSString stringWithFormat:@"%@getShotImgByName?senderId=%@&secToken=%@&objectId=%d&name=%@",self.connect_header,userId,secToken,objectId,name];
    NSLog(@"getShotImgByName URL: %@",service);
    NSData *data=[self requestURLSync:service];
    if(data){
        GDataXMLElement *rootElement=[self getRootElementByData:data];
        NSString* errorCodeVal=[[[rootElement elementsForName:@"errorCode"] objectAtIndex:0] stringValue];
        NSString* errorMsg=[[[rootElement elementsForName:@"errorMsg"] objectAtIndex:0] stringValue];
        if([errorCodeVal isEqualToString:@"0"]){
            
            return [[[rootElement elementsForName:@"base64String"] objectAtIndex:0] stringValue];
            
        }else{
            [self notificationErrorCode:errorMsg];
        }
    }
    return nil;
}

#pragma mark create user elsysapi 提供
-(BOOL)createUser:(NSString *)userName password:(NSString *)_pass email:(NSString *)_email phoneNumber:(NSString *)phnumber appId:(int)appId{
    NSString* service=[NSString stringWithFormat:@"%@createUser?loginName=%@&password=%@&email=%@&phoneNumber=%@&appId=%d&type=4",self.sysApiUrl,userName,[WsqMD5Util getmd5WithString:_pass],_email,phnumber,appId];
    
    
    NSLog(@"createUser URL: %@",service);
    NSData *data=[self requestURLSync:service];
    if(data){
        GDataXMLElement *rootElement=[self getRootElementByData:data];
        NSString* errorCodeVal=[[[rootElement elementsForName:@"errorCode"] objectAtIndex:0] stringValue];
        NSString* errorMsg=[[[rootElement elementsForName:@"errorMsg"] objectAtIndex:0] stringValue];
        if([errorCodeVal isEqualToString:@"0"]){
            return YES;
        }else{
            [self notificationErrorCode:errorMsg];
        }
    }
    return NO;
}




/*  webservice API end......
 ***************************************************************
 */





#pragma private
NSString *kErrorCodeKey=@"key_error_code";
NSString *kErrorAlertNotification=@"key_error_notifiaction";
-(void)notificationErrorCode:(NSString *)errorCode{
    dispatch_async(dispatch_get_main_queue(), ^{
        if(errorCode!=nil){
            NSDictionary *infoDic=[NSDictionary dictionaryWithObject:errorCode forKey:kErrorCodeKey];
            [[NSNotificationCenter defaultCenter] postNotificationName:kErrorAlertNotification object:nil userInfo:infoDic];
        }
      
    });
}
-(GDataXMLElement *)getRootElementByData:(NSData *)data{
    GDataXMLDocument *doc=[[[GDataXMLDocument alloc] initWithData:data options:0 error:nil] autorelease];
    GDataXMLElement *rootElement=[doc rootElement];
    return rootElement;
}

-(NSData *)requestURLSync:(NSString *)service{
    NSURL* url=[NSURL URLWithString:service];
    NSMutableURLRequest* request=[NSMutableURLRequest requestWithURL:url];
    [request setTimeoutInterval:12];
    [request setHTTPMethod:@"GET"];
    NSURLResponse* response=nil;
    NSError* error=nil;
    NSData * data=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if(data!=nil){
        return data;
    }else{
        NSString *errorDescription=nil;
        errorDescription=error.localizedDescription;
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self notificationErrorCode:errorDescription];
            
        });
    }
    return nil;
}

#pragma nouse
-(NSData *)requestURL:(NSString *)service{
    NSURL* url=[NSURL URLWithString:service];
    NSMutableURLRequest* request=[NSMutableURLRequest requestWithURL:url];
    [request setTimeoutInterval:DEFAULT_TIME_OUT];
    [request setHTTPMethod:@"GET"];
    NSOperationQueue* queue=[[NSOperationQueue alloc] init];
     [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
         NSLog(@"asyn RESPONSE :%@  NSDATA :%@  NSERROR:%@",response,[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease],connectionError);
     }];
    return nil;
}

+(id)allocWithZone:(struct _NSZone *)zone{
    @synchronized(self){
        if(shareService==nil){
            shareService=[super allocWithZone:zone];
            return shareService;
        }
    }
    return nil;
}
-(id)copyWithZone:(NSZone *)zone{
    return self;
}
-(id)retain{
    return self;
}
-(oneway void)release{
    
}
-(id)autorelease{
    return self;
}
- (instancetype)init
{
    @synchronized(self){
        self=[super init];
        return self;
    }
    
}

@end
