//
//  normaView.h
//  RAC
//
//  Created by ekhome on 17/8/22.
//  Copyright © 2017年 luzhe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "baseTableView.h"
#import "normaModel.h"
@interface normaView : UICollectionViewCell<baseTableView>
@property (nonatomic,strong)UIButton *playBtn;
@property (nonatomic,strong)UILabel *descLab;

@end
