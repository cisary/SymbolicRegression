//
//  SymbolicRegression_Tests.m
//  SymbolicRegression Tests
//
//  Created by Michal Cisarik on 5/25/14.
//  Copyright (c) 2014 Michal Cisarik. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "DE.h"


@interface SymbolicRegression_Tests : XCTestCase {
    int **buffer;
    DE *de;
    GFS *gfs;
    OUT *output;
    MersenneTwister *mt;
    double fitness;
}
@property int** buffer;
@property DE *de;
@property GFS *gfs;
@property OUT* output;

@property MersenneTwister *mt;
@end

@implementation SymbolicRegression_Tests
@synthesize output,gfs,buffer,mt,de;
- (void)setUp
{
    [super setUp];
    //gfs = [[GFS alloc]initWithFunctionSet:UINT64_MAX];
    mt=[[MersenneTwister alloc]initWithSeed:(uint32)time(NULL)];
    
    NSLog(@"%@",[Configuration all]);
    
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testDE{
    
    de = [[DE alloc]initWith64bits:UINT32_MAX];
    
    [de metaEvolve];
    
    NSLog(@"%@",de);
    int i=0;
}
- (void)testGFSdescription
{
    NSString *s=[NSString stringWithFormat:@"%@",[[GFS alloc]initWithFunctionSet:UINT64_MAX]];
    
    XCTAssertEqualObjects(s, @"{+,-,*,/,sin,cos,tan,log,log2,log10,^2,^3,^4,^5,^6,^,2^,pi^,e^,x,1,2,3,4,5,6,7,8,9,pi,e,phi,}", @"Hmm");
    
    s=[NSString stringWithFormat:@"%@",[[GFS alloc]initWithFunctionSet:UINT16_MAX]];
    
    XCTAssertEqualObjects(s, @"{+,-,*,/,sin,cos,tan,log,log2,log10,^2,^3,^4,^5,^6,x,1,}", @"Hmm");
    
    s=[NSString stringWithFormat:@"%@",[[GFS alloc]initWithFunctionSet:UINT8_MAX]];
    
    XCTAssertEqualObjects(s, @"{+,-,*,/,sin,cos,tan,log,x,}", @"Hmm");
    
    int i=8;
}

- (void)testGFScalculationRepairing{
    gfs=[[GFS alloc]initWithFunctionSet:UINT8_MAX];
    output=[[OUT alloc ]initWithConfiguration:[Configuration all] andGFS:gfs];
    
    //NSLog(@"GFS=%d!",UINT8_MAX);
    
    //NSLog(@"GFS=%@",[NSString stringWithFormat:@"%@",[[GFS alloc]initWithFunctionSet:UINT8_MAX]]);
    
    int _t=[gfs terminalsStartingIndex];
    
    int* a = (int *) malloc(sizeof(int) * 32);
    int* b = (int *) malloc(sizeof(int) * 32);
    
    for (int i=0; i<32; i++) {
        a[i]=[mt randomUInt32From:0 to:[gfs terminalsStartingIndex]];
        b[i]=[mt randomUInt32From:[gfs terminalsStartingIndex] to:[gfs size]];
    }
    
    
    
    NSMutableString *buffer1=[NSMutableString stringWithFormat:@""];
    NSMutableString *buffer2=[NSMutableString stringWithFormat:@""];
    
    for (int v = 0; v < 32; v++) {
        [buffer1 appendString:[NSString stringWithFormat:@"%d,",a[v]]];
        [buffer2 appendString:[NSString stringWithFormat:@"%d,",b[v]]];
    }
    
    NSLog(@"\na=[%@]\nb=[%@]\n",buffer1,buffer2);
    
    [gfs repairA:a withB:b];
    
    buffer1=[NSMutableString stringWithFormat:@""];
    
    for (int v = 0; v < 32; v++) {
        [buffer1 appendString:[NSString stringWithFormat:@"%d,",a[v]]];
    }
    
    NSLog(@"%@\n",buffer1);
    
    fitness=[gfs errorA:a withB:b];
    
    gfs.variableNameInsteadOfValue=YES;
    
    

    [output insertFitness:fitness string:[NSString stringWithFormat:@"\n%d\n[%@]\n[%@]\n%@\n>%@",[gfs bin],buffer1,buffer2,[gfs stringA:a withB:b],[NSNumber numberWithDouble:fitness]]];
    
    NSLog(@"%@",output);
    int sdi=3;
    XCTAssertEqualObjects(output, @"s", @"Hmm");
}


@end
