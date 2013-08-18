//
//  main.m
//  SymbolicRegression
//
//  Created by Michal Cisarik on 8/14/13.
//  Copyright (c) 2013 Michal Cisarik. All rights reserved.
//

@import Cocoa;
#import "GA.h"
#import "GPU.h"

// constants:
static const NSInteger NUM_THREADS = 4;

int main(int argc, const char * argv[]) {
    //GPU *opencl = [[GPU alloc]init];
    //int in[3]={2,2,2};
    //float *a=[opencl calculate:in a:NULL b:NULL len:3];
    
    @autoreleasepool {
        GA *a = [GA newGAWithGenes:20
                           popSize:20
                       generations:1
                           mutProb:0.033
                         crossProb:0.6
                               gfs:[[GFS alloc]initFunctionSet]];
        [a generate];
        [a free];
    }
    return NSApplicationMain(argc, argv);
}
