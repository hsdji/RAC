//
//  baseTableView.h
//  RAC
//
//  Created by ekhome on 17/8/21.
//  Copyright © 2017年 luzhe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "baseTableViewController.h"
@protocol baseTableView <NSObject>
@optional
- (void)bindViewModel:(id)viewModel;

- (void)bindViewModel:(id)viewModel forIndexPath:(NSIndexPath *)indexPath;


- (void)clear;

- (BOOL)hadLoadImage;
@end
