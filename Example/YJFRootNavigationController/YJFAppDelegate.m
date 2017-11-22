//
//  YJFAppDelegate.m
//  YJFRootNavigationController
//
//  Created by acct<blob>=<NULL> on 11/03/2017.
//  Copyright (c) 2017 acct<blob>=<NULL>. All rights reserved.
//

#import "YJFAppDelegate.h"
#import "YJFTabBarController.h"

@implementation YJFAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self setupLaunch];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}



- (void)setupLaunch{
    
    // 主界面
    self.window.rootViewController = [[YJFTabBarController alloc] init];
}

@end
