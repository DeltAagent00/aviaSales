//
//  TabBarControllerTableViewController.m
//  AviaSales
//
//  Created by Alex on 03/01/2019.
//  Copyright © 2019 Alex. All rights reserved.
//

#import "TabBarController.h"

@implementation TabBarController

-(instancetype)init {
    self = [super initWithNibName:nil bundle:nil];
    
    if (self) {
        self.viewControllers = [self createViewControllers];
        self.tabBar.tintColor = [UIColor blackColor];
    }
    
    return self;
}

-(NSArray<UIViewController *> *) createViewControllers {
    NSMutableArray<UIViewController *> *controllers = [NSMutableArray new];
    
    MainViewController *mainViewController = [[MainViewController alloc] init];
    mainViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:[@"search_tab" localize] image:[UIImage imageNamed:@"search"] selectedImage:[UIImage imageNamed:@"search_selected"]];
    
    UINavigationController *mainNavigationController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
    [controllers addObject:mainNavigationController];
    
    
    MapViewController *mapViewController = [[MapViewController alloc] init];
    mapViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:[@"map_tab" localize] image:[UIImage imageNamed:@"map"] selectedImage:[UIImage imageNamed:@"map_selected"]];
    
    UINavigationController *mapNavigationController = [[UINavigationController alloc] initWithRootViewController:mapViewController];
    [controllers addObject:mapNavigationController];
    
    TicketsViewController *favoriteViewController = [[TicketsViewController alloc] initFavoriteTicketsController];
    favoriteViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:[@"favorites_tab" localize] image:[UIImage imageNamed:@"favorite"] selectedImage:[UIImage imageNamed:@"favorite_selected"]];
    
    UINavigationController *favoriteNavigationController = [[UINavigationController alloc] initWithRootViewController:favoriteViewController];
    [controllers addObject:favoriteNavigationController];
    
    return controllers;
}

@end
