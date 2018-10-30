//
//  surveycategory.h
//  Occupant survey
//
//  Created by Group X on 03/07/15.
//  Copyright (c) 2015 usgbc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface surveycategory : UIViewController <UIAlertViewDelegate>
{
    NSUserDefaults *prefs;
    int width,height;
    UIAlertView *alert;
    BOOL opened;
    NSString *leedid;
}
@property (weak, nonatomic) IBOutlet UIButton *plaquebutton;
@property (weak, nonatomic) IBOutlet UIButton *humanbutton;
@property (weak, nonatomic) IBOutlet UIView *vv;
@property (weak, nonatomic) IBOutlet UIButton *transitbutton;
- (IBAction)humanclick:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nav1;
@property (weak, nonatomic) IBOutlet UINavigationItem *nv;

- (IBAction)transitclick:(id)sender;
- (IBAction)gotolist:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *humanhide;
@property (weak, nonatomic) IBOutlet UIButton *transithide;
- (IBAction)plaque:(id)sender;
- (IBAction)gobacktolist:(id)sender;


@end
