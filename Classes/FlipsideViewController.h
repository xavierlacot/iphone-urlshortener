//
//  FlipsideViewController.h
//  PasteUrl
//
//  Created by Steve Hernandez on 4/20/09.
//  Copyright BinaryImplosion 2009. All rights reserved.
//
#define kServiceKey		@"services"
#define kTinyUrlService @"TinyURL"
#define kIsgdService	@"is.gd"
#define kXavccService	@"xav.cc"
#define kSurlmeService	@"surl.me"

@protocol FlipsideViewControllerDelegate;


@interface FlipsideViewController : UIViewController
	<UITableViewDataSource, UITableViewDelegate> {
	id <FlipsideViewControllerDelegate> delegate;
	NSArray *list;
	NSIndexPath *lastIndexPath;
}
@property (nonatomic, assign) id <FlipsideViewControllerDelegate> delegate;
@property (nonatomic, retain) NSArray *list;
@property (nonatomic, retain) NSIndexPath *lastIndexPath;
- (IBAction)done;

@end


@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end