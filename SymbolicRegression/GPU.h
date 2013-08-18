//
//  GPU.h
//  SymbolicRegression
//
//  Created by Michal Cisarik on 8/16/13.
//  Copyright (c) 2013 Michal Cisarik. All rights reserved.
//
#import <Foundation/Foundation.h>
#include <OpenCL/opencl.h>
#include <stdio.h>
#include <stdlib.h>
#include <float.h>
#include "gpucalculate_kernel.cl.h"

#define NUM_VALUES 1024

@interface GPU : NSObject {
    char name[128];
    dispatch_queue_t queue;
    cl_device_id gpu;
    float* in;
    float* out;
    void* mem_in;
    void* mem_out;
}
-(id)init;
-(float*) calculate:(int*)o a:(double*)a b:(double*)b len:(int)len;
-(void)free;
@end
