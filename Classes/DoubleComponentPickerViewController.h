//  Created by Chris Palian
//  Copyright 2009 PALIANTech Ent. All rights reserved.

#import <UIKit/UIKit.h>
#import "LockAppDelegate.h"
#import <CoreData/CoreData.h>
#import <iAd/iAd.h>


@class RootViewController2;

@interface DoubleComponentPickerViewController : UIViewController <UIPopoverControllerDelegate, UISplitViewControllerDelegate, UITextFieldDelegate> {
	
	IBOutlet ADBannerView *bannerView;

	UIPopoverController *popoverController;
    UIToolbar *toolbar;
	
    RootViewController2 *rootViewController;
	
	IBOutlet	UITextField		*locationField;

	IBOutlet	UITextField		*breadField;
	IBOutlet	UITextField		*fillingField;
	IBOutlet	UITextField		*condomentField;
	
}

@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, assign) IBOutlet RootViewController2 *rootViewController;

@property (retain, nonatomic) UITextField	*locationField;

@property (retain, nonatomic) UITextField	*breadField;
@property (retain, nonatomic) UITextField	*fillingField;
@property (retain, nonatomic) UITextField	*condomentField;

@property (nonatomic, retain) IBOutlet ADBannerView *bannerView;

-(void)moveBannerViewOffscreen;
-(void)moveBannerViewOnscreen;

//@property (nonatomic, assign)	PickersAppDelegate	*delegateRef;

-(IBAction)buttonPressed:(id)sender;
-(IBAction)textFieldDoneEditing:(id)sender;
-(IBAction)clear;
-(IBAction)removeKeyBoard;
@end
