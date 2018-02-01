//
//  CustomCollectionViewCells.h
//  multiple
//
//  Created by Group10 on 05/05/15.
//  Copyright (c) 2015 Group10. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCollectionViewCells : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UILabel *lbl;
@property (strong, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UIButton *bt;

@end
