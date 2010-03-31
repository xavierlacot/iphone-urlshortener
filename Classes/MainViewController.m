//
//  MainViewController.m
//  PasteUrl
//
//  Created by Steve Hernandez on 4/20/09.
//  Copyright BinaryImplosion.com 2009. All rights reserved.
//

#import "MainViewController.h"
#import "MainView.h"
#import "RegexKitLite.h"
#import "Reachability.h"


@implementation MainViewController
@synthesize compressedUrl;
@synthesize uncompressedUrl;
@synthesize compressButton;
@synthesize copyToClipBoardButton;
@synthesize serviceSelected;
@synthesize activityIndicator;
@synthesize indicator;
@synthesize HUD;
	
#pragma mark -
#pragma mark Action Methods (IBAction)

- (IBAction)backgroundClick:(id)sender {
	[uncompressedUrl resignFirstResponder];
}

- (IBAction)compressUrl:(id)sender {
	// Should be initialized with the windows frame so the HUD disables all user input by covering the entire screen
	HUD = [[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
	
	// Add HUD to screen
	[self.view.window addSubview:HUD];
	
	// Regisete for HUD callbacks so we can remove it from the window at the right time
	HUD.delegate = self;
	
	HUD.labelText = @"Loading";
	HUD.detailsLabelText = @"retrieving shortened Url...";
	
	// Show the HUD while the provided method executes in a new thread
	[HUD showWhileExecuting:@selector(initiateCompression) onTarget:self withObject:nil animated:YES];
}

- (IBAction)copyToClipBoard:(id)sender {
	
	// Only allow urls to copyied to the clipboard
	UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
	BOOL isValidUrl;
	NSString *errorMsg = nil;
	NSString *regexUrlString = @"\\b(https?)://([a-zA-Z0-9\\-.]+)((?:/[a-zA-Z0-9\\-._?,'+\\&%$=~*!():@\\\\]*)+)?";
	NSString *urlCandidateForClipboard = compressedUrl.text;
	if([urlCandidateForClipboard isMatchedByRegex:regexUrlString]) {
		// Place compressed url into pasteboard
		[pasteBoard setString:compressedUrl.text];
		isValidUrl = YES;
	}
	else {
		errorMsg = [[NSString alloc] initWithFormat:@"%@ is not a valid Url.", urlCandidateForClipboard];
		isValidUrl = NO;
	}
	
	// If pasteBoard has something go ahead and display status message.
	if (isValidUrl) {
		// Should be initialized with the windows frame so the HUD disables all user input by covering the entire screen
		statusHUD = [[BEStatusHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
		
		// Add HUD to screen
		[self.view.window addSubview:statusHUD];
		
		// Register for StatusHUD callbacks so we can remove it from the window at the right time
		statusHUD.delegate = self;
		
		statusHUD.labelText = @"Added to Clipboard";
		statusHUD.detailsLabelText = (@"%@ added to Clipboard", pasteBoard.string);
		
		// Show the StatusHUD while the provided method executes in a new thread
		[statusHUD showWhileExecuting:@selector(timer) onTarget:self withObject:nil animated:YES];
	}
	else {
		UIAlertView *alert = [[UIAlertView alloc]
							  initWithTitle:@"Error" 
							  message:errorMsg 
							  delegate:nil
							  cancelButtonTitle:@"Ok" 
							  otherButtonTitles:nil]; 
		[alert show];
		[alert release];
		[errorMsg release];
	}
	
}

- (IBAction)showInfo {    
	FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
	controller.delegate = self;
	
	controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:controller animated:YES];
	
	[controller release];
}

- (IBAction)showPreview:(id)sender {
	NSString *url = uncompressedUrl.text;
	NSString *tinyRequestUrl = [[NSString alloc] initWithFormat:@"http://tinyurl.com/api-create.php?url=%@", url];
	NSURL *generateUrl = [[NSURL alloc] initWithString:tinyRequestUrl];
	NSString *displayText = [NSString stringWithContentsOfURL:generateUrl usedEncoding: NULL error:NULL];
	NSURL *previewUrl = [[NSURL alloc] initWithString:displayText];
	[[UIApplication sharedApplication] openURL:previewUrl];
	
}

- (IBAction)textFieldDoneEditing:(id)sender {
	[sender resignFirstResponder];
}

#pragma mark 
#pragma mark Helper methods

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if (!buttonIndex == [actionSheet cancelButtonIndex]) {
		NSString *msg = nil;
		
		if (compressedUrl.text.length > 0) {
			msg = [[NSString alloc] initWithFormat:@"Successfully copied %@ to Clipboard", compressedUrl.text];
		} else {
			msg = @"Error!";
		} 
					
		UIAlertView *alert = [[UIAlertView alloc]
							  initWithTitle:@"Added to Clipboard" 
							  message:msg 
							  delegate:nil
							  cancelButtonTitle:@"Ok" 
							  otherButtonTitles:nil]; 
		[alert show];
		[alert release];
		[msg release];
	}
}

- (NSString *)generateRequestURL:(NSString *)url service:(NSString *)service {
	NSString *serviceRequestUrl;
	// Let's check to see if this works!˙
	if ([service isEqualToString:kTinyUrlService]) {
		serviceRequestUrl = [[NSString alloc] initWithFormat:@"http://tinyurl.com/api-create.php?url=%@", url];
	} else if ([service isEqualToString:kIsgdService]) {
		serviceRequestUrl = [[NSString alloc] initWithFormat:@"http://is.gd/api.php?longurl=%@", url];
	} else if ([service isEqualToString:kTrimService]) {
		serviceRequestUrl = [[NSString alloc] initWithFormat:@"http://api.tr.im/api/trim_simple?url=%@", url];
	} else {
		NSString *displayText = @"Service Not Selected";
		NSLog(@"Results: %@",displayText );
		return displayText;
	}
	NSURL *generateUrl = [[[NSURL alloc] initWithString:serviceRequestUrl] autorelease];
	NSString *displayText = [NSString stringWithContentsOfURL:generateUrl usedEncoding: NULL error:NULL];
	NSLog(@"Results: %@",displayText );
	return displayText;
} 

- (void)hudWasHidden {
	// Remove HUD from screen when the HUD was hidden
	[HUD removeFromSuperview];
	[HUD release];
}

- (void) initiateCompression {
	NSString *url = uncompressedUrl.text;
	NSString *serviceCheck = self.refreshServiceSelectionField;
	NSString *modifiedURL;
	if (serviceCheck != NULL) {
		modifiedURL = [self generateRequestURL:url service:serviceCheck];
	}
	else {
		modifiedURL = @"Service Not Selected";
	}
	compressedUrl.text = modifiedURL;
}

- (void) prepareHUDDisplay {
	
	// --- Status Bar Indicator ---
	//UIApplication* app = [UIApplication sharedApplication];
	//app.networkActivityIndicatorVisible = YES; // to stop it, set this to NO
	// -----
	
	// Should be initialized with the windows frame so the HUD disables all user input by covering the entire screen
	HUD = [[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
	
	// Add HUD to screen
	[self.view.window addSubview:HUD];
	
	// Regisete for HUD callbacks so we can remove it from the window at the right time
	HUD.delegate = self;
	
	HUD.labelText = @"Loading";
	HUD.detailsLabelText = @"retrieving shortened URL...";
	
	// Show the HUD while the provided method executes in a new thread
	[HUD showWhileExecuting:@selector(initiateCompression) onTarget:self withObject:nil animated:YES];
	
	//app.networkActivityIndicatorVisible = NO;
}

// Private method that will check default settings when called.
- (NSString *)refreshServiceSelectionField {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSLog(@"default service is %@", defaults);
	
	//serviceSelected.text = [defaults objectForKey:kServiceKey];
	NSLog(@"objectForKey %@", [defaults objectForKey:kServiceKey]);
	if ([defaults objectForKey:kServiceKey] != NULL) {
		compressedUrl.text = [defaults objectForKey:kServiceKey];
		return [defaults objectForKey:kServiceKey];
	}
	else {
		// default to TinyURL
		compressedUrl.text = @"TinyUrl";
		NSLog(@"label: ", compressedUrl.text);
		//return [defaults objectForKey:kTinyUrlService];
		return kTinyUrlService;
	}
}

- (void)statusHudWasHidden {
	// Remove the status HUD from the screen when the HUD is hidden
	[statusHUD removeFromSuperview];
	[statusHUD release];
}

- (void) timer {
	// will display status message
	sleep(3);
}

// Private method that will take any url and unshort it using the untiny.me service
- (NSString *)unshortUrl:(NSString *)url {
	NSString *errorMsg = @"error";
	NSString *svcRequestUrl = [[NSString alloc] initWithFormat:@"http://untiny.me/api/1.0/extract?url=%@&format=text", url];
	NSURL *generateUrl = [[NSURL alloc] initWithString:svcRequestUrl];
	if (generateUrl != nil) {
		return [NSString stringWithContentsOfURL:generateUrl usedEncoding: NULL error:NULL];
	}
	else {
		return errorMsg;
	}
	
}

#pragma mark 
#pragma mark UIViewController Delegates

- (void)dealloc {
	[compressedUrl release];
	[serviceSelected release];
	[indicator release];
	[HUD release];
	[statusHUD release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller {
	[self dismissModalViewControllerAnimated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;	
}

/*- (void)viewDidLoad {
	
}*/

//Called by Reachability whenever status changes.
- (void) reachabilityChanged: (NSNotification* )note
{
	Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
	//[self updateInterfaceWithReachability: curReach];
}


-(BOOL)connectedToInternet: (Reachability*) curReach {
	
	NetworkStatus netStatus = [curReach currentReachabilityStatus];
	NSString* statusString= @"";
	switch (netStatus) {
		case NotReachable:
		{
			statusString = @"Access Not Available";
			NSLog(@"Logging: %@", statusString);
			return NO;
			break;
		}
		case ReachableViaWWAN:
		{
			statusString = @"Reachable WWAN";
			NSLog(@"Logging: %@", statusString);
			return YES;
			break;
		}
		case ReachableViaWiFi:
		{
			statusString = @"Reachable WiFi";
			NSLog(@"Logging: %@", statusString);
			return YES;
			break;
		}
		default:
			return NO;
			break;
	}
	
}

- (void)viewDidAppear:(BOOL)animated {
	
	// Observe the kNetworkReachabilityChangedNotification. When that notification is posted, the
    // method "reachabilityChanged" will be called. 
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
		
	internetReach = [[Reachability reachabilityForInternetConnection] retain];
	[internetReach startNotifer];
	if(![self connectedToInternet: internetReach]) {
		UIAlertView *alertInternetConnection = [[UIAlertView alloc]
							  initWithTitle:@"Error" 
							  message:@"Internet connection is unavailable." 
							  delegate:nil
							  cancelButtonTitle:@"Ok" 
							  otherButtonTitles:nil]; 
		[alertInternetConnection show];
		[alertInternetConnection release];
	}
	
	[super viewDidAppear:YES];
	
	// Check the url shortening service from settings
	[self refreshServiceSelectionField];
	
	// Grab the first item from the pasteboard and check if there is 
	// a url to shorten.
	UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
	NSString *firstItemInPasteBoardString = pasteBoard.string;
	
	// Prepare regex items to setup strings for text field display
	NSString *regexString = @"\\b(https?)://([a-zA-Z0-9\\-.]+)((?:/[a-zA-Z0-9\\-._?,'+\\&%$=~*!():@\\\\]*)+)?";
	NSString *regexTinyUrlString = @"(\\b(https?)://)?(tinyurl.com/)";
	NSString *regexTrimUrlString = @"(\\b(https?)://)?(tr.im/)";
	NSString *regexIsgdUrlString = @"(\\b(https?)://)?(is.gd/)";
	
	if([firstItemInPasteBoardString isMatchedByRegex:regexString]) {
		if ([firstItemInPasteBoardString isMatchedByRegex:regexTinyUrlString]) {
			uncompressedUrl.text = [self unshortUrl:firstItemInPasteBoardString];
		}
		else if ([firstItemInPasteBoardString isMatchedByRegex:regexTrimUrlString]) {
			uncompressedUrl.text = [self unshortUrl:firstItemInPasteBoardString];
		}
		else if ([firstItemInPasteBoardString isMatchedByRegex:regexIsgdUrlString]) {
			uncompressedUrl.text = [self unshortUrl:firstItemInPasteBoardString];
		}
		else {
			uncompressedUrl.text = firstItemInPasteBoardString;
			self.prepareHUDDisplay;
		}
	}
	else {
		NSLog(@"Sorry... No URL Found: %@", firstItemInPasteBoardString);
		uncompressedUrl.text =  @"Copy a URL to your clipboard";
	}
}

@end
