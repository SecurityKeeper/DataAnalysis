//
//  DAClustering.h
//  DataAnalysis
//
//  Created by Jiao Liu on 1/19/16.
//  Copyright (c) 2016 SecurityKeeper. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    kClusteringType_Plain,
    kClusteringType_Grouped,
} kClusteringType;

@interface DAClustering : NSObject
{
@private
    float averageDistance;
    float minDistance;
    long maxSeedTime;
}

/**
 Instance Methods
 */
+ (id)sharedInstance;
+ (void)destroyInstance;

/**
 @abstract Using K-Mean to clustering the data set
 @param Data struct:
 input = @[@{x:1.0, y:1.2, z:3.2 ...},
 @{x:1.0, y:1.2, z:3.2 ...},
 @{x:1.0, y:1.2, z:3.2 ...},
 ...
 @{x:1.0, y:1.2, z:3.2 ...},
 ]
 @return the clustered data set.
 PlainType:
 output = @[@{x:1.0, y:1.2, z:3.2 ... cluster:1},
 @{x:1.0, y:1.2, z:3.2 ... cluster:2},
 @{x:1.0, y:1.2, z:3.2 ... cluster:2},
 ...
 @{x:1.0, y:1.2, z:3.2 ... cluster:n},
 ]
 GroupedType:
 output = @[@[@{x:1.0, y:1.2, z:3.2 ... }],
 @[@{x:1.0, y:1.2, z:3.2 ... },
 @{x:1.0, y:1.2, z:3.2 ... }],
 ...
 @[@{x:1.0, y:1.2, z:3.2 ... }},
 ]
 */
- (NSArray *)clusteringData:(NSArray *)data type:(kClusteringType)type;
<<<<<<< Updated upstream

/**
 @abstract calculate the K-value
 @param the data set
 @return the K-value(the number of the clusters)
=======
/**
 return the K-value(the number of the clusters)
>>>>>>> Stashed changes
 */
- (long)getTargetKValue:(NSArray *)data;

/**
 @abstract Check the new data by original data set
 @param data:the new data with struct @{x:1.0, y:1.2, z:3.2 ...}
 dataSet:the original data set with struct
 @[@{x:1.0, y:1.2, z:3.2 ...},
 @{x:1.0, y:1.2, z:3.2 ...},
 @{x:1.0, y:1.2, z:3.2 ...},
 ...
 @{x:1.0, y:1.2, z:3.2 ...},
 ]
 @return the weight of the new data
 */
- (float)checkData:(NSDictionary *)data set:(NSArray *)dataSet;

@end
