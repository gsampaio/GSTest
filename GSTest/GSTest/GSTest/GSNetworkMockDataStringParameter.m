//
//  GSNetworkMockDataStringParameter.m
//  GSTest
//
//  Created by Guilherme Sampaio on 7/21/13.
//  Copyright (c) 2013 Guilherme Sampaio. All rights reserved.
//

#import "GSNetworkMockDataStringParameter.h"

@implementation GSNetworkMockDataStringParameter

+ (instancetype)mockDataParameterWithParameter:(id)parameter
{
    NSAssert([parameter isKindOfClass:[NSString class]], @"The enconding type for string parameter should be an NSString");
    GSNetworkMockDataStringParameter *stringParameter = [[GSNetworkMockDataStringParameter alloc] init];
    stringParameter.parameter = [parameter copy];
    return stringParameter;
}

- (NSData *)dataForParameter
{
    NSData *data = [self.parameter dataUsingEncoding:NSUTF8StringEncoding];
    return data;
}
@end
