//
//  fistViewModel.m
//  RAC
//
//  Created by ekhome on 17/8/21.
//  Copyright © 2017年 luzhe. All rights reserved.
//

#import "fistViewModel.h"
#import "fisModel.h"
@interface fistViewModel ()
@property(nonatomic, assign) BOOL isLoading;
//获取的数据
@property(nonatomic, strong) NSMutableArray *sourceArray;
//当前页
@property(nonatomic, assign) int currentPage;
//是否是下拉加载更多(为了通用性，参数多了点)
@property(nonatomic, assign) BOOL isLoadMore;
//模型
@property(nonatomic, assign) Class modelClass;
//@property(nonatomic, strong) RACCommand *sourceCommand;
@end


@implementation fistViewModel
- (instancetype)init {
    self = [super init];
    if (self) {
        _currentPage = 1;
        self.sourceArray = [NSMutableArray new];
        [self setUp];
    }
    return self;
}

-(void)setUp{
    @weakify(self)
    self.sourceCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * (RACTuple *turple) {
        @strongify(self)
        return [self getdata:[turple.first boolValue]];
    }];
    RAC(self, isLoading)=self.sourceCommand.executing;
}



-(void)loadData
{
    self.currentPage +=1;
    RACTuple *newTurple = RACTuplePack(@(NO));
    [self.sourceCommand execute:newTurple];
   
}




-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (!self.isLoading) {
        [self loadData];
    }
}

-(RACSignal *)getdata:(BOOL)isfistLoad{
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        if (isfistLoad) {
            fisModel *v = [fisModel new];
            v.imageUrl = @"2345235236562546";
            v.desc = @"描述";
            [self.sourceArray addObject:v];
            [subscriber sendNext:self.sourceArray];
            [subscriber sendCompleted];
        }else{
            fisModel *v = [fisModel new];
            v.imageUrl = @"2345235236562546";
            v.desc = [@"描述222 ~~~~~~ " stringByAppendingString:[NSString stringWithFormat:@"%d",self.currentPage]];;
            [self.sourceArray addObject:v];
            [subscriber sendNext:self.sourceArray];
            [subscriber sendCompleted];
        }
        [subscriber sendNext:self.sourceArray];
        [subscriber sendCompleted];
        return nil;
  }];
    
}




@end
