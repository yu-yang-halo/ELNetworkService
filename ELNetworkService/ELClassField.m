//
//  ELClassField.m
//  ELNetworkService
//
//  Created by admin on 15/6/11.
//  Copyright (c) 2015年 LZTech. All rights reserved.
//

#import "ELClassField.h"

@implementation ELClassField

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeInt:self.fieldId forKey:@"fieldId"];
    [aCoder encodeObject:self.fieldName forKey:@"fieldName"];
    [aCoder encodeObject:self.displayName forKey:@"displayName"];
    [aCoder encodeInt:self.dataType forKey:@"dataType"];
    [aCoder encodeBool:self.deviceStateYN forKey:@"deviceStateYN"];
    [aCoder encodeBool:self.deviceCmdYN forKey:@"deviceCmdYN"];
    [aCoder encodeBool:self.tsYN forKey:@"tsYN"];
    [aCoder encodeBool:self.presistYN forKey:@"presistYN"];
    [aCoder encodeObject:self.defaultValue forKey:@"defaultValue"];
    [aCoder encodeInt:self.aggrMethod forKey:@"aggrMethod"];
    
    [aCoder encodeObject:self.icon forKey:@"icon"];
    [aCoder encodeInt:self.widget forKey:@"widget"];
    
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    if(self=[super init]){
        self.fieldId=[aDecoder decodeIntForKey:@"fieldId"];
        self.fieldName=[aDecoder decodeObjectForKey:@"fieldName"];
        self.displayName=[aDecoder decodeObjectForKey:@"displayName"];
        self.dataType=[aDecoder decodeIntForKey:@"dataType"];
        self.deviceStateYN=[aDecoder decodeBoolForKey:@"deviceStateYN"];
        self.deviceCmdYN=[aDecoder decodeBoolForKey:@"deviceCmdYN"];
        self.tsYN=[aDecoder decodeBoolForKey:@"tsYN"];
        self.presistYN=[aDecoder decodeBoolForKey:@"presistYN"];
        self.defaultValue=[aDecoder decodeObjectForKey:@"defaultValue"];
        self.aggrMethod=[aDecoder decodeIntForKey:@"aggrMethod"];
        
        self.icon=[aDecoder decodeObjectForKey:@"icon"];
        self.widget=[aDecoder decodeIntForKey:@"widget"];
    }
    return self;
}


@end
