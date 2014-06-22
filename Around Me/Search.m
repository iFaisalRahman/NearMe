//
//  Search.m
//  Around Me
//
//  Created by Faisal Rahman on 2/17/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Search.h"


@implementation Search

@synthesize delegate,callback,callbackfailed;

-(void)setDelegateWithCallBack:(id)requestDelegate :(SEL)requestSelector :(SEL)requestFailed{
	
	self.delegate=requestDelegate;
	self.callback=requestSelector;
	self.callbackfailed=requestFailed;
	return;
}
-(IBAction)back{

	[self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
	
	
}
-(void)viewDidAppear:(BOOL)animated{

	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(back)] autorelease];
	//self.navigationItem.leftBarButtonItem  = [[[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStylePlain target:self action:nil] autorelease];	

	UISearchBar* mySearchBar = [[[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)] autorelease];

	mySearchBar.tintColor = [UIColor colorWithRed:0.0 green:46.0/255.0 blue:96.0/255.0 alpha:1];
	mySearchBar.delegate  =  self;
	[mySearchBar becomeFirstResponder];

	[self.view addSubview:mySearchBar];	
}

#pragma mark UISearchBar delegate

// return NO to not become first responder
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{

	return YES;
}                      


// called when text starts editing
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{

	NSLog(@"searchBarTextDidBeginEditing");
}

// return NO to not resign first responder
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{

	NSLog(@"searchBarShouldEndEditing");
	if([searchBar.text length]>0)
	{
		[delegate performSelector:callback withObject: searchBar.text];
	}
	
	return YES;
}                        

// called when text ends editing
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{

	NSLog(@"searchBarTextDidEndEditing");
	
}                       
// called when text changes (including clear)
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{

}  


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{

	NSLog(@"SearchButtonClicked");
	
	[searchBar resignFirstResponder];
}  


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
	
	NSLog(@"Deallocating Search....");
	[delegate release];
    [super dealloc];
}


@end
