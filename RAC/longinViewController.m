//
//  longinViewController.m
//  RAC
//
//  Created by ekhome on 17/8/17.
//  Copyright © 2017年 luzhe. All rights reserved.
//

#import "longinViewController.h"
#import "longInview.h"
#import "longInModel.h"
@interface longinViewController ()
@property (nonatomic,strong)RACTuple *tuple;
@property (nonatomic,strong)longInModel *model;
@end

@implementation longinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    longInview *v = [[longInview alloc] init];
    [self.view addSubview:v];
    self.tuple = [RACTuple tupleWithObjects:@(2),self,v ,nil];
    self.model = [longInModel new];
    //数据源信号
    
     [[self.model.sourceCommand execute:self.tuple] subscribeNext:^(id  _Nullable x) {
         NSLog(@"%@",x);
     }];
  
    

    
    
    
    
}




@end
