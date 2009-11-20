//
//  PasteUrlAppDelegate.m
//  PasteUrl
//
//  Created by Steve Hernandez on 4/20/09.
//  Copyright BinaryImplosion 2009. All rights reserved.
//

#import "PasteUrlAppDelegate.h"
#import "MainViewController.h"

@implementation PasteUrlAppDelegate


@synthesize window;
@synthesize mainViewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {
    
	MainViewController *aController = [[MainViewController alloc] initWithNibName:@"MainView" bundle:nil];
	self.mainViewController = aController;
	[aController release];
	
    mainViewController.view.frame = [UIScreen mainScreen].applicationFrame;
	[window addSubview:[mainViewController view]];
    [window makeKeyAndVisible];
}


- (void)dealloc {
	
    [mainViewController release];
    [window release];
    [super dealloc];
}

@end
