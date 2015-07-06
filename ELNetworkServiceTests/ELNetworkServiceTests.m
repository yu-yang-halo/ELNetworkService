//
//  ELNetworkServiceTests.m
//  ELNetworkServiceTests
//
//  Created by apple on 15/5/1.
//  Copyright (c) 2015年 LZTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "ElApiService.h"
@interface ELNetworkServiceTests : XCTestCase

@end

@implementation ELNetworkServiceTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
   XCTAssert(YES, @"Pass");
    
   ELClassObject *clsobj=[[ElApiService shareElApiService] getClassById:20];
    XCTAssertNil(clsobj);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
