//
//  PDBHModel.h
//  PerfectDota2
//
//  Created by 谈Xx on 15/12/17.
//  Copyright © 2015年 谈Xx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PDBHModel : NSObject
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, copy) NSString *title;
/**
 *  webview 有url
 */
@property (nonatomic, copy) NSString *url;
/**
 *  客户端原生 有type
 */
@property (nonatomic, copy) NSString *type;
/**
 *  new hot
 */
@property (nonatomic, copy) NSString *tag;
@end
