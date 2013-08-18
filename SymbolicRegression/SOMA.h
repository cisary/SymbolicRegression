//
//  SOMA.h
//  SymbolicRegression
//
//  Created by Michal Cisarik on 8/17/13.
//  Copyright (c) 2013 Michal Cisarik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SOMA : NSObject {
    double **pop;
}
-(float*)getFloatsForGPU;
@end
