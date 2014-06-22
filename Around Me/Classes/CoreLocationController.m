//
//  CoreLocationController.m
//  CoreLocationDemo
//
//  Created by Nicholas Vellios on 8/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CoreLocationController.h"


@implementation CoreLocationController

@synthesize locMgr, delegate;


- (void)stop{

	[locMgr stopUpdatingHeading];
	[locMgr stopUpdatingLocation];
}
- (void)start{

	[locMgr startUpdatingLocation];
	[locMgr startUpdatingHeading];
}
- (id)init {
	self = [super init];
	
	if(self != nil) {
		self.locMgr = [[[CLLocationManager alloc] init] autorelease];
		self.locMgr.delegate = self;
		[locMgr setDesiredAccuracy:kCLLocationAccuracyBest];
		[locMgr startUpdatingLocation];
		[locMgr startUpdatingHeading];
		
	}
	
	return self;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	if([self.delegate conformsToProtocol:@protocol(CoreLocationControllerDelegate)]) 
	{
		[self.delegate locationUpdate:newLocation];
	}
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	if([self.delegate conformsToProtocol:@protocol(CoreLocationControllerDelegate)]) {
		[self.delegate locationError:error];
	}
}

- (void)dealloc {
	[self.locMgr release];
	[super dealloc];
}

@end
