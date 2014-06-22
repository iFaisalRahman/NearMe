//
//  PlaceWebViewController.m
//  AroundMe
//
//  Created by Faisal Rahman on 2/7/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "PlaceWebViewController.h"


@implementation PlaceWebViewController


-(void)setURL:(NSString*)URL{

	url  = [[NSString alloc] initWithString:URL] ;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {

    [super viewDidLoad];
	
	UIWebView *web = [[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 460-44)] autorelease];
	web.delegate =self;
	[self.view addSubview:web];

	//Create a URL object FROM THAT STRING
	NSURL *URL = [NSURL URLWithString:url];
	
	//URL Requst Object CREATD FROM YOUR URL OBJECT
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:URL];
	
	//Load the request in the UIWebView.
	[web loadRequest:requestObj];
	
	
	
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[url release];
    [super dealloc];
}


@end
