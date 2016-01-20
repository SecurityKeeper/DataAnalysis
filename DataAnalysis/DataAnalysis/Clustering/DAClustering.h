//
//  DAClustering.h
//  DataAnalysis
//
//  Created by Jiao Liu on 1/19/16.
//  Copyright (c) 2016 SecurityKeeper. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DAClustering : NSObject
{
    @private
    float averageDistance;
    float minDistance;
}

/*
 Instance Methods
 */
+ (id)sharedInstance;
+ (void)destroyInstance;

/*
 Using K-Mean to clustering the data set
 Data struct:
 input = @[@{x:1.0, y:1.2, z:3.2 ...},
 @{x:1.0, y:1.2, z:3.2 ...},
 @{x:1.0, y:1.2, z:3.2 ...},
 ...
 @{x:1.0, y:1.2, z:3.2 ...},
 ]
 
 output = @[@{x:1.0, y:1.2, z:3.2 ... cluster:1},
 @{x:1.0, y:1.2, z:3.2 ... cluster:2},
 @{x:1.0, y:1.2, z:3.2 ... cluster:2},
 ...
 @{x:1.0, y:1.2, z:3.2 ... cluster:n},
 ]
 */
- (NSArray *)clusteringData:(NSArray *)data;
/*
 return the K-value(the number of the clusters)
 */
- (long)getTargetKValue:(NSArray *)data;

@end
