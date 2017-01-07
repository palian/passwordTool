//
//  iPhonePINView.m
//  Lock
//
//  Created by Christopher Palian on 7/30/11.
//  Copyright 2011 PALIANTech Ent. All rights reserved.
//

#import "iPhonePINView.h"
#import "iPhonePINSetup.h"
#import "PIN.h"
#import "LockAppDelegate.h"

@implementation iPhonePINView
@synthesize PassPhraseField,infoLabel, keyBoardController;

NSError *__autoreleasing *error;

-(NSString *)dataFilePath
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	return [documentsDirectory stringByAppendingPathComponent:kFilename];
}

-(IBAction)ChangeKeyBoard:(id)sender
{
	[PassPhraseField resignFirstResponder];
	
	if(keyBoardController.selectedSegmentIndex == 0){PassPhraseField.keyboardType=UIKeyboardTypeASCIICapable;}
	if(keyBoardController.selectedSegmentIndex == 1){PassPhraseField.keyboardType=UIKeyboardTypeNumberPad;}
	if(keyBoardController.selectedSegmentIndex == 2){PassPhraseField.keyboardType=UIKeyboardTypeNumbersAndPunctuation;}
	
	[PassPhraseField becomeFirstResponder];
	
	NSMutableArray *array = [[NSMutableArray alloc] init]; //stores desired objects in an array to save the data
	
	NSString *KeyboardType;
	if(keyBoardController.selectedSegmentIndex ==0){KeyboardType=@"0";}
	else if(keyBoardController.selectedSegmentIndex ==1){KeyboardType=@"1";}
	else if(keyBoardController.selectedSegmentIndex ==2){KeyboardType=@"2";}
	else {KeyboardType=@"0";}
	
	[array addObject:KeyboardType]; //stores Keyboard Type
	
	[array writeToFile:[self dataFilePath] atomically:YES];
}

-(IBAction)VisitWebSite
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.PALIANTech.com"]];
}

-(IBAction)setAction
{
	iPhonePINSetup *lf;// = [[iPhonePINSetup alloc]initWithNibName:@"iPhonePINSetup" bundle:nil];
    
    CGSize result = [[UIScreen mainScreen] bounds].size;
    if(result.height == 480)
    {
        // iPhone Classic
        lf = [[iPhonePINSetup alloc]initWithNibName:@"iPhonePINSetup" bundle:nil];
    }
    if(result.height == 568)
    {
        // iPhone 5
        lf = [[iPhonePINSetup alloc]initWithNibName:@"iPhonePINSetup5" bundle:nil];
    }
    
	//lf.delegate = self;
	//lf.modalTransitionStyle =  UIModalTransitionStyleCrossDissolve;
	lf.modalTransitionStyle =  UIModalTransitionStyleCoverVertical;
    [self presentViewController:lf animated:YES completion:nil];
}

-(IBAction)goAction
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
	for (int i=0; i<array.count; i++) {		
		PIN *thePIN = [array objectAtIndex:i];
		
		lastPassPhrase = [NSString stringWithFormat:@"%@",thePIN.passPhrase];
	}
	
	if([lastPassPhrase isEqualToString:@"PALIANTech"])
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"SETUP NEEDED" message:@"Please enter the setup and setup a PassPhrase." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
	}		
	else if([PassPhraseField.text isEqualToString:lastPassPhrase])
	{
        [self dismissViewControllerAnimated:YES completion:nil];
	}
	else
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"INCORRECT" message:@"The PassPhrase you entered is incorrect. Please Try Again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
	}
	
	[PassPhraseField resignFirstResponder];
}

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

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	NSString *filePath = [self dataFilePath];
	if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
	{
		NSArray *array = [[NSArray alloc] initWithContentsOfFile:filePath];
		
		NSString *KeyBoardType;
		KeyBoardType = [array objectAtIndex:0];  //pulls the keyboard type from the saved file
		if([KeyBoardType isEqualToString:@"0"]){keyBoardController.selectedSegmentIndex=0;}
		else if([KeyBoardType isEqualToString:@"1"]){keyBoardController.selectedSegmentIndex=1;}
		else if([KeyBoardType isEqualToString:@"2"]){keyBoardController.selectedSegmentIndex=2;}
		else{keyBoardController.selectedSegmentIndex=0;}
		
	}	
	
	[PassPhraseField becomeFirstResponder];

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
