//
//  GPUScheduller.m
//  SymbolicRegression
//
//  Created by Michal Cisarik on 8/17/13.
//  Copyright (c) 2013 Michal Cisarik. All rights reserved.
//

#import "GPUScheduller.h"

@implementation GPUScheduller
- (id)init
{
    self = [super init];
    if (self) {
        gpu = [[GPU alloc]init];
        soma = [[SOMA alloc]init];
    }
    return self;
}
@end
