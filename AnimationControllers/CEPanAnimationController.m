//
//  CEPanAnimationController.m
//  TransitionsDemo
//
//  Created by Alvin Zeng on 01/08/2014.
//  Copyright (c) 2014 Alvin Zeng. All rights reserved.
//

#import "CEPanAnimationController.h"
#import "AKNavigationBar.h"



@implementation CEPanAnimationController

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC fromView:(UIView *)fromView toView:(UIView *)toView {
    
    CGFloat SCREEN_WIDTH = CGRectGetWidth([[UIScreen mainScreen] bounds]);
    NSLog(@"%s", __PRETTY_FUNCTION__);
    self.duration = .3;
    // Add the toView to the container
    UIView* containerView = [transitionContext containerView];
    [containerView addSubview:toView];
    toView.frame = CGRectMake(self.reverse ? -160 : SCREEN_WIDTH, toView.frame.origin.y, toView.frame.size.width, toView.frame.size.height);
    
    self.reverse ? [containerView sendSubviewToBack:toView] : [containerView bringSubviewToFront:toView];
    
    AKNavigationBar * navigationBar = (AKNavigationBar *)self.navigationController.navigationBar;
    UIViewController * targetVC = ([toVC isKindOfClass:[UITabBarController class]])?([(UITabBarController *)toVC selectedViewController]):toVC;
    
    if (targetVC.navigationItem.navigationBarHidden) {
        CGRect toViewRect = toView.frame;
        toViewRect.size.height = CGRectGetHeight(self.navigationController.view.bounds);
        toViewRect.origin.y = 0;
        toView.frame = toViewRect;
    }
    
    /*
    AKNavigationBar * navigationBar = (AKNavigationBar *)self.navigationController.navigationBar;
    UIViewController * fromVCInside = ([fromVC isKindOfClass:[UITabBarController class]])?([(UITabBarController *)fromVC selectedViewController]):fromVC;
    UIView * fromViewBar = [navigationBar prepareBarViewForViewController:fromVCInside];
    CGRect fromViewBarRect = fromViewBar.frame;
    fromViewBarRect.origin.x = CGRectGetMinX(fromView.frame);
    
    NSLog(@"%@", NSStringFromCGRect(fromViewBarRect));
    
    UIViewController * targetVC = ([toVC isKindOfClass:[UITabBarController class]])?([(UITabBarController *)toVC selectedViewController]):toVC;
    
    if (targetVC.navigationItem.navigationBarHidden) {
        CGRect toViewRect = toView.frame;
        toViewRect.size.height = CGRectGetHeight(self.navigationController.view.bounds);
        toViewRect.origin.y = 0;
        toView.frame = toViewRect;
    }
    
    UIView * toViewBar = [navigationBar prepareBarViewForViewController:targetVC];
    CGRect rect = toViewBar.frame;
    rect.origin.x = CGRectGetMinX(toView.frame);
    
    

    NSLog(@"%@", NSStringFromCGRect(rect));
    
    NSLog(@"fromVC:%lu toVc:%lu", [self.navigationController.viewControllers indexOfObject:fromVC], [self.navigationController.viewControllers indexOfObject:toVC]);
    BOOL isPoping = [self.navigationController.viewControllers indexOfObject:fromVC] == NSNotFound;
    
    if (isPoping) {
        [navigationBar setFirstView:fromViewBar secondView:toViewBar];

        rect.size.width = 160;
        rect.origin.x = -160;
        fromViewBarRect.size.width = SCREEN_WIDTH;
    }else{
        [navigationBar setFirstView:toViewBar   secondView:fromViewBar];
    
        rect.size.width = SCREEN_WIDTH;
        fromViewBarRect.size.width = SCREEN_WIDTH;
    }
    toViewBar.frame = rect;
    fromViewBar.frame = fromViewBarRect;
*/
    // animate
    NSTimeInterval duration = [self transitionDuration:transitionContext];
   
    BOOL shouldHideNavBar = targetVC.navigationItem.navigationBarHidden;
    
    CGFloat fromValue = navigationBar.navComponentAlpha;
    CGFloat toValue = (shouldHideNavBar)?0.001:1.0;

    
//    [UIView beginAnimations:nil context:nil];
//    
//    CGRect finalRect = toViewBar.frame;
//    finalRect.origin.x = 0;
//    CGRect fromViewRect = fromViewBar.frame;
//    fromViewRect.origin.x = !self.reverse ? -160 : SCREEN_WIDTH;
//    if(isPoping){
//        fromViewRect.size.width = SCREEN_WIDTH;
//        finalRect.size.width = SCREEN_WIDTH;
//    }else{
//        
//        fromViewRect.size.width = 160;
//        finalRect.size.width = SCREEN_WIDTH;
//    }
//    
//    toViewBar.frame = finalRect;
//    fromViewBar.frame = fromViewRect;
//    
//    [UIView commitAnimations];
    
    
//    [UIView animateWithDuration:duration animations:^{
//        
//        CGRect rect = toViewBar.frame;
//        rect.origin.x = 0;
//        CGRect fromViewRect = fromViewBar.frame;
//        fromViewRect.origin.x = !self.reverse ? -160 : SCREEN_WIDTH;
//        if(isPoping){
//            fromViewRect.size.width = SCREEN_WIDTH;
//            rect.size.width = SCREEN_WIDTH;
//        }else{
//            
//            fromViewRect.size.width = 160;
//            rect.size.width = SCREEN_WIDTH;
//        }
//        
//        toViewBar.frame = rect;
//        fromViewBar.frame = fromViewRect;
//        
//    } completion:^(BOOL finished) {
//        NSLog(@"animation completion");
//    }];
    [UIView animateWithDuration:duration animations:^{
        fromView.frame = CGRectMake(!self.reverse ? -160 : SCREEN_WIDTH, fromView.frame.origin.y, fromView.frame.size.width, fromView.frame.size.height);
        toView.frame = CGRectMake(0, toView.frame.origin.y, toView.frame.size.width, toView.frame.size.height);
        
        /*CGRect finalRect = toViewBar.frame;
        finalRect.origin.x = 0;
        
        
        CGRect fromViewRect = fromViewBar.frame;
        fromViewRect.origin.x = !self.reverse ? -160 : SCREEN_WIDTH;
        if(isPoping){
            fromViewRect.size.width = SCREEN_WIDTH;
            finalRect.size.width = SCREEN_WIDTH;
        }else{
        
            fromViewRect.size.width = 160;
            finalRect.size.width = SCREEN_WIDTH;
        }
        
        toViewBar.frame = finalRect;
        fromViewBar.frame = fromViewRect;*/

        
        navigationBar.navComponentAlpha = toValue;
        
    } completion:^(BOOL finished) {
        if ([transitionContext transitionWasCancelled]) {
            toView.frame = CGRectMake(0, toView.frame.origin.y, toView.frame.size.width, toView.frame.size.height);
            fromView.frame = CGRectMake(0, fromView.frame.origin.y, fromView.frame.size.width, fromView.frame.size.height);
            navigationBar.navComponentAlpha = fromValue;
            /*[toViewBar removeFromSuperview];*/

        } else {
            // reset from- view to its original state
            [fromView removeFromSuperview];
            fromView.frame = CGRectMake(!self.reverse ? -160 : SCREEN_WIDTH, fromView.frame.origin.y, fromView.frame.size.width, fromView.frame.size.height);
            toView.frame = CGRectMake(0, toView.frame.origin.y, toView.frame.size.width, toView.frame.size.height);
            navigationBar.navComponentAlpha = toValue;
            /*[fromViewBar removeFromSuperview];*/
        }
        NSLog(@"Finished");
        
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
    
}

@end
