//
//  EpisodesRecentsViewController.m
//  test1
//
//  Created by Adrien Humilière on 28/05/12.
//  Copyright (c) 2012 home. All rights reserved.
//

#import "EpisodesRecentsViewController.h"

#import "SBJson.h"
#import "Episode.h"

#import "AudioEpisodeViewController.h"

@interface EpisodesRecentsViewController () {
    NSMutableArray *_objects;
}

@end

@implementation EpisodesRecentsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	
	// Récupération de la liste des épisodes
	SBJsonParser* parser = [[SBJsonParser alloc] init];
	NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://webserv.freepod.net/get.php?episode_recent=15"]]];
	NSData* response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSString* jsonString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
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
		[newEpisode setLastUpdateFromString:[episode objectForKey:@"pubDate"]];
		
		if (!_objects) {
			_objects = [[NSMutableArray alloc] init];
		}
		[_objects addObject:newEpisode];
	}
	
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
	[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
	
	
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	
	self.tableView.rowHeight = 60;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
    }
	
	Episode *object = [_objects objectAtIndex:indexPath.row];
	cell.textLabel.text = [object description];
	cell.imageView.image = [object getJacquette:120];
	cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}

- (CGFloat) tableView: (UITableView *) tableView heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
	return 60;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AudioEpisodeViewController *audioViewController = [[AudioEpisodeViewController alloc]initWithNibName:@"AudioEpisodeViewController" bundle:nil];
	
	Episode *episode = [_objects objectAtIndex:indexPath.row];
	
	audioViewController.episode = episode;
    [self.navigationController pushViewController:audioViewController animated:YES];
}

@end
