//
//  CustomCollectionViews.m
//  multiple
//
//  Created by Group10 on 05/05/15.
//  Copyright (c) 2015 Group10. All rights reserved.
//

#import "CustomCollectionViews.h"
#import "CustomCollectionViewCells.h"

@implementation CustomCollectionViews
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
   self.but.backgroundColor=[UIColor colorWithRed:0.576  green:0.568 blue:0.513 alpha:1];
    

        self.seg.selectedSegmentIndex=-1;
   flow = [[UICollectionViewFlowLayout alloc] init];
    
    if([self.collectionData count]==2){
        flow.sectionInset = UIEdgeInsetsMake(45, 45, 0, 0);
        
        
    }else if([self.collectionData count]==3){
        flow.sectionInset = UIEdgeInsetsMake(45,4,0,0);
        
        
    }
    else if([self.collectionData count]==4){
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
    width=[UIScreen mainScreen].bounds.size.width;
    height=[UIScreen mainScreen].bounds.size.height;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.itemSize = CGSizeMake(7.0, 91.0);
    [self.collectionview setCollectionViewLayout:flowLayout];
    int space = self.collectionview.frame.size.width;
    space = space - 130 *2;
    space = space/3;
    flow = [[UICollectionViewFlowLayout alloc] init];
    flow.minimumInteritemSpacing = space/2;
    flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
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
    flow.minimumInteritemSpacing = 0.114 * width;
    flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flow.itemSize = CGSizeMake(0.212 * width, 0.145 * height);
    [self.collectionview setCollectionViewLayout:flow];
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
            lbl.frame=CGRectMake(1, 1, 100, 125);
        }
        else{
            lbl.frame=CGRectMake(1, 1, 70, 91);
        }
    }
    border1 = [CAShapeLayer layer];
    border1.path = [UIBezierPath bezierPathWithRect:lbl.bounds].CGPath;
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
    //[self.layer addSublayer:line1];
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
    //[self.layer addSublayer:line2];
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
    //[self.layer addSublayer:line3];
    line3.hidden=YES;
    border1.strokeColor=[UIColor colorWithRed:0.576  green:0.568 blue:0.513 alpha:1].CGColor;
    border1.fillColor = nil;
    border1.cornerRadius=5;
    border1.masksToBounds = YES;
    border1.lineDashPattern = @[@8.5, @5];
    //[lbl.layer addSublayer:border1];
    //[self addSubview:lbl];
    [_collectionview registerNib:[UINib nibWithNibName:@"CustomCollectionViewCells" bundle:nil] forCellWithReuseIdentifier:@"cvCells"];
 
}

-(void)dashlineadjust{

    if(width==375 && height==667){
        if([self.collectionData count]==1){
            line1.hidden=NO;
            line2.hidden=YES;
            line3.hidden=YES;
            line1.frame = CGRectMake(170, 120, 138.31, 0);
            border1.frame = CGRectMake(186, 90,lbl.bounds.size.width, lbl.bounds.size.height);
            border1.frame = CGRectMake(186, 73,lbl.bounds.size.width, lbl.bounds.size.height);
        }
        
        if([self.collectionData count]==2){
            line1.frame = CGRectMake(123, 120, 138.31, 0);
            line2.hidden=NO;
            line1.hidden=NO;
            line3.hidden=YES;
            line2.frame = CGRectMake(215, 120, 138.31, 0);
            border1.frame = CGRectMake(186, 73,lbl.bounds.size.width, lbl.bounds.size.height);
            border1.frame = CGRectMake(230, 73,lbl.bounds.size.width, lbl.bounds.size.height);
        }
        
        if([self.collectionData count]==3){
            line3.hidden=NO;
            line2.hidden=NO;
            line1.hidden=NO;
            line3.frame = CGRectMake(270, 120, 138.31, 0);
            line2.frame = CGRectMake(178, 120, 138.31, 0);
            line1.frame = CGRectMake(86, 120, 138.31, 0);
            border1.frame = CGRectMake(220, 73,lbl.bounds.size.width, lbl.bounds.size.height);
            border1.frame = CGRectMake(284, 73,lbl.bounds.size.width, lbl.bounds.size.height);
        }
        
        if([self.collectionData count]==4){
            line3.hidden=NO;
            line2.hidden=NO;
            line1.hidden=NO;
            line3.frame = CGRectMake(270, 120, 138.31, 0);
            line2.frame = CGRectMake(178, 120, 138.31, 0);
            line1.frame = CGRectMake(86, 120, 138.31, 0);
            border1.frame = CGRectMake(220, 73,lbl.bounds.size.width, lbl.bounds.size.height);
            border1.frame = CGRectMake(282, 73,lbl.bounds.size.width, lbl.bounds.size.height);
        }
    }
    
    else if(width==414 && height==736){
        if([self.collectionData count]==1){
            line1.hidden=NO;
            line2.hidden=YES;
            line3.hidden=YES;
            line1.frame = CGRectMake(187, 120, 138.31, 0);
            border1.frame = CGRectMake(196, 87,lbl.bounds.size.width, lbl.bounds.size.height);
            border1.frame = CGRectMake(196, 63,lbl.bounds.size.width, lbl.bounds.size.height);
        }
        
        else if([self.collectionData count]==2){
            line2.hidden=NO;
            line3.hidden=YES;
            line1.hidden=NO;
            line2.frame = CGRectMake(250, 120, 138.31, 0);
            line1.frame = CGRectMake(152, 120, 138.31, 0);
            border1.frame = CGRectMake(186, 87,lbl.bounds.size.width, lbl.bounds.size.height);
            border1.frame = CGRectMake(259, 63,lbl.bounds.size.width, lbl.bounds.size.height);
        }
        
        else if([self.collectionData count]==3){
            line3.hidden=NO;
            line1.hidden=NO;
            line2.hidden=NO;
            line2.frame = CGRectMake(192, 120, 138.31, 0);
            line1.frame = CGRectMake(95, 120, 138.31, 0);
            line3.frame = CGRectMake(289, 120, 138.31, 0);
            border1.frame = CGRectMake(225, 87,lbl.bounds.size.width, lbl.bounds.size.height);
            border1.frame = CGRectMake(300, 63,lbl.bounds.size.width, lbl.bounds.size.height);
        }
        else if([self.collectionData count]==4){
            line3.hidden=NO;
            line1.hidden=NO;
            line2.hidden=NO;
            line2.frame = CGRectMake(192, 120, 138.31, 0);
            line1.frame = CGRectMake(95, 120, 138.31, 0);
            line3.frame = CGRectMake(289, 120, 138.31, 0);
            border1.frame = CGRectMake(225, 87,lbl.bounds.size.width, lbl.bounds.size.height);
            border1.frame = CGRectMake(300, 63,lbl.bounds.size.width, lbl.bounds.size.height);
        }
    }
    
    else if(width==320 && height==568){
        
        if([self.collectionData count]==1){
            line1.hidden=NO;
            line2.hidden=YES;
            line3.hidden=YES;
            line1.frame = CGRectMake(160, 120, 138.31, 0);
            border1.frame = CGRectMake(172, 74,lbl.bounds.size.width, lbl.bounds.size.height);
            border1.frame = CGRectMake(172, 74,lbl.bounds.size.width, lbl.bounds.size.height);
        }
        
        if([self.collectionData count]==2){
            line2.hidden=NO;
            line1.hidden=NO;
            line3.hidden=YES;
            line1.frame = CGRectMake(115, 120, 138.31, 0);
            line2.frame = CGRectMake(194, 120, 138.31, 0);
            border1.frame = CGRectMake(172, 74,lbl.bounds.size.width, lbl.bounds.size.height);
            border1.frame = CGRectMake(204, 74,lbl.bounds.size.width, lbl.bounds.size.height);
        }
        
        if([self.collectionData count]==3){
            line3.hidden=NO;
            line1.hidden=NO;
            line2.hidden=NO;
            line1.frame = CGRectMake(77, 120, 138.31, 0);
            line2.frame = CGRectMake(157, 120, 138.31, 0);
            line3.frame = CGRectMake(237, 120, 138.31, 0);
            border1.frame = CGRectMake(204, 74,lbl.bounds.size.width, lbl.bounds.size.height);
            border1.frame = CGRectMake(248, 74,lbl.bounds.size.width, lbl.bounds.size.height);
        }
        if([self.collectionData count]==4){
            line3.hidden=NO;
            line1.hidden=NO;
            line2.hidden=NO;
            line1.frame = CGRectMake(77, 120, 138.31, 0);
            line2.frame = CGRectMake(157, 120, 138.31, 0);
            line3.frame = CGRectMake(237, 120, 138.31, 0);
            border1.frame = CGRectMake(204, 74,lbl.bounds.size.width, lbl.bounds.size.height);
            border1.frame = CGRectMake(246, 73,lbl.bounds.size.width, lbl.bounds.size.height);
        }
    }
    else{
        
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
            if([self.collectionData count]==1){
                line1.hidden=NO;
                line3.hidden=YES;
                line2.hidden=YES;
                line1.frame = CGRectMake(350, 120, 138.31, 0);
                border1.frame = CGRectMake(172, 50,lbl.bounds.size.width, lbl.bounds.size.height);
                border1.frame = CGRectMake(360, 57,lbl.bounds.size.width, lbl.bounds.size.height);
            }
            
            if([self.collectionData count]==2){
                line1.hidden=NO;
                line2.hidden=NO;
                line3.hidden=YES;
                line1.frame = CGRectMake(300, 120, 138.31, 0);
                line2.frame = CGRectMake(411, 120, 138.31, 0);
                border1.frame = CGRectMake(172, 56,lbl.bounds.size.width, lbl.bounds.size.height);
                border1.frame = CGRectMake(420, 57,lbl.bounds.size.width, lbl.bounds.size.height);
            }
            
            if([self.collectionData count]==3){
                line3.hidden=NO;
                line1.hidden=NO;
                line2.hidden=NO;
                line3.frame = CGRectMake(472, 120, 138.31, 0);
                line2.frame = CGRectMake(360, 120, 138.31, 0);
                line1.frame = CGRectMake(250, 120, 138.31, 0);
                border1.frame = CGRectMake(204, 56,lbl.bounds.size.width, lbl.bounds.size.height);
                border1.frame = CGRectMake(479, 57,lbl.bounds.size.width, lbl.bounds.size.height);
            }
            if([self.collectionData count]==4){
                line3.hidden=NO;
                line2.hidden=NO;
                line1.hidden=NO;
                line3.frame = CGRectMake(472, 120, 138.31, 0);
                line2.frame = CGRectMake(360, 120, 138.31, 0);
                line1.frame = CGRectMake(250, 120, 138.31, 0);
                border1.frame = CGRectMake(204, 56,lbl.bounds.size.width, lbl.bounds.size.height);
                border1.frame = CGRectMake(479, 57,lbl.bounds.size.width, lbl.bounds.size.height);
            }
        }
        else{
            if([self.collectionData count]==1){
                line1.hidden=NO;
                line3.hidden=YES;
                line2.hidden=YES;
                line1.frame = CGRectMake(160, 115, 138.31, 0);
                border1.frame = CGRectMake(172, 58,lbl.bounds.size.width, lbl.bounds.size.height);
                border1.frame = CGRectMake(172, 73,lbl.bounds.size.width, lbl.bounds.size.height);
            }
            
            else if([self.collectionData count]==2){
                line2.hidden=NO;
                line3.hidden=YES;
                line1.hidden=NO;
                line1.frame = CGRectMake(115, 115, 138.31, 0);
                line2.frame = CGRectMake(193, 115, 138.31, 0);
                border1.frame = CGRectMake(204, 58,lbl.bounds.size.width, lbl.bounds.size.height);
                border1.frame = CGRectMake(204, 73,lbl.bounds.size.width, lbl.bounds.size.height);
            }
            
            else if([self.collectionData count]==3){
                line3.hidden=NO;
                line1.hidden=NO;
                line2.hidden=NO;
                line3.frame = CGRectMake(235, 115, 138.31, 0);
                line2.frame = CGRectMake(156, 115, 138.31, 0);
                line1.frame = CGRectMake(75, 115, 138.31, 0);
                border1.frame = CGRectMake(246, 58,lbl.bounds.size.width, lbl.bounds.size.height);
                border1.frame = CGRectMake(246, 73,lbl.bounds.size.width, lbl.bounds.size.height);
            }
            else if([self.collectionData count]==4){
                line3.hidden=NO;
                line1.hidden=NO;
                line2.hidden=NO;
                line3.frame = CGRectMake(235, 115, 138.31, 0);
                line2.frame = CGRectMake(156, 115, 138.31, 0);
                line1.frame = CGRectMake(75, 115, 138.31, 0);
                border1.frame = CGRectMake(246, 58,lbl.bounds.size.width, lbl.bounds.size.height);
                border1.frame = CGRectMake(246, 73,lbl.bounds.size.width, lbl.bounds.size.height);
            }
        }
        
    }
 
}



#pragma mark - Getter/Setter overrides
- (void)setCollectionData:(NSArray *)collectionData{
    
    _collectionData = collectionData;
    [_collectionview setContentOffset:CGPointZero animated:NO];
    [_collectionview reloadData];
}

- (void)setlabelData:(NSString *)labelData {
    _labeldata = labelData;
    [_collectionview setContentOffset:CGPointZero animated:NO];
}


#pragma mark - UICollectionViewDataSource methods
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.collectionData count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCollectionViewCells *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cvCells" forIndexPath:indexPath];

    
    cell.layer.cornerRadius=5.0;
    cell.layer.masksToBounds=YES;
    self.tick.hidden=[_tickdata intValue];
    self.rowlabel.text=_labeldata;
    cell.lbl.text=[NSString stringWithFormat:@"%.1f",[[self.collectionData objectAtIndex:indexPath.row]doubleValue]];
    cell.img.image=[UIImage imageNamed:[self.imagedata objectAtIndex:indexPath.row]];
    self.but.tag=[_tags intValue];
    //[self dashlineadjust];
    return cell;
}



- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
   /* if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
        if([self.collectionData count]==2){
            return UIEdgeInsetsMake(20 , 200, 0, 65);
        }else if([self.collectionData count]==3){
            return UIEdgeInsetsMake(20 , 150, 0, 7);
        }
        else if([self.collectionData count]==4){
            return UIEdgeInsetsMake(20 , 150, 0, 7);
        }
        else{
            return UIEdgeInsetsMake(20 , 250, 0, 0);
        }
    }else{
        if(width==414 && height==736){
            if([self.collectionData count]==2){
                return UIEdgeInsetsMake(15 , 65, 0, 65);
            }else if([self.collectionData count]==3){
                return UIEdgeInsetsMake(15 , 7, 0, 7);
            }
            else if([self.collectionData count]==4){
                return UIEdgeInsetsMake(15 , 7, 0, 7);
            }
            else{
                return UIEdgeInsetsMake(15 , 100, 0, 100);
            }
        }
        else{
            
            if([self.collectionData count]==2){
                return UIEdgeInsetsMake(20 , 45, 0, 45);
            }else if([self.collectionData count]==3){
                return UIEdgeInsetsMake(20 , 7, 0, 7);
            }
            else if([self.collectionData count]==4){
                return UIEdgeInsetsMake(20 , 7, 0, 7);
            }
            else{
                return UIEdgeInsetsMake(20 , 90, 0, 90);
            }
        }
    }
    return UIEdgeInsetsMake(65, 0, 0, 0);*/
    NSInteger numberOfCells = self.frame.size.width / flow.itemSize.width;
    NSInteger edgeInsets = (self.frame.size.width - (numberOfCells * flow.itemSize.width)) / (numberOfCells + 1);
    return UIEdgeInsetsMake(0, edgeInsets, 0, edgeInsets);
}

- (void)setimageData:(NSMutableArray *)imageData{
    _imagedata = imageData;
    [_collectionview setContentOffset:CGPointZero animated:NO];    
    [_collectionview reloadData];
}

-(void)accessory:(NSString *)tickdata{
    _tickdata = tickdata;
    [_collectionview setContentOffset:CGPointZero animated:NO];
    [_collectionview reloadData];
}

-(void)tagnum:(int)tag{
    [_but setTag:tag];
}

- (IBAction)editordelete:(id)sender {
    UIButton *b=(UIButton *)sender;
    NSLog(@"Tag is %d ",(int)b.tag);
}


@end
