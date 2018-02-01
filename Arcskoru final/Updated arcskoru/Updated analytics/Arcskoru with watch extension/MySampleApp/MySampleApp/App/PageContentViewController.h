//
//  PageContentViewController.h
//  racetrack
//
//  Created by Group X on 10/07/15.
//  Copyright (c) 2015 usgbc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageContentViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property NSUInteger pageIndex;
@property NSString *titleText;
@property NSString *imageFile;

@end
