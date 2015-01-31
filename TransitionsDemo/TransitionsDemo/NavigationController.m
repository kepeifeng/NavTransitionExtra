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
#import "CEPanAnimationController.h"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)


@interface NavigationController () <UINavigationControllerDelegate>

@property (nonatomic, strong) CEReversibleAnimationController * animationController;
@property (nonatomic, strong) CEBaseInteractionController * interactionController;
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

-(instancetype)initWithRootViewController:(UIViewController *)rootViewController{

    self = [super initWithNavigationBarClass:[AKNavigationBar class] toolbarClass:nil];
    if (self) {
        [self pushViewController:rootViewController animated:NO];
    }
    return self;
}



-(void)viewDidLoad{
    [super viewDidLoad];
    self.delegate = self;
    self.animationController = [CEPanAnimationController new];
    self.interactionController = [CEHorizontalSwipeInteractionController new];
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    CGRect drawingRect;
    

    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") && self.underStatusBar == NO) {
        //big size
        CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
        drawingRect = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.navigationBar.bounds)+statusBarHeight);
    }
    else{
        //small size
        drawingRect = self.navigationBar.bounds;
    }
    UIView * view = [[UIView alloc] initWithFrame:drawingRect];
    

    
    UIView * backgroundView = [[UIView alloc] initWithFrame:view.bounds];
    backgroundView.userInteractionEnabled = NO;
    backgroundView.clipsToBounds = YES;
//    [view addSubview:backgroundView];//UC
    
    self.navigationBar.backgroundView = backgroundView;
    [view addSubview:self.navigationBar];
    [self.view addSubview:view];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear: animated];
    NSLog(@"Top VC:%@", NSStringFromCGRect(self.topViewController.view.frame));
}

-(void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    
    
    if (self.underStatusBar) {
        [self makeStatusBarOnTop];
        self.navigationBar.frame = self.navigationBar.bounds;
        self.navigationBar.backgroundView.frame = self.navigationBar.frame;
    }
}

-(void)addChildViewController:(UIViewController *)childController{
    [super addChildViewController:childController];
    NSLog(@"addChildViewController");
}

-(void)setUnderStatusBar:(BOOL)underStatusBar{

    _underStatusBar = underStatusBar;
    [self.navigationBar setUnderStatusBar:underStatusBar];
    
}
-(void)makeStatusBarOnTop
{
    static BOOL isAnimating = NO;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") && self.view.frame.origin.y==0 && !isAnimating)
    {
        
        UIApplication *application = [UIApplication sharedApplication];
        
        CGRect frame = [[UIScreen mainScreen]bounds];
        CGRect wFrame = CGRectMake(0, frame.origin.y+application.statusBarFrame.size.height, frame.size.width, frame.size.height-application.statusBarFrame.size.height);
        self.view.frame = wFrame;
        
        /*isAnimating = YES;
         [UIView animateWithDuration:0.1 animations:^{
         self.view.frame = wFrame;
         } completion:^(BOOL finished) {
         isAnimating = NO;
         }];*/
    }
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    NSLog(@"push");
    [super pushViewController:viewController animated:animated];
}

-(UIViewController *)popViewControllerAnimated:(BOOL)animated{
    NSLog(@"popViewControllerAnimated");
    return [super popViewControllerAnimated:animated];
}


-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    NSLog(@"did show %@, count %lu", viewController, (unsigned long)navigationController.viewControllers.count);
    
    UIViewController * targetVC = ([viewController isKindOfClass:[UITabBarController class]])?([(UITabBarController *)viewController selectedViewController]):viewController;
    BOOL shouldHideNavBar = targetVC.navigationItem.navigationBarHidden;
    
    if (shouldHideNavBar) {
        viewController.view.frame = navigationController.view.bounds;
        NSLog(@"didShowViewController %@", NSStringFromCGRect(viewController.view.frame));
        
    }else{
        CGFloat statusBarHeight = CGRectGetMaxY(navigationController.navigationBar.frame);
        viewController.view.frame = CGRectMake(0, statusBarHeight, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-statusBarHeight);
    }
    [(AKNavigationBar *)navigationController.navigationBar finishedTransitionToViewController:targetVC];
    NSLog(@"VC count = %lu", (unsigned long)navigationController.viewControllers.count);
    self.animationController.navigationController = self;
    if (self.interactionController) {
        if (YES) {
//        if (shouldHideNavBar == NO) {
            
            [self.interactionController wireToViewController:viewController forOperation:CEInteractionOperationPop];
        }
    }
    
    viewController.view.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
}


-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{

    NSLog(@"willShowViewController %@, index = %lu, count = %lu", NSStringFromCGRect(viewController.view.frame), [navigationController.viewControllers indexOfObject:viewController], navigationController.viewControllers.count);
    
    UIViewController * targetVC = ([viewController isKindOfClass:[UITabBarController class]])?([(UITabBarController *)viewController selectedViewController]):viewController;
    
//    [(AKNavigationBar *)navigationController.navigationBar prepareBarViewForViewController:targetVC];
    [(AKNavigationBar *)navigationController.navigationBar prepareBarViewForViewController:viewController];
    
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
    
    if (self.animationController) {
        self.animationController.reverse = operation == UINavigationControllerOperationPop;
    }
    
    return self.animationController;
}



- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                          interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController {
    NSLog(@"%s",__PRETTY_FUNCTION__);
    // if we have an interaction controller - and it is currently in progress, return it
    id <UIViewControllerInteractiveTransitioning> controller = self.interactionController && self.interactionController.interactionInProgress ? self.interactionController : nil;
    if ([controller isKindOfClass:[CEHorizontalSwipeInteractionController class]]) {
        [(CEHorizontalSwipeInteractionController *) controller setNavigationController:navigationController];
    }
    return controller;
}

@end
