//
//  MainViewController.h
//  PasteUrl
//
//  Created by Steve Hernandez on 4/20/09.
//  Copyright BinaryImplosion.com 2009. All rights reserved.
//
#define kServiceKey		@"services"
#define kTinyUrlService @"TinyURL"
#define kIsgdService	@"is.gd"
#define kXavccService	@"xav.cc"
#define kSurlmeService	@"surl.me"

#import "FlipsideViewController.h"
#import "MBProgressHUD.h"
#import "BEStatusHUD.h"

@class Reachability;
@interface MainViewController : UIViewController 
<FlipsideViewControllerDelegate, UIActionSheetDelegate, MBProgressHUDDelegate, BEStatusHUDDelegate> {
	IBOutlet UILabel *compressedUrl;
	IBOutlet UITextField *uncompressedUrl;
	IBOutlet UIButton *compressButton;
	IBOutlet UIButton *copyToClipBoardButton;
	IBOutlet UILabel *serviceSelected;
	MBProgressHUD *HUD;
	BEStatusHUD *statusHUD;
	UIActivityIndicatorView *activityIndicator;
	UIActivityIndicatorView *indicator;
	NSMutableDictionary *currentResult;
	NSString *currentElement;
	NSString *lastElement;
	NSMutableArray *results;
	Reachability* hostReach;
	Reachability* internetReach;
    Reachability* wifiReach;
}
@property (retain, nonatomic) UILabel *compressedUrl;
@property (retain, nonatomic) UITextField *uncompressedUrl;
@property (retain, nonatomic) UIButton *compressButton;
@property (retain, nonatomic) UIButton *copyToClipBoardButton;
@property (retain, nonatomic) UILabel *serviceSelected;
@property (retain, nonatomic) UIActivityIndicatorView *activityIndicator;
@property (retain, nonatomic) UIActivityIndicatorView *indicator;
@property (retain, nonatomic) MBProgressHUD *HUD;

- (IBAction)compressUrl:(id)sender;
- (IBAction)textFieldDoneEditing:(id)sender;
- (IBAction)backgroundClick:(id)sender;
- (IBAction)copyToClipBoard:(id)sender;
- (IBAction)showInfo;
- (IBAction)showPreview:(id)sender;
- (NSString *)refreshServiceSelectionField;
- (NSString *)generateRequestURL:(NSString *)url service:(NSString *)svc;
- (NSString *)unshortUrl:(NSString *)url;
- (void) prepareHUDDisplay;
//- (void)intiateCompression;

@end