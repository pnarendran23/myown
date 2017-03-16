//
//  buttonarrayforhumansurvey.h
//  connection
//
//  Created by Group10 on 22/03/15.
//  Copyright (c) 2015 Group10. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface buttonarrayforhumansurvey : UIViewController<UIAlertViewDelegate,NSURLConnectionDelegate>
{
    UIButton *Button;
    UIButton *Button1;
    int nope;
    BOOL opened;
    UIButton *checkbox;
    NSMutableArray *experiencearr;
    int position;
    int y;
    int i;
    NSUserDefaults *prefs;
    NSURLSessionDataTask *task;
    NSString *str;
    NSURLSession *session;
    int height;
    UITextField *myTextField;
    int width,hot,dirty,dark,loud,stuffy,cold,smelly,glare,privacy,other;
    UIButton *scanBarCodeButton;
    BOOL othertext;
    UIButton *cliked;
    UIAlertView *alert;
    int it;
    BOOL submitteddonthide;
    NSURL *URL;
    NSMutableURLRequest *request;
    NSString* subscription_key;
    NSString* domain_url;
    NSString* survey_url;
    
    UIButton *butt;
    BOOL hotcheckBoxSelected;
    BOOL coldcheckBoxSelected;
    BOOL smellycheckBoxSelected;
    BOOL stuffycheckBoxSelected;
    BOOL privacycheckBoxSelected;
    BOOL loudcheckBoxSelected;
    BOOL darkcheckBoxSelected;
    BOOL dirtycheckBoxSelected;
    BOOL glarecheckBoxSelected;
    BOOL othercheckBoxSelected;    
    UILabel *labelForTitle;
    UIView *titleView;
    UILabel *otherlabel;

}
@property (strong, nonatomic) IBOutlet UINavigationItem *nav1;
- (IBAction)otherdone:(id)sender;
- (IBAction)back:(id)sender;
- (IBAction)humansurveycomplete:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *sorytohearthat;
@property (strong, nonatomic) IBOutlet UILabel *numberofcharacters;
@property (strong, nonatomic) IBOutlet UIButton *goback;
@property (strong, nonatomic) IBOutlet UIButton *next;
@property (strong, nonatomic) IBOutlet UILabel *selectthat;
@property (strong, nonatomic) IBOutlet UITextView *textVie;
@property (strong, nonatomic) IBOutlet UIView *vv;
@property (weak, nonatomic) IBOutlet UIView *spinner;

@end





