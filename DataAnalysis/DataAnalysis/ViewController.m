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
    NSLog(@"%f",[[DAClustering sharedInstance] checkData:@{@"x":@"1.3",@"y":@"5.0"} set:data1]);

    printf("\n######## 下面是线性回归部分 ########\n");
    /*线性归回部分*/
    
    setData(dataX, dataY);
    int n = (int)dataY.count;
    int m = (int)dataX.count/dataY.count;
    double a[n-1],v[3],dt[5];
    double x[m][n];
    double b[n][m];
    double c[m][m];
    double d[m][m];
    double y[n];
    double t[m];
    
    //读取y数组的值
    for (int i = 0; i<n; i++) {
        y[i] = [[dataY objectAtIndex:i] floatValue];
        // NSLog(@"%lf",y[i]);
    }
    //读取x数组的值
    int k=0;
    for (int j=0; j<n; j++)
        for (int i=0; i<m; i++)
            
        {
            x[i][j] = [[dataX objectAtIndex:k] floatValue];
            k++;
            // NSLog(@"x[%d][%d] = %lf",i,j,x[i][j]);
        }
    
    //读取x的转置矩阵
    for(int i=0;i<m;i++)
        for(int j=0;j<n;j++)
        {
            b[j][i] = x[i][j];
        }
    
    //x与转置矩阵乘积
    double temp;
    for(int i = 0; i < n; i++){
        for(int j = 0; j < m; j++){
            temp = 0;
            for(k = 0; k < m; k++){
                temp += x[i][k] * b[k][j];
            }
            c[i][j] = temp;
        }
    }

    
    int isak = DinV(c,3);
    if (isak!=0) {
        for(int i=0;i<n;i++)   //输出结果
        {
            for(int j=0;j<n;j++)
                d[i][j] = c[i][j];
        }
    }

    for (int k1=0; k1<m; k1++) {
        //printf("*******%lf\n",c[k1][k1]);
    }
    
    regAnalysis((double *)x,y,m,n,a,dt,v);
    
    printf("\n函数系数:\n");
    for (int i=0; i<=m; i++)
        printf("a(%d)=%lf\n",i,a[i]);
    printf("\n");
    printf("剩余平方和：q=%lf  平均标准偏差：s=%lf 可决系数：r=%lf  \n",dt[0],dt[1],dt[2]);
    printf("\n");
    printf("回归平方和：u=%lf  总离差平方和：e=%lf\n",dt[3],dt[4]);
    printf("\n");
//    for (i=0; i<=2; i++)
//        printf("v(%2d)=%lf\n",i,v[i]);
//    printf("\n");
    
    /* F检验 */
    double F = (dt[3]/m)/(dt[0]/(n-m-1));       //F ~ F(m,n-m-1)= 5.409 a = 0.05
    printf("m=%d ,n = %d\n",m,n);
    printf("F检验值：F=%lf\n",F);
    if (F > 5.409) {
        printf("所建模型线性关系在0.95的水平下显著成立\n");
    }else{
    
        printf("所建模型关系不显著\n");
    }
    
    /* t检验 */
//    double VarError = dt[0]/(n-m-1);     //随机误差项的方差  t ~ t(n-m-1) = 2.571 a = 0.05
//    for (int i=0; i<m; i++)
//    {
//        t[i] = a[i]/(sqrt(c[i][i] * VarError));
//        printf("t(%d) = %f\n",i,t[i]);
//    }
}


@end
