//
//  ViewController.m
//  ViewControllerTransitions
//
//  Created by Colin Eberhardt on 08/09/2013.
//  Copyright (c) 2013 Colin Eberhardt. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "CEBaseInteractionController.h"

@interface ViewController () <UIViewControllerTransitioningDelegate>

@end

static int colorIndex = 0;
static int count;
static BOOL shouldShowNavigationBar = YES;
@implementation ViewController {
    NSArray* _colors;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.navigationBarHidden = shouldShowNavigationBar;
    shouldShowNavigationBar = !shouldShowNavigationBar;
//    _colors = @[[UIColor redColor],
//                [UIColor orangeColor],
//                [UIColor yellowColor],
//                [UIColor greenColor],
//                [UIColor blueColor],
//                [UIColor purpleColor]];
	
    UIColor * color = [UIColor colorWithRed:(arc4random_uniform(100)/100.0) green:(arc4random_uniform(100)/100.0) blue:(arc4random_uniform(100)/100.0) alpha:1.000];
    self.view.backgroundColor = color;
    self.textView.text = [NSString stringWithFormat:@"%d号", count];
    count++;
    
    
    
//    colorIndex  = (colorIndex + 1) % _colors.count;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"ShowSettings"]) {
        UIViewController *toVC = segue.destinationViewController;
        toVC.transitioningDelegate = self;
    }
    
    [super prepareForSegue:segue sender:sender];
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    
    if (AppDelegateAccessor.settingsInteractionController) {
        [AppDelegateAccessor.settingsInteractionController wireToViewController:presented forOperation:CEInteractionOperationDismiss];
    }
    
    AppDelegateAccessor.settingsAnimationController.reverse = NO;
    return AppDelegateAccessor.settingsAnimationController;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    AppDelegateAccessor.settingsAnimationController.reverse = YES;
    return AppDelegateAccessor.settingsAnimationController;
 }
- (IBAction)backButtonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

// - (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
//     return AppDelegateAccessor.settingsInteractionController && AppDelegateAccessor.settingsInteractionController.interactionInProgress ? AppDelegateAccessor.settingsInteractionController : nil;
// }


@end
