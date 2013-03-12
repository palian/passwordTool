//
//  RootViewController.h
//  Lock
//
//  Created by cspalian on 7/20/09.
//  Copyright New York State Police 2009. All rights reserved.
//
#import <iAd/iAd.h>

@interface RootViewController : UIViewController <NSFetchedResultsControllerDelegate, ADBannerViewDelegate, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate> {
	NSFetchedResultsController *fetchedResultsController;
	NSManagedObjectContext *managedObjectContext;
	
	IBOutlet ADBannerView *bannerView;
	
	UISearchBar *searchBar;
	UISearchDisplayController *searchDC;
    

}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet ADBannerView *bannerView;

@property (retain) UISearchBar *searchBar;
@property (retain) UISearchDisplayController *searchDC;


-(void)moveBannerViewOffscreen;
-(void)moveBannerViewOnscreen;
-(IBAction)dismissView;
-(IBAction)editMode;
- (void) performFetch;

-(IBAction)infoAction;

@end