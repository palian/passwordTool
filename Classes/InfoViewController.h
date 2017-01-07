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

@property (strong, nonatomic) IBOutlet UILabel *linkedUserLabel;
@property (strong, nonatomic) IBOutlet UILabel *lastBackupDateLabel;
@property (nonatomic, strong) IBOutlet UIButton* linkButton;
@property (strong, nonatomic) IBOutlet UIButton *restoreButton;
@property (strong, nonatomic) IBOutlet UIButton *backupButton;

@end