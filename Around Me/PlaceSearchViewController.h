//
//  PlaceSearchViewController.h
//  Around Me
//
//  Created by Faisal on 2/8/12.
//  Copyright 2012 Faisal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "AsynchronousParser.h" 


@interface PlaceSearchViewController : UIViewController
<	UITableViewDelegate,
	UITableViewDataSource>
{

	CLLocation *myLocation;
	
	UITableView *myTable;
	NSMutableArray *arrPlaces;
	
	NSString *strPlaceType;
	
	AsynchronousParser *myParser;
	BOOL didDataLoad;
	
}

-(void)getData;
-(void) setPlaceType:(NSString*)str;
@end
