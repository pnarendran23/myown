//
//  ViewController.h
//  plaque
//
//  Created by Group X on 11/01/16.
//  Copyright © 2016 own. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "plaquebig.h"
@interface ViewController : UIViewController<UIAlertViewDelegate, UINavigationControllerDelegate>

- (IBAction)back:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *bigplaque;
@property (weak, nonatomic) IBOutlet UIView *plaquesuperview;
- (IBAction)closeit:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *pp;
@property (nonatomic,strong) IBOutlet UIView *plaquevieww;
@property (weak, nonatomic) IBOutlet UIView *spinnerview;
@property (weak, nonatomic) IBOutlet UIButton *gback;
@end

