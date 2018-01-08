//
//  ModulePerformMethodProvider.h
//  ModuleFactory
//
//  Created by Dong on 2018/1/8.
//  Copyright © 2018年 YoYo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModulePerformMethodProvider : NSObject

// 远程调用
- (id)performActionWithOpenUrl:(NSURL *)url;

// 本地调用
- (id)performNativeAction:(NSString *)action target:(NSString *)target parmas:(NSDictionary *)params;

@end
