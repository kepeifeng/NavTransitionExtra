//
//  CamButton.m
//  2bulu-NewAssistant
//
//  Created by Kent Peifeng Ke on 1/8/15.
//  Copyright (c) 2015 魏新杰. All rights reserved.
//

#import "CamButton.h"

@implementation CamButton

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.textColor = [UIColor whiteColor];
    }
    return self;
}
-(void)setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    [super drawRect:rect];
    // Drawing code
    //// General Declarations
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGFloat borderWidth = 1/[[UIScreen mainScreen] scale];
    CGFloat borderWidth = 1;
    //// Color Declarations
    UIColor* highlightShadowColor = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 0.75];

    UIColor* gradientColor, * gradientColor2;
    if (self.highlighted) {
        gradientColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.7];
        gradientColor2 = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.3];
    }else{
        gradientColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.314];
        gradientColor2 = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.706];
    }

    
    //// Gradient Declarations
    CGFloat gradientLocations[] = {0, 1};
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)@[(id)gradientColor.CGColor, (id)gradientColor2.CGColor], gradientLocations);
    
    //// Shadow Declarations
    UIColor* highlightShadow = highlightShadowColor;
    CGSize highlightShadowOffset = CGSizeMake(0,0.5);
//    CGSize highlightShadowOffset = CGSizeMake(0.1, 1.1);
    CGFloat highlightShadowBlurRadius = 1;
    
    //// Image Declarations
    UIImage* camButton = [UIImage imageNamed: @"cam_button_bg.jpg"];
    
    //// Rectangle Drawing
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectInset(self.bounds, 0.5, 0.5) cornerRadius: 5];
    CGContextSaveGState(context);
    [UIColor.blackColor setStroke];
    rectanglePath.lineWidth = borderWidth;
    [rectanglePath stroke];
    
    [rectanglePath addClip];
    

    
//    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawTiledImage(context, CGRectMake(0, 0, camButton.size.width, camButton.size.height), camButton.CGImage);

    CGContextDrawLinearGradient(context, gradient, CGPointMake(0, -0), CGPointMake(0, CGRectGetHeight(self.bounds)), 0);
    CGContextRestoreGState(context);
    
    ////// Rectangle Inner Shadow
    CGContextSaveGState(context);
    UIRectClip(rectanglePath.bounds);
    CGContextSetShadowWithColor(context, CGSizeZero, 0, NULL);
    
    CGContextSetAlpha(context, CGColorGetAlpha([highlightShadow CGColor]));
    CGContextBeginTransparencyLayer(context, NULL);
    {
        UIColor* opaqueShadow = [highlightShadow colorWithAlphaComponent: 1];
        CGContextSetShadowWithColor(context, highlightShadowOffset, highlightShadowBlurRadius, [opaqueShadow CGColor]);
        CGContextSetBlendMode(context, kCGBlendModeSourceOut);
        CGContextBeginTransparencyLayer(context, NULL);
        
        [opaqueShadow setFill];
        [rectanglePath fill];
        
        CGContextEndTransparencyLayer(context);
    }
    CGContextEndTransparencyLayer(context);
    CGContextRestoreGState(context);
    

    
    
    //// Cleanup
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);

    
}


@end
