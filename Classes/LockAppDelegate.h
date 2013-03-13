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

@interface LockAppDelegate : NSObject <UIApplicationDelegate> {
    
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;	    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
	
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

@property (nonatomic, retain) IBOutlet UISplitViewController *splitViewController;
@property (nonatomic, retain) IBOutlet RootViewController2 *rootViewController2;
@property (nonatomic, retain) IBOutlet DoubleComponentPickerViewController *detailViewController;

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, readonly) NSString *applicationDocumentsDirectory;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

