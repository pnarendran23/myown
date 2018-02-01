//
//  ViewController.h
//  multiple
//
//  Created by Group10 on 05/05/15.
//  Copyright (c) 2015 Group10. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface addsurvey : UIViewController <UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate, UINavigationControllerDelegate>{
    NSUserDefaults *prefs;
    UIView *notificationView;
    UILabel *notificationLabel;
    NSMutableArray *mainarr;
    BOOL opened;
    NSIndexPath *ind;
    NSMutableArray *jsonarray;
    NSMutableArray *milesarray;
    UIButton *btn;
    int width,height;
    int edit;    
    UITapGestureRecognizer *tapGesture;
    NSString* subscription_key;
    NSString* domain_url;
    NSString* survey_url;    
    NSArray *cararray,*car23array,*walkarray,*altarray,*tramarray,*motorarray,*busarray,*railarray;
}
- (IBAction)assist:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *spinner;

@property (strong, nonatomic) IBOutlet UITableView *tableview;
- (IBAction)addmoresurvey:(id)sender;
- (IBAction)backtocategories:(id)sender;
- (IBAction)submitsurvey:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *submitbtn;
@property (strong, nonatomic) IBOutlet UINavigationItem *nav1;

@end

