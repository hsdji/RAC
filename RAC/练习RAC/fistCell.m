//
//  fistCell.m
//  RAC
//
//  Created by ekhome on 17/8/21.
//  Copyright © 2017年 luzhe. All rights reserved.
//

#import "fistCell.h"
@interface fistCell ()<baseTableView>
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *lab;
@end

@implementation fistCell
-(void)bindViewModel:(fisModel *)viewModel forIndexPath:(NSIndexPath *)indexPath
{
    self.backgroundColor = [UIColor redColor];
    self.image.image = [UIImage imageNamed:viewModel.imageUrl];
    self.lab.text = viewModel.desc;
    self.lab.backgroundColor= [UIColor greenColor];
}
@end

