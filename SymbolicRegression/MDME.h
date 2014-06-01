/*!
 * \file MDME.h
 * \brief MigratingDifferentialMetaEvolution, see MDME.m for more info.
 * \author Bc. Michal Cisarik
 * \date 8/18/13
 *
 * Copyright (c) 2013 Michal Cisarik. All rights reserved.
 */

#import "MersenneTwister.h"

// thread-safe C++ mersenne twister:
//!!! typedef std::mt19937_64 MT; so wrong, so wrong: Caused EXT_BAD_ACCESS randomly !!!

///! MDMEEE
/*!
 \class MDME
 \brief Differential Evolution
 */
@interface MDME : NSObject

///! A class constructor - factory:
/*!
 Constructs the MDME class, and assigns the values.
 */
//+ (id) newForProblem:(Problem)p seed:(int)seed;

//! Initializers:
/*!
 Constructs the MDME class, and assigns the values.
 */
- (id) initWithVectors:(NSNumber*) vect
           generations:(NSNumber*) numGenerations
         scalingFactor:(NSNumber*) p_m
             crossProb:(NSNumber*) p_c
               mutProb:(NSNumber*) m_p
               migProb:(NSNumber*) m
            migrations:(NSNumber*) migrat
                  seed:(int)seed;

-(void)initVectors:(int**)v count:(int)c;

-(BOOL) mt19937b0_1;
-(BOOL) mt19937b0_1prob;

-(void) initXu;
-(void) initXl;

// internal methods:
-(NSString*) description;
-(void) free;
-(void) seed;
-(void) evolve;
-(void) metaEvolve;
-(void) migrate: (int**)migrating;
-(void) randomVectors;
-(void) randomRepairing;
-(void) repair:(int) v trial:(BOOL)trial mutate:(BOOL)randomize;

-(NSString *) bestDescription;
-(NSString *) allVectorsDescription;

+(NSMutableArray *) createMigratingMetaEvolutionsWithVectors:(int)vect generations:(NSInteger)numGenerations scalingFactor:(double)p_m crossProb:(double)p_c;

+(NSMutableDictionary *) evolveMigratingMetaEvolutions:(NSMutableArray*)evolutions;

+(void)freeMigratingMetaEvolutions:(NSMutableArray*)evolutions;

// helper methods:
-(BOOL)_isinarray:(int*)array len:(int)length element:(int)element;

// properites:
@property(readwrite) double bestFitness;
@property(readwrite) int metaEvolutionIndividual;
@property(readonly) int** repaired;
@property(readwrite) int** migratingVectors;
@property(readonly) float bestVectorFitness;
@property(readonly) int* migratingbuffer;
@property(readonly) int* bestbuffer;
@property(readonly) double* averageFitness;
@property(readonly) double* bestFitnesses;

@end