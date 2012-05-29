//
//  AppDelegate.m
//  test1
//
//  Created by Adrien Humilière on 21/05/12.
//  Copyright (c) 2012 home. All rights reserved.
//

#import "AppDelegate.h"

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "Episode.h"
#import "EpisodesRecentsViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize navigationController = _navigationController;
@synthesize navigationControllerRecent = _navigationControllerRecent;
@synthesize splitViewController = _splitViewController;

AVPlayer *audioPlayer;
Episode *readingEpisode;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
	[[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleBlackOpaque];

//	MasterViewController *masterViewController = [[MasterViewController alloc] initWithNibName:@"MasterViewController_iPhone" bundle:nil];
//	self.navigationController = [[UINavigationController alloc] initWithRootViewController:masterViewController];
//	
//	self.window.rootViewController = self.navigationController;
//	[self.window makeKeyAndVisible];
//    return YES;
	
//	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    // Override point for customization after application launch.
//	[[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleBlackOpaque];
//	
	tabBarController = [[UITabBarController alloc] init]; 
	
	// Vue principale (Liste des podcasts)
	MasterViewController *masterViewController = [[MasterViewController alloc] initWithNibName:@"MasterViewController_iPhone" bundle:nil];
	self.navigationController = [[UINavigationController alloc] initWithRootViewController:masterViewController];
	self.navigationController.title = @"Podcasts";
	self.navigationController.tabBarItem.image = [UIImage imageNamed:@"icon-podcast.png"];
	
	// Vue secondaire (Liste des épisodes récents)
	EpisodesRecentsViewController *episodesRecentsViewController = [[EpisodesRecentsViewController alloc] initWithNibName:@"EpisodesRecentsViewController" bundle:nil];
	self.navigationControllerRecent = [[UINavigationController alloc] initWithRootViewController:episodesRecentsViewController];
	self.navigationControllerRecent.title = @"Récents";
	self.navigationControllerRecent.tabBarItem.image = [UIImage imageNamed:@"icon-recent.png"];
	
	tabBarController.viewControllers = [NSArray arrayWithObjects:self.navigationController, self.navigationControllerRecent, nil];
	
	self.window.rootViewController = tabBarController;
	[self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
