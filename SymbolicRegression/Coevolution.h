//
//  Coevolution.h
//  MDME
//
//  Created by Michal Cisarik on 11/12/13.
//  Copyright (c) 2013 Michal Cisarik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MersenneTwister.h"
#import "DE.h"
#import "GFS.h"

@interface Coevolution : NSObject
-(id)initAndSeed:(unsigned int) seed;
-(unsigned long) migratingTo64bits:(uint64)index;
-(id)bestEvolution;
-(void)coevolveOptimized;
-(void)coevolve;
-(void)analyze;
-(void)free;
@end
