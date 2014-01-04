//
//  PodcastViewController.m
//  freepod
//
//  Created by Adrien Humilière on 09/12/12.
//  Copyright (c) 2012 Freepod. All rights reserved.
//

#import "PodcastViewController.h"

@interface PodcastViewController ()

@end

@implementation PodcastViewController

- (id)initWithPodcast:(Podcast *)podcast {
    self = [super init];
    if (self) {
        _podcast = podcast;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onEpisodesListUpdate) name:NOTIFICATION_EPISODES_LIST_UPDATE object:_podcast];
		[[PodcastsManager instance] updatePodcast:podcast];
	}
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	UIRefreshControl * refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(onUpdateContent) forControlEvents:UIControlEventValueChanged];
	[refreshControl setTintColor:[UIColor freepodLightBlueColor]];
    self.refreshControl = refreshControl;
}

- (void)onUpdateContent {
	[[PodcastsManager instance] updatePodcast:_podcast];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onEpisodesListUpdate {
	[self.refreshControl endRefreshing];
	
	[self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [[_podcast episodes] count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    Episode * episode = [[_podcast episodes] objectAtIndex:indexPath.row];
    
	NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.adhumi.fr/api/get-img-episode.php?id=%d&nom=image&width=%f", [episode episodeId], [self tableView:tableView heightForRowAtIndexPath:indexPath] * [[UIScreen mainScreen] scale]]]];
	[NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
		if (connectionError) {
			NSLog(@"Error loading cover");
		} else {
			UIImage *image = [[UIImage alloc] initWithData:data scale:[[UIScreen mainScreen] scale]];
			
			[cell.imageView setImage:image];
		}
	}];
	
    cell.textLabel.text = [episode title];
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"d MMMM yyyy"];
	
    [cell.detailTextLabel setText:[dateFormatter stringFromDate:[episode pubDate]]];
	[cell.detailTextLabel setTextColor:[UIColor lightGrayColor]];
	
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Episode * episode = [[_podcast episodes] objectAtIndex:indexPath.row];
	
	[[PlayerViewController instance] playEpisode:episode];
	[self presentViewController:[PlayerMainViewController instance] animated:YES completion:nil];
}

@end
