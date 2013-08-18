//
//  GA.m
//  SymbolicRegression
//
//  Created by Michal Cisarik on 8/18/13.
//  Copyright (c) 2013 Michal Cisarik. All rights reserved.
//

#import "GA.h"

@implementation GA
@synthesize averageFitness;
@synthesize bestFitness;
@synthesize numCorrectBitsInBestIndividual;
@synthesize fitnessFuction;

+ (id) newGAWithGenes:(NSInteger)numGenes popSize:(NSInteger)size generations:(NSInteger)numGenerations mutProb:(double)p_m crossProb:(double)p_c gfs:(GFS*)g {
    
	return [[GA alloc] initWithGenes:numGenes popSize:size generations:numGenerations mutProb:p_m crossProb:p_c gfs:g];
}

- (id) initWithGenes:(NSInteger)numGenes popSize:(NSInteger)size generations:(NSInteger)numGenerations mutProb:(double)p_m crossProb:(double)p_c gfs:(GFS*)g {
    
	if ( self = [super init] ) {
        
        gfs=g;
        dataset=[[DataSet alloc]init];
        input=[dataset inputvalues];
    
		populationSize = size;
		numberGenes = numGenes;
		numberGenerations = numGenerations;
		probMutation = p_m;
		probCrossover = p_c;
		
        // allocate all needed memory:
		population = (int**)malloc(sizeof(int*) * populationSize);
		population[0] = (int*)malloc(sizeof(int) * populationSize * numberGenes);
		offspring = (int**)malloc(sizeof(int*) * populationSize);
		offspring[0] = (int*)malloc(sizeof(int) * populationSize * numberGenes);
        repairing = (int**)malloc(sizeof(int*) * populationSize);
		repairing[0] = (int*)malloc(sizeof(int) * populationSize * numberGenes);
        averageFitness = (double*)malloc(sizeof(double)*numberGenerations);
		bestFitness = (double*)malloc(sizeof(double)*numberGenerations);
		numCorrectBitsInBestIndividual = (double*)malloc(sizeof(double)*numberGenerations);
		fitnessValues = (double*)malloc(sizeof(double)*populationSize);
		normalizedFitnessValues = (double*)malloc(sizeof(double)*populationSize);
		runningTotal = (double*)malloc(sizeof(double)*populationSize);
        arraybuffer = (int*)malloc(sizeof(int) * numGenes * 2);
        repairsbuffer = (int*)malloc(sizeof(int) * numGenes * 2);
        
        for ( NSInteger i = 0; i < populationSize; i++ ) {
			if(i) {
				population[i] = population[i-1] + numberGenes;
				offspring[i] = offspring[i-1] + numberGenes;
                repairing[i] = repairing[i-1] + numberGenes;
			}
		}
    
		// seed the random number generator:
		srand((unsigned int)time(NULL));
        int terminal=0;
        int terminalsindex=[gfs terminalsStartingIndex];;
		for ( NSInteger organism = 0; organism < populationSize; organism++ ) {
			for ( NSInteger gene = 0; gene < numberGenes; gene++ ) {
                terminal=(rand() % ([[gfs elements]count]-terminalsindex));
                population[organism][gene] = rand() % [[gfs elements]count];
                repairing[organism][gene]=terminalsindex+terminal;
			}
		}
        
	} return self;
}

-(void)addGFSelement:(int*)element repairing:(int*)rep {
    [[gfs elements] addObject:[[GFSrein alloc]initWithArray:element andGFS:gfs repairing:rep]];
}

-(void)do:(EvolveCommand)command{
    int **pop;
    if (command == EvolvePopulation)
        pop = population;
    else if (command == EvolveRepairs)
        pop = repairing;
    
    [self calculateFitnessForPopulation];
    // To keep track of where we're placing the offspring (not just replacing the parents)
    NSInteger kid1 = 0;
    NSInteger kid2 = populationSize - 1;
    
    // populationSize/2  b/c we pick 2 @ a time
    for ( NSInteger i = 0; i < populationSize/2; i++ ) {
        
        // If we need to stop
        //if ( self.isCancelled ) return;
        
        
        
        /* ---------------------------------------------
         Select two individuals to be parents
         
         Get two random numbers, and select parents by
         the range the number falls in from runningTotal
         
         Make sure don't let organism mate with itself...
         ---------------------------------------------- */
        
        // Get two random numbers between 0 and 1 ( 5 significant digits)
        double r1 = (rand() % 100000) * 0.00001;
        double r2 = (rand() % 100000) * 0.00001;
        
        // Find the parents
        NSInteger parent1 = 0;
        NSInteger parent2 = 0;
        while ( r1 > runningTotal[parent1] && parent1 < populationSize ) parent1++;
        while ( r2 > runningTotal[parent2] && parent2 < populationSize ) parent2++;
        
        // Make sure that we aren't mating with ourselves
        //			while ( parent2 == parent1 ) {
        //				r2 = (rand() % 100000) * 0.00001;
        //				parent2 = 0;	// Reset
        //				while ( r2 > runningTotal[parent2] && parent2 < populationSize) parent2++;
        //			}
        
        
        
        
        
        /* ----------------------------------------------
         Mate Parents & Get Offspring
         
         Generate rand # to determine if doing crossover
         If no crossover, just copy bit strings over.
         
         Otherwise, randomly select a point in the bit
         string and copy up to that point, then switch.
         
         ----------------------------------------------- */
        
        // Get a random # to determine whether crossover should be done [0,1] with 5 sig digits
        double r = (rand() % 100000) * 0.00001;
        
        // If doing crossover
        if ( r <= probCrossover ) {
            
            // Randomly select a bit to be crossover point
            NSInteger crossPoint = rand() % numberGenes;
            
            // Copy bits over to offspring until the crossover point
            for ( NSInteger gene = 0; gene < crossPoint; gene++ ) {
                offspring[kid1][gene] = pop[parent1][gene];
                offspring[kid2][gene] = pop[parent2][gene];
            }
            
            // Now reverse, bits from parent1 go to offspring[parent2], vice versa
            for ( NSInteger gene = crossPoint; gene < numberGenes; gene++ ) {
                offspring[kid1][gene] = pop[parent2][gene];
                offspring[kid2][gene] = pop[parent1][gene];
            }
        }
        
        // If not doing crossover, just copy over the bit strings from the parents into the offspring (not \0 terminated, so have to do bit by bit)
        else {
            for ( NSInteger gene = 0; gene < numberGenes; gene++ ) {
                offspring[kid1][gene] = pop[parent1][gene];
                offspring[kid2][gene] = pop[parent2][gene];
            }
        }
        
        
        // Now perform mutations on offspring
        for ( NSInteger gene = 0; gene < numberGenes; gene++ ) {
            
            // 2 Random #'s to determine if mutation will be done this bit in the offspring
            double k1 = (rand() % 100000) * 0.00001;
            double k2 = (rand() % 100000) * 0.00001;
            
            
            
            if ( k1 <= probMutation ) offspring[kid1][gene] = offspring[kid1][gene] == rand() % [[gfs elements]count];
            if ( k2 <= probMutation ) offspring[kid2][gene] = offspring[kid2][gene] == rand() % [[gfs elements]count];
        }
        
        // Now update the kid 'pointers'
        // kid1 works from bottom towards the middle, while kid2 works from top down, similar to how stack and heap work together
        kid1++;
        kid2--;
    }
    
    
    // Update the population (merge offspring back in)
    for ( NSInteger i = 0; i < populationSize; i++ ) {
        for ( NSInteger j = 0; j < numberGenes; j++ ) {
            pop[i][j] = offspring[i][j];
        }
    }
}

-(void) generate {
	for ( NSInteger generation = 0; generation < numberGenerations; generation++ ) {
        NSLog(@"%ld. generation:\r %@",(long)generation,self);
        @try {
            [self do:EvolvePopulation];
        }
        @catch (NotEnoughTerminalsInRepairingArray *exception) {
            NSLog(@"NotEnoughTerminalsInRepairingArray: %@",exception);
        }
        @catch (UnexpectedBehavior *exception) {
            NSLog(@"UnexpectedBehavior: %@",exception);
        }
    }
}

-(NSString *) description  {
    NSMutableString *out=[[NSMutableString alloc]init];
    NSMutableString *indiv=[[NSMutableString alloc]init];
    
    for ( int cell = 0; cell < populationSize; cell++ ) {
        [indiv setString:@"[" ];
        for ( NSInteger gene = 0; gene < numberGenes; gene++ ) {
            [indiv appendString:[[NSString alloc]initWithFormat:@"%d,",population[cell][gene]]];
        }
        [indiv appendString:@"]\r["];
        for (int i=0;i<19;i++){
            arraybuffer[i]=population[cell][i];
            repairsbuffer[i]=repairing[cell][i];
            [indiv appendString:[[NSString alloc]initWithFormat:@"%d,",repairing[cell][i]]];
            int i=0;
        }
        
        [out appendString:[NSString stringWithFormat:@"%@\r",[indiv description]]];
        
        Calculation *d=[[Calculation alloc]initWithArray:arraybuffer andRepairing:repairsbuffer];
        Calculation *e=[[Calculation alloc]initWithArray:arraybuffer andRepairing:repairsbuffer];
        
        for(id x in input) {
            [gfs setValueOf:@"x" value:(double)[x doubleValue]];
            gfs.showXnoValue = NO;
            [out appendString:[NSString stringWithFormat:@"%@ = %g\r\r",
                               [gfs toStringRepairing:d],
                               [gfs evaluateRepairing:e]]];
            [d nullCalculation];
            [e nullCalculation];
            break;
        }
        
        [indiv appendString:@"] =>"];
        for ( NSInteger gene = 0; gene < numberGenes; gene++ ) {
            [indiv appendString:[[NSString alloc]initWithFormat:@"%d,",population[cell][gene]]];
        }
        [indiv appendString:@"]\r"];
    }
    return out;
}

/*! Calculates the fitness for the population
 */
- (void) calculateFitnessForPopulation {
	totalFitness = 0.0;
    Calculation *c=[[Calculation alloc]initWithArray:arraybuffer andRepairing:repairsbuffer];
    
    double fitness=0;
    double dx=0;
    int i;
	id x;
	for ( NSInteger cell = 0; cell < populationSize; cell++ ) {
        
        // refresh variables to initial values and copy current cell's arrays to buffer to calculate with right data
        fitness=0;
        dx=0;
		for (i=0;i<19;i++){
            arraybuffer[i]=population[cell][i];
            repairsbuffer[i]=repairing[cell][i];
        }

        for(x in input) {
            [c nullCalculation];
            [gfs setValueOf:@"x" value:(double)[x doubleValue]];
            dx=[gfs evaluateRepairing:c];
            fitness+=(double)ABS([[input objectForKey:x]doubleValue] - dx);
        }
        
        // compute individual's fitness value (average):
        fitness = fitness/[input count];
        
        Calculation *d=[[Calculation alloc]initWithArray:arraybuffer andRepairing:repairsbuffer];
        gfs.showXnoValue = YES;
        for(id x in input) {
            NSLog(@"%@",[NSString stringWithFormat:@"%@ : fitness=%g\r",
                               [gfs toStringRepairing:d],fitness]);
            [d nullCalculation];
            break;
        }
        
		totalFitness += fitness;	// add to summation
		fitnessValues[cell] = fitness;	// set in array
	}
    
	// normalize the fitness values:
	for ( NSInteger cell = 0; cell < populationSize; cell++ ) {
		normalizedFitnessValues[cell] = fitnessValues[cell] / totalFitness;
		if ( cell ) runningTotal[cell] = runningTotal[cell-1] + normalizedFitnessValues[cell];
		else runningTotal[0] = normalizedFitnessValues[0];
	}
}

/*! dealoc every bit string pointer for future reuse
 */
- (void) free {
#ifdef DEBUG
    NSLog(@"Freeing all allocated arrays from memory");
#endif
	free(population[0]);
	free(population);
	free(offspring);
	free(averageFitness);
	free(bestFitness);
	free(numCorrectBitsInBestIndividual);
	free(fitnessValues);
	free(normalizedFitnessValues);
	free(runningTotal);
}

@end
