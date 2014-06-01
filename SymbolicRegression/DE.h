/*!
 * \file DE.h
 * \brief DifferentialEvolution
 * \author Bc. Michal Cisarik
 * \date 8/18/13
 *
 * Copyright (c) 2013 Michal Cisarik. All rights reserved.
 */

#import "GFS.h"

///! DEEE
/*!
 \class DE
 \brief Differential Evolution
 */
@interface DE : NSObject {
    
	// statistics:
	double* averageFitness;
	double* bestFitnesses;
	double* fitnesses;
    double* metaFitnesses;
	double* normalizedFitnessValues;
	double* runningTotal;
    
	double totalFitness;
	double  bestFitness;
    
	// properties of differential evolution:
	int dimension;
	int numberGenerations;
	int numberVectors;
    
	double probCrossover;
    double scalingFactor;
    
    // matrix arrays pointers for malloc
	double **a;
    double **b;
    
    int **a_;
    int **b_;
    
    // vector pointers for malloc:
	double *Xu;
    double *Xl;
    double *XuR;
    double *XlR;
    double *trialA;
    double *trialB;
    
    int *bestbuffer;
    int *migratingbuffer;
    int *repairingbuffer;
    
    int bestVectorIndex;
    double bestVectorFitness,metaBestFitness,direction,before,after,beforeFitness,beforeMeta;
    
    // if set to 0 evolve method evolve normally
    // else calculate repairing array for particular individual (metaevolution)
    int metaEvolutionIndividual;
    
    NSMutableString *buffer;
    NSMutableString *mutableout;
    
    // helper variables:
    int vector,metavector,i,j,imeta,metaBestIndex,generation,r1,r2,r3,k,kk,improvements,generationswithnochange,solutions;
    BOOL best,bestMeta;
    
    // my custom objects:
    GFS *gfs;
    
    // random generator:
    MersenneTwister *mersennetwister;
    
    // output
    OUT *output;
}

///! A class constructor - factory:

//! Initializers:
/*!
 Constructs the DE class, and assigns the values.
 */
-(id) initWith64bits:(uint64) bits;

-(void) free;

-(void) metaEvolve;

//de
-(void) initA;
-(void) initB;
-(void) evolveA;
-(void) evolveB;
-(void) repairA;
-(void) repairB;
-(void) repair;

// text output:
-(NSString *) description;
-(NSString *) describe:(int)w;
// properites:

@property(readwrite) double Xl_;
@property(readwrite) double Xu_;
@property(readwrite) double XlR_;
@property(readwrite) double XuR_;
@property(readwrite) int metaEvolutionIndividual;
@property(readwrite) double* a;
@property(readwrite) double* b;
@property(readwrite) int** a_;
@property(readwrite) int** b_;
@property(readwrite) int** migratingVectors;
@property(readwrite) double bestVectorFitness;
@property(readwrite) int* migratingbuffer;
@property(readwrite) int* bestbuffer;
@property(readwrite) double* averageFitness;
@property(readwrite) double* bestFitnesses;
//TODO readonly ? ? 
@end