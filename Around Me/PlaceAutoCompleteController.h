//
//  PlaceAutoCompleteController.h
//  Around Me
//
//  Created by Faisal Rahman on 2/17/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@interface PlaceAutoCompleteController : UIViewController<UITableViewDelegate, UITableViewDataSource> {

	NSString *strSearch;
	
	NSMutableArray* arrPlaces;
	
	UIAlertView *alertLoading;
	
	UITableView *myTable;
}
-(void)setSearchString:(NSString*)str;
@end
