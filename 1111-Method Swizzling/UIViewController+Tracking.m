//
//  UIViewController+Tracking.m
//  1111-Method Swizzling
//
//  Created by yahuan1 on 16/11/11.
//  Copyright © 2016年 yahuan1. All rights reserved.
//

#import "UIViewController+Tracking.h"
#import <objc/runtime.h>
@implementation UIViewController (Tracking)
+ (void)load
{
    Class class = [self class];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        SEL originalSelector = @selector(viewWillAppear:);
        SEL swizzlingSelector = @selector(whj_viewWillAppear:);
        Method originalMethod = class_getClassMethod(class, originalSelector);
        Method swizzlingMethod = class_getClassMethod(class, swizzlingSelector);
        
        BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzlingMethod), method_getTypeEncoding(swizzlingMethod));
        
        if (didAddMethod) {
            class_replaceMethod(class, swizzlingSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzlingMethod);
        }
        
        
        
    });
    
}

#pragma mark - Method Swizzling
- (void)whj_viewWillAppear:(BOOL)animated {
    [self whj_viewWillAppear:animated];
    NSLog(@"viewWillAppear: %@", self);
}
@end
