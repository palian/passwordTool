//
//  InfoViewController.m
//  Lock
//
//  Created by Christopher Palian on 2/5/13.
//
//

#import "InfoViewController.h"
#import "LockAppDelegate.h"

@implementation InfoViewController

@synthesize linkButton;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.navigationItem.title = @"Info";
        
        // get notified if the backup timestamp changes
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backupDateChanged:) name:@"LockAppDelegateDidUpdateBackup" object:nil];
        
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[DBAccountManager sharedManager] removeObserver:self];
    
}

- (void)updateStatus
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    DBAccount *account = [DBAccountManager sharedManager].linkedAccount;
    
    // update the button and user name label
    if (account.linked)
    {
        [self.linkButton setTitle:@"Unlink Dropbox" forState:UIControlStateNormal];
        self.restoreButton.enabled = YES;
        self.backupButton.enabled = YES;

        if (account.info)
        {
            NSLog(@"Account '%@' linked", account.info.displayName);
            
            self.linkedUserLabel.text = [NSString stringWithFormat:@"Linked Dropbox: %@", account.info.displayName];
        }
        else
        {
            NSLog(@"No info yet on linked account");

            // there's a bug in the API that the info is not available right away
            [self performSelector:@selector(updateStatus) withObject:nil afterDelay:0.1];
        }
    }
    else
    {
        NSLog(@"Account unlinked");
        
        self.linkedUserLabel.text = nil;
        [self.linkButton setTitle:@"Link Dropbox" forState:UIControlStateNormal];
        
        self.restoreButton.enabled = NO;
        self.backupButton.enabled = NO;
    }
}

- (void)_updateRestoreState
{
    LockAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    NSDate *date = [appDelegate lastBackupDate];
    
    if (!date)
    {
        [self.restoreButton setTitle:@"No Backup Available" forState:UIControlStateNormal];
        self.lastBackupDateLabel.text = nil;
        self.restoreButton.enabled = NO;
    }
    else
    {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        df.dateStyle = NSDateFormatterMediumStyle;
        df.timeStyle = NSDateFormatterMediumStyle;
        
        NSString *dateString = [df stringFromDate:date];
        NSString *title = [NSString stringWithFormat:@"Last Backup: %@", dateString];
        self.lastBackupDateLabel.text = title;
        
        [self.restoreButton setTitle:@"Restore Backup" forState:UIControlStateNormal];
        self.restoreButton.enabled = YES;
    }
}


-(IBAction)sendData:(id)sender
{
    LockAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    [appDelegate backupDatabaseToDropbox];
}


-(IBAction)receiveData:(id)sender
{
    LockAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    [appDelegate restoreDatabaseFromDropbox];
}

- (void)didPressLink
{
    DBAccountManager *manager = [DBAccountManager sharedManager];
    
    if (manager.linkedAccount.linked)
    {
        // we have an account, unlink it
        [manager.linkedAccount unlink];
    }
    else
    {
        // link account
        [[DBAccountManager sharedManager] linkFromController:self];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateStatus];
    
    // observe the account so that we can update the buttons
    [[DBAccountManager sharedManager] addObserver:self block: ^(DBAccount *account) {
        NSLog(@"updated");
        [self updateStatus];
    }];
    
    [self _updateRestoreState];
}

- (void)backupDateChanged:(NSNotification *)notification
{
    [self _updateRestoreState];
}

@end
