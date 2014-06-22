//
//  Search.h
//  Around Me
//
//  Created by Faisal Rahman on 2/17/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Search : UIViewController<UISearchBarDelegate>{
	
	id					delegate;
	SEL					callback;
	SEL					callbackfailed;
}

@property(nonatomic, retain) id			    delegate;
@property(nonatomic) SEL					callback;
@property(nonatomic) SEL					callbackfailed;

-(void)setDelegateWithCallBack:(id)requestDelegate :(SEL)requestSelector :(SEL)requestFailed;

-(IBAction)back;
@end
