//
//  ELClassObject.h
//  ELNetworkService
//
//  Created by admin on 15/6/11.
//  Copyright (c) 2015年 LZTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ELClassObject : NSObject<NSCoding>

@property(nonatomic,assign) NSInteger  classId;
@property(nonatomic,retain) NSString  *clsName;
@property(nonatomic,retain) NSString  *displayName;
@property(nonatomic,assign) NSInteger clsType;
@property(nonatomic,assign) NSInteger appId;
@property(nonatomic,assign) NSInteger deviceMsgFormat;
@property(nonatomic,assign) NSInteger access;
@property(nonatomic,retain) NSArray   *classFields;
@property(nonatomic,retain) NSString  *icon;


@end
