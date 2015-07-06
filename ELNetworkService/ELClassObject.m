//
//  ELClassObject.m
//  ELNetworkService
//
//  Created by admin on 15/6/11.
//  Copyright (c) 2015年 LZTech. All rights reserved.
//

#import "ELClassObject.h"

@implementation ELClassObject
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeInt:self.classId forKey:@"classId"];
    [aCoder encodeObject:self.clsName forKey:@"clsName"];
    [aCoder encodeObject:self.displayName forKey:@"displayName"];
    [aCoder encodeInt:self.clsType forKey:@"clsType"];
    [aCoder encodeInt:self.appId forKey:@"appId"];
    [aCoder encodeInt:self.deviceMsgFormat forKey:@"deviceMsgFormat"];
    [aCoder encodeInt:self.access forKey:@"access"];
    [aCoder encodeObject:self.classFields forKey:@"classFields"];
    [aCoder encodeObject:self.icon forKey:@"icon"];
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    if(self=[super init]){
        self.classId=[aDecoder decodeIntForKey:@"classId"];
        self.clsName=[aDecoder decodeObjectForKey:@"clsName"];
        self.displayName=[aDecoder decodeObjectForKey:@"displayName"];
        self.clsType=[aDecoder decodeIntForKey:@"clsType"];
        self.appId=[aDecoder decodeIntForKey:@"appId"];
        self.deviceMsgFormat=[aDecoder decodeIntForKey:@"deviceMsgFormat"];
        self.access=[aDecoder decodeIntForKey:@"access"];
        self.icon=[aDecoder decodeObjectForKey:@"icon"];
        self.classFields=[aDecoder decodeObjectForKey:@"classFields"];
        
    }
    return self;
}
@end
