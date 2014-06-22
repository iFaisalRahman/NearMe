//
//  PlaceDetailedViewController.h
//  AroundMe
//
//  Created by Faisal on 2/6/12.
//  Copyright 2012 Faisal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaceDetails.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <MessageUI/MessageUI.h>


@interface PlaceDetailedViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate> {

	PlaceDetails *pDetails;
	
	UITableView *myTable;
}

-(void)setLocation:(PlaceDetails*)l;
@end
