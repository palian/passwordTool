//
//  LockAppDelegate.h
//  Lock
//
//  Created by cspalian on 7/20/09.
//  Copyright New York State Police 2009. All rights reserved.
//

#import <Dropbox/Dropbox.h>

@class RootViewController2;
@class DoubleComponentPickerViewController;

@interface LockAppDelegate : NSObject <UIApplicationDelegate>
{
	UISplitViewController *splitViewController;
	
	RootViewController2 *rootViewController2;
	DoubleComponentPickerViewController *detailViewController;

    UIWindow *window;
    UINavigationController *navigationController;
    
    NSString *relinkUserId;
}

- (IBAction)saveAction:sender;

/**
 Creates an encrypted version of the database and saves it to Dropbox
 */
- (void)backupDatabaseToDropbox;

/**
 Retrieves an encrypted version of the datase from dropbox
 */
- (void)restoreDatabaseFromDropbox;


/**
 Retrieves the last modification date of the backup file
 @returns the latest known backup date or `nil` if none available
 */
@property (nonatomic, copy) NSDate *lastBackupDate;

@property (nonatomic, strong) IBOutlet UISplitViewController *splitViewController;
@property (nonatomic, strong) IBOutlet RootViewController2 *rootViewController2;
@property (nonatomic, strong) IBOutlet DoubleComponentPickerViewController *detailViewController;

@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (weak, nonatomic, readonly) NSString *applicationDocumentsDirectory;

@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) IBOutlet UINavigationController *navigationController;

@end

