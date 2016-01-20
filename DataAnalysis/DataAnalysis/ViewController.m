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

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSMutableArray *data = [[NSMutableArray alloc]init];
    NSMutableArray *label = [[NSMutableArray alloc]init];
    
    loadData(data, label);
    NSLog(@"%lu",(unsigned long)data.count);
    int rows = (int)data.count/3;
    NSArray *weights = storGradAscent(data, rows, 3, label, 300);
    
    float w0 = [weights[0] floatValue];
    float w1 = [weights[1] floatValue];
    float w2 = [weights[2] floatValue];
    
    float X1 = 3.0;
    float X2 = 4.0;
    
    float probability = sigmoid(w0 + w1*X1 + w2*X2);
    NSLog(@"%f",probability);
    
    
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
    [[DAClustering sharedInstance] clusteringData:data1];
}

@end
