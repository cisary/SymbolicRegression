//
//  MDME.m
//  MDME
//
//  Created by user on 10/28/13.
//  Copyright (c) 2013 Michal Cisarik. All rights reserved.
//

/*! \file MDME.mm
 
 \brief MDME (Migrating Differential Meta Evolution) is differential evolution applied as metaevolution for custom indexing or "repairing" array which is used to generate gt permutations / any transformation matrixes. Vectors itself are also evolved by DE. Metaevolution in the name of this technique (MDME) stands for another (meta) DE which evolves second array of the solution. This part of evolving individuals is crucial especially when solving symbolic regression or similar problems. In this case it is repairing indexes for creating subpermutations, but it may be any array paired somehow to the solution array. In short, algorithm manages and evolves in the duplex population, migrating of elite individuals is configurable by migration probability and migration rate. In the future I plan to configure every part of evolution dynamically so that it would be possible evolve configurations of metaevolution as well. Each evolution can be surely "rated" by fitness. Maybe it's the way to avoid manual parametrization of evolutionary algorithms at all. Proper parametrization is imho crucial part of many evolutionary algorithms in general and it would be great to let another DE/SOMA.. to configure whole coevolution and/or its parts.
 
 for evolutionary framework's parts (algorithms) solving problem there need to be protocol for input output and commands representation:
 
 key-value {@"":@ }-type structures hold information about type of algorithm and how many times should they be evaluated in the single population space.
 
*/

#import "MDME.h"

@implementation MDME  {
    
	// statistics:
	double* averageFitness;
	double* fitnesses;
    double* metaFitnesses;
	double* normalizedFitnessValues;
	double* runningTotal;
	double  totalFitness;
	double  bestFitness;
    
	// properties of differential evolution:
	int dimension;
	int numberGenerations;
	int numberVectors;
    int migrations;
    double probCrossover;
    double scalingFactor;
    double probMutation;
    double probMigration;
    
    // matrix arrays pointers for malloc
    int **repaired;
	double **vectors;
    double **repairing;
    
    // vector pointers for malloc:
    int *bestbuffer;
    int *repairingbuffer;
    
	double *Xu;
    double *Xl;
    double *trialVector;
    double *trialRepair;
    double *trial;
    
    // variables used across methods:
    float bestVectorFitness,metaBestFitness,direction,before,after,beforeFitness,beforeMeta;
    
    // if set to 0 evolve method evolve normally
    // else calculate repairing array for particular individual (metaevolution)
    int metaEvolutionIndividual;
    
    // indexes:
    int vector,metavector,i,j,imeta,a,metaBestIndex,generation,r1,r2,r3,k,kk,improvements,generationswithnochange,solutions,o,bestVectorIndex;
    
    // flags:
    BOOL best,bestMeta;
    
    // stringbuffers:
    NSMutableString *buffer;
    NSMutableString *mutableout;
    
    // random generator
    MersenneTwister *mt;
}

// properties:
@synthesize averageFitness,metaEvolutionIndividual,migratingVectors,migratingbuffer,bestbuffer,bestVectorFitness,repaired,bestFitness;

-(BOOL) mt19937b0_1{
    return ([mt randomDouble0To1Exclusive] > 0.5) ? YES : NO;
}

-(BOOL) mt19937b0_1prob:(double)prob{
    return ([mt randomDoubleFrom:0.0 to:1.0] < prob) ? YES : NO;
}

//! init Xu vector - upper bound accoring to number of cities
-(void)initXu{
    
    float upper;
        upper = 31;
    
    for ( vector = 0; vector < dimension; vector++ )
        Xu[vector] = upper;
}

//! init Xl vector as 1
-(void)initXl{
    for ( vector = 0; vector < dimension; vector++ )
        Xl[vector] = 1;
}

-(void)migrate:(int**)migrating{
    for (int v=0; v<migrations; v++)
        if ([self mt19937b0_1prob:probMigration])
            for (int w=0; w<dimension; w++)
                vectors[v][w]=(double)migrating[v][w];
    
}

//! generate random metaevolution (repairing) array 'repairing[][]'
-(void)randomRepairing{
    
    for ( vector = 0; vector < numberVectors; vector++ )
        for ( i = 0; i < dimension; i++ )
            repairing[vector][i] = [mt randomUInt32From:0 to:dimension];
}

-(void)randomVectors {
    
    for ( vector = 0; vector < numberVectors; vector++ )
        for ( i = 0; i < dimension; i++ )
            vectors[vector][i] = [mt randomUInt32From:0 to:dimension];
    
}

//! Initialize differential metaevolution instance
/*!
 \param vect Number of vectors to evolve
 \param numGenerations How many times will repairing metaevolution (5x) and vectors evolution evolution (5x) take place - one generation is 10 in total so 100 generations will be 1000 evalutations!
 \param scalingFactor Differential evolution parameter
 \param crossProb probability of crossver
 \param mutProb probability of mutation
 \param migProb probability of migration
 \param migrations number of vectors which are going to migrate
 \param seed number for random generator (needed because of parallelization)
 
 \return id of the newly created instance
 */
- (id) initWithVectors:(NSNumber*)vect generations:(NSNumber*)numGenerations scalingFactor:(NSNumber*)p_m crossProb:(NSNumber*)p_c mutProb:(NSNumber*) m_p migProb:(NSNumber*)m migrations:(NSNumber*)migrat  seed:(int)seed {
    
	if ( self = [super init] ) {
        
        mt=[[MersenneTwister alloc] initWithSeed:seed];
        
        dimension = 32;
        
        bestFitness = DBL_MAX;
        
        numberVectors = [vect intValue];
		numberGenerations = [numGenerations intValue];
        
        scalingFactor = [p_m doubleValue];
		probCrossover = [p_c doubleValue];
        probMutation = [m_p doubleValue];
        probMigration = [m doubleValue];
        migrations = [migrat intValue];
        
        bestVectorFitness = FLT_MAX;
        metaEvolutionIndividual = 0;
        
        // allocate all needed memory:
        repairingbuffer = (int *)malloc(sizeof(int) * dimension);
        bestbuffer= (int *)malloc(sizeof(int) * dimension);
        
        Xu = (double *)malloc(sizeof(double) * dimension);
        Xl = (double *)malloc(sizeof(double) * dimension);
        
        vectors = (double **) malloc(sizeof(double*) * numberVectors);
		vectors[0] = (double *) malloc(sizeof(double) * dimension * numberVectors);
        
        repairing = (double **) malloc(sizeof(double*) * numberVectors);
		repairing[0] = (double *) malloc(sizeof(double) * dimension * numberVectors);
        
        repaired = (int **) malloc(sizeof(int*) * numberVectors);
		repaired[0] = (int *) malloc(sizeof(int) * dimension * numberVectors);
        
        averageFitness = (double *) malloc(sizeof(double) * numberGenerations);
		normalizedFitnessValues = (double *) malloc(sizeof(double) * numberVectors);
		runningTotal = (double *) malloc(sizeof(double) * numberVectors);
        
        trialRepair = (double *) malloc(sizeof(double) * dimension);
        trialVector = (double *) malloc(sizeof(double) * dimension);
        
        for ( i = 0; i < numberVectors; i++ ) {
			if(i) {
                repairing[i] = repairing[i-1] + numberVectors;
                repaired[i] = repaired[i-1] + numberVectors;
                vectors[i] = vectors[i-1] + numberVectors;
			}
		}
        
        [self initXu];
        [self initXl];
        
        [self randomVectors];
        [self randomRepairing];
        
        for (i=0; i<numberVectors;i++)
            [self repair:i trial:NO mutate:NO];
        
        buffer = [[NSMutableString alloc]init];
        
	} return self;
}

-(void)initVectors:(int**)v count:(int)c {
    
    for ( vector = 0; vector < c; vector++ ) {
        for ( i = 0; i < dimension; i++ )
            vectors[vector][i] = v[vector][i];
        
        [self repair:vector trial:NO mutate:NO];
    }
    
}

-(BOOL)_isinarray:(int*)array len:(int)length element:(int)element{
    
    if (a==0)
        return YES;
    
    BOOL is = NO;
    
    for (i=0; i<length; i++)
        if (array[i] == element) {
            is = YES;
            break;
        }
    return is;
}

//! Evolve by differential evolution
/*!
 changes vectors array or repairing array according to variable metaEvolutionIndividual
 */
-(void)metaEvolve {
    
    // find random r1,r2,r3 in [0,numberVectors) such that r1 != j !r2 != r3 :
    while (true) {
        r1=[mt randomUInt32From:0 to:dimension];
        if (r1!=j)
            break;
    }
    
    while (true) {
        r2=[mt randomUInt32From:0 to:dimension];
        if ((r2!=r1) && (r2!=j))
            break;
    }
    
    while (true) {
        r3=[mt randomUInt32From:0 to:dimension];
        if ((r3!=r2) && (r3!=r1) && (r3!=j))
            break;
    }
    
    if (metaEvolutionIndividual)
        trial = trialVector;
    else
        trial = trialRepair;
    
    for (k = 0; k < dimension; k++)
        trial[k] = repairing[r3][k] + scalingFactor * ((repairing[r1])[k]-(repairing[r2])[k]);
    
    // Crossover:
    int n = [mt randomUInt32From:0 to:dimension];
    int l = 0;
    
    while (true) {
        
        l += 1;
        if (([mt randomDouble0To1Exclusive] > probCrossover) || (l > dimension))
            break;
    }
    
    for (k = 0; k < dimension; k++) {
        for (kk = n; ((kk > n) && (kk < (n+l))); kk++) {
            
            if (k != (kk % dimension))
                trial[k]=repairing[metavector][k];
            else {
                for (k = 0; k < dimension; k++) {
                    for (kk = n; ((kk > n) && (kk < (n+l))); kk++) {
                        
                        if (k != (kk % dimension))
                            trial[k] = vectors[vector][k];
                    }
                }
            }
        }
    }
    
    // Boundaries check:
    for (k = 0; k < dimension; k++)
        while ((trial[k] < Xl[k]) || (trial[k] > Xu[k])) {
            if (trial[k] < Xl[k])
                trial[k] = 2 * Xl[k] - trial[k];
            if (trial[k] > Xu[k])
                trial[k] = 2 * Xu[k] - trial[k];
        }
    
}

/*! Generating valid permutations from chandom array
 
 Thanks to randomization of vector it is possible to escape local extreme!
 
 Here there are hard constrains implemented
 */
/*!
 \param v index to the repaired[][] array
 \param trial flag to repair repairingbuffer array instead of repaired[][] one
 \param mutate if YES is choosen direction of finding next free number is randomized by mersenne twister (probability 50/50)
 */
-(void)repair:(int) v trial:(BOOL)meta mutate:(BOOL)randomize{
    
    if (meta)
        repairingbuffer[0]=(int)vectors[v][0];
    else
        repaired[v][0]=(int)vectors[v][0];
    
    int repairindex=0;
    
    BOOL increasing;
    
    for (imeta = 1; imeta < dimension; imeta++) {
        
        if (meta)
            a = repairingbuffer[imeta];
        
        else
            a = (int)vectors[v][imeta];
        
        repaired[v][imeta] = 0;
        
        if ([self _isinarray:repaired[v] len:imeta element:a])
            a = (int)repairing[v][repairindex++];
        
        if (randomize)
            increasing = [self mt19937b0_1];
        else
            increasing = ((a % 2)==0)?YES:NO;
        
        while ([self _isinarray:repaired[v] len:imeta element:a]) {
            
            if (increasing)
                a += 1;
            else
                a -= 1;
            
            if (a > dimension)
                a = 0;
            
            else if (a <= 0)
                a = dimension;
            
        }
        
        repaired[v][imeta] = a;
        
        // We were repairing repairingbuffer so we have to write changes to the repairingbuffer array:
        if (meta)
            repairingbuffer[imeta] = repaired[v][imeta];
        //else
        vectors[v][imeta] = (double)repaired[v][imeta];
    }
}

//! Evolve vectors and metaevolve its repairing individuals
//!
-(void)evolve {
    
    // set initial values:
    beforeFitness = FLT_MAX;
    
    beforeMeta = 0;
    solutions = 0;
    
    // we have to evolve each vector by [self evolve] * METAEVOLUTION times to get "improved" or evolved repairing mask for vector evaluation. After each metaevolution best 'mask' is saved to 'repaired' array:
    for ( vector = 0; vector < numberVectors; vector++ ) {
        
        // turn off metavolution (we need to compute 'beforeMeta' variable):
        generationswithnochange = 0;
        
        // but vector have to be repaired first:
        [self repair:vector trial:NO mutate:NO];
        
        // than evaluated according problem solved:
        /*if (problem == TSP)
            beforeMeta = tsp->TourCost(&repaired[vector][0]);
        
        else if (problem == FSS)
            beforeMeta = fss->Makespan(&repaired[vector][0]);
        */
        
        beforeMeta = 1;//TODO01
        
        // reset current metaevolution best fitness value for maximum finding:
        metaBestFitness = beforeMeta;
        
        // set metaevolution for repairing particular vector:
        metaEvolutionIndividual = vector;
        
        // reset improvements because now we are counting metaevolution improvements:
        improvements = 0;
        
        // run repairing for every metavector
        for ( metavector = 0; metavector < numberVectors; metavector++ ) {
            
            // repair vector without mutation
            [self repair:vector trial:NO mutate:NO];
            
            before = 1;//tsp->TourCost(&repaired[metavector][0]);
            
            // evolve repairing vectors:
            [self metaEvolve];
            
            // copy current repairing to the global repairing array:
            for (imeta = 0; imeta < dimension; imeta++)
                repairing[vector][imeta] = trialRepair[imeta];
            
            // repair:
            [self repair:metavector trial:NO mutate:NO];
            
            // evaluate objective function:
            after = 2;// TODO03 tsp->TourCost(&repaired[metavector][0]);
            
            // selection:
            if (after < before) {
                
                // increment improvements counter:
                improvements += 1;
                
                // if new best repairing vector was found:
                //if (after < ) {
                if (after < metaBestFitness) {
                    
                    for (imeta = 0; imeta < dimension; imeta++)
                        vectors[metavector][imeta] = repaired[metavector][imeta];
                    
                    // and set new maximum value:
                    metaBestFitness = after;
                }
            }
        }
        
        improvements = 0;
        solutions = 0;
        
        metaEvolutionIndividual = 0;
        
        // run repairing for every metavector
        for ( metavector = 0; metavector < numberVectors; metavector++ ) {
            
            // set repairing buffer as current metavector:
            for (imeta = 0; imeta < dimension; imeta++)
                repairingbuffer[imeta]=vectors[metavector][imeta];
            
            // repair:
            [self repair:metavector trial:YES mutate:NO];
            
            before = 1;//TODO02tsp->TourCost(repairingbuffer);
            
            // evolve repairing vectors:
            [self metaEvolve];
            
            // copy current repairing to the global repairing array:
            for (imeta = 0; imeta < dimension; imeta++)
                repairingbuffer[imeta] = trialVector[imeta];
            
            // repair with randomization or without according to probMutation
            //if ([self mt19937b0_1prob: probMutation])
            //    [self repair:metavector trial:YES mutate:YES]; // mutate???
            //else
            [self repair:metavector trial:YES mutate:NO];
            
            // evaluate:
            after = 2;//TODO04tsp->TourCost(repairingbuffer);
            
            // selection:
            if (after < before) {
                
                // copy current repairing to the global repairing array:
                for (imeta = 0; imeta < dimension; imeta++)
                    vectors[metavector][imeta] = repairingbuffer[imeta];
                
                if (after < bestFitness) {
                    
                    bestFitness = after;
                    
                    // increment improvements counter:
                    improvements += 1;
                    
                    for (imeta = 0; imeta < dimension; imeta++) {
                        
                        bestbuffer[imeta] = repairingbuffer[imeta];
                        
                        repairingbuffer[imeta] = repairing[metavector][imeta];
                    }
                }
            }
        }
    }
}

//! "@" string representation method for the NSLog
/*!
 Prints repaired Xu.
 */
-(NSString *) description  {
    mutableout=[NSMutableString stringWithString:@""];
    buffer=[NSMutableString stringWithString:@""];
    
    for (int v = 0; v < dimension; v++)
        [buffer appendString:[NSString stringWithFormat:@"%i,",(int)bestbuffer[v]]];
    
    [mutableout appendString:[NSString stringWithFormat:@"%@\n\nFitness = %.0f\n",buffer,bestFitness]];
    
    return mutableout;
}

-(NSString *) allVectorsDescription  {
    mutableout=[NSMutableString stringWithFormat:@""];
    int v,x;
    for (v = 0; v < numberVectors; v++) {
        buffer=[NSMutableString stringWithFormat:@""];
        
        for (x = 0; x < dimension; x++)
            [buffer appendString:[NSString stringWithFormat:@"%.0f,",vectors[v][x]]];
        
        [mutableout appendString:[NSString stringWithFormat:@"v[%i] = %@\n",v,buffer]];
        
        buffer=[NSMutableString stringWithFormat:@""];
        
        for (x = 0; x < dimension; x++)
            [buffer appendString:[NSString stringWithFormat:@"%.0f,",repairing[v][x]]];
        
        [mutableout appendString:[NSString stringWithFormat:@"repairing[%i] = %@\n",v,buffer]];
        
        buffer=[NSMutableString stringWithFormat:@""];
        
        for (x = 0; x < dimension; x++)
            [buffer appendString:[NSString stringWithFormat:@"%i,",repaired[v][x]]];
        
        [mutableout appendString:[NSString stringWithFormat:@"repaired[%i] = %@\n\n",v,buffer]];
    }
    return mutableout;
}

//! "Post-ARC" alternative to dealoc - has to be called manually
/*!
 Clears the memory - all arrays allocated with malloc are free-d from memory.
 */
- (void) free {
    free(bestbuffer);
	free(Xu);
	free(Xl);
    free(repairingbuffer);
    free(vectors[0]);
    free(vectors);
    free(repaired[0]);
    free(repaired);
    free(repairing[0]);
    free(repairing);
    free(trialRepair);
    free(trialVector);
	free(averageFitness);
	free(fitnesses);
    free(metaFitnesses);
	free(normalizedFitnessValues);
	free(runningTotal);
}

@end
