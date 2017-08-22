//
//  normaViewModel.h
//  RAC
//
//  Created by ekhome on 17/8/22.
//  Copyright © 2017年 luzhe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReactiveObjc.h"

@interface normaViewModel : NSObject
@property (nonatomic,strong,readonly)RACCommand *raccommand;

- (void)refresh;
@end
