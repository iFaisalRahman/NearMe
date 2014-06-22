//
//  Around_MeAppDelegate.m
//  Around Me
//
//  Created by Faisal on 2/8/12.
//  Copyright 2012 Faisal. All rights reserved.
//

#import "SSMapAnnotation.h"

@implementation SSMapAnnotation

@synthesize coordinate = _coordinate;
@synthesize title = _title;
@synthesize subtitle = _subtitle;

#pragma mark -
#pragma mark Class Methods

+ (SSMapAnnotation *)mapAnnotationWithCoordinate:(CLLocationCoordinate2D)aCoordinate {
	return [self mapAnnotationWithCoordinate:aCoordinate title:nil subtitle:nil];
}


+ (SSMapAnnotation *)mapAnnotationWithCoordinate:(CLLocationCoordinate2D)aCoordinate title:(NSString *)aTitle {
	return [self mapAnnotationWithCoordinate:aCoordinate title:aTitle subtitle:nil];
}


+ (SSMapAnnotation *)mapAnnotationWithCoordinate:(CLLocationCoordinate2D)aCoordinate title:(NSString *)aTitle subtitle:(NSString *)aSubtitle {
	SSMapAnnotation *annotation = [[[self alloc] init] autorelease];
	annotation.coordinate = aCoordinate;
	annotation.title = aTitle;
	annotation.subtitle = aSubtitle;
	return annotation;
}


#pragma mark -
#pragma mark NSObject

- (void)dealloc {
	[_title release];
	[_subtitle release];
	[super dealloc];
}


#pragma mark -
#pragma mark Initializers

- (SSMapAnnotation *)initWithCoordinate:(CLLocationCoordinate2D)aCoordinate {
	return [self initWithCoordinate:aCoordinate title:nil subtitle:nil];
}


- (SSMapAnnotation *)initWithCoordinate:(CLLocationCoordinate2D)aCoordinate title:(NSString *)aTitle {
	return [self initWithCoordinate:aCoordinate title:aTitle subtitle:nil];
}


- (SSMapAnnotation *)initWithCoordinate:(CLLocationCoordinate2D)aCoordinate title:(NSString *)aTitle subtitle:(NSString *)aSubtitle {
	if ((self = [super init])) {
		self.coordinate = aCoordinate;
		self.title = aTitle;
		self.subtitle = aSubtitle;
	}
	return self;
}
-(void)setIndex:(int)i{

	index = i;
}
-(int)getIndex{

	return index;
}
@end
