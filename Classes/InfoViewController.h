//
//  InfoViewController.h
//  Lock
//
//  Created by Christopher Palian on 2/5/13.
//
//

#import <UIKit/UIKit.h>
#import <Dropbox/Dropbox.h>

@interface InfoViewController : UIViewController 
{

}

-(IBAction)didPressLink;
-(IBAction)sendData:(id)sender;
-(IBAction)receiveData:(id)sender;

@property (retain, nonatomic) IBOutlet UILabel *linkedUserLabel;
@property (retain, nonatomic) IBOutlet UILabel *lastBackupDateLabel;
@property (nonatomic, retain) IBOutlet UIButton* linkButton;
@property (retain, nonatomic) IBOutlet UIButton *restoreButton;
@property (retain, nonatomic) IBOutlet UIButton *backupButton;

@end