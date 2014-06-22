//
//  ShowPlaceOnMap.m
//  Around Me
//
//  Created by Faisal Rahman on 2/8/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ShowPlaceOnMap.h"
#import "SSMapAnnotation.h"
#import "PlaceDetailedViewController.h"
#import "PlaceDetails.h"
#import "PlaceDetailedParser.h"
#import "AsynchronousParser.h"





#define API_KEY  @"AIzaSyBHs4i-zVuXsO6u5NO4ZdIvFO2aRjew93E"
#define OUTPUT   @"json"
#define SENSOR   @"true"


#define radiusOfCircle   10

static NSString* kAppId =     @"c55f16db53fedf50793b2c33c0f0317b";//Facebook APP ID
extern CLLocation *USER_SOURCE_LOCATION;



@implementation ShowPlaceOnMap

/*********************************************************************/

#pragma mark AsynchronousParser Delegate
-(void)getData:(int)index{
	
	PlaceDetails *pDetails = [arrPlacesDetails objectAtIndex:index];
	
	NSString *strURL = [[[NSString alloc] initWithFormat:@"https://maps.googleapis.com/maps/api/place/details/%@?reference=%@&sensor=%@&key=%@",OUTPUT,pDetails.ref,SENSOR,API_KEY] autorelease];
	
	AsynchronousParser *myParser = [[[AsynchronousParser alloc] initWithUrl: strURL Data:nil] autorelease];
	[myParser initWithCallBack: self :@selector(AsynchonousParserDataRequestSuccess:) :@selector(AsynchonousParserDataRequestFailed)];
	
	alertLoading = [[[UIAlertView alloc] initWithTitle:nil message:@"Data Loading..." delegate:nil cancelButtonTitle:nil otherButtonTitles:nil] autorelease];
	[alertLoading show];
}
-(void)downloadDetailInfo:(int)index{
	
	currentIndex = index;
	
	PlaceDetails *p = [dicPlacesDetails objectForKey: [NSString stringWithFormat:@"%d",index] ];
	
	if(p==nil)
	{
		[self getData:  currentIndex];
	}
	else
	{
		//NSLog(@"%@",p.name);
	}
	
}
-(void)AsynchonousParserDataRequestSuccess:(NSDictionary*)arrData{
	
	//NSLog(@"%@",arrData);
	
	PlaceDetailedParser *pParser = [[PlaceDetailedParser alloc] init];
	
	PlaceDetails *l = [pParser parse:arrData];
	
	PlaceDetails *pDetails = [[PlaceDetails alloc] init];
	
	pDetails.name		=   l.name;
	pDetails.latitude	=   l.latitude;
	pDetails.longitude	=	l.longitude;
	pDetails.street		=   l.street;
	pDetails.locality	=	l.locality;
	pDetails.State		=	l.State;
	pDetails.country	=	l.country;
	pDetails.postalCode	=	l.postalCode;
	pDetails.google_url	=	l.google_url;
	pDetails.web_url	=	l.web_url;
	pDetails.vicinity    =   l.vicinity;
	pDetails.phoneNumber =	l.phoneNumber;
	pDetails.intphoneNumber = l.intphoneNumber;
	
	[dicPlacesDetails setObject:pDetails forKey: [NSString stringWithFormat:@"%d",currentIndex]];
	
	[pParser release];
	
	[pDetails release];
	
	[alertLoading dismissWithClickedButtonIndex:0 animated:YES];
	 
}
-(void)AsynchonousParserDataRequestFailed{
	[alertLoading dismissWithClickedButtonIndex:0 animated:YES];

}

/*********************************************************************/

#pragma mark DIAL To Phone
-(void)dial{
	PlaceDetails *pDetails = [dicPlacesDetails objectForKey:[NSString stringWithFormat:@"%d",currentIndex]];
	if([pDetails.intphoneNumber length]>0)
	{
		NSString *str = [[[NSString alloc] initWithFormat:@"tel:%@",pDetails.intphoneNumber] autorelease];
		
		str = [str stringByReplacingOccurrencesOfString:@"(" withString:@""];
		str = [str stringByReplacingOccurrencesOfString:@")" withString:@""];
		str = [str stringByReplacingOccurrencesOfString:@"-" withString:@""];
		str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
		
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString: str] ];
	}
	
	
}

-(void)dialToPhone{
	
	PlaceDetails *pDetails = [dicPlacesDetails objectForKey:[NSString stringWithFormat:@"%d",currentIndex]];

	
	if([pDetails.intphoneNumber length]>0)
	{
		UIActionSheet *actionSheet = [[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:pDetails.phoneNumber,nil] autorelease];
		actionSheet.tag=103;
		[actionSheet showFromToolbar:self.navigationController.toolbar];
	}
	else
	{
		UIActionSheet *actionSheet = [[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"No Phone Number" destructiveButtonTitle:nil otherButtonTitles:nil] autorelease];
		actionSheet.tag=103;
		[actionSheet showFromToolbar:self.navigationController.toolbar];
		
	}

	
}

#pragma mark SEND SMS
-(void)sendSMS{

	PlaceDetails *pDetails = [dicPlacesDetails objectForKey:[NSString stringWithFormat:@"%d",currentIndex]];

	MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
	picker.messageComposeDelegate=self;

	NSString *smsBody = [[[NSString alloc] initWithFormat: @"%@\n%@\n\n http://maps.google.com/maps?ll=%f,%f&q=%f,%f",pDetails.name, pDetails.vicinity,USER_SOURCE_LOCATION.coordinate.latitude,USER_SOURCE_LOCATION.coordinate.longitude, [pDetails.latitude doubleValue], [pDetails.longitude doubleValue]] autorelease];

	[picker setBody: smsBody];

	[self presentModalViewController:picker animated:YES];
	
	[picker release];
	
	
	
}
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{

	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark E-MAIL
-(void)sendEmail{
	
	
	if([MFMailComposeViewController canSendMail])
	{
	PlaceDetails *pDetails = [dicPlacesDetails objectForKey:[NSString stringWithFormat:@"%d",currentIndex]];
	
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	
	picker.mailComposeDelegate = self;
	
	[picker setSubject: @"Around Me"];
	
	NSArray *BCC = [[NSArray alloc]initWithObjects:@"faisal_cse_03@yahoo.com",nil];
	
	[picker setBccRecipients: BCC ];
	
	[BCC release];
	
	
	NSString *emailBody = [[[NSString alloc] initWithFormat: @"%@\n%@\n\n http://maps.google.com/maps?ll=%f,%f&q=%f,%f",pDetails.name, pDetails.vicinity,USER_SOURCE_LOCATION.coordinate.latitude,USER_SOURCE_LOCATION.coordinate.longitude, [pDetails.latitude doubleValue], [pDetails.longitude doubleValue]]autorelease];
	
	[picker setMessageBody:emailBody isHTML:YES];
	
	[self presentModalViewController:picker animated:YES];
	
	[picker release];
	}
	else
	{
	
		UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:nil message:@"Around Me cannot send email:\n Please setup a mail account in preferences" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
		[alert show];
	}

	
}
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	
	[self dismissModalViewControllerAnimated:YES];
}	

#pragma mark SHOW ROUTE
-(void)showRoute{
		
	PlaceDetails *pDetails = [dicPlacesDetails objectForKey:[NSString stringWithFormat:@"%d",currentIndex]];
	NSString *url = [[[NSString alloc] initWithFormat:@"http://maps.google.com/maps?saddr=%f,%f&daddr=%@,%@",USER_SOURCE_LOCATION.coordinate.latitude, USER_SOURCE_LOCATION.coordinate.longitude ,pDetails.latitude, pDetails.longitude] autorelease];
	[[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
}

-(void) actionButtonPressed{

	UIActionSheet *actionSheet = [[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Show Route",@"Post On Facebook",nil] autorelease];
	actionSheet.tag=101;
	[actionSheet showFromToolbar:self.navigationController.toolbar];
}
 
-(void) replyButtonPressed{

	UIActionSheet *actionSheet;
	if([MFMessageComposeViewController canSendText])
	{
		actionSheet= [[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"E-mail",@"SMS",nil] autorelease];
	}
	else
	{
		actionSheet= [[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"E-mail",nil] autorelease];
		
	}

	[actionSheet showFromToolbar:self.navigationController.toolbar];
	actionSheet.tag=201;
}


#pragma mark UIActionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{

	if(actionSheet.tag==101)//Action Button Pressed
	{
		switch (buttonIndex) {
			case 0:
				NSLog(@"SHOW ROUTE");
				[self showRoute];
				break;
			case 1:
				NSLog(@"POST ON FACEBOOK");
				
				[self login];
				break;
				
			
			default:
				break;
		}
	}
	else
	{
		if(actionSheet.tag==201)// Reply Button Pressed
		{
			if(buttonIndex==0)//EMAIL
			{
				[self sendEmail];
			}
			if(buttonIndex==1)
			{
				if([MFMessageComposeViewController canSendText])
				{
					[self sendSMS];
				}
			}
		
		}
		else
		{
		
				if(buttonIndex==0)
				{
					[self dial];
				}
		}
	
	}
	
	
}

/**********************************************************************/


-(void)goToPlaceDetailed:(int)index{
	
	PlaceDetails *pDetails = [dicPlacesDetails objectForKey:[NSString stringWithFormat:@"%d",currentIndex]];

	PlaceDetailedViewController *pdV = [[[PlaceDetailedViewController alloc] initWithNibName:@"PlaceDetailedViewController" bundle:nil] autorelease];
	
	[pdV setLocation:pDetails];

	[self.navigationController pushViewController:pdV animated:YES];
	
	
}


-(void)showPlaceLocationOnMAP{
	
	
	// Setting the centre point of the MAP to the USER LOCATION
	CLLocationCoordinate2D coordinate;
	coordinate.latitude =  USER_SOURCE_LOCATION.coordinate.latitude;
	coordinate.longitude = USER_SOURCE_LOCATION.coordinate.longitude;

	mpView.region = MKCoordinateRegionMakeWithDistance(coordinate, radiusOfCircle*1000, radiusOfCircle*1000);
	
	
	SSMapAnnotation *pAnnotation;
	CLLocation *p;
	
	int i=0;
	for(PlaceDetails *pd in arrPlacesDetails)
	{
		p = [[[CLLocation alloc] initWithLatitude:[pd.latitude doubleValue] longitude:[pd.longitude doubleValue]] autorelease];
		
		pAnnotation = [[SSMapAnnotation alloc] initWithCoordinate:  p.coordinate title: pd.name];
		[pAnnotation setIndex: i++ ];
		[mpView addAnnotation: pAnnotation];
		[pAnnotation release];
		
	}
	
}

-(void)showTitle{

	PlaceDetails *pDetails = (PlaceDetails*)[arrPlacesDetails objectAtIndex:0];
	
	CLLocation *location = [[[CLLocation alloc] initWithLatitude:[pDetails.latitude doubleValue] longitude:[pDetails.longitude doubleValue]] autorelease];
	
	double distance = [location distanceFromLocation:USER_SOURCE_LOCATION];
	//if(distance)
	NSString *strTitle = [[[NSString alloc] initWithFormat:@""] autorelease];

	if([pDetails.name length]>0)
	{
		strTitle = [strTitle stringByAppendingFormat:@"%@",pDetails.name];
	}
	if(distance>=1000)
	{
		strTitle = [strTitle stringByAppendingFormat:@"\n%.0f km",distance/1000.0];
	}
	else
	{
		strTitle = [strTitle stringByAppendingFormat:@"%.0f m",distance];	
	}
	
	if([pDetails.address length]>0)
	{
		strTitle = [strTitle stringByAppendingFormat:@" - %@",pDetails.address];
	}
	
	UILabel *lbTitle = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)] autorelease];
	lbTitle.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
	lbTitle.text = strTitle;
	lbTitle.textColor=[UIColor whiteColor];
	lbTitle.numberOfLines=0;
	lbTitle.font = [UIFont boldSystemFontOfSize:15.0];
	[self.view addSubview:lbTitle];
	
}



-(void)setPlaceDetailsArray:(NSArray*)arr{

	arrPlacesDetails = [[NSMutableArray alloc] initWithArray:arr];
	dicPlacesDetails = [[NSMutableDictionary alloc] init];
	
	int i=0;
	for(PlaceDetails *pDetails in arrPlacesDetails)
	{
		[dicPlacesDetails setObject:pDetails forKey: [NSString stringWithFormat:@"%d",i]];
		i++;
	}
	
	
	
}

-(void)setLocationArray:(NSArray*)arr{
	
	arrPlacesDetails = [[NSMutableArray alloc] initWithArray:arr];
	dicPlacesDetails = [[NSMutableDictionary alloc] init];

}

-(void) updateToolberView{
	
	self.navigationController.toolbarHidden=NO;
	
	UIBarButtonItem *btnGlobe		=		[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:nil action:@selector(actionButtonPressed)] autorelease];
	UIBarButtonItem *btnSettings	=		[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:nil action:@selector(replyButtonPressed)] autorelease];
	UIBarButtonItem *btnSpace		=		[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];

	
	NSArray *arrBtn;
	if([MFMessageComposeViewController canSendText])
	{
		
		UIBarButtonItem *btnDial	=	[[UIBarButtonItem alloc] initWithImage: [ UIImage imageNamed:@"icon-phone.png"] style:UIBarButtonItemStylePlain target:nil action:@selector(dialToPhone)];
		arrBtn	=  [[NSArray alloc] initWithObjects:btnSpace,btnGlobe,btnSpace,btnDial,btnSpace,btnSettings,btnSpace,nil];
	}
	else
	{
		arrBtn	=  [[NSArray alloc] initWithObjects:btnSpace,btnGlobe,btnSpace,btnSettings,btnSpace,nil];
	}

	
	


	[self setToolbarItems:arrBtn animated: YES];
	
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	currentIndex=0;
    [super viewDidLoad];
	
		
	[self updateToolberView];
	
	
	//For Facebook
	_permissions =  [[NSArray arrayWithObjects: @"read_stream",@"publish_stream", @"offline_access",@"user_photos",nil] retain];
	_facebook = [[[[Facebook alloc] init] autorelease] retain];

	
}

-(void)viewDidAppear:(BOOL)animated{

	mpView = [[[MKMapView alloc] initWithFrame:CGRectMake(0, 0, 320, 460-44-44)] autorelease];
	mpView.delegate=self;
	mpView.showsUserLocation=YES;

	[self.view addSubview:mpView];
	
	if([arrPlacesDetails count]==1)// Show Title When Only One Place is being shown on MAP
		[self showTitle];
	
	[self showPlaceLocationOnMAP];
	
}

-(void)viewWillDisappear:(BOOL)animated{
	
	for(UIView *v in [self.view subviews] )
	{
		[v removeFromSuperview];
	}
	
}



#pragma mark MKMapView delegate
- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView{

	//NSLog(@"mapViewDidFinishLoadingMap:");
}
- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views{

	if(! [[[[views objectAtIndex:0] annotation] title] isEqualToString:@"Current Location"] )
		[mapView selectAnnotation: [mapView.annotations objectAtIndex:currentIndex ] animated : YES] ;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
	
	[self goToPlaceDetailed:view.tag];

}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
	
	if( ! [[view.annotation title] isEqualToString:@"Current Location"])
	{
		[self downloadDetailInfo:view.tag];
		
		NSArray *arr = self.toolbarItems;
		for(UIBarButtonItem *btn in arr)
		{
			btn.target=self;
		}
	}
	
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {

	/*
	NSArray *arr = self.toolbarItems;
	
	for(UIBarButtonItem *btn in arr)
	{
		btn.target=nil;
	}
	 */
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
	
	
	if([[annotation title] isEqualToString:@"Current Location"])
	{
		return nil;
	}
	
	
	SSMapAnnotation *ann = (SSMapAnnotation*)annotation;
	
	static NSString *identifier = @"CELL";
	
    MKPinAnnotationView *annView = nil;
    annView = (MKPinAnnotationView*)[mpView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if( annView == nil )
	{
        annView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier] autorelease];
    }
	
	
	annView.pinColor = MKPinAnnotationColorRed;
	UIButton *disclosureButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
	annView.rightCalloutAccessoryView = disclosureButton;
	[annView setSelected:YES animated: YES];
	annView.tag= [ann getIndex];
	annView.animatesDrop=TRUE;
	annView.canShowCallout = YES;
    return annView;
}



#pragma mark Facebook

-(void)postStatus{
	
	PlaceDetails *pDetails = [dicPlacesDetails objectForKey:[NSString stringWithFormat:@"%d",currentIndex]];

	NSString *postBody = [[[NSString alloc] initWithFormat: @"%@\n%@\n\n http://maps.google.com/maps?ll=%f,%f&q=%f,%f",pDetails.name, pDetails.vicinity,USER_SOURCE_LOCATION.coordinate.latitude,USER_SOURCE_LOCATION.coordinate.longitude, [pDetails.latitude doubleValue], [pDetails.longitude doubleValue]]autorelease];

	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:postBody, @"message", nil];
	
    [_facebook requestWithGraphPath:@"me/feed"
						  andParams:params 
					  andHttpMethod:@"POST" 
						andDelegate:self];
	
	
}
- (void)login {
	
	[_facebook authorize:kAppId permissions:_permissions delegate:self];
	
}

#pragma mark FaceBook Delegates
/**
 * Callback for facebook login
 */ 


-(void) fbDidLogin {
	
	[self postStatus];
	
}


/**
 * Callback for facebook did not login
 */
- (void)fbDidNotLogin {
		
}

/**
 * Callback for facebook logout
 */ 
-(void) fbDidLogout {
	
}


///////////////////////////////////////////////////////////////////////////////////////////////////
// FBRequestDelegate

/**
 * Callback when a request receives Response
 */ 
- (void)request:(FBRequest*)request didReceiveResponse:(NSURLResponse*)response{
	
	NSLog(@"received response:%@",response);
};

/**
 * Called when an error prevents the request from completing successfully.
 */
- (void)request:(FBRequest*)request didFailWithError:(NSError*)error{
	
	NSLog(@"Request Not Complete");
};

/**
 * Called when a request returns and its response has been parsed into an object.
 * The resulting object may be a dictionary, an array, a string, or a number, depending
 * on thee format of the API response.
 */
- (void)request:(FBRequest*)request didLoad:(id)result{
	
	NSLog(@"REQUEST COMPLETE %@",result);
	
};

///////////////////////////////////////////////////////////////////////////////////////////////////
// FBDialogDelegate

/** 
 * Called when a UIServer Dialog successfully return
 */
- (void)dialogDidComplete:(FBDialog*)dialog{
	NSLog(@"dialogDidComplete");
}


/******************************************************/


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
	
	NSLog(@"Dealocating....ShowPlaceOnMap");
	[_permissions release];
	[arrPlacesDetails release];
	[dicPlacesDetails release];
    [super dealloc];
	
	
}


@end
