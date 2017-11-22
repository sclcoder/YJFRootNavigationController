//
//  UIViewController+YJFNavigationExtension.m
//  yunService
//
//  Created by 孙春磊 on 2017/10/21.
//  Copyright © 2017年 yunjifen. All rights reserved.
//

#import "UIViewController+YJFNavigationExtension.h"
#import <objc/runtime.h>

@implementation UIViewController (YJFNavigationExtension)

// runtime添加一个成员变量
- (YJFRootNavigationController *)yjf_navigationController {
    return objc_getAssociatedObject(self, _cmd);
}

// 使用@selector(yjf_navigationController)  _cmd当做key
- (void)setYjf_navigationController:(YJFRootNavigationController *)navigationController {
    objc_setAssociatedObject(self, @selector(yjf_navigationController), navigationController, OBJC_ASSOCIATION_ASSIGN);
}


@end
