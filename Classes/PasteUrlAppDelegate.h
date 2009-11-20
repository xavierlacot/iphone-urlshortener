//
//  PasteUrlAppDelegate.h
//  PasteUrl
//
//  Created by Steve Hernandez on 4/20/09.
//  Copyright BinaryImplosion 2009. All rights reserved.
//

@class MainViewController;

@interface PasteUrlAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    MainViewController *mainViewController;
	
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) MainViewController *mainViewController;


@end

