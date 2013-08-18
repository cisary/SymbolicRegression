//
//  GPUTests.m
//  GPUTests
//
//  Created by Michal Cisarik on 8/16/13.
//  Copyright (c) 2013 Michal Cisarik. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "GPUScheduller.h"

@interface GPUTests : SenTestCase {
    GPUScheduller *scheduller;
}

@end

@implementation GPUTests
- (void)setUp {
    [super setUp];
    scheduller = [[GPUScheduller alloc]init];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testCalculate
{
    //int i[3]={2,2,2};
    //[opencl copy:i a:NULL b:NULL len:NULL];
    
    //STFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

@end
