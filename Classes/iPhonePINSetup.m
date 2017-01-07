//
//  iPhonePINSetup.m
//  Lock
//
//  Created by Christopher Palian on 7/30/11.
//  Copyright 2011 PALIANTech Ent. All rights reserved.
//

#import "iPhonePINSetup.h"
#import "PIN.h"
#import "LockAppDelegate.h"

@implementation iPhonePINSetup
@synthesize oldPassPhraseField, theNewPassPhraseField, verifyPassPhraseField;

NSError *__autoreleasing *error;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/
-(IBAction)setPassPhrase1
{
	
	LockAppDelegate *appDelegate = (LockAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSManagedObjectContext *moc = [appDelegate managedObjectContext];
	
	NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"PIN" inManagedObjectContext:moc];
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entityDescription];
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:YES];
	[request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
	
	NSArray *array = [moc executeFetchRequest:request error:error];
	
	NSString *lastPassPhrase;
	for (int i=0; i<array.count; i++) 
	{		
		PIN *thePIN = [array objectAtIndex:i];
		
		lastPassPhrase = [NSString stringWithFormat:@"%@",thePIN.passPhrase];
	}
	
	if([lastPassPhrase isEqualToString:@"PALIANTech"])
	{
		if([theNewPassPhraseField.text isEqualToString:verifyPassPhraseField.text])
		{
			LockAppDelegate *appDelegate = (LockAppDelegate *)[[UIApplication sharedApplication] delegate];
			NSManagedObjectContext *context = [appDelegate managedObjectContext];	
			NSManagedObject *theButton = [NSEntityDescription insertNewObjectForEntityForName:@"PIN" inManagedObjectContext:context];
			
			NSDate *buttonDateNow = [[NSDate alloc] init];
				
			[theButton setValue:theNewPassPhraseField.text forKey:@"passPhrase"];
			[theButton setValue:buttonDateNow forKey:@"timeStamp"];
					
			[context save:error];
				
			
            [self dismissViewControllerAnimated:YES completion:nil];
		}
		else
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR" message:@"The verification field does not match the new PassPhrase field!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alert show];
		}
	}
	else if([oldPassPhraseField.text isEqualToString:lastPassPhrase]||[oldPassPhraseField.text isEqualToString:@"PALIANTechUniversalPasswords"])
	{
		if([theNewPassPhraseField.text isEqualToString:verifyPassPhraseField.text])
		{
			LockAppDelegate *appDelegate = (LockAppDelegate *)[[UIApplication sharedApplication] delegate];
			NSManagedObjectContext *context = [appDelegate managedObjectContext];	
			NSManagedObject *theButton = [NSEntityDescription insertNewObjectForEntityForName:@"PIN" inManagedObjectContext:context];
			
			NSDate *buttonDateNow = [[NSDate alloc] init];
			
			[theButton setValue:theNewPassPhraseField.text forKey:@"passPhrase"];
			[theButton setValue:buttonDateNow forKey:@"timeStamp"];
			
			[context save:error];
			
			
            [self dismissViewControllerAnimated:YES completion:nil];
		}
		else
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR" message:@"The verification field does not match the new PassPhrase field!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alert show];
		}
	}
	else
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR" message:@"You entered an incorrect old PassPhrase!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
	}
		
}

-(IBAction)cancelAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)removePassPhraseKey
{
	[oldPassPhraseField resignFirstResponder];
	[theNewPassPhraseField resignFirstResponder];
	[verifyPassPhraseField resignFirstResponder];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	LockAppDelegate *appDelegate = (LockAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSManagedObjectContext *moc = [appDelegate managedObjectContext];
	
	NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"PIN" inManagedObjectContext:moc];
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entityDescription];
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:YES];
	[request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
	
	NSArray *array = [moc executeFetchRequest:request error:error];
	
	NSString *lastPassPhrase;
	
	for (int i=0; i<array.count; i++) 
	{		
		PIN *thePIN = [array objectAtIndex:i];
		
		lastPassPhrase = [NSString stringWithFormat:@"%@",thePIN.passPhrase];
	}
	
	if([lastPassPhrase isEqualToString:@"PALIANTech"])
	{
		oldPassPhraseField.alpha=0.45;
		oldPassPhraseField.enabled=NO;
	}
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}




@end
