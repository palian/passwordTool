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

- (IBAction)didPressLink;
-(IBAction)closeView:(id)sender;
-(IBAction)sendData:(id)sender;
-(IBAction)receiveData:(id)sender;

@property (nonatomic, retain) IBOutlet UIButton* linkButton;

@end