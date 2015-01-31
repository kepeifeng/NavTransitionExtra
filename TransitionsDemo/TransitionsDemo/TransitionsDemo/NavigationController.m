//
//  MyNavigationControllerViewController.m
//  ViewControllerTransitions
//
//  Created by Colin Eberhardt on 09/09/2013.
//  Copyright (c) 2013 Colin Eberhardt. All rights reserved.
//

#import "NavigationController.h"
#import "AppDelegate.h"
#import "CEBaseInteractionController.h"
#import "CEReversibleAnimationController.h"
#import "CEHorizontalSwipeInteractionController.h"
@interface NavigationController () <UINavigationControllerDelegate>

@end

@implementation NavigationController

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.delegate = self;
        
//        self.navigationBar.barTintColor = [UIColor greenColor];
        
//        [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"cam_button_bg"] forBarMetrics:(UIBarMetricsDefault)];
    }
    return self;
}

//-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
//
//
//
//}

-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    NSLog(@"did show %@, count %lu", viewController, (unsigned long)navigationController.viewControllers.count);
    
    UIViewController * targetVC = ([viewController isKindOfClass:[UITabBarController class]])?([(UITabBarController *)viewController selectedViewController]):viewController;
    BOOL shouldHideNavBar = targetVC.navigationItem.navigationBarHidden;
    
    if (shouldHideNavBar) {
        navigationController.navigationBar.alpha = 0;
    }else{
        navigationController.navigationBar.alpha = 1;
    
    }
    NSLog(@"VC count = %lu", (unsigned long)navigationController.viewControllers.count);
    AppDelegateAccessor.navigationControllerAnimationController.navigationController = self;
    if (AppDelegateAccessor.navigationControllerInteractionController) {
        if (shouldHideNavBar == NO) {
            
            [AppDelegateAccessor.navigationControllerInteractionController wireToViewController:viewController forOperation:CEInteractionOperationPop];
        }
    }
}
-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{

    
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC {
    NSLog(@"%s",__PRETTY_FUNCTION__);
    // when a push occurs, wire the interaction controller to the to- view controller
//    if (AppDelegateAccessor.navigationControllerInteractionController) {
//        [AppDelegateAccessor.navigationControllerInteractionController wireToViewController:toVC forOperation:CEInteractionOperationPop];
//    }
    
    if (AppDelegateAccessor.navigationControllerAnimationController) {
        AppDelegateAccessor.navigationControllerAnimationController.reverse = operation == UINavigationControllerOperationPop;
    }
    
    return AppDelegateAccessor.navigationControllerAnimationController;
}

- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                          interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController {
    NSLog(@"%s",__PRETTY_FUNCTION__);
    // if we have an interaction controller - and it is currently in progress, return it
    id <UIViewControllerInteractiveTransitioning> controller = AppDelegateAccessor.navigationControllerInteractionController && AppDelegateAccessor.navigationControllerInteractionController.interactionInProgress ? AppDelegateAccessor.navigationControllerInteractionController : nil;
    if ([controller isKindOfClass:[CEHorizontalSwipeInteractionController class]]) {
        [(CEHorizontalSwipeInteractionController *) controller setNavigationController:navigationController];
    }
    return controller;
}

@end
