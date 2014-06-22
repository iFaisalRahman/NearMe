//
//  Around_MeAppDelegate.h
//  Around Me
//
//  Created by Faisal on 2/8/12.
//  Copyright 2012 Faisal. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Around_MeViewController;

@interface Around_MeAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    Around_MeViewController *viewController;
	UINavigationController *nav;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet Around_MeViewController *viewController;

@end

