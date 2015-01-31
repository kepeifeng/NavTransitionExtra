//
//  AKNavigationBar.m
//  WorldTravel
//
//  Created by Kent Peifeng Ke on 14/11/7.
//  Copyright (c) 2014年 Kent Peifeng Ke. All rights reserved.
//

#import "AKNavigationBar.h"
#import <objc/runtime.h>
#import "CamButton.h"
#import "CamView.h"

@implementation UINavigationItem (BackgroundColor)

-(UIColor *)navigationBarBackgroundColor{
    return objc_getAssociatedObject(self, @selector(navigationBarBackgroundColor));
}

-(void)setNavigationBarBackgroundColor:(UIColor *)navigationBarBackgroundColor{
    objc_setAssociatedObject(self, @selector(navigationBarBackgroundColor), navigationBarBackgroundColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
@implementation AKNavigationBar{
    NSMapTable * _barViewMapTable;
    UIView * _contentView;
}
@synthesize backgroundView = _myBackgroundView;

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        [self setupDefaultView];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupDefaultView];
    }
    return self;
}
-(void)setupDefaultView{
    
    self.navComponentAlpha = 1;
    self.backgroundColor = [UIColor clearColor];
    self.tintColor = [UIColor whiteColor];
    [self setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.clipsToBounds = NO;
    
    CGRect drawingRect;
    
    if ( floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1 && self.underStatusBar == NO)
    {
        // iOS 7
        CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
        drawingRect = CGRectMake(0, 0 - statusBarHeight, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) + statusBarHeight);
    }
    else
    {
        // iOS 6
        drawingRect = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    }
    
    
    _contentView = [[UIView alloc] initWithFrame:self.bounds];
    _contentView.userInteractionEnabled = NO;
    _contentView.exclusiveTouch = NO;
    [self addSubview:_contentView];
    
    
}

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_contentView != nil) {
        [self sendSubviewToBack:_contentView];
    }
    // allow all layout subviews call to adjust the frame
    /*if ( _backgroundView != nil )
     {
     
     CGRect rect;
     if ( floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1 && self.underStatusBar == NO)
     {
     // iOS 7
     CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
     rect = CGRectMake(0, 0 - statusBarHeight, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) + statusBarHeight);
     }
     else
     {
     // iOS 6
     rect = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
     }
     
     _backgroundView.frame = rect;
     [self sendSubviewToBack:_backgroundView];
     // make sure the graident layer is at position 1
     //        [self.layer insertSublayer:self.gradientLayer atIndex:1];
     
     }*/
    
    if (self.backItem != nil) {
        NSLog(@"Has Back Item");
    }else{
        NSLog(@"Has NOT Back Item");
    }
}


/*-(void)addSubview:(UIView *)view{
 
 
 //    [super addSubview:view];
 
 if (view == _backgroundView || view == _contentView) {
 [super addSubview:view];
 }else{
 [_contentView addSubview:view];
 }
 
 NSLog(@"Function Name: %s\nView:%@", __PRETTY_FUNCTION__, view);
 }
 
 
 
 -(void)insertSubview:(UIView *)view aboveSubview:(UIView *)siblingSubview{
 if (view == _backgroundView || view == _contentView) {
 [super insertSubview:view aboveSubview:siblingSubview];
 }else{
 [_contentView insertSubview:view aboveSubview:siblingSubview];
 }
 NSLog(@"Function Name: %s\nView:%@", __PRETTY_FUNCTION__, view);
 }
 
 -(void)insertSubview:(UIView *)view atIndex:(NSInteger)index{
 
 if (view == _backgroundView || view == _contentView) {
 [super insertSubview:view atIndex:index];
 //        [self newViewAdded:view];
 
 }else{
 [_contentView insertSubview:view atIndex:index];
 }
 NSLog(@"Function Name: %s\nView:%@", __PRETTY_FUNCTION__, view);
 }
 
 -(void)insertSubview:(UIView *)view belowSubview:(UIView *)siblingSubview{
 if (view == _backgroundView || view == _contentView) {
 [super insertSubview:view belowSubview:siblingSubview];
 }else{
 [_contentView insertSubview:view belowSubview:siblingSubview];
 }
 NSLog(@"Function Name: %s\nView:%@", __PRETTY_FUNCTION__, view);
 
 }*/

-(void)setNavComponentAlpha:(CGFloat)navComponentAlpha{
    
    self.alpha = navComponentAlpha;
    //    _navComponentAlpha = navComponentAlpha;
    //    _contentView.alpha = navComponentAlpha;
    //    for (UIView * view in self.subviews) {
    //        if (view == _backgroundView) {
    //            continue;
    //        }
    //        view.alpha = navComponentAlpha;
    //    }
    
    
}

/*-(void)newViewAdded:(UIView *)view{
 if (view!=_backgroundView) {
 //        view.hidden = (self.navComponentAlpha!=1);
 }
 }
 
 
 
 -(void)addSubview:(UIView *)view{
 
 if ((self.navComponentAlpha==1) || view ==_backgroundView) {
 [super addSubview:view];
 NSLog(@"addSubView:\n%@",view);
 }
 //    [self newViewAdded:view];
 
 }
 
 -(void)insertSubview:(UIView *)view aboveSubview:(UIView *)siblingSubview{
 [super insertSubview:view aboveSubview:siblingSubview];
 
 [self newViewAdded:view];
 }
 
 -(void)insertSubview:(UIView *)view atIndex:(NSInteger)index{
 if ((self.navComponentAlpha==1) || view ==_backgroundView) {
 [super insertSubview:view atIndex:index];
 [self newViewAdded:view];
 
 }
 }
 
 -(void)insertSubview:(UIView *)view belowSubview:(UIView *)siblingSubview{
 if ((self.navComponentAlpha==1) || view ==_backgroundView) {
 [super insertSubview:view belowSubview:siblingSubview];
 [self newViewAdded:view];
 }
 
 }
 
 -(void)setNavComponentAlpha:(CGFloat)navComponentAlpha{
 _navComponentAlpha = navComponentAlpha;
 for (UIView * view in self.subviews) {
 if (view == _backgroundView) {
 continue;
 }
 //        view.hidden = (navComponentAlpha!=1);
 //        view.alpha = navComponentAlpha;
 }
 }*/

-(UIView *)prepareBarViewForViewController:(UIViewController *)viewController
{
    UIViewController * targetVC = ([viewController isKindOfClass:[UITabBarController class]])?([(UITabBarController *)viewController selectedViewController]):viewController;
    
    
    UIView * barView = [self barViewForViewController:targetVC];
    
    if (barView) {
        barView.frame = CGRectMake(0, -44, 320, 44);
        //    barView.frame = _myBackgroundView.bounds;
        barView.opaque = NO;
        [viewController.view.layer addSublayer:barView.layer];
    }

    
    //    [self.superview insertSubview:barView belowSubview:self];
    //    [_backgroundView addSubview:barView];
//    return barView;
    return nil;
}



-(void)finishedTransitionToViewController:(UIViewController *)viewController
{
    UIView * view = [self barViewForViewController:viewController];
    
    for (UIView * subView in [_myBackgroundView.subviews copy]) {
        if (view == subView) {
            continue;
        }
        
        [subView removeFromSuperview];
    }
    
    if (view != nil && view.superview == nil) {
        [_myBackgroundView addSubview:view];
    }
}

-(UIView *)barViewForViewController:(UIViewController *)viewController
{
    
    if (!_barViewMapTable) {
        _barViewMapTable = [NSMapTable new];
    }
    
    if(viewController.navigationItem.navigationBarHidden){
        return nil;
    }
    
    UIView * barView = viewController.navigationItem.navigationBarView;
    //    UIView * barView = [_barViewMapTable objectForKey:viewController];
    //    if (!barView) {
    //        barView = [[UIView alloc] initWithFrame:self.bounds];
    ////        UIColor * color = [UIColor colorWithRed:(arc4random_uniform(100)/100.0) green:(arc4random_uniform(100)/100.0) blue:(arc4random_uniform(100)/100.0) alpha:1.000];
    //        barView.backgroundColor = viewController.view.backgroundColor;
    //        [_barViewMapTable setObject:barView forKey:viewController];
    //    }
    if (!barView) {
        barView = [_barViewMapTable objectForKey:viewController];
        if (!barView && self.defaultBarView) {
//            barView = self.defaultBarView();
            barView = [[UILabel alloc] initWithFrame:(CGRectMake(0, 0, 320, 44))];
            barView.backgroundColor = [UIColor yellowColor];
            [_barViewMapTable setObject:barView forKey:viewController];
        }
    }
    return barView;
    
}

-(void)setFirstView:(UIView *)firstView secondView:(UIView *)secondView
{
    
    
    if (firstView.superview != _myBackgroundView) {
        [_myBackgroundView addSubview:firstView];
    }
    
    if (secondView.superview != _myBackgroundView) {
        [_myBackgroundView addSubview:secondView];
    }
    
    [_myBackgroundView bringSubviewToFront:secondView];
    [_myBackgroundView bringSubviewToFront:firstView];
     

}



@end

@implementation AKNavigationController

-(NSArray *)popToRootViewControllerAnimated:(BOOL)animated{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    return [super popToRootViewControllerAnimated:animated];
}

-(UIViewController *)popViewControllerAnimated:(BOOL)animated{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    return [super popViewControllerAnimated:animated];
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    [super pushViewController:viewController animated:animated];
}

-(NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    return [super popToViewController:viewController animated:animated];
}

@end

@implementation AKBarButtonItem

-(instancetype)initWithImage:(UIImage *)image style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action{
    
    CamButton * button = [[CamButton alloc] init];
    [button setImage:image
            forState:(UIControlStateNormal)];
    [button addTarget:self action:@selector(action) forControlEvents:(UIControlEventTouchUpInside)];
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    [button sizeToFit];
    CGRect buttonRect = button.bounds;
    buttonRect.size.width += 10;
    buttonRect.size.height = 31;
    self = [super initWithCustomView:button];
    if (self) {
        
    }
    return self;
}

-(instancetype)initWithTitle:(NSString *)title style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action{
    CamButton * button = [[CamButton alloc] init];
    [button setTitle:title
            forState:(UIControlStateNormal)];
    [button addTarget:self action:@selector(action) forControlEvents:(UIControlEventTouchUpInside)];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    
    button.titleLabel.layer.shadowColor = [[UIColor colorWithWhite:0.000 alpha:1] CGColor];
    button.titleLabel.layer.shadowOffset = CGSizeMake(1/[[UIScreen mainScreen] scale], 1/[[UIScreen mainScreen] scale]);
    button.titleLabel.layer.shadowRadius = 1;
    button.titleLabel.layer.shadowOpacity = 1;
    button.titleLabel.layer.masksToBounds = NO;
    //    [button setTitleShadowColor:[UIColor colorWithWhite:0.000 alpha:0.650] forState:UIControlStateNormal];
    //    button.titleLabel.shadowOffset = CGSizeMake(1.0, 1.0);
    
    
    [button sizeToFit];
    CGRect buttonRect = button.bounds;
    buttonRect.size.width += 10;
    buttonRect.size.height = 31;
    
    button.frame = buttonRect;
    self = [super initWithCustomView:button];
    if (self) {
        
    }
    return self;
}




@end

@implementation UINavigationItem (Extension)


- (BOOL)navigationBarHidden {
    return [objc_getAssociatedObject(self, @selector(navigationBarHidden)) boolValue];
}

- (void)setNavigationBarHidden: (BOOL)navigationBarHidden {
    objc_setAssociatedObject(self, @selector(navigationBarHidden), @(navigationBarHidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}



//- (UIImage *)navigationBarImage {
//    return objc_getAssociatedObject(self, @selector(navigationBarImage));
//}
//
//- (void)setNavigationBarImage: (UIImage *)navigationBarImage {
//    objc_setAssociatedObject(self, @selector(navigationBarImage), navigationBarImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}
//
//
//- (UIColor *) navigationBarColor {
//    return objc_getAssociatedObject(self, @selector(navigationBarColor));
//}
//
//- (void)setnavigationBarColor: (UIColor *)navigationBarColor {
//    objc_setAssociatedObject(self, @selector(navigationBarColor), navigationBarColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}


- (UIView *)navigationBarView {
    return objc_getAssociatedObject(self, @selector(navigationBarView));
}

- (void)setNavigationBarView: (UIView *)navigationBarView {
    objc_setAssociatedObject(self, @selector(navigationBarView), navigationBarView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}




@end
