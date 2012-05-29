//
//  MasterViewController.m
//  test1
//
//  Created by Adrien Humilière on 21/05/12.
//  Copyright (c) 2012 home. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"

#import "SBJson.h"
#import "Podcast.h"
#import "Episode.h"

#import "AudioEpisodeViewController.h"
#import "EpisodesRecentsViewController.h"

#import "JacquetteDownloader.h"

@interface MasterViewController () {
    NSMutableArray *_objects;
}
@end

@implementation MasterViewController

@synthesize imageDownloadsInProgress;

extern AVPlayer *audioPlayer;
extern Episode *readingEpisode;

//@synthesize detailViewController = _detailViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		//self.title = NSLocalizedString(@"Freepod", @"Freepod");
	}
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	//self.navigationItem.leftBarButtonItem = self.editButtonItem;

	UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Player" style:UIBarButtonItemStylePlain target:self action:@selector(displayPlayer:)];
	self.navigationItem.rightBarButtonItem = addButton;

	
	//self.navigationItem.title = @"Freepod";
	
	self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.22 green:0.38 blue:0.47 alpha:1];
	UIImageView *logo=[[UIImageView alloc]initWithFrame:CGRectMake(74, 0, 172, 44)];
	logo.image=[UIImage imageNamed:@"logo_freepod_navbar_crop.png"];
	logo.tag = 42;
	[self.navigationController.navigationBar addSubview:logo];
	
	// Récupération de la liste des podcasts
	NSLog(@"Récupération JSON \"Liste des podcasts\"");
	NSMutableArray *podcastsList = [[NSMutableArray alloc] init];
	
	SBJsonParser* parser = [[SBJsonParser alloc] init];
	NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://webserv.freepod.net/get.php?podcasts"]];
	NSData* response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSString* jsonString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
	//NSLog(@"%@", jsonString);
	NSArray* podcasts = [parser objectWithString:jsonString error:nil];
	
	for (NSDictionary* podcast in  podcasts) {
		Podcast *newPodcast = [[Podcast alloc] init];
		NSLog(@"Récupération de %@",[podcast objectForKey:@"nom"]);
		
		[newPodcast setIdPodcast:[[podcast objectForKey:@"id"] intValue]];
		[newPodcast setNom:[podcast objectForKey:@"nom"]];
		[newPodcast setDescription:[podcast objectForKey:@"description"]];
		[newPodcast setExplicite:[podcast objectForKey:@"explicite"]];
		[newPodcast setUrlSite:[podcast objectForKey:@"url_site"]];
		[newPodcast setUrlFreepod:[podcast objectForKey:@"url_freepod"]];
		[newPodcast setLogoNormal:[podcast objectForKey:@"logo_normal"]];
		[newPodcast setLogoBanner:[podcast objectForKey:@"logo_banner"]];
		
		[podcastsList addObject:newPodcast];
		
		if (!_objects) {
			_objects = [[NSMutableArray alloc] init];
		}
		[_objects insertObject:newPodcast atIndex:0];
		NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
		[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
	}
	
	if (!_objects) {
		_objects = [[NSMutableArray alloc] init];
	}
	[_objects insertObject:[[EpisodesRecentsViewController alloc] init] atIndex:0];
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
	[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
	
	self.tableView.rowHeight = 80;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

// AFFICHE LE PLAYER
- (void)displayPlayer:(id)sender
{
	AudioEpisodeViewController *audioViewController = [[AudioEpisodeViewController alloc]initWithNibName:@"AudioEpisodeViewController" bundle:nil];
	
	audioViewController.episode = readingEpisode;
	audioViewController.precedentView = self.view;
	
	audioViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
	[self presentModalViewController:audioViewController animated:YES];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return _objects.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	 if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
    }
	
	if ([[_objects objectAtIndex:indexPath.row] class] == [Podcast class]) {
		Podcast *object = [_objects objectAtIndex:indexPath.row];
		cell.textLabel.text = [object description];
		//cell.imageView.image = [object getJacquette:160];
		if (!object.jacquette208) {
            if (self.tableView.dragging == NO && self.tableView.decelerating == NO) {
                [self startJacquetteDownload:object forIndexPath:indexPath andWith:208];
            }
            // if a download is deferred or in progress, return a placeholder image
            cell.imageView.image = [UIImage imageNamed:@"Placeholder.png"];                
        }
        else
        {
			cell.imageView.image = object.jacquette208;
        }
	} else { 
		cell.textLabel.text = @"Emissions récentes";
		cell.imageView.image = [[UIImage alloc] init];
	}
	cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}

- (void)startJacquetteDownload:(Podcast *)podcast forIndexPath:(NSIndexPath *)indexPath andWith:(int) width{
    JacquetteDownloader *jacquetteDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (jacquetteDownloader == nil) 
    {
        jacquetteDownloader = [[JacquetteDownloader alloc] init];
        jacquetteDownloader.podcast = podcast;
        jacquetteDownloader.indexPathInTableView = indexPath;
        jacquetteDownloader.delegate = self;
        [imageDownloadsInProgress setObject:jacquetteDownloader forKey:indexPath];
        [jacquetteDownloader startDownload:width];
    }
}

- (void)loadImagesForOnscreenRows {
	if ([_objects count] > 0) {
		NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
		for (NSIndexPath *indexPath in visiblePaths) {
			if ([[_objects objectAtIndex:indexPath.row] class] == [Podcast class]) {
				Podcast *podcast = [_objects objectAtIndex:indexPath.row];
				if (!podcast.jacquette208) {
					[self startJacquetteDownload:podcast forIndexPath:indexPath andWith:208];
				}
			}
		}
	}
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (CGFloat) tableView: (UITableView *) tableView heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
	if ([[_objects objectAtIndex:indexPath.row] class] == [Podcast class]) {
		return 80;
	} else { 
		return 50;
	}
}

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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[_objects objectAtIndex:indexPath.row] class] == [Podcast class]) {
		DetailViewController *detailViewController = [[DetailViewController alloc]initWithNibName:@"DetailViewController_iPhone" bundle:nil];
		
		Podcast *podcast = [_objects objectAtIndex:indexPath.row];
		
		detailViewController.detailItem = podcast;
		[self.navigationController pushViewController:detailViewController animated:YES];
	} else { 
		EpisodesRecentsViewController *detailViewController = [[EpisodesRecentsViewController alloc]initWithNibName:@"DetailViewController_iPhone" bundle:nil];
		
		[self.navigationController pushViewController:detailViewController animated:YES];
	}
}

- (void)jacquetteDidLoad:(NSIndexPath *)indexPath
{
    JacquetteDownloader *jacquetteDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (jacquetteDownloader != nil) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:jacquetteDownloader.indexPathInTableView];
        
        // Display the newly loaded image
        cell.imageView.image = jacquetteDownloader.podcast.jacquette208;
    }
	
	[self.tableView reloadData];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
	{
        [self loadImagesForOnscreenRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}

@end
