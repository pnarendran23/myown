//
//  listofbuildings.h
//  Occupant survey
//
//  Created by Group X on 06/07/15.
//  Copyright (c) 2015 usgbc. All rights reserved.
//
#import "CustomCollectionViews.h"
#import <UIKit/UIKit.h>
@interface listofroutes : UITableViewCell
@property (weak,nonatomic)CustomCollectionViews *v;
-(void)dashlineadjust;
- (void)setCollectionData:(NSMutableArray *)collectionData;
- (void)setimageData:(NSMutableArray *)imageData;
-(void)setlabelData:(NSString *)labelData;
-(void)tagnum:(int)tag;


@property (weak, nonatomic) IBOutlet UIButton *mibutton;
-(void)accessory:(NSString *)tickdata;
@property (weak, nonatomic) IBOutlet UIImageView *tick;

@end
