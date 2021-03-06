//
//  ELClass.h
//  objectc_ehome
//
//  Created by admin on 14-9-25.
//  Copyright (c) 2014年 cn.lztech  合肥联正电子科技有限公司. All rights reserved.
//

#ifndef objectc_ehome_ELClass_h
#define objectc_ehome_ELClass_h

typedef NS_ENUM(NSInteger, ELDEVICECLASSTYPE) {
    ELDEVICECLASSTYPE_GATEWAY=1,
    ELDEVICECLASSTYPE_AC,
    ELDEVICECLASSTYPE_DOORSENSOR,
    ELDEVICECLASSTYPE_POWERMET,
    ELDEVICECLASSTYPE_PTMOTIONDET,
    ELDEVICECLASSTYPE_SCHEDULE,
    ELDEVICECLASSTYPE_ELMOTIONDET,
    ELDEVICECLASSTYPE_SMOKEDETECTOR,
    ELDEVICECLASSTYPE_BPMONITOR,
    ELDEVICECLASSTYPE_IPCAMERA,
    ELDEVICECLASSTYPE_POWERCTRL,
    ELDEVICECLASSTYPE_ACBRAND,
    ELDEVICECLASSTYPE_CODETECTOR,
    ELDEVICECLASSTYPE_POWERSTRIPS,
    ELDEVICECLASSTYPE_CURTAIN,
    ELDEVICECLASSTYPE_PROJECTORSCREEN,
    ELDEVICECLASSTYPE_EMERGENCYBUTTON,
    ELDEVICECLASSTYPE_GASDETECTOR,
    ELDEVICECLASSTYPE_WALLPOWERCTRL,
    ELDEVICECLASSTYPE_WALLSWITCH,
    ELDEVICECLASSTYPE_WATERDETECTOR,
    ELDEVICECLASSTYPE_TEMPHUMISENSOR,
    ELDEVICECLASSTYPE_VALVE,
    ELDEVICECLASSTYPE_SCENARIOSWITCH,
    ELDEVICECLASSTYPE_THERMOSTAT,
    ELDEVICECLASSTYPE_FIREDETECTOR,//26
    ELDEVICECLASSTYPE_BPMONITORSUPER,
    ELDEVICECLASSTYPE_ACFAN,//28
    ELDEVICECLASSTYPE_POWERALARM,
    ELDEVICECLASSTYPE_REPEATER,//IR
    ELDEVICECLASSTYPE_TV_BRAND,//31
    ELDEVICECLASSTYPE_AUDIO_BRAND,//32
    ELDEVICECLASSTYPE_TEMPHUMISENSOR2,//33
    ELDEVICECLASSTYPE_DOORLOCK,//34智能门锁
    ELDEVICECLASSTYPE_BLRepeater,//35集成博联红外转发器
    ELDEVICECLASSTYPE_DEVBOARD=100
    
};

#endif
