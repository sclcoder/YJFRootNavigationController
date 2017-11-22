//
//  UIViewController+YJFNavigationExtension.h
//  yunService
//
//  Created by 孙春磊 on 2017/10/21.
//  Copyright © 2017年 yunjifen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YJFRootNavigationController.h"

@interface UIViewController (YJFNavigationExtension)

@property (nonatomic, weak) YJFRootNavigationController *yjf_navigationController;

@end
