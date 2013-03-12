//
//  InfoViewController.m
//  Lock
//
//  Created by Christopher Palian on 2/5/13.
//
//

#import "InfoViewController.h"

@interface InfoViewController ()

- (void)updateButtons;

@end

@implementation InfoViewController

@synthesize linkButton;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.navigationItem.title = @"Info";
    }
    return self;
}
-(IBAction)closeView:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(IBAction)sendData:(id)sender
{
    
}


-(IBAction)receiveData:(id)sender
{
    
}

- (void)didPressLink
{
    [[DBAccountManager sharedManager] linkFromController:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateButtons];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)updateButtons
{
    
}

@end
