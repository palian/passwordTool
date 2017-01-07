//
//  iPhonePINSetup.h
//  Lock
//
//  Created by Christopher Palian on 7/30/11.
//  Copyright 2011 PALIANTech Ent. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface iPhonePINSetup : UIViewController {

	IBOutlet UITextField *oldPassPhraseField, *theNewPassPhraseField, *verifyPassPhraseField;
	
}

@property(nonatomic, strong)UITextField *oldPassPhraseField, *theNewPassPhraseField, *verifyPassPhraseField;

-(IBAction)removePassPhraseKey;
-(IBAction)setPassPhrase1;
-(IBAction)cancelAction;

@end