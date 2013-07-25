//
//  GSNetworkMockDataJSONParameter.m
//  GSTest
//
//  Created by Guilherme Sampaio on 7/21/13.
//  Copyright (c) 2013 Guilherme Sampaio. All rights reserved.
//

#import "GSNetworkMockDataJSONParameter.h"

@implementation GSNetworkMockDataJSONParameter

+ (instancetype)mockDataParameterWithParameter:(id)parameter
{
    BOOL isValidParameterClass = [parameter isKindOfClass:[NSArray class]] || [parameter isKindOfClass:[NSDictionary class]];
    NSAssert(isValidParameterClass, @"The enconding type for string parameter should be a NSArray or a NSDicitionary");
    
    GSNetworkMockDataJSONParameter *jsonParameter = [[GSNetworkMockDataJSONParameter alloc] init];
    jsonParameter.parameter = [parameter copy];
    return jsonParameter;
}

- (NSData *)dataForParameter
{
    return [NSJSONSerialization dataWithJSONObject:self.parameter options:NSJSONWritingPrettyPrinted error:nil];
}
@end
