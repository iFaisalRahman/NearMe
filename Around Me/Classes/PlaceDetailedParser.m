//
//  PlaceDetailedParser.m
//  AroundMe
//
//  Created by Faisal on 2/6/12.
//  Copyright 2012 Faisal. All rights reserved.
//

#import "PlaceDetailedParser.h"
#import "PlaceDetails.h"

@implementation PlaceDetailedParser


-(PlaceDetails*)parse:(NSDictionary*)dicData{
	

	NSLog(@"PlaceDetailedParser");
	
	PlaceDetails *l = [[[PlaceDetails alloc] init] autorelease];
	
	NSArray *address = [[dicData objectForKey:@"result"] objectForKey:@"address_components"];
	
	for(NSDictionary *dic in address ){
	

		if([[[dic objectForKey:@"types"] objectAtIndex:0] isEqualToString:@"street_number"])
		{
			l.street = [dic objectForKey:@"long_name"];
		}
		
		if([[[dic objectForKey:@"types"] objectAtIndex:0] isEqualToString:@"locality"])
		{
			l.locality = [dic objectForKey:@"long_name"];
		}
		
		if([[[dic objectForKey:@"types"] objectAtIndex:0] isEqualToString:@"administrative_area_level_1"])
		{
			l.State = [dic objectForKey:@"long_name"];
		}
		
		if([[[dic objectForKey:@"types"] objectAtIndex:0] isEqualToString:@"country"])
		{
			l.country = [dic objectForKey:@"long_name"];
		}

		if([[[dic objectForKey:@"types"] objectAtIndex:0] isEqualToString:@"postal_code"])
		{
			l.postalCode = [dic objectForKey:@"long_name"];
		}
		
	}
		
	l.name			= [[dicData objectForKey:@"result"] objectForKey:@"name"];
	l.vicinity		= [[dicData objectForKey:@"result"] objectForKey:@"vicinity"];
	l.phoneNumber	= [[dicData objectForKey:@"result"] objectForKey:@"formatted_phone_number"];
	l.intphoneNumber = [[dicData objectForKey:@"result"] objectForKey:@"international_phone_number"];
	l.google_url	= [[dicData objectForKey:@"result"] objectForKey:@"url"];
	l.web_url		= [[dicData objectForKey:@"result"] objectForKey:@"website"];
	l.latitude		= [[[[dicData objectForKey:@"result"] objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lat"];
	l.longitude		= [[[[dicData objectForKey:@"result"] objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lng"];	

	return l;
}


- (void)dealloc {
	
NSLog(@"Deallaocating: PlaceDetailedParser...");
    [super dealloc];
	
	
}

@end
