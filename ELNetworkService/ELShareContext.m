//
//  ELShareContext.m
//  objectc_ehome
//
//  Created by admin on 14-10-12.
//  Copyright (c) 2014年 cn.lztech  合肥联正电子科技有限公司. All rights reserved.
//

#define LAN(key) NSLocalizedString(key, nil)

#import "ELShareContext.h"
#import "Util.h"
static ELShareContext *instance=nil;
@implementation ELShareContext
+(ELShareContext *)defaultContext{
    @synchronized(self){
        if(!instance){
            instance=[[self alloc] init];
        }
        
    }
    return instance;
}
-(NSArray *)allLocations{
    for(int i=0;i<[_allLocations count];i++){
        NSString *locName=[[NSUserDefaults standardUserDefaults] objectForKey:[[_allLocations objectAtIndex:i] objectForKey:@"locId"]];
        if(![Util isEmpty:locName]){
            [[_allLocations objectAtIndex:i]  setValue:locName forKey:@"roomName"];
        }
    }
    return _allLocations;
}
-(NSDictionary *)errorCodeMap{
    NSArray *keys=@[@"0",
                       @"1",
                       @"2",
                       @"3",
                       
                       @"1001",
                        @"1002",
                        @"1008",
                        @"1009",
                        @"1010",
                        @"1011",
                        @"1012",
                        @"1013",
                       
                        @"1014",
                        @"1015",
                        @"1016",
                        @"1017",
                        @"1018",
                        @"1019",
                        @"1020",
                        @"1021",
                        @"1022",
                        @"1023",
                        @"1024",
                        @"1025",
                        @"1026",
                        @"1027",
                        @"1028",
                        @"1029",
                        @"1030",
                        @"1031",
                        @"1032",
                        @"1033",
                        @"1034",
                        @"1035",
                        @"1036",
                        @"1037",
                        @"1038",
                        @"1039",
                        @"1040",
                        @"1041",
                        @"1042",
                        @"1043",
                        @"1048",
                        @"1100",
                        @"1101",
                    
                        @"1900",
                        @"1901",
                        @"1902",
                        @"2002",
                        @"2003",
                        @"2004",
                        @"2012"];
                    NSArray *objects=@[LAN(@"errorCode_suc"),
                                        LAN(@"errorCode_service_err"),
                                        LAN(@"errorCode_login_fail"),
                                        LAN(@"errorCode_unconnect"),
                                        LAN(@"errorCode_input_err"),
                                        LAN(@"errorCode_input_err"),
                                        LAN(@"errorCode_user_exists"),
                                        LAN(@"errorCode_device_unexist"),
                                        LAN(@"errorCode_device_in_ou"),
                                        LAN(@"errorCode_user_unexist"),
                                        LAN(@"errorCode_type_exist"),
                                        LAN(@"errorCode_alert_no_set"),
                                        LAN(@"errorCode_type_unexist"),
                                        LAN(@"errorCode_key_err"),
                                        LAN(@"errorCode_invaild_id"),
                                        LAN(@"errorCode_input_name"),
                                        LAN(@"errorCode_sys_err"),
                                        LAN(@"errorCode_no_sys_user"),
                                        LAN(@"errorCode_usered_no_del"),
                                        LAN(@"errorCode_no_login"),
                                        LAN(@"errorCode_prop_usered"),
                                        LAN(@"errorCode_no_auth"),
                                        LAN(@"errorCode_device_id_err"),
                                        LAN(@"errorCode_prop_id_err"),
                                        LAN(@"errorCode_prop_name_err"),
                                        LAN(@"errorCode_device_noexist"),
                                        LAN(@"errorCode_device_no_find"),
                                        LAN(@"errorCode_class_no_find"),
                                        LAN(@"errorCode_no_device_type"),
                                        LAN(@"errorCode_prop_no_find"),
                                        LAN(@"errorCode_alert_no_set"),
                                        LAN(@"errorCode_database_err"),
                                        LAN(@"errorCode_no_support"),
                                        LAN(@"errorCode_offer_id"),
                                        LAN(@"errorCode_data_format_err"),
                                        LAN(@"errorCode_device_offline"),
                                        LAN(@"errorCode_net_bad"),
                                        LAN(@"errorCode_timeout"),
                                        LAN(@"errorCode_learning_first"),
                                        LAN(@"errorCode_no_reg"),
                                        LAN(@"errorCode_task_unexist"),
                                        LAN(@"errorCode_can_not_reg"),
                                        LAN(@"errorCode_vcode_cache_null"),
                                        LAN(@"errorCode_net_slow"),
                                        LAN(@"errorCode_ews_connect_err"),
                                        LAN(@"errorCode_query_err"),
                                        LAN(@"errorCode_unsupport_interface"),
                                        LAN(@"errorCode_sys_err_redo"),
                                        LAN(@"errorCode_time_format_err"),
                                        LAN(@"errorCode_video_load_err"),
                                        LAN(@"errorCode_device_lock"),
                                        LAN(@"errorCode_pass_update_suc")];
    NSDictionary *map=[NSDictionary dictionaryWithObjects:objects forKeys:keys];
    return map;
}
-(NSArray *)sceneIcons{
    return  [NSArray arrayWithObjects:
                     @"scene_default.png",
                     @"scene_leave.png",
                     @"scene_arrive.png",
                     @"scene_gohome.png",
                     @"scene_holiday.png",
                     @"scene_awayhome.png",
                     @"scene_duty.png",
                     @"scene_offduty.png",
                     @"scene_meeting.png",
                     @"scene_demonstration.png",
                     nil];
}

+(id)allocWithZone:(struct _NSZone *)zone{
    @synchronized(self){
        if(!instance){
            instance=[super allocWithZone:zone];//确保使用同一块内存地址
            return instance;
        }
    }
    return nil;
}
-(id)copy{
    return self;
}
-(id)retain{
    return self;
}
-(NSUInteger)retainCount{
    return UINT_MAX;
}
-(id)autorelease{
    return self;
}
-(oneway void)release{
    
}
@end
