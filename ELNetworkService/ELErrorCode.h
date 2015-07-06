//
//  ELErrorCode.h
//  objectc_ehome
//
//  Created by admin on 14-10-14.
//  Copyright (c) 2014年 cn.lztech  合肥联正电子科技有限公司. All rights reserved.
//

#ifndef objectc_ehome_ELErrorCode_h
#define objectc_ehome_ELErrorCode_h
typedef NS_ENUM(NSInteger,ErrorCode){
    ErrorCode_ACCEPT=0,// 成功
    ErrorCode_REJECT,//(1, "服务器错误，请稍后再试！"),
    ErrorCode_LOGIN_FAILED,//(2, "登录失败，请再试！"),
    ErrorCode_CONN_TO_WS_ERR,//(3, "不能连接到服务器，请检查手机通信状态，稍后再试！"),
    
    ErrorCode_INVALID_LOGIN_NAME_PWD=1001,//(1001, "用户名或密码输入错误。"),
    ErrorCode_LOGIN_NAME_NOT_EXIST,//(1002, "用户名或密码输入错误。"),
    ErrorCode_DUP_NAME=1008,//(1008, "用户名已经被使用。"),
    ErrorCode_DEVICE_DOES_NOT_EXISTS,//(1009, "设备不存在。"),
    ErrorCode_DEVICE_BELONG_TO_OTHER,//(1010, "设备已经属于别的账户。"),
    ErrorCode_USER_DOES_NOT_EXIST,//(1011, "用户不存在。"),
    ErrorCode_DEVICE_TYPE_IN_USE,//(1012, "The device type is used by attribute definition. It could not been deleted"),
    ErrorCode_ALERT_NOT_EXISTS,//(1013, "预警还没有设置。请先设置预警。"),
    
    ErrorCode_DEVICE_TYPE_NOT_EXISTS,//(1014, "设备类型不存在。"),
    ErrorCode_FK_VIOLATION,//(1015, "数据库外键错误。 "),
    ErrorCode_INVALID_USER_ID,//(1016, "无效用户ID。"),
    ErrorCode_NAME_IS_REQUIRED,//(1017, "请输入名称。"),
    ErrorCode_INTERNAL_DB_ERR,//(1018, "系统错误。"),
    ErrorCode_INVALID_SYS_USER,//(1019, "用户不是系统用户。"),
    ErrorCode_CAN_NOT_DEL,//(1020, "名称被使用，不能删除。"),
    ErrorCode_SERVICE_CLIENT_LOGOFF,//(1021, "The client for the services is not logged in."),
    ErrorCode_EMPTY_DATA,//(1022, "设备属性已经被使用。"),
    ErrorCode_PERMISSION_DENY,//(1023, "没有权限"),
    ErrorCode_INVALID_OBJECT_ID,//(1024, "设备ID错误。"),
    ErrorCode_INVALID_FIELD_ID,//(1025, "字段ID错误。"),
    ErrorCode_INVALID_FIELD_NAME,//(1026, "字段名称错误。"),
    ErrorCode_OBJECT_NOT_EXIST,//(1027, "设备不存在 。"),
    ErrorCode_OBJECT_NOT_FOUND,//(1028, "设备未找到。"),
    ErrorCode_CLASS_NOT_FOUND,//(1029, "类未找到。"),
    ErrorCode_OBJECT_NOT_ADEVICE,//(1030, "此对象不是设备类型。"),
    ErrorCode_FIELD_NOT_FOUND,//(1031, "字段未找到。"),
    ErrorCode_ALERT_NOT_FOUND,//(1032, "预警还未设置。请先设置预警。"),
    ErrorCode_INVALID_HIST_SRC_DATA,//(1033, "数据库错误。请稍后再试！ "),
    ErrorCode_CONVERSION_IS_NOT_SUPPORTED,//(1034, "不支持此变换。 "),
    ErrorCode_OBJID_OR_ALERTID_REQ,//(1035, "请提供设备ID"),
    ErrorCode_INVALID_DATA_FMT,//(1036, "数据格式错误。 "),
    ErrorCode_DEVICE_NOT_CONNECTED,//(1037, "设备不在线。"),
    ErrorCode_DEVICE_REJECT,//(1038, "网络拥堵，请稍后重试！"),
    ErrorCode_INVALID_SEC_TOKEN,//(1039, "超时。请重新登录！"),
    ErrorCode_AC_TYPE_UNKNOWN,//(1040, "请首先进行对码学习。"),
    ErrorCode_DEVICE_NOT_REG,//(1041, "The device is not registered in core server"),
    ErrorCode_TASK_NOT_EXIST,//(1042, "The scheduled task 不存在，请设置!"),//The scheduled task does not exist
    ErrorCode_OBJECT_ALREADY_EXIST,//(1043, "设备已经注册，不能再注册。"),
    ErrorCode_CODE_CACHE_NULL=1048,//(1048, "Verification code cache is null"),
    ErrorCode_REQ_TIME_OUT=1100,//(1100, "网络慢。请稍后再试！"),
    ErrorCode_INTERNAL_CONN_ERROR,//(1101, "e联WS接口服务器连接错误"),

    ErrorCode_DB_QUERY_ERROR=1900,//(1900, "数据库查询错误"),
    ErrorCode_INTERFACE_NOT_SUPPORTED,//(1901, "不支持此接口"),
    ErrorCode_INTERNAL_ERROR,//(1902, "系统错误。请重新登录再试！"),
    ErrorCode_DATAFORMAT_ERROR=2002,//(2002,"时间数据格式化错误，请输入正确的时间格式"),
    ErrorCode_VEDIO_LOAD_FAIL,//(2003,"视频加载错误"),
    ErrorCode_DEVICE_LOCKED,//(2004,"设备已锁定，请按设备解锁");
    
    ErrorCode_RELOGIN=2012,//(2012,"密码修改成功，请重新登录！"),
    

};

#endif
