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

- (id)initWithPodcastId:(int)podcastId {
    self = [super init];
    if (self) {
        // Custom initialization
        _jsonData = [[NSMutableData alloc] init];
        
        _episodes = [NSArray array];
        
        _podcastId = podcastId;
        
        [NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://webserv.freepod.net/get.php?episodes=%d", _podcastId]]] delegate:self];
    }
    return self;
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        if (_episodes == nil) return 0;
        return [_episodes count];
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
    
    NSDictionary *episode = [_episodes objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [episode objectForKey:@"title"];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma mark - delegate NSURLConnection

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"Request : podcasts didFinishLoading");
    SBJsonParser* parser = [[SBJsonParser alloc] init];
    
	NSString* jsonString = [[NSString alloc] initWithData:_jsonData encoding:NSUTF8StringEncoding];
	_episodes = [parser objectWithString:jsonString error:nil];
        
    [self.tableView reloadData];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"Receiving data");
    [_jsonData appendData:data];
}

- (void)connectionDidFailWithError:(NSError *)error {
    NSLog(@"Erreur de connexion");
}

@end
