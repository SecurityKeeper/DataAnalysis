//
//  DAAverageCalculate.m
//  DataAnalysis
//
//  Created by 郑红 on 3/30/16.
//  Copyright © 2016 SecurityKeeper. All rights reserved.
//

#import "DAAverageCalculate.h"

static double const defaultStandard = 0.95;//1.96
static long double const pai = M_PI;
static long double const e = M_E;
@interface DAAverageCalculate ()

@property (nonatomic,copy) NSArray * number;

@end

@implementation DAAverageCalculate

+ (DAAverageCalculate *)defaultInstance {
    static dispatch_once_t token;
    static DAAverageCalculate * averageCal;
    dispatch_once(&token, ^{
        averageCal = [[DAAverageCalculate alloc] init];
    });
    return averageCal;
}

//概率
- (long double)probabilityCalculate:(NSArray *)array
                           newValue:(long double)newValue {
    long double paiValue = sqrtl(2*pai);
    long double aveValue = [self aveValue:array newValue:newValue];
    long double variance = [self varianceAveValue:aveValue valueArr:array newValue:newValue];
    long double standardDeviation = sqrtl(variance);
    long double head = 1/paiValue*standardDeviation;
    
    long double pingfang = 0 - powl(newValue - aveValue, 2);
    long double mi = pingfang / 2* standardDeviation * standardDeviation;
    
    return head * powl(e, mi);
}

//置信区间
- (long double)conValue:(double)aveValue variance :(long double)variacne {
    long double varianceTemp = sqrt(variacne);
    long double n = sqrt(aveValue);
    long double result = varianceTemp * 1.96/n;//95%
    
    return result;
}

//均值
- (long double)aveValue:(NSArray *)numberArr newValue:(double) newValue{
    long double total = 0;
    for (NSNumber * number in numberArr) {
        total += [number doubleValue];
    }
    if (newValue) {
        total += newValue;
    }
    return newValue?total/(numberArr.count+1):total/(numberArr.count);
}


//方差
- (long double)varianceAveValue:(long double)aveValue
                       valueArr:(NSArray *)numberArr
                       newValue:(double)newValue{
    long double total = 0;
    for (NSNumber * number in numberArr) {
        long double temp = [number doubleValue];
        total += pow((temp - aveValue), 2);
    }
    if (newValue) {
        total += pow((newValue - aveValue), 2);
    }
    
    
    return newValue?total/(numberArr.count +1):total/numberArr.count;
}
@end