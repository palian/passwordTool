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

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet ADBannerView *bannerView;

@property (strong) UISearchBar *searchBar;
@property (strong) UISearchDisplayController *searchDC;


-(void)moveBannerViewOffscreen;
-(void)moveBannerViewOnscreen;
-(IBAction)dismissView;
-(IBAction)editMode;
- (void) performFetch;

-(IBAction)infoAction;

@end