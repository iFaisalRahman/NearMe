//
//  Around_MeAppDelegate.m
//  Around Me
//
//  Created by Faisal on 2/8/12.
//  Copyright 2012 Faisal. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface SSMapAnnotation : NSObject <MKAnnotation> {

@private
	
	CLLocationCoordinate2D _coordinate;
	NSString * _title;
	NSString * _subtitle;
	int index;
}

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

+ (SSMapAnnotation *)mapAnnotationWithCoordinate:(CLLocationCoordinate2D)aCoordinate;
+ (SSMapAnnotation *)mapAnnotationWithCoordinate:(CLLocationCoordinate2D)aCoordinate title:(NSString *)aTitle;
+ (SSMapAnnotation *)mapAnnotationWithCoordinate:(CLLocationCoordinate2D)aCoordinate title:(NSString *)aTitle subtitle:(NSString *)aSubtitle;

- (SSMapAnnotation *)initWithCoordinate:(CLLocationCoordinate2D)aCoordinate;
- (SSMapAnnotation *)initWithCoordinate:(CLLocationCoordinate2D)aCoordinate title:(NSString *)aTitle;
- (SSMapAnnotation *)initWithCoordinate:(CLLocationCoordinate2D)aCoordinate title:(NSString *)aTitle subtitle:(NSString *)aSubtitle;
-(void)setIndex:(int)i;
-(int)getIndex;
@end
