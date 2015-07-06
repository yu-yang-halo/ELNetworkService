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
#import "ELClassObject.h"

#define KEY_USERID @"elian_userId_key"
#define KEY_SECTOKEN @"elian_sectoken_key"
#define KEY_ADMIN_USERID @"elian_admin_userId_key"
#define KEY_ADMIN_SECTOKEN @"elian_admin_sectoken_key"
#define KEY_ADMIN_APPID @"elian_admin_appID_key"
#define DEFAULT_TIME_OUT 11

@interface ElApiService()
-(NSData *)requestURLSync:(NSString *)service;
-(NSData *)requestURL:(NSString *)service;
-(GDataXMLElement *)getRootElementByData:(NSData *)data;
#pragma mark 获取系统登录权限
-(void)sysLogin:(NSString *)name andPassword:(NSString *)password withYN:(BOOL)logoutYN;
#pragma mark 网络错误汇报
-(void)notificationErrorCode:(NSString *)errorCode;
@end

@implementation ElApiService (ClassData)

-(ELClassObject *)getClassById:(NSInteger)classId{
    NSString *userId=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_ADMIN_USERID];
    NSString *secToken=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_ADMIN_SECTOKEN];
    
    if(userId==nil||secToken==nil){
        [self sysLogin:@"elhome" andPassword:@"elhome" withYN:NO];
        userId=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_ADMIN_USERID];
        secToken=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_ADMIN_SECTOKEN];
    }
    
    
    
    NSString* service=[NSString stringWithFormat:@"%@getClass?senderId=%@&secToken=%@&classId=%d",self.connect_header,userId,secToken,classId];
    
    NSLog(@"getClassById URL: %@",service);

    NSData *data=[self requestURLSync:service];
    if(data){
        GDataXMLElement *rootElement=[self getRootElementByData:data];
        NSString* errorCodeVal=[[[rootElement elementsForName:@"errorCode"] objectAtIndex:0] stringValue];
        NSString* errorMsg=[[[rootElement elementsForName:@"errorMsg"] objectAtIndex:0] stringValue];
        
        if([errorCodeVal isEqualToString:@"0"]){
            
            NSInteger classId=[[[[rootElement elementsForName:@"classId"] objectAtIndex:0] stringValue] integerValue];
            
            NSString *clsName=[[[rootElement elementsForName:@"clsName"] objectAtIndex:0] stringValue];
            NSString *displayName=[[[rootElement elementsForName:@"displayName"] objectAtIndex:0] stringValue];
            NSInteger clsType=[[[[rootElement elementsForName:@"clsType"] objectAtIndex:0] stringValue] integerValue];
            NSInteger appId=[[[[rootElement elementsForName:@"appId"] objectAtIndex:0] stringValue] integerValue];
            NSInteger deviceMsgFormat=[[[[rootElement elementsForName:@"deviceMsgFormat"] objectAtIndex:0] stringValue] integerValue];
            NSInteger access=[[[[rootElement elementsForName:@"access"] objectAtIndex:0] stringValue] integerValue];
            NSString *icon=[[[rootElement elementsForName:@"icon"] objectAtIndex:0] stringValue];
            
            ELClassObject *elClassObject=[[ELClassObject alloc] init];
            elClassObject.classId=classId;
            elClassObject.clsName=clsName;
            [clsName release];
            clsName=nil;
            
            elClassObject.displayName=displayName;
            [displayName release];
            displayName=nil;
            
            elClassObject.icon=icon;
            [icon release];
            icon=nil;
            
            
            elClassObject.clsType=clsType;
            
            elClassObject.appId=appId;
            
            elClassObject.deviceMsgFormat=deviceMsgFormat;
            elClassObject.access=access;
            
            NSMutableArray *fieldsArray=[NSMutableArray new];
            
            
            NSArray *fieldListNode=[rootElement elementsForName:@"fieldList"];
            
            for(GDataXMLElement *element in fieldListNode){
                
                NSInteger fieldId=[[[[element elementsForName:@"fieldId"] objectAtIndex:0] stringValue] integerValue];
                NSString  *fieldName=[[[element elementsForName:@"fieldName"] objectAtIndex:0] stringValue];
                NSString  *displayName=[[[element elementsForName:@"displayName"] objectAtIndex:0] stringValue];
                NSInteger dataType=[[[[element elementsForName:@"dataType"] objectAtIndex:0] stringValue] integerValue];
                
                BOOL deviceStateYN=[[[[element elementsForName:@"deviceStateYN"] objectAtIndex:0] stringValue] boolValue];
                BOOL deviceCmdYN=[[[[element elementsForName:@"deviceCmdYN"] objectAtIndex:0] stringValue] boolValue];
                BOOL tsYN=[[[[element elementsForName:@"tsYN"] objectAtIndex:0] stringValue] boolValue];
                BOOL presistYN=[[[[element elementsForName:@"presistYN"] objectAtIndex:0] stringValue] boolValue];
                NSInteger aggrMethod=[[[[element elementsForName:@"aggrMethod"] objectAtIndex:0] stringValue] integerValue];
                
                NSString *defaultValue=[[[element elementsForName:@"defaultValue"] objectAtIndex:0] stringValue];
                
                NSInteger widget=[[[[element elementsForName:@"widget"] objectAtIndex:0] stringValue] integerValue];
                
                NSString *ficon=[[[element elementsForName:@"icon"] objectAtIndex:0] stringValue];
                
                
                ELClassField *elClassField=[[ELClassField alloc] init];
                elClassField.fieldId=fieldId;
                elClassField.fieldName=fieldName;
                elClassField.displayName=displayName;
                elClassField.dataType=dataType;
                elClassField.deviceStateYN=deviceStateYN;
                elClassField.deviceCmdYN=deviceCmdYN;
                elClassField.tsYN=tsYN;
                elClassField.presistYN=presistYN;
                elClassField.aggrMethod=aggrMethod;
                
                elClassField.icon=ficon;
                elClassField.widget=widget;
                
                
                if(defaultValue!=nil){
                    elClassField.defaultValue=defaultValue;
                }else{
                    elClassField.defaultValue=@"999";
                }
                
                
                [fieldsArray addObject:elClassField];
                [elClassField release];
                elClassField=nil;
            }
            
            elClassObject.classFields=fieldsArray;
            [fieldsArray release];
            fieldsArray=nil;
            
            return elClassObject;
            
        }else{
            [self notificationErrorCode:errorMsg];
        }
    }
    return nil;
}

@end
static NSString *requestURL=ELSERVICE_URL;
static NSInteger _platform=HYLPLATFORM_ELHOME;


@implementation ElApiService
+(void)setPlatformType:(HYLPLATFORM) platform{
    if(platform==HYLPLATFORM_DEVELOPER){
        requestURL=DEVELOPER_URL;
    }else if (platform==HYLPLATFORM_ELHOME){
        requestURL=ELSERVICE_URL;
    }else if(platform==HYLPLATFORM_TEST){
        requestURL=TEST_URL;
    }
    _platform=platform;
    if(shareService!=nil){
        [shareService release];
        shareService=nil;
    }
    
}
+(ElApiService *) shareElApiService{
    @synchronized([ElApiService class]){
        if(shareService==nil){
            shareService=[[ElApiService alloc] init];
            shareService.connect_header=[NSString stringWithFormat:@"http://%@:%d/elws/services/elwsapi/",requestURL,ELSERVICE_PORT];
        }
        return shareService;
    }
    
}

#pragma mark create user
-(BOOL)createUser:(NSString *)userName password:(NSString *)_pass email:(NSString *)_email{
    [self sysLogin:@"elhome" andPassword:@"elhome" withYN:NO];
    
    NSString *userId=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_ADMIN_USERID];
    NSString *secToken=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_ADMIN_SECTOKEN];
    NSString *phoneNUM=@"";
    if([Util isMobileNumber:userName]){
        phoneNUM=userName;
    }
    if(_email==nil){
        _email=@"";
    }
    NSString* service=[NSString stringWithFormat:@"%@createUser?senderId=%@&secToken=%@&loginName=%@&password=%@&email=%@&phoneNumber=%@&realName=%@&appId=2&type=4&serviceId=1",self.connect_header,userId,secToken,userName,[WsqMD5Util getmd5WithString:_pass],_email,phoneNUM,userName];
    
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


#pragma mark message
-(BOOL)sendEmailShortMsg:(NSString *)address withType:(NSInteger)addressType andText:(NSString *)text{
    [self sysLogin:@"elhome" andPassword:@"elhome" withYN:NO];
    NSString *userId=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_ADMIN_USERID];
    NSString *secToken=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_ADMIN_SECTOKEN];
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

-(NSString *)getShortMsgCodeByUser:(NSString *)userName{
    [self sysLogin:@"elhome" andPassword:@"elhome" withYN:NO];
    NSString *userId=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_ADMIN_USERID];
    NSString *secToken=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_ADMIN_SECTOKEN];
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
-(BOOL)sendShortMsgCodeByUser:(NSString *)userName withType:(NSInteger)type{
    [self sysLogin:@"elhome" andPassword:@"elhome" withYN:NO];
    NSString *userId=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_ADMIN_USERID];
    NSString *secToken=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_ADMIN_SECTOKEN];
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
-(NSArray *)getGatewayListByIP:(NSString *)ipAddress{
    NSMutableArray *gwArray=[[[NSMutableArray alloc] init] autorelease];
    [self sysLogin:@"elhome" andPassword:@"elhome" withYN:NO];
    
    NSString *userId=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_ADMIN_USERID];
    NSString *secToken=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_ADMIN_SECTOKEN];
    NSString* service=[NSString stringWithFormat:@"%@getGatewayListByIP?senderId=%@&secToken=%@&ipAddr=%@",self.connect_header,userId,secToken,ipAddress];
    NSLog(@"getGatewayListByIP URL: %@",service);
    NSData *data=[self requestURLSync:service];
    if(data){
        GDataXMLElement *rootElement=[self getRootElementByData:data];
        NSString* errorCodeVal=[[[rootElement elementsForName:@"errorCode"] objectAtIndex:0] stringValue];
        NSString* errorMsg=[[[rootElement elementsForName:@"errorMsg"] objectAtIndex:0] stringValue];
        NSArray *gwListElement=[rootElement elementsForName:@"gwList"];
        if([errorCodeVal isEqualToString:@"0"]){
            for (int i=0;i<[gwListElement count];i++) {
                ELDeviceInfo *deviceInfo=[[[ELDeviceInfo alloc] init] autorelease];
                deviceInfo.clientId=[[[[[gwListElement objectAtIndex:i] elementsForName:@"clientId"] objectAtIndex:0] stringValue] integerValue];
                deviceInfo.sn=[[[[gwListElement objectAtIndex:i] elementsForName:@"sn"] objectAtIndex:0] stringValue];
                [gwArray addObject:deviceInfo];
                
            }
        }else{
            [self notificationErrorCode:errorMsg];
        }
    }
    return gwArray;
}
-(NSArray *)getChildDevicesByGW:(NSInteger)gwClientId{
    NSMutableArray *deviceArray=[[[NSMutableArray alloc] init] autorelease];
    [self sysLogin:@"elhome" andPassword:@"elhome" withYN:NO];
    NSString *userId=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_ADMIN_USERID];
    NSString *secToken=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_ADMIN_SECTOKEN];
    NSString* service=[NSString stringWithFormat:@"%@getChildDevicesByGW?senderId=%@&secToken=%@&gatewayId=%d",self.connect_header,userId,secToken,gwClientId];
    NSLog(@"getChildDevicesByGW URL: %@",service);
    NSData *data=[self requestURLSync:service];
    if(data){
        GDataXMLElement *rootElement=[self getRootElementByData:data];
        NSString* errorCodeVal=[[[rootElement elementsForName:@"errorCode"] objectAtIndex:0] stringValue];
        NSString* errorMsg=[[[rootElement elementsForName:@"errorMsg"] objectAtIndex:0] stringValue];
        NSArray *deviceListElement=[rootElement elementsForName:@"deviceList"];
        if([errorCodeVal isEqualToString:@"0"]){
            for (int i=0;i<[deviceListElement count];i++) {
                ELDeviceInfo *deviceInfo=[[[ELDeviceInfo alloc] init] autorelease];
                deviceInfo.clientId=[[[[[deviceListElement objectAtIndex:i] elementsForName:@"clientId"] objectAtIndex:0] stringValue] integerValue];
                deviceInfo.sn=[[[[deviceListElement objectAtIndex:i] elementsForName:@"sn"] objectAtIndex:0] stringValue];
                [deviceArray addObject:deviceInfo];
            }
        }else{
            [self notificationErrorCode:errorMsg];
        }
    }
    return deviceArray;
}
-(BOOL)createAlert:(ELAlertCondition *)alert toDevice:(NSInteger)objectId{
    NSString *userId=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERID];
    NSString *secToken=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SECTOKEN];
    NSString* service=[NSString stringWithFormat:@"%@createAlert?senderId=%@&secToken=%@&objectId=%d&useScriptYN=%d&fieldId=%d&operator=%@&threshhold=%f&alertMsgText=%@&autoDisarmYN=%d&numOfSend=%d&mode=%d",self.connect_header,userId,secToken,objectId,alert.useScriptFlag,alert.fieldId,alert.Operator,alert.threshold,[Util encodeToPercentEscapeString:alert.msgText],alert.autoDisarm,alert.numOfSend,alert.mode];
    
    NSLog(@"createAlert URL: %@",service);
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
-(NSInteger)createObject:(ELDeviceObject *)devObj{
    NSString *userId=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERID];
    NSString *secToken=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SECTOKEN];
    NSString* service=[NSString stringWithFormat:@"%@createObject?senderId=%@&secToken=%@&ownerUserId=%@&classId=%d&name=%@&desc=%@&ccsClientId=%d&ccsClientSn=%@&gatewayId=%d&parentId=1&locId=%d&accessYN=%d&connType=%d",self.connect_header,userId,secToken,userId,devObj.classId,[Util encodeToPercentEscapeString:devObj.name],[Util encodeToPercentEscapeString:devObj.name],devObj.ccsClientId,devObj.clientSn,devObj.gatewayId,devObj.locId,devObj.accessYN,devObj.connType];
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

#pragma mrak executeScenario
-(BOOL)deleteScenario:(NSInteger)scenarioId{
    NSString *userId=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERID];
    NSString *secToken=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SECTOKEN];
    NSString* service=[NSString stringWithFormat:@"%@deleteScenario?senderId=%@&secToken=%@&scenarioId=%d",self.connect_header,userId,secToken,scenarioId];
    NSLog(@"deleteScenario URL: %@",service);
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
-(NSInteger)createScenario:(NSString *)name withImageId:(NSInteger)imageId{
    NSString *userId=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERID];
    NSString *secToken=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SECTOKEN];
    NSString* service=[NSString stringWithFormat:@"%@createScenario?senderId=%@&secToken=%@&userId=%@&name=%@&imageId=%d&activeYN=true",self.connect_header,userId,secToken,userId,[Util encodeToPercentEscapeString:name],imageId];
    NSLog(@"createScenario URL: %@",service);
    NSData *data=[self requestURLSync:service];
    if(data){
        GDataXMLElement *rootElement=[self getRootElementByData:data];
        NSString* errorCodeVal=[[[rootElement elementsForName:@"errorCode"] objectAtIndex:0] stringValue];
        NSString* errorMsg=[[[rootElement elementsForName:@"errorMsg"] objectAtIndex:0] stringValue];
        if([errorCodeVal isEqualToString:@"0"]){
            return [[[[rootElement elementsForName:@"scenarioId"] objectAtIndex:0] stringValue] integerValue];
        }else{
            [self notificationErrorCode:errorMsg];
        }
    }
    return -1;
}
-(BOOL)addTaskToScenario:(NSInteger)scenarioId withTask:(ELSimpleTask *)task{
    NSString *userId=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERID];
    NSString *secToken=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SECTOKEN];
    NSMutableString* service=[NSMutableString stringWithFormat:@"%@addTaskToScenario?senderId=%@&secToken=%@&scenarioId=%d&taskType=%d&objectId=%d",self.connect_header,userId,secToken,scenarioId,task.taskType,task.objectId];
    if(task.fieldId!=0){
        [service appendFormat:@"&fieldId=%d&fieldValue=%@&alertId=0&alertMode=0",task.fieldId,task.fieldValue];
    }
    if(task.alertId!=0){
         [service appendFormat:@"&fieldId=0&fieldValue=0&alertId=%d&alertMode=%d",task.alertId,task.alertMode];
    }
    
    NSLog(@"addTaskToScenario URL: %@",service);
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

-(BOOL)executeScenario:(NSInteger)scenarioId{
    NSString *userId=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERID];
    NSString *secToken=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SECTOKEN];
    NSString* service=[NSString stringWithFormat:@"%@executeScenario?senderId=%@&secToken=%@&scenarioId=%d",self.connect_header,userId,secToken,scenarioId];
    NSLog(@"executeScenario URL: %@",service);
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
#pragma mark getScenarioListByUser
-(NSMutableArray *)getScenarioListByUser{
    NSMutableArray *cacheScenarioList=[[[NSMutableArray alloc] init] autorelease];
    NSString *userId=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERID];
    NSString *secToken=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SECTOKEN];
    NSString* service=[NSString stringWithFormat:@"%@getScenarioListByUser?senderId=%@&secToken=%@&userId=%@",self.connect_header,userId,secToken,userId];
    NSLog(@"getScenarioListByUser URL: %@",service);
    NSData *data=[self requestURLSync:service];
    if(data){
        GDataXMLElement *rootElement=[self getRootElementByData:data];
        NSString* errorCodeVal=[[[rootElement elementsForName:@"errorCode"] objectAtIndex:0] stringValue];
        NSString* errorMsg=[[[rootElement elementsForName:@"errorMsg"] objectAtIndex:0] stringValue];
        if([errorCodeVal isEqualToString:@"0"]){
            NSArray *scenarioInfoList=[rootElement elementsForName:@"scenarioInfoList"];
            for (int i=0;i<scenarioInfoList.count;i++) {
                GDataXMLElement *element=[scenarioInfoList objectAtIndex:i];
                ELScenario *scenario=[[ELScenario alloc] init];
                
                scenario.scenarioId=[[[[element elementsForName:@"scenarioId"] objectAtIndex:0] stringValue] integerValue];
                scenario.name=[[[element elementsForName:@"name"] objectAtIndex:0] stringValue];
                scenario.imageId=[[[[element elementsForName:@"imageId"] objectAtIndex:0] stringValue] integerValue];
                scenario.activeYN=[[[[element elementsForName:@"activeYN"] objectAtIndex:0] stringValue] boolValue];
                scenario.creatorId=[[[[element elementsForName:@"creatorId"] objectAtIndex:0] stringValue] integerValue];
                
                [cacheScenarioList addObject:scenario];
                [scenario release];
            }
        }else{
            [self notificationErrorCode:errorMsg];
        }
    }
    return cacheScenarioList;
}
#pragma mark getScenarioDetail
-(ELScenarioDetail *)getScenarioDetail:(NSInteger)scenarioId{
    ELScenarioDetail *detail=[[[ELScenarioDetail alloc] init] autorelease];
    NSString *userId=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERID];
    NSString *secToken=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SECTOKEN];
    NSString* service=[NSString stringWithFormat:@"%@getScenarioDetail?senderId=%@&secToken=%@&scenarioId=%d",self.connect_header,userId,secToken,scenarioId];
    NSLog(@"getScenarioDetail URL: %@",service);
    NSData *data=[self requestURLSync:service];
    if(data){
        GDataXMLElement *rootElement=[self getRootElementByData:data];
        NSString* errorCodeVal=[[[rootElement elementsForName:@"errorCode"] objectAtIndex:0] stringValue];
        NSString* errorMsg=[[[rootElement elementsForName:@"errorMsg"] objectAtIndex:0] stringValue];
        if([errorCodeVal isEqualToString:@"0"]){
            detail.scenarioId=[[[[rootElement elementsForName:@"scenarioId"] objectAtIndex:0] stringValue] integerValue];
            detail.name=[[[rootElement elementsForName:@"name"] objectAtIndex:0] stringValue];
            detail.imageId=[[[[rootElement elementsForName:@"imageId"] objectAtIndex:0] stringValue] integerValue];
            detail.activeYN=[[[[rootElement elementsForName:@"activeYN"] objectAtIndex:0] stringValue] boolValue];
            NSMutableArray *taskList=[[[NSMutableArray alloc] init] autorelease];
            NSArray *taskListElements=[rootElement elementsForName:@"taskList"];
            for (int i=0;i<[taskListElements count];i++) {
                GDataXMLElement *taskElement=[taskListElements objectAtIndex:i];
                ELSimpleTask *task=[[[ELSimpleTask alloc] init] autorelease];
                task.taskId=[[[[taskElement elementsForName:@"taskId"] objectAtIndex:0] stringValue] integerValue];
                task.objectId=[[[[taskElement elementsForName:@"objectId"] objectAtIndex:0] stringValue] integerValue];
                task.fieldId=[[[[taskElement elementsForName:@"fieldId"] objectAtIndex:0] stringValue] integerValue];
                task.fieldValue=[[[taskElement elementsForName:@"fieldValue"] objectAtIndex:0] stringValue] ;
                task.alertId=[[[[taskElement elementsForName:@"alertId"] objectAtIndex:0] stringValue] integerValue];
                task.alertMode=[[[[taskElement elementsForName:@"alertMode"] objectAtIndex:0] stringValue] integerValue];
                task.taskType=[[[[taskElement elementsForName:@"taskType"] objectAtIndex:0] stringValue] integerValue];
                [taskList insertObject:task atIndex:i];
            }
            detail.taskList=taskList;
        }else{
            [self notificationErrorCode:errorMsg];
        }
    }
    return detail;
}
#pragma mark activateTask
-(BOOL)activateTask:(NSInteger)taskId withYN:(BOOL)activeYN{
    NSString *userId=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERID];
    NSString *secToken=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SECTOKEN];
    NSString* service=[NSString stringWithFormat:@"%@activateTask?senderId=%@&secToken=%@&taskId=%d&activeYN=%d",self.connect_header,userId,secToken,taskId,activeYN];
    NSLog(@"activateTask URL: %@",service);
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
-(BOOL)createTask:(ELScheduleTask *)task{
    NSString *userId=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERID];
    NSString *secToken=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SECTOKEN];
    NSMutableString* service=[NSMutableString stringWithFormat:@"%@createTask?senderId=%@&secToken=%@&taskId=%d&objectId=%d&fieldId=%d&fieldValue=%@&executionType=%d&freq=%d&createUserId=%@&alertId=%d&activeYN=%d",self.connect_header,userId,secToken,task.taskId,task.objectId,task.fieldId,task.fieldValue,task.executionType,task.freq,userId,task.alertId,task.activeYN];
    if(task.executionTime!=nil){
        [service appendFormat:@"&executionTime=%@",task.executionTime];
    }
    NSLog(@"createTask URL: %@",service);
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
-(BOOL)deleteTask:(NSInteger)taskId{
    NSString *userId=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERID];
    NSString *secToken=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SECTOKEN];
    NSMutableString* service=[NSMutableString stringWithFormat:@"%@deleteTask?senderId=%@&secToken=%@&taskId=%d",self.connect_header,userId,secToken,taskId];
    NSLog(@"deleteTask URL: %@",service);
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
-(BOOL)updateTask:(ELScheduleTask *)task{
    NSString *userId=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERID];
    NSString *secToken=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SECTOKEN];
    NSMutableString* service=[NSMutableString stringWithFormat:@"%@updateTask?senderId=%@&secToken=%@&taskId=%d&objectId=%d",self.connect_header,userId,secToken,task.taskId,task.objectId];
    if(task.alertId<=0){
        [service appendFormat:@"&fieldId=%d&fieldValue=%@&executionType=%d&executionTime=%@&activeYN=%d",task.fieldId,task.fieldValue ,task.executionType,task.executionTime,task.activeYN];
    }else{
        [service appendFormat:@"&fieldId=%d&fieldValue=%@&executionType=%d&alertId=%d&activeYN=%d",task.fieldId,task.fieldValue,task.executionType,task.alertId,task.activeYN];
    }
    NSLog(@"updateTask URL: %@",service);
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
-(NSArray *)getTaskListByObject:(NSInteger)objectId{
    NSMutableArray *taskArray=[[[NSMutableArray alloc] init] autorelease];
    NSString *userId=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERID];
    NSString *secToken=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SECTOKEN];
    NSString* service=[NSString stringWithFormat:@"%@getTaskListByObject?senderId=%@&secToken=%@&objectId=%d",self.connect_header,userId,secToken,objectId];
    NSLog(@"getTaskListByObject URL: %@",service);
    NSData *data=[self requestURLSync:service];
    if(data){
        GDataXMLElement *rootElement=[self getRootElementByData:data];
        NSString* errorCodeVal=[[[rootElement elementsForName:@"errorCode"] objectAtIndex:0] stringValue];
        NSString* errorMsg=[[[rootElement elementsForName:@"errorMsg"] objectAtIndex:0] stringValue];
        if([errorCodeVal isEqualToString:@"0"]){
             NSArray *taskListElements=[rootElement elementsForName:@"taskList"];
            for (int i=0;i<[taskListElements count];i++) {
                GDataXMLElement *taskElement=[taskListElements objectAtIndex:i];
                ELScheduleTask *task=[[ELScheduleTask alloc] init];
                task.taskId=[[[[taskElement elementsForName:@"taskId"] objectAtIndex:0] stringValue] integerValue];
                task.alertId=[[[[taskElement elementsForName:@"alertId"] objectAtIndex:0] stringValue] integerValue];
                task.objectId=[[[[taskElement elementsForName:@"objectId"] objectAtIndex:0] stringValue] integerValue];
                task.fieldId=[[[[taskElement elementsForName:@"fieldId"] objectAtIndex:0] stringValue] integerValue];
                task.fieldValue=[[[taskElement elementsForName:@"fieldValue"] objectAtIndex:0] stringValue] ;
                task.createUserId=[[[[taskElement elementsForName:@"createUserId"] objectAtIndex:0] stringValue] integerValue];
                task.executionType=[[[[taskElement elementsForName:@"executionType"] objectAtIndex:0] stringValue] integerValue];
                task.executionTime=[[[taskElement elementsForName:@"executionTime"] objectAtIndex:0] stringValue] ;
                task.freq=[[[[taskElement elementsForName:@"freq"] objectAtIndex:0] stringValue] integerValue];
                task.activeYN=[[[[taskElement elementsForName:@"activeYN"] objectAtIndex:0] stringValue] boolValue];
                
                if(task.objectId==objectId){
                    [taskArray addObject:task];
                }
                
                [task release];
            }
            
        }else{
            [self notificationErrorCode:errorMsg];
        }
    }
    return taskArray;

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
#pragma mark getLocationList
-(NSArray *)getLocationList{
    [self sysLogin:@"elhome" andPassword:@"elhome" withYN:NO];
    NSString *userId=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_ADMIN_USERID];
    NSString *secToken=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_ADMIN_SECTOKEN];
    NSString* service=[NSString stringWithFormat:@"%@getLocationList?senderId=%@&secToken=%@&appId=2",self.connect_header,userId,secToken];
    NSLog(@"getLocationList URL: %@",service);
    NSData *data=[self requestURLSync:service];
    NSMutableArray *_locArray=[[[NSMutableArray alloc] init] autorelease];
    if(data){
        GDataXMLElement *rootElement=[self getRootElementByData:data];
        NSString* errorCodeVal=[[[rootElement elementsForName:@"errorCode"] objectAtIndex:0] stringValue];
        NSString* errorMsg=[[[rootElement elementsForName:@"errorMsg"] objectAtIndex:0] stringValue];
        if([errorCodeVal isEqualToString:@"0"]){
            NSArray *locationList=[rootElement elementsForName:@"locationList"];
           
            for (int i=0;i<[locationList count];i++) {
                GDataXMLElement *_ele=[locationList objectAtIndex:i];
                if([[[[_ele elementsForName:@"locId"] objectAtIndex:0] stringValue] integerValue]>=1000){
                    NSMutableDictionary *_locationObj=[[NSMutableDictionary alloc] init];
                    
                    [_locationObj setObject:[[[_ele elementsForName:@"locId"] objectAtIndex:0] stringValue] forKey:@"locId"] ;
                    [_locationObj setObject:[[[_ele elementsForName:@"roomName"] objectAtIndex:0] stringValue] forKey:@"roomName"] ;
                    
                    [_locArray addObject:_locationObj];
                    [_locationObj release];
                }
            }
        }else{
            [self notificationErrorCode:errorMsg];
        }
    }
    return [Util sortByLocId:_locArray];
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
            ELDeviceObject *deviceObject=[[ELDeviceObject alloc] init];
            deviceObject.objectId=[[[[rootElement elementsForName:@"objectId"] objectAtIndex:0] stringValue] integerValue];
            deviceObject.classId=[[[[rootElement elementsForName:@"classId"] objectAtIndex:0]  stringValue] integerValue];
            if(deviceObject.classId==ELDEVICECLASSTYPE_IPCAMERA){
                deviceObject.netState=1;
            }else{
                deviceObject.netState=[[[[rootElement elementsForName:@"netState"] objectAtIndex:0]  stringValue] integerValue];
            }
            deviceObject.locId=[[[[rootElement elementsForName:@"locId"] objectAtIndex:0]  stringValue] integerValue];
            deviceObject.ccsClientId=[[[[rootElement elementsForName:@"ccsClientId"] objectAtIndex:0]  stringValue] integerValue];
            deviceObject.gatewayId=[[[[rootElement elementsForName:@"gatewayId"] objectAtIndex:0]  stringValue] integerValue];
            
            deviceObject.bindVmId=[[[[rootElement elementsForName:@"bindVmId"] objectAtIndex:0]  stringValue] integerValue];
            
            deviceObject.clientSn=[[[rootElement elementsForName:@"clientSn"] objectAtIndex:0] stringValue];
            deviceObject.name=[[[rootElement elementsForName:@"name"] objectAtIndex:0] stringValue];
            
            NSArray *valueList=[rootElement elementsForName:@"valueList"];
            NSMutableDictionary *_fieldDic=[[[NSMutableDictionary alloc] init] autorelease];
            for (int j=0;j<[valueList count];j++) {
                GDataXMLElement *fields=[valueList objectAtIndex:j];
                NSString *_key=[[[fields elementsForName:@"fieldId"] objectAtIndex:0] stringValue];
                NSString *_value=[[[fields elementsForName:@"value"] objectAtIndex:0] stringValue];
                [_fieldDic setObject:_value forKey:[NSString stringWithFormat:@"%@",_key]];
                
            }
            deviceObject.fieldMap=_fieldDic;
            return deviceObject;
        }else{
            [self notificationErrorCode:errorMsg];
        }
    }
    return nil;
}
#pragma mark alert
-(NSArray *)getAlertAddressList:(NSInteger)alertId{
    NSMutableArray *addressArray=[[[NSMutableArray alloc] init] autorelease];
    NSString *userId=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERID];
    NSString *secToken=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SECTOKEN];
    NSString* service=[NSString stringWithFormat:@"%@getAlertAddressList?senderId=%@&secToken=%@&alertId=%d",self.connect_header,userId,secToken,alertId];
    NSLog(@"getAlertAddressList URL: %@",service);
    NSData *data=[self requestURLSync:service];
    if(data){
        GDataXMLElement *rootElement=[self getRootElementByData:data];
        NSString* errorCodeVal=[[[rootElement elementsForName:@"errorCode"] objectAtIndex:0] stringValue];
        if([errorCodeVal isEqualToString:@"0"]){
            NSArray *addressListElement= [rootElement elementsForName:@"addressList"];
            for(int i=0;i<[addressListElement count];i++){
                ELAlertAddress *alertAddress=[[ELAlertAddress alloc] init];
                alertAddress.addressType=[[[[[addressListElement objectAtIndex:i] elementsForName:@"addressType"] objectAtIndex:0] stringValue] integerValue];
                alertAddress.address=[[[[addressListElement objectAtIndex:i] elementsForName:@"address"] objectAtIndex:0] stringValue];
                alertAddress.activeYn=[[[[[addressListElement objectAtIndex:i] elementsForName:@"activeYN"] objectAtIndex:0] stringValue] boolValue];
                [addressArray addObject:alertAddress];
                [alertAddress release];
            }
        }
    }
    return addressArray;
}
-(NSArray *)getAlertSchedule:(NSInteger)alertId{
    NSMutableArray *scheduleArray=[[[NSMutableArray alloc] init] autorelease];
    NSString *userId=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERID];
    NSString *secToken=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SECTOKEN];
    NSString* service=[NSString stringWithFormat:@"%@getAlertSchedule?senderId=%@&secToken=%@&alertId=%d",self.connect_header,userId,secToken,alertId];
    NSLog(@"getAlertSchedule URL: %@",service);
    NSData *data=[self requestURLSync:service];
    if(data){
        GDataXMLElement *rootElement=[self getRootElementByData:data];
        NSString* errorCodeVal=[[[rootElement elementsForName:@"errorCode"] objectAtIndex:0] stringValue];
        if([errorCodeVal isEqualToString:@"0"]){
            NSArray *addressListElement= [rootElement elementsForName:@"timeTable"];
            for(int i=0;i<[addressListElement count];i++){
                ELAlertSchedule *schedule=[[ELAlertSchedule alloc] init];
                schedule.startHour=[[[[[addressListElement objectAtIndex:i] elementsForName:@"startHour"] objectAtIndex:0] stringValue] integerValue];
                schedule.startMin=[[[[[addressListElement objectAtIndex:i] elementsForName:@"startMin"] objectAtIndex:0] stringValue] integerValue];
                schedule.endHour=[[[[[addressListElement objectAtIndex:i] elementsForName:@"endHour"] objectAtIndex:0] stringValue] integerValue];
                schedule.endMin=[[[[[addressListElement objectAtIndex:i] elementsForName:@"endMin"] objectAtIndex:0] stringValue] integerValue];
                [scheduleArray addObject:schedule];
                [schedule release];
            }
        }
    }
    return scheduleArray;

}

-(NSArray *)getAlertEventListByDevice:(NSInteger)objectId withMax:(NSInteger)maxNum{
    NSMutableArray *eventArray=[[[NSMutableArray alloc] init] autorelease];
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

-(BOOL)addAlertAddress:(ELAlertAddress *)alertAddress{
    NSString *userId=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERID];
    NSString *secToken=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SECTOKEN];
    NSString* service=[NSString stringWithFormat:@"%@addAlertAddress?senderId=%@&secToken=%@&alertId=%d&addressType=%d&address=%@&activeYN=%d",self.connect_header,userId,secToken,alertAddress.alertId,alertAddress.addressType,alertAddress.address,alertAddress.activeYn];
    NSLog(@"addAlertAddress URL: %@",service);
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
-(BOOL)deleteAlertAddress:(NSInteger)alertId withType:(NSInteger)addressType{
    NSString *userId=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERID];
    NSString *secToken=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SECTOKEN];
    NSString* service=[NSString stringWithFormat:@"%@deleteAlertAddress?senderId=%@&secToken=%@&alertId=%d&addressType=%d",self.connect_header,userId,secToken,alertId,addressType];
    NSLog(@"deleteAlertAddress URL: %@",service);
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
-(BOOL)addAlertSchedule:(ELAlertSchedule *)alertSchedule{
    NSString *userId=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERID];
    NSString *secToken=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SECTOKEN];
    NSString* service=[NSString stringWithFormat:@"%@addAlertSchedule?senderId=%@&secToken=%@&alertId=%d&startHour=%d&startMin=%d&endHour=%d&endMin=%d",self.connect_header,userId,secToken,alertSchedule.alertId,alertSchedule.startHour,alertSchedule.startMin,alertSchedule.endHour,alertSchedule.endMin];
    NSLog(@"addAlertSchedule URL: %@",service);
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
-(BOOL)deleteAlertSchedule:(NSInteger)alertId{
    NSString *userId=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERID];
    NSString *secToken=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SECTOKEN];
    NSString* service=[NSString stringWithFormat:@"%@deleteAlertSchedule?senderId=%@&secToken=%@&alertId=%d",self.connect_header,userId,secToken,alertId];
    NSLog(@"deleteAlertSchedule URL: %@",service);
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

-(BOOL)setAlertMode:(NSInteger) objectId withMode:(NSInteger)mode{
    NSString *userId=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERID];
    NSString *secToken=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SECTOKEN];
    NSString* service=[NSString stringWithFormat:@"%@setAlertMode?senderId=%@&secToken=%@&objectId=%d&mode=%d",self.connect_header,userId,secToken,objectId,mode];
    NSLog(@"setAlertMode URL: %@",service);
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
-(NSInteger)getAlertMode:(NSInteger)objectId{
    NSString *userId=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERID];
    NSString *secToken=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SECTOKEN];
    NSString* service=[NSString stringWithFormat:@"%@getAlertMode?senderId=%@&secToken=%@&objectId=%d",self.connect_header,userId,secToken,objectId];
    NSLog(@"getAlertMode URL: %@",service);
    NSData *data=[self requestURLSync:service];
    if(data){
        GDataXMLElement *rootElement=[self getRootElementByData:data];
        NSString* errorCodeVal=[[[rootElement elementsForName:@"errorCode"] objectAtIndex:0] stringValue];
        NSString* errorMsg=[[[rootElement elementsForName:@"errorMsg"] objectAtIndex:0] stringValue];
        if([errorCodeVal isEqualToString:@"0"]){
            return [[[[rootElement elementsForName:@"mode"] objectAtIndex:0] stringValue] integerValue];
        }else{
            [self notificationErrorCode:errorMsg];
        }
    }
    return -1;

}


-(ELAlertCondition *)getAlertByObjectId:(NSInteger)objectId{
    NSString *userId=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERID];
    NSString *secToken=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SECTOKEN];
    NSString* service=[NSString stringWithFormat:@"%@getAlertByObjectId?senderId=%@&secToken=%@&objectId=%d",self.connect_header,userId,secToken,objectId];
    NSLog(@"getAlertByObjectId URL: %@",service);
    NSData *data=[self requestURLSync:service];
    if(data){
        GDataXMLElement *rootElement=[self getRootElementByData:data];
        NSString* errorCodeVal=[[[rootElement elementsForName:@"errorCode"] objectAtIndex:0] stringValue];
        NSString* errorMsg=[[[rootElement elementsForName:@"errorMsg"] objectAtIndex:0] stringValue];
        if([errorCodeVal isEqualToString:@"0"]){
            ELAlertCondition *alertCondition=[[[ELAlertCondition alloc] init] autorelease];
            alertCondition.alertId=[[[[rootElement elementsForName:@"alertId"] objectAtIndex:0] stringValue] integerValue];
            alertCondition.objectId=[[[[rootElement elementsForName:@"objectId"] objectAtIndex:0] stringValue] integerValue];
            alertCondition.fieldId=[[[[rootElement elementsForName:@"fieldId"] objectAtIndex:0] stringValue] integerValue];
            alertCondition.useScriptFlag=[[[[rootElement elementsForName:@"useScriptFlag"] objectAtIndex:0] stringValue] boolValue];
            alertCondition.Operator=[[[rootElement elementsForName:@"operator"] objectAtIndex:0] stringValue];
            alertCondition.threshold=[[[[rootElement elementsForName:@"threshold"] objectAtIndex:0] stringValue] floatValue];
            alertCondition.conditionScript=[[[rootElement elementsForName:@"conditionScript"] objectAtIndex:0] stringValue];
            alertCondition.msgText=[[[rootElement elementsForName:@"alertMsgText"] objectAtIndex:0] stringValue];
            alertCondition.autoDisarm=[[[[rootElement elementsForName:@"autoDisarmYN"] objectAtIndex:0] stringValue] boolValue];
            alertCondition.numOfSend=[[[[rootElement elementsForName:@"numOfSend"] objectAtIndex:0] stringValue] integerValue];
            alertCondition.mode=[[[[rootElement elementsForName:@"mode"] objectAtIndex:0] stringValue] integerValue];
            return alertCondition;
        }else{
            [self notificationErrorCode:errorMsg];
        }
    }
    return nil;
}
-(NSArray *)getObjectListByClass:(NSInteger)classId{
    NSMutableArray *deviceArray=[[[NSMutableArray alloc] init] autorelease];
   [self sysLogin:@"elhome" andPassword:@"elhome" withYN:NO];
    NSString *userId=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_ADMIN_USERID];
    NSString *secToken=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_ADMIN_SECTOKEN];
    NSString *appId=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_ADMIN_APPID];
    NSString* service=[NSString stringWithFormat:@"%@getObjectListByClass?senderId=%@&secToken=%@&appId=%@&classId=%d",self.connect_header,userId,secToken,appId,classId];
    NSLog(@"getObjectListByClass URL: %@",service);
    NSData *data=[self requestURLSync:service];
    if(data){
        GDataXMLElement *rootElement=[self getRootElementByData:data];
        NSString* errorCodeVal=[[[rootElement elementsForName:@"errorCode"] objectAtIndex:0] stringValue];
        NSString* errorMsg=[[[rootElement elementsForName:@"errorMsg"] objectAtIndex:0] stringValue];
        NSArray *valueList=[rootElement elementsForName:@"valueList"];
        
        if([errorCodeVal isEqualToString:@"0"]){
            for(int i=0;i<[valueList count];i++){
                GDataXMLElement *element=[valueList objectAtIndex:i];
                ELDeviceObject *deviceObject=[[[ELDeviceObject alloc] init] autorelease];
                deviceObject.objectId=[[[[element elementsForName:@"objectId"] objectAtIndex:0] stringValue] integerValue];
                deviceObject.classId=[[[[element elementsForName:@"classId"] objectAtIndex:0]  stringValue] integerValue];
                deviceObject.name=[[[element elementsForName:@"name"] objectAtIndex:0]  stringValue];
                [deviceArray addObject:deviceObject];
            }
        }else{
            [self notificationErrorCode:errorMsg];
        }
    }
    
    return deviceArray;
}
#pragma getObjectListAndFieldsByUser
-(NSMutableDictionary *)getObjectListAndFieldsByUser{
    NSMutableDictionary *objectCache=[[[NSMutableDictionary alloc] init] autorelease];
    
    NSString *userId=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERID];
    NSString *secToken=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SECTOKEN];
    NSString* service=[NSString stringWithFormat:@"%@getObjectListAndFieldsByUser?senderId=%@&secToken=%@&userId=%@",self.connect_header,userId,secToken,userId];
    NSLog(@"getObjectListAndFieldsByUser URL: %@",service);
    NSData *data=[self requestURLSync:service];
    if(data){
        GDataXMLElement *rootElement=[self getRootElementByData:data];
        NSString* errorCodeVal=[[[rootElement elementsForName:@"errorCode"] objectAtIndex:0] stringValue];
        NSString* errorMsg=[[[rootElement elementsForName:@"errorMsg"] objectAtIndex:0] stringValue];
        NSArray *valueList=[rootElement elementsForName:@"valueList"];
        
        if([errorCodeVal isEqualToString:@"0"]){
            for(int i=0;i<[valueList count];i++){
                GDataXMLElement *element=[valueList objectAtIndex:i];
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
                NSMutableDictionary *_fieldDic=[[[NSMutableDictionary alloc] init] autorelease];
                for (int j=0;j<[fieldList count];j++) {
                    GDataXMLElement *fields=[fieldList objectAtIndex:j];
                    NSString *_key=[[[fields elementsForName:@"fieldId"] objectAtIndex:0] stringValue];
                    NSString *_value=[[[fields elementsForName:@"value"] objectAtIndex:0] stringValue];
                    [_fieldDic setObject:_value forKey:[NSString stringWithFormat:@"%@",_key]];
                    
                }
                deviceObject.fieldMap=_fieldDic;
                [objectCache setObject:deviceObject forKey:[NSString stringWithFormat:@"%d",deviceObject.objectId]];
                
                [deviceObject release];
            }
        }else{
             [self notificationErrorCode:errorMsg];
        }
    }
    //缓存到本地
    [[ELShareContext defaultContext] setDeviceList:objectCache];
    
    return objectCache;
}
-(BOOL)updateUserPass:(NSString *)password byLoginName:(NSString *)loginName{
    
    ELUserInfo *userInfo=[self findUserInfo:loginName withEmail:nil];
    if(userInfo==nil){
        return NO;
    }
    [self loginByUsername:userInfo.loginName andPassword:userInfo.password];
    NSString *userId=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERID];
    NSString *secToken=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SECTOKEN];
    NSString* service=[NSString stringWithFormat:@"%@updateUser?senderId=%@&secToken=%@&userId=%@&loginName=%@&password=%@&type=%d&appId=%d&realName=%@&email=%@&phoneNumber=%@&serviceId=%d",self.connect_header,userId,secToken,userId,userInfo.loginName,password,userInfo.type,userInfo.appId,userInfo.realName,userInfo.email,userInfo.phoneNumber,userInfo.serviceId];
    
    NSLog(@"updateUserPass URL: %@",service);
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

-(BOOL)updateUser:(ELUserInfo *)userInfo{
    NSString *userId=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERID];
    NSString *secToken=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SECTOKEN];
    NSString* service=[NSString stringWithFormat:@"%@updateUser?senderId=%@&secToken=%@&userId=%@&loginName=%@&password=%@&type=%d&appId=%d&realName=%@&email=%@&phoneNumber=%@&serviceId=%d",self.connect_header,userId,secToken,userId,userInfo.loginName,userInfo.password,userInfo.type,userInfo.appId,userInfo.realName,userInfo.email,userInfo.phoneNumber,userInfo.serviceId];
    
    NSLog(@"getObjectListAndFieldsByUser URL: %@",service);
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
-(ELUserInfo *)findUserInfo:(NSString *)loginName withEmail:(NSString *)email{
    [self sysLogin:@"elhome" andPassword:@"elhome" withYN:NO];
    
    NSString *userId=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_ADMIN_USERID];
    NSString *secToken=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_ADMIN_SECTOKEN];
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
            ELUserInfo *userInfo=[[[ELUserInfo alloc] init] autorelease];
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
-(ELUserInfo *)findUserInfo:(NSString *)loginName{
    if(loginName==nil){
        loginName=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_LOGINNAME];
    }
    [self sysLogin:@"elhome" andPassword:@"elhome" withYN:NO];
    
    NSString *userId=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_ADMIN_USERID];
    NSString *secToken=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_ADMIN_SECTOKEN];
   
    
    NSString* service=[NSString stringWithFormat:@"%@findUserInfo?senderId=%@&secToken=%@&loginName=%@",self.connect_header,userId,secToken,loginName];
    NSLog(@"findUserInfo URL: %@",service);
    NSData *data=[self requestURLSync:service];
    if(data){
        GDataXMLElement *rootElement=[self getRootElementByData:data];
        NSString* errorCodeVal=[[[rootElement elementsForName:@"errorCode"] objectAtIndex:0] stringValue];
       NSString* errorMsg=[[[rootElement elementsForName:@"errorMsg"] objectAtIndex:0] stringValue];
        if([errorCodeVal isEqualToString:@"0"]){
            ELUserInfo *userInfo=[[[ELUserInfo alloc] init] autorelease];
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

#pragma mark 获取系统登录权限
-(void)sysLogin:(NSString *)name andPassword:(NSString *)password withYN:(BOOL)logoutYN{
    
    if(_platform==HYLPLATFORM_DEVELOPER||_platform==HYLPLATFORM_TEST){
        
        [[NSUserDefaults standardUserDefaults] setObject:[[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERID] forKey:KEY_ADMIN_USERID];
        [[NSUserDefaults standardUserDefaults] setObject:[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SECTOKEN] forKey:KEY_ADMIN_SECTOKEN];
        
        NSLog(@"开发者账户自身拥有最高权限。。。");
        
        return;
        
        
    }
    NSString* service=[NSString stringWithFormat:@"%@sysLogin?name=%@&password=%@&logoutYN=%d",self.connect_header,name,password,logoutYN];
    NSLog(@"sysLogin URL: %@",service);
    NSData *data=[self requestURLSync:service];
    if(data){
        GDataXMLElement *rootElement=[self getRootElementByData:data];
         NSString* errorCodeVal=[[[rootElement elementsForName:@"errorCode"] objectAtIndex:0] stringValue];
        NSString* errorMsg=[[[rootElement elementsForName:@"errorMsg"] objectAtIndex:0] stringValue];
        NSString* userIdVal=[[[rootElement elementsForName:@"userId"] objectAtIndex:0] stringValue];
        NSString* secTokenVal=[[[rootElement elementsForName:@"secToken"] objectAtIndex:0] stringValue];
        NSString* appIdVal=[[[rootElement elementsForName:@"appId"] objectAtIndex:0] stringValue];
        NSLog(@"sys login:: errorCode:%@, userId:%@ ,secToken:%@ ,appId:%@ ",errorCodeVal,userIdVal,secTokenVal,appIdVal);
        if([errorCodeVal isEqualToString:@"0"]){
            [[NSUserDefaults standardUserDefaults] setObject:userIdVal forKey:KEY_ADMIN_USERID];
            [[NSUserDefaults standardUserDefaults] setObject:secTokenVal forKey:KEY_ADMIN_SECTOKEN];
            [[NSUserDefaults standardUserDefaults] setObject:appIdVal forKey:KEY_ADMIN_APPID];
        }else{
            [self notificationErrorCode:errorMsg];
        }

        
    }
}

#pragma api appUserLogin
-(BOOL)loginByUsername:(NSString *)username andPassword:(NSString *)password{
    NSString* service=[NSString stringWithFormat:@"%@appUserLogin?name=%@&password=%@&appId=2&clientEnv=ios&logoutYN=false",self.connect_header,[Util encodeToPercentEscapeString:username],[WsqMD5Util getmd5WithString:password]];
    
    NSLog(@"loginByUsername URL: %@",service);
    
    //登录之前清除缓存的
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:KEY_ADMIN_USERID];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:KEY_ADMIN_SECTOKEN];
    NSLog(@"登录之前清除缓存....system token clear");
    
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
            
            //[self sysLogin:@"elhome" andPassword:@"elhome" withYN:NO];
            return YES;
        }else{
            [self notificationErrorCode:errorMsg];
        }
    }
    return NO;
}

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
           // [YYProgress dismiss];
//            SIAlertView *alertView=[[SIAlertView alloc] initWithTitle:@"提示" andMessage:errorDescription];
//            [alertView addButtonWithTitle:@"确定" type:(SIAlertViewButtonTypeDestructive) handler:^(SIAlertView *alertView) {
//                
//                
//            }];
//            [alertView show];
            ////[OMGToast showWithText:errorDescription];
            
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
