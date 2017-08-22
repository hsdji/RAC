//
//  RACViewController.m
//  RAC
//
//  Created by ekhome on 17/8/21.
//  Copyright © 2017年 luzhe. All rights reserved.
//

#import "RACViewController.h"
#import "ReactiveObjc.h"
@interface RACViewController ()
@property (nonatomic,strong)RACSignalBindBlock block;
@end

@implementation RACViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"RAC练习";
    self.view.backgroundColor = [UIColor grayColor];
    
    
        
    

}
//监听输入框的内容
- (void)demo1{
    UITextField *filed = [[UITextField alloc] initWithFrame:CGRectMake(20, 60, 80, 50)];
    filed.backgroundColor = [UIColor whiteColor];
    filed.placeholder = @"我这里是监听输入框输入的内容";
    [self.view addSubview:filed];
    [filed.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"%@",x);
    }];
}
//对输入框的输入内容进行条件判断
- (void)demo2{
    
    UITextField *filed = [[UITextField alloc] initWithFrame:CGRectMake(20, 60, 80, 50)];
    filed.backgroundColor = [UIColor whiteColor];
    filed.placeholder = @"我这里是监听输入框输入的内容";
    [self.view addSubview:filed];
    [[filed.rac_textSignal filter:^BOOL(NSString * _Nullable value) {
        NSLog(@"%@",value);
        return [value isEqualToString:@"12345678901"]&&value.length>=10;//只有这里判断为真才会走下一步
    }] subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"进来了");
    }];
    
}
@end
