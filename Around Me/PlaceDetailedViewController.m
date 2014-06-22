//
//  PlaceDetailedViewController.m
//  AroundMe
//
//  Created by Faisal on 2/6/12.
//  Copyright 2012 Faisal. All rights reserved.
//

#import "PlaceDetailedViewController.h"

#import "PlaceDetailedParser.h"
#import "PlaceWebViewController.h"


#define API_KEY  @"AIzaSyBHs4i-zVuXsO6u5NO4ZdIvFO2aRjew93E"
#define OUTPUT   @"json"
#define SENSOR   @"true"

/*
https://maps.googleapis.com/maps/api/place/details/output?parameters

https://maps.googleapis.com/maps/api/place/details/json?reference=REFERENCE_DATA&sensor=true&key=KEY_DATA

 where output may be either of the following values:
 
 * json (recommended) indicates output in JavaScript Object Notation (JSON)
 * xml indicates output as XML
 
 Certain parameters are required to initiate a search request. As is standard in URLs, all parameters are separated using the ampersand (&) character. The list of parameters and their possible values are enumerated below.
 
 * key (required) — Your application's API key. This key identifies your application for purposes of quota management and so that Places added from your application are made immediately available to your app. Visit the APIs Console to create an API Project and obtain your key.
 * reference (required) — A textual identifier that uniquely identifies a place, returned from a Place search request.
 * sensor (required) — Indicates whether or not the Place Details request came from a device using a location sensor (e.g. a GPS). This value must be either true or false.
 
 * language (optional) — The language code, indicating in which language the results should be returned, if possible. See the list of supported languages and their codes. Note that we often update supported languages so this list may not be exhaustive. 
 
 
*/


extern CLLocation *USER_SOURCE_LOCATION;



@implementation PlaceDetailedViewController



-(void)showRoute{

	NSString *url = [[[NSString alloc] initWithFormat:@"http://maps.google.com/maps?saddr=%f,%f&daddr=%@,%@",USER_SOURCE_LOCATION.coordinate.latitude, USER_SOURCE_LOCATION.coordinate.longitude ,pDetails.latitude, pDetails.longitude] autorelease];
	NSLog(@"%@",url);
	
	[[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
}

-(void)goToGoogleWeb{

	PlaceWebViewController *pWeb = [[[PlaceWebViewController alloc] initWithNibName:@"PlaceWebViewController" bundle:nil] autorelease];
	
	[pWeb setURL:pDetails.google_url];
	[self.navigationController pushViewController:pWeb animated:YES];
	
}

-(void)dialPhone{

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

#pragma mark E-MAIL


-(void)sendEmail{
	
	if([MFMailComposeViewController canSendMail])
	{
		
		MFMailComposeViewController *picker = [[[MFMailComposeViewController alloc] init] autorelease];
		
		picker.mailComposeDelegate = self;
		
		[picker setSubject: @"Around Me"];
		
		NSArray *BCC = [[NSArray alloc]initWithObjects:@"faisal_cse_03@yahoo.com",nil];
		
		[picker setBccRecipients: BCC ];
		
		[BCC release];
		
		
		NSString *emailBody = [[[NSString alloc] initWithFormat: @"%@\n%@\n\n http://maps.google.com/maps?ll=%f,%f&q=%f,%f",pDetails.name, pDetails.vicinity,USER_SOURCE_LOCATION.coordinate.latitude,USER_SOURCE_LOCATION.coordinate.longitude, [pDetails.latitude doubleValue], [pDetails.longitude doubleValue]]autorelease];
		NSLog(@"%@",emailBody);
		[picker setMessageBody:emailBody isHTML:YES];
		
		[self presentModalViewController:picker animated:YES];
	}
	else
	{
		
		UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:nil message:@"Around Me cannot send email:\n Please setup a mail account in preferences" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
		[alert show];
	}
	
	
	
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	
	[self dismissModalViewControllerAnimated:YES];
	
	UIAlertView *alert;
	switch (result) {
		case MFMailComposeResultSent:
			NSLog(@"SENT");
			alert = [[UIAlertView alloc]initWithTitle:@"Email" message:@"Email sent successfully!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alert show];
			[alert release];
			break;
			
		case MFMailComposeResultFailed:
			NSLog(@"Failed");
			alert = [[UIAlertView alloc]initWithTitle:@"Email" message:@"Email send failed!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alert show];
			[alert release];
			break;
			
		default:
			break;
	}
}

-(void)shareToMAil{
	
	[self sendEmail];
}


-(void)setLocation:(PlaceDetails*)l{

	//CnRpAAAA-9To-RSILF33axRSgCd3K6iTvkpof5Ud1uBy1tOmpX4sAj3KLRvx2y52ArPY3bJl-XyztoMMv6sZPBtY6zojnG-vssBFoM8VfPRL3Ui2tl71XJp1d7FcIadmRl8zyZP13kdwyJn5Z7CDP8iwoCDd2BIQ_YSN9BFCLfVTJ9O1LH_D7hoURRB-tp1E1IOhTEV_ZfEwgolbV0U
	pDetails = [[PlaceDetails alloc] init];
	pDetails.name=l.name;
	pDetails.address=l.address;
	pDetails.latitude=l.latitude;
	pDetails.longitude=l.longitude;
	pDetails.ref	=	l.ref;
	pDetails.street	=	l.street;
	pDetails.locality=	l.locality;
	pDetails.State	=	l.State;
	pDetails.country=	l.country;
	pDetails.postalCode=l.postalCode;
	pDetails.phoneNumber=l.phoneNumber;
	pDetails.intphoneNumber=l.intphoneNumber;
	pDetails.vicinity	= l.vicinity;
	pDetails.google_url	= l.google_url;
	pDetails.web_url	= l.web_url;
	
	
	//pDetails.ref=l.ref;
	
}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	
	myTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 460-44-44) style:UITableViewStyleGrouped] ;
	myTable.delegate=self;
	myTable.dataSource=self;
	
	[self.view addSubview:myTable];
	
}






#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	
	return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	double height=50.0;
	if(indexPath.section==0)
	{
		height = 50;
	}
	
	if(indexPath.section==1)
	{
		height = 100;
	}
	
	if(indexPath.section==2)
	{
		height = 40;
	}
	if(indexPath.section==3)
	{
		height = 100;
	}
	
	return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	int numRow=1;
	
	
	
	return numRow;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	
	NSString *CellIdentifier = [[[NSString alloc] initWithFormat:@"CELL2_%d",indexPath.row+indexPath.section] autorelease];
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if(cell==nil)
	{
		cell = [[[UITableViewCell alloc]initWithFrame:CGRectZero reuseIdentifier: CellIdentifier]autorelease];
		
		cell.textLabel.textColor = [UIColor colorWithRed:5/255.0 green:55/255.0 blue:112/255.0 alpha:1];

		
		if(indexPath.section == 0)
		{
			cell.textLabel.text = pDetails.name;
			cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
			cell.textLabel.numberOfLines=0;
			cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
		}
		
		
		if(indexPath.section == 1)
		{
			NSString *strAddress = [[[NSString alloc] initWithFormat:@""] autorelease];
			if(pDetails.vicinity !=nil )
			{
				strAddress  =  [strAddress stringByAppendingFormat:@"%@",pDetails.vicinity];
				strAddress  =  [strAddress stringByReplacingOccurrencesOfString:@", " withString:@"\n"];
				
			}
			if(pDetails.country !=nil )
			{
				strAddress  =  [strAddress stringByAppendingFormat:@"\n%@",pDetails.country];
			}
			
			UILabel *lbHead1 = [[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 70, 20)] autorelease];
			lbHead1.text = @"Address:";
			lbHead1.textColor = [UIColor colorWithRed:5/255.0 green:55/255.0 blue:112/255.0 alpha:1];
			lbHead1.font = [UIFont boldSystemFontOfSize:15.0];

			lbHead1.textAlignment = UITextAlignmentRight;
			[cell.contentView addSubview:lbHead1];
			
			UILabel *lbDet1 = [[[UILabel alloc] initWithFrame:CGRectMake(90, 10, 200, 80)] autorelease];
			lbDet1.text = strAddress;
			lbDet1.numberOfLines=0;
			lbDet1.font = [UIFont boldSystemFontOfSize:15.0];
			lbDet1.textAlignment=UITextAlignmentLeft;
			CGSize result = [strAddress sizeWithFont:lbDet1.font constrainedToSize: lbDet1.frame.size  lineBreakMode:UILineBreakModeWordWrap];
			lbDet1.frame = CGRectMake(90, 10, 200, result.height);
			//lbDet1.backgroundColor=[UIColor redColor];
			[cell.contentView addSubview:lbDet1];
			
		}
		
		if(indexPath.section == 2)
		{
			UILabel *lbHead2 = [[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 70, 20)] autorelease];
			lbHead2.text = @"Phone:";
			lbHead2.textColor = [UIColor colorWithRed:5/255.0 green:55/255.0 blue:112/255.0 alpha:1];
			lbHead2.font = [UIFont boldSystemFontOfSize:15];
			lbHead2.textAlignment = UITextAlignmentRight;
			[cell.contentView addSubview:lbHead2];
			
			UILabel *lbDet2 = [[[UILabel alloc] initWithFrame:CGRectMake(90, 10, 200, 20)] autorelease];
			lbDet2.text = pDetails.phoneNumber;
			lbDet2.numberOfLines=0;
			lbDet2.font = [UIFont boldSystemFontOfSize:15.0];
			lbDet2.textAlignment=UITextAlignmentLeft;
			[cell.contentView addSubview:lbDet2];
		}
		if(indexPath.section == 3)
		{
			cell.backgroundColor = [UIColor clearColor];
			cell.contentView.backgroundColor = [UIColor clearColor];
			cell.contentView.backgroundColor = [UIColor clearColor];
			
			UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
			btn1.frame     =CGRectMake(0, 7, 140, 40);
			[btn1 setTitle:@"Show Route" forState:UIControlStateNormal];
			btn1.titleLabel.textColor = [UIColor colorWithRed:5/255.0 green:55/255.0 blue:112/255.0 alpha:1];
			[btn1 addTarget:self action:@selector(showRoute) forControlEvents:UIControlEventTouchUpInside];
			[cell.contentView addSubview:btn1];
			
			UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
			btn2.frame     =CGRectMake(160, 7, 140, 40);
			[btn2 setTitle:@"Add To Favorites" forState:UIControlStateNormal];
			btn2.titleLabel.textColor = [UIColor colorWithRed:5/255.0 green:55/255.0 blue:112/255.0 alpha:1];
			[cell.contentView addSubview:btn2];
			
			UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
			btn3.frame     =CGRectMake(0, 40+7+5, 140, 40);
			[btn3 setTitle:@"Share" forState:UIControlStateNormal];
			[btn3 addTarget:self action:@selector(shareToMAil) forControlEvents:UIControlEventTouchUpInside];
			btn3.titleLabel.textColor = [UIColor colorWithRed:5/255.0 green:55/255.0 blue:112/255.0 alpha:1];
			[cell.contentView addSubview:btn3];
			
			UIButton *btn4 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
			btn4.frame     =CGRectMake(160, 40+7+5, 140, 40);
			[btn4 setTitle:@"Add to Contacts" forState:UIControlStateNormal];
			btn4.titleLabel.textColor = [UIColor colorWithRed:5/255.0 green:55/255.0 blue:112/255.0 alpha:1];
			[cell.contentView addSubview:btn4];
			
			
		}
		 
		
	//	cell.textLabel.text = @"Hello";
	//	cell.textLabel.textColor=[UIColor yellowColor];
	}
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath { 
	
	NSLog(@"%d",indexPath.row+indexPath.section);
	
	if(indexPath.row+indexPath.section==0)
	{
		[self goToGoogleWeb];
	}
	if(indexPath.row+indexPath.section==2)
	{
		[self dialPhone];
	}
	
	
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

	NSLog(@"Deallocating...PlaceDetailedViewController");
	
	[pDetails release];
	[myTable release];
    [super dealloc];
}


@end
