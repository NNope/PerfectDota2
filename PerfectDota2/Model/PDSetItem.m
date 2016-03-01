//
//  PDSetItem.m
//  PerfectDota2
//
//  Created by 谈Xx on 16/2/23.
//  Copyright © 2016年 谈Xx. All rights reserved.
//

#import "PDSetItem.h"

@implementation PDSetItem

+ (instancetype)itemWithTitle:(NSString *)title
{
    PDSetItem *item = [[self alloc] init];
    item.title = title;
    
    /**
     *  增加测试block
     */

    item.operation = ^(id viewController){
        if (viewController == nil)
        {
            return ;
        }
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:title preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action1];
        
        UIAlertAction *action2  = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action2];
        
        [viewController presentViewController:alert animated:YES completion:nil];
        
    };
    return item;
}


@end
