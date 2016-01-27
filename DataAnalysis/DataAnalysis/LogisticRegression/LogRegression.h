//
//  LogRegression.h
//  DataAnalysis
//
//  Created by dengjc on 16/1/15.
//  Copyright (c) 2016年 dengjc. All rights reserved.
//
#ifndef __DataAnalysis__LogRegression__
#define __DataAnalysis__LogRegression__

int loadData(NSMutableArray *data,NSMutableArray *labels);

float sigmoid(float x);

NSArray* storGradAscent(NSArray* arrIn,int rows,int cols,NSArray* labels,int numIter);

#endif /* defined(__DataAnalysis__LogRegression__) */