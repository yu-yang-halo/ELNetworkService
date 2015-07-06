//
//  ELClassField.h
//  ELNetworkService
//
//  Created by admin on 15/6/11.
//  Copyright (c) 2015年 LZTech. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger,HYLWidgetStyle){
    HYLWidgetStyle_Control=1,
    HYLWidgetStyle_ControlAndShow,
    HYLWidgetStyle_InputValue,
    HYLWidgetStyle_OutputValue,
    HYLWidgetStyle_Percentage,
};

@interface ELClassField : NSObject<NSCoding>

@property(nonatomic,assign) NSInteger  fieldId;
@property(nonatomic,retain) NSString  *fieldName;
@property(nonatomic,retain) NSString  *displayName;
@property(nonatomic,assign) NSInteger  dataType;
@property(nonatomic,assign) BOOL       deviceStateYN;
@property(nonatomic,assign) BOOL       deviceCmdYN;
@property(nonatomic,assign) BOOL       tsYN;//历史数据
@property(nonatomic,assign) BOOL       presistYN;
@property(nonatomic,retain) NSString  *defaultValue;
@property(nonatomic,assign) NSInteger  aggrMethod;

@property(nonatomic,retain) NSString*  icon;
@property(nonatomic,assign) NSInteger  widget;

@end
