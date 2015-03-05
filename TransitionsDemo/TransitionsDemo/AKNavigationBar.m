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

static void(^_gDefaultBarConfig)(UIView * view) ;

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
    
    UIView * _backgroundView;
    
    NSMutableArray * _backgroundViews;
    
    CALayer * _layerForFromVC;
    CALayer * _layerForToVC;
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
    self.barTintColor = [UIColor clearColor];
    [self setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.clipsToBounds = NO;
    
//    CGRect drawingRect;
//    
//    if ( floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
//    {
//        // iOS 7
//        CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
//        drawingRect = CGRectMake(0, 0 - statusBarHeight, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) + statusBarHeight);
//    }
//    else
//    {
//        // iOS 6
//        drawingRect = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
//    }
    
    
    _backgroundView = [[UIView alloc] initWithFrame:self.bounds];
    _backgroundView.userInteractionEnabled = NO;
    _backgroundView.exclusiveTouch = NO;
    [self addSubview:_backgroundView];
    
    
}

-(void)drawRect:(CGRect)rect{
//    [super drawRect:rect];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_contentView != nil) {
        [self sendSubviewToBack:_contentView];
    }
    // allow all layout subviews call to adjust the frame
    if ( _backgroundView != nil )
     {
     
//     CGRect rect;
//     if ( floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
//     {
//     // iOS 7
//     CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
//     rect = CGRectMake(0, 0 - statusBarHeight, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) + statusBarHeight);
//     }
//     else
//     {
//     // iOS 6
//     rect = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
//     }
//     
     _backgroundView.frame = self.backgroundRect;
     [self sendSubviewToBack:_backgroundView];
     // make sure the graident layer is at position 1
     //        [self.layer insertSublayer:self.gradientLayer atIndex:1];
     
     }
    
    /*if (self.backItem != nil) {
        NSLog(@"Has Back Item");
    }else{
        NSLog(@"Has NOT Back Item");
    }*/
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


-(CGFloat)navComponentAlpha{
    return self.alpha;
}
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

+(void(^)(UIView * view))defaultBarConfig
{
    return _gDefaultBarConfig;
}

+(void)setDefaultBarViewConfig:(void(^)(UIView * view))defaultBarConfig
{
    
    _gDefaultBarConfig = defaultBarConfig;
	
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

-(void)setHidden:(BOOL)hidden{
    [super setHidden:hidden];

    
}
-(UIView *)prepareBarViewForViewController:(UIViewController *)viewController layer:(CALayer **)layer
{
    
    
    UIViewController * targetVC = ([viewController isKindOfClass:[UITabBarController class]])?([(UITabBarController *)viewController selectedViewController]):viewController;
    
//    CALayer * layer = [viewController.view.layer valueForKey:@"AKNavBackgroundLayer"];
//    if (layer) {
//        return nil;
//    }
    UIView * barView = [self barViewForViewController:targetVC];
    
    if (barView) {
        CGFloat height = CGRectGetMaxY(self.backgroundRect);
//        barView.frame = CGRectMake(0, -height, CGRectGetWidth([[UIScreen mainScreen] bounds]), height);
        barView.frame = CGRectMake(0, -height, CGRectGetWidth([[UIScreen mainScreen] bounds]), height);
        barView.opaque = NO;
        
        viewController.view.clipsToBounds = NO;
        viewController.view.layer.masksToBounds = NO;
        
        *layer = barView.layer;
        [viewController.view.layer addSublayer:*layer];

        NSLog(@"Layer Count:%lu", (unsigned long)viewController.view.layer.sublayers.count);
        
//        [viewController.view addObserver:self forKeyPath:@"frame" options:(NSKeyValueObservingOptionNew) context:nil];
//        [viewController.view.layer setValue:barView.layer forKey:@"AKNavBackgroundLayer"];
    }

    
    //    [self.superview insertSubview:barView belowSubview:self];
    //    [_backgroundView addSubview:barView];
//    return barView;
    return barView;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{

    if ([object isKindOfClass:[UIView class]] && [keyPath isEqualToString:@"frame"]) {
        
        UIView * view =(UIView *)object;
        CGRect frame = [[change objectForKey:NSKeyValueChangeNewKey] CGRectValue];
//        CALayer * layer = [[[view layer] sublayers] firstObject];
        CALayer * layer = [view.layer valueForKey:@"AKNavBackgroundLayer"];

        CGFloat height = CGRectGetMaxY(self.backgroundRect);
        if (layer) {
            layer.frame = CGRectMake(0, 20, CGRectGetWidth([[UIScreen mainScreen] bounds]), height);
        }
        
    }
}


-(void)willTransitFromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{

    [_backgroundView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    if (self.hidden == YES) {
        return;
    }
    CALayer * toLayer, * fromLayer;
    UIView * fromBarView = [self prepareBarViewForViewController:fromVC layer:&fromLayer];
    UIView * toBarView = [self prepareBarViewForViewController:toVC layer:&toLayer];
    
    
    
    _layerForToVC = toLayer;
    _layerForFromVC = fromLayer;
    
}

-(void)finishedTransitionFromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)viewController canceled:(BOOL)canceled
{
    
//    CALayer * toLayer = [viewController.view.layer valueForKey:@"AKNavBackgroundLayer"];
//    if (toLayer) {
//        [toLayer removeFromSuperlayer];
//        [viewController.view.layer needsDisplay];
//    }
//    
//    CALayer * fromLayer = [fromVC.view.layer valueForKey:@"AKNavBackgroundLayer"];
//    if (fromLayer) {
//        [fromLayer removeFromSuperlayer];
//        [fromVC.view.layer needsDisplay];
//    }
//
    if (_layerForToVC) {
        [_layerForToVC removeFromSuperlayer];
        _layerForToVC = nil;
    }
    if (_layerForFromVC) {
        [_layerForFromVC removeFromSuperlayer];
        _layerForFromVC = nil;
    }
    
    UIView * view;
    if (canceled) {
        view = [self barViewForViewController:fromVC];
    }else{
        view = [self barViewForViewController:viewController];
    }

    view.frame = _backgroundView.bounds;
    [_backgroundView addSubview:view];
    
}



-(void)finishedTransitionToViewController:(UIViewController *)viewController
{
    UIView * view = [self barViewForViewController:viewController];
    
    for (UIView * subView in [_backgroundView.subviews copy]) {
        if (view == subView) {
            continue;
        }
        
        [subView removeFromSuperview];
    }
    
    if (view != nil && view.superview == nil) {
        [_backgroundView addSubview:view];
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

    if (!barView) {
        
        barView = [self getBackgroundView];
    }
    return barView;
    
}

-(UIView *)getBackgroundView{

    
    UIView * bgView;
    for (UIView * view in _backgroundViews) {
        if (view.layer.superlayer == nil) {
            bgView = view;
            break;
        }
    }
    
    if (!bgView) {
        
        UIView * view = [[UIView alloc] initWithFrame:self.backgroundRect];
        if ((self.defaultBarView || [[self class] defaultBarConfig])) {
            if (self.defaultBarView) {
                self.defaultBarView(view);
            }else if ([self.class defaultBarConfig]) {
                
                ([self.class defaultBarConfig])(view);
            }
        }
        
        if (!_backgroundViews) {
            _backgroundViews = [NSMutableArray new];
        }
        
        [_backgroundViews addObject:view];
        bgView = view;
    }
    
    return bgView;
}

/*-(void)setFirstView:(UIView *)firstView secondView:(UIView *)secondView
{
    
    
    if (firstView.superview != _myBackgroundView) {
        [_myBackgroundView addSubview:firstView];
    }
    
    if (secondView.superview != _myBackgroundView) {
        [_myBackgroundView addSubview:secondView];
    }
    
    [_myBackgroundView bringSubviewToFront:secondView];
    [_myBackgroundView bringSubviewToFront:firstView];
     

}*/



@end

/*@implementation AKNavigationController

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

@end*/

@implementation AKBarButtonItem



-(instancetype)initWithTitle:(NSString *)title style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action{
    CamButton * button = [CamButton barButtonWithTitle:title];
    [button addTarget:target action:action forControlEvents:(UIControlEventTouchUpInside)];
    
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
