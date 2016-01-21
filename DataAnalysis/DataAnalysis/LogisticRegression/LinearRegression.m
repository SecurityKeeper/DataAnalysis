//
//  LinearRegression.m
//  DataAnalysis
//
//  Created by weiguang on 16/1/20.
//  Copyright (c) 2016年 SecurityKeeper. All rights reserved.
//

#import "LinearRegression.h"
#include "math.h"
#include "stdlib.h"
#import "chlkFunction.h"

void regAnalysis(double *x,double *y,int m,int n,double *a,double *dt,double *v)
{
    int i,j,k,mm;
    double q,e,u,p,yy,s,r,pp,*b;
    b=malloc((m+1)*(m+1)*sizeof(double));
    mm=m+1;
    b[mm*mm-1]=n;
    for (j=0; j<=m-1; j++)
    {   p=0.0;
        for (i=0; i<=n-1; i++)
            p=p+x[j*n+i];
        b[m*mm+j]=p;
        b[j*mm+m]=p;
    }
    for (i=0; i<=m-1; i++)
        for (j=i; j<=m-1; j++)
        {   p=0.0;
            for (k=0; k<=n-1; k++)
                p=p+x[i*n+k]*x[j*n+k];
            b[j*mm+i]=p;
            b[i*mm+j]=p;
        }
    a[m]=0.0;
    for (i=0; i<=n-1; i++)
        a[m]=a[m]+y[i];
        for (i=0; i<=m-1; i++)
        {   a[i]=0.0;
            for (j=0; j<=n-1; j++)
                a[i]=a[i]+x[i*n+j]*y[j];
        }
    chlk(b,mm,1,a);
    yy=0.0;
    for (i=0; i<=n-1; i++)
        yy=yy+y[i]/n;        //计算y的均值
        q=0.0; e=0.0; u=0.0;
        for (i=0; i<=n-1; i++)
        {   p=a[m];
            for (j=0; j<=m-1; j++)
                p=p+a[j]*x[j*n+i];   //求出当前的y的测量值
            //剩余平方和或残差平方和
            q=q+(y[i]-p)*(y[i]-p);
            //回归平方和
            u=u+(p-yy)*(p-yy);
            //总离差平方和 e = u+q
            e=e+(y[i]-yy)*(y[i]-yy);
        }
    s=sqrt(q/n);     //平均标准偏差
    r=sqrt(1-q/e);   // 相关系数
    
    for (j=0; j<=m-1; j++)
    {   p=0.0;
        for (i=0; i<=n-1; i++)
        {
            pp=a[m];
            for (k=0; k<=m-1; k++)
                if (k!=j) pp=pp+a[k]*x[k*n+i];
            p=p+(y[i]-pp)*(y[i]-pp);
        }
        v[j]=sqrt(1.0-q/p);
    }
    dt[0]=q;    //剩余平方和
    dt[1]=s;    //平均标准偏差
    dt[2]=r;    //相关系数
    dt[3]=u;    //回归平方和
    dt[4]=e;    //总离差平方和
    free(b);
}

void setData(NSMutableArray *dataX,NSMutableArray *dataY) {
    float x1,x2,x3,y;
    NSString *path = [[NSBundle mainBundle]pathForResource:@"setData" ofType:@"txt"];
    FILE *file = fopen([path cStringUsingEncoding:NSASCIIStringEncoding], "r");
    while (!feof(file)) {
        fscanf(file, "%f %f %f %f", &x1, &x2, &x3,&y);
        [dataX addObject:@(x1)];
        [dataX addObject:@(x2)];
        [dataX addObject:@(x3)];
        [dataY addObject:@(y)];
    }
}
