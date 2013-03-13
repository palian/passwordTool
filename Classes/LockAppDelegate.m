//
//  LockAppDelegate.m
//  Lock
//
//  Created by cspalian on 7/20/09.
//  Copyright New York State Police 2009. All rights reserved.
//

#import "LockAppDelegate.h"
#import "RootViewController.h"
#import "iPhonePINView.h"
#import "NSData-AES.h"
#import "NSFileManager-AES.h"
#import "rijndael.h"
#import <Dropbox/Dropbox.h>

@implementation LockAppDelegate
{
    NSDate *_lastBackupDate;
}

@synthesize window;
@synthesize navigationController;

@synthesize splitViewController, detailViewController, rootViewController2;

@synthesize lastBackupDate = _lastBackupDate;

- (void)awakeFromNib
{    
    RootViewController *rootViewController;// = (RootViewController *)[navigationController topViewController];
    

    CGSize result = [[UIScreen mainScreen] bounds].size;
    if(result.height == 480)
    {// iPhone Classic
        rootViewController = [(RootViewController *)[navigationController topViewController] initWithNibName:@"RootViewController" bundle:nil];
    }
    //if(result.height == 568)
    {// iPhone 5
        rootViewController = [(RootViewController *)[navigationController topViewController] initWithNibName:@"RootViewController5" bundle:nil];
    }
    
    rootViewController.managedObjectContext = self.managedObjectContext;
}

- (void)_setupDropboxAPI
{
    DBAccountManager *accountManager = [[DBAccountManager alloc] initWithAppKey:@"8ad9lq3ns5zeefz" secret:@"di5td5cucuracp1"];
	[DBAccountManager setSharedManager:accountManager];
    DBAccount *account = accountManager.linkedAccount;
    
    // if we have a linked account set the file system for it
    if (account)
    {
        DBFilesystem *filesystem = [[DBFilesystem alloc] initWithAccount:account];
        [DBFilesystem setSharedFilesystem:filesystem];
        
        [self _startObservingBackupFile];
    }
}

- (void)_startObservingBackupFile
{
    DBPath *newPath = [[DBPath root] childPath:@"Encrypted.sqlite"];
    
    DBError *error;
    DBFileInfo *fileInfo = [[DBFilesystem sharedFilesystem] fileInfoForPath:newPath error:&error];
    
    if (fileInfo)
    {
		 self.lastBackupDate = fileInfo.modifiedTime;
    }
    
    // observe the backup file path to update the last backup timestamp
    [[DBFilesystem sharedFilesystem] addObserver:self forPath:newPath block:^{
        DBError *error;
        DBFileInfo *fileInfo = [[DBFilesystem sharedFilesystem] fileInfoForPath:newPath error:&error];
        
        if (fileInfo)
        {
			  self.lastBackupDate = fileInfo.modifiedTime;
        }
    }];

}

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
    [self _setupDropboxAPI];
    
    // set all navigation bar style, since you inconsistently use toolbars and navigation bars we set both
    [[UIToolbar appearance] setBarStyle:UIBarStyleBlackOpaque];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlackOpaque];

    [self.window setRootViewController:navigationController];
    [window makeKeyAndVisible];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url sourceApplication:(NSString *)source annotation:(id)annotation
{
    DBAccount *account = [[DBAccountManager sharedManager] handleOpenURL:url];
    if (account)
    {
        DBFilesystem *filesystem = [[DBFilesystem alloc] initWithAccount:account];
        [DBFilesystem setSharedFilesystem:filesystem];
        
        [self _startObservingBackupFile];
        
        NSLog(@"App linked successfully!");
        return YES;
    }
    
    return YES;
}


#pragma mark - Backup/Restore to Dropbox

// creates a file url for a temporary file with unique name
- (NSURL *)_temporaryFileURL
{
    NSString *tmpDir =  NSTemporaryDirectory();
    
    CFUUIDRef newUniqueId = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef newUniqueIdString = CFUUIDCreateString(kCFAllocatorDefault, newUniqueId);
    NSString *tmpPath = [tmpDir stringByAppendingPathComponent:(NSString *)newUniqueIdString];
    CFRelease(newUniqueId);
    CFRelease(newUniqueIdString);
    
    return [NSURL fileURLWithPath:tmpPath];
}


- (void)backupDatabaseToDropbox
{
    NSLog(@"Backup");
    
    NSURL *sourceURL = [NSURL fileURLWithPath:[[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"Lock.sqlite"]];
    NSURL *destinationURL = [self _temporaryFileURL];
    
    NSError *error;
    if (![self encryptDatabaseAtURL:sourceURL toURL:destinationURL error:&error])
    {
        NSLog(@"unable to encrypt DB to %@, %@", [destinationURL path], [error localizedDescription]);
        return;
    }
    
    DBPath *newPath = [[DBPath root] childPath:@"Encrypted.sqlite"];
    DBError *dbError;
    
    // remove previous backup if it exists
    [[DBFilesystem sharedFilesystem] deletePath:newPath error:NULL];
    
    DBFile *file = [[DBFilesystem sharedFilesystem] createFile:newPath error:&dbError];
    
    if (!file)
    {
        NSLog(@"Unable to create Dropbox file %@", [dbError localizedDescription]);
        return;
    }

    if (![file writeContentsOfFile:[destinationURL path] shouldSteal:YES error:&dbError])
    {
        NSLog(@"Unable to write to Dropbox file %@", [dbError localizedDescription]);
        return;
    }
}

- (void)restoreDatabaseFromDropbox
{
    NSLog(@"Restore");
    
    NSString *storePath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"EncryptedTemp.sqlite"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
	
	if ([fileManager fileExistsAtPath:storePath])
	{
        NSError *error1 = nil;
		if (![[NSFileManager defaultManager] AESDecryptFile:[[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"EncryptedTemp.sqlite" ] toFile:[[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"Lock.sqlite"] usingPassphrase:@"ToughC00kiesDong" error:&error1])
		{
			NSLog(@"Failed to write encrypted file. Error = %@", [[error1 userInfo] objectForKey:AESEncryptionErrorDescriptionKey]);
		}
		
		NSLog(@"Encrypted Store Decrypted.");
	}
	else
	{
		NSLog(@"EncryptedTemp does not exist.");
    }
}

-(BOOL)encryptDatabaseAtURL:(NSURL *)sourceURL toURL:(NSURL *)destinationURL error:(NSError **)error
{
    NSAssert([sourceURL isFileURL], @"sourceURL parameter should be a file URL");
    NSAssert([destinationURL isFileURL], @"destinationURL parameter should be a file URL");
    
    NSError *AESError = nil;
    if (![[NSFileManager defaultManager] AESEncryptFile:[sourceURL path] toFile:[destinationURL path] usingPassphrase:@"ToughC00kiesDong" error:&AESError])
    {
        if (error)
        {
            *error = AESError;
        }
        
        NSLog(@"Failed to write encrypted file. Error = %@", [[AESError userInfo] objectForKey:AESEncryptionErrorDescriptionKey]);
        return NO;
    }
    
    return YES;
}

- (void)setLastBackupDate:(NSDate *)lastBackupDate
{
    if (_lastBackupDate != lastBackupDate)
    {
        [_lastBackupDate release];
        
        _lastBackupDate = [lastBackupDate copy];
        
        // send notification
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LockAppDelegateDidUpdateBackup" object:self];
    }
}


#pragma mark -
#pragma mark Saving

/**
 Performs the save action for the application, which is to send the save:
 message to the application's managed object context.
 */
- (IBAction)saveAction:(id)sender
{	
    NSError *error = nil;
    if (![[self managedObjectContext] save:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
    }
}


#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) managedObjectContext
{	
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel
{	
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    return managedObjectModel;
}

/**
 applicationWillTerminate: saves changes in the application's managed object context before the application terminates.
 */
- (void)applicationWillTerminate:(UIApplication *)application
{    
    NSError *error = nil;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
			/*
			 Replace this implementation with code to handle the error appropriately.
			 
			 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
			 */
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
        } 
    }
	
	NSLog(@"Application did register quit function.");
	
	NSError *error1 = nil;
    if (![[NSFileManager defaultManager] AESEncryptFile:[[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"Lock.sqlite"] toFile:[[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"Encrypted.sqlite"] usingPassphrase:@"ToughC00kiesDong" error:&error1])
    {   
        NSLog(@"Failed to write encrypted file. Error = %@", [[error1 userInfo] objectForKey:AESEncryptionErrorDescriptionKey]);
    }
	
	NSLog(@"Store Encrypted.");
	
	NSFileManager *fileManager1 = [NSFileManager defaultManager];
	[fileManager1 removeItemAtPath:[[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"Lock.sqlite"] error:NULL];
	
	NSLog(@"Original Store Deleted.");
    
    
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator 
{
	
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
		
    NSString *storePath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"Encrypted.sqlite"];
	NSString *storePath1 = [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"Lock.sqlite"];

	 NSFileManager *fileManager = [NSFileManager defaultManager];
	
	if ([fileManager fileExistsAtPath:storePath]&&[fileManager fileExistsAtPath:storePath1])
	{
		//Both files exist, the application closed prematurely, use the Lock.sqlite DB
	}
	else 
	{
		// If the expected store doesn't exist, copy the default store.
		if (![fileManager fileExistsAtPath:storePath]) {
			NSString *defaultStorePath = [[NSBundle mainBundle] pathForResource:@"Encrypted" ofType:@"sqlite"];
			if (defaultStorePath) { [fileManager copyItemAtPath:defaultStorePath toPath:storePath error:NULL];}
		}
		
		NSError *error1 = nil;
		if (![[NSFileManager defaultManager] AESDecryptFile:[[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"Encrypted.sqlite" ] toFile:[[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"Lock.sqlite"] usingPassphrase:@"ToughC00kiesDong" error:&error1])
		{   
			NSLog(@"Failed to write encrypted file. Error = %@", [[error1 userInfo] objectForKey:AESEncryptionErrorDescriptionKey]);
		}
		
		NSLog(@"Encrypted Store Decrypted.");	
	}
	
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"Lock.sqlite"]];
	
	NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
    }    
	
    return persistentStoreCoordinator;
}


#pragma mark -
#pragma mark Application's documents directory

/**
 Returns the path to the application's documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
	
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	
    [managedObjectContext release];
    [managedObjectModel release];
    [persistentStoreCoordinator release];
    
	[navigationController release];
	[window release];
	[super dealloc];
}


@end

