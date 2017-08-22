//
//  normaViewModel.m
//  RAC
//
//  Created by ekhome on 17/8/22.
//  Copyright © 2017年 luzhe. All rights reserved.
//

#import "normaViewModel.h"
#import "AFNetworking.h"
#import "normaModel.h"
@interface normaViewModel()
@property (nonatomic,strong)RACCommand *raccommand;
@property (nonatomic,assign)BOOL isLoading;
@end


@implementation normaViewModel
-(instancetype)init{
    self = [super init];
    if (self) {
        [self setUp];
    }
    return self;
}





- (void)setUp{
    self.raccommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * (RACTuple  *tuple) {
        return [self loadData];
    }];
    
    RAC(self,isLoading) = self.raccommand.executing;
    
}


-(void)refresh
{
    if (!self.isLoading) {
        RACTuple *tuple = [RACTuple tupleWithObjects:@"1", nil];
        [self.raccommand execute:tuple];
    }
}
/*
 
    parameters:
 **/

-(RACSignal *)loadData{
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/json",@"text/html", @"application/json",  @"text/javascript", @"text/plain", nil];
        [manager.requestSerializer setTimeoutInterval:10];
        
        [manager POST:@"http://123.59.169.36/rest/n/feed/hot?appver=5.1.1.212&did=7685EF0D-B053-4C79-A0A2-19469206636A&c=a&ver=5.1&sys=ios10.3.1&mod=iPhone7%2C2&net=%E4%B8%AD%E5%9B%BD%E7%A7%BB%E5%8A%A85" parameters:@{@"client_key":@"56c3713c",@"count":@"30",@"country_code":@"cn",@"id":@"18",@"language":@"zh-Hans-CN;q=1",@"pv":@"false",@"sig":@"fa7fbdc49e7f821ba556a4f6b749c3d7",@"type":@"7",@"pcursor":@"1"} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            NSMutableArray *alldata = [NSMutableArray new];
            NSArray *arr = [responseObject valueForKey:@"feeds"];
            for (int i =0; i<arr.count; i++) {
                NSArray *arr2 = [arr[i] valueForKey:@"main_mv_urls"];
                NSArray *imageArr = [arr[i] valueForKey:@"cover_thumbnail_urls"];
                for (int i =0; i<arr2.count; i++) {
                    NSString  *str = [arr2[i] valueForKey:@"url"];
                    NSString *imageStr = [imageArr[i] valueForKey:@"url"];
                    NSDictionary *dic = @{@"imageDesc":str,@"imageUrl":imageStr};
                    [alldata addObject:dic];
                }
            }
            [subscriber sendNext:alldata];
            [subscriber sendCompleted];
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [subscriber sendCompleted];
        }];
        return nil;
    }];

}

@end
