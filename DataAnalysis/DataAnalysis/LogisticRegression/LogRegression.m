//
//  LogRegression.m
//  DataAnalysis
//
//  Created by dengjc on 16/1/15.
//  Copyright (c) 2016年 dengjc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LogRegression.h"

/*
    从文件加载数据至数组，testSet为训练数据集,返回文件列数（特征数）
 */
int loadData(NSMutableArray *data,NSMutableArray *labels) {
    NSString *path = [[NSBundle mainBundle]pathForResource:@"data" ofType:@"txt"];
    NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSMutableArray *lineArr = [NSMutableArray arrayWithArray:[content componentsSeparatedByString:@"\n"]];
    [lineArr removeLastObject];
    int cols = 0;
    for (NSString *line in lineArr) {
        NSArray *compArr = [line componentsSeparatedByString:@" "];
        cols = (int)compArr.count;
        
        [data addObject:@(1.0)];
        for (int i=0; i<compArr.count - 1; i++) {
            [data addObject:@([compArr[i] floatValue])];
        }
        [labels addObject:@([[compArr lastObject]floatValue])];
    }
    
//    FILE *file = fopen([path cStringUsingEncoding:NSASCIIStringEncoding], "r");
//    while (!feof(file)) {
//        fscanf(file, "%f %f %f ", &x1, &x2, &label);
//        [data addObject:@(1.0)];
//        [data addObject:@(x1)];
//        [data addObject:@(x2)];
//        [labels addObject:@(label)];
//    }
    return cols;
}

float sigmoid(float x) {
    return 1.0/(1.0 + exp(-x));
}

/*
     随机梯度上升算法：arrIn为特征矩阵，rows行cols列。
     classLabels为分类结果，用0，1表示
     numIter为迭代次数
     返回最佳参数
 */
NSArray* storGradAscent(NSArray* arrIn,int rows,int cols,NSArray* labels,int numIter) {
    NSMutableArray *weights = [[NSMutableArray alloc]init];
    for (int i=0; i<cols ;i++) {
        [weights addObject:@1.0];
    }
    for (int j = 0; j<numIter; j++) {
        NSMutableArray *dataIndex = [[NSMutableArray alloc]init];
        for (int i=0; i<rows; i++) {
            [dataIndex addObject:@(i)];
        }
        for (int i=0; i<rows; i++) {
            float alpha = 4.0/(1.0 + j + i) + 0.01;
            int randIndex = rand()%dataIndex.count;
            float sum = 0.0;
            for (int k=0; k<cols; k++) {
                sum += [[arrIn objectAtIndex:randIndex*cols + k] floatValue] * [[weights objectAtIndex:k]floatValue];
            }
            float h = sigmoid(sum);
            float error = [[labels objectAtIndex:randIndex]floatValue] - h;
            for (int q=0; q<cols; q++) {
                float tmp = [[weights objectAtIndex:q]floatValue];
                tmp += alpha * error * [[arrIn objectAtIndex:randIndex*cols + q] floatValue];
                weights[q] = @(tmp);
            }
            [dataIndex removeObjectAtIndex:randIndex];
        }
    }
    return weights;
}