//
//  PlaceAutoCompleteController.m
//  Around Me
//
//  Created by Faisal Rahman on 2/17/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "PlaceAutoCompleteController.h"
#import "AsynchronousParser.h"
#import "JSON.h"
#import "PlaceDetailedParser.h"
#import "PlaceDetails.h"
#import "ShowPlaceOnMap.h"


#define API_KEY  @"AIzaSyBHs4i-zVuXsO6u5NO4ZdIvFO2aRjew93E"
#define OUTPUT   @"json"
#define SENSOR   @"true"
#define RADIUS   @"50"

extern CLLocation *USER_SOURCE_LOCATION;

@implementation PlaceAutoCompleteController






-(void)goToMapViewWithArray{
	
	
	ShowPlaceOnMap *spView = [[[ShowPlaceOnMap alloc] initWithNibName:@"ShowPlaceOnMap" bundle:nil] autorelease];
	
	//[spView setLocationArray:arrPlaces];
	[spView setPlaceDetailsArray:arrPlaces];
	
	[self.navigationController pushViewController:spView animated:YES];
}
-(void)goToMapView:(int)index{
	
	ShowPlaceOnMap *spView = [[[ShowPlaceOnMap alloc] initWithNibName:@"ShowPlaceOnMap" bundle:nil] autorelease];
	
	[spView setPlaceDetailsArray: [NSArray arrayWithObject:[arrPlaces objectAtIndex:index]] ];
	
	
	[self.navigationController pushViewController:spView animated:YES];
	
}


-(void)setSearchString:(NSString *)str{

	strSearch = [[NSString alloc] initWithString:str];
}

-(void)getData{

	alertLoading = [[UIAlertView alloc] initWithTitle:nil message:@"Data Loading..." delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];

	[alertLoading show];
	
	
	NSString *strURL = [[NSString alloc] initWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&types=establishment&location=%f,%f&radius=%@&sensor=%@&key=%@",
																															strSearch,USER_SOURCE_LOCATION.coordinate.latitude,USER_SOURCE_LOCATION.coordinate.longitude,RADIUS,SENSOR,API_KEY];
	
	AsynchronousParser *parser = [[[AsynchronousParser alloc] initWithUrl:strURL Data:nil] autorelease];
	[parser initWithCallBack:self :@selector(AsynchonousParserDataRequestSuccess:) :@selector(AsynchonousParserDataRequestFailed)];
	
	
}




// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	arrPlaces = [[NSMutableArray alloc] init];
	
	[self getData];
}

-(void)viewDidAppear:(BOOL)animated{
	
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"show Map" style:UIBarButtonItemStylePlain target:self action:@selector(goToMapViewWithArray)] autorelease];
	
	myTable = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 460-44-44) style:UITableViewStylePlain] autorelease];
	myTable.delegate=self;
	myTable.dataSource=self;
	[self.view addSubview:myTable];
}

-(void)viewWillDisappear:(BOOL)animated{
	
	for(UIView *v in [self.view subviews] )
	{
		NSLog(@"removing From PlaceSearchViewController......");
		[v removeFromSuperview];
	}
	
}
-(NSDictionary*)jsonParser:(NSData*)data{

	SBJSON *jParser = [[[SBJSON alloc]init]autorelease];
	NSString *json_string = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]autorelease];
	
	NSDictionary *statuses = [jParser objectWithString:json_string error:nil];
	NSLog(@"%@",statuses);
	
	return statuses;
	
	
}

-(void)AsynchonousParserDataRequestSuccess:(NSDictionary*)arrData{

	
	for(NSDictionary* dic in [arrData objectForKey:@"predictions"] )
	{
	
		NSString *strURL = [[[NSString alloc] initWithFormat:@"https://maps.googleapis.com/maps/api/place/details/%@?reference=%@&sensor=%@&key=%@",OUTPUT,[dic objectForKey:@"reference"],SENSOR,API_KEY] autorelease];
		
		NSData *data  = [NSData dataWithContentsOfURL: [NSURL URLWithString:strURL]];
		
		NSDictionary*dicParse = [self jsonParser:data];
	
		PlaceDetailedParser *pD = [[PlaceDetailedParser alloc] init];
		PlaceDetails* l = [pD parse: dicParse];
		
		[arrPlaces addObject:l];
	}
	
	[alertLoading dismissWithClickedButtonIndex:0 animated:YES];
	[alertLoading release];
	
	[myTable reloadData];
}

-(void)AsynchonousParserDataRequestFailed{
}

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
	
	double distance = [location2 distanceFromLocation:USER_SOURCE_LOCATION];
	
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
		lbAddress.text = l.vicinity;
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
	
	[self goToMapView:indexPath.row];
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
	
	[strSearch release];
	[arrPlaces release];
    [super dealloc];
}


@end
