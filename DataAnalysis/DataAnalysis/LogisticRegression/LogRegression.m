//
//  LogRegression.m
//  DataAnalysis
//
//  Created by dengjc on 16/1/15.
//  Copyright (c) 2016年 dengjc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LogRegression.h"

NSArray *weights;
/*
    从文件加载数据至数组，testSet为训练数据集,返回特征数
 */
int loadData(NSMutableArray *data,NSMutableArray *labels) {
    NSString *path = [[NSBundle mainBundle]pathForResource:@"testSet" ofType:@"txt"];
    NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSMutableArray *lineArr = [NSMutableArray arrayWithArray:[content componentsSeparatedByString:@"\r\n"]];
    [lineArr removeLastObject];
    int cols = 0;
    for (NSString *line in lineArr) {
        NSArray *compArr = [line componentsSeparatedByString:@"\t"];
        cols = (int)compArr.count;
        
        [data addObject:@(1.0)];
        for (int i=0; i<compArr.count - 1; i++) {
            [data addObject:@([compArr[i] floatValue])];
        }
        [labels addObject:@([[compArr lastObject]floatValue])];
    }
    return cols;
}

NSArray *loadDataFromFile()
{
    NSMutableArray *data = [[NSMutableArray alloc]init];
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"testSet" ofType:@"txt"];
    NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSMutableArray *lineArr = [NSMutableArray arrayWithArray:[content componentsSeparatedByString:@"\r\n"]];
    [lineArr removeLastObject];
    for (NSString *line in lineArr) {
        NSArray *compArr = [line componentsSeparatedByString:@"\t"];
        NSMutableArray *tmp = [[NSMutableArray alloc]init];
//        [tmp addObject:@(1.0)];
        
        for (int i=0; i<compArr.count; i++) {
            [tmp addObject:@([compArr[i] floatValue])];
        }
        [data addObject:tmp];
    }
    return data;
}

//int setupData(NSArray *dataSet)

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

NSArray* gradientAscent(NSArray *arrIn,int numIter)
{
    int rows = arrIn.count;
    NSArray *row = [arrIn objectAtIndex:0];
    int cols = row.count;
    
    NSMutableArray *dataArr = [[NSMutableArray alloc]init];
    NSMutableArray *labels = [[NSMutableArray alloc]init];
    for (NSArray *arr in arrIn) {
        [dataArr addObject:@(1.0)];
        for (int i=0; i<arr.count-1; i++) {
            [dataArr addObject:@([[arr objectAtIndex:i]floatValue])];
        }
        [labels addObject:@([[arr lastObject]floatValue])];
    }
    return storGradAscent(dataArr, rows, cols, labels, numIter);
}

//likeliHood ratio test
float pi(float x,int k) {
    long fac = 1;
    for (int i=1; i<=k; i++) {
        fac  *= i;
    }
    return pow(x, k)*exp(-x)/fac;
}

bool likeliHoodRatioTest(NSArray *data,NSArray *label,NSArray *weights,int k) {
    int n = (int)label.count;
    int n0 = 0,n1 = 0;
    for (int i = 0; i<n; i++) {
        int tmp = [label[i]intValue];
        if (tmp == 0) {
            n0++;
        } else {
            n1++;
        }
    }
    float G = 0.0;
    for (int i=0; i<n; i++) {
        float sum = 0.0;
        for (int j=i*k,m=0; j<i*k+k; j++,m++) {
            sum += [data[j]floatValue]*[weights[m]floatValue];
        }
        float pvalue = sigmoid(sum);
        G += [label[i]floatValue]*log(pvalue) + (1-[label[i]floatValue])*log(1 - pvalue + 0.0001);
    }
    G = G - (n1*log(n1) + n0*log(n0) - n*log(n));
    G *= 2;
    NSLog(@"n0 = %d,n1 = %d,n = %d,G = %f",n0,n1,n,G);
    
    if (G > 5.991) {//X0.05(2) = 5.991
        return true;
    } else {
        return false;
    }
}

bool likelyHoodRatioCheck(NSArray *arrIn)
{
    NSArray *row = [arrIn objectAtIndex:0];
    int cols = row.count;
    NSMutableArray *dataArr = [[NSMutableArray alloc]init];
    NSMutableArray *labels = [[NSMutableArray alloc]init];
    for (NSArray *arr in arrIn) {
        [dataArr addObject:@(1.0)];
        for (int i=0; i<arr.count-1; i++) {
            [dataArr addObject:@([[arr objectAtIndex:i]floatValue])];
        }
        [labels addObject:@([[arr lastObject]floatValue])];
    }
    
    weights = gradientAscent(arrIn, 500);
    return likeliHoodRatioTest(dataArr, labels, weights, cols);
}

float checkData(NSArray* data) {
    if (data.count==0||(data.count != weights.count - 1)) {
        NSLog(@"参数个数错误");
        return 0;
    }
    float x = [[weights objectAtIndex:0]floatValue];
    for (int i=0; i<data.count; i++) {
        float w = [[weights objectAtIndex:i+1]floatValue];
        float d = [[data objectAtIndex:i]floatValue];
        x += w*d;
    }
    return sigmoid(x);
    
//    NSLog(@"---------------------------------------------");
//    NSMutableArray *dataIn = [[NSMutableArray alloc]init];
//    NSMutableArray *label = [[NSMutableArray alloc]init];
//    
//    int cols = loadData(dataIn, label);
//    NSLog(@"%lu",(unsigned long)data.count);
//    int rows = (int)data.count/cols;
//    NSArray *weights = storGradAscent(data, rows, cols, label, 500);
//    
//    //    for (id weight in weights) {
//    //        NSLog(@"%f",[weight floatValue]);
//    //    }
//    if (data.count==0||(data.count != weights.count - 1)) {
//        NSLog(@"参数个数错误");
//        return 0;
//    }
//    float G = likeliHoodRatioTest(dataIn, label,weights,cols);
//    if (G > 5.991) {//X0.05(2) = 5.991
//        NSLog(@"逻辑回归模型合理");
//        float x = [[weights objectAtIndex:0]floatValue];
//        for (int i=0; i<weights.count; i++) {
//            float w = [[weights objectAtIndex:i]floatValue];
//            float d = [[data objectAtIndex:i]floatValue];
//            x += w*d;
//        }
//        return sigmoid(x);
//    } else {
//        NSLog(@"逻辑回归模型不合理");
//        return 0;
//    }
    return 0;
}