//
//  GFS.h
//  Testovanie
//
//  Created by Michal Cisarik on 8/1/13.
//  Copyright (c) 2013 Michal Cisarik. All rights reserved.
//

@interface NotEnoughTerminalsInRepairingArray : NSException
@end

@interface UnexpectedBehavior : NSException
@end

#import <Foundation/Foundation.h>
//#import "GPUScheduller.h"

typedef double (^func2)(double,double);
typedef double (^func1)(double);
typedef double (^func0)(void);

@protocol GFS2args <NSObject>
-(double) eval:(double)parameter1 and:(double)parameter2;
@end

@protocol GFS1args <NSObject>
-(double) eval:(double)a;
@end

@protocol GFS0args <NSObject>
-(double) eval;
@end

@protocol GFSvariable <NSObject>
@end

@protocol GFSreinforced <NSObject>
@end

@interface Calculation : NSObject{
@public
    int* array;
    int i;
    int* last;
    int* len;
    int* repairing;
    int* lastrepairing;
    int* lastbigger;
    
    int last_static;
    int len_static;
    int lastrepairing_static;
    int lastbigger_static;
}
-(id)initWithArray:(int*)a andRepairing:(int*)b;
-(void)nullCalculation;
@end



@interface GFSelement : NSObject {
    NSString *name;
}
@property NSString *name;
@end

@interface GFSvar : GFSelement <GFSvariable>{
    double* variable;
}
-(id)initWith:(double *)n name:(NSString *)s;
-(double)value;
@end

@interface GFS1 : GFSelement <GFS1args>{
    func1 function;
}
-(double) eval:(double)parameter1;
@end

@interface GFS2 : GFSelement <GFS2args>{
    func2 function;
}
-(double) eval:(double)parameter1 and:(double)parameter2;
@end

@interface GFS0 : GFSelement <GFS0args>{
    func0 function;
}
-(double) eval;
@end



@interface GFS : NSObject
@property BOOL showXnoValue;
@property int terminalsStartingIndex;
@property NSMutableArray *elements;

- (id)initFunctionSet;

-(NSString *)toStringRepairing:(Calculation *)c;

-(NSString *)toStringRepairingRecursive:(int*)array at:(int) i last:(int*)last max:
(int*)len repairing:(int *)repairing lastrepairing:(int*)lastrepairing lastbigger:(int*)lastbigger;

-(double)evaluateRepairing:(Calculation *)c;

-(double)evaluateRepairingRecursive:(int*)array at:(int) i last:(int*)last max:(int*)len repairing:(int *)repairing lastrepairing:(int*)lastrepairing lastbigger:(int*)lastbigger;

-(NSString *)description;

-(void)setValueOf:(NSString*)var value:(double)val;
@end




@interface GFSrein : GFSelement <GFSreinforced>{
    int* array;
    int* repairing;
}
@property GFS *gfs;
-(int*) get;
-(int*) getRepairing;
-(id)initWithArray:(int *)n andGFS:(GFS *)gfs repairing:(int*)rep;
@end


