//
//  GFSFunctions.m
//  SymbolicRegression
//
//  Created by Michal Cisarik on 8/17/13.
//  Copyright (c) 2013 Michal Cisarik. All rights reserved.
//

#import "GFSFunctions.h"

@implementation GFSFunctions
- (id)init
{
    self = [super init];
    if (self) {
        gfs = [[GFS alloc]initFunctionSet];
        semaphores=[[NSMutableArray alloc]init];
        for (int i=0;i<50;i++) {
            dispatch_semaphore_t sem = dispatch_semaphore_create(0);
            [semaphores addObject:sem];
        }
    }
    return self;
}
@end
