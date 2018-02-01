//
//  buttonarray.m
//  connection
//
//  Created by Group10 on 19/03/15.
//  Copyright (c) 2015 Group10. All rights reserved.
//
#define ACCEPTABLE_CHARECTERS @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz().,?/\;:\"'-_+=!@#$%^&*][{}|~`<>"

#import "buttonarray.h"
#import "addsurvey.h"
#import "CustomCollectionViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
@interface buttonarray ()

@property(nonatomic,strong )UIButton *mileorkm;
@property(nonatomic, readonly) UITextRange *markedTextRange;
@end

@implementation buttonarray
@synthesize close;
@synthesize array;
@synthesize array1;

@synthesize routescore;
@synthesize vv;
@synthesize  milabel;
@synthesize routeimage;

- (void)unmarkText{

}


-(void)viewWillDisappear:(BOOL)animated{
    [UIView setAnimationsEnabled:YES];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    /*CGFloat w = 0.212 * width;
    CGFloat spacing = 0.114 * width;;
    CGFloat total = (tempArray.count * w);
    CGFloat spacingwidth = spacing * (tempArray.count - 1);
    CGFloat leftinset = (collectionView.frame.size.width - (total + spacingwidth))/2;
    */
    NSInteger numberOfCells = self.view.frame.size.width / flow.itemSize.width;
    NSInteger edgeInsets = (self.view.frame.size.width - (numberOfCells * flow.itemSize.width)) / (numberOfCells + 1);
    return UIEdgeInsetsMake(0, edgeInsets, 0, edgeInsets);
    //return UIEdgeInsetsMake(0, leftinset, 0, leftinset);
   /*if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
       if([tempArray count]==2){
           return UIEdgeInsetsMake(45 , 200, 0, 65);
       }else if([tempArray count]==3){
           return UIEdgeInsetsMake(45 , 150, 0, 7);
       }
       else if([tempArray count]==4){
           return UIEdgeInsetsMake(45 , 150, 0, 7);
       }
       else{
           return UIEdgeInsetsMake(45 , 250, 0, 0);
       }

       
   }else{
       if(width==414 && height==736){
           if([tempArray count]==2){
               return UIEdgeInsetsMake(45 , 65, 0, 65);
           }else if([tempArray count]==3){
               return UIEdgeInsetsMake(45 , 7, 0, 7);
           }
           else if([tempArray count]==4){
               return UIEdgeInsetsMake(45 , 7, 0, 7);
           }
           else{
               return UIEdgeInsetsMake(45 , 100, 0, 100);
           }
       }
       else{
           if([tempArray count]==2){
               return UIEdgeInsetsMake(45 , 45, 0, 45);
           }else if([tempArray count]==3){
               return UIEdgeInsetsMake(45 , 7, 0, 7);
           }
           else if([tempArray count]==4){
               return UIEdgeInsetsMake(45 , 7, 0, 7);
           }
           else{
               return UIEdgeInsetsMake(45 , 90, 0, 90);
           }
       }
   }*/
    return UIEdgeInsetsMake(0, 100, 0, 0);
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [tempArray count];
}




-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CustomCollectionViewCell *cell = (CustomCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"cvCell2" forIndexPath:indexPath];
    if(clicked.tag==1000){
        UIView *ev = [[UIView alloc] init];
        //ev.frame = CGRectMake(cell.cellimage.frame.origin.x, cell.cellimage.frame.origin.y, 0.8 * flow.itemSize.width, 0.8 * flow.itemSize.width);
        //cell.cellimage.frame = ev.frame;
        //[cell.cellabel setAdjustsFontSizeToFitWidth:YES];
        if(howmanypeople==1){
            cell.cellimage.image=[UIImage imageNamed:[imagearray objectAtIndex:indexPath.row]];
            cell.cellabel.text=[NSString stringWithFormat:@"%.1f",[[tempArray objectAtIndex:indexPath.row]doubleValue]];

        }else if(howmanypeople>=2 && howmanypeople<=3){
            cell.cellimage.image=[UIImage imageNamed:[imagearray objectAtIndex:indexPath.row]];
            cell.cellabel.text=[NSString stringWithFormat:@"%.1f",[[tempArray objectAtIndex:indexPath.row]doubleValue]];
        }
        else{
            cell.cellimage.image=[UIImage imageNamed:[imagearray objectAtIndex:indexPath.row]];
            cell.cellabel.text=[NSString stringWithFormat:@"%.1f",[[tempArray objectAtIndex:indexPath.row]doubleValue]];
        }
    }
    else if(clicked.tag==1001){
            cell.cellimage.image=[UIImage imageNamed:[imagearray objectAtIndex:indexPath.row]];
            cell.cellabel.text=[NSString stringWithFormat:@"%.1f",[[tempArray objectAtIndex:indexPath.row]doubleValue]];
    }
    else if(clicked.tag==1002){
        cell.cellimage.image=[UIImage imageNamed:[imagearray objectAtIndex:indexPath.row]];
        cell.cellabel.text=[NSString stringWithFormat:@"%.1f",[[tempArray objectAtIndex:indexPath.row]doubleValue]];
    }
    else if(clicked.tag==1003){
        cell.cellimage.image=[UIImage imageNamed:[imagearray objectAtIndex:indexPath.row]];
        cell.cellabel.text=[NSString stringWithFormat:@"%.1f",[[tempArray objectAtIndex:indexPath.row]doubleValue]];
    }
    else if(clicked.tag==2000){
        cell.cellimage.image=[UIImage imageNamed:[imagearray objectAtIndex:indexPath.row]];
        cell.cellabel.text=[NSString stringWithFormat:@"%.1f",[[tempArray objectAtIndex:indexPath.row]doubleValue]];
    }
    else if(clicked.tag==2001){
        cell.cellimage.image=[UIImage imageNamed:[imagearray objectAtIndex:indexPath.row]];
        cell.cellabel.text=[NSString stringWithFormat:@"%.1f",[[tempArray objectAtIndex:indexPath.row]doubleValue]];
    }
    else if(clicked.tag==2002){
        cell.cellimage.image=[UIImage imageNamed:[imagearray objectAtIndex:indexPath.row]];
        cell.cellabel.text=[NSString stringWithFormat:@"%.1f",[[tempArray objectAtIndex:indexPath.row]doubleValue]];
    }else{
        cell.cellimage.image=[UIImage imageNamed:[imagearray objectAtIndex:indexPath.row]];
        cell.cellabel.text=[NSString stringWithFormat:@"%.1f",[[tempArray objectAtIndex:indexPath.row]doubleValue]];
    }
    cell.layer.cornerRadius=5;
  [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:1.2];
    [UIView setAnimationBeginsFromCurrentState:YES];
    cell.alpha=0;
    cell.alpha=1;
    cell.backgroundColor=[UIColor whiteColor];
    [UIView commitAnimations];
    cell.backgroundColor=[UIColor darkGrayColor];
    CAShapeLayer *border = [CAShapeLayer layer];
    border.path = [UIBezierPath bezierPathWithRect:cell.bounds].CGPath;
    border.frame = CGRectMake(cell.bounds.size.width+80, cell.bounds.origin.y+1, 0.125 * width, 0.114 * height);
    border.strokeColor = [UIColor colorWithRed:0.576  green:0.568 blue:0.513 alpha:1].CGColor;
    border.fillColor = nil;
    border.cornerRadius=5;
    border.masksToBounds = YES;
    border.lineDashPattern = @[@8.5, @5];
    //[cell.layer addSublayer:border];
    self.collectionView.delegate=self;
    return cell;
}



- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ind=indexPath;
  /*  alert = [[UIAlertView alloc] initWithTitle:@"Warning.."
                                                    message:@"Remove Mode from Route"
                                                   delegate:self
                                          cancelButtonTitle:@"No"
                                          otherButtonTitles:@"Yes", nil];
    alert.tag=1;
    [alert show];
   */
    
    UIAlertController * alert=[UIAlertController
                               
                               alertControllerWithTitle:@"Warning.." message:@"Remove Mode from Route" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"Yes"
                                style:UIAlertActionStyleDestructive
                                handler:^(UIAlertAction * action)
                                {
                                    int row=(int)[ind row];
                                    [tempArray removeObjectAtIndex:row];
                                    [imagearray removeObjectAtIndex:row];
                                    [captionArray removeObjectAtIndex:row];
                                    NSArray *deleteItems=@[ind];
                                    [self.collectionView deleteItemsAtIndexPaths:deleteItems];
                                    iterate--;
                                    if([tempArray count]==0){
                                        extra=1;
                                        self.collectionView.hidden=NO;
                                        line1.hidden=YES;
                                        border1.hidden=YES;
                                    }
                                    else{
                                        line1.hidden=NO;
                                        border1.hidden=NO;
                                    }
                                    [self.collectionView reloadData];

                                    // call method whatever u need
                                }];
    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:@"No"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action)
                               {
                                  
                                   // call method whatever u need
                                   
                               }];
    
    [alert addAction:noButton];
    [alert addAction:yesButton];
    
    [[[[alert view]subviews] objectAtIndex:0] setBackgroundColor:[UIColor whiteColor]];
    [[[alert view] layer] setCornerRadius:10];
    [[[alert view] layer] setMasksToBounds:YES];
    [self presentViewController:alert animated:YES completion:nil];
    
    
}

- (void)alertView:(UIAlertView *)warn clickedButtonAtIndex:(NSInteger)buttonIndex
{
    opened=NO;
    if(warn.tag==2){
        if(buttonIndex==1){
           [self performSegueWithIdentifier:@"gobackfromtransit" sender:nil];
        }
    }
    if(warn.tag==1){
        NSString *title = [warning buttonTitleAtIndex:buttonIndex];
        if([title isEqualToString:@"Yes"]){
            int row=(int)[ind row];
            [tempArray removeObjectAtIndex:row];
            [imagearray removeObjectAtIndex:row];
            [captionArray removeObjectAtIndex:row];
            NSArray *deleteItems=@[ind];
            [self.collectionView deleteItemsAtIndexPaths:deleteItems];
            iterate--;
            if([tempArray count]==0){
                extra=1;
                self.collectionView.hidden=NO;
                line1.hidden=YES;
                border1.hidden=YES;
            }
            else{
                line1.hidden=NO;
                border1.hidden=NO;
            }
            [self.collectionView reloadData];
           /* [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDuration:0.01];
            [UIView setAnimationBeginsFromCurrentState:YES];
            if([tempArray count]==2){
                flow.sectionInset = UIEdgeInsetsMake(45, 45, 0, 0);
            }else if([tempArray count]==3){
                flow.sectionInset = UIEdgeInsetsMake(45,4,0,0);
            }
            else if([tempArray count]==4){
                flow.sectionInset = UIEdgeInsetsMake(45,5,0,0);
            }
            else{
                flow.sectionInset = UIEdgeInsetsMake(45,90,0,0);
            }
            if(width==375 && height==667){
                if([tempArray count]==1){
                    line1.hidden=NO;
                    line2.hidden=YES;
                    line3.hidden=YES;
                    line1.frame = CGRectMake(170, 124, 138.31, 0);
                    border1.frame = CGRectMake(186, 90,lbl.bounds.size.width, lbl.bounds.size.height);
                    border1.frame = CGRectMake(186, 77,lbl.bounds.size.width, lbl.bounds.size.height);
                }
                if([tempArray count]==2){
                    line3.hidden=YES;
                    line2.hidden=NO;
                    line1.hidden=NO;
                    line1.frame = CGRectMake(123, 124, 138.31, 0);
                    line2.frame = CGRectMake(215, 124, 138.31, 0);
                    border1.frame = CGRectMake(186, 90,lbl.bounds.size.width, lbl.bounds.size.height);
                    border1.frame = CGRectMake(230, 77,lbl.bounds.size.width, lbl.bounds.size.height);
                }
                if([tempArray count]==3){
                    line3.hidden=NO;
                    line2.hidden=NO;
                    line1.hidden=NO;
                    line3.frame = CGRectMake(270, 124, 138.31, 0);
                    line2.frame = CGRectMake(178, 124, 138.31, 0);
                    line1.frame = CGRectMake(86, 124, 138.31, 0);
                    border1.frame = CGRectMake(220, 90,lbl.bounds.size.width, lbl.bounds.size.height);
                    border1.frame = CGRectMake(284, 77,lbl.bounds.size.width, lbl.bounds.size.height);
                }
                if([tempArray count]==4){
                    line3.hidden=NO;
                    line2.hidden=NO;
                    line1.hidden=NO;
                    line3.frame = CGRectMake(270, 124, 138.31, 0);
                    line2.frame = CGRectMake(178, 124, 138.31, 0);
                    line1.frame = CGRectMake(86, 124, 138.31, 0);
                    border1.frame = CGRectMake(220, 73,lbl.bounds.size.width, lbl.bounds.size.height);
                    border1.frame = CGRectMake(282, 77,lbl.bounds.size.width, lbl.bounds.size.height);
            }
        }
        else if(width==414 && height==736){
            if([tempArray count]==1){
                line1.hidden=NO;
                line2.hidden=YES;
                line3.hidden=YES;
                line1.frame = CGRectMake(187, 130, 138.31, 0);
                border1.frame = CGRectMake(196, 87,lbl.bounds.size.width, lbl.bounds.size.height);
                border1.frame = CGRectMake(196, 80,lbl.bounds.size.width, lbl.bounds.size.height);
            }
            if([tempArray count]==2){
                line2.hidden=NO;
                line3.hidden=YES;
                line1.hidden=NO;
                line2.frame = CGRectMake(250, 130, 138.31, 0);
                line1.frame = CGRectMake(152, 130, 138.31, 0);
                border1.frame = CGRectMake(186, 87,lbl.bounds.size.width, lbl.bounds.size.height);
                border1.frame = CGRectMake(259, 80,lbl.bounds.size.width, lbl.bounds.size.height);
            }
            if([tempArray count]==3){
                line3.hidden=NO;
                line1.hidden=NO;
                line2.hidden=NO;
                line2.frame = CGRectMake(192, 130, 138.31, 0);
                line1.frame = CGRectMake(95, 130, 138.31, 0);
                line3.frame = CGRectMake(289, 130, 138.31, 0);
                border1.frame = CGRectMake(225, 87,lbl.bounds.size.width, lbl.bounds.size.height);
                border1.frame = CGRectMake(300, 80,lbl.bounds.size.width, lbl.bounds.size.height);
            }
            if([tempArray count]==4){
                line3.hidden=NO;
                line1.hidden=NO;
                line2.hidden=NO;
                line2.frame = CGRectMake(192, 130, 138.31, 0);
                line1.frame = CGRectMake(95, 130, 138.31, 0);
                line3.frame = CGRectMake(289, 130, 138.31, 0);
                border1.frame = CGRectMake(225, 87,lbl.bounds.size.width, lbl.bounds.size.height);
                border1.frame = CGRectMake(300, 80,lbl.bounds.size.width, lbl.bounds.size.height);
            }
        }
        else if(width==320 && height==568){
            
            if([tempArray count]==1){
                line1.hidden=NO;
                line2.hidden=YES;
                line3.hidden=YES;
                line1.frame = CGRectMake(160, 110, 138.31, 0);
                border1.frame = CGRectMake(172, 74,lbl.bounds.size.width, lbl.bounds.size.height);
                border1.frame = CGRectMake(172, 62.5,lbl.bounds.size.width, lbl.bounds.size.height);
            }
            if([tempArray count]==2){
                line2.hidden=NO;
                line3.hidden=YES;
                line1.hidden=NO;
                line1.frame = CGRectMake(115, 110, 138.31, 0);
                line2.frame = CGRectMake(194, 110, 138.31, 0);
                border1.frame = CGRectMake(172, 74,lbl.bounds.size.width, lbl.bounds.size.height);
                border1.frame = CGRectMake(204, 62.5,lbl.bounds.size.width, lbl.bounds.size.height);
            }
            if([tempArray count]==3){
                line3.hidden=NO;
                line1.hidden=NO;
                line2.hidden=NO;
                line1.frame = CGRectMake(77, 110, 138.31, 0);
                line2.frame = CGRectMake(157, 110, 138.31, 0);
                line3.frame = CGRectMake(237, 110, 138.31, 0);
                border1.frame = CGRectMake(204, 74,lbl.bounds.size.width, lbl.bounds.size.height);
                border1.frame = CGRectMake(248, 62.5,lbl.bounds.size.width, lbl.bounds.size.height);
            }
            if([tempArray count]==4){
                line3.hidden=NO;
                line1.hidden=NO;
                line2.hidden=NO;
                line1.frame = CGRectMake(77, 110, 138.31, 0);
                line2.frame = CGRectMake(157, 110, 138.31, 0);
                line3.frame = CGRectMake(237, 110, 138.31, 0);
                border1.frame = CGRectMake(204, 74,lbl.bounds.size.width, lbl.bounds.size.height);
                border1.frame = CGRectMake(248, 62.5,lbl.bounds.size.width, lbl.bounds.size.height);
            }
        }
        else{
            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
                if([tempArray count]==1){
                    line1.hidden=NO;
                    line2.hidden=YES;
                    line3.hidden=YES;
                    line1.frame = CGRectMake(350, 180, 138.31, 0);
                    border1.frame = CGRectMake(172, 50,lbl.bounds.size.width, lbl.bounds.size.height);
                    border1.frame = CGRectMake(360, 115,lbl.bounds.size.width, lbl.bounds.size.height);
                    
                    
                    
                }
                if([tempArray count]==2){
                    line2.hidden=NO;
                    line3.hidden=YES;
                    line1.hidden=NO;
                    line1.frame = CGRectMake(300, 180, 138.31, 0);
                    line2.frame = CGRectMake(411, 180, 138.31, 0);
                    border1.frame = CGRectMake(172, 56,lbl.bounds.size.width, lbl.bounds.size.height);
                    border1.frame = CGRectMake(420, 115,lbl.bounds.size.width, lbl.bounds.size.height);
                }
                if([tempArray count]==3){
                    line3.hidden=NO;
                    line1.hidden=NO;
                    line2.hidden=NO;
                    line3.frame = CGRectMake(472, 180, 138.31, 0);
                    line2.frame = CGRectMake(360, 180, 138.31, 0);
                    line1.frame = CGRectMake(250, 180, 138.31, 0);
                    border1.frame = CGRectMake(204, 56,lbl.bounds.size.width, lbl.bounds.size.height);
                    border1.frame = CGRectMake(479, 115,lbl.bounds.size.width, lbl.bounds.size.height);
                }
                if([tempArray count]==4){
                    line3.hidden=NO;
                    line2.hidden=NO;
                    line1.hidden=NO;
                    line3.frame = CGRectMake(472, 180, 138.31, 0);
                    line2.frame = CGRectMake(360, 180, 138.31, 0);
                    line1.frame = CGRectMake(250, 180, 138.31, 0);
                    border1.frame = CGRectMake(204, 56,lbl.bounds.size.width, lbl.bounds.size.height);
                    border1.frame = CGRectMake(479, 115,lbl.bounds.size.width, lbl.bounds.size.height);
                }
            }else{
            if([tempArray count]==1){
                line1.hidden=NO;
                line2.hidden=YES;
                line3.hidden=YES;
                line1.frame = CGRectMake(160, 102, 138.31, 0);
                border1.frame = CGRectMake(172, 58,lbl.bounds.size.width, lbl.bounds.size.height);
                border1.frame = CGRectMake(172, 49,lbl.bounds.size.width, lbl.bounds.size.height);
            }
            if([tempArray count]==2){
                line1.hidden=NO;
                line2.hidden=NO;
                line3.hidden=YES;
                line1.frame = CGRectMake(115, 102, 138.31, 0);
                line2.frame = CGRectMake(193, 102, 138.31, 0);
                border1.frame = CGRectMake(172, 58,lbl.bounds.size.width, lbl.bounds.size.height);
                border1.frame = CGRectMake(204, 49,lbl.bounds.size.width, lbl.bounds.size.height);
            }
            if([tempArray count]==3){
                line1.hidden=NO;
                line2.hidden=NO;
                line3.hidden=NO;
                line3.frame = CGRectMake(235, 102, 138.31, 0);
                line2.frame = CGRectMake(156, 102, 138.31, 0);
                line1.frame = CGRectMake(75, 102, 138.31, 0);
                border1.frame = CGRectMake(204, 58,lbl.bounds.size.width, lbl.bounds.size.height);
                border1.frame = CGRectMake(246, 49,lbl.bounds.size.width, lbl.bounds.size.height);
            }
            if([tempArray count]==4){
                line1.hidden=NO;
                line2.hidden=NO;
                line3.hidden=NO;
                line3.frame = CGRectMake(235, 102, 138.31, 0);
                line2.frame = CGRectMake(156, 102, 138.31, 0);
                line1.frame = CGRectMake(75, 102, 138.31, 0);
                border1.frame = CGRectMake(204, 58,lbl.bounds.size.width, lbl.bounds.size.height);
                border1.frame = CGRectMake(246, 49,lbl.bounds.size.width, lbl.bounds.size.height);
            }
            }
        }
        [UIView commitAnimations];*/
        }
        
    }
    else{
        if (buttonIndex == 0){
            if([alert textFieldAtIndex:0].text.length == 0)
            {
                
            }
            

        }

    }
}

-(IBAction)closecategory:(id)sender{
    [self closethesurvey:nil];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if (([[segue identifier] isEqualToString:@"addthisroute"])||([[segue identifier] isEqualToString:@"transittohuman"])) {
        [prefs setObject:tempArray forKey:@"temp"];
        [prefs setObject:imagearray forKey:@"image"];
        [prefs setObject:captionArray forKey:@"caption"];
        [prefs setInteger:submitteddonthide forKey:@"transitdone"];
    }
}


-(void)viewWillAppear:(BOOL)animated{
    x=0;
    opened=NO;
    NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"building_details"]];
    self.navigationController.navigationBar.backItem.title = dict[@"name"];
    x=0;
    prefs=[NSUserDefaults standardUserDefaults];
    [prefs synchronize];
    
    tempArray=[[NSMutableArray alloc] init];
    imagearray=[[NSMutableArray alloc] init];
    captionArray=[[NSMutableArray alloc]init];
    iterate=0;
    if((int)[prefs integerForKey:@"edit"]==1){
        tempArray=[[prefs objectForKey:@"temp"]mutableCopy];
        imagearray=[[prefs objectForKey:@"image"]mutableCopy];
        captionArray=[[prefs objectForKey:@"caption"] mutableCopy];
        iterate=(int)tempArray.count;
    }
    compare=[[NSArray alloc] initWithArray:tempArray];
    CAShapeLayer *baseline = [CAShapeLayer layer];
    baseline.fillColor         = nil;
    baseline.strokeColor       = [UIColor colorWithRed:0.576  green:0.568 blue:0.513 alpha:1].CGColor;
    UIBezierPath *baselinePath = [UIBezierPath bezierPath];
    [baselinePath moveToPoint:CGPointMake(width-10, 0)];
    [baselinePath addCurveToPoint:CGPointMake(0, 0) controlPoint1:CGPointMake(0, 0) controlPoint2:CGPointMake(width, 0)];
    baseline.frame = CGRectMake(5, 5, 0, 0);
    baseline.path = baselinePath.CGPath;
    baseline.lineWidth = 3;
    [self.collectionView.layer addSublayer:baseline];
    [self.collectionView reloadData];
    NSLog(@"%@,%@",tempArray,captionArray);
    myImageView =routeimage;
    [myImageView setImage:myScreenShot];
    [self.vv addSubview:myImageView];
    [myImageView setContentMode:UIViewContentModeCenter];
    [self.vv addSubview:txt];
    [txt setContentMode:UIViewContentModeScaleAspectFit];
    mi=[buttonselect boolForKey:@"miles"];
    mi=NO;
    if(!mi){
        [_milesbutton setTitle:@"Mi" forState:UIControlStateNormal];
        mi=NO;
    }
    else{
        [_milesbutton setTitle:@"Km" forState:UIControlStateNormal];
        mi=YES;
    }
    txt=self.routescore;
    _milesbutton.frame = CGRectMake(txt.frame.size.width + txt.frame.origin.x, _milesbutton.frame.origin.y, _milesbutton.frame.size.width, _milesbutton.frame.size.height);
    [self.gtitle setTextAlignment:NSTextAlignmentCenter];
    self.gtitle.text=@"On a typical day, how do you get to this building? \"one day, one way\"";
    self.gtitle.numberOfLines=2;
    self.gtitle.font=[UIFont fontWithName:@"GothamBook" size:16];
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 7, 52)];
    [routescore setLeftViewMode:UITextFieldViewModeAlways];
    [routescore setLeftView:paddingView];
    
    UIColor *borderColor = [UIColor whiteColor];
    
    routescore.layer.borderColor = borderColor.CGColor;
    routescore.layer.borderWidth = 1.0;
    routescore.layer.cornerRadius = 5.0;
    _milesbutton.layer.cornerRadius=5;
    goback=0;
    i=0;
    [_milesbutton.layer setMasksToBounds:YES];
    self.surveyclose.hidden=YES;
    alert.delegate=self;
    warning.delegate=self;
    n=0;
    tag=0;
    self.collectionView.hidden=NO;
    self.vv.hidden=YES;
    self.submitbtn.hidden=NO;
    self.howmany.hidden=YES;
    [self.howfar setText:@"How far did you travel?"];
    self.cardone.hidden=YES;
    self.view.frame=[UIScreen mainScreen].bounds;
    routescore.userInteractionEnabled=YES;
    [self.vv.layer setCornerRadius:4];
    routescore.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"0.00" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    submitteddonthide=[prefs integerForKey:@"transitdone"];
    car23array=[[NSMutableArray alloc] init];
    cararray=[[NSMutableArray alloc] init];
    walkarray=[[NSMutableArray alloc] init];
    tramarray=[[NSMutableArray alloc] init];
    altarray=[[NSMutableArray alloc] init];
    busarray=[[NSMutableArray alloc] init];
    motorarray=[[NSMutableArray alloc] init];
    railarray=[[NSMutableArray alloc] init];
    if((int)[prefs integerForKey:@"editingroute"]==1){
        cararray=[[prefs objectForKey:@"cararray"] mutableCopy];
        car23array=[[prefs objectForKey:@"car23array"] mutableCopy];
        walkarray =[[prefs objectForKey:@"walkarray"] mutableCopy];
        railarray =[[prefs objectForKey:@"railarray"] mutableCopy];
        altarray =[[prefs objectForKey:@"altarray"] mutableCopy];
        tramarray =[[prefs objectForKey:@"tramarray"] mutableCopy];
        motorarray =[[prefs objectForKey:@"motorarray"] mutableCopy];
        busarray =[[prefs objectForKey:@"busarray"] mutableCopy];
        [prefs setInteger:0 forKey:@"editingroute"];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(closeit)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    [self.collectionView reloadData];
    prefs = [NSUserDefaults standardUserDefaults];
    NSMutableArray *m=[[NSMutableArray arrayWithArray:[prefs objectForKey:@"mainarray"]]mutableCopy];
    dispatch_async(dispatch_get_main_queue(), ^{
    if(m.count > 0){
        self.navigationController.navigationBar.backItem.title = dict[@"Back"];
        self.navigationController.navigationBar.topItem.title = @"Back";
    }else{
        self.navigationController.navigationBar.backItem.title = dict[@"More"];
    }
    });
}



-(void)viewDidAppear:(BOOL)animated{
    NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"building_details"]];
    self.navigationItem.title = dict[@"name"];
    self.navigationController.navigationBar.backItem.title = @"More";
    self.navigationController.navigationItem.backBarButtonItem.title = @"More";
    prefs = [NSUserDefaults standardUserDefaults];
    NSMutableArray *m=[[NSMutableArray arrayWithArray:[prefs objectForKey:@"mainarray"]]mutableCopy];
    dispatch_async(dispatch_get_main_queue(), ^{
    if(m.count > 0){
        self.navigationController.navigationBar.backItem.title = @"Back";
        self.navigationController.navigationItem.backBarButtonItem.title = @"Back";
        self.navigationController.navigationItem.leftBarButtonItem.title = @"Back";
    }else{
        self.navigationController.navigationBar.backItem.title = @"More";
        self.navigationController.navigationItem.backBarButtonItem.title = @"More";
        self.navigationController.navigationItem.leftBarButtonItem.title = @"More";
    }
    });
}


- (void)registerNib:(UINib *)nib forCellWithReuseIdentifier:(NSString *)identifier{
   nib = [UINib nibWithNibName:@"CustomCollectionViewCell" bundle: nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:@"cvCell2"];
}





-(void)dashlineadjust{
    lbl=[[UILabel alloc] init];
    [lbl.layer removeFromSuperlayer];
    if(width==414 && height==736){
        lbl.frame=CGRectMake(1, 1, 88, 107);
    }
    else if(width==375 && height==667){
    lbl.frame=CGRectMake(1, 1, 82, 94);
    }
    else{
         if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
             lbl.frame=CGRectMake(1, 1, 0.125 * width, 0.114 * height);
         }
         else{
lbl.frame=CGRectMake(1, 1, 70, 91);
         }
    }
    
    border1 = [CAShapeLayer layer];
    border1.path = [UIBezierPath bezierPathWithRect:lbl.bounds].CGPath;
    


    if([tempArray count]==2){
        flow.sectionInset = UIEdgeInsetsMake(45, 45, 0, 0);
        
        
    }else if([tempArray count]==3){
        flow.sectionInset = UIEdgeInsetsMake(45,4,0,0);
        
        
    }
    else if([tempArray count]==4){
        flow.sectionInset = UIEdgeInsetsMake(45,5,0,0);
    }
    else{
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
            flow.sectionInset=UIEdgeInsetsMake(45, 90, 0, 0);
        }
        else{
        flow.sectionInset = UIEdgeInsetsMake(45,90,0,0);
        }
        
    }
    
    if(width==375 && height==667){
        if([tempArray count]==1){
            line1.hidden=NO;
            line2.hidden=YES;
            line3.hidden=YES;
            line1.frame = CGRectMake(170, 124, 138.31, 0);
            
            border1.frame = CGRectMake(186, 90,lbl.bounds.size.width, lbl.bounds.size.height);
            border1.frame = CGRectMake(186, 77,lbl.bounds.size.width, lbl.bounds.size.height);
            
            
            
        }
        
        if([tempArray count]==2){
            line3.hidden=YES;
            line2.hidden=NO;
            line1.hidden=NO;
            line1.frame = CGRectMake(123, 124, 138.31, 0);
            line2.frame = CGRectMake(215, 124, 138.31, 0);
            border1.frame = CGRectMake(186, 90,lbl.bounds.size.width, lbl.bounds.size.height);
            border1.frame = CGRectMake(230, 77,lbl.bounds.size.width, lbl.bounds.size.height);
        }
        
        if([tempArray count]==3){
            line3.hidden=NO;
            line2.hidden=NO;
            line1.hidden=NO;
            line3.frame = CGRectMake(270, 124, 138.31, 0);
            line2.frame = CGRectMake(178, 124, 138.31, 0);
            line1.frame = CGRectMake(86, 124, 138.31, 0);
            border1.frame = CGRectMake(220, 90,lbl.bounds.size.width, lbl.bounds.size.height);
            border1.frame = CGRectMake(284, 77,lbl.bounds.size.width, lbl.bounds.size.height);
        }
        
        if([tempArray count]==4){
            line3.hidden=NO;
            line2.hidden=NO;
            line1.hidden=NO;
            line3.frame = CGRectMake(270, 124, 138.31, 0);
            line2.frame = CGRectMake(178, 124, 138.31, 0);
            line1.frame = CGRectMake(86, 124, 138.31, 0);
            border1.frame = CGRectMake(220, 73,lbl.bounds.size.width, lbl.bounds.size.height);
            border1.frame = CGRectMake(282, 77,lbl.bounds.size.width, lbl.bounds.size.height);
        }
    }
    
    else if(width==414 && height==736){
        if([tempArray count]==1){
            line1.hidden=NO;
            line2.hidden=YES;
            line3.hidden=YES;
            line1.frame = CGRectMake(187, 130, 138.31, 0);
            
            border1.frame = CGRectMake(196, 87,lbl.bounds.size.width, lbl.bounds.size.height);
            border1.frame = CGRectMake(196, 80,lbl.bounds.size.width, lbl.bounds.size.height);
    }
        
        if([tempArray count]==2){
            line2.hidden=NO;
            line3.hidden=YES;
            line1.hidden=NO;
            line2.frame = CGRectMake(250, 130, 138.31, 0);
            line1.frame = CGRectMake(152, 130, 138.31, 0);
            border1.frame = CGRectMake(186, 87,lbl.bounds.size.width, lbl.bounds.size.height);
            border1.frame = CGRectMake(259, 80,lbl.bounds.size.width, lbl.bounds.size.height);
        }
        
        if([tempArray count]==3){
            line3.hidden=NO;
            line1.hidden=NO;
            line2.hidden=NO;
            line2.frame = CGRectMake(192, 130, 138.31, 0);
            line1.frame = CGRectMake(95, 130, 138.31, 0);
            line3.frame = CGRectMake(289, 130, 138.31, 0);
            border1.frame = CGRectMake(225, 87,lbl.bounds.size.width, lbl.bounds.size.height);
            border1.frame = CGRectMake(300, 80,lbl.bounds.size.width, lbl.bounds.size.height);
        }
        if([tempArray count]==4){
            line3.hidden=NO;
            line1.hidden=NO;
            line2.hidden=NO;
            line2.frame = CGRectMake(192, 130, 138.31, 0);
            line1.frame = CGRectMake(95, 130, 138.31, 0);
            line3.frame = CGRectMake(289, 130, 138.31, 0);
            border1.frame = CGRectMake(225, 87,lbl.bounds.size.width, lbl.bounds.size.height);
            border1.frame = CGRectMake(300, 80,lbl.bounds.size.width, lbl.bounds.size.height);
        }
    }
    
    else if(width==320 && height==568){
        
        if([tempArray count]==1){
            line1.hidden=NO;
            line2.hidden=YES;
            line3.hidden=YES;
            line1.frame = CGRectMake(160, 110, 138.31, 0);
            border1.frame = CGRectMake(172, 74,lbl.bounds.size.width, lbl.bounds.size.height);
            border1.frame = CGRectMake(172, 62.5,lbl.bounds.size.width, lbl.bounds.size.height);
        }
        
        if([tempArray count]==2){
            line2.hidden=NO;
            line1.hidden=NO;
            line3.hidden=YES;
            line1.frame = CGRectMake(115, 110, 138.31, 0);
            line2.frame = CGRectMake(194, 110, 138.31, 0);
            border1.frame = CGRectMake(172, 74,lbl.bounds.size.width, lbl.bounds.size.height);
            border1.frame = CGRectMake(204, 62.5,lbl.bounds.size.width, lbl.bounds.size.height);
        }
        
        if([tempArray count]==3){
            line3.hidden=NO;
            line1.hidden=NO;
            line2.hidden=NO;
            line1.frame = CGRectMake(77, 110, 138.31, 0);
            line2.frame = CGRectMake(157, 110, 138.31, 0);
            line3.frame = CGRectMake(237, 110, 138.31, 0);
            border1.frame = CGRectMake(204, 74,lbl.bounds.size.width, lbl.bounds.size.height);
            border1.frame = CGRectMake(248, 62.5,lbl.bounds.size.width, lbl.bounds.size.height);
        }
        if([tempArray count]==4){
            line3.hidden=NO;
            line1.hidden=NO;
            line2.hidden=NO;
            line1.frame = CGRectMake(77, 110, 138.31, 0);
            line2.frame = CGRectMake(157, 110, 138.31, 0);
            line3.frame = CGRectMake(237, 110, 138.31, 0);
            border1.frame = CGRectMake(204, 74,lbl.bounds.size.width, lbl.bounds.size.height);
            border1.frame = CGRectMake(248, 62.5,lbl.bounds.size.width, lbl.bounds.size.height);
        }
    }
    else{
        
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
            if([tempArray count]==1){
                line1.hidden=NO;
                line2.hidden=YES;
                line3.hidden=YES;
                line1.frame = CGRectMake(350, 180, 138.31, 0);
                border1.frame = CGRectMake(172, 50,lbl.bounds.size.width, lbl.bounds.size.height);
                border1.frame = CGRectMake(360, 115,lbl.bounds.size.width, lbl.bounds.size.height);
            }
            
            if([tempArray count]==2){
                line2.hidden=NO;
                line3.hidden=YES;
                line1.hidden=NO;
                line1.frame = CGRectMake(300, 180, 138.31, 0);
                line2.frame = CGRectMake(411, 180, 138.31, 0);
                border1.frame = CGRectMake(172, 56,lbl.bounds.size.width, lbl.bounds.size.height);
                border1.frame = CGRectMake(420, 115,lbl.bounds.size.width, lbl.bounds.size.height);
            }
            
            if([tempArray count]==3){
                line3.hidden=NO;
                line1.hidden=NO;
                line2.hidden=NO;
                line3.frame = CGRectMake(472, 180, 138.31, 0);
                line2.frame = CGRectMake(360, 180, 138.31, 0);
                line1.frame = CGRectMake(250, 180, 138.31, 0);
                border1.frame = CGRectMake(204, 56,lbl.bounds.size.width, lbl.bounds.size.height);
                border1.frame = CGRectMake(479, 115,lbl.bounds.size.width, lbl.bounds.size.height);
            }
            if([tempArray count]==4){
                line3.hidden=NO;
                line2.hidden=NO;
                line1.hidden=NO;
                line3.frame = CGRectMake(472, 180, 138.31, 0);
                line2.frame = CGRectMake(360, 180, 138.31, 0);
                line1.frame = CGRectMake(250, 180, 138.31, 0);
                border1.frame = CGRectMake(204, 56,lbl.bounds.size.width, lbl.bounds.size.height);
                border1.frame = CGRectMake(479, 115,lbl.bounds.size.width, lbl.bounds.size.height);
            }
        }
         else{
             if([tempArray count]==1){
                 line1.hidden=NO;
                 line2.hidden=YES;
                 line3.hidden=YES;
                 line1.frame = CGRectMake(160, 102, 138.31, 0);
                 border1.frame = CGRectMake(172, 58,lbl.bounds.size.width, lbl.bounds.size.height);
                 border1.frame = CGRectMake(172, 49,lbl.bounds.size.width, lbl.bounds.size.height);
             }
             
             if([tempArray count]==2){
                 line1.hidden=NO;
                 line2.hidden=NO;
                 line3.hidden=YES;
                 line1.frame = CGRectMake(115, 102, 138.31, 0);
                 line2.frame = CGRectMake(193, 102, 138.31, 0);
                 border1.frame = CGRectMake(172, 58,lbl.bounds.size.width, lbl.bounds.size.height);
                 border1.frame = CGRectMake(204, 49,lbl.bounds.size.width, lbl.bounds.size.height);
             }
             
             if([tempArray count]==3){
                 line1.hidden=NO;
                 line2.hidden=NO;
                 line3.hidden=NO;
                 line3.frame = CGRectMake(235, 102, 138.31, 0);
                 line2.frame = CGRectMake(156, 102, 138.31, 0);
                 line1.frame = CGRectMake(75, 102, 138.31, 0);
                 border1.frame = CGRectMake(204, 58,lbl.bounds.size.width, lbl.bounds.size.height);
                 border1.frame = CGRectMake(246, 49,lbl.bounds.size.width, lbl.bounds.size.height);
             }
             if([tempArray count]==4){
                 line1.hidden=NO;
                 line2.hidden=NO;
                 line3.hidden=NO;
                 line3.frame = CGRectMake(235, 102, 138.31, 0);
                 line2.frame = CGRectMake(156, 102, 138.31, 0);
                 line1.frame = CGRectMake(75, 102, 138.31, 0);
                 border1.frame = CGRectMake(204, 58,lbl.bounds.size.width, lbl.bounds.size.height);
                 border1.frame = CGRectMake(246, 49,lbl.bounds.size.width, lbl.bounds.size.height);
             }
         }
        
    }

    
    border1.strokeColor=[UIColor colorWithRed:0.576  green:0.568 blue:0.513 alpha:1].CGColor;
    border1.fillColor = nil;
    border1.cornerRadius=5;
    border1.masksToBounds = YES;
    border1.lineDashPattern = @[@8.5, @5];
    //[lbl.layer addSublayer:border1];
    //[self.collectionView addSubview:lbl];
}




- (void)viewDidLoad {
    [super viewDidLoad];
    if([[NSUserDefaults standardUserDefaults] integerForKey:@"closeall"] == 1){
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"closeall"];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"CustomCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cvCell2"];
    
    NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"building_details"]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"OpenSans" size:17], NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    [self.navigationItem setTitle:[NSString stringWithFormat:@"%@",dict[@"name"]]];
    int space = self.view.frame.size.width;
    space = space - 130 *2;
    space = space/3;
    /*if(width==414 && height==736){
     flow.itemSize=CGSizeMake( 88, 107);
     }
     else if(width==375 && height==667){
     flow.itemSize=CGSizeMake( 82, 94);
     }
     else{
     if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
     
     flow.itemSize = CGSizeMake(100, 125);
     }
     else{
     flow.itemSize = CGSizeMake(70, 91);
     }
     }*/
    width=[UIScreen mainScreen].bounds.size.width;
    height=[UIScreen mainScreen].bounds.size.height;
    flow = [[UICollectionViewFlowLayout alloc] init];
    flow.minimumInteritemSpacing = 0.114 * width;
    flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flow.itemSize = CGSizeMake(0.212 * width, 0.145 * height);
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        flow.itemSize = CGSizeMake(0.212 * width, 0.195 * height);
    }
    [self.collectionView setCollectionViewLayout:flow];
    
    
    line1 = [CAShapeLayer layer];
    line1.fillColor         = nil;
    line1.strokeColor       = [UIColor colorWithRed:0.576  green:0.568 blue:0.513 alpha:1].CGColor;
    line1.lineDashPattern   = @[@3, @2];
    line1Path = [UIBezierPath bezierPath];
    [line1Path moveToPoint:CGPointMake(10, 0)];
    if((width==414 && height==736)||(width==320 && height==568)||(width==320 && height==480)){
        [line1Path addCurveToPoint:CGPointMake(0, 0) controlPoint1:CGPointMake(5, 0) controlPoint2:CGPointMake(20, 0)];
    }else{
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
            [line1Path addCurveToPoint:CGPointMake(0, 0) controlPoint1:CGPointMake(5, 0) controlPoint2:CGPointMake(17, 0)];
        }
        else{
            [line1Path addCurveToPoint:CGPointMake(0, 0) controlPoint1:CGPointMake(5, 0) controlPoint2:CGPointMake(32, 0)];
        }
    }
    line1.path = line1Path.CGPath;
    //[self.collectionView.layer addSublayer:line1];
    line1.hidden=YES;
    
    line2 = [CAShapeLayer layer];
    line2.fillColor         = nil;
    line2.strokeColor       = [UIColor colorWithRed:0.576  green:0.568 blue:0.513 alpha:1].CGColor;
    line2.lineDashPattern   = @[@3, @2];
    line2Path = [UIBezierPath bezierPath];
    [line2Path moveToPoint:CGPointMake(10, 0)];
    if((width==414 && height==736)||(width==320 && height==568)||(width==320 && height==480)){
        [line2Path addCurveToPoint:CGPointMake(0, 0) controlPoint1:CGPointMake(5, 0) controlPoint2:CGPointMake(20, 0)];
    }else{
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
            [line2Path addCurveToPoint:CGPointMake(0, 0) controlPoint1:CGPointMake(5, 0) controlPoint2:CGPointMake(17, 0)];
        }
        else{
            [line2Path addCurveToPoint:CGPointMake(0, 0) controlPoint1:CGPointMake(5, 0) controlPoint2:CGPointMake(32, 0)];
        }
    }
    line2.path = line2Path.CGPath;
    //[self.collectionView.layer addSublayer:line2];
    line2.hidden=YES;
    
    line3 = [CAShapeLayer layer];
    line3.fillColor         = nil;
    line3.strokeColor       = [UIColor colorWithRed:0.576  green:0.568 blue:0.513 alpha:1].CGColor;
    line3.lineDashPattern   = @[@3, @2];
    line3Path = [UIBezierPath bezierPath];
    [line3Path moveToPoint:CGPointMake(10, 0)];
    if((width==414 && height==736)||(width==320 && height==568)||(width==320 && height==480)){
        [line3Path addCurveToPoint:CGPointMake(0, 0) controlPoint1:CGPointMake(5, 0) controlPoint2:CGPointMake(20, 0)];
    }else{
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
            [line3Path addCurveToPoint:CGPointMake(0, 0) controlPoint1:CGPointMake(5, 0) controlPoint2:CGPointMake(17, 0)];
        }
        else{
            [line3Path addCurveToPoint:CGPointMake(0, 0) controlPoint1:CGPointMake(5, 0) controlPoint2:CGPointMake(32, 0)];
        }
    }
    line3.path = line3Path.CGPath;
    //[self.collectionView.layer addSublayer:line3];
    line3.hidden=YES;
    imagearray = [[NSMutableArray alloc] init];
    close.frame=CGRectMake(4, 0.0528*height, 24, 24);
    self.surveyclose.frame=CGRectMake(4, 0.0528*height, 24, 24);
    [close addTarget:self action:@selector(closecategory:) forControlEvents:UIControlEventTouchUpInside];
    [close setBackgroundImage:[UIImage imageNamed:@"ic_lomobile_menu_cancel_black.png"] forState:UIControlStateNormal];
    [self.view addSubview:close];
    
    if(mi){
        [_milesbutton setTitle:@"Mi" forState:UIControlStateNormal];
        mi=NO;
    }
    else{
        [_milesbutton setTitle:@"Km" forState:UIControlStateNormal];
        mi=YES;
    }
    [_milesbutton addTarget:self action:@selector(mileorkmpressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.vv addSubview:_milesbutton];
    int y=0.2441*height;
    for (int j=0; j<4; j++) {
        NSString *title=@"Button";
        Button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        Button.frame=CGRectMake(0.016 * width, y, 0.483*width, 0.0704*height);
        if(j==0){
            title=@"Car";
            [Button setImage:[UIImage imageNamed:@"ic_lomobile_transit_cars_small.png"]
                    forState:UIControlStateNormal];
        }
        else if(j==1){
            [Button setImage:[UIImage imageNamed:@"ic_lomobile_transit_walk_small.png"]
                    forState:UIControlStateNormal];
            title=@"Walk";
        }
        else if(j==2){
            [Button setImage:[UIImage imageNamed:@"ic_lomobile_transit_light_small.png"]
                    forState:UIControlStateNormal];
            title=@"Tram";
        }
        else if(j==3){
            [Button setImage:[UIImage imageNamed:@"ic_lomobile_transit_alt_small.png"]
                    forState:UIControlStateNormal];
            title=@"Alternative";
        }
        [Button setTitle:title forState:UIControlStateNormal];
        Button.backgroundColor=[UIColor darkGrayColor];
        Button.tintColor=[UIColor whiteColor];
        Button1.tintColor=[UIColor whiteColor];
        [Button setImageEdgeInsets:UIEdgeInsetsMake(7.0, 0.0276*width, 3.0, 0.3548*width)];
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
            Button.titleLabel.font=[UIFont fontWithName:@"GothamBook" size:19];
            [Button setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 40, 0.0, -0.03125*width)];
        }
        else{
            Button.titleLabel.font=[UIFont fontWithName:@"GothamBook" size:16];
            if(width==320 && height==568){
                [Button setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -55, 0.0, -0.03125*width)];
            }
            else if(width==320 && height==480){
                Button.titleLabel.font=[UIFont fontWithName:@"GothamBook" size:12];
                [Button setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -50, 0.0, -0.03125*width)];
            }
            else if(width==414 && height==736){
                [Button setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -40, 0.0, -0.03125*width)];
            }
            else if(width ==375 && height==667){
                [Button setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -45, 0.0, -0.03125*width)];
            }
            else{
                [Button setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -15, 0.0, -0.03125*width)];
            }
        }
        [Button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [Button setTag:1000+j];
        Button.layer.cornerRadius=5;
        [self.view addSubview:Button];
        Button1 =[UIButton buttonWithType:UIButtonTypeRoundedRect];
        Button1.frame=CGRectMake(0.504*width, y, 0.483*width, 0.0704*height);
        [Button1 setBackgroundColor:[UIColor darkGrayColor]];
        
        if(j<=2){
            if(j==0){
                title=@"Bus";
                [Button1 setImage:[UIImage imageNamed:@"ic_lomobile_transit_bus_small.png"]
                         forState:UIControlStateNormal];
            }
            else if(j==1){
                [Button1 setImage:[UIImage imageNamed:@"ic_lomobile_transit_scooter_small.png"]
                         forState:UIControlStateNormal];
                title=@"Motorcycle";
            }
            else if(j==2){
                [Button1 setImage:[UIImage imageNamed:@"ic_lomobile_transit_heavy_small.png"]
                         forState:UIControlStateNormal];
                title=@"Heavy Rail";
            }
            [UIView setAnimationsEnabled:YES];
            [Button1 setTitle:title forState:UIControlStateNormal];
            [Button1 setImageEdgeInsets:UIEdgeInsetsMake(7.0, 0.0276*width, 3.0, 0.3548*width)];
            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
                Button1.titleLabel.font=[UIFont fontWithName:@"GothamBook" size:19];
                [Button1 setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 40, 0.0, -0.03125*width)];
            }
            else{
                Button1.titleLabel.font=[UIFont fontWithName:@"GothamBook" size:16];
                if(width==320 && height==568){
                    [Button1 setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -55, 0.0, -0.03125*width)];
                }
                else if(width==320 && height==480){
                    Button1.titleLabel.font=[UIFont fontWithName:@"GothamBook" size:12];
                    [Button1 setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -50, 0.0, -0.03125*width)];
                }
                else if(width==414 && height==736){
                    [Button1 setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -40, 0.0, -0.03125*width)];
                }
                else if(width ==375 && height==667){
                    [Button1 setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -45, 0.0, -0.03125*width)];
                }
                else{
                    [Button1 setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -15, 0.0, -0.03125*width)];
                }
            }
            
            [Button1 setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
            [UIView setAnimationsEnabled:YES];
            [Button1 setTag:2000+j];
            [self.view addSubview:Button1];
            [Button1.layer setCornerRadius:5];
        }
        [Button1 addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [Button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        y+=0.07812*height;
    }
       //[self dashlineadjust];
}

-(IBAction)mileorkmpressed:(id)sender{

    //
   
}




-(IBAction)buttonPressed:(id)sender{
    i=1;
    self.surveyclose.hidden=NO;
    goback=1;
    self.close.hidden=YES;
    //
    
    clicked = (UIButton *) sender;
    //
    if(iterate<4){
        self.milesbutton.hidden=NO;
    self.collectionView.hidden=YES;
    if(clicked.tag == 2000){
        range = 30;
        myImageView.image = [UIImage imageNamed:@"ic_lomobile_transit_bus_small.png"];
    }
    else if(clicked.tag==2001){
        range = 30;
        myImageView.image = [UIImage imageNamed:@"ic_lomobile_transit_scooter_small.png"];
    }
    else if(clicked.tag==2002){
        range = 30;
        myImageView.image= [UIImage imageNamed:@"ic_lomobile_transit_heavy_small.png"];
}else if(clicked.tag==1002){
        range = 30;
        myImageView.image= [UIImage imageNamed:@"ic_lomobile_transit_light_small.png"];
}
else if(clicked.tag==1003){
        range = 30;
        myImageView.image= [UIImage imageNamed:@"ic_lomobile_transit_alt_small.png"];
}
else if(clicked.tag==1000){
        range = 30;
        myImageView.image= [UIImage imageNamed:@"ic_lomobile_transit_cars_small.png"];
}
else if(clicked.tag==1001){
        range = 3;
        myImageView.image= [UIImage imageNamed:@"ic_lomobile_transit_walk_small.png"];
}
    [self fillroute];
    }
    else{
        //[alert show];
        //[self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:1.0f];
        [self maketoast:@"Maximum limit reached" withbackground:[UIColor blackColor] withdelay:4.5];
    }


}
-(void)maketoast:(NSString *)message withbackground:(UIColor *)color withdelay:(double)delay{
    if([notificationView isDescendantOfView:self.view]){
        [notificationView removeFromSuperview];
    }
    notificationLabel = [[UILabel alloc] init];
    notificationView = [[UIView alloc] init];
    if(self.navigationController != nil){
        notificationView.frame = CGRectMake(0.0, 0.0 , self.view.frame.size.width, 0.058 * [UIScreen mainScreen].bounds.size.height);
    }else{
        
    }
    notificationLabel.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, notificationView.frame.size.height);
    notificationLabel.text      = message;
    [notificationView setBackgroundColor:color];
    [notificationLabel setFont:[UIFont fontWithName:@"OpenSans" size:15]];
    [notificationLabel setNumberOfLines:3];
    [notificationLabel setTextColor:[UIColor whiteColor]];
    [notificationLabel setTextAlignment:NSTextAlignmentCenter];
    [notificationView addSubview:notificationLabel];
    [self.view addSubview:notificationView];
    [self.view bringSubviewToFront:notificationView];
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        notificationView.frame = CGRectMake(0.0, self.navigationController.navigationBar.frame.size.height + self.navigationController.navigationBar.frame.origin.y, self.view.frame.size.width, 0.058 * [UIScreen mainScreen].bounds.size.height);
    } completion:^(BOOL finished){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self hide];
        });
    }];
    
    
    
}

-(void)hide{
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
    } completion:^(BOOL finished){        
        [notificationView removeFromSuperview];
    }];
    
    
}


-(void)dismissAlert:(UIAlertView *)alert{
    [alert dismissWithClickedButtonIndex:(int)nil animated:YES];
}

-(void)closeit{
    if (opened==YES) {
    [alert dismissWithClickedButtonIndex:(int)nil animated:YES];
    }
}


-(void)fillroute{
    mi = NO;
    if(!mi){
        [milabel setText:@"Mi"];
    }
    else{
        [milabel setText:@"Km"];
    }

    [routescore becomeFirstResponder];
    self.vv.hidden=NO;
    self.submitbtn.hidden=YES;
    self.vv.backgroundColor=[UIColor darkGrayColor]; //gray color
    self.howmany.hidden=YES;
    [[self.view viewWithTag:1000] setHidden:YES];
    [[self.view viewWithTag:1001] setHidden:YES];
    [[self.view viewWithTag:1002] setHidden:YES];
    [[self.view viewWithTag:1003] setHidden:YES];
    [[self.view viewWithTag:2000] setHidden:YES];
    [[self.view viewWithTag:2001] setHidden:YES];
    [[self.view viewWithTag:2002] setHidden:YES];
    [self.gtitle setHidden:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
 
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if(textField==routescore){
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSArray *sep = [newString componentsSeparatedByString:@"."];
        NSString *neString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        NSString *expression = @"^([0-9]+)?(\\.([0-9]{1,2})?)?$";
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:nil];
        NSUInteger numberOfMatches = [regex numberOfMatchesInString:neString
                                                            options:0
                                                              range:NSMakeRange(0, [newString length])];
        if (numberOfMatches == 0)
            return NO;
    if([sep count] >= 2)
    {
        NSString *sepStr=[NSString stringWithFormat:@"%@",[sep objectAtIndex:1]];
        return !([sepStr length]>1);
    }
    else{
        NSUInteger newLength = [routescore.text length] + [string length] - range.length;
        return (newLength > 3) ? NO : YES;
    }
    }
    else{
        
        NSCharacterSet *acceptedInput = [NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARECTERS];
            NSUInteger nwLength = [self.howmany.text length] + [string length] - range.length;
            return ((nwLength>1) || ([[string componentsSeparatedByCharactersInSet:acceptedInput] count]>1) ) ? NO : YES;
 }
    return YES;
   }

int range = 0;

- (IBAction)surveydone:(id)sender {
   
    if(([routescore.text isEqualToString:@""])||([routescore.text isEqualToString:@"0"])){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please Enter a value greater than 0" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];

        //[alert show];
        //[self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:1.0f];
        [self maketoast:@"Please enter a value greater than 0" withbackground:[UIColor blackColor] withdelay:4.5];
        
    }else if([routescore.text integerValue] > 0 && [routescore.text integerValue] > range){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@ miles seems above average for one day, one way. Please check if this is correct.",routescore.text] delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
        
        //[alert show];
        //[self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:1.0f];
        [self maketoast:[NSString stringWithFormat:@"%@ miles seems above average for one day, one way. Please check if this is correct.",routescore.text] withbackground:[UIColor blackColor] withdelay:4.5];
        
    }
    else{
                    if(clicked.tag!=1000){
                            iterate++;
                        NSMutableString *str=[[NSMutableString alloc] init];
                                if(mi==NO){
                                [tempArray addObject:routescore.text];
                                }
                                else{
                                    int num=[routescore.text intValue];

                                    num=num*0.62137;
                                    [tempArray addObject:[NSString stringWithFormat:@"%i",num]];
                                }   
                                if(clicked.tag == 2000){
                                    [busarray addObject:routescore.text];
                                    [str setString:@""];
                                    [imagearray addObject:@"ic_lomobile_transit_bus_small.png"];
                                    [str appendString:@"bus"];
                                    [captionArray addObject:str];

                                }
                                else if(clicked.tag==2001){
                                    [motorarray addObject:routescore.text];
                                    [imagearray addObject:@"ic_lomobile_transit_scooter_small.png"];
                                    str=[NSMutableString stringWithFormat:@"motorcycle"];
                                    [captionArray addObject:str];
                                }
                                else if(clicked.tag==2002){
                                    [railarray addObject:routescore.text];
                                    [imagearray addObject:@"ic_lomobile_transit_heavy_small.png"];
                                    [str setString:@""];
                                    [str appendString:@"heavy_rail"];
                                    [captionArray addObject:str];

                                    
                                }else if(clicked.tag==1002){                                                                        [tramarray addObject:routescore.text];
                                    [imagearray addObject:@"ic_lomobile_transit_light_small.png"];
                                    [captionArray addObject:@"light_rail"];
                                }
                                else if(clicked.tag==1003){
                                    [altarray addObject:routescore.text];
                                    [imagearray addObject:@"ic_lomobile_transit_alt_small.png"];
                                    [captionArray addObject:@"cars4"];
                                }
                                
                                else if(clicked.tag==1001){
                                    [walkarray addObject:routescore.text];
                                    [imagearray addObject:@"ic_lomobile_transit_walk_small.png"];
                                    [captionArray addObject:@"walk"];
                                }
                        i=1;
                        route=[NSString stringWithFormat:@"%.1f",[ routescore.text doubleValue]];
                        [self.collectionView reloadData];                        
                        [self closecategory:nil];
                    }
                    else{
                        [tempArray addObject:routescore.text];
                        self.milabel.hidden=YES;
                        route=[NSString stringWithFormat:@"%.1f",[ routescore.text doubleValue]];

                        routescore.hidden=YES;
                        self.milesbutton.hidden=YES;
                        self.howmany.hidden=NO;
                        [self.howmany becomeFirstResponder];
                        [self.howmany setPlaceholder:@"0"];
                        myImageView.hidden=YES;
                        self.cardone.hidden=NO;
                        self.surveydone.hidden=YES;
                        [self.howfar setText:@"How many people were in the car? Include yourself!"];
                    }


    }

}
- (IBAction)carsurveydone:(id)sender {
        if([self.howmany.text isEqualToString:@"0"]||([self.howmany.text isEqualToString:@""])){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please enter more than 0" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];

            //[alert show];
            //[self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:1.0f];
            [self maketoast:@"Please enter more than 0" withbackground:[UIColor blackColor] withdelay:4.5];
        }
        else{
        goback=0;
            iterate++;
        self.surveydone.hidden=YES;
        self.routescore.hidden=YES;
        self.howmany.hidden=YES;
        i=1;
        howmanypeople=[self.howmany.text intValue];
        if(howmanypeople==1){
            [imagearray addObject:@"ic_lomobile_transit_car_small.png"];
            [captionArray addObject:@"car"];
            [cararray addObject:routescore.text];
        }
        else if(howmanypeople>=2 && howmanypeople<=3)
        {
            [car23array addObject:routescore.text];
            [imagearray addObject:@"ic_lomobile_transit_car23_small.png"];
            [captionArray addObject:@"car23"];
        }
        else{
            [altarray addObject:routescore.text];
            [imagearray addObject:@"ic_lomobile_transit_car4_small.png"];
            [captionArray addObject:@"cars4"];
        }
        [self.howmany resignFirstResponder];
        self.collectionView.dataSource = self;
        [self.collectionView reloadData];
        [self.howmany setText:@""];
       [self closecategory:nil];
    }

}





-(void) action:(id)sender
{

    for (UIView *subView in self.view.subviews)
    {
        if (subView.tag == 100)
        {
            subView.hidden = YES;
                    }
        else if (subView.tag == 101)
        {
            subView.hidden=YES;
        }
        else if (subView.tag == 102)
        {
            subView.hidden=YES;
        }
        else if (subView.tag == 103)
        {
            subView.hidden=YES;
        }
    }
}

- (IBAction)stopfilling:(id)sender {
    
    [[self.view viewWithTag:1000] setHidden:NO];
    [[self.view viewWithTag:1001] setHidden:NO];
    [[self.view viewWithTag:1002] setHidden:NO];
    [[self.view viewWithTag:1003] setHidden:NO];
    [[self.view viewWithTag:2000] setHidden:NO];
    [[self.view viewWithTag:2001] setHidden:NO];
    [[self.view viewWithTag:2002] setHidden:NO];
    [self.gtitle setHidden:NO];
    vv.hidden=YES;
    self.submitbtn.hidden=NO;
    [self.routescore resignFirstResponder];
    [self.howmany resignFirstResponder];
    self.routescore.hidden=NO;
    self.milabel.hidden=NO;
    myImageView.hidden=NO;
    self.surveydone.hidden=NO;
    self.cardone.hidden=YES;
    self.collectionView.hidden = NO;
    routescore.text=@"";
    [self.howfar setText:@"How far did you travel?"];
    goback=0;
    
}

- (IBAction)transitsurveydone:(id)sender {
    goback=0;

            NSString *header=[[NSString alloc] init];
    if([tempArray count]!=0){
        double carsum = 0;
        double car23sum = 0;
        double altsum = 0;
        double walksum = 0;
        double tramsum = 0;
        double railsum = 0;
        double bussum = 0;
        double motorsum = 0;
        
        for (int n=0; n<captionArray.count; n++) {
            if([[[captionArray objectAtIndex:n] uppercaseString] isEqualToString:@"BUS"]){
                bussum+=[[tempArray objectAtIndex:n] doubleValue];
            }
            if([[[captionArray objectAtIndex:n] uppercaseString] isEqualToString:@"WALK"]){
                walksum+=[[tempArray objectAtIndex:n] doubleValue];
            }
            if([[[captionArray objectAtIndex:n] uppercaseString] isEqualToString:@"LIGHT_RAIL"]){
                tramsum+=[[tempArray objectAtIndex:n] doubleValue];
            }
            if([[[captionArray objectAtIndex:n] uppercaseString] isEqualToString:@"CARS4"]){
                altsum+=[[tempArray objectAtIndex:n] doubleValue];
            }
            if([[[captionArray objectAtIndex:n] uppercaseString] isEqualToString:@"CAR23"]){
                car23sum+=[[tempArray objectAtIndex:n] doubleValue];
            }
            if([[[captionArray objectAtIndex:n] uppercaseString] isEqualToString:@"HEAVY_RAIL"]){
                railsum+=[[tempArray objectAtIndex:n] doubleValue];
            }
            if([[[captionArray objectAtIndex:n] uppercaseString] isEqualToString:@"MOTORCYCLE"]){
                motorsum+=[[tempArray objectAtIndex:n] doubleValue];
            }
            if([[[captionArray objectAtIndex:n] uppercaseString] isEqualToString:@"CAR"]){
                carsum+=[[tempArray objectAtIndex:n] doubleValue];
            }
            
        }
        [cararray addObject:[NSString stringWithFormat:@"%f", carsum]];
        [walkarray addObject:[NSString stringWithFormat:@"%f", walksum]];
        [busarray addObject:[NSString stringWithFormat:@"%f", bussum]];
        [motorarray addObject:[NSString stringWithFormat:@"%f", motorsum]];
        [car23array addObject:[NSString stringWithFormat:@"%f", car23sum]];
        [altarray addObject:[NSString stringWithFormat:@"%f", altsum]];
        [tramarray addObject:[NSString stringWithFormat:@"%f", tramsum]];
        [railarray addObject:[NSString stringWithFormat:@"%f", railsum]];
        int busalready,car23already,motoralready,tramalready,railalready,walkalready,caralready,cars4already;
        busalready=0;
        car23already=0;
        motoralready=0;
        tramalready=0;
        railalready=0;
        walkalready=0;
        caralready=0;
        cars4already=0;
        d=[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"",@"", nil];
        NSString *str1,*str2,*str3,*str4;
        [d removeAllObjects];
        if(tempArray.count==1){
            for (int x=0; x<1; x++) {
                str1=[NSString stringWithFormat:@"\"%@\"",[captionArray objectAtIndex:x]];
                [d setObject:[tempArray objectAtIndex:x]  forKey:str1];
            }
            header=[NSString stringWithFormat: @"{%@:%@}",str1,[d objectForKey:str1]];
        }
        
        else if(tempArray.count==2){
            NSMutableArray *unique=[NSMutableArray array];
            for (id obj in captionArray) {
                if (![unique containsObject:obj]) {
                    NSString *str=(NSString *)obj;
                    [unique addObject:str];
                }
            }
            
            for (int x=0; x<unique.count; x++) {
                if(x==0){
                    str1=[NSString stringWithFormat:@"\"%@\"",[unique objectAtIndex:x]];
                    if([[[unique objectAtIndex:x] uppercaseString] isEqualToString:@"BUS"]){
                        if(busalready==0){
                            [d setObject:[NSString stringWithFormat:@"%.1f",bussum]  forKey:str1];
                            busalready=1;
                        }
                    }
                    if([[[unique objectAtIndex:x] uppercaseString] isEqualToString:@"WALK"]){
                        if(walkalready==0){
                            [d setObject:[NSString stringWithFormat:@"%.1f",walksum]  forKey:str1];
                            walkalready=1;
                        }
                    }
                    if([[[unique objectAtIndex:x] uppercaseString] isEqualToString:@"LIGHT_RAIL"]){
                        if(tramalready==0){
                            [d setObject:[NSString stringWithFormat:@"%.1f",tramsum]  forKey:str1];
                            tramalready=1;
                        }
                    }
                    if([[[unique objectAtIndex:x] uppercaseString] isEqualToString:@"CARS4"]){
                        if(cars4already==0){
                            [d setObject:[NSString stringWithFormat:@"%.1f",altsum]  forKey:str1];
                            cars4already=1;
                        }
                    }
                    if([[[unique objectAtIndex:x] uppercaseString] isEqualToString:@"CAR23"]){
                        if(car23already==0){
                            [d setObject:[NSString stringWithFormat:@"%.1f",car23sum]  forKey:str1];
                            car23already=1;
                        }
                    }
                    if([[[unique objectAtIndex:x] uppercaseString] isEqualToString:@"HEAVY_RAIL"]){
                        if(railalready==0){
                            [d setObject:[NSString stringWithFormat:@"%.1f",railsum]  forKey:str1];
                            railalready=1;
                        }
                    }
                    if([[[unique objectAtIndex:x] uppercaseString] isEqualToString:@"MOTORCYCLE"]){
                        if(motoralready==0){
                            [d setObject:[NSString stringWithFormat:@"%.1f",motorsum]  forKey:str1];
                            motoralready=1;
                        }
                    }
                    if([[[unique objectAtIndex:x] uppercaseString] isEqualToString:@"CAR"]){
                        if(caralready==0){
                            [d setObject:[NSString stringWithFormat:@"%.1f",carsum]  forKey:str1];
                            caralready=1;
                        }
                    }
                }
                
                else if(x==1){
                    str2=[NSString stringWithFormat:@"\"%@\"",[unique objectAtIndex:x]];
                    if([[[unique objectAtIndex:x] uppercaseString] isEqualToString:@"BUS"]){
                        if(busalready==0){
                            [d setObject:[NSString stringWithFormat:@"%.1f",bussum]  forKey:str2];
                            busalready=1;
                        }
                    }
                    if([[[unique objectAtIndex:x] uppercaseString] isEqualToString:@"WALK"]){
                        if(walkalready==0){
                            [d setObject:[NSString stringWithFormat:@"%.1f",walksum]  forKey:str2];
                            walkalready=1;
                        }
                    }
                    if([[[unique objectAtIndex:x] uppercaseString] isEqualToString:@"LIGHT_RAIL"]){
                        if(tramalready==0){
                            [d setObject:[NSString stringWithFormat:@"%.1f",tramsum]  forKey:str2];
                            tramalready=1;
                        }
                    }
                    if([[[unique objectAtIndex:x] uppercaseString] isEqualToString:@"CARS4"]){
                        if(cars4already==0){
                            [d setObject:[NSString stringWithFormat:@"%.1f",altsum]  forKey:str2];
                            cars4already=1;
                        }
                    }
                    if([[[unique objectAtIndex:x] uppercaseString] isEqualToString:@"CAR23"]){
                        if(car23already==0){
                            [d setObject:[NSString stringWithFormat:@"%.1f",car23sum]  forKey:str2];
                            car23already=1;
                        }
                    }
                    if([[[unique objectAtIndex:x] uppercaseString] isEqualToString:@"HEAVY_RAIL"]){
                        if(railalready==0){
                            [d setObject:[NSString stringWithFormat:@"%.1f",railsum]  forKey:str2];
                            railalready=1;
                        }
                    }
                    if([[[unique objectAtIndex:x] uppercaseString] isEqualToString:@"MOTORCYCLE"]){
                        if(motoralready==0){
                            [d setObject:[NSString stringWithFormat:@"%.1f",motorsum]  forKey:str2];
                            motoralready=1;
                        }
                    }
                    if([[[unique objectAtIndex:x] uppercaseString] isEqualToString:@"CAR"]){
                        if(caralready==0){
                            [d setObject:[NSString stringWithFormat:@"%.1f",carsum]  forKey:str2];
                            caralready=1;
                        }
                    }
                    
                }

                
            }
            if(unique.count==1){
                header=[NSString stringWithFormat: @"{%@:%@}",str1,[d objectForKey:str1]];

            }
            else{
                header=[NSString stringWithFormat: @"{%@:%@,%@:%@}",str1,[d objectForKey:str1],str2,[d objectForKey:str2]];

            }

            
        }
        else if(tempArray.count==3){
            NSMutableArray *unique = [NSMutableArray array];
            for (id obj in captionArray) {
                if (![unique containsObject:obj]) {
                    NSString *str=(NSString *)obj;
                    [unique addObject:str];
                }
            }
            for (int x=0; x<unique.count; x++) {
                if(x==0){
                    str1=[NSString stringWithFormat:@"\"%@\"",[unique objectAtIndex:x]];
                    if([[[unique objectAtIndex:x] uppercaseString] isEqualToString:@"BUS"]){
                        if(busalready==0){
                        [d setObject:[NSString stringWithFormat:@"%.1f",bussum]  forKey:str1];
                            busalready=1;
                        }
                    }
                    if([[[unique objectAtIndex:x] uppercaseString] isEqualToString:@"WALK"]){
                        if(walkalready==0){
                        [d setObject:[NSString stringWithFormat:@"%.1f",walksum]  forKey:str1];
                            walkalready=1;
                        }
                    }
                    if([[[unique objectAtIndex:x] uppercaseString] isEqualToString:@"LIGHT_RAIL"]){
                        if(tramalready==0){
                        [d setObject:[NSString stringWithFormat:@"%.1f",tramsum]  forKey:str1];
                            tramalready=1;
                        }
                    }
                    if([[[unique objectAtIndex:x] uppercaseString] isEqualToString:@"CARS4"]){
                        if(cars4already==0){
                        [d setObject:[NSString stringWithFormat:@"%.1f",altsum]  forKey:str1];
                            cars4already=1;
                        }
                    }
                    if([[[unique objectAtIndex:x] uppercaseString] isEqualToString:@"CAR23"]){
                        if(car23already==0){
                        [d setObject:[NSString stringWithFormat:@"%.1f",car23sum]  forKey:str1];
                            car23already=1;
                        }
                    }
                    if([[[unique objectAtIndex:x] uppercaseString] isEqualToString:@"HEAVY_RAIL"]){
                        if(railalready==0){
                        [d setObject:[NSString stringWithFormat:@"%.1f",railsum]  forKey:str1];
                            railalready=1;
                        }
                    }
                    if([[[unique objectAtIndex:x] uppercaseString] isEqualToString:@"MOTORCYCLE"]){
                        if(motoralready==0){
                        [d setObject:[NSString stringWithFormat:@"%.1f",motorsum]  forKey:str1];
                            motoralready=1;
                        }
                    }
                    if([[[unique objectAtIndex:x] uppercaseString] isEqualToString:@"CAR"]){
                        if(caralready==0){
                        [d setObject:[NSString stringWithFormat:@"%.1f",carsum]  forKey:str1];
                            caralready=1;
                        }
                    }
                }
                
                else if(x==1){
                    str2=[NSString stringWithFormat:@"\"%@\"",[unique objectAtIndex:x]];
                    if([[[unique objectAtIndex:x] uppercaseString] isEqualToString:@"BUS"]){
                        if(busalready==0){
                        [d setObject:[NSString stringWithFormat:@"%.1f",bussum]  forKey:str2];
                            busalready=1;
                        }
                    }
                    if([[[unique objectAtIndex:x] uppercaseString] isEqualToString:@"WALK"]){
                        if(walkalready==0){
                        [d setObject:[NSString stringWithFormat:@"%.1f",walksum]  forKey:str2];
                            walkalready=1;
                        }
                    }
                    
                    
                    
                    if([[[unique objectAtIndex:x] uppercaseString] isEqualToString:@"LIGHT_RAIL"]){
                        if(tramalready==0){
                        [d setObject:[NSString stringWithFormat:@"%.1f",tramsum]  forKey:str2];
                            tramalready=1;
                        }
                    }
                    if([[[unique objectAtIndex:x] uppercaseString] isEqualToString:@"CARS4"]){
                        if(cars4already==0){
                        [d setObject:[NSString stringWithFormat:@"%.1f",altsum]  forKey:str2];
                            cars4already=1;
                        }
                    }
                    if([[[unique objectAtIndex:x] uppercaseString] isEqualToString:@"CAR23"]){
                        if(car23already==0){
                        [d setObject:[NSString stringWithFormat:@"%.1f",car23sum]  forKey:str2];
                            car23already=1;
                        }
                    }
                    if([[[unique objectAtIndex:x] uppercaseString] isEqualToString:@"HEAVY_RAIL"]){
                        if(railalready==0){
                        [d setObject:[NSString stringWithFormat:@"%.1f",railsum]  forKey:str2];
                            railalready=1;
                        }
                    }
                    if([[[unique objectAtIndex:x] uppercaseString] isEqualToString:@"MOTORCYCLE"]){
                        if(motoralready==0){
                        [d setObject:[NSString stringWithFormat:@"%.1f",motorsum]  forKey:str2];
                            motoralready=1;
                        }
                    }
                    if([[[unique objectAtIndex:x] uppercaseString] isEqualToString:@"CAR"]){
                        if(caralready==0){
                        [d setObject:[NSString stringWithFormat:@"%.1f",carsum]  forKey:str2];
                            caralready=1;
                        }
                    }
                    
                }
                if(x==2){
                    
                    str3=[NSString stringWithFormat:@"\"%@\"",[unique objectAtIndex:x]];
                    if([[[unique objectAtIndex:x] uppercaseString] isEqualToString:@"BUS"]){
                        if(busalready==0){
                        [d setObject:[NSString stringWithFormat:@"%.1f",bussum]  forKey:str3];
                            busalready=1;
                        }
                    }
                    if([[[unique objectAtIndex:x] uppercaseString] isEqualToString:@"WALK"]){
                        if(walkalready==0){
                        [d setObject:[NSString stringWithFormat:@"%.1f",walksum]  forKey:str3];
                            walkalready=1;
                        }
                    }
                    if([[[unique objectAtIndex:x] uppercaseString] isEqualToString:@"LIGHT_RAIL"]){
                        if(tramalready==0){
                        [d setObject:[NSString stringWithFormat:@"%.1f",tramsum]  forKey:str3];
                            tramalready=1;
                        }
                    }
                    if([[[unique objectAtIndex:x] uppercaseString] isEqualToString:@"CARS4"]){
                        if(cars4already==0){
                        [d setObject:[NSString stringWithFormat:@"%.1f",altsum]  forKey:str3];
                            cars4already=1;
                        }
                    }
                    if([[[unique objectAtIndex:x] uppercaseString] isEqualToString:@"CAR23"]){
                        if(car23already==0){
                        [d setObject:[NSString stringWithFormat:@"%.1f",car23sum]  forKey:str3];
                            car23already=1;
                        }
                    }
                    if([[[unique objectAtIndex:x] uppercaseString] isEqualToString:@"HEAVY_RAIL"]){
                        if(railalready==0){
                        [d setObject:[NSString stringWithFormat:@"%.1f",railsum]  forKey:str3];
                            railalready=1;
                        }
                    }
                    if([[[unique objectAtIndex:x] uppercaseString] isEqualToString:@"MOTORCYCLE"]){
                        if(motoralready==0){
                        [d setObject:[NSString stringWithFormat:@"%.1f",motorsum]  forKey:str3];
                            motoralready=1;
                        }
                    }
                    if([[[unique objectAtIndex:x] uppercaseString] isEqualToString:@"CAR"]){
                        if(caralready==0){
                        [d setObject:[NSString stringWithFormat:@"%.1f",carsum]  forKey:str3];
                            caralready=1;
                        }
                    }
                }
                
                
                
            }
            if(unique.count==1){
            header=[NSString stringWithFormat: @"{%@:%@}",str1,[d objectForKey:str1]];
            }
            else if(unique.count==2){
                 header=[NSString stringWithFormat: @"{%@:%@,%@:%@}",str1,[d objectForKey:str1],str2,[d objectForKey:str2]];
            }
            else{
            header=[NSString stringWithFormat: @"{%@:%@,%@:%@,%@:%@}",str1,[d objectForKey:str1],str2,[d objectForKey:str2],str3,[d objectForKey:str3]];
            }
        }
        
        else if(tempArray.count==4){
            NSMutableArray *unique = [NSMutableArray array];
            
            for (id obj in captionArray) {
                if (![unique containsObject:obj]) {
                    NSString *str=(NSString *)obj;
                    [unique addObject:str];
                }
            }
            
            for (int x=0; x<unique.count; x++) {
                        if(x==0){
                            str1=[NSString stringWithFormat:@"\"%@\"",[unique objectAtIndex:x]];
                            if([[[unique objectAtIndex:x] uppercaseString] isEqualToString:@"BUS"]){
                                if(busalready==0){
                                    [d setObject:[NSString stringWithFormat:@"%.1f",bussum]  forKey:str1];
                                    busalready=1;
                                }
                            }
                            if([[[unique objectAtIndex:x] uppercaseString] isEqualToString:@"WALK"]){
                                if(walkalready==0){
                                    [d setObject:[NSString stringWithFormat:@"%.1f",walksum]  forKey:str1];
                                    walkalready=1;
                                }
                            }
                            if([[[unique objectAtIndex:x] uppercaseString] isEqualToString:@"LIGHT_RAIL"]){
                                if(tramalready==0){
                                    [d setObject:[NSString stringWithFormat:@"%.1f",tramsum]  forKey:str1];
                                    tramalready=1;
                                }
                            }
                            if([[[unique objectAtIndex:x] uppercaseString] isEqualToString:@"CARS4"]){
                                if(cars4already==0){
                                    [d setObject:[NSString stringWithFormat:@"%.1f",altsum]  forKey:str1];
                                    cars4already=1;
                                }
                            }
                            if([[[unique objectAtIndex:x] uppercaseString] isEqualToString:@"CAR23"]){
                                if(car23already==0){
                                    [d setObject:[NSString stringWithFormat:@"%.1f",car23sum]  forKey:str1];
                                    car23already=1;
                                }
                            }
                            if([[[unique objectAtIndex:x] uppercaseString] isEqualToString:@"HEAVY_RAIL"]){
                                if(railalready==0){
                                    [d setObject:[NSString stringWithFormat:@"%.1f",railsum]  forKey:str1];
                                    railalready=1;
                                }
                            }
                            if([[[unique objectAtIndex:x] uppercaseString] isEqualToString:@"MOTORCYCLE"]){
                                if(motoralready==0){
                                    [d setObject:[NSString stringWithFormat:@"%.1f",motorsum]  forKey:str1];
                                    motoralready=1;
                                }
                            }
                            if([[[unique objectAtIndex:x] uppercaseString] isEqualToString:@"CAR"]){
                                if(caralready==0){
                                    [d setObject:[NSString stringWithFormat:@"%.1f",carsum]  forKey:str1];
                                    caralready=1;
                                }
                            }
                        }
                        
                        else if(x==1){
                            str2=[NSString stringWithFormat:@"\"%@\"",[unique objectAtIndex:x]];
                            if([[[unique objectAtIndex:x] uppercaseString] isEqualToString:@"BUS"]){
                                if(busalready==0){
                                    [d setObject:[NSString stringWithFormat:@"%.1f",bussum]  forKey:str2];
                                    busalready=1;
                                }
                            }
                            if([[[unique objectAtIndex:x] uppercaseString] isEqualToString:@"WALK"]){
                                if(walkalready==0){
                                    [d setObject:[NSString stringWithFormat:@"%.1f",walksum]  forKey:str2];
                                    walkalready=1;
                                }
                            }
                            
                            
                            
                            if([[[unique objectAtIndex:x] uppercaseString] isEqualToString:@"LIGHT_RAIL"]){
                                if(tramalready==0){
                                    [d setObject:[NSString stringWithFormat:@"%.1f",tramsum]  forKey:str2];
                                    tramalready=1;
                                }
                            }
                            if([[[unique objectAtIndex:x] uppercaseString] isEqualToString:@"CARS4"]){
                                if(cars4already==0){
                                    [d setObject:[NSString stringWithFormat:@"%.1f",altsum]  forKey:str2];
                                    cars4already=1;
                                }
                            }
                            if([[[unique objectAtIndex:x] uppercaseString] isEqualToString:@"CAR23"]){
                                if(car23already==0){
                                    [d setObject:[NSString stringWithFormat:@"%.1f",car23sum]  forKey:str2];
                                    car23already=1;
                                }
                            }
                            if([[[unique objectAtIndex:x] uppercaseString] isEqualToString:@"HEAVY_RAIL"]){
                                if(railalready==0){
                                    [d setObject:[NSString stringWithFormat:@"%.1f",railsum]  forKey:str2];
                                    railalready=1;
                                }
                            }
                            if([[[unique objectAtIndex:x] uppercaseString] isEqualToString:@"MOTORCYCLE"]){
                                if(motoralready==0){
                                    [d setObject:[NSString stringWithFormat:@"%.1f",motorsum]  forKey:str2];
                                    motoralready=1;
                                }
                            }
                            if([[[unique objectAtIndex:x] uppercaseString] isEqualToString:@"CAR"]){
                                if(caralready==0){
                                    [d setObject:[NSString stringWithFormat:@"%.1f",carsum]  forKey:str2];
                                    caralready=1;
                                }
                            }
                            
                        }
                        if(x==2){
                            
                            str3=[NSString stringWithFormat:@"\"%@\"",[unique objectAtIndex:x]];
                            if([[[unique objectAtIndex:x] uppercaseString] isEqualToString:@"BUS"]){
                                if(busalready==0){
                                    [d setObject:[NSString stringWithFormat:@"%.1f",bussum]  forKey:str3];
                                    busalready=1;
                                }
                            }
                            if([[[unique objectAtIndex:x] uppercaseString] isEqualToString:@"WALK"]){
                                if(walkalready==0){
                                    [d setObject:[NSString stringWithFormat:@"%.1f",walksum]  forKey:str3];
                                    walkalready=1;
                                }
                            }
                            if([[[unique objectAtIndex:x] uppercaseString] isEqualToString:@"LIGHT_RAIL"]){
                                if(tramalready==0){
                                    [d setObject:[NSString stringWithFormat:@"%.1f",tramsum]  forKey:str3];
                                    tramalready=1;
                                }
                            }
                            if([[[unique objectAtIndex:x] uppercaseString] isEqualToString:@"CARS4"]){
                                if(cars4already==0){
                                    [d setObject:[NSString stringWithFormat:@"%.1f",altsum]  forKey:str3];
                                    cars4already=1;
                                }
                            }
                            if([[[unique objectAtIndex:x] uppercaseString] isEqualToString:@"CAR23"]){
                                if(car23already==0){
                                    [d setObject:[NSString stringWithFormat:@"%.1f",car23sum]  forKey:str3];
                                    car23already=1;
                                }
                            }
                            if([[[unique objectAtIndex:x] uppercaseString] isEqualToString:@"HEAVY_RAIL"]){
                                if(railalready==0){
                                    [d setObject:[NSString stringWithFormat:@"%.1f",railsum]  forKey:str3];
                                    railalready=1;
                                }
                            }
                            if([[[unique objectAtIndex:x] uppercaseString] isEqualToString:@"MOTORCYCLE"]){
                                if(motoralready==0){
                                    [d setObject:[NSString stringWithFormat:@"%.1f",motorsum]  forKey:str3];
                                    motoralready=1;
                                }
                            }
                            if([[[unique objectAtIndex:x] uppercaseString] isEqualToString:@"CAR"]){
                                if(caralready==0){
                                    [d setObject:[NSString stringWithFormat:@"%.1f",carsum]  forKey:str3];
                                    caralready=1;
                                }
                            }
                        }
                
                else if(x==3){
                    str4=[NSString stringWithFormat:@"\"%@\"",[unique objectAtIndex:x]];
                    if([[[unique objectAtIndex:x] uppercaseString] isEqualToString:@"BUS"]){
                         if(busalready==0){
                        [d setObject:[NSString stringWithFormat:@"%.1f",bussum]  forKey:str4];
                             busalready=1;
                         }
                    }
                    if([[[unique objectAtIndex:x] uppercaseString] isEqualToString:@"WALK"]){
                         if(walkalready==0){
                        [d setObject:[NSString stringWithFormat:@"%.1f",walksum]  forKey:str4];
                             walkalready=1;
                         }
                    }
                    if([[[unique objectAtIndex:x] uppercaseString] isEqualToString:@"LIGHT_RAIL"]){
                         if(tramalready==0){
                        [d setObject:[NSString stringWithFormat:@"%.1f",tramsum]  forKey:str4];
                             tramalready=1;
                         }
                    }
                    if([[[unique objectAtIndex:x] uppercaseString] isEqualToString:@"CARS4"]){
                         if(cars4already==0){
                        [d setObject:[NSString stringWithFormat:@"%.1f",altsum]  forKey:str4];
                             cars4already=1;
                         }
                    }
                    if([[[unique objectAtIndex:x] uppercaseString] isEqualToString:@"CAR23"]){
                         if(car23already==0){
                        [d setObject:[NSString stringWithFormat:@"%.1f",car23sum]  forKey:str4];
                             car23already=1;
                         }
                    }
                    if([[[unique objectAtIndex:x] uppercaseString] isEqualToString:@"HEAVY_RAIL"]){
                         if(railalready==0){
                        [d setObject:[NSString stringWithFormat:@"%.1f",railsum]  forKey:str4];
                             railalready=1;
                         }
                    }
                    if([[[unique objectAtIndex:x] uppercaseString] isEqualToString:@"MOTORCYCLE"]){
                         if(motoralready==0){
                        [d setObject:[NSString stringWithFormat:@"%.1f",motorsum]  forKey:str4];
                             motoralready=1;
                         }
                    }
                    if([[[unique objectAtIndex:x] uppercaseString] isEqualToString:@"CAR"]){
                         if(caralready==0){
                        [d setObject:[NSString stringWithFormat:@"%.1f",carsum]  forKey:str4];
                             caralready=1;
                         }
                    }
                    
                }
                
                
                
            }
            
            if(unique.count==1){
            header=[NSString stringWithFormat: @"{%@:%@}",str1,[d objectForKey:str1]];
            }
            else if(unique.count==2){
            header=[NSString stringWithFormat: @"{%@:%@,%@:%@}",str1,[d objectForKey:str1],str2,[d objectForKey:str2]];
            }
            else if(unique.count==3){
            header=[NSString stringWithFormat: @"{%@:%@,%@:%@,%@:%@}",str1,[d objectForKey:str1],str2,[d objectForKey:str2],str3,[d objectForKey:str3]];
            }
            else{
            header=[NSString stringWithFormat: @"{%@:%@,%@:%@,%@:%@,%@:%@}",str1,[d objectForKey:str1],str2,[d objectForKey:str2],str3,[d objectForKey:str3],str4,[d objectForKey:str4]];
            }
            
        }
        NSMutableArray *unique = [NSMutableArray array];
        
        for (id obj in captionArray) {
            if (![unique containsObject:obj]) {
                NSString *str=(NSString *)obj;
                str=[str stringByReplacingOccurrencesOfString:@"_" withString:@" "];
                str=[[str componentsSeparatedByCharactersInSet:
                      [[NSCharacterSet letterCharacterSet] invertedSet]] componentsJoinedByString:@""];
                [unique addObject:str];
            }
        }
        
        
        if(unique.count==1){
            [prefs setObject:[[unique objectAtIndex:0]capitalizedString] forKey:@"routelabel"];
        }
        else if(unique.count==2){
            [prefs setObject:[NSString stringWithFormat:@"%@ n' %@",[[unique objectAtIndex:0] capitalizedString],[[unique objectAtIndex:1]capitalizedString]] forKey:@"routelabel"];
        }
        else if(unique.count==3){
            [prefs setObject:@"The mix" forKey:@"routelabel"];
        }
        else{
            [prefs setObject:@"The mix" forKey:@"routelabel"];
        }
        
        [prefs setInteger:1 forKey:@"added"];
        [prefs setObject:header forKey:@"jsonquery"];
        //[self performSegueWithIdentifier:@"transit" sender:self];
        UIStoryboard *mainstoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *v = [[UIViewController alloc] init];
        int grid = 0;
        grid = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"grid"];
        if(grid == 1){
            v = [mainstoryboard instantiateViewControllerWithIdentifier:@"grid"];
        }else{
            v = [mainstoryboard instantiateViewControllerWithIdentifier:@"listofassets"];
        }
        UIViewController *more = [mainstoryboard instantiateViewControllerWithIdentifier:@"more"];
        UIViewController *listroutes = [mainstoryboard instantiateViewControllerWithIdentifier:@"listroutes"];
        UINavigationController *rootvc = [self navigationController];
        NSMutableArray *controllers = [[rootvc viewControllers] mutableCopy];
        [controllers removeAllObjects];
        UIViewController *listofassets = [mainstoryboard instantiateViewControllerWithIdentifier:@"projectslist"];
        if(grid == 1){
            listofassets = [mainstoryboard instantiateViewControllerWithIdentifier:@"gridvc"];
        }else{
            listofassets = [mainstoryboard instantiateViewControllerWithIdentifier:@"projectslist"];
        }
        [controllers addObject:listofassets];
        [controllers addObject:more];
        [controllers addObject:listroutes];
        [prefs setObject:tempArray forKey:@"temp"];
        [prefs setObject:imagearray forKey:@"image"];
        [prefs setObject:captionArray forKey:@"caption"];
        [prefs setInteger:submitteddonthide forKey:@"transitdone"];
        //self.navigationController.hidesBarsOnTap = NO;
        //self.navigationController.hidesBarsOnSwipe = NO;
        //self.navigationController.hidesBarsWhenVerticallyCompact = NO;
        NSLog(@"add survey Nib name %@ %@ %@",[[self.navigationController.viewControllers lastObject]restorationIdentifier], tempArray, captionArray);
        NSString *restorationID = [[self.navigationController.viewControllers lastObject]restorationIdentifier];
        NSString *previousrestorationID = [[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2]restorationIdentifier];
        if([restorationID isEqualToString:@"addnewroute"] && ![previousrestorationID isEqualToString:@"listroutes"]){
        [self performSegueWithIdentifier:@"addthisroute" sender:nil];
        }else{
            [prefs setObject:tempArray forKey:@"temp"];
            [prefs setObject:imagearray forKey:@"image"];
            [prefs setObject:captionArray forKey:@"caption"];
            [prefs setInteger:submitteddonthide forKey:@"transitdone"];
            [self.navigationController popViewControllerAnimated:YES];
        }
        //[self.navigationController setViewControllers:controllers animated:YES];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please enter atleast one route" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
        
        //[alert show];
        [self maketoast:@"Please enter at least one route" withbackground:[UIColor blackColor] withdelay:4.5];
        //[self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:1.0f];
    }
    
 
}
- (IBAction)backbarbtn:(id)sender {
    [self goback:nil];
}

- (IBAction)goback:(id)sender {
    if (goback==0) {
        //[self performSegueWithIdentifier:@"gobackfromtransit" sender:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        self.collectionView.hidden=NO;
        
        [[self.view viewWithTag:1000] setHidden:NO];
        [[self.view viewWithTag:1001] setHidden:NO];
        [[self.view viewWithTag:1002] setHidden:NO];
        [[self.view viewWithTag:1003] setHidden:NO];
        [[self.view viewWithTag:2000] setHidden:NO];
        [[self.view viewWithTag:2001] setHidden:NO];
        [[self.view viewWithTag:2002] setHidden:NO];
        [self.gtitle setHidden:NO];
        vv.hidden=YES;
        self.submitbtn.hidden=NO;
        [self.routescore resignFirstResponder];
        [self.howmany resignFirstResponder];
        self.routescore.hidden=NO;
        self.milabel.hidden=NO;
        myImageView.hidden=NO;
        self.surveydone.hidden=NO;
        self.cardone.hidden=YES;
        routescore.text=@"";
        [self.howfar setText:@"How far did you travel?"];
        goback=0;
    }
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
       return YES;
}








- (IBAction)closetransit:(id)sender {

    if([compare isEqualToArray:tempArray]){
    //[self performSegueWithIdentifier:@"gobackfromtransit" sender:nil];
        NSString *restorationID = [[self.navigationController.viewControllers lastObject]restorationIdentifier];        
        NSString *previousrestorationID = [[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2]restorationIdentifier];
        if([restorationID isEqualToString:@"addnewroute"] && ![previousrestorationID isEqualToString:@"listroutes"]){
            [self performSegueWithIdentifier:@"addthisroute" sender:nil];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else{
        warning = [[UIAlertView alloc] initWithTitle:@"Changes made will be lost"
                                             message:@"Are you sure about exit ?"
                                            delegate:self
                                   cancelButtonTitle:@"No"
                                   otherButtonTitles:@"Yes", nil];
        warning.tag=2;
        [warning show];
    }
    
    

}

- (IBAction)closethesurvey:(id)sender {
    [routescore resignFirstResponder];
    goback=0;
        self.submitbtn.hidden=NO;
        self.vv.hidden=YES;
      //  self.vv.backgroundColor=[UIColor grayColor];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.01];
        [UIView setAnimationBeginsFromCurrentState:YES];
    border1.hidden=NO;
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
        if([tempArray count]==2){
            
            flow.sectionInset=UIEdgeInsetsMake(90 , 200, 0, 65);
        }else if([tempArray count]==3){
            flow.sectionInset=UIEdgeInsetsMake(90 , 7, 0, 7);
        }
        else if([tempArray count]==4){
    
            flow.sectionInset=UIEdgeInsetsMake(90 , 7, 0, 7);
    
        }
        else{
            flow.sectionInset=UIEdgeInsetsMake(90 , 250, 0, 0);
        }
            
    }
    else{
    
        if([tempArray count]==2){
            flow.sectionInset = UIEdgeInsetsMake(45, 45, 0, 0);
        }else if([tempArray count]==3){
            flow.sectionInset = UIEdgeInsetsMake(45,4,0,0);
        }
        else if([tempArray count]==4){
            flow.sectionInset = UIEdgeInsetsMake(45,5,0,0);
        }
        else{
            flow.sectionInset = UIEdgeInsetsMake(45,90,0,0);
            
        }
    }
    if(width==375 && height==667){
            if([tempArray count]==1){
                line1.hidden=NO;
                line2.hidden=YES;
                line3.hidden=YES;
                line1.frame = CGRectMake(170, 124, 138.31, 0);
                
                border1.frame = CGRectMake(186, 90,lbl.bounds.size.width, lbl.bounds.size.height);
                border1.frame = CGRectMake(186, 77,lbl.bounds.size.width, lbl.bounds.size.height);
            }
            if([tempArray count]==2){
                line3.hidden=YES;
                line2.hidden=NO;
                line1.hidden=NO;
                line1.frame = CGRectMake(123, 124, 138.31, 0);
                line2.frame = CGRectMake(215, 124, 138.31, 0);
                border1.frame = CGRectMake(186, 90,lbl.bounds.size.width, lbl.bounds.size.height);
                border1.frame = CGRectMake(230, 77,lbl.bounds.size.width, lbl.bounds.size.height);
            }
            if([tempArray count]==3){
                line3.hidden=NO;
                line2.hidden=NO;
                line1.hidden=NO;
                line3.frame = CGRectMake(270, 124, 138.31, 0);
                line2.frame = CGRectMake(178, 124, 138.31, 0);
                line1.frame = CGRectMake(86, 124, 138.31, 0);
                border1.frame = CGRectMake(220, 90,lbl.bounds.size.width, lbl.bounds.size.height);
                border1.frame = CGRectMake(284, 77,lbl.bounds.size.width, lbl.bounds.size.height);
            }
            if([tempArray count]==4){
                line3.hidden=NO;
                line2.hidden=NO;
                line1.hidden=NO;
                line3.frame = CGRectMake(270, 124, 138.31, 0);
                line2.frame = CGRectMake(178, 124, 138.31, 0);
                line1.frame = CGRectMake(86, 124, 138.31, 0);
                border1.frame = CGRectMake(220, 73,lbl.bounds.size.width, lbl.bounds.size.height);
                border1.frame = CGRectMake(282, 77,lbl.bounds.size.width, lbl.bounds.size.height);
            }
        }
        
        else if(width==414 && height==736){
            if([tempArray count]==1){
                line1.hidden=NO;
                line2.hidden=YES;
                line3.hidden=YES;
                line1.frame = CGRectMake(187, 130, 138.31, 0);
                
                border1.frame = CGRectMake(196, 87,lbl.bounds.size.width, lbl.bounds.size.height);
                border1.frame = CGRectMake(196, 80,lbl.bounds.size.width, lbl.bounds.size.height);
            }
            if([tempArray count]==2){
                line2.hidden=NO;
                line3.hidden=YES;
                line1.hidden=NO;
                line2.frame = CGRectMake(250, 130, 138.31, 0);
                line1.frame = CGRectMake(152, 130, 138.31, 0);
                border1.frame = CGRectMake(186, 87,lbl.bounds.size.width, lbl.bounds.size.height);
                border1.frame = CGRectMake(259, 80,lbl.bounds.size.width, lbl.bounds.size.height);
            }
            if([tempArray count]==3){
                line3.hidden=NO;
                line1.hidden=NO;
                line2.hidden=NO;
                line2.frame = CGRectMake(192, 130, 138.31, 0);
                line1.frame = CGRectMake(95, 130, 138.31, 0);
                line3.frame = CGRectMake(289, 130, 138.31, 0);
                border1.frame = CGRectMake(225, 87,lbl.bounds.size.width, lbl.bounds.size.height);
                border1.frame = CGRectMake(300, 80,lbl.bounds.size.width, lbl.bounds.size.height);
            }
            if([tempArray count]==4){
                line3.hidden=NO;
                line1.hidden=NO;
                line2.hidden=NO;
                line2.frame = CGRectMake(192, 130, 138.31, 0);
                line1.frame = CGRectMake(95, 130, 138.31, 0);
                line3.frame = CGRectMake(289, 130, 138.31, 0);
                border1.frame = CGRectMake(225, 87,lbl.bounds.size.width, lbl.bounds.size.height);
                border1.frame = CGRectMake(300, 80,lbl.bounds.size.width, lbl.bounds.size.height);
            }
        }
        
        else if(width==320 && height==568){
            
            if([tempArray count]==1){
                line1.hidden=NO;
                line2.hidden=YES;
                line3.hidden=YES;
                line1.frame = CGRectMake(160, 110, 138.31, 0);
                border1.frame = CGRectMake(172, 64,lbl.bounds.size.width, lbl.bounds.size.height);
                border1.frame = CGRectMake(172, 62.5,lbl.bounds.size.width, lbl.bounds.size.height);
            }
            if([tempArray count]==2){
                line3.hidden=YES;
                line1.hidden=NO;
                line2.hidden=NO;
                line1.frame = CGRectMake(115, 110, 138.31, 0);
                line2.frame = CGRectMake(194, 110, 138.31, 0);
                border1.frame = CGRectMake(172, 74,lbl.bounds.size.width, lbl.bounds.size.height);
                border1.frame = CGRectMake(204, 62.5,lbl.bounds.size.width, lbl.bounds.size.height);
            }
            if([tempArray count]==3){
                line3.hidden=NO;
                line1.hidden=NO;
                line2.hidden=NO;
                line1.frame = CGRectMake(77, 110, 138.31, 0);
                line2.frame = CGRectMake(157, 110, 138.31, 0);
                line3.frame = CGRectMake(237, 110, 138.31, 0);
                border1.frame = CGRectMake(204, 74,lbl.bounds.size.width, lbl.bounds.size.height);
                border1.frame = CGRectMake(246, 62.5,lbl.bounds.size.width, lbl.bounds.size.height);
            }
            if([tempArray count]==4){
                line3.hidden=NO;
                line1.hidden=NO;
                line2.hidden=NO;
                line1.frame = CGRectMake(77, 110, 138.31, 0);
                line2.frame = CGRectMake(157, 110, 138.31, 0);
                line3.frame = CGRectMake(237, 110, 138.31, 0);
                border1.frame = CGRectMake(204, 74,lbl.bounds.size.width, lbl.bounds.size.height);
                border1.frame = CGRectMake(246, 62.5,lbl.bounds.size.width, lbl.bounds.size.height);
            }
        }
        else{
                if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
                    if([tempArray count]==1){
                        line1.hidden=NO;
                        line2.hidden=YES;
                        line3.hidden=YES;
                        line1.frame = CGRectMake(0.426 * width, 0.164 * height, 1.432 * width, 0);
                        border1.frame = CGRectMake(172, 50,lbl.bounds.size.width, lbl.bounds.size.height);
                        border1.frame = CGRectMake(0.439 * width, 0.105 * height,lbl.bounds.size.width, lbl.bounds.size.height);
                    }
                    if([tempArray count]==2){
                        line2.hidden=NO;
                        line3.hidden=YES;
                        line1.hidden=NO;
                        line1.frame = CGRectMake(300, 180, 138.31, 0);
                        line2.frame = CGRectMake(411, 180, 138.31, 0);
                        border1.frame = CGRectMake(172, 56,lbl.bounds.size.width, lbl.bounds.size.height);
                        border1.frame = CGRectMake(420, 115,lbl.bounds.size.width, lbl.bounds.size.height);
                    }
                    if([tempArray count]==3){
                        line3.hidden=NO;
                        line1.hidden=NO;
                        line2.hidden=NO;
                        line3.frame = CGRectMake(472, 180, 138.31, 0);
                        line2.frame = CGRectMake(360, 180, 138.31, 0);
                        line1.frame = CGRectMake(250, 180, 138.31, 0);
                        border1.frame = CGRectMake(204, 56,lbl.bounds.size.width, lbl.bounds.size.height);
                        border1.frame = CGRectMake(479, 115,lbl.bounds.size.width, lbl.bounds.size.height);
                    }
                    if([tempArray count]==4){
                        line3.hidden=NO;
                        line2.hidden=NO;
                        line1.hidden=NO;
                        line3.frame = CGRectMake(472, 180, 138.31, 0);
                        line2.frame = CGRectMake(360, 180, 138.31, 0);
                        line1.frame = CGRectMake(250, 180, 138.31, 0);
                        border1.frame = CGRectMake(204, 56,lbl.bounds.size.width, lbl.bounds.size.height);
                        border1.frame = CGRectMake(479, 115,lbl.bounds.size.width, lbl.bounds.size.height);
                    }
                }else{
            
                    if([tempArray count]==1){
                        line1.hidden=NO;
                        line2.hidden=YES;
                        line3.hidden=YES;
                        line1.frame = CGRectMake(160, 102, 138.31, 0);
                        border1.frame = CGRectMake(172, 58,lbl.bounds.size.width, lbl.bounds.size.height);
                        border1.frame = CGRectMake(172, 49,lbl.bounds.size.width, lbl.bounds.size.height);
                        
                        
                        
                    }
                    
                    if([tempArray count]==2){
                        line1.hidden=NO;
                        line2.hidden=NO;
                        line3.hidden=YES;
                        line1.frame = CGRectMake(115, 102, 138.31, 0);
                        line2.frame = CGRectMake(193, 102, 138.31, 0);
                        border1.frame = CGRectMake(172, 58,lbl.bounds.size.width, lbl.bounds.size.height);
                        border1.frame = CGRectMake(204, 49,lbl.bounds.size.width, lbl.bounds.size.height);
                    }
                    
                    if([tempArray count]==3){
                        line1.hidden=NO;
                        line2.hidden=NO;
                        line3.hidden=NO;
                        line3.frame = CGRectMake(235, 102, 138.31, 0);
                        line2.frame = CGRectMake(156, 102, 138.31, 0);
                        line1.frame = CGRectMake(75, 102, 138.31, 0);
                        border1.frame = CGRectMake(204, 58,lbl.bounds.size.width, lbl.bounds.size.height);
                        border1.frame = CGRectMake(246, 49,lbl.bounds.size.width, lbl.bounds.size.height);
                    }
                    if([tempArray count]==4){
                        line1.hidden=NO;
                        line2.hidden=NO;
                        line3.hidden=NO;
                        line3.frame = CGRectMake(235, 102, 138.31, 0);
                        line2.frame = CGRectMake(156, 102, 138.31, 0);
                        line1.frame = CGRectMake(75, 102, 138.31, 0);
                        border1.frame = CGRectMake(204, 58,lbl.bounds.size.width, lbl.bounds.size.height);
                        border1.frame = CGRectMake(246, 49,lbl.bounds.size.width, lbl.bounds.size.height);
                    }
                }
            
            
        }
        [UIView commitAnimations];
        
        self.collectionView.hidden=NO;
        mi = NO;
    if(!mi){
        [_milesbutton setTitle:@"Mi" forState:UIControlStateNormal];
        mi=NO;
    }
    else{
        [_milesbutton setTitle:@"Km" forState:UIControlStateNormal];
        mi=YES;
    }
        [[self.view viewWithTag:1000] setHidden:NO];
        [[self.view viewWithTag:1001] setHidden:NO];
        [[self.view viewWithTag:1002] setHidden:NO];
        [[self.view viewWithTag:1003] setHidden:NO];
        [[self.view viewWithTag:2000] setHidden:NO];
        [[self.view viewWithTag:2001] setHidden:NO];
        [[self.view viewWithTag:2002] setHidden:NO];
        [self.gtitle setHidden:NO];
        self.routescore.hidden=NO;
        self.milabel.hidden=NO;
        myImageView.hidden=NO;
        self.surveydone.hidden=NO;
        self.cardone.hidden=YES;
        routescore.text=@"";
        [self.howfar setText:@"How far did you travel?"];
        i=0;
        self.surveyclose.hidden=YES;
        self.close.hidden=NO;

}
- (IBAction)mileclick:(id)sender {
    if(mi){
        [_milesbutton setTitle:@"Mi" forState:UIControlStateNormal];
        mi=NO;
    }
    else{
        [_milesbutton setTitle:@"Km" forState:UIControlStateNormal];
        mi=YES;
    }

}
@end

@implementation UITextField (DisableCopyPasteSelect)

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    return NO;
    return [super canPerformAction:action withSender:sender];
}

@end
