//
//  AppDelegate.m
//  iOS_Application_Security
//
//  Created by YenTing on 2022/2/16.
//

#import "AppDelegate.h"
#import "iOS_Application_Security-Swift.h"
#import "iOS_Application_Security-Bridging-Header.h"

@interface AppDelegate ()
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *rootViewController = [storyboard instantiateInitialViewController];
    UINavigationController *rootNavigationViewController = [[UINavigationController alloc]initWithRootViewController:rootViewController];
    self.window.rootViewController = rootNavigationViewController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
