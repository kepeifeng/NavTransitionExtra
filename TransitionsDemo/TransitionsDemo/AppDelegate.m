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
#import "AKNavigationBar.h"
#import "CamView.h"
#import "AKNavigationController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    AppDelegateAccessor.navigationControllerAnimationController = [CEPanAnimationController new];
    AppDelegateAccessor.navigationControllerInteractionController = [CEHorizontalSwipeInteractionController new];
    

    [AKNavigationController setUnderStatusBar:YES];
    
    AKNavigationController * navigationController = (AKNavigationController *)self.window.rootViewController;
    [AKNavigationBar setDefaultBarViewConfig:^(UIView *view) {
        [view addSubview:[[CamView alloc] initWithFrame:view.bounds]];
//        UIColor * color = [UIColor colorWithRed:(arc4random_uniform(100)/100.0) green:(arc4random_uniform(100)/100.0) blue:(arc4random_uniform(100)/100.0) alpha:1.000];
//        
//        view.backgroundColor = color;
    }];
    

    
    UITabBarController * tabBarController = [navigationController.viewControllers firstObject];
    tabBarController.delegate = self;
    
//    AppDelegateAccessor.navigationControllerAnimationController.navigationController = navigationController;
//    navigationController.navigationBar.translucent = NO;
    NSLog(@"%@",self.window.rootViewController);
    return YES;
}

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{

    UINavigationController * navController = tabBarController.navigationController;


    

    
    if ([navController.delegate respondsToSelector:@selector(navigationController:willShowViewController:animated:)]) {
        [navController.delegate navigationController:navController willShowViewController:tabBarController animated:NO];
    }
    if ([navController.delegate respondsToSelector:@selector(navigationController:didShowViewController:animated:)]) {
        
        [navController.delegate navigationController:navController
                                                       didShowViewController:tabBarController
                                                                    animated:NO];
    }
    
    /*[(AKNavigationBar *)tabBarController.navigationController.navigationBar prepareBarViewForViewController:viewController];
    BOOL shouldHideNavBar = viewController.navigationItem.navigationBarHidden;
    [(AKNavigationBar *)tabBarController.navigationController.navigationBar finishedTransitionToViewController:viewController];
    
    if (shouldHideNavBar) {
//        tabBarController.navigationController.navigationBar.alpha = 0;
    }else{
//        tabBarController.navigationController.navigationBar.alpha = 1;
    }*/
}
@end


