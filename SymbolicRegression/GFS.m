//
//  GFS.m
//  Testovanie
//
//  Created by Michal Cisarik on 8/1/13.
//  Copyright (c) 2013 Michal Cisarik. All rights reserved.
//

#import "GFS.h"

// ================== // ERRORS AND EXCEPTIONS // ================== //
@implementation NotEnoughTerminalsInRepairingArray
@end

@implementation UnexpectedBehavior
@end

// =================== // IMPLEMENTATIONS // ======================= //
@implementation Configuration

+(NSDictionary*) all
{
    static NSDictionary* dict = nil;
    
    if (dict == nil) {
        dict = @{
                 
        @"3D" : @NO,

        @"function2D"  : @"x^6-2x^4+x^2",
        @"function3D"  : @"(x^2)/y",

        @"arithmeticFunctions" : @YES,
        @"logarithmicFunctions" : @YES,
        @"goniometricFunctions" : @YES,
        @"polynomialFunctions" : @YES,

        @"linearConstants" : @YES,
        @"exponentialFunctions" : @YES,
        @"mathConstants" :@YES,

        @"reinforcedEvolution" : @YES,

        @"MDME_vectors" : @32,
        @"MDME_generations" : @5,
        @"MDME_scalingFactor" : @0.9,
        @"MDME_crossProb" : @0.9,
        @"MDME_mutProb" : @0.3,
        @"MDME_migProb" : @0.6,
        @"MDME_migrations" : @20,

        @"DE_vectors" : @32,
        @"DE_generations" : @5,
        @"DE_scalingFactor" : @0.9,
        @"DE_crossProb" : @0.9,
        @"DE_mutProb" : @0.3,
        @"DE_migProb" : @0.6,
        @"DE_migrations" : @20,

        @"forcebit1": @YES, //add
        @"forcebit2": @YES, //sub
        @"forcebit3": @YES, //mul
        @"forcebit4": @YES, //div
        @"forcebit5": [NSNull null], //sin
        @"forcebit6": [NSNull null], //cos
        @"forcebit7": [NSNull null], //tan
        @"forcebit8": [NSNull null], //log
        @"forcebit9": [NSNull null], //log2
        @"forcebit10": [NSNull null], //log10
        @"forcebit11": [NSNull null], //^2
        @"forcebit12": [NSNull null], //^3
        @"forcebit13": [NSNull null], //^4
        @"forcebit14": [NSNull null], //^5
        @"forcebit15": [NSNull null], //^6
        @"forcebit16": [NSNull null], //1
        @"forcebit17": [NSNull null], //2
        @"forcebit18": [NSNull null], //3
        @"forcebit19": [NSNull null], //4
        @"forcebit20": [NSNull null], //5
        @"forcebit21": [NSNull null], //6
        @"forcebit22": [NSNull null], //7
        @"forcebit23": [NSNull null], //8
        @"forcebit24": [NSNull null], //9
        @"forcebit25": @NO, //
        @"forcebit26": @NO, //
        @"forcebit27": @NO, //
        @"forcebit28": @NO, //
        @"forcebit29": @NO, //
        @"forcebit30": @NO, //
        @"forcebit31": @NO, //
        @"forcebit32": @NO, // FORCE x and y variables?
        };
    }
    
    return dict;
}

@end


@implementation IN

+(NSMutableArray*) ekvidistantDoublesCount:(int)count min:(double)m max:(double)mx {
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:count];
    
    double dx=m;
    double rx=mx/(double)count;
    double qx=0.0;
    for (int i=0; i<count; i++) {
        if (qx+rx-dx>-0.005 &&qx+rx-dx<0.005 ) {
            [array insertObject:[NSNumber numberWithDouble:0.0] atIndex:i ];
        }
        else [array insertObject:[NSNumber numberWithDouble:qx+rx+dx] atIndex:i ];
        qx=qx+rx;
    }
    return array;
  
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
- (id)initWithArray:(int [])n andGFS:(GFS *)g repairing:(int [])rep{
    self = [super init];
    if (self) {
        gfs=g;
        array=n;
        repairing=rep;
        [gfs repairA:n withB:rep];
        double value=[gfs errorA:n withB:rep];
        NSLog(@"Repairing in progress: %g",value);
        name=[gfs stringA:n withB:rep];
    }
    return self;
}
@end



@implementation GFS {
    
    __block double _x; // variable is used in dynamically created block
    __block double _y;
    int _i;
    int _last_static;
    int _len_static;
    int _lastrepairing_static;
    int _lastbigger_static;
    int _debt;
    
    int* _last;
    int* _len;
    int* _lastrepairing;
    int* _lastbigger;
    NSMutableArray *xs;
    int j;
    double sumdx,dx,da,db;
    
    NSMutableString *temp;
    NSMutableString *buffer1;
    NSMutableString *buffer2;
}


@synthesize elements,variableNameInsteadOfValue,terminalsStartingIndex,bin,size,xpos,functions,constants;

-(NSDictionary*) mask:(uint64) b
{
    NSDictionary* dict = @{
          // arithmeticFunctions:
                           
      @"add" : (((b&bit1)==bit1)||([[[Configuration all] objectForKey:@"forcebit1"]isEqualTo:@YES]))?@YES:@NO,
      @"sub" : (((b&bit2)==bit2)||([[[Configuration all] objectForKey:@"forcebit2"]isEqualTo:@YES]))?@YES:@NO,
      @"mul" : (((b&bit3)==bit3)||([[[Configuration all] objectForKey:@"forcebit3"]isEqualTo:@YES]))?@YES:@NO,
      @"div" : (((b&bit4)==bit4)||([[[Configuration all] objectForKey:@"forcebit4"]isEqualTo:@YES]))?@YES:@NO,
      
      // goniometricFunctions:
      @"sin" : (((b&bit5)==bit5)||([[[Configuration all] objectForKey:@"forcebit5"]isEqualTo:@YES]))?@YES:@NO,
      @"cos" : (((b&bit6)==bit6)||([[[Configuration all] objectForKey:@"forcebit6"]isEqualTo:@YES]))?@YES:@NO,
      @"tan" : (((b&bit7)==bit7)||([[[Configuration all] objectForKey:@"forcebit7"]isEqualTo:@YES]))?@YES:@NO,
      
      // logarithmicFunctions:
      @"log" : (((b&bit8)==bit8)||([[[Configuration all] objectForKey:@"forcebit8"]isEqualTo:@YES]))?@YES:@NO,
      @"log2" : (((b&bit9)==bit9)||([[[Configuration all] objectForKey:@"forcebit9"]isEqualTo:@YES]))?@YES:@NO,
      @"log10" : (((b&bit10)==bit10)||([[[Configuration all] objectForKey:@"forcebit10"]isEqualTo:@YES]))?@YES:@NO,
      
      // polynomialFunctions:
      @"pow2" : (((b&bit11)==bit11)||([[[Configuration all] objectForKey:@"forcebit11"]isEqualTo:@YES]))?@YES:@NO,
      @"pow3" : (((b&bit12)==bit12)||([[[Configuration all] objectForKey:@"forcebit12"]isEqualTo:@YES]))?@YES:@NO,
      @"pow4" : (((b&bit13)==bit13)||([[[Configuration all] objectForKey:@"forcebit13"]isEqualTo:@YES]))?@YES:@NO,
      @"pow5" : (((b&bit14)==bit14)||([[[Configuration all] objectForKey:@"forcebit14"]isEqualTo:@YES]))?@YES:@NO,
      @"pow6" : (((b&bit15)==bit15)||([[[Configuration all] objectForKey:@"forcebit15"]isEqualTo:@YES]))?@YES:@NO, // Here is place for x,y according to 32th flag
      
      // linearConstants:
      @"1" : (((b&bit16)==bit16)||([[[Configuration all] objectForKey:@"forcebit16"]isEqualTo:@YES]))?@YES:@NO,
      @"2" : (((b&bit17)==bit17)||([[[Configuration all] objectForKey:@"forcebit17"]isEqualTo:@YES]))?@YES:@NO,
      @"3" : (((b&bit18)==bit18)||([[[Configuration all] objectForKey:@"forcebit18"]isEqualTo:@YES]))?@YES:@NO,
      @"4" : (((b&bit19)==bit19)||([[[Configuration all] objectForKey:@"forcebit19"]isEqualTo:@YES]))?@YES:@NO,
      @"5" : (((b&bit20)==bit20)||([[[Configuration all] objectForKey:@"forcebit20"]isEqualTo:@YES]))?@YES:@NO,
      @"6" : (((b&bit21)==bit21)||([[[Configuration all] objectForKey:@"forcebit21"]isEqualTo:@YES]))?@YES:@NO,
      @"7" : (((b&bit22)==bit22)||([[[Configuration all] objectForKey:@"forcebit22"]isEqualTo:@YES]))?@YES:@NO,
      @"8" : (((b&bit23)==bit23)||([[[Configuration all] objectForKey:@"forcebit23"]isEqualTo:@YES]))?@YES:@NO,
      @"9" : (((b&bit24)==bit24)||([[[Configuration all] objectForKey:@"forcebit24"]isEqualTo:@YES]))?@YES:@NO,
      
      // exponentialFunctions:
      @"^" : (((b&bit25)==bit25)||([[[Configuration all] objectForKey:@"forcebit25"]isEqualTo:@YES]))?@YES:@NO,
      @"2^" : (((b&bit26)==bit26)||([[[Configuration all] objectForKey:@"forcebit26"]isEqualTo:@YES]))?@YES:@NO,
      @"pi^" : (((b&bit27)==bit27)||([[[Configuration all] objectForKey:@"forcebit27"]isEqualTo:@YES]))?@YES:@NO,
      @"e^" : (((b&bit28)==bit28)||([[[Configuration all] objectForKey:@"forcebit28"]isEqualTo:@YES]))?@YES:@NO,
      
      // mathConstants:
      @"pi" : (((b&bit29)==bit29)||([[[Configuration all] objectForKey:@"forcebit29"]isEqualTo:@YES]))?@YES:@NO,
      @"e" : (((b&bit30)==bit30)||([[[Configuration all] objectForKey:@"forcebit30"]isEqualTo:@YES]))?@YES:@NO,
      @"phi" : (((b&bit31)==bit31)||([[[Configuration all] objectForKey:@"forcebit31"]isEqualTo:@YES]))?@YES:@NO,
      
      // 3D?
      @"y" : (((b&bit32)==bit32)||([[[Configuration all] objectForKey:@"forcebit32"]isEqualTo:@YES]))?@YES:@NO,
      } ;
    
    
    return dict;
}
/*! Instantiate GFS with elements of pointers to functions wrapped in custom GFSelement subclasses according to number of parameters used
 \return self
 */
-(id)initWithFunctionSet:(uint64)fsb{
    
    self = [super init];
    if (self) {
        
        _last=&_last_static;
        _len=&_len_static;
        _lastrepairing=&_lastrepairing_static;
        _lastbigger=&_lastbigger_static;
        
        
        xs = [IN ekvidistantDoublesCount:50 min:-1 max:2];
        
        bit1 = 1;    // 2^0    000...00000001     add
        bit2 = 2;    // 2^1    000...00000010     sub
        bit3 = 4;    // 2^2    000...00000100     mul
        bit4 = 8;    // 2^3    000...00001000     div
        bit5 = 16;   // 2^4    000...00010000     sin
        bit6 = 32;   // 2^5    000...00100000     cos
        bit7 = 64;   // 2^6    000...01000000     tan
        bit8 = 128;  // 2^7    000...10000000     log
        bit9 = 256;  // 2^8      log2
        bit10 = 512; // 2^9      log10
        bit11 = 1024;// 2^10     pow2
        bit12 = 2048;// 2^11     pow3
        bit13 = 4096;// 2^12     pow4
        bit14 = 8192;// 2^13     pow5
        bit15 = 16384;// 2^14    pow6
        bit16 = 32768;// 2^15    1
        bit17 = 65536;// 2^16    2
        bit18 = 131072;// 2^17   3
        bit19 = 262144;// 2^18   4
        bit20 = 524288;// 2^19   5
        bit21 = 1048576;// 2^20  6
        bit22 = 2097152;       //7
        bit23 = 4194304;       //8
        bit24 = 8388608;       //9
        bit25 = 16777216;      //10
        bit26 = 33554432;      //11
        bit27 = 67108864;      //12
        bit28 = 134217728;     //13
        bit29 = 268435456;     //14
        bit30 = 536870912;     //15
        bit31 = 1073741824;    //16
        bit32 = 2147483648;    //  force vars flag!
        
        bin=fsb;
        
        // create functions for GFSelement subclasses:
        func2 _add = ^(double a, double b) { return a + b; };
        func2 _sub = ^(double a, double b) { return a - b; };
        func2 _mul = ^(double a, double b) { return a * b; };
        func2 _div = ^(double a, double b) { return a / b; };
        
        func1 _sin = ^(double par) { return sin(par); };
        func1 _cos = ^(double par) { return cos(par); };
        func1 _tan = ^(double par) { return tan(par); };
        func1 _log = ^(double par) { return log(par); };
        func1 _log2 = ^(double par) { return log2(par); };
        func1 _log10 = ^(double par) { return log10(par); };
        
        func1 _pow2 = ^(double par) { return pow(par,2); };
        func1 _pow3 = ^(double par) { return pow(par,3); };
        func1 _pow4 = ^(double par) { return pow(par,4); };
        func1 _pow5 = ^(double par) { return pow(par,5); };
        func1 _pow6 = ^(double par) { return pow(par,6); };
        
        func0 _1=^() { return (double) 1; };
        func0 _2=^() { return (double) 2; };
        func0 _3=^() { return (double) 3; };
        func0 _4=^() { return (double) 4; };
        func0 _5=^() { return (double) 5; };
        func0 _6=^() { return (double) 6; };
        func0 _7=^() { return (double) 7; };
        func0 _8=^() { return (double) 8; };
        func0 _9=^() { return (double) 9; };
        
        func2 _up = ^(double a, double b) { return pow(a,b); };
        func1 _2up = ^(double par) { return pow(2,par); };
        func1 _piup = ^(double par) { return pow(M_PI,par); };
        func1 _eup = ^(double par) { return pow(M_E,par); };
    
        func0 _pi=^() { return (double) M_PI; };
        func0 _e=^() { return (double) M_E; };
        func0 _phi=^() { return (double) 1.618033988749894848204586834365; };
        
        // initial values for variables which may be used in calculations:
        _x=1;
        _y=1;
        
        functions=0;
        
        NSDictionary* fs=[self mask:fsb];
        
        elements=[[NSMutableArray alloc] initWithCapacity:32];
        
        bin=0;
        
        if (([[[Configuration all] objectForKey:@"arithmeticFunctions"]isEqualTo:@YES])||
            ([[[Configuration all] objectForKey:@"linearConstants"]isEqualTo:@YES])){
        
            if (([[fs objectForKey:@"add"] isEqualTo:@YES])&&((![[[Configuration all] objectForKey:@"forcebit1"]isEqualTo:@NO])||([[[Configuration all] objectForKey:@"forcebit1"]isEqualTo:[NSNull null]]))) {
                [elements insertObject:[[GFS2 alloc]initWith:_add name:@"+"] atIndex:functions++ ];
                bin|=bit1;
            }
    
            if (([[fs objectForKey:@"sub"] isEqualTo:@YES])&&((![[[Configuration all] objectForKey:@"forcebit2"]isEqualTo:@NO])||([[[Configuration all] objectForKey:@"forcebit2"]isEqualTo:[NSNull null]]))) {
                [elements insertObject:[[GFS2 alloc]initWith:_sub name:@"-"] atIndex:functions++ ];
                bin|=bit2;
            }
            
            if (([[fs objectForKey:@"mul"] isEqualTo:@YES])&&((![[[Configuration all] objectForKey:@"forcebit3"]isEqualTo:@NO])||([[[Configuration all] objectForKey:@"forcebit3"]isEqualTo:[NSNull null]]))) {
                [elements insertObject:[[GFS2 alloc]initWith:_mul name:@"*"] atIndex:functions++ ];
                bin^=bit3;
            }
            
            
            if (([[fs objectForKey:@"div"] isEqualTo:@YES])&&((![[[Configuration all] objectForKey:@"forcebit4"]isEqualTo:@NO])||([[[Configuration all] objectForKey:@"forcebit4"]isEqualTo:[NSNull null]]))) {
                [elements insertObject:[[GFS2 alloc]initWith:_div name:@"/"] atIndex:functions++ ];
                bin^=bit4;
            }
            
        }
        
        if ([[[Configuration all] objectForKey:@"exponentialFunctions"]isEqualTo:@YES]) {
            if (([[fs objectForKey:@"^"] isEqualTo:@YES])&&((![[[Configuration all] objectForKey:@"forcebit125"]isEqualTo:@NO])||([[[Configuration all] objectForKey:@"forcebit125"]isEqualTo:[NSNull null]]))) {
                [elements insertObject:[[GFS2 alloc]initWith:_up name:@"^"] atIndex:functions++ ];
                bin|=bit25;
            }
        }
        
        //gfs1StartingIntex=functions;
        
        if ([[[Configuration all] objectForKey:@"goniometricFunctions"]isEqualTo:@YES]) {
            if (([[fs objectForKey:@"sin"] isEqualTo:@YES])&&((![[[Configuration all] objectForKey:@"forcebit5"]isEqualTo:@NO])||([[[Configuration all] objectForKey:@"forcebit5"]isEqualTo:[NSNull null]]))) {
                [elements insertObject:[[GFS1 alloc]initWith:_sin name:@"sin"] atIndex:functions++ ];
                bin^=bit5;
            }
            
            if (([[fs objectForKey:@"cos"] isEqualTo:@YES])&&((![[[Configuration all] objectForKey:@"forcebit6"]isEqualTo:@NO])||([[[Configuration all] objectForKey:@"forcebit6"]isEqualTo:[NSNull null]]))) {
                [elements insertObject:[[GFS1 alloc]initWith:_cos name:@"cos"] atIndex:functions++ ];
                bin|=bit6;
            }
            
            if (([[fs objectForKey:@"tan"] isEqualTo:@YES])&&((![[[Configuration all] objectForKey:@"forcebit7"]isEqualTo:@NO])||([[[Configuration all] objectForKey:@"forcebit7"]isEqualTo:[NSNull null]]))) {
                [elements insertObject:[[GFS1 alloc]initWith:_tan name:@"tan"] atIndex:functions++ ];
                bin|=bit7;
            }
            
        }
        if ([[[Configuration all] objectForKey:@"logarithmicFunctions"]isEqualTo:@YES]) {
            if (([[fs objectForKey:@"log"] isEqualTo:@YES])&&((![[[Configuration all] objectForKey:@"forcebit8"]isEqualTo:@NO])||([[[Configuration all] objectForKey:@"forcebit8"]isEqualTo:[NSNull null]]))) {
                [elements insertObject:[[GFS1 alloc]initWith:_log name:@"log"] atIndex:functions++ ];
                bin|=bit8;
            }
            
            if (([[fs objectForKey:@"log2"] isEqualTo:@YES])&&((![[[Configuration all] objectForKey:@"forcebit9"]isEqualTo:@NO])||([[[Configuration all] objectForKey:@"forcebit9"]isEqualTo:[NSNull null]]))) {
                [elements insertObject:[[GFS1 alloc]initWith:_log2 name:@"log2"] atIndex:functions++ ];
                bin|=bit9;
            }
            
            if (([[fs objectForKey:@"log10"] isEqualTo:@YES])&&((![[[Configuration all] objectForKey:@"forcebit10"]isEqualTo:@NO])||([[[Configuration all] objectForKey:@"forcebit10"]isEqualTo:[NSNull null]]))) {
                [elements insertObject:[[GFS1 alloc]initWith:_log10 name:@"log10"] atIndex:functions++ ];
                bin|=bit10;
            }
        }
        if ([[[Configuration all] objectForKey:@"polynomialFunctions"]isEqualTo:@YES]) {
            if (([[fs objectForKey:@"pow2"] isEqualTo:@YES])&&((![[[Configuration all] objectForKey:@"forcebit11"]isEqualTo:@NO])||([[[Configuration all] objectForKey:@"forcebit11"]isEqualTo:[NSNull null]]))) {
                [elements insertObject:[[GFS1 alloc]initWith:_pow2 name:@"^2"] atIndex:functions++ ];
                bin|=bit11;
            }
            
            if (([[fs objectForKey:@"pow3"] isEqualTo:@YES])&&((![[[Configuration all] objectForKey:@"forcebit12"]isEqualTo:@NO])||([[[Configuration all] objectForKey:@"forcebit12"]isEqualTo:[NSNull null]]))) {
                [elements insertObject:[[GFS1 alloc]initWith:_pow3 name:@"^3"] atIndex:functions++ ];
                bin|=bit12;
            }
            
            if (([[fs objectForKey:@"pow4"] isEqualTo:@YES])&&((![[[Configuration all] objectForKey:@"forcebit13"]isEqualTo:@NO])||([[[Configuration all] objectForKey:@"forcebit13"]isEqualTo:[NSNull null]]))) {
                [elements insertObject:[[GFS1 alloc]initWith:_pow4 name:@"^4"] atIndex:functions++ ];
                bin|=bit13;
            }
            
            if (([[fs objectForKey:@"pow5"] isEqualTo:@YES])&&((![[[Configuration all] objectForKey:@"forcebit14"]isEqualTo:@NO])||([[[Configuration all] objectForKey:@"forcebit14"]isEqualTo:[NSNull null]]))) {
                [elements insertObject:[[GFS1 alloc]initWith:_pow5 name:@"^5"] atIndex:functions++ ];
                bin|=bit14;
            }
            
            if (([[fs objectForKey:@"pow6"] isEqualTo:@YES])&&((![[[Configuration all] objectForKey:@"forcebit15"]isEqualTo:@NO])||([[[Configuration all] objectForKey:@"forcebit15"]isEqualTo:[NSNull null]]))) {
                [elements insertObject:[[GFS1 alloc]initWith:_pow6 name:@"^6"] atIndex:functions++ ];
                bin|=bit15;
            }
        }
        
        if ([[[Configuration all] objectForKey:@"exponentialFunctions"]isEqualTo:@YES]) {
            if (([[fs objectForKey:@"2^"] isEqualTo:@YES])&&((![[[Configuration all] objectForKey:@"forcebit26"]isEqualTo:@NO])||([[[Configuration all] objectForKey:@"forcebit26"]isEqualTo:[NSNull null]]))) {
                [elements insertObject:[[GFS1 alloc]initWith:_2up name:@"2^"] atIndex:functions++ ];
                bin|=bit26;
            }
            
            if (([[fs objectForKey:@"pi^"] isEqualTo:@YES])&&((![[[Configuration all] objectForKey:@"forcebit27"]isEqualTo:@NO])||([[[Configuration all] objectForKey:@"forcebit27"]isEqualTo:[NSNull null]]))) {
                [elements insertObject:[[GFS1 alloc]initWith:_piup name:@"pi^"] atIndex:functions++ ];
                bin|=bit27;
            }
            
            if (([[fs objectForKey:@"e^"] isEqualTo:@YES])&&((![[[Configuration all] objectForKey:@"forcebit28"]isEqualTo:@NO])||([[[Configuration all] objectForKey:@"forcebit28"]isEqualTo:[NSNull null]]))) {
                [elements insertObject:[[GFS1 alloc]initWith:_eup name:@"e^"] atIndex:functions++ ];
                bin|=bit28;
            }
            
        }
        
        
        xpos=functions;
        
        terminalsStartingIndex=xpos;
        
        [elements insertObject:[[GFSvar alloc] initWith:&_x name:@"x"] atIndex:xpos++];
        
        if ([[[Configuration all] objectForKey:@"3D"] isEqualTo:@YES])
           [elements insertObject:[[GFSvar alloc] initWith:&_y name:@"y"] atIndex:xpos++];
        
        if ([[[Configuration all] objectForKey:@"linearConstants"]isEqualTo:@YES]) {
        
            if (([[fs objectForKey:@"1"] isEqualTo:@YES])&&((![[[Configuration all] objectForKey:@"forcebit16"]isEqualTo:@NO])||([[[Configuration all] objectForKey:@"forcebit16"]isEqualTo:[NSNull null]]))) {
                [elements insertObject:[[GFS0 alloc]initWith:_1 name:@"1"] atIndex:xpos++];
                bin|=bit16;
            }
            
            if (([[fs objectForKey:@"2"] isEqualTo:@YES])&&((![[[Configuration all] objectForKey:@"forcebit17"]isEqualTo:@NO])||([[[Configuration all] objectForKey:@"forcebit17"]isEqualTo:[NSNull null]]))) {
                [elements insertObject:[[GFS0 alloc]initWith:_2 name:@"2"] atIndex:xpos++];
                bin|=bit17;
            }
            
            if (([[fs objectForKey:@"3"] isEqualTo:@YES])&&((![[[Configuration all] objectForKey:@"forcebit18"]isEqualTo:@NO])||([[[Configuration all] objectForKey:@"forcebit18"]isEqualTo:[NSNull null]]))) {
                [elements insertObject:[[GFS0 alloc]initWith:_3 name:@"3"] atIndex:xpos++];
                bin|=bit18;
            }
            
            if (([[fs objectForKey:@"4"] isEqualTo:@YES])&&((![[[Configuration all] objectForKey:@"forcebit19"]isEqualTo:@NO])||([[[Configuration all] objectForKey:@"forcebit19"]isEqualTo:[NSNull null]]))) {
                [elements insertObject:[[GFS0 alloc]initWith:_4 name:@"4"] atIndex:xpos++];
                bin|=bit19;
            }
            
            if (([[fs objectForKey:@"5"] isEqualTo:@YES])&&((![[[Configuration all] objectForKey:@"forcebit20"]isEqualTo:@NO])||([[[Configuration all] objectForKey:@"forcebit20"]isEqualTo:[NSNull null]]))) {
                [elements insertObject:[[GFS0 alloc]initWith:_5 name:@"5"] atIndex:xpos++];
                bin|=bit20;
            }
            
            if (([[fs objectForKey:@"6"] isEqualTo:@YES])&&((![[[Configuration all] objectForKey:@"forcebit21"]isEqualTo:@NO])||([[[Configuration all] objectForKey:@"forcebit21"]isEqualTo:[NSNull null]]))) {
                [elements insertObject:[[GFS0 alloc]initWith:_6 name:@"6"] atIndex:xpos++];
                bin|=bit21;
            }
            
            if (([[fs objectForKey:@"7"] isEqualTo:@YES])&&((![[[Configuration all] objectForKey:@"forcebit22"]isEqualTo:@NO])||([[[Configuration all] objectForKey:@"forcebit22"]isEqualTo:[NSNull null]]))) {
                [elements insertObject:[[GFS0 alloc]initWith:_7 name:@"7"] atIndex:xpos++];
                bin|=bit22;
            }
            
            if (([[fs objectForKey:@"8"] isEqualTo:@YES])&&((![[[Configuration all] objectForKey:@"forcebit23"]isEqualTo:@NO])||([[[Configuration all] objectForKey:@"forcebit23"]isEqualTo:[NSNull null]]))) {
                [elements insertObject:[[GFS0 alloc]initWith:_8 name:@"8"] atIndex:xpos++];
                bin|=bit23;
            }
            
            if (([[fs objectForKey:@"9"] isEqualTo:@YES])&&((![[[Configuration all] objectForKey:@"forcebit24"]isEqualTo:@NO])||([[[Configuration all] objectForKey:@"forcebit24"]isEqualTo:[NSNull null]]))) {
                [elements insertObject:[[GFS0 alloc]initWith:_9 name:@"9"] atIndex:xpos++];
                bin|=bit24;
            }
        }
        
        if ([[[Configuration all] objectForKey:@"mathConstants"]isEqualTo:@YES]) {
            if (([[fs objectForKey:@"pi"] isEqualTo:@YES])&&((![[[Configuration all] objectForKey:@"forcebit29"]isEqualTo:@NO])||([[[Configuration all] objectForKey:@"forcebit29"]isEqualTo:[NSNull null]]))) {
                [elements insertObject:[[GFS0 alloc]initWith:_pi name:@"pi"] atIndex:xpos++];
                bin|=bit29;
            }
            
            if (([[fs objectForKey:@"e"] isEqualTo:@YES])&&((![[[Configuration all] objectForKey:@"forcebit30"]isEqualTo:@NO])||([[[Configuration all] objectForKey:@"forcebit30"]isEqualTo:[NSNull null]]))) {
                [elements insertObject:[[GFS0 alloc]initWith:_e name:@"e"] atIndex:xpos++];
                bin|=bit30;
            }
            
            if (([[fs objectForKey:@"phi"] isEqualTo:@YES])&&((![[[Configuration all] objectForKey:@"forcebit31"]isEqualTo:@NO])||([[[Configuration all] objectForKey:@"forcebit31"]isEqualTo:[NSNull null]]))) {
                [elements insertObject:[[GFS0 alloc]initWith:_phi name:@"phi"] atIndex:xpos++];
                bin|=bit31;
            }
        }
        
        constants=xpos-terminalsStartingIndex;
        
        constants-=1;//there is x variable everytime
        if ([[[Configuration all] objectForKey:@"3D"]isEqualTo:@YES])
            constants-=1;//y variable;
        
        size=xpos;
    }
    
    return self;
}


-(void)setValueOf:(NSString*)var value:(double)val{
    if ([var isEqual:@"x"])
        _x=val;
    if ([var isEqual:@"y"])
        _y=val;
}




-(NSString *)toStringRecursive:(int[])array at:(int) i last:(int*)last max:(int*)len repairing:(int *)repairing lastrepairing:(int*)lastrepairing lastbigger:(int*)lastbigger{
int j=*last;
    GFSelement *f=[elements objectAtIndex:array[i]];
    
    if ([f conformsToProtocol: @protocol( GFS2args )]){
        *last+=2;
        return [NSString stringWithFormat:@"(%@%@%@)",
                [self toStringRecursive:array at:j+1 last:last max:len repairing:repairing lastrepairing:lastrepairing lastbigger:lastbigger],
                [((GFS2*)f) name],
                [self toStringRecursive:array at:j+2 last:last max:len repairing:repairing lastrepairing:lastrepairing lastbigger:lastbigger]];
    } else if ([f conformsToProtocol: @protocol( GFS1args )]){
        *last+=1;
        if (([[((GFS1*)f) name] isEqualToString:@"^2"]) ||
            ([[((GFS1*)f) name] isEqualToString:@"^3"]) ||
            ([[((GFS1*)f) name] isEqualToString:@"^4"]) ||
            ([[((GFS1*)f) name] isEqualToString:@"^5"]) ||
            ([[((GFS1*)f) name] isEqualToString:@"^6"]))
            
            return [NSString stringWithFormat:@"(%@)%@",
                    [self toStringRecursive:array at:j+1 last:last max:len repairing:repairing lastrepairing:lastrepairing lastbigger:lastbigger],
                    [((GFS1*)f) name]];
        
        else return [NSString stringWithFormat:@"%@(%@)",
                     [((GFS1*)f) name],
                     [self toStringRecursive:array at:j+1 last:last max:len repairing:repairing lastrepairing:lastrepairing lastbigger:lastbigger]];
    } else if ([f conformsToProtocol: @protocol( GFS0args )]){
        return [NSString stringWithFormat:@"%@",[((GFS0*)f) name]];
        
    } else if ([f conformsToProtocol: @protocol( GFSreinforced )]){
        return [((GFSrein*)f) name];
        
    } else if ([f conformsToProtocol: @protocol( GFSvariable )]){
        if (variableNameInsteadOfValue)
            return [f name];
        if ([[f name] isEqual:@"x"])
            return[NSString stringWithFormat:@"%g",_x];
        else if ([[f name] isEqual:@"y"])
            return[NSString stringWithFormat:@"%g",_y];
    }
    return @"_";
}


-(double)evaluateRecursive:(int[]) array
                                 at:(int)  i
                               last:(int*) last
                                max:(int*) len
                          repairing:(int*) repairing
                      lastrepairing:(int*) lastrepairing
                         lastbigger:(int*) lastbigger
                              depth:(int*) depth{
    
    // necessary local variables inside recursion:
    int j = *last;
    GFSelement *f;
    double a,b,result;
    
    f=[elements objectAtIndex:array[i]];
    
    if ([f conformsToProtocol: @protocol( GFS2args )]){
        *last+=2;
        
        a=[self evaluateRecursive:array at:j+1 last:last max:len repairing:repairing lastrepairing:lastrepairing lastbigger:lastbigger depth:depth];
        
        b=[self evaluateRecursive:array at:j+2 last:last max:len repairing:repairing lastrepairing:lastrepairing lastbigger:lastbigger depth:depth];
        result=[((GFS2 *)f) eval: a and: b];
        
        return result;
        
    } else if ([f conformsToProtocol: @protocol( GFS1args )]){
        *last+=1;
        
        b=[self evaluateRecursive:array at:j+1 last:last max:len repairing:repairing lastrepairing:lastrepairing lastbigger:lastbigger depth:depth];
        result=[((GFS1 *)f) eval:b];
        
        
            *depth+=1;
            return result;
        
    } else if ([f conformsToProtocol: @protocol( GFS0args )]){
        return [((GFS0 *)f) eval];
        
    } else if ([f conformsToProtocol: @protocol( GFSreinforced )]){
        int a=0;
        int b=0;
        int c=0;
        return [self evaluateRecursive:[((GFSrein*)f) get] at:a last:&b max:len repairing:[((GFSrein*)f) getRepairing] lastrepairing:lastrepairing lastbigger:lastbigger depth:&c];
        
    } else if ([f conformsToProtocol: @protocol( GFSvariable )]){
        if ([[f name] isEqual:@"x"])
            
            return _x;
        else if ([[f name] isEqual:@"y"])
            
            return _y;
        
    }
    return (double)NAN;
}

-(double)evaluateRepairingRecursive:(int[]) array
                                 at:(int)  i
                               last:(int*) last
                                max:(int*) len
                          repairing:(int*) repairing
                      lastrepairing:(int*) lastrepairing
                         lastbigger:(int*) lastbigger
                              depth:(int*) depth{
    
    // necessary local variables inside recursion:
    int j = *last;
    GFSelement *f;
    double a,b,result;
    
    // if there were MAXDEPTH or more calls of a GFS1 function:
    if ((*depth > MAXDEPTH)||(*lastbigger > size)||(*last > MAXWIDTH)) {
        
        f=[elements objectAtIndex:terminalsStartingIndex];
        array[i]=terminalsStartingIndex;
        
    } else if (i>*len) {
        
        // select
        f=[elements objectAtIndex:repairing[(*lastbigger)]];
        array[i]=repairing[*lastbigger];
        *lastbigger+=1;
        
    } else
        f=[elements objectAtIndex:array[i]];
    
    if ([f conformsToProtocol: @protocol( GFS2args )]){
        *last+=2;
        
        //====>
        a=[self evaluateRepairingRecursive:array at:j+1 last:last max:len repairing:repairing lastrepairing:lastrepairing lastbigger:lastbigger depth:depth];
        
        //====>
        b=[self evaluateRepairingRecursive:array at:j+2 last:last max:len repairing:repairing lastrepairing:lastrepairing lastbigger:lastbigger depth:depth];
        result=[((GFS2 *)f) eval: a and: b];
        
        if ((a == NAN) || (b == NAN) || (a == INFINITY) || (b == INFINITY) ||
            (a == -INFINITY) || (b == -INFINITY) || (result == NAN) ||
            (result == INFINITY) || (result == -INFINITY)){
            
            f=[elements objectAtIndex:repairing[*lastrepairing]];
            array[i]=repairing[*lastrepairing];// REPAIRING!!
            *lastrepairing+=1;
            
        } else return result;
        
    } else if ([f conformsToProtocol: @protocol( GFS1args )]){
        *last+=1;
        
        b=[self evaluateRepairingRecursive:array at:j+1 last:last max:len repairing:repairing lastrepairing:lastrepairing lastbigger:lastbigger depth:depth];
        result=[((GFS1 *)f) eval:b];
        
        if ((b == NAN) || (b==INFINITY) || (b==-INFINITY) || (result == NAN) || (result == INFINITY) || (result == -INFINITY)) {
            f=[elements objectAtIndex:repairing[*lastrepairing]];
            array[i]=repairing[*lastrepairing];
            *lastrepairing+=1;
            
        } else {
            *depth+=1;
            return result;
        }
        
    } else if ([f conformsToProtocol: @protocol( GFS0args )]){
        return [((GFS0 *)f) eval];
        
    } else if ([f conformsToProtocol: @protocol( GFSreinforced )]){
        int a=0;
        int b=0;
        int c=0;
        return [self evaluateRepairingRecursive:[((GFSrein*)f) get] at:a last:&b max:len repairing:[((GFSrein*)f) getRepairing] lastrepairing:lastrepairing lastbigger:lastbigger depth:&c];
        
    } else if ([f conformsToProtocol: @protocol( GFSvariable )]){
        if ([[f name] isEqual:@"x"])
            return _x;
        else if ([[f name] isEqual:@"y"])
            return _y;
        
    }
    return (double)NAN;
}

-(NSString*)description{
    NSMutableString *t=[NSMutableString stringWithString:@"{"];
    for (id element in elements){
        [t appendString:[NSString stringWithFormat:@"%@,",[element name]]];
    }
    [t appendString:@"}"];
    return [NSString stringWithString:t];
    
    
}

-(void)null {
    _i=0;
    _last_static=0;
    _len_static=32;
    _lastrepairing_static=0;
    _lastbigger_static=0;
    _debt=0;
}

-(NSString *)describeA:(int[])_a withB:(int[])_b{
    
    temp=[NSMutableString stringWithFormat:@""];
    buffer1=[NSMutableString stringWithFormat:@""];
    buffer2=[NSMutableString stringWithFormat:@""];
    
    for (int v = 0; v < 32; v++) {
        [buffer1 appendString:[NSString stringWithFormat:@"%d,",_a[v]]];
        [buffer2 appendString:[NSString stringWithFormat:@"%i,",_b[v]]];
    }
    
    //[temp appendFormat:@"\n[%@]\n[%@]\n",buffer1,buffer2];
    
    self.variableNameInsteadOfValue=YES;
    
    double fitness=[self errorA:_a withB:_b];
    
    [temp appendString:[NSString stringWithFormat:@"\n%llu\n[%@]\n[%@]\n%@\n%@",[self bin],buffer1,buffer2,[self stringA:_a withB:_b],[NSNumber numberWithDouble:fitness]]];
    
    return [NSString stringWithFormat:@"%@",temp];

}

-(NSString *)stringA:(int[])_a withB:(int[])_b{
    [self null];
    return [self toStringRecursive:_a
                                at:_i
                              last:_last
                               max:_len
                         repairing:_b
                     lastrepairing:_lastrepairing
                        lastbigger:_lastbigger];
}

-(void)repairA:(int[])_a withB:(int[])_b{
    [self null];
    [self evaluateRepairingRecursive:_a at:_i last:_last max:_len repairing:_b lastrepairing:_lastrepairing lastbigger:_lastbigger depth:&_debt];
}

-(double)errorA:(int[])_a withB:(int[])_b{
    
    sumdx=0;
    double error=0;
    for (j=0; j<32; j++) {
        
        [self null];
        
        dx=[[xs objectAtIndex:j]doubleValue];
        
        da=[self evaluateRecursive:_a at:_i last:_last max:_len repairing:_b lastrepairing:_lastrepairing lastbigger:_lastbigger depth:&_debt];
        
        if ([[[Configuration all] objectForKey:@"function2D"] isEqualTo:@"x^6-2x^4+x^2"])
            db=(pow(dx,6)-(2*pow(dx,4))+pow(dx,2));
        
        else if ([[[Configuration all] objectForKey:@"function2D"] isEqualTo:@"sin(x^6)-((2*cos(x))^4+(tan(x))^2)"])
            db=(sin(pow(dx,6))-(2*pow(cos(dx),4))+pow(tan(dx),2));
        
        if (da>0) {
            if (db>0) {
                if (da>db) {
                    error=da-db;
                } else {
                    error=db-da;
                }
            } else {
                error=da-db;
            }
        } else if (da<0) {
            if (db>0) {
                error=db-da;
            } else {
                
                if (db<da){
                    return db-da;
                } else {
                    return da-db;
                }
            }
        }
        
        
        sumdx+=error;
        
        
    }
    return sumdx;
}

@end

@implementation OUT {
    int i,j;
    double a,b,dx,dy,sumdx;
    double best;
    NSMutableArray *xs;
    NSMutableArray *ys;
    NSMutableString *mutable;
   
}

@synthesize gfs,configuration,calculations;

- (id)initWithConfiguration:(NSDictionary*) conf andGFS:(GFS*)gs{
    self = [super init];
    if (self) {
        best=FLT_MAX;
        configuration=conf;
        gfs=gs;
        calculations=[[NSMutableDictionary alloc]initWithCapacity:1000];
        xs = [IN ekvidistantDoublesCount:50 min:-1 max:2];
        ys = [IN ekvidistantDoublesCount:50 min:-1 max:2];
    }
    return self;
}

-(BOOL)insertFitness:(double)f string:(NSString*)s{
    //if ([[self.calculations allKeys] ]) ) {
    //if ([self bestDescription]!=Nil) {
        
    
    
    if ((f<best) && (!((f==0)||(f==-INFINITY)||(f==INFINITY)||(f==NAN)||(f<0)))) {
        
        [calculations setValue:s forKey:[NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:f]]];
        best=f;
        NSLog(@"\n%@\n\nBEST:%f",[self bestDescription],best);
    //}
        
        if (best<10) {
            return YES;
        }
    }
    
    return NO;
}

-(NSString*)bestDescription{
    if (best!=FLT_MAX)
        return [NSString stringWithFormat:@"%@",[calculations  objectForKey:[NSString stringWithFormat:@"%@", [NSNumber numberWithDouble:best]]]];
    else
        return @"";
    
    
}

-(NSString*)description{
    mutable=[NSMutableString stringWithFormat:@""];
    for (NSString *n in [calculations allKeys]) {
        [mutable appendString:[NSString stringWithFormat:@"%@",[calculations objectForKey:n]]];
    }
    return [NSString stringWithFormat:@"%@\n",mutable];
}
@end