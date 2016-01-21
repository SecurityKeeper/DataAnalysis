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


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSMutableArray *data = [[NSMutableArray alloc]init];
    NSMutableArray *label = [[NSMutableArray alloc]init];
    NSMutableArray *dataX = [[NSMutableArray alloc]init];
    NSMutableArray *dataY = [[NSMutableArray alloc]init];
    
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

    printf("\n######## 下面是线性回归部分 ########\n");
    /*线性归回部分*/
    int i,j,k=0;
    setData(dataX, dataY);
    int n = (int)dataY.count;
    int m = (int)dataX.count/dataY.count;
    double a[n-1],v[3],dt[5];
    double x[m][n];
    double y[n];
    
    //读取y数组的值
    for (i = 0; i<n; i++) {
        y[i] = [[dataY objectAtIndex:i] floatValue];
        // NSLog(@"%lf",y[i]);
    }
    //读取x数组的值
    for (j=0; j<n; j++)
        for (i=0; i<m; i++)
    {
        x[i][j] = [[dataX objectAtIndex:k] floatValue];
            k++;
       // NSLog(@"%lf",x[i][j]);
    }
    regAnalysis(x,y,m,n,a,dt,v);
    
    printf("\n函数系数:\n");
    for (i=0; i<=m; i++)
        printf("a(%2d)=%lf\n",i,a[i]);
    printf("\n");
    printf("剩余平方和：q=%lf  平均标准偏差：s=%lf 相关系数：r=%lf  \n",dt[0],dt[1],dt[2]);
    printf("\n");
    printf("回归平方和：u=%lf  总离差平方和：e=%lf\n",dt[3],dt[4]);
    printf("\n");
    for (i=0; i<=2; i++)
        printf("v(%2d)=%lf\n",i,v[i]);
    printf("\n");
    
    /*F检验 */
    double F = (dt[3]/m)/(dt[0]/(n-m-1));       //F ~ F(m,n-m-1) a = 0.05
    printf("F检验值：F=%lf",F);
    

}

@end
