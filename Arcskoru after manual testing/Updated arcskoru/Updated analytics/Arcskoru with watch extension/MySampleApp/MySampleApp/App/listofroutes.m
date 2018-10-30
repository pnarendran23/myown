//
//  listofbuildings.m
//  Occupant survey
//
//  Created by Group X on 06/07/15.
//  Copyright (c) 2015 usgbc. All rights reserved.
//

#import "listofroutes.h"

@implementation listofroutes

-(void)awakeFromNib{
    [super awakeFromNib];
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        // Initialization code
        _v = [[NSBundle mainBundle] loadNibNamed:@"CustomCollectionViews" owner:self options:nil][0];
        _v.frame = self.contentView.bounds;
        [self.contentView addSubview:_v];        
        _mibutton=_v.but;
    }
    return self;
}

- (void)setCollectionData:(NSMutableArray *)collectionData{
    [_v setCollectionData:collectionData];
}
- (void)setimageData:(NSArray *)imageData{
    [_v setimageData:imageData];
}

-(void)tagnum:(int)tag{
    [_v tagnum:tag];
    NSLog(@"%d",tag);
}

- (void)setlabelData:(NSString *)labelData{
    [_v setlabelData:labelData];
}

- (void)accessory:(NSString *)tickdata{
    [_v accessory:tickdata];
}


-(void)dashlineadjust{
    [_v dashlineadjust];
}
 

@end
