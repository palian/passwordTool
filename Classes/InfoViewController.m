//
//  InfoViewController.m
//  Lock
//
//  Created by Christopher Palian on 2/5/13.
//
//

#import "InfoViewController.h"

@implementation InfoViewController

@synthesize linkButton;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.navigationItem.title = @"Info";
        
        [[DBAccountManager sharedManager] addObserver:self block: ^(DBAccount *account) {
            NSLog(@"updated");
            [self updateStatus];
        }];
    }
    return self;
}

- (void)dealloc
{
    [[DBAccountManager sharedManager] removeObserver:self];
    
    [_linkedUserLabel release];
    [super dealloc];
}

- (void)updateStatus
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    DBAccount *account = [DBAccountManager sharedManager].linkedAccount;
    
    // update the button and user name label
    if (account.linked)
    {
        [self.linkButton setTitle:@"Unlink Dropbox" forState:UIControlStateNormal];

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
    }
}


-(IBAction)sendData:(id)sender
{
    
}


-(IBAction)receiveData:(id)sender
{
    
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
}


@end
