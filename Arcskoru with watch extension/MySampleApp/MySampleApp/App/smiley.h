//
//  smiley.h
//  Occupant survey
//
//  Created by Group X on 03/07/15.
//  Copyright (c) 2015 usgbc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface smiley : UIViewController <UIApplicationDelegate>{
    BOOL opened;
    NSUserDefaults *prefs;
    CAShapeLayer * smiling;
    NSArray *numbers;
    NSUInteger indx;
    int submitteddonthide;
    int nope;
    NSNumber *number;
    UIBezierPath *smilingPath;
    int position;
    UIBezierPath*  facePath;
    CAShapeLayer *face,*lefteye,*righteye;
    NSMutableArray *experiencearr;
    int width,height;

}
@property (weak, nonatomic) IBOutlet UISlider *slider;
- (IBAction)done:(id)sender;
- (IBAction)goback:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *vv;
@property (weak, nonatomic) IBOutlet UIButton *submitbtn;
@property (weak, nonatomic) IBOutlet UIView *spinner;

@end
