//
//  Around_MeViewController.m
//  Around Me
//
//  Created by Faisal on 2/8/12.
//  Copyright 2012 Faisal. All rights reserved.
//

#import "Around_MeViewController.h"
#import "PlaceSearchViewController.h"
#import "Search.h"
#import "PlaceAutoCompleteController.h"

CLLocation *USER_SOURCE_LOCATION;

@implementation Around_MeViewController
@synthesize CLController;





-(void)GoToPlaceSearch:(int)index{
	
	PlaceSearchViewController *pV = [[[PlaceSearchViewController alloc] initWithNibName:@"PlaceSearchViewController" bundle:nil] autorelease];
	[pV setPlaceType: [dicPlaces objectForKey: (NSString*)[arrType objectAtIndex:index]]];
	//[pV setLocation:myLocation];
	[self.navigationController pushViewController:pV animated:YES];
}

/*******************************  Search Option  **************************************/

-(void)searchButtonPressed{

	Search *mySearch = [[[Search alloc] initWithNibName:@"Search" bundle:nil] autorelease];
	[mySearch setDelegateWithCallBack:self : @selector(searchRequestSucess:) :nil];
	
	[self.navigationController pushViewController:mySearch animated:YES];
	
}

-(void)searchRequestSucess:(NSString*)str{ // Returned Here after search string input

	[self.navigationController popViewControllerAnimated:NO];

	PlaceAutoCompleteController *pA = [[[PlaceAutoCompleteController alloc] initWithNibName:@"PlaceAutoCompleteController" bundle:nil] autorelease]; 
	[pA setSearchString: str];
	[self.navigationController pushViewController:pA animated:YES];
	
}

/*******************************  Search Option  End **************************************/


/*******************************  Data Initialize  **************************************/

-(void) initiateTypeList{

	[dicPlaces removeAllObjects];
	
	[dicPlaces setObject:@"bank/atm" forKey:@"Banks|ATM"];
	[dicPlaces setObject:@"bar" forKey:@"Bars"];
	[dicPlaces setObject:@"cafe" forKey:@"Cofee"];
	[dicPlaces setObject:@"gas_station" forKey:@"Gas Stations"];
	[dicPlaces setObject:@"hospital" forKey:@"Hospitals"];
	[dicPlaces setObject:@"lodging" forKey:@"Hotels"];
	[dicPlaces setObject:@"movie_theater" forKey:@"Movie Theater"];
	[dicPlaces setObject:@"parking" forKey:@"Parking"];
	[dicPlaces setObject:@"pharmacy" forKey:@"Pharmacies"];
	[dicPlaces setObject:@"restaurant" forKey:@"Restaurants"];
	[dicPlaces setObject:@"grocery_or_supermarket|convenience_store" forKey:@"Supermarkets"];
	[dicPlaces setObject:@"taxi_stand" forKey:@"Taxis"];
	
	
	[arrType release];
	arrType  =  [[NSMutableArray alloc] initWithArray:  [[dicPlaces allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)]  ]; 

}

-(void)initializeLocationManager{
 
 CLController = [[CoreLocationController alloc] init];
 CLController.delegate = self;
 [CLController.locMgr startUpdatingLocation];
 
 }
 
/*******************************  VIEW UPDATING  **************************************/

-(void) addTableView{
	
	myTable = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 460-44-44) style:UITableViewStylePlain] autorelease];
	myTable.delegate=self;
	myTable.dataSource=self;
	[self.view addSubview:myTable];
}

-(void) updateToolberView{
	
	self.navigationController.toolbarHidden=NO;
	
	UIImageView *imgNavBar = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BAR.png"]] autorelease];
	imgNavBar.frame = CGRectMake(0, 0, 320, 44.0);
	[self.navigationController.toolbar insertSubview:imgNavBar atIndex:0];
}

- (void)viewDidLoad {
 
	[super viewDidLoad];

	self.navigationItem.title = @"Around Me";
	
	dicPlaces = [[NSMutableDictionary alloc] init] ;
	arrType   = [[NSMutableArray alloc] init];
	
	myLocation = [[CLLocation alloc] init];
	USER_SOURCE_LOCATION = [[CLLocation alloc] init];
	
	[self updateToolberView];
	
	[self initializeLocationManager];
	

}

-(void)viewDidAppear:(BOOL)animated{

	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchButtonPressed)] autorelease];	

	[self addTableView];
	[self initiateTypeList];
	
}

-(void)viewDidDisappear:(BOOL)animated{

	for(UIView *v in [self.view subviews] )
	{
		NSLog(@"removing......");
		[v removeFromSuperview];
	}
	
	[dicPlaces removeAllObjects];
	[arrType removeAllObjects];
	
}
/*******************************  VIEW UPDATING END **************************************/

 #pragma mark -
 #pragma mark LOCATION DELEGATE
-(void)locationUpdate:(CLLocation *)location {
 
	 NSLog(@"Locationa Update: %f  %f", location.coordinate.latitude, location.coordinate.longitude);
 
	 [myLocation release];
	 [USER_SOURCE_LOCATION release];

	 myLocation = [[CLLocation alloc] initWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
	 USER_SOURCE_LOCATION = [[CLLocation alloc] initWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
}
 
-(void)locationError:(NSError *)error {
 
}
 

#pragma mark -
#pragma mark Table view data source


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
		
	return [arrType count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *CellIdentifier= @"CELL";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if(cell==nil)
	{
		cell = [[[UITableViewCell alloc]initWithFrame:CGRectZero reuseIdentifier: CellIdentifier]autorelease];
	}
	
	cell.imageView.image = [UIImage imageNamed: [NSString stringWithFormat:@"%@.png", [arrType objectAtIndex:indexPath.row] ] ];
	
	cell.textLabel.text = [arrType objectAtIndex:indexPath.row];
	cell.textLabel.font = [UIFont boldSystemFontOfSize:17];
	cell.textLabel.textColor = [UIColor colorWithRed:0/255.0 green:55/255.0 blue:112/255.0 alpha:1];
	cell.selectionStyle=UITableViewCellSelectionStyleNone;
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath { 
	
	[self GoToPlaceSearch: indexPath.row ];		
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	
	[CLController stop];
	[CLController release];
	[arrType release];
	[dicPlaces release];
	[myLocation release];
	[USER_SOURCE_LOCATION release];
    [super dealloc];
}

@end
