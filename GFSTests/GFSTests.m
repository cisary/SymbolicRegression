//
//  HelloWorld06_Tests.m
//  HelloWorld06 Tests
//
//  Created by Michal Cisarik on 8/14/13.
//  Copyright (c) 2013 Michal Cisarik. All rights reserved.
//
#import <SenTestingKit/SenTestingKit.h>
#import "GFS.h"

@interface GFSTests : SenTestCase
@property GFS *gfs;
@end

@implementation GFSTests
@synthesize gfs;
- (void)setUp {
    gfs = [[GFS alloc]initFunctionSet];
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

-(void)testDescription {
    NSString *expected=@"GFS={+, -, *, /, log, sin, cos, tan, x, 2, 3, }";
    NSString *evaluated=[gfs description];
    STAssertTrue([evaluated isEqualToString:expected],@"GFS Description");
}

-(void)testToString {
    [gfs setValueOf:@"x" value:(double)7];
    int a[20]={0,5,6,7,8,9,10,10,10,0,0,0,0,0,0,0,0,0,0,0};
    int b[20]={10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10};
    NSString *out=[[[GFSrein alloc]initWithArray:a andGFS:gfs repairing:b] name];
    STAssertTrue([out isEqualToString:@"(sin(tan(7))+cos(2))"],
                 @"Test for testing toString in name function of the GFSrein");
    
    Calculation *c=[[Calculation alloc]initWithArray:a andRepairing:b];
    out=[gfs toStringRepairing:c];
    STAssertTrue([out isEqualToString:@"(sin(tan(7))+cos(2))"],
                 @"toString called by toStringRepairing with one parameter: instance of the Calculation class");

}

-(void)testEvaluate {
    [gfs setValueOf:@"x" value:(double)7];
    int a[20]={0,5,6,7,8,9,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
    int b[20]={10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10};
    Calculation *c=[[Calculation alloc]initWithArray:a andRepairing:b];
    NSString *calculated=[NSString stringWithFormat:@"%.11f",
                          [gfs evaluateRepairing:c]];
    NSString *expected=@"0.34911499659";
    STAssertTrue([calculated isEqualToString:expected],@"Calculate");
    
}

-(void)testEvaluate_DivisionByZero {
//    [gfs setValueOf:@"x" value:(double)0];
//    int a[20]={3,6,10,10,10,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};//(sin(0)/0)
//    int b[20]={9,9,9,9,9,9,10,10,10,10,10,10,10,10,10,10,10,10,10,10};
//    int i=0;int j=0;int k=19;
//    NSString *calculated=[NSString stringWithFormat:@"%.11f",
//                          [gfs evaluate:a at:i last:&j max:&k repairing:b]];
//    NSString *repr=[[[GFSrein alloc]initWithArray:a andGFS:gfs repairing:b] name];
//    NSString *expected=@"-0.22473066347";
//    STAssertTrue([calculated isEqualToString:expected],@"Calculate");
}


@end
