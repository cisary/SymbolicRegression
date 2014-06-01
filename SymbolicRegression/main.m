//
//  main.m
//  SymbolicRegression
//
//  Created by Michal Cisarik on 8/14/13.
//  Copyright (c) 2013 Michal Cisarik. All rights reserved.
//
/*
 #import <SenTestingKit/SenTestingKit.h>
 #import "GFS.h"
 
 @interface GFSTests : SenTestCase
 @property GFS *gfs;
 @end
 
 @implementation GFSTests
 @synthesize gfs;
 - (void)setUp {
 gfs = [[GFS alloc]initWithFunctionSet:(uint64_t)98930 *98930];
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
 out=[gfs toString:c];
 
 
 STAssertTrue([out isEqualToString:@"(sin(tan(7))+cos(2))"],
 @"toString called by toStringRepairing with one parameter: instance of the Calculation class");
 
 }
 
 -(void)testEvaluate {
 [gfs setValueOf:@"x" value:(double)7];
 int a[20]={0,5,6,7,8,9,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
 int b[20]={10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10};
 
 Calculation *c=[[Calculation alloc]initWithArray:a andRepairing:b];
 
 NSString *calculated=[NSString stringWithFormat:@"%.11f", [gfs evaluateRepairing:c]];
 NSString *expected=@"0.34911499659";
 STAssertTrue([calculated isEqualToString:expected],@"Calculate");
 
 }
 
 -(void)testEvaluate_DivisionByZero {
 [gfs setValueOf:@"x" value:(double)3];
 int a[20]={3,6,8,8,10,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
 int b[20]={9,9,9,9,9,9,10,10,10,10,10,10,10,10,10,10,10,10,10,10};
 
 Calculation *c=[[Calculation alloc]initWithArray:a andRepairing:b];
 
 NSString *calculated=[NSString stringWithFormat:@"%.11f", [gfs evaluateRepairing:c]];
 NSString *repr=[[[GFSrein alloc]initWithArray:a andGFS:gfs repairing:b] name];
 
 STAssertTrue([@"(cos(3)/3)" isEqualToString:repr],@"Calculate");
 
 // google: cos ( 3 radians ) / 3 =
 // -0.32999749886
 
 STAssertTrue([@"-0.32999749887" isEqualToString:calculated],@"Calculate");
 
 
 }

 
 */

@import Cocoa;

#import "Coevolution.h"

int main(int argc, const char * argv[]) {
    
    // ARC enabled  - input function, blocks & thread groups are created within main block
    @autoreleasepool { // this may cause problems in sen tests because there is one global pool
        
        Coevolution *coevolution=[[Coevolution alloc]
                                  
                                  initAndSeed:(unsigned int)time(NULL)];
        
        [coevolution analyze];
        
        [coevolution free];
        
         
    }
    return NSApplicationMain(argc, argv);
}
