//
//  fistViewModel.h
//  RAC
//
//  Created by ekhome on 17/8/21.
//  Copyright © 2017年 luzhe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "reactiveObjc.h"
@interface fistViewModel : NSObject<UIScrollViewDelegate>
@property(nonatomic, strong) RACCommand *sourceCommand;
-(void)loadData;
@end
