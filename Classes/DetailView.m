//
//  DetailView.m
//  Lock
//
//  Created by Christopher Palian on 7/31/11.
//  Copyright 2011 PALIANTech Ent. All rights reserved.
//

#import "DetailView.h"


@implementation DetailView

@synthesize LabelOne, LabelTwo, LabelThree;
@synthesize editedObject;

-(IBAction)dismissDetailView
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
	
	
	LabelOne.text = [[editedObject valueForKey:@"lockLocation"] description];
	LabelTwo.text = [[editedObject valueForKey:@"lockSlider1"] description];;
	LabelThree.text = [[editedObject valueForKey:@"lockSlider2"] description];;

}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
	
	return YES;
}


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
