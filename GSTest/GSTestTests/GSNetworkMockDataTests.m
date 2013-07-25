//
//  GSNetworkMockDataTests.m
//  GSTest
//
//  Copyright (c) 2013 Guilherme Sampaio. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation
//  the rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
//  DEALINGS IN THE SOFTWARE.

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
