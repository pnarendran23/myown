//
//  CustomCollectionViewCell.h
//  connection
//
//  Created by Group10 on 20/03/15.
//  Copyright (c) 2015 Group10. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCollectionViewCell : UICollectionViewCell{
    int width;
    int height;
}
@property (strong, nonatomic) IBOutlet UILabel *cellabel;
@property (strong, nonatomic) IBOutlet UIImageView *cellimage;


@end
