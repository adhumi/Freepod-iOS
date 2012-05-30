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
#import "PodcastCell.h"
#import <QuartzCore/QuartzCore.h>

#define REFRESH_HEADER_HEIGHT 52.0f

@interface MasterViewController () {
    NSMutableArray *_objects;
}
@end

@implementation MasterViewController
@synthesize textPull, textRelease, textLoading, refreshHeaderView, refreshLabel, refreshArrow, refreshSpinner;

@synthesize imageDownloadsInProgress;

extern AVPlayer *audioPlayer;
extern Episode *readingEpisode;

//@synthesize detailViewController = _detailViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		[self setupStrings];
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
		[newPodcast setLastUpdateFromString:[podcast objectForKey:@"lastUpdate"]];
		
		[podcastsList addObject:newPodcast];
		
		if (!_objects) {
			_objects = [[NSMutableArray alloc] init];
		}
		[_objects insertObject:newPodcast atIndex:0];
		NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
		[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
		
		[self addPullToRefreshHeader];
	}
	
//	if (!_objects) {
//		_objects = [[NSMutableArray alloc] init];
//	}
//	[_objects insertObject:[[EpisodesRecentsViewController alloc] init] atIndex:0];
//	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//	[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//	
	self.tableView.rowHeight = 80;
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
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
    
    PodcastCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

	if (cell == nil) {
			NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PodcastCell" owner:self options:nil];
			cell = (PodcastCell *)[nib objectAtIndex:0];
		}
	
	
		Podcast *object = [_objects objectAtIndex:indexPath.row];
		cell.nom.text = [object nom];
		cell.lastUpdate.text = [NSString stringWithFormat:@"Dernière émission : %@",[object formattedLastUpadate]];
		if (!object.jacquette208) {
            if (self.tableView.dragging == NO && self.tableView.decelerating == NO) {
                [self startJacquetteDownload:object forIndexPath:indexPath andWith:160];
            }
            // if a download is deferred or in progress, return a placeholder image
            cell.jacquette.image = [UIImage imageNamed:@"jacquette_default_160.png"];                
        }
        else
        {
			cell.jacquette.image = object.jacquette208;
        }
		return cell;
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
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	if ([[_objects objectAtIndex:indexPath.row] class] == [Podcast class]) {
		DetailViewController *detailViewController = [[DetailViewController alloc]initWithNibName:@"DetailViewController_iPhone" bundle:nil];
		
		Podcast *podcast = [_objects objectAtIndex:indexPath.row];
		
		detailViewController.detailItem = podcast;
		[self.navigationController pushViewController:detailViewController animated:YES];
	} else { 
		EpisodesRecentsViewController *detailViewController = [[EpisodesRecentsViewController alloc]initWithNibName:@"DetailViewController_iPhone" bundle:nil];
		
		[self.navigationController pushViewController:detailViewController animated:YES];
	}
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)jacquetteDidLoad:(NSIndexPath *)indexPath
{
    JacquetteDownloader *jacquetteDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (jacquetteDownloader != nil) {
        PodcastCell *cell = (PodcastCell*) [self.tableView cellForRowAtIndexPath:jacquetteDownloader.indexPathInTableView];
        
        // Display the newly loaded image
        cell.jacquette.image = jacquetteDownloader.podcast.jacquette208;
    }
	
	[self.tableView reloadData];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
	{
        [self loadImagesForOnscreenRows];
	}
	
	if (isLoading) return;
    isDragging = NO;
    if (scrollView.contentOffset.y <= -REFRESH_HEADER_HEIGHT) {
        // Released above the header
        [self startLoading];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
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

- (void)setupStrings{
	textPull = [[NSString alloc] initWithString:@"Pull down to refresh..."];
	textRelease = [[NSString alloc] initWithString:@"Release to refresh..."];
	textLoading = [[NSString alloc] initWithString:@"Loading..."];
}

- (void)addPullToRefreshHeader {
    refreshHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 - REFRESH_HEADER_HEIGHT, 320, REFRESH_HEADER_HEIGHT)];
    refreshHeaderView.backgroundColor = [UIColor clearColor];
	
    refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, REFRESH_HEADER_HEIGHT)];
    refreshLabel.backgroundColor = [UIColor clearColor];
    refreshLabel.font = [UIFont boldSystemFontOfSize:12.0];
    refreshLabel.textAlignment = UITextAlignmentCenter;
	
    refreshArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
    refreshArrow.frame = CGRectMake(floorf((REFRESH_HEADER_HEIGHT - 27) / 2),
                                    (floorf(REFRESH_HEADER_HEIGHT - 44) / 2),
                                    27, 44);
	
    refreshSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    refreshSpinner.frame = CGRectMake(floorf(floorf(REFRESH_HEADER_HEIGHT - 20) / 2), floorf((REFRESH_HEADER_HEIGHT - 20) / 2), 20, 20);
    refreshSpinner.hidesWhenStopped = YES;
	
    [refreshHeaderView addSubview:refreshLabel];
    [refreshHeaderView addSubview:refreshArrow];
    [refreshHeaderView addSubview:refreshSpinner];
    [self.tableView addSubview:refreshHeaderView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (isLoading) return;
    isDragging = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
	if (isLoading) {
        // Update the content inset, good for section headers
        if (scrollView.contentOffset.y > 0)
            self.tableView.contentInset = UIEdgeInsetsZero;
        else if (scrollView.contentOffset.y >= -REFRESH_HEADER_HEIGHT)
            self.tableView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (isDragging && scrollView.contentOffset.y < 0) {
        // Update the arrow direction and label
        [UIView beginAnimations:nil context:NULL];
        if (scrollView.contentOffset.y < -REFRESH_HEADER_HEIGHT) {
            // User is scrolling above the header
            refreshLabel.text = self.textRelease;
            [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
        } else { // User is scrolling somewhere within the header
            refreshLabel.text = self.textPull;
            [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
        }
        [UIView commitAnimations];
    }
}

- (void)startLoading {
    isLoading = YES;
	
    // Show the header
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    self.tableView.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
    refreshLabel.text = self.textLoading;
    refreshArrow.hidden = YES;
    [refreshSpinner startAnimating];
    [UIView commitAnimations];
	
    // Refresh action!
    [self refresh];
}

- (void)stopLoading {
    isLoading = NO;
	
    // Hide the header
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDidStopSelector:@selector(stopLoadingComplete:finished:context:)];
    self.tableView.contentInset = UIEdgeInsetsZero;
    UIEdgeInsets tableContentInset = self.tableView.contentInset;
    tableContentInset.top = 0.0;
    self.tableView.contentInset = tableContentInset;
    [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
    [UIView commitAnimations];
}

- (void)stopLoadingComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    // Reset the header
    refreshLabel.text = self.textPull;
    refreshArrow.hidden = NO;
    [refreshSpinner stopAnimating];
}

- (void)refresh {
    // This is just a demo. Override this method with your custom reload action.
    // Don't forget to call stopLoading at the end.
    [self performSelector:@selector(stopLoading) withObject:nil afterDelay:2.0];
	
//	// Récupération de la liste des podcasts
//	NSLog(@"Récupération JSON \"Liste des podcasts\"");
//	NSMutableArray *podcastsList = [[NSMutableArray alloc] init];
//	
//	SBJsonParser* parser = [[SBJsonParser alloc] init];
//	NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://webserv.freepod.net/get.php?podcasts"]];
//	NSData* response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//	NSString* jsonString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
//	//NSLog(@"%@", jsonString);
//	NSArray* podcasts = [parser objectWithString:jsonString error:nil];
//	
//	for (NSDictionary* podcast in  podcasts) {
//		Podcast *newPodcast = [[Podcast alloc] init];
//		NSLog(@"Récupération de %@",[podcast objectForKey:@"nom"]);
//		
//		[newPodcast setIdPodcast:[[podcast objectForKey:@"id"] intValue]];
//		[newPodcast setNom:[podcast objectForKey:@"nom"]];
//		[newPodcast setDescription:[podcast objectForKey:@"description"]];
//		[newPodcast setExplicite:[podcast objectForKey:@"explicite"]];
//		[newPodcast setUrlSite:[podcast objectForKey:@"url_site"]];
//		[newPodcast setUrlFreepod:[podcast objectForKey:@"url_freepod"]];
//		[newPodcast setLogoNormal:[podcast objectForKey:@"logo_normal"]];
//		[newPodcast setLogoBanner:[podcast objectForKey:@"logo_banner"]];
//		[newPodcast setLastUpdateFromString:[podcast objectForKey:@"lastUpdate"]];
//		
//		[podcastsList addObject:newPodcast];
//		
//		if (!_objects) {
//			_objects = [[NSMutableArray alloc] init];
//		}
//		[_objects addObject:newPodcast];
//		NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//		[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//	}
//	
//	[self.tableView reloadData];
}

@end
