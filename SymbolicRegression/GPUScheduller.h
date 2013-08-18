//
//  GPUScheduller.h
//  SymbolicRegression
//
//  Created by Michal Cisarik on 8/17/13.
//  Copyright (c) 2013 Michal Cisarik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPU.h"
#import "SOMA.h"

@interface GPUScheduller : NSObject {
    SOMA *soma;
    GPU *gpu;
}

@end
