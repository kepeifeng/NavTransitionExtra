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
#import "AKNavigationBar.h"
#import "NavigationController.h"
#import "SettingsViewController.h"

@interface ViewController () <UIViewControllerTransitioningDelegate>

@end

static int count;
static BOOL shouldShowNavigationBar = YES;
@implementation ViewController {
    NSArray* _colors;
    int _index;
    NSString * _name;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _index = count;
        _name = [NSString stringWithFormat:@"%d号", _index];
        count++;
    }
    return self;
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    if (self) {
        _index = count;
        _name = [NSString stringWithFormat:@"%d号", _index];
        count++;

    }
    
    return self;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*self.navigationItem.navigationBarHidden = shouldShowNavigationBar;
    shouldShowNavigationBar = !shouldShowNavigationBar;*/
    
    
//    _colors = @[[UIColor redColor],
//                [UIColor orangeColor],
//                [UIColor yellowColor],
//                [UIColor greenColor],
//                [UIColor blueColor],
//                [UIColor purpleColor]];
	
    UIColor * color = [UIColor colorWithRed:(arc4random_uniform(100)/100.0) green:(arc4random_uniform(100)/100.0) blue:(arc4random_uniform(100)/100.0) alpha:1.000];
    self.view.backgroundColor = color;
    self.textView.text = _name;
    
    
//    UIView * barView = [[UIView alloc] init];
    UIImageView * barView = [[UIImageView alloc] init];
//    barView.backgroundColor = [UIColor colorWithRed:(arc4random_uniform(100)/100.0) green:(arc4random_uniform(100)/100.0) blue:(arc4random_uniform(100)/100.0) alpha:1.000];
    barView.contentMode = UIViewContentModeScaleAspectFill;
    //        UIColor * color = [UIColor colorWithRed:(arc4random_uniform(100)/100.0) green:(arc4random_uniform(100)/100.0) blue:(arc4random_uniform(100)/100.0) alpha:1.000];
    barView.backgroundColor = self.view.backgroundColor;
    self.navigationItem.navigationBarView = barView;
    self.title = [NSString stringWithFormat:@"VC%@", _name];

    self.navigationItem.navigationBarHidden = (_index % 3 == 0);
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"Setting"] style:(UIBarButtonItemStylePlain) target:self action:@selector(setting:)];
    if (self.navigationItem.leftBarButtonItem == nil) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"Left"] style:(UIBarButtonItemStylePlain) target:self action:@selector(setting:)];
    }
    self.navigationItem.leftItemsSupplementBackButton = YES;
    
//    colorIndex  = (colorIndex + 1) % _colors.count;
}

//-(void)didMoveToParentViewController:(UIViewController *)parent{
//
//    [super didMoveToParentViewController:parent];
//    NSLog(@"%@ didMoveToParentViewController %@", _name, parent);
//}

-(void)setting:(id)sender{
    NSLog(@"setting tapped");
    
    ViewController * viewController = [[ViewController alloc] init];
    viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:(UIBarButtonItemStylePlain) target:self action:@selector(close:)];
    NavigationController * navController = [[NavigationController alloc] initWithRootViewController:viewController];
    navController.underStatusBar = YES;
    [self presentViewController:navController animated:YES completion:NULL];
    
}

-(void)close:(id)sender{

    [self.navigationController.presentedViewController dismissViewControllerAnimated:YES completion:NULL];
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
- (IBAction)popToRoot:(id)sender {
    
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

// - (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
//     return AppDelegateAccessor.settingsInteractionController && AppDelegateAccessor.settingsInteractionController.interactionInProgress ? AppDelegateAccessor.settingsInteractionController : nil;
// }


@end
