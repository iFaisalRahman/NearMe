//
//  LocationParser.m
//  AroundMe
//
//  Created by Faisal on 2/5/12.
//  Copyright 2012 Faisal. All rights reserved.
//

#import "PlaceSearchResultParser.h"

@implementation PlaceSearchResultParser

-(NSArray*)parse:(NSMutableArray*)arrData{


	NSMutableArray *arr = [[[NSMutableArray alloc] init] autorelease];
	for(NSDictionary *dic in arrData)
	{
	
		PlaceDetails *l = [[PlaceDetails alloc] init];
		l.name = [dic objectForKey:@"name"];
		l.address = [dic objectForKey:@"vicinity"];
		l.latitude = [[[dic objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lat"];
		l.longitude = [[[dic objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lng"];		
		l.ref = [dic objectForKey:@"reference"];
	
		[arr addObject:l];
		
		[l release];
	}
	
	
	return arr;
	
}

- (void)dealloc {
	
	NSLog(@"Deallaocating: PlaceSearchResultParser...");
    [super dealloc];
	
	
}
@end
