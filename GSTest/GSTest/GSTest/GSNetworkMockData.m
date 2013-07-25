//
//  GSNetworkMockData.m
//  GSTest
//
//  Created by Guilherme Sampaio on 7/21/13.
//  Copyright (c) 2013 Guilherme Sampaio. All rights reserved.
//

#import "GSNetworkMockData.h"

@implementation GSNetworkMockData
+ (instancetype) status200MockData
{
    GSNetworkMockData *mockData = [[GSNetworkMockData alloc] init];
    mockData.status = 200;
    mockData.error = nil;
    mockData.parameter = nil;
    return mockData;
}
+ (instancetype) status500MockData
{
    GSNetworkMockData *mockData = [[GSNetworkMockData alloc] init];
    mockData.status = 500;
    mockData.error = nil;
    mockData.parameter = nil;
    return mockData;
}
@end
