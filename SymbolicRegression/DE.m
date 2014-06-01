/*! \file DE.mm
 \brief A TSP header file.
 */

#import "DE.h"

@implementation DE

// properties:
@synthesize averageFitness,bestFitnesses,metaEvolutionIndividual,migratingVectors,migratingbuffer,bestbuffer,bestVectorFitness,a_,b_,Xl_,Xu_,XlR_,XuR_;


//! Initialize differential evolution instance
/*!
 \param vect Number of vectors to evolve
 \param numGenerations How many times will repairing metaevolution (5x) and vectors evolution evolution (5x) take place - one generation is 10 in total so 100 generations will be 1000 evalutations!
 \param scalingFactor Differential evolution parameter
 \param crossProb probability of the crossver operator
 \param defaultProblem pointer to the enum
 
 \return id of newly created instance
 */
-(id) initWith64bits:(uint64) bits {
	if ( self = [super init] ) {
        gfs = [[GFS alloc]initWithFunctionSet:(uint64)bits];
        
        Xl_=0;
        Xu_=[gfs terminalsStartingIndex];
        XlR_=Xu_;
        XuR_=[gfs size];
        
        output=[[OUT alloc ]initWithConfiguration:[[Configuration all]copy] andGFS:gfs];
        
        dimension = 32;//[gfs size];
        
        numberVectors = [[[Configuration all] objectForKey:@"DE_vectors"]intValue];
		numberGenerations = [[[Configuration all] objectForKey:@"DE_generations"]intValue];
        
        scalingFactor = [[[Configuration all] objectForKey:@"DE_scalingFactor"]intValue];
		probCrossover = [[[Configuration all] objectForKey:@"DE_crossProb"]intValue];
        
        bestVectorFitness = FLT_MAX;
        metaEvolutionIndividual = 0;
        
        mersennetwister = [[MersenneTwister alloc] init];
        
        // allocate all needed memory:
        
        repairingbuffer = (int *)malloc(sizeof(int) * dimension);
        migratingbuffer = (int *)malloc(sizeof(int) * dimension);
        bestbuffer= (int *)malloc(sizeof(int) * dimension);
        
        //fitnesses = (double *)malloc(sizeof(double) * numberVectors);
        //metaFitnesses = (double *)malloc(sizeof(double) * numberVectors);
        
		Xu = (double *)malloc(sizeof(double) * dimension);
        Xl = (double *)malloc(sizeof(double) * dimension);
        
        XuR = (double *)malloc(sizeof(double) * dimension);
        XlR = (double *)malloc(sizeof(double) * dimension);
        
        for (j = 0; j < dimension; j++) {
            Xl[j]=Xl_;
            Xu[j]=Xu_;
            XlR[j]=XlR_;
            XuR[j]=XuR_;
        }
        
        
        a = (double **) malloc(sizeof(double*) * numberVectors);
		a[0] = (double *) malloc(sizeof(double) * dimension * numberVectors);
        a_ = (int **) malloc(sizeof(int*) * numberVectors);
		a_[0] = (int *) malloc(sizeof(int) * dimension * numberVectors);
        
        
        b = (double **) malloc(sizeof(double*) * numberVectors);
		b[0] = (double *) malloc(sizeof(double) * dimension * numberVectors);
        b_ = (int **) malloc(sizeof(int*) * numberVectors);
		b_[0] = (int *) malloc(sizeof(int) * dimension * numberVectors);
        
        
        averageFitness = (double *) malloc(sizeof(double) * numberGenerations);
		//bestFitnesses = (double *) malloc(sizeof(double) * numberGenerations);
		normalizedFitnessValues = (double *) malloc(sizeof(double) * numberVectors);
		runningTotal = (double *) malloc(sizeof(double) * numberVectors);
        
        trialA = (double *) malloc(sizeof(double) * dimension);
        trialB = (double *) malloc(sizeof(double) * dimension);
        
        bestFitness = FLT_MAX;
        
        for ( i = 0; i < numberVectors; i++ ) {
			if(i) {
                
                a[i] = a[i-1] + numberVectors;
                a_[i] = a_[i-1] + numberVectors;
                
                b[i] = b[i-1] + numberVectors;
                b_[i] = b_[i-1] + numberVectors;
                
			}
		}
        
        
        buffer = [[NSMutableString alloc]init];
        
	} return self;
}

//! Evolve by differential evolution
/*!
 changes vectors array or repairing array according to variable metaEvolutionIndividual
 */
-(void)evolveA {
    
    // MUTATION:
    
    // find random r1,r2,r3 in [0,numberVectors) such that r1 != j !r2 != r3 :
    while (true) {
        r1=[mersennetwister randomUInt32From:0 to:numberVectors-1];
        if (r1!=j)
            break;
    }
    
    while (true) {
        r2=[mersennetwister randomUInt32From:0 to:numberVectors-1];
        if ((r2!=r1) && (r2!=j))
            break;
    }
    
    while (true) {
        r3=[mersennetwister randomUInt32From:0 to:numberVectors-1];
        if ((r3!=r2) && (r3!=r1) && (r3!=j))
            break;
    }
    
    for (k = 0; k < dimension; k++)
            trialA[k] = (a[r3])[k] + scalingFactor * ((a[r1])[k]-(a[r2])[k]);
    
    
    // CROSSOVER:
    
    int n = ([mersennetwister randomDoubleFrom:0 to:1] * dimension);
    int l = 0;
    
    while (true) {
        
        l += 1;
        if (([mersennetwister randomDoubleFrom:0 to:1] > probCrossover)
            || (l > dimension))
            break;
    }
    
    for (k = 0; k < dimension; k++) {
        for (kk = n; ((kk > n) && (kk < (n+l))); kk++) {
            
            if (k != (kk % dimension))
                trialA[k]=a[vector][k];
            else {
                for (k = 0; k < dimension; k++)
                    for (kk = n; ((kk > n) && (kk < (n+l))); kk++)
                        
                        if (k != (kk % dimension))
                            trialA[k] = a[vector][k];
            }
        }
    }
}



-(void)evolveB {
    
    // MUTATION:
    
    // find random r1,r2,r3 in [0,numberVectors) such that r1 != j !r2 != r3 :
    while (true) {
        r1=[mersennetwister randomUInt32From:0 to:numberVectors-1];
        if (r1!=j)
            break;
    }
    
    while (true) {
        r2=[mersennetwister randomUInt32From:0 to:numberVectors-1];
        if ((r2!=r1) && (r2!=j))
            break;
    }
    
    while (true) {
        r3=[mersennetwister randomUInt32From:0 to:numberVectors-1];
        if ((r3!=r2) && (r3!=r1) && (r3!=j))
            break;
    }

    for (k = 0; k < dimension; k++)
        trialB[k] = b[r3][k] + scalingFactor * ((b[r1])[k]-(b[r2])[k]);

    
    // CROSSOVER:
    int n = ([mersennetwister randomDoubleFrom:0 to:1] * dimension);
    int l = 0;
    
    while (true) {
        l += 1;
        if (([mersennetwister randomDoubleFrom:0 to:1] > probCrossover)
            || (l > dimension))
            break;
    }
    
    for (k = 0; k < dimension; k++) {
        for (kk = n; ((kk > n) && (kk < (n+l))); kk++) {
            
            if (k != (kk % dimension))
                trialB[k]=b[metavector][k];
            else {
                for (k = 0; k < dimension; k++)
                    for (kk = n; ((kk > n) && (kk < (n+l))); kk++)
                        
                        if (k != (kk % dimension))
                            trialB[k] = b[metavector][k];
            }
        }
    }
    
    
}

-(void)repairA{
    for (k = 0; k < dimension; k++) {
        while ((trialA[k] < Xl[k]) || (trialA[k] > Xu[k])) {
            if (trialA[k] < Xl[k])
                trialA[k] = 2 * Xl[k] - trialA[k];
            if (trialA[k] > Xu[k])
                trialA[k] = 2 * Xu[k] - trialA[k];
        }
        a_[vector][k]=trialA[k];
    }
    
}
-(void)repairB{
    for (k = 0; k < dimension; k++) {
        while ((trialB[k] < XlR[k]) || (trialB[k] > XuR[k])) {
            if (trialB[k] < XlR[k])
                trialB[k] = (2*XlR[k])-trialB[k];
            if (trialB[k] > XuR[k])
                trialB[k] = (2*XuR[k])-trialB[k];
        }
        b_[metavector][k]=trialB[k];
    }
}


//! Evolve vectors and metaevolve its repairing individuals
//!
-(void)metaEvolve {
    
    //init
    for ( vector = 0; vector < numberVectors; vector++ )
        
        for (j = 0; j < dimension; j++) {
            
            a[vector][j]=[mersennetwister randomDoubleFrom:Xl[j] to:Xu[j]];
            b[vector][j]=[mersennetwister randomDoubleFrom:XlR[j] to:XuR[j]];
        }
    
    
    generationswithnochange=0;
    beforeFitness=FLT_MAX;
    
    // 1.) evolve whole population
    for ( vector = 0; vector < numberVectors; vector++ ) {
        [self evolveA];
        [self repairA];
        
        metavector=vector;
        
        [self evolveB];
        
        [self repairB];
        
    }
    
for (generation = 0; generation < numberGenerations; generation++){
        
    
    
        // 2.) repair
for ( vector = 0; vector < numberVectors; vector++ ) {

    [self evolveA];
    [self repairA];
    
    for (metaBestIndex = 0; metaBestIndex < 1; metaBestIndex++){
            
        for ( metavector = 0; metavector < numberVectors; metavector++ ) {
            beforeMeta=0;
            
            int ss=0;
            while (((beforeMeta==0)||(beforeMeta==-INFINITY)||(beforeMeta==INFINITY)||(beforeMeta==NAN)||(beforeMeta<0))&&(ss<5)) {
                
                [self evolveB];
                [self repairB];
                
                [gfs repairA:&a_[vector][0] withB:&b_[metavector][0]];
                
                beforeMeta=[gfs errorA:&a_[vector][0] withB:&b_[metavector][0]];
                
                if ([output insertFitness:beforeMeta string:[NSString stringWithFormat:@"%@",[gfs describeA:&a_[vector][0] withB:&b_[metavector][0]]]]) {
                    return ;
                }
                
                ss+=1;
                
                
            }
            
            
            
            }
        
        }
        
    }
    }
}
            /*
 //           for (imeta = 0; imeta < dimension; imeta++)
//                migratingbuffer[imeta] = b_[metavector][imeta];
//                improvements = 0;
//                
//                for ( vector = 0; vector < numberVectors; vector++ )
//                    for (j = 0; j < dimension; j++)
//                        b[vector][j]=[mersennetwister randomDoubleFrom:XlR[j] to:XuR[j]];
//
//                //
             
            for ( metavector = 0; metavector < numberVectors-1; metavector++ ) {
                //for (int m = 0; m < 3; m+=1) {
                
                    after=0;
                    while ((after==0)||(after==-INFINITY)||(after==INFINITY)||(after==NAN)||(after<0)) {
                        [self evolveB];
                        
                        [gfs repairA:a_[vector] withB:b_[metavector]];
                        after=[gfs errorA:&a_[vector][0] withB:&b_[metavector][0]];
                    }
                    [output insertFitness:after string:[NSString stringWithFormat:@"%@",[gfs describeA:&a_[vector][0] withB:&b_[metavector][0]]]];
                    
                    for (imeta = 0; imeta < dimension; imeta++)
                        migratingbuffer[imeta] = b_[metavector][imeta];
                    
                }
            
            for (imeta = 0; imeta < dimension; imeta++)
                b[vector][imeta] = (double)migratingbuffer[imeta];
        }
        NSLog(@"%i:%@",generation,[output bestDescription]);
        generationswithnochange += 1;
        
        if (bestVectorFitness < bestFitness) {
            beforeFitness = bestVectorFitness;
            generationswithnochange = 0;
        }
        
        if (generationswithnochange == 100){
           // [self resetMigrate];
            generation=0;
        }
        
        if ( bestVectorFitness < 0.01) {
            NSException *e = [NSException
                              exceptionWithName:@"newest extreme ever found!"
                              reason:@"if (bestVectorFitness < BESTFITNESSEVER)"
                              userInfo:nil];
            @throw e;
        }
        
    }
}*/

//! "@" representation method for the NSLog
/*!
 Prints repaired Xu.
 */
-(NSString *) description  {

    return [NSString stringWithFormat:@"%@",[output bestDescription]];
}

-(NSString *) allVectorsDescription  {
    
    
    mutableout=[NSMutableString stringWithFormat:@""];
    int v,x;
    for (v = 0; v < numberVectors; v++) {
        buffer=[NSMutableString stringWithFormat:@""];
        
        for (x = 0; x < dimension; x++)
            [buffer appendString:[NSString stringWithFormat:@"%.0f,",a[v][x]]];
        
        [mutableout appendString:[NSString stringWithFormat:@"a[%i] = %@\n",v,buffer]];
        
        buffer=[NSMutableString stringWithFormat:@""];
        
        for (x = 0; x < dimension; x++)
            [buffer appendString:[NSString stringWithFormat:@"%.0f,",b[v][x]]];
        
        [mutableout appendString:[NSString stringWithFormat:@"b[%i] = %@\n",v,buffer]];
        
        buffer=[NSMutableString stringWithFormat:@""];
        
        for (x = 0; x < dimension; x++)
            [buffer appendString:[NSString stringWithFormat:@"%i,",a_[v][x]]];
        
        [mutableout appendString:[NSString stringWithFormat:@"a[%i] = %@\n",v,buffer]];
    }
    return mutableout;
}



//! "Post-ARC" alternative to dealoc
/*!
 Clears the memory.
 */
- (void) free {
    free(bestbuffer);
	free(Xu);
    free(XuR);
	free(Xl);
    free(repairingbuffer);
    free(migratingbuffer);
    free(a[0]);
    free(a);
    free(a_[0]);
    free(a_);
    free(b[0]);
    free(b);
    free(b_[0]);
    free(b_);
	free(averageFitness);
	//free(bestFitnesses);
	free(fitnesses);
    free(metaFitnesses);
	free(normalizedFitnessValues);
	free(runningTotal);
    free(trialA);
    free(trialB);
}

@end
