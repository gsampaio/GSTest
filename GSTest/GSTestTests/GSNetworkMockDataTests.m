//
//  GSNetworkMockDataTests.m
//  GSTest
//
//  Created by Guilherme Sampaio on 7/25/13.
//  Copyright (c) 2013 Guilherme Sampaio. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GSNetworkMockData.h"

@interface GSNetworkMockDataTests : XCTestCase

@end

@implementation GSNetworkMockDataTests

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testStatus200MockDataReturnAnObject
{
    GSNetworkMockData *mockData = [GSNetworkMockData status200MockData];
    XCTAssertNotNil(mockData, @"status200MockData should not return  nil object");
}

- (void)testStatus200MockDataReturnAnObjectWithStatus200
{
    GSNetworkMockData *mockData = [GSNetworkMockData status200MockData];
    XCTAssertEquals(mockData.status, (NSUInteger) 200, @"status200MockData should return an object with status 200");
}

- (void)testStatus500MockDataReturnAnObject
{
    GSNetworkMockData *mockData = [GSNetworkMockData status500MockData];
    XCTAssertNotNil(mockData, @"status500MockData should not return  nil object");
}

- (void)testStatus500MockDataReturnAnObjectWithStatus500
{
    GSNetworkMockData *mockData = [GSNetworkMockData status500MockData];
    XCTAssertEquals(mockData.status, (NSUInteger) 500, @"status500MockData should return an object with status 500");
}

@end
