//
//  ShowPlaceOnMap.h
//  Around Me
//
//  Created by Faisal Rahman on 2/8/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "PlaceDetails.h"
#import <CoreLocation/CoreLocation.h>
#import <MessageUI/MessageUI.h>
#import "FBConnect.h"


@interface ShowPlaceOnMap : UIViewController
<MKMapViewDelegate, 
UIActionSheetDelegate,
MFMailComposeViewControllerDelegate,
MFMessageComposeViewControllerDelegate,
FBRequestDelegate,
FBDialogDelegate,
FBSessionDelegate
> {

	MKMapView *mpView;
	
	
	NSMutableArray *arrPlacesDetails;
	NSMutableDictionary *dicPlacesDetails;
	
	
	UIAlertView *dataLoadingAlert;
	
	int currentIndex;
	
	
	UIAlertView *alertLoading;
	
	
	////For FB Connect
	Facebook* _facebook;
	NSArray* _permissions;
	
}


-(void)setLocationArray:(NSArray*)arr;
-(void)setPlaceDetailsArray:(NSArray*)arr;


-(void)getData:(int)index;
@end
