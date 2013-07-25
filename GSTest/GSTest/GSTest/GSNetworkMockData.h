//
//  GSNetworkMockData.h
//  GSTest
//
//  Created by Guilherme Sampaio on 7/21/13.
//  Copyright (c) 2013 Guilherme Sampaio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GSNetworkMockDataParameter.h"

@interface GSNetworkMockData : NSObject
@property (nonatomic, strong) GSNetworkMockDataParameter *parameter;
@property (nonatomic, strong) NSArray *headers;
@property (nonatomic, strong) NSError *error;
@property (nonatomic) NSUInteger status;
+ (instancetype) status200MockData;
+ (instancetype) status500MockData;
@end
