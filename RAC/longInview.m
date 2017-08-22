//
//  longInview.m
//  RAC
//
//  Created by ekhome on 17/8/17.
//  Copyright © 2017年 luzhe. All rights reserved.
//

#import "longInview.h"
#import "ReactiveObjc.h"

@interface longInview()
@property (nonatomic,copy)RACCommand *rac_command;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *pas;

@property (weak, nonatomic) IBOutlet UIButton *btn;
@end


@implementation longInview

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        NSArray * nibs = [[NSBundle mainBundle] loadNibNamed:@"longInview" owner:self options:nil];
        self = (longInview *) [nibs firstObject];  
    }
    return self;
}










@end
