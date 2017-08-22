//
//  normalCollectionViewController.m
//  RAC
//
//  Created by ekhome on 17/8/22.
//  Copyright © 2017年 luzhe. All rights reserved.
//
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#import "normalCollectionViewController.h"
#import "normaViewModel.h"
#import "normaView.h"
@interface normalCollectionViewController ()
@property (nonatomic,strong)NSMutableArray *allDataArr;
@property (nonatomic,strong)normaViewModel *viewModel;
@property (nonatomic,strong)RACSignal *souce;
@property (nonatomic,assign)CGFloat lastOffsetY;
@end

@implementation normalCollectionViewController

static NSString * const reuseIdentifier = @"Cell";


- (instancetype)init{
    // 创建一个流水布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    // 设置cell的尺寸
    layout.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width/2-20, 170);
    // 设置滚动的方向
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    // 行间距
    layout.minimumLineSpacing = 30;
    // 设置cell之间的间距
    layout.minimumInteritemSpacing = 0;
    //    // 组间距
    layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    self.allDataArr = [NSMutableArray new];
    self.viewModel = [normaViewModel new];
    //数据源信号
    self.souce = [[self.viewModel.raccommand executionSignals] switchToLatest];
    [self.souce subscribeNext:^(id  _Nullable x) {
        [self.allDataArr addObjectsFromArray:x];
        [self.collectionView reloadData];
    }];
    return [super initWithCollectionViewLayout:layout];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView registerClass:[normaView class] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    RACTuple *tuple = [RACTuple tupleWithObjects:@(YES),nil];
    [self.viewModel.raccommand execute:tuple];
    
}



- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.allDataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    normaView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    NSLog(@"%ld",indexPath.row);
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:self.allDataArr[indexPath.row]];
    [cell bindViewModel:dic];
    return cell;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y- self.lastOffsetY> 2*SCREEN_HEIGHT) {
        [self.viewModel refresh];
        self.lastOffsetY=scrollView.contentOffset.y;
    }
}

@end
