//
//  ViewController.m
//  DataAnalysis
//
//  Created by dengjc on 16/1/14.
//  Copyright (c) 2016年 dengjc. All rights reserved.
//

#import "ViewController.h"
#import <Accelerate/Accelerate.h>
#import "LogRegression.h"
#import "DAClustering.h"
#import "LinearRegression.h"
#define N 3


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSLog(@"---------------------------------------------");
//    
    NSArray *data = loadDataFromFile();
//    NSArray *weights = gradientAscent(data, 500);
    bool G = likelyHoodRatioCheck(data);
    if (G) {
        NSLog(@"逻辑回归模型合理");
    } else {
        NSLog(@"逻辑回归模型不合理");
        return;
    }
    
//    int cols = loadData(data, label);
//    int rows = (int)data.count/cols;
//    NSArray *weights = storGradAscent(data, rows, cols, label, 500);
//
//    for (id weight in weights) {
//        NSLog(@"%f",[weight floatValue]);
//    }
//    
//    float G = likeliHoodRatioTest(data, label,weights,cols);
    
    NSArray *newData = @[@100,@2];
    float val = checkData(newData);
    NSLog(@"---------------------------------------------");
//    float w0 = [weights[0] floatValue];
//    float w1 = [weights[1] floatValue];
//    float w2 = [weights[2] floatValue];
//    
//    float X1 = 3.0;
//    float X2 = 4.0;
//    
//    float probability = sigmoid(w0 + w1*X1 + w2*X2);
//    NSLog(@"probability = %f",probability);
    
    NSArray *data1 = @[@{@"x":@"1.3",@"y":@"3.0"},
                       @{@"x":@"3.2",@"y":@"3.3"},
                       @{@"x":@"1.42",@"y":@"3.3"},
                       @{@"x":@"1.32",@"y":@"5.3"},
                       @{@"x":@"1.22",@"y":@"13.3"},
                       @{@"x":@"10.2",@"y":@"5.3"},
                       @{@"x":@"12.2",@"y":@"3.31"},
                       @{@"x":@"3.2",@"y":@"3.33"},
                       @{@"x":@"5.2",@"y":@"3.23"},
                       @{@"x":@"1.2",@"y":@"2.3"},
                       @{@"x":@"1.32",@"y":@"3.3"}];
    NSLog(@"%f",[[DAClustering sharedInstance] checkData:@{@"x":@"1.3",@"y":@"5.0"} set:data1]);

    printf("\n######## 下面是线性回归部分 ########\n");
    /*线性归回部分*/
    

}


@end
