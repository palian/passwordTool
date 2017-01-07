//
//  iPhonePINView.h
//  Lock
//
//  Created by Christopher Palian on 7/30/11.
//  Copyright 2011 PALIANTech Ent. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kFilename @"OptionsData.plist"

@interface iPhonePINView : UIViewController {

	IBOutlet UITextField *PassPhraseField;
	IBOutlet UILabel *infoLabel;
	
	IBOutlet UISegmentedControl *keyBoardController;
	
}

@property(nonatomic, strong) UITextField *PassPhraseField;
@property(nonatomic, strong) UILabel *infoLabel;

@property(nonatomic, strong) UISegmentedControl *keyBoardController;

-(NSString *)dataFilePath;

-(IBAction)setAction;
-(IBAction)goAction;

-(IBAction)VisitWebSite;

-(IBAction)ChangeKeyBoard:(id)sender;

@end