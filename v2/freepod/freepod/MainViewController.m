//
//  ViewController.m
//  freepod
//
//  Created by Adrien Humilière on 07/12/12.
//  Copyright (c) 2012 Freepod. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (id)init {
    self = [super init];
    if (self) {
        _jsonData = [[NSMutableData alloc] init];
	}
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[self view] setBackgroundColor:[UIColor whiteColor]];
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.22 green:0.38 blue:0.47 alpha:1.];
        
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height - 44 - 20)];
    [_scrollView setContentSize:CGSizeMake(320, [[self view] bounds].size.height)];
    [[self view] addSubview:_scrollView];
	// Do any additional setup after loading the view, typically from a nib.
    
    [NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://webserv.freepod.net/get.php?podcasts"]] delegate:self];
    NSLog(@"Request : get.php?podcasts");
    
    //[self displayPodcastsList];
}

- (void)displayPodcastsList {
    if (_podcasts == nil) return;
    if ([_podcasts count] == 0) return;
    
    int scrollViewHeight = (ceil([_podcasts count] / 2.) * (10 + 145)) + 10;
        
    if (scrollViewHeight > [[self view] bounds].size.height) {
        [_scrollView setContentSize:CGSizeMake(320, scrollViewHeight)];
    }
    
    int i = 0;
    for (NSDictionary* podcast in _podcasts) {
        int row = floor(i / 2); // de 0 à infinity
        int col = i % 2; // 0 ou 1
        
        CoverButton* newCover = [[CoverButton alloc] initWithFrame:CGRectMake(10 + col * (145 + 10), 10 + row * (145 + 10), 145, 145) andPodcastId:[[podcast objectForKey:@"id"] intValue]];
        [newCover setDelegate:self];
        [_scrollView addSubview:newCover];
        
        ++i;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - delegate CoverButton

- (void)coverTouched:(int)podcastId {
    // La cover a été touchée, afficher le détail du podcast
    NSLog(@"Load podcast %d", podcastId);
    
    PodcastViewController* podcastViewController = [[PodcastViewController alloc] initWithPodcastId:podcastId];
    
    [self.navigationController pushViewController:podcastViewController animated:YES];
}

#pragma mark - delegate NSURLConnection

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"Request : podcasts didFinishLoading");
    SBJsonParser* parser = [[SBJsonParser alloc] init];
    
	NSString* jsonString = [[NSString alloc] initWithData:_jsonData encoding:NSUTF8StringEncoding];
	_podcasts = [parser objectWithString:jsonString error:nil];
    
    [self displayPodcastsList];
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
