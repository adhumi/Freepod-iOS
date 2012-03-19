//
//  AppDelegate.m
//  Freepod
//
//  Created by Adrien Humilière on 14/03/12.
//  Copyright (c) 2012 home. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"
#import "SBJson.h"
#import "Podcast.h"
#import "Episode.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
	    self.viewController = [[ViewController alloc] initWithNibName:@"ViewController_iPhone" bundle:nil];
	} else {
	    self.viewController = [[ViewController alloc] initWithNibName:@"ViewController_iPad" bundle:nil];
	}
	self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
	
	// Récupération de la liste des podcasts
	NSLog(@"Récupération JSON \"Liste des podcasts\"");
	podcastsList = [[NSMutableArray alloc] init];
	
	SBJsonParser* parser = [[SBJsonParser alloc] init];
	NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://webserv.freepod.net/get.php?podcasts"]];
	NSData* response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSString* jsonString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
	//NSLog(@"%@", jsonString);
	NSArray* podcasts = [parser objectWithString:jsonString error:nil];
	
	for (NSDictionary* podcast in  podcasts) {
		Podcast *newPodcast = [[Podcast alloc] init];
		NSLog(@"### Parsing de %@",[podcast objectForKey:@"nom"]);
		
		[newPodcast setIdPodcast:[[podcast objectForKey:@"id"] intValue]];
		[newPodcast setNom:[podcast objectForKey:@"nom"]];
		[newPodcast setDescription:[podcast objectForKey:@"description"]];
		[newPodcast setExplicite:[podcast objectForKey:@"explicite"]];
		[newPodcast setUrlSite:[podcast objectForKey:@"url_site"]];
		[newPodcast setUrlFreepod:[podcast objectForKey:@"url_freepod"]];
		[newPodcast setLogoNormal:[podcast objectForKey:@"logo_normal"]];
		[newPodcast setLogoBanner:[podcast objectForKey:@"logo_banner"]];
		
		// Récupération de la liste des épisodes
		request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://webserv.freepod.net/get.php?episodes=%@", [podcast objectForKey:@"id"]]]];
		response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
		jsonString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
		NSArray* episodes = [parser objectWithString:jsonString error:nil];
		
		for (NSDictionary* episode in episodes) {
			Episode *newEpisode = [[Episode alloc] init];
			NSLog(@"%@",[episode objectForKey:@"title"]);
			
			[newEpisode setIdEpisode:[[episode objectForKey:@"id"] intValue]];
			[newEpisode setIdPodcast:[[episode objectForKey:@"id_podcast"] intValue]];
			[newEpisode setTitle:[episode objectForKey:@"title"]];
			[newEpisode setURL:[episode objectForKey:@"url"]];
			[newEpisode setType:[episode objectForKey:@"type"]];
			[newEpisode setDescription:[episode objectForKey:@"description"]];
			[newEpisode setAuthor:[episode objectForKey:@"author"]];
			[newEpisode setExplicite:[episode objectForKey:@"explicite"]];
			[newEpisode setDuration:[episode objectForKey:@"duration"]];
			[newEpisode setImage:[episode objectForKey:@"newImage"]];
			[newEpisode setKeywords:[episode objectForKey:@"keywords"]];
			
			[newPodcast addEpisode:newEpisode];
		}
		
		[podcastsList addObject:newPodcast];
	}
	
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];
	
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	/*
	 Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	 Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	 */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	/*
	 Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	 If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	 */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	/*
	 Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	 */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	/*
	 Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	 */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	/*
	 Called when the application is about to terminate.
	 Save data if appropriate.
	 See also applicationDidEnterBackground:.
	 */
}

@end
