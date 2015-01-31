//
//  AKTabBar.m
//  TransitionsDemo
//
//  Created by Kent Peifeng Ke on 1/22/15.
//  Copyright (c) 2015 Colin Eberhardt. All rights reserved.
//

#import "AKTabBar.h"
#import "CamView.h"

@implementation AKTabBar{
    UIView * _backgroundView;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
    
    
    CGRect drawingRect;
    
    drawingRect = self.bounds;
    
    //    if ( floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1 )
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
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Color Declarations
    UIColor* gradientColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.314];
    UIColor* gradientColor2 = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.706];
    UIColor* spotLight = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 0.2];
    
    //// Gradient Declarations
    CGFloat gradientLocations[] = {0, 1};
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)@[(id)gradientColor.CGColor, (id)gradientColor2.CGColor], gradientLocations);
    //// Image Declarations
    UIImage* camButton = [UIImage imageNamed: @"cam_button_bg.jpg"];
    
    //// Rectangle Drawing
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: drawingRect];
    CGContextSaveGState(context);
    [rectanglePath addClip];
    //    CGContextDrawTiledImage(context, CGRectMake(0, 0, camButton.size.width, camButton.size.height), camButton.CGImage);
    CGContextDrawTiledImage(context, CGRectMake(0, 0, camButton.size.width, camButton.size.height), camButton.CGImage);
    
    
    CGContextDrawLinearGradient(context, gradient, CGPointMake(0, -0), CGPointMake(0, CGRectGetHeight(drawingRect)), 0);
    CGContextRestoreGState(context);
    
    //Inner border
    [[UIColor colorWithWhite:0.000 alpha:0.400] setStroke];
    rectanglePath.lineWidth = 2;
    //    [rectanglePath stroke];
    
    
    //// Rectangle 2 Drawing
    //    CGRect spotLightRect = self.bounds;
    //    CGRect spotLightRect = CGRectInset(drawingRect, 1, 1);
    CGRect spotLightRect = drawingRect;
    spotLightRect.size.height = spotLightRect.size.height/2;
    UIBezierPath* rectangle2Path = [UIBezierPath bezierPathWithRect: spotLightRect];
    [spotLight setFill];
    [rectangle2Path fill];
    
    
    //// Cleanup
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    
    
    
}


-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

//
//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    NSLog(@"%@\nYa!It's me! LayoutSubviews",self);
//    
//    // allow all layout subviews call to adjust the frame
//    if ( _backgroundView != nil )
//    {
//        
//        CGRect rect;
//        
//        rect = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
//        _backgroundView.frame = rect;
//        [self sendSubviewToBack:_backgroundView];
//        // make sure the graident layer is at position 1
//        //        [self.layer insertSublayer:self.gradientLayer atIndex:1];
//        
//    }
//}
//

@end
