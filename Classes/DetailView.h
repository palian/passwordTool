//
//  DetailView.h
//  Lock
//
//  Created by Christopher Palian on 7/31/11.
//  Copyright 2011 PALIANTech Ent. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DetailView : UIViewController {

	IBOutlet UILabel *LabelOne, *LabelTwo, *LabelThree;
	NSManagedObject *editedObject;
}

@property (nonatomic, retain) UILabel *LabelOne, *LabelTwo, *LabelThree;
@property (nonatomic, retain) NSManagedObject *editedObject;

-(IBAction)dismissDetailView;

@end