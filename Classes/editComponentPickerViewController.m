//  Created by Chris Palian
//  Copyright 2009 PALIANTech Ent. All rights reserved.

#import "editComponentPickerViewController.h"
#import "RootViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "iPhonePINView.h"

@interface editComponentPickerViewController ()
@property (nonatomic, retain) UIPopoverController *popoverController;
- (void)configureView;
@end

@implementation editComponentPickerViewController

@synthesize locationField,  bannerView;

@synthesize breadField;
@synthesize fillingField;
@synthesize condomentField;
@synthesize editedObject;

@synthesize toolbar, popoverController, rootViewController;

NSError *error;

NSUserDefaults *defaults;

//method which is triggered when the advanced iAd does not recieve an Ad
-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
	[self moveBannerViewOffscreen];
}

//method which is triggered when the advanced iAd does recieve an Ad
-(void)bannerViewDidLoadAd:(ADBannerView *)banner
{
	[self moveBannerViewOnscreen];
}

//method which moves the advanced iAd off of the screen
-(void)moveBannerViewOffscreen
{
	bannerView.hidden=YES;
}

//method which moves the advanced iAd on to the screen
-(void)moveBannerViewOnscreen
{	
	bannerView.hidden=NO;
}


#pragma mark -
#pragma mark Split view support

- (void)setDetailItem:(NSManagedObject *)managedObject {}


- (void)configureView {}

- (void)splitViewController: (UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController 
		  withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController: (UIPopoverController*)pc {
    
    barButtonItem.title = @"Passwords";
    NSMutableArray *items = [[toolbar items] mutableCopy];
    [items insertObject:barButtonItem atIndex:0];
    [toolbar setItems:items animated:YES];
    [items release];
    self.popoverController = pc;
}


// Called when the view is shown again in the split view, invalidating the button and popover controller.
- (void)splitViewController: (UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    
    NSMutableArray *items = [[toolbar items] mutableCopy];
    [items removeObjectAtIndex:0];
    [toolbar setItems:items animated:YES];
    [items release];
    self.popoverController = nil;
}


#pragma mark -
#pragma mark Rotation support

// Ensure that the view controller supports rotation and that the split view can therefore show in both portrait and landscape.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
}




-(IBAction)buttonPressed:(id)sender //save function
{	
	if([locationField.text isEqualToString:@""]||[fillingField.text isEqualToString:@""]||[breadField.text isEqualToString:@""])
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR" message:@"Please enter a website, username and password." delegate:nil cancelButtonTitle:@"Understood" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	else
	{
        LockAppDelegate *appDelegate = (LockAppDelegate *)[[UIApplication sharedApplication] delegate];
		NSManagedObjectContext *context = [appDelegate managedObjectContext];
		
		//NSManagedObject *theLock = [NSEntityDescription insertNewObjectForEntityForName:@"Lock" inManagedObjectContext:context];
		[editedObject setValue:locationField.text forKey:@"lockLocation"];
		[editedObject setValue:fillingField.text forKey:@"lockSlider1"];
		[editedObject setValue:breadField.text forKey:@"lockSlider2"];
		
		//reduces the DVDname to the first letter for the index
		NSString *FLetterString = [locationField.text substringToIndex:1];
		FLetterString = [FLetterString uppercaseString];
		if([FLetterString isEqualToString:@"0"]||[FLetterString isEqualToString:@"1"]||[FLetterString isEqualToString:@"2"]
		   ||[FLetterString isEqualToString:@"3"]||[FLetterString isEqualToString:@"4"]||[FLetterString isEqualToString:@"5"]
		   ||[FLetterString isEqualToString:@"6"]||[FLetterString isEqualToString:@"7"]||[FLetterString isEqualToString:@"8"]
		   ||[FLetterString isEqualToString:@"9"]){FLetterString = @"#";}		
		[editedObject setValue:FLetterString forKey:@"FLetter"];
		
		[context save:&error];
		
		//[myManagedObject setValue:highisONConverter forKey:@"priorityLevel"];
		[self clear];
		[self removeKeyBoard];
		
		[self.navigationController popViewControllerAnimated:YES];	
	}
	
}
	


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		// Initialization code
	}
	return self;
}

- (void)viewDidLoad {
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
	{
		// The device is an iPad running iPhone 4.2 or later.
		[self moveBannerViewOffscreen];

	}
	else
	{
		// The device is an iPhone or iPod touch running 4.2 or later.
		UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Reset" style:UIBarButtonItemStylePlain target:self action:@selector(clear)];          
		self.navigationItem.rightBarButtonItem = anotherButton;
		[anotherButton release];
		
		self.title = @"Edit Data";
		
		[locationField becomeFirstResponder];
	}
	
	locationField.text = [[editedObject valueForKey:@"lockLocation"] description];
	fillingField.text = [[editedObject valueForKey:@"lockSlider1"] description];
	breadField.text = [[editedObject valueForKey:@"lockSlider2"] description];
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}

- (IBAction)textFieldDoneEditing:(id)sender
{
	[locationField resignFirstResponder];
	[fillingField resignFirstResponder];
	[breadField resignFirstResponder];
	[condomentField resignFirstResponder];
	[sender resignFirstResponder];
} 

-(IBAction)removeKeyBoard
{
	[locationField resignFirstResponder];
	[fillingField resignFirstResponder];
	[breadField resignFirstResponder];
	[condomentField resignFirstResponder];
}

-(IBAction)clear
{
	//clears textfields associated with spinners
	locationField.text = [NSString stringWithFormat:@""];
	breadField.text = [NSString stringWithFormat:@""];
	fillingField.text = [NSString stringWithFormat:@""];
	condomentField.text = [NSString stringWithFormat:@""];
	
	[self removeKeyBoard];

}

- (void)dealloc {
	[locationField release];

	[breadField release];
	[fillingField release];
	[condomentField release];
	
	[popoverController release];
    [toolbar release];
	[rootViewController release];
	
	[bannerView release];
	
	[super dealloc];
}

@end
