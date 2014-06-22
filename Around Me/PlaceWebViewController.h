//
//  PlaceWebViewController.h
//  AroundMe
//
//  Created by Faisal Rahman on 2/7/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PlaceWebViewController : UIViewController <UIWebViewDelegate>{

	NSString *url;
}

-(void)setURL:(NSString*)URL;
@end
