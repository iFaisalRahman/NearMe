//
//  PlaceDetails.h
//  AroundMe
//
//  Created by Faisal on 2/5/12.
//  Copyright 2012 Faisal. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PlaceDetails : NSObject {

	NSString *name;
	NSString *address;
	NSString *latitude;
	NSString *longitude;
	NSString *ref;
	
	NSString *street;
	NSString *locality;
	NSString *State;
	NSString *country;
	NSString *postalCode;

	NSString *phoneNumber;
	NSString *intphoneNumber;
	NSString *google_url;
	NSString *web_url;
	NSString *vicinity;
}
@property(nonatomic,retain) NSString *name;
@property(nonatomic,retain) NSString *address;
@property(nonatomic,retain) NSString *latitude;
@property(nonatomic,retain) NSString *longitude;
@property(nonatomic,retain) NSString *ref;
@property(nonatomic,retain) NSString *street;
@property(nonatomic,retain) NSString *locality;
@property(nonatomic,retain) NSString *State;
@property(nonatomic,retain) NSString *country;
@property(nonatomic,retain) NSString *postalCode;
@property(nonatomic,retain) NSString *vicinity;

@property(nonatomic,retain) NSString *phoneNumber;
@property(nonatomic,retain) NSString *intphoneNumber;
@property(nonatomic,retain) NSString *google_url;
@property(nonatomic,retain) NSString *web_url;
@end
