//
//  ModulePerformMethodProvider.m
//  ModuleFactory
//
//  Created by Dong on 2018/1/8.
//  Copyright © 2018年 YoYo. All rights reserved.
//

#import "ModulePerformMethodProvider.h"
#import <UIKit/UIKit.h>

@implementation ModulePerformMethodProvider

// 远程调用
- (id)performActionWithOpenUrl:(NSURL *)url {
    NSString *urlQuery = [url query];
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    for (NSString *param in [urlQuery componentsSeparatedByString:@"&"]) {
        // [请求字段, 数据]
        NSArray *elements = [param componentsSeparatedByString:@"="];
        if (elements.count != 2) {
            continue;
        }
        
        [params setObject:elements.lastObject forKey:elements.firstObject];
    }
    
    // 这里做一些防御性质的判断，native 是本地调用才使用
    NSString *action = [url.path stringByReplacingOccurrencesOfString:@"/" withString:@""];
    if ([action hasPrefix:@"native"]) {
        return nil;
    }
    
    return [self performNativeAction:action target:url.host parmas:params];
}

// 本地调用
- (id)performNativeAction:(NSString *)action target:(NSString *)target parmas:(NSDictionary *)params {
    if (!action || !target) {
        return nil;
    }
    
    Class targetClass = NSClassFromString(target);
    SEL selector = NSSelectorFromString(action);
    
    if ([targetClass respondsToSelector:selector]) {
        return [self safePerformSelector:selector target:targetClass params:params];
    }
    
    return nil;
}

#pragma mark - private methods

- (id)safePerformSelector:(SEL)selector target:(id)target params:(NSDictionary *)params {
    NSMethodSignature *methodSignature = [target methodSignatureForSelector:selector];
    
    if (!methodSignature) {
        return nil;
    }
    
    const char* returnType = [methodSignature methodReturnType];
    
    if (strcmp(returnType, @encode(void)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:selector];
        [invocation setTarget:target];
        [invocation invoke];
        return nil;
    }
    
    if (strcmp(returnType, @encode(NSInteger)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:selector];
        [invocation setTarget:target];
        [invocation invoke];
        NSInteger result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    if (strcmp(returnType, @encode(BOOL)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:selector];
        [invocation setTarget:target];
        [invocation invoke];
        BOOL result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    if (strcmp(returnType, @encode(CGFloat)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:selector];
        [invocation setTarget:target];
        [invocation invoke];
        CGFloat result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    if (strcmp(returnType, @encode(NSUInteger)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:selector];
        [invocation setTarget:target];
        [invocation invoke];
        NSUInteger result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    return [target performSelector:selector withObject:params];
#pragma clang diagnostic pop
}

@end
