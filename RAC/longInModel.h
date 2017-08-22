//
//  longInModel.h
//  RAC
//
//  Created by ekhome on 17/8/17.
//  Copyright © 2017年 luzhe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReactiveObjc.h"
@interface longInModel : NSObject

@property(nonatomic, strong,readonly) RACCommand *sourceCommand;

@property (nonatomic,copy,readonly)NSString *result;

@property (nonatomic,assign,readonly)NSInteger resCode;

@property (nonatomic,copy,readonly)NSString *resMsg;



@end
