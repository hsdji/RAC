//
//  baseTableViewController.h
//  RAC
//
//  Created by ekhome on 17/8/21.
//  Copyright © 2017年 luzhe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "reactiveObjc.h"

@protocol DynamicHeightModel <NSObject>


- (NSString *)idStr;

- (BOOL)isLoadedImage;

@end


@interface baseTableViewController : NSObject

@property(assign, nonatomic) BOOL isDynamicHeight;

@property(strong, nonatomic, readonly) NSArray *data;

@property(weak, nonatomic) id <UITableViewDelegate> delegate;

@property(weak, nonatomic) id <UIScrollViewDelegate> scrollViewDelegate;
//使用xib的cell
+(instancetype)bindingBaseForTableView:(UITableView *)tableView
                           souceSingal:(RACSignal *)souce
                      selectionCommand:(RACCommand *)selection
                     customerNibCellCalss:(Class)customerClass;
//纯代码的cell
+(instancetype)bindingBaseForTableView:(UITableView *)tableView
                           souceSingal:(RACSignal *)souce
                      selectionCommand:(RACCommand *)selection
                  customerCellCalss:(Class)customerClass;
@end




































