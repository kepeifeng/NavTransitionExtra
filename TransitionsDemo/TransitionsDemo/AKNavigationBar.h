//
//  AKNavigationBar.h
//  WorldTravel
//
//  Created by Kent Peifeng Ke on 14/11/7.
//  Copyright (c) 2014年 Kent Peifeng Ke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationItem (BackgroundColor)
@property UIColor * navigationBarBackgroundColor;
@end

@interface AKNavigationBar : UINavigationBar


//- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;
//- (UIViewController *)popViewControllerAnimated:(BOOL)animated;
//- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated;
//- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated;
//@property (nonatomic) BOOL underStatusBar;
@property (nonatomic) CGFloat navComponentAlpha;
@property (nonatomic) CGRect backgroundRect;
@property (nonatomic, weak) UIView * backgroundView;
-(UIView *)barViewForViewController:(UIViewController *)viewController;
-(UIView *)prepareBarViewForViewController:(UIViewController *)viewController;

/*-(void)setFirstView:(UIView *)firstView secondView:(UIView *)secondView;*/
-(void)willTransitFromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC;
-(void)finishedTransitionFromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)viewController canceled:(BOOL)canceled;
//-(void)finishedTransitionFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController;
@property (nonatomic, copy) void (^defaultBarView)(UIView * view);


+(void(^)(UIView * view))defaultBarConfig;
+(void)setDefaultBarViewConfig:(void(^)(UIView * view))defaultBarConfig;
@end


/*@interface AKNavigationController : UINavigationController

@end*/

@interface AKBarButtonItem : UIBarButtonItem

@end


@interface UINavigationItem (Extension)
@property BOOL navigationBarHidden;
//@property UIColor * navigationBarColor;
//@property UIImage * navigationBarImage;
@property UIView * navigationBarView;

@end