//
//  YJFNavigationViewController.m
//  yunService
//
//  Created by 孙春磊 on 2017/10/21.
//  Copyright © 2017年 yunjifen. All rights reserved.
//

#import "YJFRootNavigationController.h"
#import "UIViewController+YJFNavigationExtension.h"

@interface YJFWrapViewController : UIViewController

@property (nonatomic, strong, readonly) UIViewController *rootViewController;
+ (YJFWrapViewController *)wrapViewControllerWithViewController:(UIViewController *)viewController;
@end

// 用户真正操作的Nav
@interface YJFWrapNavigationController : UINavigationController

@end


@implementation YJFWrapNavigationController

- (void)viewDidLoad{
    
    [super viewDidLoad];
    // 关闭此Nav的手势交互
    self.interactivePopGestureRecognizer.enabled = NO;
    
    // 1.取出设置主题的对象
    UINavigationBar *navBar = self.navigationBar;
    
    // 1. 导航条上标题的颜色 title
    NSDictionary *navbarTitleTextAttributes = @{
                                                NSFontAttributeName : [UIFont systemFontOfSize:17],
                                                NSForegroundColorAttributeName :[UIColor whiteColor]
                                                };
  
    [navBar setTitleTextAttributes:navbarTitleTextAttributes];
    // 穿透效果
    navBar.translucent = YES;
    
    // 设置导航条item颜色
    navBar.tintColor = [UIColor whiteColor];

    // 这样可以保留毛玻璃效果
    navBar.barTintColor = [UIColor redColor];
    
    
    UIImageView *navBarHairlineImageView = [self findHairlineImageViewUnder:navBar];
    navBarHairlineImageView.hidden = YES;
    
    // 自定义返回图片(在返回按钮旁边) 这个效果由navigationBar控制
    [navBar setBackIndicatorImage:[UIImage imageNamed:@"NavBack"]];
    [navBar setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"NavBack"]];
}


// 寻找导航栏下的黑线
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

// pop
- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    // 根导航控制器做pop操作 交互动画也交给根导航控制器
    return [self.navigationController popViewControllerAnimated:animated];
}

- (NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated {
    return [self.navigationController popToRootViewControllerAnimated:animated];
}

- (NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    YJFRootNavigationController *yjf_navigationController = viewController.yjf_navigationController;
    NSInteger index = [yjf_navigationController.yjf_viewControllers indexOfObject:viewController];
    return [self.navigationController popToViewController:yjf_navigationController.viewControllers[index] animated:animated];
}

// push
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    // 获取根导航控制器
    viewController.yjf_navigationController = (YJFRootNavigationController *)self.navigationController;
    
    // 统一处理一下Tabbar的隐藏与展示问题
    if (viewController.yjf_navigationController.viewControllers.count) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    // 将业务控制器包装一下再push入栈
    [self.navigationController pushViewController:[YJFWrapViewController wrapViewControllerWithViewController:viewController] animated:animated];
}

-(void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion{
    [self.navigationController dismissViewControllerAnimated:flag completion:completion];
    self.viewControllers.firstObject.yjf_navigationController=nil;
}

@end


static NSValue *yjf_tabBarRectValue;

@implementation YJFWrapViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    if (self.childViewControllers.count && self.view.subviews.count == 0) {
        self.childViewControllers.firstObject.view.frame = self.view.frame;
        [self.view addSubview:self.childViewControllers.firstObject.view];
        [self.childViewControllers.firstObject didMoveToParentViewController:self];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (self.tabBarController && !yjf_tabBarRectValue) {
        yjf_tabBarRectValue = [NSValue valueWithCGRect:self.tabBarController.tabBar.frame];
    }
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.tabBarController && [self rootViewController].hidesBottomBarWhenPushed) {
        self.tabBarController.tabBar.frame = CGRectZero;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // scl:修复contentinset的问题  具体什么原因我没找到
    self.tabBarController.tabBar.translucent = YES;
    if (self.tabBarController && !self.tabBarController.tabBar.hidden && yjf_tabBarRectValue) {
        self.tabBarController.tabBar.frame = yjf_tabBarRectValue.CGRectValue;
    }
}


+ (YJFWrapViewController *)wrapViewControllerWithViewController:(UIViewController *)viewController {
    
    // WrapVc->NavWrapVc->Vc
    // 为了显示返回指示器
    UIViewController *indicatorVc = [UIViewController new];
    // 原生显示效果
    if (viewController.yjf_navigationController.viewControllers.count) {
        YJFWrapViewController *lastWrapVc =[viewController.yjf_navigationController.viewControllers lastObject];
        //  展示前一个控制器的title
        indicatorVc.title = lastWrapVc.rootViewController.navigationItem.title;
        // 去掉前一个控制器的title
        indicatorVc.title = @"";
        
    }
    
    YJFWrapNavigationController *wrapNavController = [[YJFWrapNavigationController alloc] init];
    
    // 设置wrapNavController栈
    if (viewController.yjf_navigationController.viewControllers.count) {
        
        wrapNavController.viewControllers = @[indicatorVc,viewController];
    } else {
        wrapNavController.viewControllers = @[viewController];
    }
    
    YJFWrapViewController *wrapViewController = [[YJFWrapViewController alloc] init];
    [wrapViewController addChildViewController:wrapNavController];
    return wrapViewController;
}


- (BOOL)hidesBottomBarWhenPushed {
    return [self rootViewController].hidesBottomBarWhenPushed;
}

- (UITabBarItem *)tabBarItem {
    return [self rootViewController].tabBarItem;
}

- (NSString *)title {
    return [self rootViewController].title;
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    return [self rootViewController];
}

- (UIViewController *)childViewControllerForStatusBarHidden {
    return [self rootViewController];
}

- (UIViewController *)rootViewController {
    YJFWrapNavigationController *wrapNavController = self.childViewControllers.firstObject;
    return wrapNavController.viewControllers.lastObject;
}


@end



@interface YJFRootNavigationController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>
@end

@implementation YJFRootNavigationController

// 代码创建
- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    if (self = [super init]) {
        // 设置rootViewController的导航控制器为NavigationController
        rootViewController.yjf_navigationController = self;
        // 导航控制器的栈
        // 将业务控制器BizVc包装一层 Wrap->Nav->BizVc
        self.viewControllers = @[[YJFWrapViewController wrapViewControllerWithViewController:rootViewController]];
    }
    return self;
}
// 从xib加载时
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.viewControllers.firstObject.yjf_navigationController = self;
        self.viewControllers = @[[YJFWrapViewController wrapViewControllerWithViewController:self.viewControllers.firstObject]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 隐藏根控制器导航条 -- 会导致侧滑手势失效：apple的侧滑手势中代理做了处理 这里不用系统的侧滑手势代理
    [self setNavigationBarHidden:YES animated:NO];
    // 将侧滑手势代理设置为自己
    self.interactivePopGestureRecognizer.delegate = self;
    self.interactivePopGestureRecognizer.enabled = YES;
    self.delegate = self;
}


#pragma mark - UINavigationControllerDelegate

// 处理手势问题
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    BOOL isRootVC = viewController == navigationController.viewControllers.firstObject;
    self.interactivePopGestureRecognizer.enabled = !isRootVC;

}

//修复有水平方向滚动的ScrollView时边缘返回手势失效的问题
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}


#pragma mark - Getter

- (NSArray *)yjf_viewControllers {
    NSMutableArray *viewControllers = [NSMutableArray array];
    for (YJFWrapViewController *wrapViewController in self.viewControllers) {
        [viewControllers addObject:wrapViewController.rootViewController];
    }
    return viewControllers.copy;
}


@end
