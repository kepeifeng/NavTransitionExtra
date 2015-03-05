//
//  MyNavigationControllerViewController.m
//  ViewControllerTransitions
//
//  Created by Colin Eberhardt on 09/09/2013.
//  Copyright (c) 2013 Colin Eberhardt. All rights reserved.
//

#import "AKNavigationController.h"
#import "AppDelegate.h"
#import "CEBaseInteractionController.h"
#import "CEReversibleAnimationController.h"
#import "CEHorizontalSwipeInteractionController.h"
#import "CEPanAnimationController.h"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

static BOOL _underStatusBar;
@interface AKNavigationController () <UINavigationControllerDelegate>

@property (nonatomic, strong) CEReversibleAnimationController * animationController;
@property (nonatomic, strong) CEBaseInteractionController * interactionController;
@end

@implementation AKNavigationController

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.delegate = self;
        
//        self.navigationBar.barTintColor = [UIColor greenColor];
        
//        [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"cam_button_bg"] forBarMetrics:(UIBarMetricsDefault)];
    }
    return self;
}
- (instancetype)init
{
//    self = [super init];
    
    self = [super initWithNavigationBarClass:[AKNavigationBar class] toolbarClass:nil];
    if (self) {
        
        self.delegate = self;
    }
    return self;
}
-(instancetype)initWithRootViewController:(UIViewController *)rootViewController{


    self = [super initWithNavigationBarClass:[AKNavigationBar class] toolbarClass:nil];
    if (self) {
        
        self.delegate = self;
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
    

    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") && _underStatusBar == NO) {
        //big size
        CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
        drawingRect = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.navigationBar.bounds)+statusBarHeight);
    }
    else{
        //small size
        drawingRect = self.navigationBar.bounds;
    }
    
    self.navigationBar.backgroundRect = drawingRect;

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear - %@", self.topViewController.view);
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear: animated];
    

    //Must Have (While being presented)
    [self updateViewLayout];
    
    NSLog(@"viewDidAppear - %@", self.topViewController.view);

}



-(void)setNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated{

    [super setNavigationBarHidden:hidden animated:animated];
    
    /*CGRect rect = self.view.bounds;
    if (hidden) {

    }else{
    
        if (self.topViewController.navigationItem.navigationBarHidden == NO) {
            rect = self.view.bounds;
            rect.origin.y = CGRectGetHeight(self.navigationBar.bounds);
            rect.size.height -= rect.origin.y;
            
        }
    }
    
    CGRect topVCRect = self.topViewController.view.frame;
    self.topViewController.view.frame = rect;*/

}

-(void)updateViewLayout{
    
    UIViewController * viewController = self.topViewController;
    UIViewController * targetVC = ([viewController isKindOfClass:[UITabBarController class]])?([(UITabBarController *)viewController selectedViewController]):viewController;
    BOOL shouldHideNavBar = targetVC.navigationItem.navigationBarHidden;
    
    if (shouldHideNavBar || self.navigationBarHidden) {
        viewController.view.frame = self.view.bounds;
        self.navigationBar.navComponentAlpha = 0;
    }else{
        CGFloat statusBarHeight = CGRectGetMaxY(self.navigationBar.frame);
        viewController.view.frame = CGRectMake(0, statusBarHeight, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-statusBarHeight);
        
//        CGRect viewControllerFrame = viewController.view.frame;

        self.navigationBar.navComponentAlpha = 1;
    }
    
    if ([viewController isKindOfClass:[UITabBarController class]]) {
        [viewController.view setNeedsLayout];
    }    
}

-(void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    
    
    if (_underStatusBar) {
        [self makeStatusBarOnTop];
        self.navigationBar.frame = self.navigationBar.bounds;
        self.navigationBar.backgroundView.frame = self.navigationBar.frame;
    }
    
    //Must Have
    [self updateViewLayout];
    NSLog(@"viewDidLayoutSubviews - %@", self.topViewController.view);

}

-(void)addChildViewController:(UIViewController *)childController{
    [super addChildViewController:childController];
    NSLog(@"addChildViewController");
}


+(BOOL)underStatusBar
{
    return _underStatusBar;
}

+(void)setUnderStatusBar:(BOOL)underStatusBar
{
    _underStatusBar = underStatusBar;
}

//-(void)setUnderStatusBar:(BOOL)underStatusBar{
//
//    _underStatusBar = underStatusBar;
//    [self.navigationBar setUnderStatusBar:underStatusBar];
//    
//}
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
    [viewController setAutomaticallyAdjustsScrollViewInsets:NO];
    [super pushViewController:viewController animated:animated];
}

-(UIViewController *)popViewControllerAnimated:(BOOL)animated{
    NSLog(@"popViewControllerAnimated");
    return [super popViewControllerAnimated:animated];
}



@end

@implementation UIViewController (AKNavigationController)



-(void)navigationController:(AKNavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    NSLog(@"did show %@, count %lu", viewController, (unsigned long)navigationController.viewControllers.count);
    
    
    [navigationController updateViewLayout];
    NSLog(@"VC count = %lu", (unsigned long)navigationController.viewControllers.count);
    navigationController.animationController.navigationController = navigationController;
    if (navigationController.interactionController) {
        [navigationController.interactionController wireToViewController:viewController forOperation:CEInteractionOperationPop];
    }
    
    viewController.view.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    
    if ([viewController isKindOfClass:[UITabBarController class]] || viewController == navigationController.topViewController) {
        
        [(AKNavigationBar *)navigationController.navigationBar finishedTransitionFromViewController:nil toViewController:viewController canceled:NO];
    }
    
}


-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    NSLog(@"willShowViewController %@, index = %lu, count = %lu", NSStringFromCGRect(viewController.view.frame), (unsigned long)[navigationController.viewControllers indexOfObject:viewController], (unsigned long)navigationController.viewControllers.count);
    
    UIViewController * targetVC = ([viewController isKindOfClass:[UITabBarController class]])?([(UITabBarController *)viewController selectedViewController]):viewController;
    
    if ([viewController isKindOfClass:[UITabBarController class]]) {
        
        viewController.navigationItem.leftBarButtonItems = targetVC.navigationItem.leftBarButtonItems;
        viewController.navigationItem.rightBarButtonItems = targetVC.navigationItem.rightBarButtonItems;
        viewController.navigationItem.title = targetVC.navigationItem.title;
        viewController.navigationItem.titleView = targetVC.navigationItem.titleView;
        
    }
    
    
    
    //    [(AKNavigationBar *)navigationController.navigationBar prepareBarViewForViewController:viewController];
    
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(AKNavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC {
    NSLog(@"%s",__PRETTY_FUNCTION__);
    // when a push occurs, wire the interaction controller to the to- view controller
    //    if (AppDelegateAccessor.navigationControllerInteractionController) {
    //        [AppDelegateAccessor.navigationControllerInteractionController wireToViewController:toVC forOperation:CEInteractionOperationPop];
    //    }
    
    if (navigationController.animationController) {
        navigationController.animationController.reverse = operation == UINavigationControllerOperationPop;
    }
    
    return navigationController.animationController;
}



- (id <UIViewControllerInteractiveTransitioning>)navigationController:(AKNavigationController *)navigationController
                          interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController {
    NSLog(@"%s",__PRETTY_FUNCTION__);
    // if we have an interaction controller - and it is currently in progress, return it
    id <UIViewControllerInteractiveTransitioning> controller = navigationController.interactionController && navigationController.interactionController.interactionInProgress ? navigationController.interactionController : nil;
    if ([controller isKindOfClass:[CEHorizontalSwipeInteractionController class]]) {
        [(CEHorizontalSwipeInteractionController *) controller setNavigationController:navigationController];
    }
    return controller;
}

@end
