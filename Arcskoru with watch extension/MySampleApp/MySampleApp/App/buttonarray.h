//
//  buttonarray.h
//  connection
//
//  Created by Group10 on 19/03/15.
//  Copyright (c) 2015 Group10. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomCollectionViewCell.h"


@interface buttonarray : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UIAlertViewDelegate,UITextFieldDelegate,UICollectionViewDelegateFlowLayout,NSURLConnectionDelegate>
{
    BOOL submitteddonthide;
    UIView *notificationView;
    UILabel *notificationLabel;
    NSUserDefaults *buttonselect;
    UIButton *Button;
    CAShapeLayer *line;
    BOOL opened;
    NSUserDefaults *prefs;
    NSMutableArray *cararray;
    NSMutableArray *walkarray;
    NSMutableArray *tramarray;
    NSMutableArray *altarray;
    NSMutableArray *busarray;
    NSMutableArray *motorarray;
    NSMutableArray *railarray;
    NSMutableArray *car23array;
    NSMutableDictionary *d;
    int iterate;
    int goback;
    UIView *v;
    CAShapeLayer *line1;
    UIBezierPath *line1Path;
    UIAlertView *alert;
    CAShapeLayer *line2;
    UIBezierPath *line2Path;
    CAShapeLayer *line3;
    UIBezierPath *line3Path;
    NSMutableArray *imagearray;
    UIBezierPath *linePath;
    UIView *v1;
    UICollectionViewFlowLayout *flow;
    NSIndexPath *ind;
    UIAlertView *warning;
    UIButton *Button1;
    CAShapeLayer *border1;
    UIImageView *myImageView;    
    NSMutableArray *tempArray;
    NSMutableArray *captionArray;
    UIImage *myScreenShot;
    NSArray *compare;
    CustomCollectionViewCell *cell1;
    CustomCollectionViewCell *cell2;
    CustomCollectionViewCell *cell3;
    UIButton *clicked;
    UILabel *lbl;
    NSString* route;
    int howmanypeople;
    UILabel *label;
    UITextField *txt;
    float width;
    int extra;
    float height;
    int x;
    BOOL mi;
    int i,n,tag;
}
@property (strong, nonatomic) IBOutlet UILabel *gtitle;
@property (strong, nonatomic) IBOutlet UINavigationItem *nav1;
@property (strong, nonatomic) IBOutlet UIButton *close;
- (IBAction)mileclick:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *howfar;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UIView *vv;
@property (strong, nonatomic) IBOutlet UIButton *milesbutton;
@property (strong, nonatomic) IBOutlet UILabel *milabel;
@property (strong, nonatomic) IBOutlet UIButton *surveydone;
- (IBAction)carsurveydone:(id)sender;
- (IBAction)surveydone:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *cardone;
@property(nonatomic,strong) NSMutableArray *array;
@property(nonatomic,strong) NSMutableArray *array1;
@property (strong, nonatomic) IBOutlet UIButton *surveyclose;

@property (strong, nonatomic) IBOutlet UITextField *howmany;

@property (strong, nonatomic) IBOutlet UIImageView *routeimage;
@property (strong, nonatomic) IBOutlet UITextField *routescore;
@property (weak, nonatomic) IBOutlet UIButton *submitbtn;


- (IBAction)transitsurveydone:(id)sender;
- (IBAction)goback:(id)sender;

@end


