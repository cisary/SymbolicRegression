//
//  GA.h
//  SymbolicRegression
//
//  Created by Michal Cisarik on 8/18/13.
//  Copyright (c) 2013 Michal Cisarik. All rights reserved.
//

#import "GFS.h"
#import "DataSet.h"

typedef enum {
    EvolvePopulation = 0,
    EvolveRepairs = 1,
    EvolveIntervals = 2
} EvolveCommand;

@interface GA : NSObject {
	
	// data we are collecting:
	double* averageFitness;
	double* bestFitness;
	double* numCorrectBitsInBestIndividual;
	
	// store these internally as well (for stats):
	double* fitnessValues;
	double* normalizedFitnessValues;
	double* runningTotal;
	double totalFitness;
	
	// properties of this genetic algorithm:
	NSInteger populationSize;
	NSInteger numberGenerations;
	NSInteger numberGenes;
	double probCrossover;
	double probMutation;
	NSInteger fitnessFuction;
    
    // my custom helper objects:
    GFS *gfs;
    DataSet *dataset;
    NSMutableDictionary *input;
    
    // bit strings:
	int **population;
	int **offspring;
    int **repairing;
    int *arraybuffer;
    int *repairsbuffer;
}

// initializers:
+ (id) newGAWithGenes:(NSInteger)numGenes popSize:(NSInteger)size generations:(NSInteger)numGenerations mutProb:(double)p_m crossProb:(double)p_c gfs:(GFS*)g;
- (id) initWithGenes:(NSInteger)numGenes popSize:(NSInteger)size generations:(NSInteger)numGenerations mutProb:(double)p_m crossProb:(double)p_c gfs:(GFS*)g;
-(void)addGFSelement:(int*)element repairing:(int*)rep;

// internal methods:
- (void) calculateFitnessForPopulation;
-(void)do:(EvolveCommand)command;
-(void)free;
-(void)generate;
-(NSString*)description;

// properites:
@property(readonly) double* averageFitness;
@property(readonly) double* bestFitness;
@property(readonly) double* numCorrectBitsInBestIndividual;
@property(readwrite) NSInteger fitnessFuction;
@end