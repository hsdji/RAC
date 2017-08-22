//
//  longInModel.m
//  RAC
//
//  Created by ekhome on 17/8/17.
//  Copyright © 2017年 luzhe. All rights reserved.
//

#import "longInModel.h"
#import "AFNetWorkUtils.h"

@interface longInModel ()

//执行获取数据的Command
@property(nonatomic, strong) RACCommand *sourceCommand;
//获取的数据
@property(nonatomic, strong) NSMutableArray *sourceArray;
//当前页
@property(nonatomic, assign) int currentPage;
//加载的是否是缓存
@property(nonatomic, assign) BOOL loadFromDB;

@property(nonatomic, assign) BOOL isLoading;
//是否是下拉加载更多(为了通用性，参数多了点)
@property(nonatomic, assign) BOOL isLoadMore;
//表名
@property(nonatomic, strong) NSString *tableName;
//模型
@property(nonatomic, assign) Class modelClass;
//接口地址
@property(strong, nonatomic) NSString *url;
//最终数据对应的key
@property(strong, nonatomic) NSString *modelArgument;

@property(assign,nonatomic) CGFloat lastOffsetY;

@end


@implementation longInModel
- (instancetype)init {
    self = [super init];
    if (self) {
        [self setUp];
    }
    return self;
}


-(void)setUp{
//    登录按钮的点击要用到
    self.sourceCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * (RACTuple *turple) {
        
        NSLog(@"%@",turple);
        return [self successSignal];
    }];
    
    
    
    
}











- (RACSignal *)successSignal{
    
    RACSignal *signal = [[self getObjectArraySignal:1]map:^id(NSMutableArray *array) {
        NSLog(@"%@",array);
        return nil;
    }];
    
   

    return signal;
    
   
}




/**
 *  转成模型
 */
- (RACSignal *)getObjectArraySignal:(int)page {
    NSString *ur = @"http://account.ledaochuxing.com/zdcx-account/app/login/personLogin";
    @weakify(self)

    return [[[[[[AFNetWorkUtils racPOSTWthURL:ur params:@{@"phone":@"18339923065",@"password":@"dfqerfqerfqwf",@"deviceTypeValue":@1}]filter:^BOOL(NSDictionary *result) {
        return [result isKindOfClass:[NSDictionary class]] && result;//保证结果不为空
    }]map:^id (NSDictionary *result) {
         return [result objectForKey:self.modelArgument];//获取字典数组
    }]filter:^BOOL(NSMutableArray *dicArray) {
         NSLog(@"%@",dicArray);
        return [dicArray isKindOfClass:[NSArray class]] && dicArray.count;//保证数组不为空
    }]map:^id(NSMutableArray *dicArray) {
        @strongify(self)
         NSLog(@"%@",dicArray);
        return self.modelClass;//字典转模型
    }]doError:^(NSError * _Nonnull error) {
        @strongify(self)
         NSLog(@"%@",error);
        if (self.isLoadMore) {
            self.currentPage--;
        }
    }];
    
}



@end
