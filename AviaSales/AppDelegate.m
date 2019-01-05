//
//  AppDelegate.m
//  AviaSales
//
//  Created by Alex on 30/11/2018.
//  Copyright © 2018 Alex. All rights reserved.
//

#import "AppDelegate.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    CGRect frame = [UIScreen mainScreen].bounds;
    self.window = [[UIWindow alloc] initWithFrame: frame];
    
    TabBarController *firstViewController = [[TabBarController alloc] init];
    
    UINavigationController *navigationViewController = [[UINavigationController alloc] initWithRootViewController:firstViewController];
    
    self.window.rootViewController = navigationViewController;
    
    [self.window makeKeyAndVisible];
    
    [[NotificationCenter sharedInstance] registerService];

    return YES;
}


@end
