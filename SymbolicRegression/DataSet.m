//
//  DataSet.m
//  SymbolicRegression
//
//  Created by Michal Cisarik on 8/18/13.
//  Copyright (c) 2013 Michal Cisarik. All rights reserved.
//

#import "DataSet.h"

@implementation DataSet
@synthesize inputvalues;
- (id)init {
    self = [super init];
    if (self) {
        inputvalues=[[NSMutableDictionary alloc]init];
        for (double x=0.0;x<10;x+=0.05)
            [inputvalues setObject:[NSNumber numberWithDouble:(sin(tan(x))+cos(3))]
                            forKey:[NSString stringWithFormat:@"%g",x]];
    }
    return self;
}
@end
