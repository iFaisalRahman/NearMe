//
//  PlaceSearchViewController.m
//  Around Me
//
//  Created by Faisal on 2/8/12.
//  Copyright 2012 Faisal. All rights reserved.
//

#import "PlaceSearchViewController.h"
#import "AsynchronousParser.h"
#import "PlaceSearchResultParser.h"
#import "PlaceDetails.h"
#import "PlaceDetailedViewController.h"
#import "ShowPlaceOnMap.h"



// Parameters for Google Api
#define API_KEY @"AIzaSyBHs4i-zVuXsO6u5NO4ZdIvFO2aRjew93E"
#define LAT @"36.8855271" 
#define LON @"-76.3058051"
#define RADIUS 4000



extern CLLocation *USER_SOURCE_LOCATION;

@implementation PlaceSearchViewController


-(void)goToMapViewWithPlaceArray{

	ShowPlaceOnMap *spView = [[[ShowPlaceOnMap alloc] initWithNibName:@"ShowPlaceOnMap" bundle:nil] autorelease];
	
	[spView setLocationArray:arrPlaces];
	
	[self.navigationController pushViewController:spView animated:YES];
}

-(void)goToMapViewWithPlace:(int)index{

	ShowPlaceOnMap *spView = [[[ShowPlaceOnMap alloc] initWithNibName:@"ShowPlaceOnMap" bundle:nil] autorelease];
	
	[spView setLocationArray: [NSArray arrayWithObject:[arrPlaces objectAtIndex:index]] ];
	
	[self.navigationController pushViewController:spView animated:YES];
 
}


/*******************************  Data Initialize  **************************************/

-(void)setPlaceType:(NSString*)str{

	strPlaceType  = [[NSString alloc] initWithString:str];
}
-(void) setUserLocation:(CLLocation*)location{

	myLocation = [[CLLocation alloc] initWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
}
/*******************************  Data Initialize End **************************************/

/*******************************  VIEW UPDATING  **************************************/

- (void)viewDidLoad {
   
	[super viewDidLoad];
	
	arrPlaces = [[NSMutableArray alloc] init];
	
	[self setUserLocation:USER_SOURCE_LOCATION];
	
	[self getData];

}

-(void)viewDidAppear:(BOOL)animated{

	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"show Map" style:UIBarButtonItemStylePlain target:self action:@selector(goToMapViewWithPlaceArray)] autorelease];

	myTable = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 460-44-44) style:UITableViewStylePlain] autorelease];
	myTable.delegate=self;
	myTable.dataSource=self;
	[self.view addSubview:myTable];
}

-(void)viewWillDisappear:(BOOL)animated{
	
	for(UIView *v in [self.view subviews] )
	{
		[v removeFromSuperview];
	}

	if(didDataLoad==NO)
	{
		[myParser CancelConnection];
	}
}

/*******************************  VIEW UPDATING End **************************************/




/*******************************  Data Laod From Google Place API  **************************************/

#pragma mark AsynchronousParser Delegate

-(void)getData{
	
	NSString *strURL = [[[NSString alloc] initWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&radius=%d&types=%@&sensor=true&key=%@",
						 myLocation.coordinate.latitude, myLocation.coordinate.longitude, RADIUS,strPlaceType,API_KEY] autorelease];
	
	myParser = [[[AsynchronousParser alloc] initWithUrl: strURL Data:nil] autorelease];
	
	[myParser initWithCallBack: self :@selector(AsynchonousParserDataRequestSuccess:) :@selector(AsynchonousParserDataRequestFailed)];
	
	didDataLoad=NO;
}

-(void)AsynchonousParserDataRequestSuccess:(NSDictionary*)arrData{
		
	didDataLoad=YES;
	
	PlaceSearchResultParser *lp = [[[PlaceSearchResultParser alloc] init] autorelease];
	NSArray* arr =  [lp parse:  [arrData objectForKey:@"results"]];
	
	[arrPlaces release];
	arrPlaces = [[NSMutableArray alloc] initWithArray:arr];

	[myTable reloadData];
}

-(void)AsynchonousParserDataRequestFailed{

	didDataLoad=YES;
}
/*******************************  Data Laod From Google Place API  **************************************/



#pragma mark -
#pragma mark Table view data source


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	return 45;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	
	return [arrPlaces count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	NSString *CellIdentifier=[NSString stringWithFormat:@"Cell%d",indexPath.row];
	
	PlaceDetails *l = (PlaceDetails*) [arrPlaces objectAtIndex: indexPath.row];
	
	CLLocation *location2 = [[[CLLocation alloc] initWithLatitude:[l.latitude doubleValue] longitude:[l.longitude doubleValue]] autorelease];
	
	double distance = [location2 distanceFromLocation:myLocation];
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if(cell==nil)
	{

		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		
		UILabel* lbName = [[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 25)] autorelease];
		lbName.text = l.name;
		lbName.textColor = [UIColor colorWithRed:5/255.0 green:55/255.0 blue:112/255.0 alpha:1];
		lbName.textAlignment = UITextAlignmentLeft;
		lbName.font=[UIFont boldSystemFontOfSize:15.0];
		lbName.backgroundColor=[UIColor clearColor];
		[cell.contentView addSubview:lbName];
		
		UILabel* lbDistance = [[[UILabel alloc] initWithFrame:CGRectMake(230, 0, 60, 45)] autorelease];
		
		if(distance<1000)
		{
			lbDistance.text = [NSString stringWithFormat:@"%.0f m",distance];
		}
		else
		{
			lbDistance.text = [NSString stringWithFormat:@"%.0f km",distance/1000.0];		
		}
		
		lbDistance.textColor = [UIColor blackColor];
		lbDistance.textAlignment = UITextAlignmentRight;
		lbDistance.backgroundColor=[UIColor clearColor];
		[cell.contentView addSubview:lbDistance];
		
		UILabel* lbAddress = [[[UILabel alloc] initWithFrame:CGRectMake(10, 25, 200, 15)] autorelease];
		lbAddress.text = l.address;
		lbAddress.textColor = [UIColor blackColor];
		lbAddress.font=[UIFont systemFontOfSize:13.0];
		lbAddress.textAlignment = UITextAlignmentLeft;
		lbAddress.backgroundColor=[UIColor clearColor];
		[cell.contentView addSubview:lbAddress];
		
		cell.contentView.backgroundColor=[UIColor clearColor];
		
	}
	
	
	cell.selectionStyle=UITableViewCellSelectionStyleNone;
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath { 
	
	NSLog(@"GO TO DETAILE VIEW");

	[self goToMapViewWithPlace:indexPath.row];
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
	
	NSLog(@"Deallocating....PlaceSearchViewController");
	[myLocation release];
	[arrPlaces release];
	[strPlaceType release];
    [super dealloc];
}

@end
