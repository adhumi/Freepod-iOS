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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onEpisodesListUpdate {
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Episode * episode = [[_podcast episodes] objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [episode title];
    
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
