//
//  baseTableViewController.m
//  RAC
//
//  Created by ekhome on 17/8/21.
//  Copyright © 2017年 luzhe. All rights reserved.
//

#import "baseTableViewController.h"
#import "baseTableView.h"
@interface baseTableViewController () <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, readwrite, assign) struct scrollViewDelegateMethodsCaching {

uint scrollViewDidScroll:1;
uint scrollViewDidEndDecelerating:1;

} scrollViewDelegateRespondsTo;

@end



@implementation baseTableViewController{
    NSArray *_data;//数据源
    UITableViewCell *_templeteCell;
    RACCommand *_selection;
    NSString *_reuseIdentifitier;
    UITableView *_tableView;
    NSMutableArray *needLoadArr;
    BOOL scroToToping;
}

-(void)setScrollViewDelegate:(id<UIScrollViewDelegate>)scrollViewDelegate
{
    if (self.scrollViewDelegate != scrollViewDelegate) {
        _scrollViewDelegate = scrollViewDelegate;
    }
     struct scrollViewDelegateMethodsCaching newMethodCaching;
    newMethodCaching.scrollViewDidScroll = [_scrollViewDelegate respondsToSelector:@selector(scrollViewDidScroll:)];
    newMethodCaching.scrollViewDidEndDecelerating = [_scrollViewDelegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)];
    self.scrollViewDelegateRespondsTo = newMethodCaching;
    
}

#pragma -mark initialization
- (instancetype)initWithTableView:(UITableView *)tableView sourceSignal:(RACSignal *)source selectionCommand:(RACCommand *)selection {
    if (self = [super init]) {
        _tableView = tableView;
        _selection = selection;
        
        [source subscribeNext:^(id x) {
            _data = x;
            [_tableView reloadData];
        }];
        needLoadArr = [[NSMutableArray alloc] init];
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return self;
}
//xib
-(instancetype)initWithTableView:(UITableView *)tableView sourceSignal:(RACSignal *)source selectionCommand:(RACCommand *)selection customCellClass:(Class)clazz {
    if (!clazz) {
        return nil;
    }
    self = [self initWithTableView:tableView sourceSignal:source selectionCommand:selection];
    
    if (self) {
        _reuseIdentifitier = NSStringFromClass(clazz);
        UINib *nib = [UINib nibWithNibName:_reuseIdentifitier bundle:nil];
        _templeteCell = [[nib instantiateWithOwner:nil options:nil] firstObject];
        [_tableView registerNib:nib forCellReuseIdentifier:_reuseIdentifitier];
        _tableView.rowHeight = _templeteCell.bounds.size.height;
    }
    return self;
}
//All code
- (instancetype)initWithTableView:(UITableView *)tableView sourceSignal:(RACSignal *)source selectionCommand:(RACCommand *)selection templateCellClass:(Class)clazz {
    self = [self initWithTableView:tableView sourceSignal:source selectionCommand:selection];
    if (self) {
        _reuseIdentifitier = NSStringFromClass(clazz);
        _templeteCell = [[clazz alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_reuseIdentifitier];
        [_tableView registerClass:clazz forCellReuseIdentifier:_reuseIdentifitier];
        _tableView.rowHeight = _templeteCell.bounds.size.height; // use the template cell to set the row height
    }
    return self;
}


#pragma -mark publick Method Implementtation
//xib
+(instancetype)bindingBaseForTableView:(UITableView *)tableView souceSingal:(RACSignal *)souce selectionCommand:(RACCommand *)selection customerNibCellCalss:(Class)customerClass
{
    
    return [[baseTableViewController alloc] initWithTableView:tableView sourceSignal:souce selectionCommand:selection customCellClass:customerClass];
}
//allCode
+(instancetype)bindingBaseForTableView:(UITableView *)tableView souceSingal:(RACSignal *)souce selectionCommand:(RACCommand *)selection customerCellCalss:(Class)customerClass
{
    return [[baseTableViewController alloc] initWithTableView:tableView sourceSignal:souce selectionCommand:selection templateCellClass:customerClass];
}


#pragma -mark tableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)]) {
        return [self.delegate tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    CGFloat heightForRowAtIndexPath = tableView.rowHeight;
    return heightForRowAtIndexPath;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id <baseTableView> cell = [tableView dequeueReusableCellWithIdentifier:_reuseIdentifitier forIndexPath:indexPath];
    [cell bindViewModel:_data[indexPath.row] forIndexPath:indexPath];
    return (UITableViewCell *) cell;
}


#pragma -mark tableViewDatasouce

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data.count;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (!_selection) {
        return;
    }
    // execute the command
    RACTuple *turple = [RACTuple tupleWithObjects:_data[indexPath.row], indexPath, nil];
    [_selection execute:turple];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.scrollViewDelegateRespondsTo.scrollViewDidScroll == 1) {
        [self.scrollViewDelegate scrollViewDidScroll:scrollView];
    }
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [needLoadArr removeAllObjects];
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.scrollViewDelegateRespondsTo.scrollViewDidEndDecelerating == 1) {
        [self.scrollViewDelegate scrollViewDidEndDecelerating:scrollView];
    }
}
@end
