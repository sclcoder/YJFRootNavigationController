//
//  YJFTabBarController.m
//  yunES
//
//  Created by 孙春磊 on 16/7/20.
//  Copyright © 2016年 yunjifen. All rights reserved.
//

#import "YJFTabBarController.h"
#import "YJFRootNavigationController.h"
#import "YJFViewController.h"

@interface YJFTabBarController ()

@end

@implementation YJFTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setupTabbar];
}


- (void)setupTabbar{
    

    [self addOneChildrenVc:[YJFViewController class]
                     title:@"home1"
               originImage:nil
             selectedImage:nil
                badgeValue:0];
    
    [self addOneChildrenVc:[YJFViewController class]
                     title:@"home2"
               originImage:nil
             selectedImage:nil
                badgeValue:0];

}


- (void)addOneChildrenVc:(Class)VcClass  title:(NSString *)title originImage:(NSString *)originImage selectedImage:(NSString *)selectedImage badgeValue:(NSInteger)badgeValue{
    
    UIViewController *viewController = [[VcClass alloc] init];
    
    UIImage *origin = [UIImage imageNamed:originImage];
    UIImage *selected = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    // 设置navigationItem
    viewController.navigationItem.title = title;
    YJFRootNavigationController *navigationVc = [[YJFRootNavigationController alloc] initWithRootViewController:viewController];
    
    // 设置tabBarItem
    navigationVc.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:origin selectedImage:selected];
    if (badgeValue) {
        navigationVc.tabBarItem.badgeValue = [NSString stringWithFormat:@"%zd",badgeValue];
    }
    
    [self addChildViewController:navigationVc];
    
    self.tabBar.tintColor = [UIColor blackColor];
    
}

@end
