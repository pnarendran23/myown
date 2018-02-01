//
//  CustomCollectionViewCells.m
//  multiple
//
//  Created by Group10 on 05/05/15.
//  Copyright (c) 2015 Group10. All rights reserved.
//

#import "CustomCollectionViewCells.h"

@implementation CustomCollectionViewCells

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    self.layer.borderColor = [[UIColor colorWithRed:180.0/255.0 green:180.0/255.0 blue:180.0/255.0 alpha:1.0] CGColor];
    self.layer.borderWidth = 1.0;
}

@end
