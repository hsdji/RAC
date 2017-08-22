//
//  fistTableViewController.m
//  RAC
//
//  Created by ekhome on 17/8/21.
//  Copyright © 2017年 luzhe. All rights reserved.
//

#import "fistTableViewController.h"
#import "fistViewModel.h"
#import "baseTableViewController.h"
#import "fistCell.h"
#import "MJRefresh.h"
@interface fistTableViewController()
@property (nonatomic,strong)fistViewModel *viewModel;
@property(strong, nonatomic) baseTableViewController *helper;
@property(strong, nonatomic) RACTuple *turple;


@end



@implementation fistTableViewController
-(void)viewDidLoad
{
    
    self.tableView = [[UITableView alloc] init];
    
        self.viewModel = [fistViewModel new];
        self.turple = [RACTuple tupleWithObjects:@(YES),nil];

        //数据源信号
        RACSignal *sourceSignal = [[self.viewModel.sourceCommand executionSignals] switchToLatest];
        
        
        RACCommand *selectCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(RACTuple *turple) {
            NSIndexPath *index = turple.second;
            fisModel *model = turple.first;
            NSLog(@"点击了地%ld行   标题是:%@",index.row,model.desc);
            return [RACSignal empty];
        }];
        //列表绑定数据
        self.helper = [baseTableViewController bindingBaseForTableView:self.tableView souceSingal:sourceSignal selectionCommand:selectCommand customerNibCellCalss:[fistCell class]];
        [self.helper setScrollViewDelegate:self.viewModel];
        [self.viewModel.sourceCommand execute:self.turple];
    
//    @weakify(self)
//    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        @strongify(self)
//        [self.viewModel loadData];
//    }];
//    
//    [self.viewModel.sourceCommand.executing subscribeNext:^(id isExcuting) {
//        @strongify(self)
//        if (![isExcuting boolValue]) {
//            [self.tableView.header endRefreshing];
//            [self.tableView.footer endRefreshing];
//        }
//    }];
}
@end
