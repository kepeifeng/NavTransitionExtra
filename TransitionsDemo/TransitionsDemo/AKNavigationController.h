//
//  AKNavigationControllerViewController.h
//  TransitionsDemo
//
//  Created by Colin Eberhardt on 10/09/2013.
//  Copyright (c) 2013 Colin Eberhardt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKNavigationBar.h"

@interface AKNavigationController : UINavigationController<UITabBarControllerDelegate>

@property (nonatomic, readonly) AKNavigationBar * navigationBar;

+(BOOL)underStatusBar;
+(void)setUnderStatusBar:(BOOL)underStatusBar;

@end
