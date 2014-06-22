//
//  Around_MeViewController.h
//  Around Me
//
//  Created by Faisal on 2/8/12.
//  Copyright 2012 Faisal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "CoreLocationController.h"

@interface Around_MeViewController : UIViewController 
<	UITableViewDelegate, 
	UITableViewDataSource, 
	CoreLocationControllerDelegate	>
{

	CoreLocationController *CLController;
	
	UITableView *myTable;
	NSMutableArray *arrType;
	NSMutableDictionary *dicPlaces;
	
	CLLocation *myLocation;
	
}
@property (nonatomic, retain) CoreLocationController *CLController;
@end

