//
//  CustomCollectionViews.h
//  multiple
//
//  Created by Group10 on 05/05/15.
//  Copyright (c) 2015 Group10. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomCollectionViewCells.h"

@interface CustomCollectionViews: UIView <UICollectionViewDataSource,UICollectionViewDelegate>{
    int width,height;
    CAShapeLayer *line1;
    UIBezierPath *line1Path;
    UIAlertView *alert;
    CAShapeLayer *line2;
    UIBezierPath *line2Path;
    CAShapeLayer *line3;
    UIBezierPath *line3Path;
    UILabel *lbl;
    UICollectionViewFlowLayout  *flow;
    CAShapeLayer *border1;
}
@property (strong, nonatomic) IBOutlet UIButton *tick;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionview;
- (void)setCollectionData:(NSArray *)collectionData;
- (void)setimageData:(NSArray *)imageData;
-(void)dashlineadjust;
@property (strong, nonatomic) IBOutlet UILabel *rowlabel;
-(void)accessory:(NSString *)tickdata;
@property (strong, nonatomic) NSArray *collectionData;
@property (strong, nonatomic) NSString *tickdata;
@property (strong, nonatomic) NSString *tags;
@property (strong, nonatomic) NSString *labeldata;
@property (strong, nonatomic) NSArray *imagedata;
-(void)setlabelData:(NSString *)labelData;
@property (strong, nonatomic) IBOutlet UIButton *but;
@property (strong, nonatomic) IBOutlet UISegmentedControl *seg;
- (IBAction)editordelete:(id)sender;
-(void)tagnum:(int)tag;

@end
