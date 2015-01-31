//
//  AppDelegate.m
//  TransitionsDemo
//
//  Created by Colin Eberhardt on 10/09/2013.
//  Copyright (c) 2013 Colin Eberhardt. All rights reserved.
//

#import "AppDelegate.h"
#import "CECardsAnimationController.h"
#import "CEFoldAnimationController.h"
#import "CEPanAnimationController.h"
#import "CEVerticalSwipeInteractionController.h"
#import "CEHorizontalSwipeInteractionController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    AppDelegateAccessor.navigationControllerAnimationController = [CEPanAnimationController new];
    AppDelegateAccessor.navigationControllerInteractionController = [CEHorizontalSwipeInteractionController new];
    
    UINavigationController * navigationController = (UINavigationController *)self.window.rootViewController;
    
    UITabBarController * tabBarController = [navigationController.viewControllers firstObject];
    tabBarController.delegate = self;
    
//    AppDelegateAccessor.navigationControllerAnimationController.navigationController = navigationController;
//    navigationController.navigationBar.translucent = NO;
    NSLog(@"%@",self.window.rootViewController);
    return YES;
}

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{

    if (viewController.navigationItem.navigationBarHidden) {
        tabBarController.navigationController.navigationBar.alpha = 0;
    }else{
        tabBarController.navigationController.navigationBar.alpha = 1;
    
    }
}
@end


