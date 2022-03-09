//
//  ViewController.m
//  iOS_Application_Security
//
//  Created by YenTing on 2022/2/16.
//

#import "RootViewController.h"
#import "iOS_Application_Security-Swift.h"
#import "AntiDebug.h"

@interface RootViewController () <menuDelegate>
@property UIViewController *rootViewController;
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addHomeViewcontroller];
    [self setNavigationBar];
   
}

- (void)setNavigationBar {
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.toolbar.translucent = NO;
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(showMenu:)]];
}

- (void)addHomeViewcontroller {
    OCHomeViewController *homeViewController = [OCHomeViewController shared];
    [homeViewController.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addChildViewController: homeViewController];
    [self.view addSubview:homeViewController.view];
    [homeViewController didMoveToParentViewController:self];
    [NSLayoutConstraint addConstraints:homeViewController.view toView:self.view withConstants:nil];
}

- (void)showMenu:(UIBarButtonItem *)sender {
    [self presentMenu];
}

- (void)presentMenu {
    OCMenuViewController *menuViewController = [OCMenuViewController new];
    menuViewController.delegate = self;
    [self.navigationController pushViewController:menuViewController animated:YES];
}

- (void)optionTapped:(enum MenuItem)menuItem {
    switch(menuItem) {
        case MenuItemJailbreak: {
            OCJailbreakViewController *jailbreakViewController = [OCJailbreakViewController new];
            jailbreakViewController.checker = [OCJailbreakFileChecker new];
            [self presentFunctionView:jailbreakViewController];
            break;
        }
        case MenuItemHook: {
            OCDebugViewController *debugViewController = [OCDebugViewController new];
            debugViewController.checker = [OCHookChecker new];
            [self presentFunctionView:debugViewController];
            break;
        }
            
        case MenuItemDebugMode: {
            OCDebugViewController *debugViewController = [OCDebugViewController new];
            debugViewController.checker = [AntiDebug new];
            [self presentFunctionView:debugViewController];
            break;
        }
        default:
            break;
    }
}

- (void)presentFunctionView:(UIViewController*) viewController {
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
