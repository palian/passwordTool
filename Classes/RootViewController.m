//
//  RootViewController.m
//  Lock
//
//  Created by cspalian on 7/20/09.
//  Copyright New York State Police 2009. All rights reserved.
//

#import "RootViewController.h"
#import "DoubleComponentPickerViewController.h"
#import "editComponentPickerViewController.h"
#import "LockAppDelegate.h"
#import "iPhonePINView.h"
#import "DetailView.h"
#import "InfoViewController.h"

@implementation RootViewController

@synthesize fetchedResultsController, managedObjectContext;
@synthesize tableView, bannerView;

@synthesize searchBar, searchDC;

BOOL EditModeON = FALSE;
UIBarButtonItem *backBarButtonItem1;


-(IBAction)infoAction
{
    InfoViewController *viewController = [[InfoViewController alloc]initWithNibName:@"InfoViewController" bundle:nil];
    viewController.modalTransitionStyle=UIModalTransitionStyleCoverVertical;
    // show the navigation controller modally
    [self presentViewController:viewController animated:YES completion:nil];
}

-(IBAction)editMode
{
	if (EditModeON==FALSE) 
	{
		EditModeON=TRUE;
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Editing" message:@"Editing Mode is ON!" 
													   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
		
		backBarButtonItem1.title=@"View Mode";
	}
	else 
	{
		EditModeON=FALSE;
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not Editing" message:@"Editing Mode is OFF!" 
													   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
		backBarButtonItem1.title=@"Edit Mode";
	}

}

#pragma mark Core Data
- (void) performFetch
{
	
	[NSFetchedResultsController deleteCacheWithName:nil];  
	
	// Init a fetch request
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Lock" inManagedObjectContext:self.managedObjectContext];
	[fetchRequest setEntity:entity];
	
	// Apply an ascending sort for the color items
	//NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"DVDname" ascending:YES selector:nil];
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lockLocation" ascending:YES selector:@selector(caseInsensitiveCompare:)];
	
	NSArray *descriptors = [NSArray arrayWithObject:sortDescriptor];
	[fetchRequest setSortDescriptors:descriptors];
	
	// Recover query
	NSString *query = self.searchBar.text;//lockSlider1
	//if (query && query.length) fetchRequest.predicate = [NSPredicate predicateWithFormat:@"lockLocation contains[cd] %@", query];

    if (query && query.length) fetchRequest.predicate = [NSPredicate predicateWithFormat:@"(lockLocation contains[cd] %@) || (lockSlider1 contains[cd] %@)",query, query];

	// Init the fetched results controller
	NSError *error;
	self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"FLetter" cacheName:@"Root"];
    self.fetchedResultsController.delegate = self;
	[self.fetchedResultsController release];
	if (![[self fetchedResultsController] performFetch:&error])	NSLog(@"Error: %@", [error localizedDescription]);
	
	[fetchRequest release];
	[sortDescriptor release];
    
    [self.tableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
	[self.searchBar setText:@""];

	[self performFetch];
    [self moveBannerViewOffscreen];

}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
	[self performFetch];
    
    [self moveBannerViewOffscreen];
}


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
    CGSize result = [[UIScreen mainScreen] bounds].size;
    if(result.height == 480)
    {// iPhone Classic
       	[tableView setFrame:CGRectMake(0, 0, 320, 416)];
        [bannerView setFrame:CGRectMake(0, 415, 320, 50)];
    }
    if(result.height == 568)
    {// iPhone5
      	[tableView setFrame:CGRectMake(0, 0, 320, 508)];
        [bannerView setFrame:CGRectMake(0, 508, 320, 50)];
    }
}

//method which moves the advanced iAd on to the screen
-(void)moveBannerViewOnscreen
{
    CGSize result = [[UIScreen mainScreen] bounds].size;
    if(result.height == 480)
    {// iPhone Classic
        [tableView setFrame:CGRectMake(0, 0, 320, 416)];
        [bannerView setFrame:CGRectMake(0, 416, 320, 50)];
        
        //Animates the banner view coming back onto the screen
        [UIView beginAnimations:@"moveBanner" context:nil];
        [UIView setAnimationDuration:1.5];
        [tableView setFrame:CGRectMake(0, 0, 320, 366)];
        [bannerView setFrame:CGRectMake(0, 366, 320, 50)];
        [UIView commitAnimations];
    }
    if(result.height == 568) //568-64-50 = 
    {// iPhone5
        [tableView setFrame:CGRectMake(0, 0, 320, 508)];
        [bannerView setFrame:CGRectMake(0, 508, 320, 50)];
        
        //Animates the banner view coming back onto the screen
        [UIView beginAnimations:@"moveBanner" context:nil];
        [UIView setAnimationDuration:1.5];
        [tableView setFrame:CGRectMake(0, 0, 320, 454)];
        [bannerView setFrame:CGRectMake(0, 454, 320, 50)];
        [UIView commitAnimations];
    }
}
 
#pragma mark -
#pragma mark View lifecycle

-(void)addTaskMethod
{	NSLog(@"The add task method was called.");
	DoubleComponentPickerViewController *addtaskview;// = [DoubleComponentPickerViewController alloc]initWithNibName:@"DoubleComponentPickerView" bundle:nil;
    
    CGSize result = [[UIScreen mainScreen] bounds].size;
    if(result.height == 480)
    {// iPhone Classic
        addtaskview = [[DoubleComponentPickerViewController alloc]initWithNibName:@"DoubleComponentPickerView" bundle:nil];
    }
    if(result.height == 568)
    {// iPhone 5
        addtaskview = [[DoubleComponentPickerViewController alloc]initWithNibName:@"DoubleComponentPickerView5" bundle:nil];
    }
	
    [self.navigationController pushViewController:addtaskview animated:YES];
    [addtaskview release];
	addtaskview = nil;
}

-(void)applicationWillTerminate:(NSNotification *)notification
{
	NSLog(@"The application Will Terminate method was called.");
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self moveBannerViewOffscreen];
	
	iPhonePINView *lf;// = [[iPhonePINView alloc]initWithNibName:@"iPhonePINView" bundle:nil];
    
    CGSize result = [[UIScreen mainScreen] bounds].size;
    if(result.height == 480)
    {// iPhone Classic
        lf = [[iPhonePINView alloc]initWithNibName:@"iPhonePINView" bundle:nil];
    }
    if(result.height == 568)
    {// iPhone 5
        lf = [[iPhonePINView alloc]initWithNibName:@"iPhonePINView5" bundle:nil];
    }
    
	//lf.delegate = self;
	//lf.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	lf.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self presentViewController:lf animated:NO completion:nil];

	NSLog(@"The view did load method was called.");
	
	UIApplication *app = [UIApplication sharedApplication];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillTerminate:) name:UIApplicationWillTerminateNotification object:app];
	
    LockAppDelegate *appDelegate = (LockAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSManagedObjectContext *context = [appDelegate managedObjectContext];
	NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Lock" inManagedObjectContext:context];
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entityDescription];
	
	self.title = @"Passwords";

	self.navigationController.navigationBar.tintColor = [UIColor blackColor];
		
	// Set up the edit and add buttons.
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addTaskMethod)];
	self.navigationItem.rightBarButtonItem = addButton;
	[addButton release];
    
	
	NSError *error = nil;
	if (![[self fetchedResultsController] performFetch:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
	
	// Create a search bar
	self.searchBar = [[[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)] autorelease];
	//self.searchBar.tintColor = COOKBOOK_PURPLE_COLOR;
	self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
	self.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
	self.searchBar.keyboardType = UIKeyboardTypeAlphabet;
	self.searchBar.delegate = self;
	self.tableView.tableHeaderView = self.searchBar;
	
	// Create the search display controller
	self.searchDC = [[[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self] autorelease];
	self.searchDC.searchResultsDataSource = self;
	self.searchDC.searchResultsDelegate = self;
    self.searchBar.tintColor = [UIColor blackColor];
	
	// Set up the edit and add buttons.
	//backBarButtonItem1 = [[UIBarButtonItem alloc] initWithTitle:@"Edit Mode" style:UIBarButtonItemStyleBordered target:self action:@selector(editMode)];
	//self.navigationItem.leftBarButtonItem = backBarButtonItem1;
	//[backBarButtonItem1 release];
	
	UIImage* image = [UIImage imageNamed:@"infoButton.png"];
    CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
    UIButton* someButton = [[UIButton alloc] initWithFrame:frame];
    [someButton setBackgroundImage:image forState:UIControlStateNormal];
    [someButton setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem* someBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:someButton];
    [someButton addTarget:self action:@selector(infoAction) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setLeftBarButtonItem:someBarButtonItem];
	
	UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap)];
    
    doubleTap.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:doubleTap];
    
    // Two finger, double tap
    UITapGestureRecognizer *twoFingerDoubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTwoFingerDoubleTap)];
    
    twoFingerDoubleTap.numberOfTapsRequired = 2;
    twoFingerDoubleTap.numberOfTouchesRequired = 2;
    [self.view addGestureRecognizer:twoFingerDoubleTap];
    
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 1.5; //seconds

    UILongPressGestureRecognizer *lpgr2 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    lpgr2.minimumPressDuration = 1.5; //seconds
    
    [self.tableView addGestureRecognizer:lpgr];
    [self.searchDC.searchResultsTableView addGestureRecognizer:lpgr2];
    

}

-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    CGPoint p = [gestureRecognizer locationInView:self.tableView];
    
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:p];
    if (indexPath == nil)
        NSLog(@"long press on table view but not on a row");
    else
    {
        NSLog(@"long press on table view at row %d", indexPath.row);

            editComponentPickerViewController *inspector = [[editComponentPickerViewController alloc] initWithNibName:@"editComponentPickerView" bundle:nil];
            inspector.editedObject = [[self fetchedResultsController] objectAtIndexPath:indexPath];
            
            [self.navigationController pushViewController:inspector animated:YES];
        
	}
}
/*{
    NSArray *sysPaths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString *docDirectory = [sysPaths objectAtIndex:0];
    NSString *PicFilePath1 = [NSString stringWithFormat:@"%@/video1.jpg", docDirectory];
    
    NSString *filename = @"viedo1.jpg";
    NSString *destDir = @"/";
    [[self restClient] uploadFile:filename toPath:destDir withParentRev:nil fromPath:PicFilePath1];
}*/

- (void)handleDoubleTap {
    
    NSLog(@"Single finger, double tap");
}

- (void)handleTwoFingerDoubleTap {
    
    NSLog(@"Two finger, double tap");
}

-(IBAction)dismissView
{
	NSLog(@"Dismissed!");
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

- (void)viewDidUnload {
	// Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
	// For example: self.myOutlet = nil;
}

/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */


#pragma mark -
#pragma mark Add a new object


#pragma mark -
#pragma mark Table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [[fetchedResultsController sections] count];
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
	return [sectionInfo numberOfObjects];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{
	// Display the First Letter of the person's last name as section headings.
	//return [[[fetchedResultsController sections] objectAtIndex:section] name];
	id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
	
	return [NSString stringWithFormat:@"%@", [sectionInfo name]];
}

- (NSInteger)tableView:(UITableView *)tableView1 sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
	
	if (index == 0) {
		// search item
		[tableView1 scrollRectToVisible:[[tableView1 tableHeaderView] bounds] animated:NO];
		return -1;
	}	
	return index-1;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView 
{
	// Return the array of section index titles
	NSArray *searchArray = [NSArray arrayWithObject:UITableViewIndexSearch];
	return [searchArray arrayByAddingObjectsFromArray:self.fetchedResultsController.sectionIndexTitles];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView1 dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
	// Configure the cell.
	NSManagedObject *managedObject = [fetchedResultsController objectAtIndexPath:indexPath];
	cell.textLabel.text = [[managedObject valueForKey:@"lockLocation"] description];
	
	NSString *slide1 = [[managedObject valueForKey:@"lockSlider1"] description];
	NSString *slide2 = [[managedObject valueForKey:@"lockSlider2"] description];

	NSString *combination = [NSString stringWithFormat:@"     Login ID/Pass: %@/%@", slide1, slide2];
	
	cell.detailTextLabel.text = combination;
	
    return cell;
}


- (void)tableView:(UITableView *)tableView1 didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here -- for example, create and push another view controller.

    DetailView *lf1;// = [[DetailView alloc]initWithNibName:@"DetailView" bundle:nil];
    
    CGSize result = [[UIScreen mainScreen] bounds].size;
    if(result.height == 480)
    {// iPhone Classic
        lf1 = [[DetailView alloc]initWithNibName:@"DetailView" bundle:nil];
    }
    if(result.height == 568)
    {// iPhone 5
        lf1 = [[DetailView alloc]initWithNibName:@"DetailView5" bundle:nil];
    }
    
		NSManagedObject *selectedObject = [[self fetchedResultsController] objectAtIndexPath:indexPath];
		lf1.editedObject = selectedObject;
		
		//lf1.modalTransitionStyle =  UIModalTransitionStyleCrossDissolve;
        lf1.modalTransitionStyle =  UIModalTransitionStyleCoverVertical;

    
        [self presentViewController:lf1 animated:YES completion:nil];
		[tableView1 deselectRowAtIndexPath:indexPath animated:YES]; 
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the managed object for the given index path
		NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
		[context deleteObject:[fetchedResultsController objectAtIndexPath:indexPath]];
		
		// Save the context.
		NSError *error;
		if (![context save:&error]) {
			// Update to handle the error appropriately.
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			exit(-1);  // Fail
		}
	}   
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // The table view should not be re-orderable.
    return NO;
}


#pragma mark -
#pragma mark Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (fetchedResultsController != nil) {
        return fetchedResultsController;
    }
    
    /*
	 Set up the fetched results controller.
	*/
	// Create the fetch request for the entity.
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	// Edit the entity name as appropriate.
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Lock" inManagedObjectContext:managedObjectContext];
	[fetchRequest setEntity:entity];
	
	// Set the batch size to a suitable number.
	[fetchRequest setFetchBatchSize:20];
	
	// Edit the sort key as appropriate.
	//NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lockLocation" ascending:YES];
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lockLocation" ascending:YES selector:@selector(caseInsensitiveCompare:)];

	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	
	[fetchRequest setSortDescriptors:sortDescriptors];
	
	// Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
	NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:@"FLetter" cacheName:@"Root"];
    aFetchedResultsController.delegate = self;
	self.fetchedResultsController = aFetchedResultsController;
	
	[aFetchedResultsController release];
	[fetchRequest release];
	[sortDescriptor release];
	[sortDescriptors release];
	
	return fetchedResultsController;
}    


// NSFetchedResultsControllerDelegate method to notify the delegate that all section and object changes have been processed. 
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	// In the simplest, most efficient, case, reload the table view.
	[self.tableView reloadData];
}

/*
 Instead of using controllerDidChangeContent: to respond to all changes, you can implement all the delegate methods to update the table view in response to individual changes.  This may have performance implications if a large number of changes are made simultaneously.

// Notifies the delegate that section and object changes are about to be processed and notifications will be sent. 
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
	[self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
	// Update the table view appropriately.
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
	// Update the table view appropriately.
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	[self.tableView endUpdates];
} 
 */


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	// Relinquish ownership of any cached data, images, etc that aren't in use.
}


- (void)dealloc {
	[fetchedResultsController release];
	[managedObjectContext release];
	
	[tableView release];
	
	bannerView.delegate = nil;
	[bannerView release];
	
	[searchBar release];
	[searchDC release];
	
    [super dealloc];
}


@end

