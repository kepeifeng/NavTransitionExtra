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
    UIView * _backgroundView;
}


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
    
    self.tintColor = [UIColor whiteColor];
    [self setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.clipsToBounds = NO;
    
    CGRect drawingRect;
    
    if ( floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1 )
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
    UIView * backgroundView = [[CamView alloc] initWithFrame:drawingRect];
//    backgroundView.backgroundColor = [UIColor yellowColor];
    backgroundView.userInteractionEnabled = NO;
    [self addSubview:backgroundView];
    
    _backgroundView = backgroundView;

}

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    NSLog(@"%@\nYa!It's me! LayoutSubviews",self);

    // allow all layout subviews call to adjust the frame
    if ( _backgroundView != nil )
    {
        
        CGRect rect;
        if ( floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1 )
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
        
    }
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