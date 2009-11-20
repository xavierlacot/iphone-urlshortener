//
//  FlipsideViewController.m
//  PasteUrl
//
//  Created by Steve Hernandez on 4/20/09.
//  Copyright BinaryImplosion 2009. All rights reserved.
//

#import "FlipsideViewController.h"


@implementation FlipsideViewController

@synthesize delegate;
@synthesize list;
@synthesize lastIndexPath;


- (void)viewDidLoad {
	self.view.backgroundColor = [UIColor viewFlipsideBackgroundColor]; 
    NSArray *array = [[NSArray alloc] initWithObjects:@"TinyURL", @"tr.im", @"is.gd", nil];
	self.list = array;
	[array release];
	
	[super viewDidLoad];
}

- (IBAction)done {
	[self.delegate flipsideViewControllerDidFinish:self];	
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)dealloc {
	[list release];
	[lastIndexPath release];
    [super dealloc];
}

#pragma mark -
#pragma mark Table Data Source Methods

/*- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	return [list count];
	
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{	
	static NSString *CheckMarkCellIdentifier = @"CheckMarkCellIdentifier";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CheckMarkCellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero
									   reuseIdentifier: CheckMarkCellIdentifier] autorelease];
	}
	NSUInteger row = [indexPath row];
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *previousRow = [defaults objectForKey:kServiceKey];
	NSUInteger oldRow = 0;
	if ([previousRow isEqualToString:kTinyUrlService]) {
		oldRow = 0;
	}
	else if ([previousRow isEqualToString:kTrimService]) {
		oldRow = 1;
	}
	else if ([previousRow isEqualToString:kIsgdService]) {
		oldRow = 2;
	}
	else {
		oldRow = (lastIndexPath != nil) ? [lastIndexPath row] : -1;
	}
	
	[cell.textLabel setText:[list objectAtIndex:row]];
		
	cell.accessoryType = (row == oldRow) ? 
		UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
	
	if (row == oldRow) {
		lastIndexPath = indexPath;
	}
		
	return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{	
	return @"Services";
}

#pragma mark -
#pragma mark Table Delegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	int newRow = [indexPath row];
	int oldRow = [lastIndexPath row];
	//int oldRow = (lastIndexPath != nil) ? [lastIndexPath row] : -1;
	
	if (newRow != oldRow)
	{
		UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
		newCell.accessoryType = UITableViewCellAccessoryCheckmark;
		
		UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:lastIndexPath];
		oldCell.accessoryType = UITableViewCellAccessoryNone;
		
		lastIndexPath = indexPath;
	}
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	// Grab the value of the row!//////////////
	NSString *rowValue = [list objectAtIndex:newRow];
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:rowValue forKey:kServiceKey];
	
}

@end
