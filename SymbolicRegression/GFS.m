//
//  GFS.m
//  Testovanie
//
//  Created by Michal Cisarik on 8/1/13.
//  Copyright (c) 2013 Michal Cisarik. All rights reserved.
//

#import "GFS.h"

@implementation NotEnoughTerminalsInRepairingArray
@end

@implementation UnexpectedBehavior
@end

@implementation Calculation
- (id)initWithArray:(int*)a andRepairing:(int*)b {
    self = [super init];
    if (self) {
        i=0;
        array=a;
        repairing=b;
        
        last_static=0;
        len_static=19;
        lastrepairing_static=0;
        lastbigger_static=0;
        
        last=&last_static;
        len=&len_static;
        lastrepairing=&lastrepairing_static;
        lastbigger=&lastbigger_static;
    }
    return self;
}

-(void)nullCalculation {
    last_static=0;
    len_static=19;
    lastrepairing_static=0;
    lastbigger_static=0;
}
@end

@implementation GFSelement
@synthesize name;
@end

@implementation GFSvar
-(id)initWith:(double *)n name:(NSString *)s{
    self = [super init];
    if (self) {
        variable=n;
        name=s;
    }
    return self;
}
-(double)value{
    return (*variable);
}
@end

@implementation GFS2
-(double) eval:(double)parameter1 and:(double)parameter2{
    return function(parameter1,parameter2);
}
- (id)initWith:(func2) f name:(NSString *)n{
    self = [super init];
    if (self) {
        function=f;
        name=[[NSString alloc]initWithString:n];
    }
    return self;
}
@end

@implementation GFS1
-(double) eval:(double)parameter1{
    return function(parameter1);
}
- (id)initWith:(func1) f name:(NSString *)n{
    self = [super init];
    if (self) {
        function=f;
        name=[[NSString alloc]initWithString:n];
    }
    return self;
}
@end

@implementation GFS0
-(double) eval{
    return function();
}
- (id)initWith:(func0) f name:(NSString *)n{
    self = [super init];
    if (self) {
        function=f;
        name=[[NSString alloc]initWithString:n];
    }
    return self;
}
@end

@implementation GFSrein
@synthesize gfs;
-(int*) get{
    return array;
}
-(int*) getRepairing{
    return repairing;
}
- (id)initWithArray:(int *)n andGFS:(GFS *)g repairing:(int *)rep{
    self = [super init];
    if (self) {
        gfs=g;
        array=n;
        repairing=rep;
        name=[gfs toStringRepairing:[[Calculation alloc]initWithArray:n andRepairing:rep]];
    }
    return self;
}
@end

@implementation GFS {
    __block double _x;//variable is used in dynamically created block
    __block double _y;
}
@synthesize elements,showXnoValue,terminalsStartingIndex;

/*! Instantiate GFS with elements of pointers to functions wrapped in custom GFSelement subclasses according to number of parameters used
 \return self
*/
- (id)initFunctionSet{
    self = [super init];
    if (self) {

        //create functions for GFSelement subclasses:
        func2 _add=^(double a, double b) { return a + b; };
        func2 _sub=^(double a, double b) { return a - b; };
        func2 _mul=^(double a, double b) { return a * b; };
        func2 _div=^(double a, double b) { return a / b; };
        func1 _sin=^(double par) { return sin(par); };
        func1 _cos=^(double par) { return cos(par); };
        func1 _tan=^(double par) { return tan(par); };
        func1 _log=^(double par) { return log(par); };
        func0 _2=^() { return (double) 2; };
        func0 _3=^() { return (double) 3; };
        
        // initial values for variables which may be used in calculations:
        _x=1;
        _y=1;
        
        // init all elements of GFS with GFSelement objects:
        elements=[NSMutableArray arrayWithObjects:
                  [[GFS2 alloc]initWith:_add name:@"+"],
                  [[GFS2 alloc]initWith:_sub name:@"-"],
                  [[GFS2 alloc]initWith:_mul name:@"*"],
                  [[GFS2 alloc]initWith:_div name:@"/"],
                  [[GFS1 alloc]initWith:_log name:@"log"],
                  [[GFS1 alloc]initWith:_sin name:@"sin"],
                  [[GFS1 alloc]initWith:_cos name:@"cos"],
                  [[GFS1 alloc]initWith:_tan name:@"tan"],
                  [[GFSvar alloc] initWith:&_x name:@"x"],
                  [[GFS0 alloc]initWith:_2 name:@"2"],
                  [[GFS0 alloc]initWith:_3 name:@"3"],
                  nil];
        
        terminalsStartingIndex=8;
    }
    
    srand((unsigned int)time(NULL));
    return self;
}

-(void)setValueOf:(NSString*)var value:(double)val{
    if ([var isEqual:@"x"])
        _x=val;
    if ([var isEqual:@"y"])
        _y=val;
}

-(NSString *)toStringRepairing:(Calculation *)c {
    return [self toStringRepairingRecursive:(c->array)
                                  at:(c->i)
                                last:(c->last)
                                 max:(c->len)
                           repairing:(c->repairing)
                       lastrepairing:(c->lastrepairing)
                          lastbigger:(c->lastbigger)];
}

-(NSString *)toStringRepairingRecursive:(int*)array at:(int) i last:(int*)last max:(int*)len repairing:(int *)repairing lastrepairing:(int*)lastrepairing lastbigger:(int*)lastbigger{
    
    int j=*last;
    GFSelement *f;
    
    //all repairs used (time to terminate by "x":
    if (*lastbigger==(*len)*2)
        f=[elements objectAtIndex:8];
    else if (i>*len){
//        if (repairing[*lastbigger]==11)
//            f=[elements objectAtIndex:8];
//        else
            f=[elements objectAtIndex:repairing[*lastbigger]];
        *lastbigger+=1;
    } else
        f=[elements objectAtIndex:array[i]];
    
    if ([f conformsToProtocol: @protocol( GFS2args )]){
        *last+=2;
        return [NSString stringWithFormat:@"(%@%@%@)",
                [self toStringRepairingRecursive:array at:j+1 last:last max:len repairing:repairing lastrepairing:lastrepairing lastbigger:lastbigger],
                [((GFS2*)f) name],
                [self toStringRepairingRecursive:array at:j+2 last:last max:len repairing:repairing lastrepairing:lastrepairing lastbigger:lastbigger]];
    }
    if ([f conformsToProtocol: @protocol( GFS1args )]){
        *last+=1;
        return [NSString stringWithFormat:@"%@(%@)",
                [((GFS1*)f) name],
                [self toStringRepairingRecursive:array at:j+1 last:last max:len repairing:repairing lastrepairing:lastrepairing lastbigger:lastbigger]];
    }
    if ([f conformsToProtocol: @protocol( GFS0args )]){
        return [NSString stringWithFormat:@"%@",[((GFS0*)f) name]];
    }
    if ([f conformsToProtocol: @protocol( GFSreinforced )]){
        return [((GFSrein*)f) name];
    }
    if ([f conformsToProtocol: @protocol( GFSvariable )]){
        if (showXnoValue)
            return [f name];
        if ([[f name] isEqual:@"x"])
            return[NSString stringWithFormat:@"%g",_x];
        else if ([[f name] isEqual:@"y"])
            return[NSString stringWithFormat:@"%g",_y];
    }
    return @"_";
}

-(double)evaluateRepairing:(Calculation *)c {
    return [self evaluateRepairingRecursive:(c->array)
                                         at:(c->i)
                                       last:(c->last)
                                        max:(c->len)
                                  repairing:(c->repairing)
                              lastrepairing:(c->lastrepairing)
                                 lastbigger:(c->lastbigger)];
}

-(double)evaluateRepairingRecursive:(int*)array at:(int) i last:(int*)last max:(int*)len repairing:(int *)repairing lastrepairing:(int*)lastrepairing lastbigger:(int*)lastbigger {
    
    int j=*last;
    GFSelement *f;
    
    //all repairs used (time to terminate by "x":
    if (*lastbigger==(*len)*2)
        f=[elements objectAtIndex:8];
    else if (i>*len){
        f=[elements objectAtIndex:repairing[(*lastbigger)]];
        *lastbigger+=1;
    } else
        f=[elements objectAtIndex:array[i]];
    
    if ([f conformsToProtocol: @protocol( GFS2args )]){
        *last+=2;
        double a=[self evaluateRepairingRecursive:array at:j+1 last:last max:len repairing:repairing lastrepairing:lastrepairing lastbigger:lastbigger];
        double b=[self evaluateRepairingRecursive:array at:j+2 last:last max:len repairing:repairing lastrepairing:lastrepairing lastbigger:lastbigger];
        if ([[f name] isEqual:@"/"] && b==0){
            f=[elements objectAtIndex:repairing[*lastrepairing]];
            *lastrepairing+=1;
        } else
            return [((GFS2 *)f) eval: a and: b];
    }
    if ([f conformsToProtocol: @protocol( GFS1args )]){
        int j=*last;
        *last+=1;
        
        double b=[self evaluateRepairingRecursive:array at:j+1 last:last max:len repairing:repairing lastrepairing:lastrepairing lastbigger:lastbigger];
        if ([[f name] isEqual:@"log"] && b==0){
            f=[elements objectAtIndex:repairing[*lastrepairing]];
            *lastrepairing+=1;
        } else
            return [((GFS1 *)f) eval:b];
    }
    if ([f conformsToProtocol: @protocol( GFS0args )]){
        return [((GFS0 *)f) eval];
    }
    if ([f conformsToProtocol: @protocol( GFSreinforced )]){
        int a=0;
        int b=0;
        return [self evaluateRepairingRecursive:[((GFSrein*)f) get] at:a last:&b max:len repairing:[((GFSrein*)f) getRepairing] lastrepairing:lastrepairing lastbigger:lastbigger];
    }
    if ([f conformsToProtocol: @protocol( GFSvariable )]){
        if ([[f name] isEqual:@"x"])
            return _x;
        if ([[f name] isEqual:@"y"])
            return _y;
    }
    return (double)1;
}

-(NSString*)description{
    NSMutableString *out=[[NSMutableString alloc]init];
    [out appendString:@"GFS={"];
    for (id element in elements){
        [out appendString:[NSString stringWithFormat:@"%@, ",[element name]]];
    }
    [out appendString:@"}"];
    return out;
}

@end

