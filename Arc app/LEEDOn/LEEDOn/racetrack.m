//
//  racetrack.m
//
//  Code generated using QuartzCode 1.33.2 on 10/07/15.
//  www.quartzcodeapp.com
//

#import "racetrack.h"
#import "QCMethod.h"

@interface racetrack ()

@property (nonatomic, strong) NSMutableDictionary * layers;


@end

@implementation racetrack

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupProperties];
        [self setupLayers];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupProperties];
        [self setupLayers];
    }
    return self;
}



- (void)setupProperties{
    self.layers = [NSMutableDictionary dictionary];
    
}

- (void)setupLayers{
    [ti1 invalidate];
    [ti2 invalidate];
    [ti3 invalidate];
    [ti4 invalidate];
    [ti5 invalidate];
    [t1 invalidate];
    [t2 invalidate];
    [t3 invalidate];
    [t4 invalidate];
    [t5 invalidate];
    [outer invalidate];
    [outer1 invalidate];
    [middle invalidate];
    [middle1 invalidate];
    [inner invalidate];
    [inner1 invalidate];
    tempenergy=0;
    temphuman=0;
    temptransport=0;
    tempwaste=0;
    tempwater=0;
    inneractual=0;
    middleactual=0;
    actual=0;
    outeractual=0;
    innerscoreforiphone.string=@"0";
    innerscoreforipad.string=@"0";
    middlescoreforiphone.string=@"0";
    middlescoreforipad.string=@"0";
    outerscoreforiphone.string=@"0";
    outerscoreforipad.string=@"0";
    
    prefs=[NSUserDefaults standardUserDefaults];
    menergy=[[prefs objectForKey:@"menergy"] intValue];
    mwater=[[prefs objectForKey:@"mwater"] intValue];
    mwaste=[[prefs objectForKey:@"mwaste"] intValue];
    mtransport=[[prefs objectForKey:@"mtransport"]intValue ];
    mhuman=[[prefs objectForKey:@"mhuman"] intValue];
    base=[[prefs objectForKey:@"base"] intValue];
    energy=[[prefs objectForKey:@"energy"] intValue];
    water=[[prefs objectForKey:@"water"] intValue];
    waste=[[prefs objectForKey:@"waste"] intValue];
    transport=[[prefs objectForKey:@"transport"]intValue ];
    human=[[prefs objectForKey:@"human"] intValue];
    NSLog(@"%d %d %d %d %d",human,transport,waste,water,energy);
    human = 12;
    transport = 4;
    waste = 5;
    water = 30;
    energy = 20;
    mhuman = 15;
    mtransport = 10;
    mwaste = 8;
    mwater = 33;
    menergy = 25;
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    dict = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults]objectForKey:@"performance_data"]];
    NSDictionary *tempdict = [[NSDictionary alloc] init];
    tempdict = dict[@"scores"];
    NSLog(@"Tempdic %@",tempdict);
    if(tempdict[@"base"] != [NSNull null]){
        base = [tempdict[@"base"] intValue];
    }else{
        base = 0;
    }
    if(tempdict[@"human_experience"] != [NSNull null]){
        human = [tempdict[@"human_experience"] intValue];
    }else{
        human = 0;
    }
    if(tempdict[@"transport"] != [NSNull null]){
        transport = [tempdict[@"transport"] intValue];
    }else{
        transport = 0;
    }
    if(tempdict[@"waste"] != [NSNull null]){
        waste = [tempdict[@"waste"] intValue];
    }else{
        waste = 0;
    }
    if(tempdict[@"water"] != [NSNull null]){
        water = [tempdict[@"water"] intValue];
    }else{
        water = 0;
    }
    if(tempdict[@"energy"] != [NSNull null]){
        energy = [tempdict[@"energy"] intValue];
    }else{
        energy = 0;
    }
    
    tempdict = dict[@"maxima"];
    NSLog(@"Tempdic %@",tempdict);    
    if(tempdict[@"human_experience"] != [NSNull null]){
        mhuman = [tempdict[@"human_experience"] intValue];
    }else{
        mhuman = 0;
    }
    if(tempdict[@"transport"] != [NSNull null]){
        mtransport = [tempdict[@"transport"] intValue];
    }else{
        mtransport = 0;
    }
    if(tempdict[@"waste"] != [NSNull null]){
        mwaste = [tempdict[@"waste"] intValue];
    }else{
        mwaste = 0;
    }
    if(tempdict[@"water"] != [NSNull null]){
        mwater = [tempdict[@"water"] intValue];
    }else{
        mwater = 0;
    }
    if(tempdict[@"energy"] != [NSNull null]){
        menergy = [tempdict[@"energy"] intValue];
    }else{
        menergy = 0;
    }
    
    
    dict = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults]objectForKey:@"comparable_data"]];
    tempdict = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults]objectForKey:@"local_comparable_data"]];
    
    width=[UIScreen mainScreen].bounds.size.width;
    height=[UIScreen mainScreen].bounds.size.height;

    
    row=(int)[prefs integerForKey:@"row"];
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){
        if(row==0){
        CALayer * puckforipad = [CALayer layer];
        puckforipad.frame    = CGRectMake(341.98, 368.57, 87, 87);
        puckforipad.contents = (id)[UIImage imageNamed:@"puck"].CGImage;
        [self.layer addSublayer:puckforipad];
        self.layers[@"puckforipad"] = puckforipad;
        
        CATextLayer * puckscoreforipad = [CATextLayer layer];
        puckscoreforipad.frame           = CGRectMake(354.45, 372.56, 62.06, 61.56);
        puckscoreforipad.contentsScale   = [[UIScreen mainScreen] scale];
            puckscoreforipad.string          = [NSString stringWithFormat:@"%d",energy+water+waste+transport+human+base];
        puckscoreforipad.font            = (__bridge CFTypeRef)@"DINEngschrift";
        puckscoreforipad.fontSize        = 65;
        puckscoreforipad.alignmentMode   = kCAAlignmentCenter;
        puckscoreforipad.foregroundColor = [UIColor whiteColor].CGColor;
        [self.layer addSublayer:puckscoreforipad];
        self.layers[@"puckscoreforipad"] = puckscoreforipad;
        
        CALayer * humangroupforipad = [CALayer layer];
        humangroupforipad.frame = CGRectMake(29.88, 287.53, 469.27, 517.44);
        
        [self.layer addSublayer:humangroupforipad];
        self.layers[@"humangroupforipad"] = humangroupforipad;
        {
            CAShapeLayer * humanbackforipad = [CAShapeLayer layer];
            humanbackforipad.frame       = CGRectMake(55.05, 11.04, 414.22, 228.29);
            humanbackforipad.fillColor   = nil;
            humanbackforipad.strokeColor = [UIColor colorWithRed:0.835 green: 0.835 blue:0.835 alpha:1].CGColor;
            humanbackforipad.lineWidth   = 30;
            humanbackforipad.path        = [self humanbackforipadPath].CGPath;
            [humangroupforipad addSublayer:humanbackforipad];
            self.layers[@"humanbackforipad"] = humanbackforipad;
            
            CATextLayer * humanmaxscoreforipad = [CATextLayer layer];
            humanmaxscoreforipad.frame           = CGRectMake(229.27, 52.71, 23, 30);
            humanmaxscoreforipad.contentsScale   = [[UIScreen mainScreen] scale];
            humanmaxscoreforipad.string          = [NSString stringWithFormat:@"%d",mhuman];
            humanmaxscoreforipad.font            = (__bridge CFTypeRef)@"GothamBook";
            humanmaxscoreforipad.fontSize        = 15;
            humanmaxscoreforipad.alignmentMode   = kCAAlignmentCenter;
            humanmaxscoreforipad.foregroundColor = [UIColor blackColor].CGColor;
            [humangroupforipad addSublayer:humanmaxscoreforipad];
            self.layers[@"humanmaxscoreforipad"] = humanmaxscoreforipad;

            
            if(human>=1){
            CAShapeLayer * humanstartpathforipad = [CAShapeLayer layer];
            humanstartpathforipad.frame       = CGRectMake(59.77, 11.5, 302, 0);
            humanstartpathforipad.fillColor   = nil;
            humanstartpathforipad.strokeColor = [UIColor colorWithRed:0.91 green: 0.604 blue:0.267 alpha:1].CGColor;
            humanstartpathforipad.lineWidth   = 30;
            humanstartpathforipad.path        = [self humanstartpathforipadPath].CGPath;
            [humangroupforipad addSublayer:humanstartpathforipad];
            self.layers[@"humanstartpathforipad"] = humanstartpathforipad;
            }
            CALayer * humanforipad = [CALayer layer];
            humanforipad.frame    = CGRectMake(69.33, 0, 10.54, 23);
            humanforipad.contents = (id)[UIImage imageNamed:@"human"].CGImage;
            [humangroupforipad addSublayer:humanforipad];
            self.layers[@"humanforipad"] = humanforipad;
            CATextLayer * humanlabelforipad = [CATextLayer layer];
            humanlabelforipad.frame           = CGRectMake(83.14, 1, 191.54, 19.86);
            humanlabelforipad.contentsScale   = [[UIScreen mainScreen] scale];
            humanlabelforipad.string          = @"HUMAN EXPERIENCE\n";
            humanlabelforipad.font            = (__bridge CFTypeRef)@"GothamBook";
            humanlabelforipad.fontSize        = 16;
            humanlabelforipad.alignmentMode   = kCAAlignmentCenter;
            humanlabelforipad.foregroundColor = [UIColor blackColor].CGColor;
            [humangroupforipad addSublayer:humanlabelforipad];
            self.layers[@"humanlabelforipad"] = humanlabelforipad;
            if(human>=1){
            CAShapeLayer * humanarrowforipad = [CAShapeLayer layer];
            humanarrowforipad.frame     = CGRectMake(94.21, 4.5, 22, 22);
            [humanarrowforipad setValue:@(-45 * M_PI/180) forKeyPath:@"transform.rotation"];
            humanarrowforipad.fillColor = [UIColor colorWithRed:0.918 green: 0.608 blue:0.235 alpha:1].CGColor;
            humanarrowforipad.lineWidth = 0;
            humanarrowforipad.path      = [self humanarrowforipadPath].CGPath;
            [humangroupforipad addSublayer:humanarrowforipad];
            self.layers[@"humanarrowforipad"] = humanarrowforipad;
            CAShapeLayer *humanstartingforipad = [CAShapeLayer layer];
            humanstartingforipad.frame       = CGRectMake(240.27, 10.32, 229, 229);
            humanstartingforipad.fillColor   = nil;
            humanstartingforipad.strokeColor = [UIColor colorWithRed:0.91 green: 0.604 blue:0.267 alpha:1].CGColor;
            humanstartingforipad.lineWidth   = 30;
            humanstartingforipad.strokeEnd   = 0;
            humanstartingforipad.path        = [self humanstartingforipadPath].CGPath;
            [humangroupforipad addSublayer:humanstartingforipad];
            self.layers[@"humanstartingforipad"] = humanstartingforipad;
            humanscoreforipad = [CATextLayer layer];
            humanscoreforipad.frame           = CGRectMake(0, 495.44, 22, 22);
            humanscoreforipad.contentsScale   = [[UIScreen mainScreen] scale];
            humanscoreforipad.string          = @"0";
            humanscoreforipad.font            = (__bridge CFTypeRef)@"GothamBook";
            humanscoreforipad.fontSize        = 15;
            humanscoreforipad.alignmentMode   = kCAAlignmentCenter;
            humanscoreforipad.foregroundColor = [UIColor blackColor].CGColor;
            [humangroupforipad addSublayer:humanscoreforipad];
            self.layers[@"humanscoreforipad"] = humanscoreforipad;
            }
        }
        
        
        CALayer * transportgroupforipad = [CALayer layer];
        transportgroupforipad.frame = CGRectMake(29.88, 248.68, 509.27, 556.29);
        
        [self.layer addSublayer:transportgroupforipad];
        self.layers[@"transportgroupforipad"] = transportgroupforipad;
        {
            CAShapeLayer * transportbackforipad = [CAShapeLayer layer];
            transportbackforipad.frame       = CGRectMake(51.89, 9.84, 457.38, 308.23);
            transportbackforipad.fillColor   = nil;
            transportbackforipad.strokeColor = [UIColor colorWithRed:0.835 green: 0.835 blue:0.835 alpha:1].CGColor;
            transportbackforipad.lineWidth   = 30;
            transportbackforipad.path        = [self transportbackforipadPath].CGPath;
            [transportgroupforipad addSublayer:transportbackforipad];
            self.layers[@"transportbackforipad"] = transportbackforipad;
            
            CATextLayer * transportmaxscoreforipad = [CATextLayer layer];
            transportmaxscoreforipad.frame         = CGRectMake(188.62, 91.57, 23, 30);
            transportmaxscoreforipad.contentsScale = [[UIScreen mainScreen] scale];
            transportmaxscoreforipad.string        = [NSString stringWithFormat:@"%d",mtransport];
            transportmaxscoreforipad.font          = (__bridge CFTypeRef)@"GothamBook";
            transportmaxscoreforipad.fontSize      = 15;
            transportmaxscoreforipad.alignmentMode = kCAAlignmentCenter;
            transportmaxscoreforipad.foregroundColor = [UIColor blackColor].CGColor;
            [transportgroupforipad addSublayer:transportmaxscoreforipad];
            self.layers[@"transportmaxscoreforipad"] = transportmaxscoreforipad;

            
            if(transport>=1){
            CAShapeLayer * transportstartingforipad = [CAShapeLayer layer];
            transportstartingforipad.frame       = CGRectMake(200.12, 9.48, 308, 308);
            transportstartingforipad.fillColor   = nil;
            transportstartingforipad.strokeColor = [UIColor colorWithRed:0.573 green: 0.557 blue:0.498 alpha:1].CGColor;
            transportstartingforipad.lineWidth   = 30;
            transportstartingforipad.strokeEnd   = 0;
            transportstartingforipad.path        = [self transportstartingforipadPath].CGPath;
            [transportgroupforipad addSublayer:transportstartingforipad];
            self.layers[@"transportstartingforipad"] = transportstartingforipad;
            CAShapeLayer * transportstartpathforipad = [CAShapeLayer layer];
            transportstartpathforipad.frame       = CGRectMake(59.77, 9.93, 302, 0);
            transportstartpathforipad.fillColor   = nil;
            transportstartpathforipad.strokeColor = [UIColor colorWithRed:0.573 green: 0.557 blue:0.498 alpha:1].CGColor;
            transportstartpathforipad.lineWidth   = 30;
            transportstartpathforipad.path        = [self transportstartpathforipadPath].CGPath;
            [transportgroupforipad addSublayer:transportstartpathforipad];
            self.layers[@"transportstartpathforipad"] = transportstartpathforipad;
            }
            CATextLayer * transportlabelforipad = [CATextLayer layer];
            transportlabelforipad.frame           = CGRectMake(97.54, 2, 191.54, 19.86);
            transportlabelforipad.contentsScale   = [[UIScreen mainScreen] scale];
            transportlabelforipad.string          = @"TRANSPORTATION";
            transportlabelforipad.font            = (__bridge CFTypeRef)@"GothamBook";
            transportlabelforipad.fontSize        = 16;
            transportlabelforipad.alignmentMode   = kCAAlignmentLeft;
            transportlabelforipad.foregroundColor = [UIColor blackColor].CGColor;
            [transportgroupforipad addSublayer:transportlabelforipad];
            self.layers[@"transportlabelforipad"] = transportlabelforipad;
            if(transport>=1){
            CAShapeLayer * transportarrowforipad = [CAShapeLayer layer];
            transportarrowforipad.frame     = CGRectMake(94.21, 43.36, 22, 22);
            [transportarrowforipad setValue:@(-45 * M_PI/180) forKeyPath:@"transform.rotation"];
            transportarrowforipad.fillColor = [UIColor colorWithRed:0.573 green: 0.557 blue:0.498 alpha:1].CGColor;
            transportarrowforipad.lineWidth = 0;
            transportarrowforipad.path      = [self transportarrowforipadPath].CGPath;
            [transportgroupforipad addSublayer:transportarrowforipad];
            self.layers[@"transportarrowforipad"] = transportarrowforipad;
            transportscoreforipad = [CATextLayer layer];
            transportscoreforipad.frame           = CGRectMake(0, 534.29, 22, 22);
            transportscoreforipad.contentsScale   = [[UIScreen mainScreen] scale];
            transportscoreforipad.string          = @"0";
            transportscoreforipad.font            = (__bridge CFTypeRef)@"GothamBook";
            transportscoreforipad.fontSize        = 15;
            transportscoreforipad.alignmentMode   = kCAAlignmentCenter;
            transportscoreforipad.foregroundColor = [UIColor blackColor].CGColor;
            [transportgroupforipad addSublayer:transportscoreforipad];
            self.layers[@"transportscoreforipad"] = transportscoreforipad;
            }
            CALayer * transport = [CALayer layer];
            transport.frame    = CGRectMake(66.12, 1, 20.44, 17);
            transport.contents = (id)[UIImage imageNamed:@"transport"].CGImage;
            [transportgroupforipad addSublayer:transport];
            self.layers[@"transport"] = transport;
        }
        
        
        CALayer * wastegroupforipad = [CALayer layer];
        wastegroupforipad.frame = CGRectMake(29.88, 207.76, 549.77, 597.21);
        
        [self.layer addSublayer:wastegroupforipad];
        self.layers[@"wastegroupforipad"] = wastegroupforipad;
        {
            CAShapeLayer * wastebackforipad = [CAShapeLayer layer];
            wastebackforipad.frame       = CGRectMake(53.51, 9.93, 496.26, 389.49);
            wastebackforipad.fillColor   = nil;
            wastebackforipad.strokeColor = [UIColor colorWithRed:0.835 green: 0.835 blue:0.835 alpha:1].CGColor;
            wastebackforipad.lineWidth   = 30;
            wastebackforipad.path        = [self wastebackforipadPath].CGPath;
            [wastegroupforipad addSublayer:wastebackforipad];
            self.layers[@"wastebackforipad"] = wastebackforipad;
            
            CATextLayer * wastemaxscoreforipad = [CATextLayer layer];
            wastemaxscoreforipad.frame           = CGRectMake(147.98, 132.48, 23, 30);
            wastemaxscoreforipad.contentsScale   = [[UIScreen mainScreen] scale];
            wastemaxscoreforipad.string          = [NSString stringWithFormat:@"%d",mwaste];
            wastemaxscoreforipad.font            = (__bridge CFTypeRef)@"GothamBook";
            wastemaxscoreforipad.fontSize        = 15;
            wastemaxscoreforipad.alignmentMode   = kCAAlignmentCenter;
            wastemaxscoreforipad.foregroundColor = [UIColor blackColor].CGColor;
            [wastegroupforipad addSublayer:wastemaxscoreforipad];
            self.layers[@"wastemaxscoreforipad"] = wastemaxscoreforipad;

            
            if(waste>=1){
            CAShapeLayer * wastestartingforipad = [CAShapeLayer layer];
            wastestartingforipad.frame       = CGRectMake(159.98, 9.9, 389, 389);
            wastestartingforipad.fillColor   = nil;
            wastestartingforipad.strokeColor = [UIColor colorWithRed:0.435 green: 0.753 blue:0.608 alpha:1].CGColor;
            wastestartingforipad.lineWidth   = 30;
            wastestartingforipad.strokeEnd   = 0;
            wastestartingforipad.path        = [self wastestartingforipadPath].CGPath;
            [wastegroupforipad addSublayer:wastestartingforipad];
            self.layers[@"wastestartingforipad"] = wastestartingforipad;
            CAShapeLayer * wastestartpathforipad = [CAShapeLayer layer];
            wastestartpathforipad.frame       = CGRectMake(59.77, 9.93, 302, 0);
            wastestartpathforipad.fillColor   = nil;
            wastestartpathforipad.strokeColor =[UIColor colorWithRed:0.435 green: 0.753 blue:0.608 alpha:1].CGColor;
            wastestartpathforipad.lineWidth   = 30;
            wastestartpathforipad.path        = [self wastestartpathforipadPath].CGPath;
            [wastegroupforipad addSublayer:wastestartpathforipad];
            self.layers[@"wastestartpathforipad"] = wastestartpathforipad;
            }
            CALayer * wastee = [CALayer layer];
            wastee.frame    = CGRectMake(65, 0.93, 22.68, 22);
            wastee.contents = (id)[UIImage imageNamed:@"waste"].CGImage;
            [wastegroupforipad addSublayer:wastee];
            self.layers[@"waste"] = wastee;
            CATextLayer * wastelabelforipad = [CATextLayer layer];
            wastelabelforipad.frame           = CGRectMake(97.54, 4, 191.54, 19.86);
            wastelabelforipad.contentsScale   = [[UIScreen mainScreen] scale];
            wastelabelforipad.string          = @"WASTE";
            wastelabelforipad.font            = (__bridge CFTypeRef)@"GothamBook";
            wastelabelforipad.fontSize        = 16;
            wastelabelforipad.alignmentMode   = kCAAlignmentLeft;
            wastelabelforipad.foregroundColor = [UIColor blackColor].CGColor;
            [wastegroupforipad addSublayer:wastelabelforipad];
            self.layers[@"wastelabelforipad"] = wastelabelforipad;
            
            if(waste>=1){
            CAShapeLayer * wastearrowforipad = [CAShapeLayer layer];
            wastearrowforipad.frame     = CGRectMake(94.21, 84.27, 22, 22);
            [wastearrowforipad setValue:@(-45 * M_PI/180) forKeyPath:@"transform.rotation"];
            wastearrowforipad.fillColor = [UIColor colorWithRed:0.435 green: 0.753 blue:0.608 alpha:1].CGColor;
            wastearrowforipad.lineWidth = 0;
            wastearrowforipad.path      = [self wastearrowforipadPath].CGPath;
            [wastegroupforipad addSublayer:wastearrowforipad];
            self.layers[@"wastearrowforipad"] = wastearrowforipad;
            wastescoreforipad = [CATextLayer layer];
            wastescoreforipad.frame           = CGRectMake(0, 575.21, 22, 22);
            wastescoreforipad.contentsScale   = [[UIScreen mainScreen] scale];
            wastescoreforipad.string          = @"0";
            wastescoreforipad.font            = (__bridge CFTypeRef)@"GothamBook";
            wastescoreforipad.fontSize        = 15;
            wastescoreforipad.alignmentMode   = kCAAlignmentCenter;
            wastescoreforipad.foregroundColor = [UIColor blackColor].CGColor;
            [wastegroupforipad addSublayer:wastescoreforipad];
            self.layers[@"wastescoreforipad"] = wastescoreforipad;
            }
        }
        
        
        CALayer * watergroupforipad = [CALayer layer];
        watergroupforipad.frame = CGRectMake(29.88, 167.8, 590.77, 637.17);
        
        [self.layer addSublayer:watergroupforipad];
        self.layers[@"watergroupforipad"] = watergroupforipad;
        {
            CAShapeLayer * waterbackforipad = [CAShapeLayer layer];
            waterbackforipad.frame       = CGRectMake(53.45, 10, 536.32, 469.64);
            waterbackforipad.fillColor   = nil;
            waterbackforipad.strokeColor = [UIColor colorWithRed:0.835 green: 0.835 blue:0.835 alpha:1].CGColor;
            waterbackforipad.lineWidth   = 30;
            waterbackforipad.path        = [self waterbackforipadPath].CGPath;
            [watergroupforipad addSublayer:waterbackforipad];
            self.layers[@"waterbackforipad"] = waterbackforipad;
            
            CATextLayer * watermaxscoreforipad = [CATextLayer layer];
            watermaxscoreforipad.frame           = CGRectMake(109.27, 172.44, 23, 30);
            watermaxscoreforipad.contentsScale   = [[UIScreen mainScreen] scale];
            watermaxscoreforipad.string          = [NSString stringWithFormat:@"%d",mwater];
            watermaxscoreforipad.font            = (__bridge CFTypeRef)@"GothamBook";
            watermaxscoreforipad.fontSize        = 15;
            watermaxscoreforipad.alignmentMode   = kCAAlignmentCenter;
            watermaxscoreforipad.foregroundColor = [UIColor blackColor].CGColor;
            [watergroupforipad addSublayer:watermaxscoreforipad];
            self.layers[@"watermaxscoreforipad"] = watermaxscoreforipad;

            
            if(water>=1){
            CAShapeLayer * waterstartingforipad = [CAShapeLayer layer];
            waterstartingforipad.frame       = CGRectMake(120.77, 9.82, 470, 470);
            waterstartingforipad.fillColor   = nil;
            waterstartingforipad.strokeColor = [UIColor colorWithRed:0.259 green: 0.741 blue:0.961 alpha:1].CGColor;
            waterstartingforipad.lineWidth   = 30;
            waterstartingforipad.strokeEnd   = 0;
            waterstartingforipad.path        = [self waterstartingforipadPath].CGPath;
            [watergroupforipad addSublayer:waterstartingforipad];
            self.layers[@"waterstartingforipad"] = waterstartingforipad;
            CAShapeLayer * waterstartpathforipad = [CAShapeLayer layer];
            waterstartpathforipad.frame       = CGRectMake(59.77, 9.5, 302, 0);
            waterstartpathforipad.fillColor   = nil;
            waterstartpathforipad.strokeColor = [UIColor colorWithRed:0.259 green: 0.741 blue:0.961 alpha:1].CGColor;
            waterstartpathforipad.lineWidth   = 30;
            waterstartpathforipad.path        = [self waterstartpathforipadPath].CGPath;
            [watergroupforipad addSublayer:waterstartpathforipad];
            self.layers[@"waterstartpathforipad"] = waterstartpathforipad;
            }
            CALayer * waterr = [CALayer layer];
            waterr.frame    = CGRectMake(70.12, 0, 11.81, 21);
            waterr.contents = (id)[UIImage imageNamed:@"water"].CGImage;
            [watergroupforipad addSublayer:waterr];
            self.layers[@"water"] = waterr;
            CATextLayer * waterlabelforipad = [CATextLayer layer];
            waterlabelforipad.frame           = CGRectMake(97.54, 2.57, 191.54, 19.86);
            waterlabelforipad.contentsScale   = [[UIScreen mainScreen] scale];
            waterlabelforipad.string          = @"WATER";
            waterlabelforipad.font            = (__bridge CFTypeRef)@"GothamBook";
            waterlabelforipad.fontSize        = 16;
            waterlabelforipad.alignmentMode   = kCAAlignmentLeft;
            waterlabelforipad.foregroundColor = [UIColor blackColor].CGColor;
            [watergroupforipad addSublayer:waterlabelforipad];
            self.layers[@"waterlabelforipad"] = waterlabelforipad;
            if(water>=1){
            CAShapeLayer * waterarrowforipad = [CAShapeLayer layer];
            waterarrowforipad.frame     = CGRectMake(94.21, 124.24, 22, 22);
            [waterarrowforipad setValue:@(-45 * M_PI/180) forKeyPath:@"transform.rotation"];
            waterarrowforipad.fillColor = [UIColor colorWithRed:0.259 green: 0.741 blue:0.961 alpha:1].CGColor;
            waterarrowforipad.lineWidth = 0;
            waterarrowforipad.path      = [self waterarrowforipadPath].CGPath;
            [watergroupforipad addSublayer:waterarrowforipad];
            self.layers[@"waterarrowforipad"] = waterarrowforipad;
            waterscoreforipad = [CATextLayer layer];
            waterscoreforipad.frame           = CGRectMake(0, 615.17, 22, 22);
            waterscoreforipad.contentsScale   = [[UIScreen mainScreen] scale];
            waterscoreforipad.string          = @"0";
            waterscoreforipad.font            = (__bridge CFTypeRef)@"GothamBook";
            waterscoreforipad.fontSize        = 15;
            waterscoreforipad.alignmentMode   = kCAAlignmentCenter;
            waterscoreforipad.foregroundColor = [UIColor blackColor].CGColor;
            [watergroupforipad addSublayer:waterscoreforipad];
            self.layers[@"waterscoreforipad"] = waterscoreforipad;
            }
        }
        
        
        CALayer * energygroupforipad = [CALayer layer];
        energygroupforipad.frame = CGRectMake(29.88, 126.87, 630.12, 678.1);
        
        [self.layer addSublayer:energygroupforipad];
        self.layers[@"energygroupforipad"] = energygroupforipad;
        {
            CAShapeLayer * energybackforipad = [CAShapeLayer layer];
            energybackforipad.frame       = CGRectMake(52.1, 10.44, 577.02, 549.69);
            energybackforipad.fillColor   = nil;
            energybackforipad.strokeColor = [UIColor colorWithRed:0.835 green: 0.835 blue:0.835 alpha:1].CGColor;
            energybackforipad.lineWidth   = 30;
            energybackforipad.path        = [self energybackforipadPath].CGPath;
            [energygroupforipad addSublayer:energybackforipad];
            self.layers[@"energybackforipad"] = energybackforipad;
            
            CATextLayer * energymaxscoreforipad = [CATextLayer layer];
            energymaxscoreforipad.frame           = CGRectMake(67.67, 213.37, 23, 30);
            energymaxscoreforipad.contentsScale   = [[UIScreen mainScreen] scale];
            energymaxscoreforipad.string          = [NSString stringWithFormat:@"%d",menergy];
            energymaxscoreforipad.font            = (__bridge CFTypeRef)@"GothamBook";
            energymaxscoreforipad.fontSize        = 15;
            energymaxscoreforipad.alignmentMode   = kCAAlignmentCenter;
            energymaxscoreforipad.foregroundColor = [UIColor blackColor].CGColor;
            [energygroupforipad addSublayer:energymaxscoreforipad];
            self.layers[@"energymaxscoreforipad"] = energymaxscoreforipad;

            
            if(energy>=1){
            CAShapeLayer * energystartingforipad = [CAShapeLayer layer];
            energystartingforipad.frame       = CGRectMake(80.12, 10.29, 550, 550);
            energystartingforipad.fillColor   = nil;
            energystartingforipad.strokeColor = [UIColor colorWithRed:0.776 green: 0.859 blue:0.122 alpha:1].CGColor;
            energystartingforipad.lineWidth   = 30;
            energystartingforipad.strokeEnd   = 0;
            energystartingforipad.path        = [self energystartingforipadPath].CGPath;
            [energygroupforipad addSublayer:energystartingforipad];
            self.layers[@"energystartingforipad"] = energystartingforipad;
            CAShapeLayer * energystartpathforipad = [CAShapeLayer layer];
            energystartpathforipad.frame       = CGRectMake(59.77, 10, 302, 0);
            energystartpathforipad.fillColor   = nil;
            energystartpathforipad.strokeColor = [UIColor colorWithRed:0.776 green: 0.859 blue:0.122 alpha:1].CGColor;
            energystartpathforipad.lineWidth   = 30;
            energystartpathforipad.path        = [self energystartpathforipadPath].CGPath;
            [energygroupforipad addSublayer:energystartpathforipad];
            self.layers[@"energystartpathforipad"] = energystartpathforipad;
            }
            CALayer * energyy = [CALayer layer];
            energyy.frame    = CGRectMake(71.17, 0, 14.15, 24);
            energyy.contents = (id)[UIImage imageNamed:@"energy"].CGImage;
            [energygroupforipad addSublayer:energyy];
            self.layers[@"energy"] = energyy;
            CATextLayer * energylabelforipad = [CATextLayer layer];
            energylabelforipad.frame           = CGRectMake(97.54, 2.07, 191.54, 19.86);
            energylabelforipad.contentsScale   = [[UIScreen mainScreen] scale];
            energylabelforipad.string          = @"ENERGY";
            energylabelforipad.font            = (__bridge CFTypeRef)@"GothamBook";
            energylabelforipad.fontSize        = 16;
            energylabelforipad.alignmentMode   = kCAAlignmentLeft;
            energylabelforipad.foregroundColor = [UIColor blackColor].CGColor;
            [energygroupforipad addSublayer:energylabelforipad];
            self.layers[@"energylabelforipad"] = energylabelforipad;
            if(energy>=1){
            CAShapeLayer * energyarrowforipad = [CAShapeLayer layer];
            energyarrowforipad.frame     = CGRectMake(94.21, 165.17, 22, 22);
            [energyarrowforipad setValue:@(-45 * M_PI/180) forKeyPath:@"transform.rotation"];
            energyarrowforipad.fillColor = [UIColor colorWithRed:0.776 green: 0.859 blue:0.122 alpha:1].CGColor;
            energyarrowforipad.lineWidth = 0;
            energyarrowforipad.path      = [self energyarrowforipadPath].CGPath;
            [energygroupforipad addSublayer:energyarrowforipad];
            self.layers[@"energyarrowforipad"] = energyarrowforipad;
            energyscoreforipad = [CATextLayer layer];
            energyscoreforipad.frame           = CGRectMake(0, 656.1, 22, 22);
            energyscoreforipad.contentsScale   = [[UIScreen mainScreen] scale];
            energyscoreforipad.string          = @"0";
            energyscoreforipad.font            = (__bridge CFTypeRef)@"GothamBook";
            energyscoreforipad.fontSize        = 15;
            energyscoreforipad.alignmentMode   = kCAAlignmentCenter;
            energyscoreforipad.foregroundColor = [UIColor blackColor].CGColor;
            [energygroupforipad addSublayer:energyscoreforipad];
            self.layers[@"energyscoreforipad"] = energyscoreforipad;
            }
        }
        [self addIpadanimationAnimation];
        }
        else {
            UIColor *color;
            if(row==1){
                actual=energy;
                maxx=menergy;
                if(tempdict[@"energy_avg"] != [NSNull null]){
                    localavg = [tempdict[@"energy_avg"] intValue];
                }else{
                    localavg = 0;
                }
                if(dict[@"energy_avg"] != [NSNull null]){
                    globalavg = [dict[@"energy_avg"] intValue];
                }else{
                    globalavg = 0;
                }
                middleactual=[[prefs objectForKey:@"middleenergy"] intValue];
                inneractual=[[prefs objectForKey:@"innerenergy"] intValue];
                color=[UIColor colorWithRed:0.776 green: 0.859 blue:0.122 alpha:1]; //Energy
            }
            else if(row==2){
                actual=water;
                maxx=mwater;
                middleactual=[[prefs objectForKey:@"middlewater"] intValue];
                inneractual=[[prefs objectForKey:@"innerwater"] intValue];
                if(tempdict[@"water_avg"] != [NSNull null]){
                    localavg = [tempdict[@"water_avg"] intValue];
                }else{
                    localavg = 0;
                }
                if(dict[@"water_avg"] != [NSNull null]){
                    globalavg = [dict[@"water_avg"] intValue];
                }else{
                    globalavg = 0;
                }
                color=[UIColor colorWithRed:0.259 green: 0.741 blue:0.961 alpha:1];
            }
            else if(row==3){
                actual=waste;
                maxx=mwaste;
                middleactual=[[prefs objectForKey:@"middlewaste"] intValue];
                inneractual=[[prefs objectForKey:@"innerwaste"] intValue];
                if(tempdict[@"waste_avg"] != [NSNull null]){
                    localavg = [tempdict[@"waste_avg"] intValue];
                }else{
                    localavg = 0;
                }
                if(dict[@"waste_avg"] != [NSNull null]){
                    globalavg = [dict[@"waste_avg"] intValue];
                }else{
                    globalavg = 0;
                }
                color=[UIColor colorWithRed:0.443 green: 0.769 blue:0.624 alpha:1];
            }
            else if(row==4){
                actual=transport;
                maxx=mtransport;
                middleactual=[[prefs objectForKey:@"middletransport"] intValue];
                inneractual=[[prefs objectForKey:@"innertransport"] intValue];
                if(tempdict[@"transport_avg"] != [NSNull null]){
                    localavg = [tempdict[@"transport_avg"] intValue];
                }else{
                    localavg = 0;
                }
                if(dict[@"transport_avg"] != [NSNull null]){
                    globalavg = [dict[@"transport_avg"] intValue];
                }else{
                    globalavg = 0;
                }

                color=[UIColor colorWithRed:0.573 green: 0.557 blue:0.498 alpha:1];
            }
            else if(row==5){
                actual=human;
                maxx=mhuman;
                middleactual=[[prefs objectForKey:@"middlehuman"] intValue];
                inneractual=[[prefs objectForKey:@"innerhuman"] intValue];
                if(tempdict[@"human_experience_avg"] != [NSNull null]){
                    localavg = [tempdict[@"human_experience_avg"] intValue];
                }else{
                    localavg = 0;
                }
                if(dict[@"human_experience_avg"] != [NSNull null]){
                    globalavg = [dict[@"human_experience_avg"] intValue];
                }else{
                    globalavg = 0;
                }
                color=[UIColor colorWithRed:0.937 green: 0.62 blue:0.153 alpha:1];
            }
            

            CALayer * individualplaqueforipad = [CALayer layer];
            individualplaqueforipad.frame = CGRectMake(73.46, 100.47, 536.71, 492.24);
            
            [self.layer addSublayer:individualplaqueforipad];
            self.layers[@"individualplaqueforipad"] = individualplaqueforipad;
            {
                CAShapeLayer * centercircleforipad = [CAShapeLayer layer];
                centercircleforipad.frame     = CGRectMake(242.04, 198.03, 137, 137);
                centercircleforipad.fillColor = [UIColor colorWithRed:0.831 green: 0.831 blue:0.831 alpha:1].CGColor;
                centercircleforipad.lineWidth = 0;
                centercircleforipad.path      = [self centercircleforipadPath].CGPath;
                [individualplaqueforipad addSublayer:centercircleforipad];
                self.layers[@"centercircleforipad"] = centercircleforipad;
                CAShapeLayer * innerbackforipad = [CAShapeLayer layer];
                innerbackforipad.frame       = CGRectMake(32.53, 165.45, 380.01, 201.72);
                innerbackforipad.fillColor   = nil;
                innerbackforipad.strokeColor = [UIColor colorWithRed:0.831 green: 0.831 blue:0.831 alpha:1].CGColor;
                innerbackforipad.lineWidth   = 41;
                innerbackforipad.path        = [self innerbackforipadPath].CGPath;
                [individualplaqueforipad addSublayer:innerbackforipad];
                self.layers[@"innerbackforipad"] = innerbackforipad;
                
                CATextLayer * innermaxscoreforipad = [CATextLayer layer];
                innermaxscoreforipad.frame           = CGRectMake(201.04, 213.66, 19.06, 15.79);
                innermaxscoreforipad.contentsScale   = [[UIScreen mainScreen] scale];
                innermaxscoreforipad.string          = [NSString stringWithFormat:@"%d",maxx];
                innermaxscoreforipad.font            = (__bridge CFTypeRef)@"GothamBook";
                innermaxscoreforipad.fontSize        = 15;
                innermaxscoreforipad.alignmentMode   = kCAAlignmentCenter;
                innermaxscoreforipad.foregroundColor = [UIColor blackColor].CGColor;
                [individualplaqueforipad addSublayer:innermaxscoreforipad];
                self.layers[@"innermaxscoreforipad"] = innermaxscoreforipad;
                if(inneractual>0){
                CALayer * innergroupforipad = [CALayer layer];
                innergroupforipad.frame = CGRectMake(0, 166.16, 411.38, 288.71);
                
                [individualplaqueforipad addSublayer:innergroupforipad];
                self.layers[@"innergroupforipad"] = innergroupforipad;
                {
                    CAShapeLayer * innerstartpathforipad = [CAShapeLayer layer];
                    innerstartpathforipad.frame       = CGRectMake(32.67, 0, 281, 0);
                    innerstartpathforipad.fillColor   = nil;
                    innerstartpathforipad.strokeColor = color.CGColor;
                    innerstartpathforipad.lineWidth   = 41;
                    innerstartpathforipad.strokeEnd   = 0;
                    innerstartpathforipad.path        = [self innerstartpathforipadPath].CGPath;
                    [innergroupforipad addSublayer:innerstartpathforipad];
                    self.layers[@"innerstartpathforipad"] = innerstartpathforipad;
                    CAShapeLayer * innerstartingforipad = [CAShapeLayer layer];
                    innerstartingforipad.frame       = CGRectMake(211.38, 0, 200, 202);
                    innerstartingforipad.fillColor   = nil;
                    innerstartingforipad.strokeColor = color.CGColor;
                    innerstartingforipad.lineWidth   = 41;
                    innerstartingforipad.strokeEnd   = 0;
                    innerstartingforipad.path        = [self innerstartingforipadPath].CGPath;
                    [innergroupforipad addSublayer:innerstartingforipad];
                    self.layers[@"innerstartingforipad"] = innerstartingforipad;
                    CAShapeLayer * innerarrowforipad = [CAShapeLayer layer];
                    innerarrowforipad.frame     = CGRectMake(62.4, 260.71, 28, 28);
                    [innerarrowforipad setValue:@(-45 * M_PI/180) forKeyPath:@"transform.rotation"];
                    innerarrowforipad.fillColor = color.CGColor;
                    innerarrowforipad.lineWidth = 0;
                    innerarrowforipad.path      = [self innerarrowforipadPath].CGPath;
                    [innergroupforipad addSublayer:innerarrowforipad];
                    self.layers[@"innerarrowforipad"] = innerarrowforipad;
                    innerscoreforipad = [CATextLayer layer];
                    innerscoreforipad.frame           = CGRectMake(0, 191.04, 19, 16);
                    innerscoreforipad.contentsScale   = [[UIScreen mainScreen] scale];
                    innerscoreforipad.string          = @"0";                    innerscoreforipad.font            = (__bridge CFTypeRef)@"GothamBook";
                    innerscoreforipad.fontSize        = 15;
                    innerscoreforipad.alignmentMode   = kCAAlignmentCenter;
                    innerscoreforipad.foregroundColor = [UIColor blackColor].CGColor;
                    [innergroupforipad addSublayer:innerscoreforipad];
                    self.layers[@"innerscoreforipad"] = innerscoreforipad;
                }
                }
                CATextLayer * lastyearforipad = [CATextLayer layer];
                lastyearforipad.frame           = CGRectMake(79.53, 155.77, 142, 22.77);
                lastyearforipad.contentsScale   = [[UIScreen mainScreen] scale];
                lastyearforipad.string          = [NSString stringWithFormat:@"%@",[prefs objectForKey:@"lastyear"]];
                lastyearforipad.font            = (__bridge CFTypeRef)@"GothamBook";
                lastyearforipad.fontSize        = 13;
                lastyearforipad.alignmentMode   = kCAAlignmentLeft;
                lastyearforipad.foregroundColor = [UIColor blackColor].CGColor;
                [individualplaqueforipad addSublayer:lastyearforipad];
                self.layers[@"lastyearforipad"] = lastyearforipad;
                CAShapeLayer * middlebackforipad = [CAShapeLayer layer];
                middlebackforipad.frame       = CGRectMake(31.47, 115.21, 430.07, 301.83);
                middlebackforipad.fillColor   = nil;
                middlebackforipad.strokeColor = [UIColor colorWithRed:0.831 green: 0.831 blue:0.831 alpha:1].CGColor;
                middlebackforipad.lineWidth   = 41;
                middlebackforipad.path        = [self middlebackforipadPath].CGPath;
                [individualplaqueforipad addSublayer:middlebackforipad];
                self.layers[@"middlebackforipad"] = middlebackforipad;
                CATextLayer * middlemaxscoreforipad = [CATextLayer layer];
                middlemaxscoreforipad.frame           = CGRectMake(149.75, 213.66, 19.06, 15.79);
                middlemaxscoreforipad.contentsScale   = [[UIScreen mainScreen] scale];
                middlemaxscoreforipad.string          = [NSString stringWithFormat:@"%d",maxx];
                middlemaxscoreforipad.font            = (__bridge CFTypeRef)@"GothamBook";
                middlemaxscoreforipad.fontSize        = 15;
                middlemaxscoreforipad.alignmentMode   = kCAAlignmentCenter;
                middlemaxscoreforipad.foregroundColor = [UIColor blackColor].CGColor;
                [individualplaqueforipad addSublayer:middlemaxscoreforipad];
                self.layers[@"middlemaxscoreforipad"] = middlemaxscoreforipad;
                if(middleactual>0){
                CALayer * middlegroupforipad = [CALayer layer];
                middlegroupforipad.frame = CGRectMake(0, 114.35, 462.38, 340.53);
                
                [individualplaqueforipad addSublayer:middlegroupforipad];
                self.layers[@"middlegroupforipad"] = middlegroupforipad;
                {
                    CAShapeLayer * middlestartpathforipad = [CAShapeLayer layer];
                    middlestartpathforipad.frame       = CGRectMake(32.34, 0, 281, 0);
                    middlestartpathforipad.fillColor   = nil;
                    middlestartpathforipad.strokeColor = color.CGColor;
                    middlestartpathforipad.lineWidth   = 41;
                    middlestartpathforipad.strokeEnd   = 0;
                    middlestartpathforipad.path        = [self middlestartpathforipadPath].CGPath;
                    [middlegroupforipad addSublayer:middlestartpathforipad];
                    self.layers[@"middlestartpathforipad"] = middlestartpathforipad;
                    CAShapeLayer * middlestartingforipad = [CAShapeLayer layer];
                    middlestartingforipad.frame       = CGRectMake(160.38, 0, 302, 302);
                    middlestartingforipad.fillColor   = nil;
                    middlestartingforipad.strokeColor = color.CGColor;
                    middlestartingforipad.lineWidth   = 41;
                    middlestartingforipad.strokeEnd   = 0;
                    middlestartingforipad.path        = [self middlestartingforipadPath].CGPath;
                    [middlegroupforipad addSublayer:middlestartingforipad];
                    self.layers[@"middlestartingforipad"] = middlestartingforipad;
                    CAShapeLayer * middlearrowforipad = [CAShapeLayer layer];
                    middlearrowforipad.frame     = CGRectMake(62.4, 312.53, 28, 28);
                    [middlearrowforipad setValue:@(-45 * M_PI/180) forKeyPath:@"transform.rotation"];
                    middlearrowforipad.fillColor = color.CGColor;
                    middlearrowforipad.lineWidth = 0;
                    middlearrowforipad.path      = [self middlearrowforipadPath].CGPath;
                    [middlegroupforipad addSublayer:middlearrowforipad];
                    self.layers[@"middlearrowforipad"] = middlearrowforipad;
                    middlescoreforipad = [CATextLayer layer];
                    middlescoreforipad.frame           = CGRectMake(0, 242.86, 19, 16);
                    middlescoreforipad.contentsScale   = [[UIScreen mainScreen] scale];
                    middlescoreforipad.string          = @"0";
                    middlescoreforipad.font            = (__bridge CFTypeRef)@"GothamBook";
                    middlescoreforipad.fontSize        = 15;
                    middlescoreforipad.alignmentMode   = kCAAlignmentCenter;
                    middlescoreforipad.foregroundColor = [UIColor blackColor].CGColor;
                    [middlegroupforipad addSublayer:middlescoreforipad];
                    self.layers[@"middlescoreforipad"] = middlescoreforipad;
                }
                               }
                CATextLayer * lastmonthforipad = [CATextLayer layer];
                lastmonthforipad.frame           = CGRectMake(80.03, 106.96, 82, 18.77);
                lastmonthforipad.contentsScale   = [[UIScreen mainScreen] scale];
                lastmonthforipad.string          = [NSString stringWithFormat:@"%@",[prefs objectForKey:@"lastmonth"]];
                lastmonthforipad.font            = (__bridge CFTypeRef)@"GothamBook";
                lastmonthforipad.fontSize        = 13;
                lastmonthforipad.alignmentMode   = kCAAlignmentLeft;
                lastmonthforipad.foregroundColor = [UIColor blackColor].CGColor;
                [individualplaqueforipad addSublayer:lastmonthforipad];
                self.layers[@"lastmonthforipad"] = lastmonthforipad;
                CAShapeLayer * outerbackforipad = [CAShapeLayer layer];
                outerbackforipad.frame       = CGRectMake(31.31, 40.37, 505.23, 451.87);
                outerbackforipad.fillColor   = nil;
                outerbackforipad.strokeColor = [UIColor colorWithRed:0.831 green: 0.831 blue:0.831 alpha:1].CGColor;
                outerbackforipad.lineWidth   = 90;
                outerbackforipad.path        = [self outerbackforipadPath].CGPath;
                [individualplaqueforipad addSublayer:outerbackforipad];
                self.layers[@"outerbackforipad"] = outerbackforipad;
                CATextLayer * outermaxscoreforipad = [CATextLayer layer];
                outermaxscoreforipad.frame           = CGRectMake(73.14, 213.66, 19.06, 15.79);
                outermaxscoreforipad.contentsScale   = [[UIScreen mainScreen] scale];
                outermaxscoreforipad.string          = [NSString stringWithFormat:@"%d",maxx];
                outermaxscoreforipad.font            = (__bridge CFTypeRef)@"GothamBook";
                outermaxscoreforipad.fontSize        = 15;
                outermaxscoreforipad.alignmentMode   = kCAAlignmentCenter;
                outermaxscoreforipad.foregroundColor = [UIColor blackColor].CGColor;
                [individualplaqueforipad addSublayer:outermaxscoreforipad];
                self.layers[@"outermaxscoreforipad"] = outermaxscoreforipad;

                if(actual>0){
                CALayer * outergroupforipad = [CALayer layer];
                outergroupforipad.frame = CGRectMake(0, 39.75, 536.71, 452);
                
                [individualplaqueforipad addSublayer:outergroupforipad];
                self.layers[@"outergroupforipad"] = outergroupforipad;
                {
                    CAShapeLayer * outerstartpathforipad = [CAShapeLayer layer];
                    outerstartpathforipad.frame       = CGRectMake(31.79, 0.41, 281, 0);
                    outerstartpathforipad.fillColor   = nil;
                    outerstartpathforipad.strokeColor = color.CGColor;
                    outerstartpathforipad.lineWidth   = 90;
                    outerstartpathforipad.strokeEnd   = 0;
                    outerstartpathforipad.path        = [self outerstartpathforipadPath].CGPath;
                    [outergroupforipad addSublayer:outerstartpathforipad];
                    self.layers[@"outerstartpathforipad"] = outerstartpathforipad;
                    CAShapeLayer * outerstartingforipad = [CAShapeLayer layer];
                    outerstartingforipad.frame       = CGRectMake(84.71, 0, 452, 452);
                    outerstartingforipad.fillColor   = nil;
                    outerstartingforipad.strokeColor = color.CGColor;
                    outerstartingforipad.lineWidth   = 90;
                    outerstartingforipad.strokeEnd   = 0;
                    outerstartingforipad.path        = [self outerstartingforipadPath].CGPath;
                    [outergroupforipad addSublayer:outerstartingforipad];
                    self.layers[@"outerstartingforipad"] = outerstartingforipad;
                    CAShapeLayer * outerarrowforipad = [CAShapeLayer layer];
                    outerarrowforipad.frame     = CGRectMake(41.71, 351.12, 64, 64);
                    [outerarrowforipad setValue:@(-45 * M_PI/180) forKeyPath:@"transform.rotation"];
                    outerarrowforipad.fillColor = color.CGColor;
                    outerarrowforipad.lineWidth = 0;
                    outerarrowforipad.path      = [self outerarrowforipadPath].CGPath;
                    [outergroupforipad addSublayer:outerarrowforipad];
                    self.layers[@"outerarrowforipad"] = outerarrowforipad;
                    outerscoreforipad = [CATextLayer layer];
                    outerscoreforipad.frame           = CGRectMake(0, 317.45, 19, 16);
                    outerscoreforipad.contentsScale   = [[UIScreen mainScreen] scale];
                    outerscoreforipad.string          = @"0";                    outerscoreforipad.font            = (__bridge CFTypeRef)@"GothamBook";
                    outerscoreforipad.fontSize        = 15;
                    outerscoreforipad.alignmentMode   = kCAAlignmentCenter;
                    outerscoreforipad.foregroundColor = [UIColor blackColor].CGColor;
                    [outergroupforipad addSublayer:outerscoreforipad];
                    self.layers[@"outerscoreforipad"] = outerscoreforipad;
                    
                    if((localavg!=globalavg)&&(localavg!=actual)){
                    CATextLayer * outerlocalavgscoreforipad = [CATextLayer layer];
                    outerlocalavgscoreforipad.frame    = CGRectMake(73.46, 602.68, 19, 16);
                    outerlocalavgscoreforipad.contentsScale = [[UIScreen mainScreen] scale];
                    outerlocalavgscoreforipad.string   = [NSString stringWithFormat:@"%d",localavg];
                    outerlocalavgscoreforipad.font     = (__bridge CFTypeRef)@"GothamBook";
                    outerlocalavgscoreforipad.fontSize = 15;
                    outerlocalavgscoreforipad.alignmentMode = kCAAlignmentCenter;
                    outerlocalavgscoreforipad.foregroundColor = [UIColor blackColor].CGColor;
                    [self.layer addSublayer:outerlocalavgscoreforipad];
                    self.layers[@"outerlocalavgscoreforipad"] = outerlocalavgscoreforipad;
                    }
                     if(globalavg!=actual){
                    CATextLayer * outerglobalavgscoreforipad = [CATextLayer layer];
                    outerglobalavgscoreforipad.frame    = CGRectMake(73.46, 602.68, 19, 16);
                    outerglobalavgscoreforipad.contentsScale = [[UIScreen mainScreen] scale];
                    outerglobalavgscoreforipad.string   = [NSString stringWithFormat:@"%d",globalavg];
                    outerglobalavgscoreforipad.font     = (__bridge CFTypeRef)@"GothamBook";
                    outerglobalavgscoreforipad.fontSize = 15;
                    outerglobalavgscoreforipad.alignmentMode = kCAAlignmentCenter;
                    outerglobalavgscoreforipad.foregroundColor = [UIColor blackColor].CGColor;
                    [self.layer addSublayer:outerglobalavgscoreforipad];
                    self.layers[@"outerglobalavgscoreforipad"] = outerglobalavgscoreforipad;
                    }
                    CAShapeLayer * localavgscoreforipadpath = [CAShapeLayer layer];
                    localavgscoreforipadpath.frame       = CGRectMake(158, 286, 452, 452);
                    localavgscoreforipadpath.fillColor   = nil;
                    localavgscoreforipadpath.opacity=0;
                    localavgscoreforipadpath.strokeColor = [UIColor colorWithRed:0.329 green: 0.329 blue:0.329 alpha:1].CGColor;
                    localavgscoreforipadpath.path        = [self localavgscoreforipadpathPath].CGPath;
                    [self.layer addSublayer:localavgscoreforipadpath];
                    self.layers[@"localavgscoreforipadpath"] = localavgscoreforipadpath;
                    
                    CAShapeLayer * globalavgscoreforipadpath = [CAShapeLayer layer];
                    globalavgscoreforipadpath.frame       = CGRectMake(158, 286, 452, 452);
                    globalavgscoreforipadpath.fillColor   = nil;
                    globalavgscoreforipadpath.opacity=0;
                    globalavgscoreforipadpath.strokeColor = [UIColor colorWithRed:0.329 green: 0.329 blue:0.329 alpha:1].CGColor;
                    globalavgscoreforipadpath.path        = [self globalavgscoreforipadpathPath].CGPath;
                    [self.layer addSublayer:globalavgscoreforipadpath];
                    self.layers[@"globalavgscoreforipadpath"] = globalavgscoreforipadpath;
                }
                }
                CATextLayer * toptitleforipad = [CATextLayer layer];
                toptitleforipad.frame           = CGRectMake(76.14, 0, 104.17, 22.88);
                toptitleforipad.contentsScale   = [[UIScreen mainScreen] scale];
                toptitleforipad.string          = @"Hello World!";
                toptitleforipad.font            = (__bridge CFTypeRef)@"GothamBook";
                toptitleforipad.fontSize        = 15;
                toptitleforipad.alignmentMode   = kCAAlignmentLeft;
                toptitleforipad.foregroundColor = [UIColor blackColor].CGColor;
                [individualplaqueforipad addSublayer:toptitleforipad];
                self.layers[@"toptitleforipad"] = toptitleforipad;
                CATextLayer * line1titleforipad = [CATextLayer layer];
                line1titleforipad.frame           = CGRectMake(76.14, 19.88, 184.17, 19.88);
                line1titleforipad.contentsScale   = [[UIScreen mainScreen] scale];
                line1titleforipad.string          = @"Hello World!";
                line1titleforipad.font            = (__bridge CFTypeRef)@"GothamBook";
                line1titleforipad.fontSize        = 13;
                line1titleforipad.alignmentMode   = kCAAlignmentLeft;
                line1titleforipad.foregroundColor = [UIColor blackColor].CGColor;
                [individualplaqueforipad addSublayer:line1titleforipad];
                self.layers[@"line1titleforipad"] = line1titleforipad;
                CATextLayer * line2titleforipad = [CATextLayer layer];
                line2titleforipad.frame           = CGRectMake(76.14, 35.21, 184.17, 19.88);
                line2titleforipad.contentsScale   = [[UIScreen mainScreen] scale];
                line2titleforipad.string          = @"Hello World!";
                line2titleforipad.font            = (__bridge CFTypeRef)@"GothamBook";
                line2titleforipad.fontSize        = 13;
                line2titleforipad.alignmentMode   = kCAAlignmentLeft;
                line2titleforipad.foregroundColor = [UIColor blackColor].CGColor;
                [individualplaqueforipad addSublayer:line2titleforipad];
                self.layers[@"line2titleforipad"] = line2titleforipad;
                CATextLayer * line3titleforipad = [CATextLayer layer];
                line3titleforipad.frame           = CGRectMake(76.14, 49.46, 184.17, 19.88);
                line3titleforipad.contentsScale   = [[UIScreen mainScreen] scale];
                line3titleforipad.string          = @"Hello World!";
                line3titleforipad.font            = (__bridge CFTypeRef)@"GothamBook";
                line3titleforipad.fontSize        = 13;
                line3titleforipad.alignmentMode   = kCAAlignmentLeft;
                line3titleforipad.foregroundColor = [UIColor blackColor].CGColor;
                [individualplaqueforipad addSublayer:line3titleforipad];
                self.layers[@"line3titleforipad"] = line3titleforipad;
                CATextLayer * line4titleforipad = [CATextLayer layer];
                line4titleforipad.frame           = CGRectMake(76.14, 65.34, 184.17, 19.88);
                line4titleforipad.contentsScale   = [[UIScreen mainScreen] scale];
                line4titleforipad.string          = @"Hello World!";
                line4titleforipad.font            = (__bridge CFTypeRef)@"GothamBook";
                line4titleforipad.fontSize        = 13;
                line4titleforipad.alignmentMode   = kCAAlignmentLeft;
                line4titleforipad.foregroundColor = [UIColor blackColor].CGColor;
                [individualplaqueforipad addSublayer:line4titleforipad];
                self.layers[@"line4titleforipad"] = line4titleforipad;
                CATextLayer * centerlabelforipad = [CATextLayer layer];
                centerlabelforipad.frame           = CGRectMake(256.54, 261.06, 108, 36.94);
                centerlabelforipad.contentsScale   = [[UIScreen mainScreen] scale];
                centerlabelforipad.string          = @"Hello!\n";
                centerlabelforipad.font            = (__bridge CFTypeRef)@"GothamBook";
                centerlabelforipad.fontSize        = 11;
                centerlabelforipad.alignmentMode   = kCAAlignmentCenter;
                centerlabelforipad.foregroundColor = color.CGColor;
                [individualplaqueforipad addSublayer:centerlabelforipad];
                self.layers[@"centerlabelforipad"] = centerlabelforipad;
                if(row==1){
                    centerlabelforipad.string=@"CURRENT ENERGY";
                }
                
                else if(row==2){
                    centerlabelforipad.string=@"CURRENT WATER";
                }
                
                else if(row==3){
                    centerlabelforipad.string=@"CURRENT WASTE";
                }
                
                else if(row==4){
                    centerlabelforipad.string=@"CURRENT \nTRANSPORTATION";
                }
                
                else if(row==5){
                    centerlabelforipad.string=@"CURRENT HUMAN \nEXPERIENCE";
                }
                if(row==1){
                    toptitleforipad.string=[NSString stringWithFormat:@"CURRENT"];
                    line1titleforipad.string=[NSString stringWithFormat:@"Electricity"];
                    line2titleforipad.string=[NSString stringWithFormat:@"Gas"];
                    line3titleforipad.string=[NSString stringWithFormat:@"Smart meters"];
                    line4titleforipad.string=[NSString stringWithFormat:@"Load schedule"];
                }
                
                else if(row==2){
                    toptitleforipad.string=[NSString stringWithFormat:@"CURRENT"];
                    line1titleforipad.string=[NSString stringWithFormat:@"Water consumption"];
                    line2titleforipad.string=[NSString stringWithFormat:@""];
                    line3titleforipad.string=[NSString stringWithFormat:@""];
                    line4titleforipad.string=[NSString stringWithFormat:@""];
                }
                else if(row==3){
                    toptitleforipad.string=[NSString stringWithFormat:@"CURRENT"];
                    line1titleforipad.string=[NSString stringWithFormat:@"Waste generated"];
                    line2titleforipad.string=[NSString stringWithFormat:@"Waste diverted"];
                    line3titleforipad.string=[NSString stringWithFormat:@""];
                    line4titleforipad.string=[NSString stringWithFormat:@""];
                }
                else if(row==4){
                    toptitleforipad.string=[NSString stringWithFormat:@"CURRENT"];
                    line1titleforipad.string=[NSString stringWithFormat:@"Occupant travel"];
                    line2titleforipad.string=[NSString stringWithFormat:@""];
                    line3titleforipad.string=[NSString stringWithFormat:@""];
                    line4titleforipad.string=[NSString stringWithFormat:@""];
                }
                else if(row==5){
                    toptitleforipad.string=[NSString stringWithFormat:@"CURRENT"];
                    line1titleforipad.string=[NSString stringWithFormat:@"CO2 levels"];
                    line2titleforipad.string=[NSString stringWithFormat:@"VOC levels"];
                    line3titleforipad.string=[NSString stringWithFormat:@"Occupant satisfaction"];
                    line4titleforipad.string=[NSString stringWithFormat:@""];
                }

            }
            
            
            
            
            CALayer * needle = [CALayer layer];
            needle.frame    = CGRectMake(149.06, 647.82, 15, 12);
            [needle setValue:@(-64.08 * M_PI/180) forKeyPath:@"transform.rotation"];
            needle.contents = (id)[UIImage imageNamed:@"needle1"].CGImage;
            [self.layer addSublayer:needle];
            self.layers[@"needle"] = needle;
            
            CALayer * needle2 = [CALayer layer];
            needle2.frame    = CGRectMake(172.5, 905.1, 15, 12);
            [needle2 setValue:@(-64 * M_PI/180) forKeyPath:@"transform.rotation"];
            needle2.contents = (id)[UIImage imageNamed:@"needle2"].CGImage;
            [self.layer addSublayer:needle2];
            self.layers[@"needle2"] = needle2;
            
            CAShapeLayer * needle1pathforipad = [CAShapeLayer layer];
            needle1pathforipad.frame     = CGRectMake(98.05, 81.02, 452, 452);
            needle1pathforipad.fillColor = nil;
            needle1pathforipad.lineWidth = 0;
            needle1pathforipad.path      = [self needle1pathforipadPath].CGPath;
            [self.layer addSublayer:needle1pathforipad];
            self.layers[@"needle1pathforipad"] = needle1pathforipad;
            
            CAShapeLayer * needle2pathforipad = [CAShapeLayer layer];
            needle2pathforipad.frame     = CGRectMake(98, 81.02, 452, 452);
            needle2pathforipad.fillColor = nil;
            needle2pathforipad.lineWidth = 0;
            needle2pathforipad.path      = [self needle2pathforipadPath].CGPath;
            [self.layer addSublayer:needle2pathforipad];
            self.layers[@"needle2pathforipad"] = needle2pathforipad;
            
            CALayer * local = [CALayer layer];
            local.frame    = CGRectMake(151.06, 586.13, 62, 62);
            local.contents = (id)[UIImage imageNamed:@"local"].CGImage;
            [self.layer addSublayer:local];
            self.layers[@"local"] = local;
            
            CALayer * global = [CALayer layer];
            global.frame    = CGRectMake(151.06, 586.13, 62, 62);
            global.contents = (id)[UIImage imageNamed:@"global"].CGImage;
            [self.layer addSublayer:global];
            self.layers[@"global"] = global;
            
            CAShapeLayer * localpathforipad = [CAShapeLayer layer];
            localpathforipad.frame     = CGRectMake(53, 35, 452, 452);
            localpathforipad.fillColor = nil;
            localpathforipad.lineWidth = 0;
            localpathforipad.path      = [self localpathforipadPath].CGPath;
            [self.layer addSublayer:localpathforipad];
            self.layers[@"localpathforipad"] = localpathforipad;
            
            CAShapeLayer * globalpathforipad = [CAShapeLayer layer];
            globalpathforipad.frame     = CGRectMake(53, 35, 452, 452);
            globalpathforipad.fillColor = nil;
            globalpathforipad.lineWidth = 0;
            //globalpathforipad.fillColor = [UIColor redColor].CGColor;
            //globalpathforipad.lineWidth = 3;
            globalpathforipad.path      = [self globalpathforipadPath].CGPath;
            [self.layer addSublayer:globalpathforipad];
            self.layers[@"globalpathforipad"] = globalpathforipad;
            
            CALayer * energy = [CALayer layer];
            energy.frame    = CGRectMake(118.62, 102.47, 16.51, 24);
            energy.contents = (id)[UIImage imageNamed:@"energy"].CGImage;
            
            CALayer * human = [CALayer layer];
            human.frame    = CGRectMake(119.09, 104.47, 13.29, 26);
            human.contents = (id)[UIImage imageNamed:@"human"].CGImage;
            
            CALayer * waste = [CALayer layer];
            waste.frame    = CGRectMake(114.89, 104.47, 24.87, 24);
            waste.contents = (id)[UIImage imageNamed:@"waste"].CGImage;
            
            CALayer * transport = [CALayer layer];
            transport.frame    = CGRectMake(111.55, 108.47, 31.26, 26);
            transport.contents = (id)[UIImage imageNamed:@"transport"].CGImage;

            CALayer * water = [CALayer layer];
            water.frame    = CGRectMake(119.62, 102.47, 14.62, 24);
            water.contents = (id)[UIImage imageNamed:@"water"].CGImage;

            if(row==1){
                [self.layer addSublayer:energy];
                self.layers[@"energy"] = energy;
                
            }
            
            else if(row==2){
                [self.layer addSublayer:water];
                self.layers[@"water"] = water;
            }
            else if(row==3){
                [self.layer addSublayer:waste];
                self.layers[@"waste"] = waste;
            }
            else if(row==4){
                [self.layer addSublayer:transport];
                self.layers[@"transport"] = transport;
            }
            else if(row==5){
                [self.layer addSublayer:human];
                self.layers[@"human"] = human;
                
            }
        
        }
        
        
        [self addIpadindividualAnimation];
        
    }
    else{
        if((int)[prefs integerForKey:@"row"]==0){
    CALayer * plaquegroupforiphone = [CALayer layer];
        if(width==320 && height==480){
    plaquegroupforiphone.frame = CGRectMake(7.5, 88.64, 287.32, 283.74);
        }
        else if(width==320 && height==568){
            plaquegroupforiphone.frame = CGRectMake(7.5, 68.64, 287.32, 283.74);
        }
        else if(width==375 && height==667){
            plaquegroupforiphone.frame = CGRectMake(37.5, 78.64, 287.32, 283.74);
        }
        else if (width==414 && height==736){
            plaquegroupforiphone.frame = CGRectMake(57.5, 88.64, 287.32, 283.74);
        }
    [self.layer addSublayer:plaquegroupforiphone];
    self.layers[@"plaquegroupforiphone"] = plaquegroupforiphone;
    {
        if((int)[prefs integerForKey:@"row"]==0){
        CALayer * puckforiphone = [CALayer layer];
        puckforiphone.frame    = CGRectMake(105.84, 98.86, 87, 87);
        puckforiphone.contents = (id)[UIImage imageNamed:@"puck"].CGImage;
        [plaquegroupforiphone addSublayer:puckforiphone];
        self.layers[@"puckforiphone"] = puckforiphone;
        CATextLayer * puckscoreforiphone = [CATextLayer layer];
        puckscoreforiphone.frame           = CGRectMake(128.97, 115.07, 40.06, 40.56);
        puckscoreforiphone.contentsScale   = [[UIScreen mainScreen] scale];
            puckscoreforiphone.string      = [NSString stringWithFormat:@"%d",energy+water+waste+transport+human+base];
        puckscoreforiphone.font            = (__bridge CFTypeRef)@"DINEngschrift";
        puckscoreforiphone.fontSize        = 36;
        puckscoreforiphone.alignmentMode   = kCAAlignmentCenter;
        puckscoreforiphone.foregroundColor = [UIColor whiteColor].CGColor;
        [plaquegroupforiphone addSublayer:puckscoreforiphone];
        self.layers[@"puckscoreforiphone"] = puckscoreforiphone;
        CALayer * humangroupforiphone = [CALayer layer];
        humangroupforiphone.frame = CGRectMake(2.05, 79.43, 204.95, 192.9);
        
        [plaquegroupforiphone addSublayer:humangroupforiphone];
        self.layers[@"humangroupforiphone"] = humangroupforiphone;
        {
            CAShapeLayer * humanbackforiphone = [CAShapeLayer layer];
            humanbackforiphone.frame       = CGRectMake(0, 5.46, 204.95, 114.87);
            humanbackforiphone.fillColor   = nil;
            humanbackforiphone.strokeColor = [UIColor colorWithRed:0.835 green: 0.835 blue:0.835 alpha:1].CGColor;
            humanbackforiphone.lineWidth   = 15;
            humanbackforiphone.path        = [self humanbackforiphonePath].CGPath;
            [humangroupforiphone addSublayer:humanbackforiphone];
            self.layers[@"humanbackforiphone"] = humanbackforiphone;
            
            CATextLayer * humanmaxscoreforiphone = [CATextLayer layer];
            humanmaxscoreforiphone.frame           = CGRectMake(85.43, 22.93, 10, 10);
            humanmaxscoreforiphone.contentsScale   = [[UIScreen mainScreen] scale];
            humanmaxscoreforiphone.string          = [NSString stringWithFormat:@"%d",mhuman];
            humanmaxscoreforiphone.font            = (__bridge CFTypeRef)@"GothamBook";
            humanmaxscoreforiphone.fontSize        = 8;
            humanmaxscoreforiphone.alignmentMode   = kCAAlignmentCenter;
            humanmaxscoreforiphone.foregroundColor = [UIColor blackColor].CGColor;
            [humangroupforiphone addSublayer:humanmaxscoreforiphone];
            self.layers[@"humanmaxscoreforiphone"] = humanmaxscoreforiphone;
            
            if(human>=1){
            CAShapeLayer * humanstartpathforiphone = [CAShapeLayer layer];
            humanstartpathforiphone.frame       = CGRectMake(1.13, 5.06, 147, 0);
            humanstartpathforiphone.fillColor   = nil;
            humanstartpathforiphone.strokeColor = [UIColor colorWithRed:0.91 green: 0.604 blue:0.267 alpha:1].CGColor;
            humanstartpathforiphone.lineWidth   = 15;
            humanstartpathforiphone.path        = [self humanstartpathforiphonePath].CGPath;
            [humangroupforiphone addSublayer:humanstartpathforiphone];
            self.layers[@"humanstartpathforiphone"] = humanstartpathforiphone;
            CAShapeLayer * humanarrowforiphone = [CAShapeLayer layer];
            humanarrowforiphone.frame     = CGRectMake(84.17, 36.78, 10, 10);
            [humanarrowforiphone setValue:@(-45 * M_PI/180) forKeyPath:@"transform.rotation"];
            humanarrowforiphone.fillColor = [UIColor colorWithRed:0.918 green: 0.608 blue:0.235 alpha:1].CGColor;
            humanarrowforiphone.lineWidth = 0;
            humanarrowforiphone.path      = [self humanarrowforiphonePath].CGPath;
            [humangroupforiphone addSublayer:humanarrowforiphone];
            self.layers[@"humanarrowforiphone"] = humanarrowforiphone;
            CAShapeLayer * humanstartingforiphone = [CAShapeLayer layer];
            humanstartingforiphone.frame       = CGRectMake(89.95, 5.46, 115, 115);
            humanstartingforiphone.fillColor   = nil;
            humanstartingforiphone.strokeColor = [UIColor colorWithRed:0.92 green: 0.609 blue:0.236 alpha:1].CGColor;
            humanstartingforiphone.lineWidth   = 15;
            humanstartingforiphone.strokeEnd   = 0;
            humanstartingforiphone.path        = [self humanstartingforiphonePath].CGPath;
            [humangroupforiphone addSublayer:humanstartingforiphone];
            self.layers[@"humanstartingforiphone"] = humanstartingforiphone;
            humanscoreforiphone = [CATextLayer layer];
            humanscoreforiphone.frame           = CGRectMake(20.33, 182.86, 10.76, 10.04);
            humanscoreforiphone.contentsScale   = [[UIScreen mainScreen] scale];
            humanscoreforiphone.string          = @"0";
            humanscoreforiphone.font            = (__bridge CFTypeRef)@"GothamBook";
            humanscoreforiphone.fontSize        = 8;
            humanscoreforiphone.alignmentMode   = kCAAlignmentCenter;
            humanscoreforiphone.foregroundColor = [UIColor blackColor].CGColor;
            [humangroupforiphone addSublayer:humanscoreforiphone];
            self.layers[@"humanscoreforiphone"] = humanscoreforiphone;
            }
            
            CALayer * humanforiphone = [CALayer layer];
            humanforiphone.frame    = CGRectMake(5.45, 0.93, 4.58, 10);
            humanforiphone.contents = (id)[UIImage imageNamed:@"human"].CGImage;
            [humangroupforiphone addSublayer:humanforiphone];
            self.layers[@"humanforiphone"] = humanforiphone;
            CATextLayer * humanlabelforiphone = [CATextLayer layer];
            humanlabelforiphone.frame           = CGRectMake(17.35, 2.5, 118.54, 15.86);
            humanlabelforiphone.contentsScale   = [[UIScreen mainScreen] scale];
            humanlabelforiphone.string          = @"HUMAN EXPERIENCE\n";
            humanlabelforiphone.font            = (__bridge CFTypeRef)@"GothamBook";
            humanlabelforiphone.fontSize        = 9;
            humanlabelforiphone.alignmentMode   = kCAAlignmentLeft;
            humanlabelforiphone.foregroundColor = [UIColor blackColor].CGColor;
            [humangroupforiphone addSublayer:humanlabelforiphone];
            self.layers[@"humanlabelforiphone"] = humanlabelforiphone;
           
        }
        
        CALayer * transportgroupforiphone = [CALayer layer];
        transportgroupforiphone.frame = CGRectMake(1.78, 59.43, 225.22, 207.9);
        
        [plaquegroupforiphone addSublayer:transportgroupforiphone];
        self.layers[@"transportgroupforiphone"] = transportgroupforiphone;
        {
            CAShapeLayer * transportbackforiphone = [CAShapeLayer layer];
            transportbackforiphone.frame       = CGRectMake(0, 5.22, 225.22, 155.17);
            transportbackforiphone.fillColor   = nil;
            transportbackforiphone.strokeColor = [UIColor colorWithRed:0.835 green: 0.835 blue:0.835 alpha:1].CGColor;
            transportbackforiphone.lineWidth   = 15;
            transportbackforiphone.path        = [self transportbackforiphonePath].CGPath;
            [transportgroupforiphone addSublayer:transportbackforiphone];
            self.layers[@"transportbackforiphone"] = transportbackforiphone;
            
            CATextLayer * transportmaxscoreforiphone = [CATextLayer layer];
            transportmaxscoreforiphone.frame    = CGRectMake(66.39, 42.93, 10, 10);
            transportmaxscoreforiphone.contentsScale = [[UIScreen mainScreen] scale];
            transportmaxscoreforiphone.string   = [NSString stringWithFormat:@"%d",mtransport];
            transportmaxscoreforiphone.font     = (__bridge CFTypeRef)@"GothamBook";
            transportmaxscoreforiphone.fontSize = 8;
            transportmaxscoreforiphone.alignmentMode = kCAAlignmentCenter;
            transportmaxscoreforiphone.foregroundColor = [UIColor blackColor].CGColor;
            [transportgroupforiphone addSublayer:transportmaxscoreforiphone];
            self.layers[@"transportmaxscoreforiphone"] = transportmaxscoreforiphone;

            
            if(transport>=1){
            CAShapeLayer * transportstartpathforiphone = [CAShapeLayer layer];
            transportstartpathforiphone.frame     = CGRectMake(0.72, 5.26, 147, 0);
            transportstartpathforiphone.lineJoin  = kCALineJoinRound;
            transportstartpathforiphone.fillColor = nil;
            transportstartpathforiphone.strokeColor = [UIColor colorWithRed:0.572 green: 0.556 blue:0.509 alpha:1].CGColor;
            transportstartpathforiphone.lineWidth = 15;
            transportstartpathforiphone.path      = [self transportstartpathforiphonePath].CGPath;
            [transportgroupforiphone addSublayer:transportstartpathforiphone];
            self.layers[@"transportstartpathforiphone"] = transportstartpathforiphone;
            CAShapeLayer * transportstartingforiphone = [CAShapeLayer layer];
            transportstartingforiphone.frame       = CGRectMake(70.22, 5.46, 155, 155);
            transportstartingforiphone.fillColor   = nil;
            transportstartingforiphone.strokeColor = [UIColor colorWithRed:0.572 green: 0.556 blue:0.505 alpha:1].CGColor;
            transportstartingforiphone.lineWidth   = 15;
            transportstartingforiphone.strokeEnd   = 0;
            transportstartingforiphone.path        = [self transportstartingforiphonePath].CGPath;
            [transportgroupforiphone addSublayer:transportstartingforiphone];
            self.layers[@"transportstartingforiphone"] = transportstartingforiphone;
            CAShapeLayer * transportarrowforiphone = [CAShapeLayer layer];
            transportarrowforiphone.frame     = CGRectMake(84.44, 51.78, 10, 10);
            [transportarrowforiphone setValue:@(-45 * M_PI/180) forKeyPath:@"transform.rotation"];
            transportarrowforiphone.fillColor = [UIColor colorWithRed:0.573 green: 0.557 blue:0.506 alpha:1].CGColor;
            transportarrowforiphone.lineWidth = 0;
            transportarrowforiphone.path      = [self transportarrowforiphonePath].CGPath;
            [transportgroupforiphone addSublayer:transportarrowforiphone];
            self.layers[@"transportarrowforiphone"] = transportarrowforiphone;
            transportscoreforiphone = [CATextLayer layer];
            transportscoreforiphone.frame         = CGRectMake(20.6, 197.86, 10.76, 10.04);
            transportscoreforiphone.contentsScale = [[UIScreen mainScreen] scale];
            transportscoreforiphone.string        = @"0";
            transportscoreforiphone.font          = (__bridge CFTypeRef)@"GothamBook";
            transportscoreforiphone.fontSize      = 8;
            transportscoreforiphone.alignmentMode = kCAAlignmentCenter;
            transportscoreforiphone.foregroundColor = [UIColor blackColor].CGColor;
            [transportgroupforiphone addSublayer:transportscoreforiphone];
            self.layers[@"transportscoreforiphone"] = transportscoreforiphone;
                
            }
            
            CALayer * transportforiphone = [CALayer layer];
            transportforiphone.frame    = CGRectMake(3.72, 1.93, 9.62, 8);
            transportforiphone.contents = (id)[UIImage imageNamed:@"transport"].CGImage;
            [transportgroupforiphone addSublayer:transportforiphone];
            self.layers[@"transportforiphone"] = transportforiphone;
            CATextLayer * transportlabelforiphone = [CATextLayer layer];
            transportlabelforiphone.frame         = CGRectMake(17.84, 3, 94.54, 15.86);
            transportlabelforiphone.contentsScale = [[UIScreen mainScreen] scale];
            transportlabelforiphone.string        = @"TRANSPORTATION\n";
            transportlabelforiphone.font          = (__bridge CFTypeRef)@"GothamBook";
            transportlabelforiphone.fontSize      = 9;
            transportlabelforiphone.alignmentMode = kCAAlignmentLeft;
            transportlabelforiphone.foregroundColor = [UIColor blackColor].CGColor;
            [transportgroupforiphone addSublayer:transportlabelforiphone];
            self.layers[@"transportlabelforiphone"] = transportlabelforiphone;
                 }
        
        CALayer * wastegroupforiphone = [CALayer layer];
        wastegroupforiphone.frame = CGRectMake(1.12, 38.93, 245.98, 228.4);
        
        [plaquegroupforiphone addSublayer:wastegroupforiphone];
        self.layers[@"wastegroupforiphone"] = wastegroupforiphone;
        {
            CAShapeLayer * wastebackforiphone = [CAShapeLayer layer];
            wastebackforiphone.frame       = CGRectMake(0, 6.05, 245.98, 194.84);
            wastebackforiphone.fillColor   = nil;
            wastebackforiphone.strokeColor = [UIColor colorWithRed:0.835 green: 0.835 blue:0.835 alpha:1].CGColor;
            wastebackforiphone.lineWidth   = 15;
            wastebackforiphone.path        = [self wastebackforiphonePath].CGPath;
            [wastegroupforiphone addSublayer:wastebackforiphone];
            self.layers[@"wastebackforiphone"] = wastebackforiphone;
            
            CATextLayer * wastemaxscoreforiphone = [CATextLayer layer];
            wastemaxscoreforiphone.frame           = CGRectMake(46.23, 63.43, 10, 10);
            wastemaxscoreforiphone.contentsScale   = [[UIScreen mainScreen] scale];
            wastemaxscoreforiphone.string          = [NSString stringWithFormat:@"%d",mwaste];
            wastemaxscoreforiphone.font            = (__bridge CFTypeRef)@"GothamBook";
            wastemaxscoreforiphone.fontSize        = 8;
            wastemaxscoreforiphone.alignmentMode   = kCAAlignmentCenter;
            wastemaxscoreforiphone.foregroundColor = [UIColor blackColor].CGColor;
            [wastegroupforiphone addSublayer:wastemaxscoreforiphone];
            self.layers[@"wastemaxscoreforiphone"] = wastemaxscoreforiphone;

            
            if(waste>=1){
            CAShapeLayer * wastestartpathforiphone = [CAShapeLayer layer];
            wastestartpathforiphone.frame       = CGRectMake(2.06, 6.06, 147, 0);
            wastestartpathforiphone.fillColor   = nil;
            wastestartpathforiphone.strokeColor = [UIColor colorWithRed:0.468 green: 0.755 blue:0.629 alpha:1].CGColor;
            wastestartpathforiphone.lineWidth   = 15;
            wastestartpathforiphone.path        = [self wastestartpathforiphonePath].CGPath;
            [wastegroupforiphone addSublayer:wastestartpathforiphone];
            self.layers[@"wastestartpathforiphone"] = wastestartpathforiphone;
            CAShapeLayer * wastestartingforiphone = [CAShapeLayer layer];
            wastestartingforiphone.frame       = CGRectMake(50.88, 5.96, 195, 195);
            wastestartingforiphone.fillColor   = nil;
            wastestartingforiphone.strokeColor = [UIColor colorWithRed:0.461 green: 0.76 blue:0.629 alpha:1].CGColor;
            wastestartingforiphone.lineWidth   = 15;
            wastestartingforiphone.strokeEnd   = 0;
            wastestartingforiphone.path        = [self wastestartingforiphonePath].CGPath;
            [wastegroupforiphone addSublayer:wastestartingforiphone];
            self.layers[@"wastestartingforiphone"] = wastestartingforiphone;
            CAShapeLayer * wastearrowforiphone = [CAShapeLayer layer];
            wastearrowforiphone.frame     = CGRectMake(85.1, 72.28, 10, 10);
            [wastearrowforiphone setValue:@(-45 * M_PI/180) forKeyPath:@"transform.rotation"];
            wastearrowforiphone.fillColor = [UIColor colorWithRed:0.459 green: 0.757 blue:0.627 alpha:1].CGColor;
            wastearrowforiphone.lineWidth = 0;
            wastearrowforiphone.path      = [self wastearrowforiphonePath].CGPath;
            [wastegroupforiphone addSublayer:wastearrowforiphone];
            self.layers[@"wastearrowforiphone"] = wastearrowforiphone;
            wastescoreforiphone = [CATextLayer layer];
            wastescoreforiphone.frame           = CGRectMake(21.26, 218.36, 10.76, 10.04);
            wastescoreforiphone.contentsScale   = [[UIScreen mainScreen] scale];
            wastescoreforiphone.string          = @"0";
            wastescoreforiphone.font            = (__bridge CFTypeRef)@"GothamBook";
            wastescoreforiphone.fontSize        = 8;
            wastescoreforiphone.alignmentMode   = kCAAlignmentCenter;
            wastescoreforiphone.foregroundColor = [UIColor blackColor].CGColor;
            [wastegroupforiphone addSublayer:wastescoreforiphone];
            self.layers[@"wastescoreforiphone"] = wastescoreforiphone;
            }
            CALayer * wasteforiphone = [CALayer layer];
            wasteforiphone.frame    = CGRectMake(3.69, 2.43, 9.28, 9);
            wasteforiphone.contents = (id)[UIImage imageNamed:@"waste"].CGImage;
            [wastegroupforiphone addSublayer:wasteforiphone];
            self.layers[@"wasteforiphone"] = wasteforiphone;
            CATextLayer * wastelabelforiphone = [CATextLayer layer];
            wastelabelforiphone.frame           = CGRectMake(18, 3, 34.54, 15.86);
            wastelabelforiphone.contentsScale   = [[UIScreen mainScreen] scale];
            wastelabelforiphone.string          = @"WASTE";
            wastelabelforiphone.font            = (__bridge CFTypeRef)@"GothamBook";
            wastelabelforiphone.fontSize        = 9;
            wastelabelforiphone.alignmentMode   = kCAAlignmentLeft;
            wastelabelforiphone.foregroundColor = [UIColor blackColor].CGColor;
            [wastegroupforiphone addSublayer:wastelabelforiphone];
            self.layers[@"wastelabelforiphone"] = wastelabelforiphone;
           }
        
        CALayer * watergroupforiphone = [CALayer layer];
        watergroupforiphone.frame = CGRectMake(0.56, 19.43, 266.44, 247.9);
        
        [plaquegroupforiphone addSublayer:watergroupforiphone];
        self.layers[@"watergroupforiphone"] = watergroupforiphone;
        {
            CAShapeLayer * waterbackforiphone = [CAShapeLayer layer];
            waterbackforiphone.frame       = CGRectMake(0, 5.63, 266.44, 234.66);
            waterbackforiphone.fillColor   = nil;
            waterbackforiphone.strokeColor = [UIColor colorWithRed:0.835 green: 0.835 blue:0.835 alpha:1].CGColor;
            waterbackforiphone.lineWidth   = 15;
            waterbackforiphone.path        = [self waterbackforiphonePath].CGPath;
            [watergroupforiphone addSublayer:waterbackforiphone];
            self.layers[@"waterbackforiphone"] = waterbackforiphone;
            
            CATextLayer * watermaxscoreforiphone = [CATextLayer layer];
            watermaxscoreforiphone.frame           = CGRectMake(25.83, 82.93, 10, 10);
            watermaxscoreforiphone.contentsScale   = [[UIScreen mainScreen] scale];
            watermaxscoreforiphone.string          = [NSString stringWithFormat:@"%d",mwater];
            watermaxscoreforiphone.font            = (__bridge CFTypeRef)@"GothamBook";
            watermaxscoreforiphone.fontSize        = 8;
            watermaxscoreforiphone.alignmentMode   = kCAAlignmentCenter;
            watermaxscoreforiphone.foregroundColor = [UIColor blackColor].CGColor;
            [watergroupforiphone addSublayer:watermaxscoreforiphone];
            self.layers[@"watermaxscoreforiphone"] = watermaxscoreforiphone;

            
            if(water>=1){
            CAShapeLayer * waterstartpathforiphone = [CAShapeLayer layer];
            waterstartpathforiphone.frame       = CGRectMake(2.63, 5.46, 147, 0);
            waterstartpathforiphone.fillColor   = nil;
            waterstartpathforiphone.strokeColor = [UIColor colorWithRed:0.32 green: 0.751 blue:0.93 alpha:1].CGColor;
            waterstartpathforiphone.lineWidth   = 15;
            waterstartpathforiphone.path        = [self waterstartpathforiphonePath].CGPath;
            [watergroupforiphone addSublayer:waterstartpathforiphone];
            self.layers[@"waterstartpathforiphone"] = waterstartpathforiphone;
            CAShapeLayer * waterstartingforiphone = [CAShapeLayer layer];
            waterstartingforiphone.frame       = CGRectMake(31.28, 5.43, 235, 235);
            waterstartingforiphone.fillColor   = nil;
            waterstartingforiphone.strokeColor = [UIColor colorWithRed:0.303 green: 0.751 blue:0.94 alpha:1].CGColor;
            waterstartingforiphone.lineWidth   = 15;
            waterstartingforiphone.strokeEnd   = 0;
            waterstartingforiphone.path        = [self waterstartingforiphonePath].CGPath;
            [watergroupforiphone addSublayer:waterstartingforiphone];
            self.layers[@"waterstartingforiphone"] = waterstartingforiphone;
            CAShapeLayer * waterarrowforiphone = [CAShapeLayer layer];
            waterarrowforiphone.frame     = CGRectMake(85.67, 91.78, 10, 10);
            [waterarrowforiphone setValue:@(-45 * M_PI/180) forKeyPath:@"transform.rotation"];
            waterarrowforiphone.fillColor = [UIColor colorWithRed:0.306 green: 0.749 blue:0.941 alpha:1].CGColor;
            waterarrowforiphone.lineWidth = 0;
            waterarrowforiphone.path      = [self waterarrowforiphonePath].CGPath;
            [watergroupforiphone addSublayer:waterarrowforiphone];
            self.layers[@"waterarrowforiphone"] = waterarrowforiphone;
            waterscoreforiphone = [CATextLayer layer];
            waterscoreforiphone.frame           = CGRectMake(21.83, 237.86, 10.76, 10.04);
            waterscoreforiphone.contentsScale   = [[UIScreen mainScreen] scale];
            waterscoreforiphone.string          = @"0";
            waterscoreforiphone.font            = (__bridge CFTypeRef)@"GothamBook";
            waterscoreforiphone.fontSize        = 8;
            waterscoreforiphone.alignmentMode   = kCAAlignmentCenter;
            waterscoreforiphone.foregroundColor = [UIColor blackColor].CGColor;
            [watergroupforiphone addSublayer:waterscoreforiphone];
            self.layers[@"waterscoreforiphone"] = waterscoreforiphone;
            }
            CALayer * waterforiphone = [CALayer layer];
            waterforiphone.frame    = CGRectMake(5.94, 1.43, 5.06, 9);
            waterforiphone.contents = (id)[UIImage imageNamed:@"water"].CGImage;
            [watergroupforiphone addSublayer:waterforiphone];
            self.layers[@"waterforiphone"] = waterforiphone;
            CATextLayer * waterlabelforiphone = [CATextLayer layer];
            waterlabelforiphone.frame           = CGRectMake(18.06, 3, 55.46, 15.86);
            waterlabelforiphone.contentsScale   = [[UIScreen mainScreen] scale];
            waterlabelforiphone.string          = @"WATER\n";
            waterlabelforiphone.font            = (__bridge CFTypeRef)@"GothamBook";
            waterlabelforiphone.fontSize        = 9;
            waterlabelforiphone.alignmentMode   = kCAAlignmentLeft;
            waterlabelforiphone.foregroundColor = [UIColor blackColor].CGColor;
            [watergroupforiphone addSublayer:waterlabelforiphone];
            self.layers[@"waterlabelforiphone"] = waterlabelforiphone;
              }
        
        CALayer * energygroupforiphone = [CALayer layer];
        energygroupforiphone.frame = CGRectMake(1.58, -0.36, 285.42, 280.72);
        
        [plaquegroupforiphone addSublayer:energygroupforiphone];
        self.layers[@"energygroupforiphone"] = energygroupforiphone;
        {
            CAShapeLayer * energybackforiphone = [CAShapeLayer layer];
            energybackforiphone.frame       = CGRectMake(0, 5.73, 285.42, 274.86);
            energybackforiphone.fillColor   = nil;
            energybackforiphone.strokeColor = [UIColor colorWithRed:0.835 green: 0.835 blue:0.835 alpha:1].CGColor;
            energybackforiphone.lineWidth   = 15;
            energybackforiphone.path        = [self energybackforiphonePath].CGPath;
            [energygroupforiphone addSublayer:energybackforiphone];
            self.layers[@"energybackforiphone"] = energybackforiphone;
            
            CATextLayer * energymaxscoreforiphone = [CATextLayer layer];
            energymaxscoreforiphone.frame         = CGRectMake(6.81, 102.71, 10, 10);
            energymaxscoreforiphone.contentsScale = [[UIScreen mainScreen] scale];
            energymaxscoreforiphone.string        = [NSString stringWithFormat:@"%d",menergy];
            energymaxscoreforiphone.font          = (__bridge CFTypeRef)@"GothamBook";
            energymaxscoreforiphone.fontSize      = 8;
            energymaxscoreforiphone.alignmentMode = kCAAlignmentCenter;
            energymaxscoreforiphone.foregroundColor = [UIColor blackColor].CGColor;
            [energygroupforiphone addSublayer:energymaxscoreforiphone];
            self.layers[@"energymaxscoreforiphone"] = energymaxscoreforiphone;

            
            if(energy>=1){
            CAShapeLayer * energystartingforiphone = [CAShapeLayer layer];
            energystartingforiphone.frame       = CGRectMake(9.74, 5.72, 275, 275);
            energystartingforiphone.fillColor   = nil;
            energystartingforiphone.strokeColor = [UIColor colorWithRed:0.776 green: 0.859 blue:0.122 alpha:1].CGColor;
            energystartingforiphone.lineWidth   = 15;
            energystartingforiphone.strokeEnd   = 0;
            energystartingforiphone.path        = [self energystartingforiphonePath].CGPath;
            [energygroupforiphone addSublayer:energystartingforiphone];
            self.layers[@"energystartingforiphone"] = energystartingforiphone;
            CAShapeLayer * energyarrowforiphone = [CAShapeLayer layer];
            energyarrowforiphone.frame     = CGRectMake(121.01, -24.76, 10, 10);
            [energyarrowforiphone setValue:@(-45 * M_PI/180) forKeyPath:@"transform.rotation"];
            energyarrowforiphone.fillColor = [UIColor colorWithRed:0.776 green: 0.859 blue:0.122 alpha:1].CGColor;
            energyarrowforiphone.lineWidth = 0;
            energyarrowforiphone.path      = [self energyarrowforiphonePath].CGPath;
            [energygroupforiphone addSublayer:energyarrowforiphone];
            self.layers[@"energyarrowforiphone"] = energyarrowforiphone;
            energyscoreforiphone = [CATextLayer layer];
            energyscoreforiphone.frame           = CGRectMake(29.88, 146.65, 10.76, 10.04);
            energyscoreforiphone.contentsScale   = [[UIScreen mainScreen] scale];
            energyscoreforiphone.string          = @"0";
            energyscoreforiphone.font            = (__bridge CFTypeRef)@"GothamBook";
            energyscoreforiphone.fontSize        = 8;
            energyscoreforiphone.alignmentMode   = kCAAlignmentCenter;
            energyscoreforiphone.foregroundColor = [UIColor blackColor].CGColor;
            [energygroupforiphone addSublayer:energyscoreforiphone];
            self.layers[@"energyscoreforiphone"] = energyscoreforiphone;
            CAShapeLayer * energystartpathforiphone = [CAShapeLayer layer];
            energystartpathforiphone.frame       = CGRectMake(1.6, 5.86, 147, 0);
            energystartpathforiphone.fillColor   = nil;
            energystartpathforiphone.strokeColor = [UIColor colorWithRed:0.776 green: 0.859 blue:0.122 alpha:1].CGColor;
            energystartpathforiphone.lineWidth   = 15;
            energystartpathforiphone.path        = [self energystartpathforiphonePath].CGPath;
            [energygroupforiphone addSublayer:energystartpathforiphone];
            self.layers[@"energystartpathforiphone"] = energystartpathforiphone;
            }
            CALayer * energyforiphone = [CALayer layer];
            energyforiphone.frame    = CGRectMake(4.92, 2.05, 6.07, 10.3);
            energyforiphone.contents = (id)[UIImage imageNamed:@"energy"].CGImage;
            [energygroupforiphone addSublayer:energyforiphone];
            self.layers[@"energyforiphone"] = energyforiphone;
            CATextLayer * energylabelforiphone = [CATextLayer layer];
            energylabelforiphone.frame           = CGRectMake(17.04, 3, 55.46, 15.86);
            energylabelforiphone.contentsScale   = [[UIScreen mainScreen] scale];
            energylabelforiphone.string          = @"ENERGY";
            energylabelforiphone.font            = (__bridge CFTypeRef)@"GothamBook";
            energylabelforiphone.fontSize        = 9;
            energylabelforiphone.alignmentMode   = kCAAlignmentLeft;
            energylabelforiphone.foregroundColor = [UIColor blackColor].CGColor;
            [energygroupforiphone addSublayer:energylabelforiphone];
            self.layers[@"energylabelforiphone"] = energylabelforiphone;
              }
        
    [self addIphoneanimationAnimation];
    }
    }
        }
        else {
            row=(int)[prefs integerForKey:@"row"];
            UIColor *color;
            if(row==1){
                actual=energy;
                maxx=menergy;
                middleactual=[[prefs objectForKey:@"middleenergy"] intValue];
                inneractual=[[prefs objectForKey:@"innerenergy"] intValue];
                if(tempdict[@"energy_avg"] != [NSNull null]){
                    localavg = [tempdict[@"energy_avg"] intValue];
                }else{
                    localavg = 0;
                }
                if(dict[@"energy_avg"] != [NSNull null]){
                    globalavg = [dict[@"energy_avg"] intValue];
                }else{
                    globalavg = 0;
                }
                color=[UIColor colorWithRed:0.776 green: 0.859 blue:0.122 alpha:1]; //Energy
            }
            else if(row==2){
                actual=water;
                maxx=mwater;
                middleactual=[[prefs objectForKey:@"middlewater"] intValue];
                inneractual=[[prefs objectForKey:@"innerwater"] intValue];
                if(tempdict[@"water_avg"] != [NSNull null]){
                    localavg = [tempdict[@"water_avg"] intValue];
                }else{
                    localavg = 0;
                }
                if(dict[@"water_avg"] != [NSNull null]){
                    globalavg = [dict[@"water_avg"] intValue];
                }else{
                    globalavg = 0;
                }
                color=[UIColor colorWithRed:0.259 green: 0.741 blue:0.961 alpha:1];
            }
            else if(row==3){
                actual=waste;
                maxx=mwaste;
                middleactual=[[prefs objectForKey:@"middlewaste"] intValue];
                inneractual=[[prefs objectForKey:@"innerwaste"] intValue];
                if(tempdict[@"waste_avg"] != [NSNull null]){
                    localavg = [tempdict[@"waste_avg"] intValue];
                }else{
                    localavg = 0;
                }
                if(dict[@"waste_avg"] != [NSNull null]){
                    globalavg = [dict[@"waste_avg"] intValue];
                }else{
                    globalavg = 0;
                }
                color=[UIColor colorWithRed:0.443 green: 0.769 blue:0.624 alpha:1];
            }
            else if(row==4){
                actual=transport;
                maxx=mtransport;
                middleactual=[[prefs objectForKey:@"middletransport"] intValue];
                inneractual=[[prefs objectForKey:@"innertransport"] intValue];
                if(tempdict[@"transport_avg"] != [NSNull null]){
                    localavg = [tempdict[@"transport_avg"] intValue];
                }else{
                    localavg = 0;
                }
                if(dict[@"transport_avg"] != [NSNull null]){
                    globalavg = [dict[@"transport_avg"] intValue];
                }else{
                    globalavg = 0;
                }
                
                color=[UIColor colorWithRed:0.573 green: 0.557 blue:0.498 alpha:1];
            }
            else if(row==5){
                actual=human;
                maxx=mhuman;
                middleactual=[[prefs objectForKey:@"middlehuman"] intValue];
                inneractual=[[prefs objectForKey:@"innerhuman"] intValue];
                if(tempdict[@"human_experience_avg"] != [NSNull null]){
                    localavg = [tempdict[@"human_experience_avg"] intValue];
                }else{
                    localavg = 0;
                }
                if(dict[@"human_experience_avg"] != [NSNull null]){
                    globalavg = [dict[@"human_experience_avg"] intValue];
                }else{
                    globalavg = 0;
                }
                color=[UIColor colorWithRed:0.937 green: 0.62 blue:0.153 alpha:1];
            }
            
            self.backgroundColor = [UIColor colorWithRed:0.918 green: 0.918 blue:0.918 alpha:1];
            
            CALayer * individualforiphone = [CALayer layer];
            individualforiphone.frame = CGRectMake(14.56, 64.13, 295, 322.38);
            if(width==375 && height==667){
            individualforiphone.frame = CGRectMake(44.56, 80.13, 295, 322.38);
            }else if(width==320 && height==480){
                individualforiphone.frame = CGRectMake(14.56, 50.13, 295, 322.38);
            }
            else if(width==320 && height==568){
                 individualforiphone.frame = CGRectMake(14.56, 34.13, 295, 322.38);
            }
             else if (width==414 && height==736){
                individualforiphone.frame = CGRectMake(64.56, 60.13, 295, 322.38);
             }
            [self.layer addSublayer:individualforiphone];
            self.layers[@"individualforiphone"] = individualforiphone;
            {
                CALayer * individualplaqueforiphone = [CALayer layer];
                individualplaqueforiphone.frame = CGRectMake(26.06, 0, 218.88, 273.37);
                
                [individualforiphone addSublayer:individualplaqueforiphone];
                self.layers[@"individualplaqueforiphone"] = individualplaqueforiphone;
                {
                    CAShapeLayer * centercircleforiphone = [CAShapeLayer layer];
                    centercircleforiphone.frame     = CGRectMake(93.28, 146.95, 56.21, 56);
                    centercircleforiphone.fillColor = [UIColor colorWithRed:0.831 green: 0.831 blue:0.831 alpha:1].CGColor;//[UIColor colorWithRed:0.333 green: 0.376 blue:0.388 alpha:1].CGColor;
                    centercircleforiphone.lineWidth = 0;
                    centercircleforiphone.path      = [self centercircleforiphonePath].CGPath;
                    [individualplaqueforiphone addSublayer:centercircleforiphone];
                    self.layers[@"centercircleforiphone"] = centercircleforiphone;
                    CAShapeLayer * innerbackforiphone = [CAShapeLayer layer];
                    innerbackforiphone.frame       = CGRectMake(0.09, 135.04, 162.3, 81.83);
                    innerbackforiphone.fillColor   = nil;
                    innerbackforiphone.strokeColor = [UIColor colorWithRed:0.831 green: 0.831 blue:0.831 alpha:1].CGColor;
                    innerbackforiphone.lineWidth   = 15;
                    innerbackforiphone.path        = [self innerbackforiphonePath].CGPath;
                    [individualplaqueforiphone addSublayer:innerbackforiphone];
                    self.layers[@"innerbackforiphone"] = innerbackforiphone;
                    
                    CATextLayer * innermaxscoreforiphone = [CATextLayer layer];
                    innermaxscoreforiphone.frame           = CGRectMake(75.68, 151.89, 10.06, 10.79);
                    innermaxscoreforiphone.contentsScale   = [[UIScreen mainScreen] scale];
                    innermaxscoreforiphone.string          = [NSString stringWithFormat:@"%d",maxx];
                    innermaxscoreforiphone.font            = (__bridge CFTypeRef)@"GothamBook";
                    innermaxscoreforiphone.fontSize        = 7;
                    innermaxscoreforiphone.alignmentMode   = kCAAlignmentCenter;
                    innermaxscoreforiphone.foregroundColor = [UIColor blackColor].CGColor;
                    [individualplaqueforiphone addSublayer:innermaxscoreforiphone];
                    self.layers[@"innermaxscoreforiphone"] = innermaxscoreforiphone;

                    if(inneractual>0){
                    CALayer * innergroupforiphone = [CALayer layer];
                    innergroupforiphone.frame = CGRectMake(1.09, 0, 161.3, 216.77);
                    
                    [individualplaqueforiphone addSublayer:innergroupforiphone];
                    self.layers[@"innergroupforiphone"] = innergroupforiphone;
                    {
                        CAShapeLayer * innerstartpathforiphone = [CAShapeLayer layer];
                        innerstartpathforiphone.frame       = CGRectMake(0, 134.54, 121, 0);
                        innerstartpathforiphone.fillColor   = nil;
                        innerstartpathforiphone.strokeColor = color.CGColor;
                        innerstartpathforiphone.lineWidth   = 15;
                        innerstartpathforiphone.strokeEnd   = 0;
                        innerstartpathforiphone.path        = [self innerstartpathforiphonePath].CGPath;
                        [innergroupforiphone addSublayer:innerstartpathforiphone];
                        self.layers[@"innerstartpathforiphone"] = innerstartpathforiphone;
                        CAShapeLayer * innerstartingforiphone = [CAShapeLayer layer];
                        innerstartingforiphone.frame       = CGRectMake(79.3, 134.77, 82, 82);
                        innerstartingforiphone.fillColor   = nil;
                        innerstartingforiphone.strokeColor = color.CGColor;
                        innerstartingforiphone.lineWidth   = 15;
                        innerstartingforiphone.strokeEnd   = 0;
                        innerstartingforiphone.path        = [self innerstartingforiphonePath].CGPath;
                        [innergroupforiphone addSublayer:innerstartingforiphone];
                        self.layers[@"innerstartingforiphone"] = innerstartingforiphone;
                        CAShapeLayer * innerarrowforiphone = [CAShapeLayer layer];
                        innerarrowforiphone.frame     = CGRectMake(96.15, 82.21, 10, 10);
                        [innerarrowforiphone setValue:@(-45 * M_PI/180) forKeyPath:@"transform.rotation"];
                        innerarrowforiphone.fillColor = color.CGColor;
                        innerarrowforiphone.lineWidth = 0;
                        innerarrowforiphone.path      = [self innerarrowforiphonePath].CGPath;
                        [innergroupforiphone addSublayer:innerarrowforiphone];
                        self.layers[@"innerarrowforiphone"] = innerarrowforiphone;
                        innerscoreforiphone = [CATextLayer layer];
                        innerscoreforiphone.frame           = CGRectMake(33.76, 0, 11.34, 10.54);
                        innerscoreforiphone.contentsScale   = [[UIScreen mainScreen] scale];
                        innerscoreforiphone.string          = @"0";
                        innerscoreforiphone.font            = (__bridge CFTypeRef)@"GothamBook";
                        innerscoreforiphone.fontSize        = 7;
                        innerscoreforiphone.alignmentMode   = kCAAlignmentCenter;
                        innerscoreforiphone.foregroundColor = [UIColor blackColor].CGColor;
                        [innergroupforiphone addSublayer:innerscoreforiphone];
                        self.layers[@"innerscoreforiphone"] = innerscoreforiphone;
                    }
                    }
                    
                    CATextLayer * lastyearforiphone = [CATextLayer layer];
                    lastyearforiphone.frame           = CGRectMake(18.77, 131.54, 80, 12.77);
                    lastyearforiphone.contentsScale   = [[UIScreen mainScreen] scale];
                    lastyearforiphone.string          = [NSString stringWithFormat:@"%@",[prefs objectForKey:@"lastyear"]];
                    lastyearforiphone.font            = (__bridge CFTypeRef)@"GothamBook";
                    lastyearforiphone.fontSize        = 7;
                    lastyearforiphone.alignmentMode   = kCAAlignmentLeft;
                    lastyearforiphone.foregroundColor = [UIColor blackColor].CGColor;
                    [individualplaqueforiphone addSublayer:lastyearforiphone];
                    self.layers[@"lastyearforiphone"] = lastyearforiphone;
                    CAShapeLayer * middlebackforiphone = [CAShapeLayer layer];
                    middlebackforiphone.frame       = CGRectMake(0.2, 113.87, 183.19, 124);
                    middlebackforiphone.fillColor   = nil;
                    middlebackforiphone.strokeColor = [UIColor colorWithRed:0.831 green: 0.831 blue:0.831 alpha:1].CGColor;
                    middlebackforiphone.lineWidth   = 15;
                    middlebackforiphone.path        = [self middlebackforiphonePath].CGPath;
                    [individualplaqueforiphone addSublayer:middlebackforiphone];
                    self.layers[@"middlebackforiphone"] = middlebackforiphone;
                    
                    CATextLayer * middlemaxscoreforiphone = [CATextLayer layer];
                    middlemaxscoreforiphone.frame         = CGRectMake(54.74, 151.39, 10.06, 10.79);
                    middlemaxscoreforiphone.contentsScale = [[UIScreen mainScreen] scale];
                    middlemaxscoreforiphone.string        = [NSString stringWithFormat:@"%d",maxx];
                    middlemaxscoreforiphone.font          = (__bridge CFTypeRef)@"GothamBook";
                    middlemaxscoreforiphone.fontSize      = 7;
                    middlemaxscoreforiphone.alignmentMode = kCAAlignmentCenter;
                    middlemaxscoreforiphone.foregroundColor = [UIColor blackColor].CGColor;
                    [individualplaqueforiphone addSublayer:middlemaxscoreforiphone];
                    self.layers[@"middlemaxscoreforiphone"] = middlemaxscoreforiphone;
                    
                    if(middleactual>0){
                    CALayer * middlegroupforiphone = [CALayer layer];
                    middlegroupforiphone.frame = CGRectMake(1.09, 0, 182.3, 237.95);
                    
                    [individualplaqueforiphone addSublayer:middlegroupforiphone];
                    self.layers[@"middlegroupforiphone"] = middlegroupforiphone;
                    {
                        CAShapeLayer * middlestartpathforiphone = [CAShapeLayer layer];
                        middlestartpathforiphone.frame       = CGRectMake(0, 113.87, 121, 0);
                        middlestartpathforiphone.fillColor   = nil;
                        middlestartpathforiphone.strokeColor =color.CGColor;
                        middlestartpathforiphone.lineWidth   = 15;
                        middlestartpathforiphone.strokeEnd   = 0;
                        middlestartpathforiphone.path        = [self middlestartpathforiphonePath].CGPath;
                        [middlegroupforiphone addSublayer:middlestartpathforiphone];
                        self.layers[@"middlestartpathforiphone"] = middlestartpathforiphone;
                        CAShapeLayer * middlestartingforiphone = [CAShapeLayer layer];
                        middlestartingforiphone.frame       = CGRectMake(58.3, 113.95, 124, 124);
                        middlestartingforiphone.fillColor   = nil;
                        middlestartingforiphone.strokeColor = color.CGColor;
                        middlestartingforiphone.lineWidth   = 15;
                        middlestartingforiphone.strokeEnd   = 0;
                        middlestartingforiphone.path        = [self middlestartingforiphonePath].CGPath;
                        [middlegroupforiphone addSublayer:middlestartingforiphone];
                        self.layers[@"middlestartingforiphone"] = middlestartingforiphone;
                        CAShapeLayer * middlearrowforiphone = [CAShapeLayer layer];
                        middlearrowforiphone.frame     = CGRectMake(96.15, 82.21, 10, 10);
                        [middlearrowforiphone setValue:@(-45 * M_PI/180) forKeyPath:@"transform.rotation"];
                        middlearrowforiphone.fillColor = color.CGColor;
                        middlearrowforiphone.lineWidth = 0;
                        middlearrowforiphone.path      = [self middlearrowforiphonePath].CGPath;
                        [middlegroupforiphone addSublayer:middlearrowforiphone];
                        self.layers[@"middlearrowforiphone"] = middlearrowforiphone;
                       
                        middlescoreforiphone = [CATextLayer layer];
                        middlescoreforiphone.frame           = CGRectMake(33.76, 0, 11.34, 10.54);
                        middlescoreforiphone.contentsScale   = [[UIScreen mainScreen] scale];
                        middlescoreforiphone.string          = @"0";
                        middlescoreforiphone.font            = (__bridge CFTypeRef)@"GothamBook";
                        middlescoreforiphone.fontSize        = 7;
                        middlescoreforiphone.alignmentMode   = kCAAlignmentCenter;
                        middlescoreforiphone.foregroundColor = [UIColor blackColor].CGColor;
                        [middlegroupforiphone addSublayer:middlescoreforiphone];
                        self.layers[@"middlescoreforiphone"] = middlescoreforiphone;
                    }
                    }
                    CATextLayer * lastmonthforiphone = [CATextLayer layer];
                    lastmonthforiphone.frame           = CGRectMake(18.77, 109.37, 80, 12.77);
                    lastmonthforiphone.contentsScale   = [[UIScreen mainScreen] scale];
                    lastmonthforiphone.string          = [NSString stringWithFormat:@"%@",[prefs objectForKey:@"lastmonth"]];
                    lastmonthforiphone.font            = (__bridge CFTypeRef)@"GothamBook";
                    lastmonthforiphone.fontSize        = 7;
                    lastmonthforiphone.alignmentMode   = kCAAlignmentLeft;
                    lastmonthforiphone.foregroundColor = [UIColor blackColor].CGColor;
                    [individualplaqueforiphone addSublayer:lastmonthforiphone];
                    self.layers[@"lastmonthforiphone"] = lastmonthforiphone;
                    CAShapeLayer * outerbackforiphone = [CAShapeLayer layer];
                    outerbackforiphone.frame       = CGRectMake(0, 78.44, 218.88, 194.93);
                    outerbackforiphone.fillColor   = nil;
                    outerbackforiphone.strokeColor = [UIColor colorWithRed:0.831 green: 0.831 blue:0.831 alpha:1].CGColor;
                    outerbackforiphone.lineWidth   = 45;
                    outerbackforiphone.path        = [self outerbackforiphonePath].CGPath;
                    [individualplaqueforiphone addSublayer:outerbackforiphone];
                    self.layers[@"outerbackforiphone"] = outerbackforiphone;
                    
                    CATextLayer * outermaxscoreforiphone = [CATextLayer layer];
                    outermaxscoreforiphone.frame           = CGRectMake(18.77, 150.89, 10.06, 10.79);
                    outermaxscoreforiphone.contentsScale   = [[UIScreen mainScreen] scale];
                    outermaxscoreforiphone.string          = [NSString stringWithFormat:@"%d",maxx];
                    outermaxscoreforiphone.font            = (__bridge CFTypeRef)@"GothamBook";
                    outermaxscoreforiphone.fontSize        = 7;
                    outermaxscoreforiphone.alignmentMode   = kCAAlignmentCenter;
                    outermaxscoreforiphone.foregroundColor = [UIColor blackColor].CGColor;
                    [individualplaqueforiphone addSublayer:outermaxscoreforiphone];
                    self.layers[@"outermaxscoreforiphone"] = outermaxscoreforiphone;
                   
                    if(actual>0){
                    CALayer * outergroupforiphone = [CALayer layer];
                    outergroupforiphone.frame = CGRectMake(1.09, 0, 217.8, 272.45);
                    
                    [individualplaqueforiphone addSublayer:outergroupforiphone];
                    self.layers[@"outergroupforiphone"] = outergroupforiphone;
                    {
                        CAShapeLayer * outerstartpathforiphone = [CAShapeLayer layer];
                        outerstartpathforiphone.frame       = CGRectMake(0, 78, 121, 0);
                        outerstartpathforiphone.fillColor   = nil;
                        outerstartpathforiphone.strokeColor = color.CGColor;
                        outerstartpathforiphone.lineWidth   = 45;
                        outerstartpathforiphone.strokeEnd   = 0;
                        outerstartpathforiphone.path        = [self outerstartpathforiphonePath].CGPath;
                        [outergroupforiphone addSublayer:outerstartpathforiphone];
                        self.layers[@"outerstartpathforiphone"] = outerstartpathforiphone;
                        CAShapeLayer * outerstartingforiphone = [CAShapeLayer layer];
                        outerstartingforiphone.frame       = CGRectMake(22.8, 77.45, 195, 195);
                        outerstartingforiphone.fillColor   = nil;
                        outerstartingforiphone.strokeColor = color.CGColor;
                        outerstartingforiphone.lineWidth   = 45;
                        outerstartingforiphone.strokeEnd   = 0;
                        outerstartingforiphone.path        = [self outerstartingforiphonePath].CGPath;
                        [outergroupforiphone addSublayer:outerstartingforiphone];
                        self.layers[@"outerstartingforiphone"] = outerstartingforiphone;
                        CAShapeLayer * outerarrowforiphone = [CAShapeLayer layer];
                        outerarrowforiphone.frame     = CGRectMake(75.47, 60.21, 32, 32);
                        [outerarrowforiphone setValue:@(-45 * M_PI/180) forKeyPath:@"transform.rotation"];
                        outerarrowforiphone.fillColor = color.CGColor;
                        outerarrowforiphone.lineWidth = 0;
                        outerarrowforiphone.path      = [self outerarrowforiphonePath].CGPath;
                        [outergroupforiphone addSublayer:outerarrowforiphone];
                        self.layers[@"outerarrowforiphone"] = outerarrowforiphone;
                        outerscoreforiphone = [CATextLayer layer];
                        outerscoreforiphone.frame           = CGRectMake(33.76, 0, 11.34, 10.54);
                        outerscoreforiphone.contentsScale   = [[UIScreen mainScreen] scale];
                        outerscoreforiphone.string          = @"0";
                        outerscoreforiphone.font            = (__bridge CFTypeRef)@"GothamBook";
                        outerscoreforiphone.fontSize        = 7;
                        outerscoreforiphone.alignmentMode   = kCAAlignmentCenter;
                        outerscoreforiphone.foregroundColor = [UIColor blackColor].CGColor;
                        [outergroupforiphone addSublayer:outerscoreforiphone];
                        self.layers[@"outerscoreforiphone"] = outerscoreforiphone;
                    }
                    }
                    CATextLayer * toptitleforiphone = [CATextLayer layer];
                    toptitleforiphone.frame           = CGRectMake(16.77, 57, 91.17, 9.88);
                    toptitleforiphone.contentsScale   = [[UIScreen mainScreen] scale];
                    toptitleforiphone.string          = @"CURRENT";
                    toptitleforiphone.font            = (__bridge CFTypeRef)@"GothamBook";
                    toptitleforiphone.fontSize        = 8;
                    toptitleforiphone.alignmentMode   = kCAAlignmentLeft;
                    toptitleforiphone.foregroundColor = [UIColor blackColor].CGColor;
                    [individualplaqueforiphone addSublayer:toptitleforiphone];
                    self.layers[@"toptitleforiphone"] = toptitleforiphone;
                    CATextLayer * line1titleforiphone = [CATextLayer layer];
                    line1titleforiphone.frame           = CGRectMake(17.27, 65.38, 91.17, 6.88);
                    line1titleforiphone.contentsScale   = [[UIScreen mainScreen] scale];
                    line1titleforiphone.string          = @"Hello World!";
                    line1titleforiphone.font            = (__bridge CFTypeRef)@"GothamBook";
                    line1titleforiphone.fontSize        = 6;
                    line1titleforiphone.alignmentMode   = kCAAlignmentLeft;
                    line1titleforiphone.foregroundColor = [UIColor blackColor].CGColor;
                    [individualplaqueforiphone addSublayer:line1titleforiphone];
                    self.layers[@"line1titleforiphone"] = line1titleforiphone;
                    CATextLayer * line2titleforiphone = [CATextLayer layer];
                    line2titleforiphone.frame           = CGRectMake(17.27, 74.25, 91.17, 6.88);
                    line2titleforiphone.contentsScale   = [[UIScreen mainScreen] scale];
                    line2titleforiphone.string          = @"Hello World!";
                    line2titleforiphone.font            = (__bridge CFTypeRef)@"GothamBook";
                    line2titleforiphone.fontSize        = 6;
                    line2titleforiphone.alignmentMode   = kCAAlignmentLeft;
                    line2titleforiphone.foregroundColor = [UIColor blackColor].CGColor;
                    [individualplaqueforiphone addSublayer:line2titleforiphone];
                    self.layers[@"line2titleforiphone"] = line2titleforiphone;
                    CATextLayer * line3titleforiphone = [CATextLayer layer];
                    line3titleforiphone.frame           = CGRectMake(17.27, 82.19, 91.17, 6.88);
                    line3titleforiphone.contentsScale   = [[UIScreen mainScreen] scale];
                    line3titleforiphone.string          = @"Hello World!";
                    line3titleforiphone.font            = (__bridge CFTypeRef)@"GothamBook";
                    line3titleforiphone.fontSize        = 6;
                    line3titleforiphone.alignmentMode   = kCAAlignmentLeft;
                    line3titleforiphone.foregroundColor = [UIColor blackColor].CGColor;
                    [individualplaqueforiphone addSublayer:line3titleforiphone];
                    self.layers[@"line3titleforiphone"] = line3titleforiphone;
                    CATextLayer * line4titleforiphone = [CATextLayer layer];
                    line4titleforiphone.frame           = CGRectMake(17.27, 91.12, 91.17, 6.88);
                    line4titleforiphone.contentsScale   = [[UIScreen mainScreen] scale];
                    line4titleforiphone.string          = @"Hello World!";
                    line4titleforiphone.font            = (__bridge CFTypeRef)@"GothamBook";
                    line4titleforiphone.fontSize        = 6;
                    line4titleforiphone.alignmentMode   = kCAAlignmentLeft;
                    line4titleforiphone.foregroundColor = [UIColor blackColor].CGColor;
                    [individualplaqueforiphone addSublayer:line4titleforiphone];
                    self.layers[@"line4titleforiphone"] = line4titleforiphone;
                    CATextLayer * centerlabelforiphone = [CATextLayer layer];
                    centerlabelforiphone.frame           = CGRectMake(96.88, 170.51, 49, 8.94);
                    centerlabelforiphone.contentsScale   = [[UIScreen mainScreen] scale];
                    centerlabelforiphone.string          = @"Hello!\n";
                    centerlabelforiphone.font            = (__bridge CFTypeRef)@"GothamBook";
                    centerlabelforiphone.fontSize        = 5;
                    centerlabelforiphone.alignmentMode   = kCAAlignmentCenter;
                    centerlabelforiphone.foregroundColor = color.CGColor;
                    [individualplaqueforiphone addSublayer:centerlabelforiphone];
                    self.layers[@"centerlabelforiphone"] = centerlabelforiphone;

                    
                    if(row==1){
                        centerlabelforiphone.string=@"CURRENT ENERGY";
                        line1titleforiphone.string=@"Electricity";
                        line2titleforiphone.string=@"Gas";
                        line3titleforiphone.string=@"Smart meters";
                        line4titleforiphone.string=@"Load schedule";
                    }
                    else if(row==2){
                        centerlabelforiphone.string=@"CURRENT WATER";
                        line1titleforiphone.string=@"Water consumption";
                        line2titleforiphone.string=@"";
                        line3titleforiphone.string=@"";
                        line4titleforiphone.string=@"";
                    }
                    else if(row==3){
                        centerlabelforiphone.string=@"CURRENT WASTE";
                        line1titleforiphone.string=@"Waste generated ";
                        line2titleforiphone.string=@"Waste diverted";
                        line3titleforiphone.string=@"";
                        line4titleforiphone.string=@"";
                    }
                    else if(row==4){
                        centerlabelforiphone.string=@"CURRENT \nTRANSPORTATION";
                        line1titleforiphone.string=@"Occupant travel";
                        line2titleforiphone.string=@"";
                        line3titleforiphone.string=@"";
                        line4titleforiphone.string=@"";
                    }
                    else if(row==5){
                        centerlabelforiphone.string=@"CURRENT HUMAN\n EXPERIENCE";
                        line1titleforiphone.string=@"CO2 levels";
                        line2titleforiphone.string=@"VOC levels";
                        line3titleforiphone.string=@"Occupant satisfaction";
                        line4titleforiphone.string=@"";
                    }
                }
             if(globalavg>0 && actual>0){
                CALayer * needle = [CALayer layer];
                needle.frame    = CGRectMake(136.5, 44.48, 9, 7.2);
                [needle setValue:@(-64.08 * M_PI/180) forKeyPath:@"transform.rotation"];
                needle.contents = (id)[UIImage imageNamed:@"needle1"].CGImage;
                [individualforiphone addSublayer:needle];
                self.layers[@"needle"] = needle;
            }
                if(localavg>0 && actual>0){
                CALayer * needle2 = [CALayer layer];
                needle2.frame    = CGRectMake(159.94, 301.77, 9, 7.2);
                [needle2 setValue:@(-64 * M_PI/180) forKeyPath:@"transform.rotation"];
                needle2.contents = (id)[UIImage imageNamed:@"needle2"].CGImage;
                [individualforiphone addSublayer:needle2];
                self.layers[@"needle2"] = needle2;
                }
                
                CAShapeLayer * needle1pathforiphone = [CAShapeLayer layer];
                needle1pathforiphone.frame     = CGRectMake(17.5, 44.88, 260, 260);
                needle1pathforiphone.fillColor = nil;
                needle1pathforiphone.lineWidth = 0;
                needle1pathforiphone.path      = [self needle1pathforiphonePath].CGPath;
                [individualforiphone addSublayer:needle1pathforiphone];
                self.layers[@"needle1pathforiphone"] = needle1pathforiphone;
                CAShapeLayer * needle2pathforiphone = [CAShapeLayer layer];
                needle2pathforiphone.frame     = CGRectMake(17.5, 44.88, 260, 260);
                needle2pathforiphone.fillColor = nil;
                needle2pathforiphone.lineWidth = 0;
                needle2pathforiphone.path      = [self needle2pathforiphonePath].CGPath;
                [individualforiphone addSublayer:needle2pathforiphone];
                self.layers[@"needle2pathforiphone"] = needle2pathforiphone;
                if(localavg>0 && actual>0){
                CALayer * local = [CALayer layer];
                local.frame    = CGRectMake(138.5, 18, 22, 22);
                local.contents = (id)[UIImage imageNamed:@"local"].CGImage;
                [individualforiphone addSublayer:local];
                self.layers[@"local"] = local;
                }
                if(globalavg>0 && actual>0){
                CALayer * global = [CALayer layer];
                global.frame    = CGRectMake(138.5, 18, 22, 22);
                global.contents = (id)[UIImage imageNamed:@"global"].CGImage;
                [individualforiphone addSublayer:global];
                self.layers[@"global"] = global;
                }
                CAShapeLayer * localpathforiphone = [CAShapeLayer layer];
                localpathforiphone.frame     = CGRectMake(0, 27.38, 295, 295);
                localpathforiphone.fillColor = nil;
                localpathforiphone.lineWidth = 0;
                localpathforiphone.path      = [self localpathforiphonePath].CGPath;
                [individualforiphone addSublayer:localpathforiphone];
                self.layers[@"localpathforiphone"] = localpathforiphone;
                CAShapeLayer * globalpathforiphone = [CAShapeLayer layer];
                globalpathforiphone.frame     = CGRectMake(0, 27.38, 295, 295);
                globalpathforiphone.fillColor = nil;
                globalpathforiphone.lineWidth = 0;
                globalpathforiphone.path      = [self globalpathforiphonePath].CGPath;
                [individualforiphone addSublayer:globalpathforiphone];
                self.layers[@"globalpathforiphone"] = globalpathforiphone;
                CALayer * energy = [CALayer layer];
                energy.frame    = CGRectMake(32.06, 58.88, 5.89, 10);
                energy.contents = (id)[UIImage imageNamed:@"energy"].CGImage;

                CALayer * human = [CALayer layer];
                human.frame    = CGRectMake(31.54, 56.88, 6.42, 14);
                human.contents = (id)[UIImage imageNamed:@"human"].CGImage;

                CALayer * waste = [CALayer layer];
                waste.frame    = CGRectMake(29.33, 59.88, 11.34, 11);
                waste.contents = (id)[UIImage imageNamed:@"waste"].CGImage;

                CALayer * transport = [CALayer layer];
                transport.frame    = CGRectMake(28.99, 59.88, 12.02, 10);
                transport.contents = (id)[UIImage imageNamed:@"transport"].CGImage;

                CALayer * water = [CALayer layer];
                water.frame    = CGRectMake(32.06, 58.88, 5.62, 10);
                water.contents = (id)[UIImage imageNamed:@"water"].CGImage;
             
                CAShapeLayer * localavgscorepathforiphone = [CAShapeLayer layer];
                localavgscorepathforiphone.frame     = CGRectMake(49.94, 77.37, 195, 195);
                localavgscorepathforiphone.fillColor = nil;
                localavgscorepathforiphone.lineWidth = 0;
                localavgscorepathforiphone.strokeColor=[UIColor blackColor].CGColor;
                localavgscorepathforiphone.path      = [self localavgscorepathforiphonePath].CGPath;
                [individualforiphone addSublayer:localavgscorepathforiphone];
                self.layers[@"localavgscorepathforiphone"] = localavgscorepathforiphone;
             
                if(globalavg!=actual && globalavg>0 && actual>0){
                CATextLayer * globalavgscoreforiphone = [CATextLayer layer];
                globalavgscoreforiphone.frame         = CGRectMake(60.9, 0, 11.34, 10.54);
                globalavgscoreforiphone.contentsScale = [[UIScreen mainScreen] scale];
                globalavgscoreforiphone.string        = [NSString stringWithFormat:@"%d",globalavg];
                globalavgscoreforiphone.font          = (__bridge CFTypeRef)@"GothamBook";
                globalavgscoreforiphone.fontSize      = 7;
                globalavgscoreforiphone.alignmentMode = kCAAlignmentCenter;
                globalavgscoreforiphone.foregroundColor = [UIColor blackColor].CGColor;
                [individualforiphone addSublayer:globalavgscoreforiphone];
                self.layers[@"globalavgscoreforiphone"] = globalavgscoreforiphone;
                }
                CAShapeLayer * globalavgscorepathforiphone = [CAShapeLayer layer];
                globalavgscorepathforiphone.frame     = CGRectMake(49.94, 77.37, 195, 195);
                globalavgscorepathforiphone.fillColor = nil;
                globalavgscorepathforiphone.lineWidth = 0;
                globalavgscorepathforiphone.path      = [self globalavgscorepathforiphonePath].CGPath;
                [individualforiphone addSublayer:globalavgscorepathforiphone];
                self.layers[@"globalavgscorepathforiphone"] = globalavgscorepathforiphone;
                if((localavg!=actual)&&(globalavg!=localavg)&& actual>0){
                CATextLayer * localavgscoreforiphone = [CATextLayer layer];
                localavgscoreforiphone.frame           = CGRectMake(60.9, 0, 11.34, 10.54);
                localavgscoreforiphone.contentsScale   = [[UIScreen mainScreen] scale];
                localavgscoreforiphone.string          = [NSString stringWithFormat:@"%d",localavg];
                localavgscoreforiphone.font            = (__bridge CFTypeRef)@"GothamBook";
                localavgscoreforiphone.fontSize        = 7;
                localavgscoreforiphone.alignmentMode   = kCAAlignmentCenter;
                localavgscoreforiphone.foregroundColor = [UIColor redColor].CGColor;
                [individualforiphone addSublayer:localavgscoreforiphone];
                self.layers[@"localavgscoreforiphone"] = localavgscoreforiphone;
                }
                if(row==1){
                    [individualforiphone addSublayer:energy];
                    self.layers[@"energy"] = energy;
                    
                }
                else if(row==2){
                    [individualforiphone addSublayer:water];
                    self.layers[@"water"] = water;
                }
                else if(row==3){
                    [individualforiphone addSublayer:waste];
                    self.layers[@"waste"] = waste;
                }
                else if(row==4){
                    [individualforiphone addSublayer:transport];
                    self.layers[@"transport"] = transport;
                }
                else if(row==5){
                    [individualforiphone addSublayer:human];
                    self.layers[@"human"] = human;
                }
                
            }
            NSLog(@"---> %d %d %d",actual,globalavg,localavg);
            NSLog(@"%@ %@",tempdict, dict);
        
        }
        [self addIphoneindividualAnimation];
    }
    
    
    
}

- (void)addIpadindividualAnimation{
    NSString * fillMode = kCAFillModeForwards;
    
    ////Innerstartpathforipad animation
    CAKeyframeAnimation * innerstartpathforipadStrokeEndAnim = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    innerstartpathforipadStrokeEndAnim.values = @[@0, @1];
    innerstartpathforipadStrokeEndAnim.keyTimes = @[@0, @1];
    innerstartpathforipadStrokeEndAnim.duration = 0.289;
    
    CAAnimationGroup * innerstartpathforipadIpadindividualAnim = [QCMethod groupAnimations:@[innerstartpathforipadStrokeEndAnim] fillMode:fillMode];
    [self.layers[@"innerstartpathforipad"] addAnimation:innerstartpathforipadIpadindividualAnim forKey:@"innerstartpathforipadIpadindividualAnim"];
    
    ////Innerstartingforipad animation
    CAKeyframeAnimation * innerstartingforipadStrokeEndAnim = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    innerstartingforipadStrokeEndAnim.values = @[@0, @1];
    innerstartingforipadStrokeEndAnim.keyTimes = @[@0, @1];
    innercount=0;
    inner=[NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(innertime) userInfo:nil repeats:NO];
    
    innerstartingforipadStrokeEndAnim.duration = 1.71;
    innerstartingforipadStrokeEndAnim.beginTime = 0.289;
    innerstartingforipadStrokeEndAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    
    CAAnimationGroup * innerstartingforipadIpadindividualAnim = [QCMethod groupAnimations:@[innerstartingforipadStrokeEndAnim] fillMode:fillMode];
    [self.layers[@"innerstartingforipad"] addAnimation:innerstartingforipadIpadindividualAnim forKey:@"innerstartingforipadIpadindividualAnim"];
    
    ////Innerarrowforipad animation
    CAKeyframeAnimation * innerarrowforipadPositionAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    innerarrowforipadPositionAnim.path     = [QCMethod offsetPath:[self innerstartingforipadPath] by:CGPointMake(211.38, 1)].CGPath;
    innerarrowforipadPositionAnim.rotationMode = kCAAnimationRotateAutoReverse;
    innerarrowforipadPositionAnim.calculationMode = kCAAnimationCubicPaced;
    innerarrowforipadPositionAnim.duration = 1.71;
    innerarrowforipadPositionAnim.beginTime = 0.289;
    innerarrowforipadPositionAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAKeyframeAnimation * innerarrowforipadHiddenAnim = [CAKeyframeAnimation animationWithKeyPath:@"hidden"];
    innerarrowforipadHiddenAnim.values   = @[@YES, @NO];
    innerarrowforipadHiddenAnim.keyTimes = @[@0, @1];
    innerarrowforipadHiddenAnim.duration = 0.583;
    
    CAKeyframeAnimation * innerarrowforipadOpacityAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    innerarrowforipadOpacityAnim.values = @[@1, @0];
    innerarrowforipadOpacityAnim.keyTimes = @[@0, @1];
    innerarrowforipadOpacityAnim.duration = 0.428;
    innerarrowforipadOpacityAnim.beginTime = 1.57;
    
    if(actual==maxx){
        CAAnimationGroup * innerarrowforipadIpadindividualAnim = [QCMethod groupAnimations:@[innerarrowforipadPositionAnim, innerarrowforipadHiddenAnim,innerarrowforipadOpacityAnim] fillMode:fillMode];
        [self.layers[@"innerarrowforipad"] addAnimation:innerarrowforipadIpadindividualAnim forKey:@"innerarrowforipadIpadindividualAnim"];
    }
    else{
    CAAnimationGroup * innerarrowforipadIpadindividualAnim = [QCMethod groupAnimations:@[innerarrowforipadPositionAnim, innerarrowforipadHiddenAnim] fillMode:fillMode];
    [self.layers[@"innerarrowforipad"] addAnimation:innerarrowforipadIpadindividualAnim forKey:@"innerarrowforipadIpadindividualAnim"];
    }
    ////Innerscoreforipad animation
    CAKeyframeAnimation * innerscoreforipadHiddenAnim = [CAKeyframeAnimation animationWithKeyPath:@"hidden"];
    innerscoreforipadHiddenAnim.values   = @[@YES, @NO];
    innerscoreforipadHiddenAnim.keyTimes = @[@0, @1];
    innerscoreforipadHiddenAnim.duration = 0.583;
    
    CAKeyframeAnimation * innerscoreforipadPositionAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    innerscoreforipadPositionAnim.path     = [QCMethod offsetPath:[self innerscoreforipadPath] by:CGPointMake(211.38, 1)].CGPath;
    innerscoreforipadPositionAnim.calculationMode = kCAAnimationCubicPaced;
    innerscoreforipadPositionAnim.duration = 1.71;
    innerscoreforipadPositionAnim.beginTime = 0.289;
    innerscoreforipadPositionAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup * innerscoreforipadIpadindividualAnim = [QCMethod groupAnimations:@[innerscoreforipadHiddenAnim, innerscoreforipadPositionAnim] fillMode:fillMode];
    [self.layers[@"innerscoreforipad"] addAnimation:innerscoreforipadIpadindividualAnim forKey:@"innerscoreforipadIpadindividualAnim"];
    
    ////Middlestartpathforipad animation
    CAKeyframeAnimation * middlestartpathforipadStrokeEndAnim = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    middlestartpathforipadStrokeEndAnim.values = @[@0, @1];
    middlestartpathforipadStrokeEndAnim.keyTimes = @[@0, @1];
    middlestartpathforipadStrokeEndAnim.duration = 0.289;
    
    CAAnimationGroup * middlestartpathforipadIpadindividualAnim = [QCMethod groupAnimations:@[middlestartpathforipadStrokeEndAnim] fillMode:fillMode];
    [self.layers[@"middlestartpathforipad"] addAnimation:middlestartpathforipadIpadindividualAnim forKey:@"middlestartpathforipadIpadindividualAnim"];
    
    ////Middlestartingforipad animation
    CAKeyframeAnimation * middlestartingforipadStrokeEndAnim = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    middlestartingforipadStrokeEndAnim.values = @[@0, @1];
    middlestartingforipadStrokeEndAnim.keyTimes = @[@0, @1];
    middlecount=0;
    middle=[NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(middletime) userInfo:nil repeats:NO];
    middlestartingforipadStrokeEndAnim.duration = 1.71;
    middlestartingforipadStrokeEndAnim.beginTime = 0.289;
    middlestartingforipadStrokeEndAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup * middlestartingforipadIpadindividualAnim = [QCMethod groupAnimations:@[middlestartingforipadStrokeEndAnim] fillMode:fillMode];
    [self.layers[@"middlestartingforipad"] addAnimation:middlestartingforipadIpadindividualAnim forKey:@"middlestartingforipadIpadindividualAnim"];
    
    ////Middlearrowforipad animation
    CAKeyframeAnimation * middlearrowforipadPositionAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    middlearrowforipadPositionAnim.path = [QCMethod offsetPath:[self middlestartingforipadPath] by:CGPointMake(160.38, 0)].CGPath;
    middlearrowforipadPositionAnim.rotationMode = kCAAnimationRotateAutoReverse;
    middlearrowforipadPositionAnim.calculationMode = kCAAnimationCubicPaced;
    middlearrowforipadPositionAnim.duration = 1.71;
    middlearrowforipadPositionAnim.beginTime = 0.289;
    middlearrowforipadPositionAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAKeyframeAnimation * middlearrowforipadHiddenAnim = [CAKeyframeAnimation animationWithKeyPath:@"hidden"];
    middlearrowforipadHiddenAnim.values   = @[@YES, @NO];
    middlearrowforipadHiddenAnim.keyTimes = @[@0, @1];
    middlearrowforipadHiddenAnim.duration = 0.583;
    
    CAKeyframeAnimation * middlearrowforipadOpacityAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    middlearrowforipadOpacityAnim.values = @[@1, @0];
    middlearrowforipadOpacityAnim.keyTimes = @[@0, @1];
    middlearrowforipadOpacityAnim.duration = 0.428;
    middlearrowforipadOpacityAnim.beginTime = 1.57;
    
    if(actual==maxx){
    CAAnimationGroup * middlearrowforipadIpadindividualAnim = [QCMethod groupAnimations:@[middlearrowforipadPositionAnim, middlearrowforipadHiddenAnim,middlearrowforipadOpacityAnim] fillMode:fillMode];
    [self.layers[@"middlearrowforipad"] addAnimation:middlearrowforipadIpadindividualAnim forKey:@"middlearrowforipadIpadindividualAnim"];
    }
    else{
        CAAnimationGroup * middlearrowforipadIpadindividualAnim = [QCMethod groupAnimations:@[middlearrowforipadPositionAnim, middlearrowforipadHiddenAnim] fillMode:fillMode];
        [self.layers[@"middlearrowforipad"] addAnimation:middlearrowforipadIpadindividualAnim forKey:@"middlearrowforipadIpadindividualAnim"];
    }
    ////Middlescoreforipad animation
    CAKeyframeAnimation * middlescoreforipadHiddenAnim = [CAKeyframeAnimation animationWithKeyPath:@"hidden"];
    middlescoreforipadHiddenAnim.values   = @[@YES, @NO];
    middlescoreforipadHiddenAnim.keyTimes = @[@0, @1];
    middlescoreforipadHiddenAnim.duration = 0.583;
    
    CAKeyframeAnimation * middlescoreforipadPositionAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    middlescoreforipadPositionAnim.path = [QCMethod offsetPath:[self middlescoreforipadPath] by:CGPointMake(160.38, 0)].CGPath;
    middlescoreforipadPositionAnim.calculationMode = kCAAnimationCubicPaced;
    middlescoreforipadPositionAnim.duration = 1.71;
    middlescoreforipadPositionAnim.beginTime = 0.289;
    middlescoreforipadPositionAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup * middlescoreforipadIpadindividualAnim = [QCMethod groupAnimations:@[middlescoreforipadHiddenAnim, middlescoreforipadPositionAnim] fillMode:fillMode];
    [self.layers[@"middlescoreforipad"] addAnimation:middlescoreforipadIpadindividualAnim forKey:@"middlescoreforipadIpadindividualAnim"];
    
    ////Outerstartpathforipad animation
    CAKeyframeAnimation * outerstartpathforipadStrokeEndAnim = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    outerstartpathforipadStrokeEndAnim.values = @[@0, @1];
    outerstartpathforipadStrokeEndAnim.keyTimes = @[@0, @1];
    outerstartpathforipadStrokeEndAnim.duration = 0.289;
    
    CAAnimationGroup * outerstartpathforipadIpadindividualAnim = [QCMethod groupAnimations:@[outerstartpathforipadStrokeEndAnim] fillMode:fillMode];
    [self.layers[@"outerstartpathforipad"] addAnimation:outerstartpathforipadIpadindividualAnim forKey:@"outerstartpathforipadIpadindividualAnim"];
    
    ////Outerstartingforipad animation
    CAKeyframeAnimation * outerstartingforipadStrokeEndAnim = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    outerstartingforipadStrokeEndAnim.values = @[@0, @1];
    outerstartingforipadStrokeEndAnim.keyTimes = @[@0, @1];
    outeractual=0;
    outer=[NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(outertime) userInfo:nil repeats:NO];
    
    outerstartingforipadStrokeEndAnim.duration = 1.71;
    outerstartingforipadStrokeEndAnim.beginTime = 0.289;
    outerstartingforipadStrokeEndAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup * outerstartingforipadIpadindividualAnim = [QCMethod groupAnimations:@[outerstartingforipadStrokeEndAnim] fillMode:fillMode];
    [self.layers[@"outerstartingforipad"] addAnimation:outerstartingforipadIpadindividualAnim forKey:@"outerstartingforipadIpadindividualAnim"];
    
    ////Outerarrowforipad animation
    CAKeyframeAnimation * outerarrowforipadPositionAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    outerarrowforipadPositionAnim.path     = [QCMethod offsetPath:[self outerstartingforipadPath] by:CGPointMake(84.71, 0)].CGPath;
    outerarrowforipadPositionAnim.rotationMode = kCAAnimationRotateAutoReverse;
    outerarrowforipadPositionAnim.calculationMode = kCAAnimationCubicPaced;
    outerarrowforipadPositionAnim.duration = 1.71;
    outerarrowforipadPositionAnim.beginTime = 0.289;
    outerarrowforipadPositionAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAKeyframeAnimation * outerarrowforipadHiddenAnim = [CAKeyframeAnimation animationWithKeyPath:@"hidden"];
    outerarrowforipadHiddenAnim.values   = @[@YES, @NO];
    outerarrowforipadHiddenAnim.keyTimes = @[@0, @1];
    outerarrowforipadHiddenAnim.duration = 0.583;
    
    CAKeyframeAnimation * outerarrowforipadOpacityAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    outerarrowforipadOpacityAnim.values = @[@1, @0];
    outerarrowforipadOpacityAnim.keyTimes = @[@0, @1];
    outerarrowforipadOpacityAnim.duration = 0.428;
    outerarrowforipadOpacityAnim.beginTime = 1.57;
    
    if(actual==maxx){
        CAAnimationGroup * outerarrowforipadIpadindividualAnim = [QCMethod groupAnimations:@[outerarrowforipadPositionAnim, outerarrowforipadHiddenAnim,outerarrowforipadOpacityAnim] fillMode:fillMode];
        [self.layers[@"outerarrowforipad"] addAnimation:outerarrowforipadIpadindividualAnim forKey:@"outerarrowforipadIpadindividualAnim"];
    }else{
    CAAnimationGroup * outerarrowforipadIpadindividualAnim = [QCMethod groupAnimations:@[outerarrowforipadPositionAnim, outerarrowforipadHiddenAnim] fillMode:fillMode];
    [self.layers[@"outerarrowforipad"] addAnimation:outerarrowforipadIpadindividualAnim forKey:@"outerarrowforipadIpadindividualAnim"];
    }
    ////Outerscoreforipad animation
    CAKeyframeAnimation * outerscoreforipadHiddenAnim = [CAKeyframeAnimation animationWithKeyPath:@"hidden"];
    outerscoreforipadHiddenAnim.values   = @[@YES, @NO];
    outerscoreforipadHiddenAnim.keyTimes = @[@0, @1];
    outerscoreforipadHiddenAnim.duration = 0.583;
    
    CAKeyframeAnimation * outerscoreforipadPositionAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    outerscoreforipadPositionAnim.path     = [QCMethod offsetPath:[self outerscoreforipadPath] by:CGPointMake(84.71, 0)].CGPath;
    outerscoreforipadPositionAnim.calculationMode = kCAAnimationCubicPaced;
    outerscoreforipadPositionAnim.duration = 1.71;
    outerscoreforipadPositionAnim.beginTime = 0.289;
    outerscoreforipadPositionAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup * outerscoreforipadIpadindividualAnim = [QCMethod groupAnimations:@[outerscoreforipadHiddenAnim, outerscoreforipadPositionAnim] fillMode:fillMode];
    [self.layers[@"outerscoreforipad"] addAnimation:outerscoreforipadIpadindividualAnim forKey:@"outerscoreforipadIpadindividualAnim"];
   
    ////Outerlocalavgscoreforipad animation
    CAKeyframeAnimation * outerlocalavgscoreforipadPositionAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    outerlocalavgscoreforipadPositionAnim.path = [QCMethod offsetPath:[self localavgscoreforipadpathPath] by:CGPointMake(158, 141)].CGPath;
    outerlocalavgscoreforipadPositionAnim.calculationMode = kCAAnimationCubicPaced;
    outerlocalavgscoreforipadPositionAnim.duration = 0.715;
    outerlocalavgscoreforipadPositionAnim.beginTime = 1.46;
    outerlocalavgscoreforipadPositionAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAKeyframeAnimation * outerlocalavgscoreforipadHiddenAnim = [CAKeyframeAnimation animationWithKeyPath:@"hidden"];
    outerlocalavgscoreforipadHiddenAnim.values = @[@YES, @YES, @NO];
    outerlocalavgscoreforipadHiddenAnim.keyTimes = @[@0, @0.911, @1];
    outerlocalavgscoreforipadHiddenAnim.duration = 2.27;
    
    CAAnimationGroup * outerlocalavgscoreforipadIpadindividualAnim = [QCMethod groupAnimations:@[outerlocalavgscoreforipadPositionAnim, outerlocalavgscoreforipadHiddenAnim] fillMode:fillMode];
    [self.layers[@"outerlocalavgscoreforipad"] addAnimation:outerlocalavgscoreforipadIpadindividualAnim forKey:@"outerlocalavgscoreforipadIpadindividualAnim"];
    
    ////Outerglobalavgscoreforipad animation
    CAKeyframeAnimation * outerglobalavgscoreforipadHiddenAnim = [CAKeyframeAnimation animationWithKeyPath:@"hidden"];
    outerglobalavgscoreforipadHiddenAnim.values = @[@YES, @YES, @NO];
    outerglobalavgscoreforipadHiddenAnim.keyTimes = @[@0, @0.911, @1];
    outerglobalavgscoreforipadHiddenAnim.duration = 2.27;
    
    CAKeyframeAnimation * outerglobalavgscoreforipadPositionAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    outerglobalavgscoreforipadPositionAnim.path = [QCMethod offsetPath:[self globalavgscoreforipadpathPath] by:CGPointMake(158, 141)].CGPath;
    outerglobalavgscoreforipadPositionAnim.calculationMode = kCAAnimationCubicPaced;
    outerglobalavgscoreforipadPositionAnim.duration = 0.709;
    outerglobalavgscoreforipadPositionAnim.beginTime = 1.47;
    outerglobalavgscoreforipadPositionAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup * outerglobalavgscoreforipadIpadindividualAnim = [QCMethod groupAnimations:@[outerglobalavgscoreforipadHiddenAnim, outerglobalavgscoreforipadPositionAnim] fillMode:fillMode];
    [self.layers[@"outerglobalavgscoreforipad"] addAnimation:outerglobalavgscoreforipadIpadindividualAnim forKey:@"outerglobalavgscoreforipadIpadindividualAnim"];

    ////Needle animation
    CAKeyframeAnimation * needlePositionAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    needlePositionAnim.path            = [QCMethod offsetPath:[self needle1pathforipadPath] by:CGPointMake(98.05, 81.02)].CGPath;
    needlePositionAnim.rotationMode    = kCAAnimationRotateAutoReverse;
    needlePositionAnim.calculationMode = kCAAnimationCubicPaced;
    needlePositionAnim.duration        = 0.709;
    needlePositionAnim.beginTime       = 1.47;
    needlePositionAnim.timingFunction  = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAKeyframeAnimation * needleHiddenAnim = [CAKeyframeAnimation animationWithKeyPath:@"hidden"];
    needleHiddenAnim.values                = @[@YES, @YES, @NO];
    needleHiddenAnim.keyTimes              = @[@0, @0.911, @1];
    needleHiddenAnim.duration              = 2.27;
    
    CAAnimationGroup * needleIpadindividualAnim = [QCMethod groupAnimations:@[needlePositionAnim, needleHiddenAnim] fillMode:fillMode];
    [self.layers[@"needle"] addAnimation:needleIpadindividualAnim forKey:@"needleIpadindividualAnim"];
    
    ////Needle2 animation
    CAKeyframeAnimation * needle2PositionAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    needle2PositionAnim.path            = [QCMethod offsetPath:[self needle2pathforipadPath] by:CGPointMake(98, 81)].CGPath;
    needle2PositionAnim.rotationMode    = kCAAnimationRotateAutoReverse;
    needle2PositionAnim.calculationMode = kCAAnimationCubicPaced;
    needle2PositionAnim.duration        = 0.715;
    needle2PositionAnim.beginTime       = 1.46;
    needle2PositionAnim.timingFunction  = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAKeyframeAnimation * needle2HiddenAnim = [CAKeyframeAnimation animationWithKeyPath:@"hidden"];
    needle2HiddenAnim.values   = @[@YES, @YES, @NO];
    needle2HiddenAnim.keyTimes = @[@0, @0.911, @1];
    needle2HiddenAnim.duration = 2.27;
    
    CAAnimationGroup * needle2IpadindividualAnim = [QCMethod groupAnimations:@[needle2PositionAnim, needle2HiddenAnim] fillMode:fillMode];
    [self.layers[@"needle2"] addAnimation:needle2IpadindividualAnim forKey:@"needle2IpadindividualAnim"];
    
    ////Local animation
    CAKeyframeAnimation * localHiddenAnim = [CAKeyframeAnimation animationWithKeyPath:@"hidden"];
    localHiddenAnim.values                = @[@YES, @YES, @NO];
    localHiddenAnim.keyTimes              = @[@0, @0.911, @1];
    localHiddenAnim.duration              = 2.27;
    
    CAKeyframeAnimation * localPositionAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    localPositionAnim.path            = [QCMethod offsetPath:[self localpathforipadPath] by:CGPointMake(53, 36)].CGPath;
    localPositionAnim.calculationMode = kCAAnimationCubicPaced;
    localPositionAnim.duration        = 0.715;
    localPositionAnim.beginTime       = 1.46;
    localPositionAnim.timingFunction  = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup * localIpadindividualAnim = [QCMethod groupAnimations:@[localHiddenAnim, localPositionAnim] fillMode:fillMode];
    [self.layers[@"local"] addAnimation:localIpadindividualAnim forKey:@"localIpadindividualAnim"];
    
    ////Global animation
    CAKeyframeAnimation * globalPositionAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    globalPositionAnim.path            = [QCMethod offsetPath:[self globalpathforipadPath] by:CGPointMake(53, 36)].CGPath;
    globalPositionAnim.calculationMode = kCAAnimationCubicPaced;
    globalPositionAnim.duration        = 0.715;
    globalPositionAnim.beginTime       = 1.46;
    globalPositionAnim.timingFunction  = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAKeyframeAnimation * globalHiddenAnim = [CAKeyframeAnimation animationWithKeyPath:@"hidden"];
    globalHiddenAnim.values                = @[@YES, @YES, @NO];
    globalHiddenAnim.keyTimes              = @[@0, @0.911, @1];
    globalHiddenAnim.duration              = 2.27;
    
    CAAnimationGroup * globalIpadindividualAnim = [QCMethod groupAnimations:@[globalPositionAnim, globalHiddenAnim] fillMode:fillMode];
    [self.layers[@"global"] addAnimation:globalIpadindividualAnim forKey:@"globalIpadindividualAnim"];
}


#pragma mark - Animation Setup


- (void)addIphoneindividualAnimation{
    NSString * fillMode = kCAFillModeForwards;
    
    ////Localavgscoreforiphone animation
    CAKeyframeAnimation * localavgscoreforiphoneHiddenAnim = [CAKeyframeAnimation animationWithKeyPath:@"hidden"];
    localavgscoreforiphoneHiddenAnim.values = @[@YES, @YES, @NO];
    localavgscoreforiphoneHiddenAnim.keyTimes = @[@0, @0.911, @1];
    localavgscoreforiphoneHiddenAnim.duration = 2.27;
    
    CAKeyframeAnimation * localavgscoreforiphonePositionAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    localavgscoreforiphonePositionAnim.path = [QCMethod offsetPath:[self localavgscorepathforiphonePath] by:CGPointMake(49.94, 77.37)].CGPath;
    localavgscoreforiphonePositionAnim.calculationMode = kCAAnimationCubicPaced;
    localavgscoreforiphonePositionAnim.duration = 0.709;
    localavgscoreforiphonePositionAnim.beginTime = 1.47;
    localavgscoreforiphonePositionAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];

    CAAnimationGroup * localavgscoreforiphoneIphoneindividualAnim = [QCMethod groupAnimations:@[localavgscoreforiphoneHiddenAnim, localavgscoreforiphonePositionAnim] fillMode:fillMode];
    [self.layers[@"localavgscoreforiphone"] addAnimation:localavgscoreforiphoneIphoneindividualAnim forKey:@"localavgscoreforiphoneIphoneindividualAnim"];

    CAKeyframeAnimation * globalavgscoreforiphoneHiddenAnim = [CAKeyframeAnimation animationWithKeyPath:@"hidden"];
    globalavgscoreforiphoneHiddenAnim.values = @[@YES, @YES, @NO];
    globalavgscoreforiphoneHiddenAnim.keyTimes = @[@0, @0.911, @1];
    globalavgscoreforiphoneHiddenAnim.duration = 2.27;
    
    CAKeyframeAnimation * globalavgscoreforiphonePositionAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    globalavgscoreforiphonePositionAnim.path = [QCMethod offsetPath:[self globalavgscorepathforiphonePath] by:CGPointMake(49.94, 77.37)].CGPath;
    globalavgscoreforiphonePositionAnim.calculationMode = kCAAnimationCubicPaced;
    globalavgscoreforiphonePositionAnim.duration = 0.709;
    globalavgscoreforiphonePositionAnim.beginTime = 1.47;
    globalavgscoreforiphonePositionAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup * globalavgscoreforiphoneIphoneindividualAnim = [QCMethod groupAnimations:@[globalavgscoreforiphoneHiddenAnim, globalavgscoreforiphonePositionAnim] fillMode:fillMode];
    [self.layers[@"globalavgscoreforiphone"] addAnimation:globalavgscoreforiphoneIphoneindividualAnim forKey:@"globalavgscoreforiphoneIphoneindividualAnim"];

    
    ////Innerstartpathforiphone animation
    CAKeyframeAnimation * innerstartpathforiphoneStrokeEndAnim = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    innerstartpathforiphoneStrokeEndAnim.values = @[@0, @1];
    innerstartpathforiphoneStrokeEndAnim.keyTimes = @[@0, @1];
    innerstartpathforiphoneStrokeEndAnim.duration = 0.289;
    
    CAAnimationGroup * innerstartpathforiphoneIphoneindividualAnim = [QCMethod groupAnimations:@[innerstartpathforiphoneStrokeEndAnim] fillMode:fillMode];
    [self.layers[@"innerstartpathforiphone"] addAnimation:innerstartpathforiphoneIphoneindividualAnim forKey:@"innerstartpathforiphoneIphoneindividualAnim"];
    
    ////Innerstartingforiphone animation
    CAKeyframeAnimation * innerstartingforiphoneStrokeEndAnim = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    innerstartingforiphoneStrokeEndAnim.values = @[@0, @1];
    innerstartingforiphoneStrokeEndAnim.keyTimes = @[@0, @1];
    innercount=0;
    inner=[NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(innertime) userInfo:nil repeats:NO];
    
    innerstartingforiphoneStrokeEndAnim.duration = 1.71;
    innerstartingforiphoneStrokeEndAnim.beginTime = 0.289;
    innerstartingforiphoneStrokeEndAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup * innerstartingforiphoneIphoneindividualAnim = [QCMethod groupAnimations:@[innerstartingforiphoneStrokeEndAnim] fillMode:fillMode];
    [self.layers[@"innerstartingforiphone"] addAnimation:innerstartingforiphoneIphoneindividualAnim forKey:@"innerstartingforiphoneIphoneindividualAnim"];
    
    ////Innerarrowforiphone animation
    CAKeyframeAnimation * innerarrowforiphonePositionAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    innerarrowforiphonePositionAnim.path = [QCMethod offsetPath:[self innerstartingforiphonePath] by:CGPointMake(79.3, 134.77)].CGPath;
    innerarrowforiphonePositionAnim.rotationMode = kCAAnimationRotateAutoReverse;
    innerarrowforiphonePositionAnim.calculationMode = kCAAnimationCubicPaced;
    innerarrowforiphonePositionAnim.duration = 1.71;
    innerarrowforiphonePositionAnim.beginTime = 0.289;
    innerarrowforiphonePositionAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAKeyframeAnimation * innerarrowforiphoneHiddenAnim = [CAKeyframeAnimation animationWithKeyPath:@"hidden"];
    innerarrowforiphoneHiddenAnim.values   = @[@YES, @NO];
    innerarrowforiphoneHiddenAnim.keyTimes = @[@0, @1];
    innerarrowforiphoneHiddenAnim.duration = 0.583;
    
    CAKeyframeAnimation * innerarrowforiphoneOpacityAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    innerarrowforiphoneOpacityAnim.values = @[@1, @0];
    innerarrowforiphoneOpacityAnim.keyTimes = @[@0, @1];
    innerarrowforiphoneOpacityAnim.duration = 0.428;
    innerarrowforiphoneOpacityAnim.beginTime = 1.57;

    if(actual==maxx){
    CAAnimationGroup * innerarrowforiphoneIphoneindividualAnim = [QCMethod groupAnimations:@[innerarrowforiphonePositionAnim, innerarrowforiphoneHiddenAnim,innerarrowforiphoneOpacityAnim] fillMode:fillMode];
    [self.layers[@"innerarrowforiphone"] addAnimation:innerarrowforiphoneIphoneindividualAnim forKey:@"innerarrowforiphoneIphoneindividualAnim"];
    }
    else{
        CAAnimationGroup * innerarrowforiphoneIphoneindividualAnim = [QCMethod groupAnimations:@[innerarrowforiphonePositionAnim, innerarrowforiphoneHiddenAnim] fillMode:fillMode];
        [self.layers[@"innerarrowforiphone"] addAnimation:innerarrowforiphoneIphoneindividualAnim forKey:@"innerarrowforiphoneIphoneindividualAnim"];
    }
    ////Innerscoreforiphone animation
    CAKeyframeAnimation * innerscoreforiphoneHiddenAnim = [CAKeyframeAnimation animationWithKeyPath:@"hidden"];
    innerscoreforiphoneHiddenAnim.values   = @[@YES, @NO];
    innerscoreforiphoneHiddenAnim.keyTimes = @[@0, @1];
    innerscoreforiphoneHiddenAnim.duration = 0.583;
    
    CAKeyframeAnimation * innerscoreforiphonePositionAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    innerscoreforiphonePositionAnim.path = [QCMethod offsetPath:[self innerscoreforiphonePath] by:CGPointMake(79.3, 134.77)].CGPath;
    innerscoreforiphonePositionAnim.calculationMode = kCAAnimationCubicPaced;
    innerscoreforiphonePositionAnim.duration = 1.71;
    innerscoreforiphonePositionAnim.beginTime = 0.289;
    innerscoreforiphonePositionAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup * innerscoreforiphoneIphoneindividualAnim = [QCMethod groupAnimations:@[innerscoreforiphoneHiddenAnim, innerscoreforiphonePositionAnim] fillMode:fillMode];
    [self.layers[@"innerscoreforiphone"] addAnimation:innerscoreforiphoneIphoneindividualAnim forKey:@"innerscoreforiphoneIphoneindividualAnim"];
    
    ////Middlestartpathforiphone animation
    CAKeyframeAnimation * middlestartpathforiphoneStrokeEndAnim = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    middlestartpathforiphoneStrokeEndAnim.values = @[@0, @1];
    middlestartpathforiphoneStrokeEndAnim.keyTimes = @[@0, @1];
    middlestartpathforiphoneStrokeEndAnim.duration = 0.289;
    
    CAAnimationGroup * middlestartpathforiphoneIphoneindividualAnim = [QCMethod groupAnimations:@[middlestartpathforiphoneStrokeEndAnim] fillMode:fillMode];
    [self.layers[@"middlestartpathforiphone"] addAnimation:middlestartpathforiphoneIphoneindividualAnim forKey:@"middlestartpathforiphoneIphoneindividualAnim"];
    
    ////Middlestartingforiphone animation
    CAKeyframeAnimation * middlestartingforiphoneStrokeEndAnim = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    middlestartingforiphoneStrokeEndAnim.values = @[@0, @1];
    middlestartingforiphoneStrokeEndAnim.keyTimes = @[@0, @1];
    middlecount=0;
    middle=[NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(middletime) userInfo:nil repeats:NO];
    middlestartingforiphoneStrokeEndAnim.duration = 1.71;
    middlestartingforiphoneStrokeEndAnim.beginTime = 0.289;
    middlestartingforiphoneStrokeEndAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup * middlestartingforiphoneIphoneindividualAnim = [QCMethod groupAnimations:@[middlestartingforiphoneStrokeEndAnim] fillMode:fillMode];
    [self.layers[@"middlestartingforiphone"] addAnimation:middlestartingforiphoneIphoneindividualAnim forKey:@"middlestartingforiphoneIphoneindividualAnim"];
    
    ////Middlearrowforiphone animation
    CAKeyframeAnimation * middlearrowforiphonePositionAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    middlearrowforiphonePositionAnim.path = [QCMethod offsetPath:[self middlestartingforiphonePath] by:CGPointMake(58.3, 113.95)].CGPath;
    middlearrowforiphonePositionAnim.rotationMode = kCAAnimationRotateAutoReverse;
    middlearrowforiphonePositionAnim.calculationMode = kCAAnimationCubicPaced;
    middlearrowforiphonePositionAnim.duration = 1.71;
    middlearrowforiphonePositionAnim.beginTime = 0.289;
    middlearrowforiphonePositionAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAKeyframeAnimation * middlearrowforiphoneHiddenAnim = [CAKeyframeAnimation animationWithKeyPath:@"hidden"];
    middlearrowforiphoneHiddenAnim.values = @[@YES, @NO];
    middlearrowforiphoneHiddenAnim.keyTimes = @[@0, @1];
    middlearrowforiphoneHiddenAnim.duration = 0.583;
    
    CAKeyframeAnimation * middlearrowforiphoneOpacityAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    middlearrowforiphoneOpacityAnim.values = @[@1, @0];
    middlearrowforiphoneOpacityAnim.keyTimes = @[@0, @1];
    middlearrowforiphoneOpacityAnim.duration = 0.428;
    middlearrowforiphoneOpacityAnim.beginTime = 1.57;
    
    if(actual==maxx){
        CAAnimationGroup * middlearrowforiphoneIphoneindividualAnim = [QCMethod groupAnimations:@[middlearrowforiphonePositionAnim, middlearrowforiphoneHiddenAnim,middlearrowforiphoneOpacityAnim] fillMode:fillMode];
        [self.layers[@"middlearrowforiphone"] addAnimation:middlearrowforiphoneIphoneindividualAnim forKey:@"middlearrowforiphoneIphoneindividualAnim"];
    }else{
    CAAnimationGroup * middlearrowforiphoneIphoneindividualAnim = [QCMethod groupAnimations:@[middlearrowforiphonePositionAnim, middlearrowforiphoneHiddenAnim] fillMode:fillMode];
    [self.layers[@"middlearrowforiphone"] addAnimation:middlearrowforiphoneIphoneindividualAnim forKey:@"middlearrowforiphoneIphoneindividualAnim"];
    }
    ////Middlescoreforiphone animation
    CAKeyframeAnimation * middlescoreforiphoneHiddenAnim = [CAKeyframeAnimation animationWithKeyPath:@"hidden"];
    middlescoreforiphoneHiddenAnim.values = @[@YES, @NO];
    middlescoreforiphoneHiddenAnim.keyTimes = @[@0, @1];
    middlescoreforiphoneHiddenAnim.duration = 0.583;
    
    CAKeyframeAnimation * middlescoreforiphonePositionAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    middlescoreforiphonePositionAnim.path = [QCMethod offsetPath:[self middlescoreforiphonePath] by:CGPointMake(58.3, 113.95)].CGPath;
    middlescoreforiphonePositionAnim.calculationMode = kCAAnimationCubicPaced;
    middlescoreforiphonePositionAnim.duration = 1.71;
    middlescoreforiphonePositionAnim.beginTime = 0.289;
    middlescoreforiphonePositionAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup * middlescoreforiphoneIphoneindividualAnim = [QCMethod groupAnimations:@[middlescoreforiphoneHiddenAnim, middlescoreforiphonePositionAnim] fillMode:fillMode];
    [self.layers[@"middlescoreforiphone"] addAnimation:middlescoreforiphoneIphoneindividualAnim forKey:@"middlescoreforiphoneIphoneindividualAnim"];
    
    ////Outerstartpathforiphone animation
    CAKeyframeAnimation * outerstartpathforiphoneStrokeEndAnim = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    outerstartpathforiphoneStrokeEndAnim.values = @[@0, @1];
    outerstartpathforiphoneStrokeEndAnim.keyTimes = @[@0, @1];
    outerstartpathforiphoneStrokeEndAnim.duration = 0.289;
    
    CAAnimationGroup * outerstartpathforiphoneIphoneindividualAnim = [QCMethod groupAnimations:@[outerstartpathforiphoneStrokeEndAnim] fillMode:fillMode];
    [self.layers[@"outerstartpathforiphone"] addAnimation:outerstartpathforiphoneIphoneindividualAnim forKey:@"outerstartpathforiphoneIphoneindividualAnim"];
    
    ////Outerstartingforiphone animation
    CAKeyframeAnimation * outerstartingforiphoneStrokeEndAnim = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    outerstartingforiphoneStrokeEndAnim.values = @[@0, @1];
    outerstartingforiphoneStrokeEndAnim.keyTimes = @[@0, @1];
    outeractual=0;
    outer=[NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(outertime) userInfo:nil repeats:NO];
    
    outerstartingforiphoneStrokeEndAnim.duration = 1.71;
    outerstartingforiphoneStrokeEndAnim.beginTime = 0.289;
    outerstartingforiphoneStrokeEndAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup * outerstartingforiphoneIphoneindividualAnim = [QCMethod groupAnimations:@[outerstartingforiphoneStrokeEndAnim] fillMode:fillMode];
    [self.layers[@"outerstartingforiphone"] addAnimation:outerstartingforiphoneIphoneindividualAnim forKey:@"outerstartingforiphoneIphoneindividualAnim"];
    
    ////Outerarrowforiphone animation
    CAKeyframeAnimation * outerarrowforiphonePositionAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    outerarrowforiphonePositionAnim.path = [QCMethod offsetPath:[self outerstartingforiphonePath] by:CGPointMake(22.8, 77.45)].CGPath;
    outerarrowforiphonePositionAnim.rotationMode = kCAAnimationRotateAutoReverse;
    outerarrowforiphonePositionAnim.calculationMode = kCAAnimationCubicPaced;
    outerarrowforiphonePositionAnim.duration = 1.71;
    outerarrowforiphonePositionAnim.beginTime = 0.289;
    outerarrowforiphonePositionAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAKeyframeAnimation * outerarrowforiphoneHiddenAnim = [CAKeyframeAnimation animationWithKeyPath:@"hidden"];
    outerarrowforiphoneHiddenAnim.values   = @[@YES, @NO];
    outerarrowforiphoneHiddenAnim.keyTimes = @[@0, @1];
    outerarrowforiphoneHiddenAnim.duration = 0.583;
    
    CAKeyframeAnimation * outerarrowforiphoneOpacityAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    outerarrowforiphoneOpacityAnim.values = @[@1, @0];
    outerarrowforiphoneOpacityAnim.keyTimes = @[@0, @1];
    outerarrowforiphoneOpacityAnim.duration = 0.428;
    outerarrowforiphoneOpacityAnim.beginTime = 1.57;
    if(actual==maxx){
    CAAnimationGroup * outerarrowforiphoneIphoneindividualAnim = [QCMethod groupAnimations:@[outerarrowforiphonePositionAnim, outerarrowforiphoneHiddenAnim,outerarrowforiphoneOpacityAnim] fillMode:fillMode];
        [self.layers[@"outerarrowforiphone"] addAnimation:outerarrowforiphoneIphoneindividualAnim forKey:@"outerarrowforiphoneIphoneindividualAnim"];
        
    }
    else{
        CAAnimationGroup * outerarrowforiphoneIphoneindividualAnim = [QCMethod groupAnimations:@[outerarrowforiphonePositionAnim, outerarrowforiphoneHiddenAnim] fillMode:fillMode];
        [self.layers[@"outerarrowforiphone"] addAnimation:outerarrowforiphoneIphoneindividualAnim forKey:@"outerarrowforiphoneIphoneindividualAnim"];
        
    }
    
    ////Outerscoreforiphone animation
    CAKeyframeAnimation * outerscoreforiphoneHiddenAnim = [CAKeyframeAnimation animationWithKeyPath:@"hidden"];
    outerscoreforiphoneHiddenAnim.values   = @[@YES, @NO];
    outerscoreforiphoneHiddenAnim.keyTimes = @[@0, @1];
    outerscoreforiphoneHiddenAnim.duration = 0.583;
    
    CAKeyframeAnimation * outerscoreforiphonePositionAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    outerscoreforiphonePositionAnim.path = [QCMethod offsetPath:[self outerscoreforiphonePath] by:CGPointMake(22.8, 77.45)].CGPath;
    outerscoreforiphonePositionAnim.calculationMode = kCAAnimationCubicPaced;
    outerscoreforiphonePositionAnim.duration = 1.71;
    outerscoreforiphonePositionAnim.beginTime = 0.289;
    outerscoreforiphonePositionAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup * outerscoreforiphoneIphoneindividualAnim = [QCMethod groupAnimations:@[outerscoreforiphoneHiddenAnim, outerscoreforiphonePositionAnim] fillMode:fillMode];
    [self.layers[@"outerscoreforiphone"] addAnimation:outerscoreforiphoneIphoneindividualAnim forKey:@"outerscoreforiphoneIphoneindividualAnim"];
    
    ////Needle animation
    CAKeyframeAnimation * needlePositionAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    needlePositionAnim.path            = [QCMethod offsetPath:[self needle1pathforiphonePath] by:CGPointMake(17.5, 44.88)].CGPath;
    needlePositionAnim.rotationMode    = kCAAnimationRotateAutoReverse;
    needlePositionAnim.calculationMode = kCAAnimationCubicPaced;
    needlePositionAnim.duration        = 0.709;
    needlePositionAnim.beginTime       = 1.47;
    needlePositionAnim.timingFunction  = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAKeyframeAnimation * needleHiddenAnim = [CAKeyframeAnimation animationWithKeyPath:@"hidden"];
    needleHiddenAnim.values                = @[@YES, @YES, @NO];
    needleHiddenAnim.keyTimes              = @[@0, @0.911, @1];
    needleHiddenAnim.duration              = 2.27;
    
    CAAnimationGroup * needleIphoneindividualAnim = [QCMethod groupAnimations:@[needlePositionAnim, needleHiddenAnim] fillMode:fillMode];
    [self.layers[@"needle"] addAnimation:needleIphoneindividualAnim forKey:@"needleIphoneindividualAnim"];
    
    ////Needle2 animation
    CAKeyframeAnimation * needle2PositionAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    needle2PositionAnim.path            = [QCMethod offsetPath:[self needle2pathforiphonePath] by:CGPointMake(17.5, 44.88)].CGPath;
    needle2PositionAnim.rotationMode    = kCAAnimationRotateAutoReverse;
    needle2PositionAnim.calculationMode = kCAAnimationCubicPaced;
    needle2PositionAnim.duration        = 0.715;
    needle2PositionAnim.beginTime       = 1.46;
    needle2PositionAnim.timingFunction  = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAKeyframeAnimation * needle2HiddenAnim = [CAKeyframeAnimation animationWithKeyPath:@"hidden"];
    needle2HiddenAnim.values   = @[@YES, @YES, @NO];
    needle2HiddenAnim.keyTimes = @[@0, @0.911, @1];
    needle2HiddenAnim.duration = 2.27;
    
    CAAnimationGroup * needle2IphoneindividualAnim = [QCMethod groupAnimations:@[needle2PositionAnim, needle2HiddenAnim] fillMode:fillMode];
    [self.layers[@"needle2"] addAnimation:needle2IphoneindividualAnim forKey:@"needle2IphoneindividualAnim"];
    
    ////Local animation
    CAKeyframeAnimation * localHiddenAnim = [CAKeyframeAnimation animationWithKeyPath:@"hidden"];
    localHiddenAnim.values                = @[@YES, @YES, @NO];
    localHiddenAnim.keyTimes              = @[@0, @0.911, @1];
    localHiddenAnim.duration              = 2.27;
    
    CAKeyframeAnimation * localPositionAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    localPositionAnim.path            = [QCMethod offsetPath:[self localpathforiphonePath] by:CGPointMake(0, 27.38)].CGPath;
    localPositionAnim.calculationMode = kCAAnimationCubicPaced;
    localPositionAnim.duration        = 0.715;
    localPositionAnim.beginTime       = 1.46;
    localPositionAnim.timingFunction  = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup * localIphoneindividualAnim = [QCMethod groupAnimations:@[localHiddenAnim, localPositionAnim] fillMode:fillMode];
    [self.layers[@"local"] addAnimation:localIphoneindividualAnim forKey:@"localIphoneindividualAnim"];
    
    ////Global animation
    CAKeyframeAnimation * globalPositionAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    globalPositionAnim.path            = [QCMethod offsetPath:[self globalpathforiphonePath] by:CGPointMake(0, 27.38)].CGPath;
    globalPositionAnim.calculationMode = kCAAnimationCubicPaced;
    globalPositionAnim.duration        = 0.715;
    globalPositionAnim.beginTime       = 1.46;
    globalPositionAnim.timingFunction  = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAKeyframeAnimation * globalHiddenAnim = [CAKeyframeAnimation animationWithKeyPath:@"hidden"];
    globalHiddenAnim.values                = @[@YES, @YES, @NO];
    globalHiddenAnim.keyTimes              = @[@0, @0.911, @1];
    globalHiddenAnim.duration              = 2.27;
    
    CAAnimationGroup * globalIphoneindividualAnim = [QCMethod groupAnimations:@[globalPositionAnim, globalHiddenAnim] fillMode:fillMode];
    [self.layers[@"global"] addAnimation:globalIphoneindividualAnim forKey:@"globalIphoneindividualAnim"];
}


-(void)innertime{
    inner1=[NSTimer scheduledTimerWithTimeInterval:(1.71/actual) target:self selector:@selector(innersum) userInfo:nil repeats:YES];
}

-(void)innersum{
    if(innercount!=actual){
        innercount++;
        if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){
            innerscoreforipad.string=[NSString stringWithFormat:@"%d",innercount];
        }else{
            innerscoreforiphone.string=[NSString stringWithFormat:@"%d",innercount];
        }
    }
    else{
        [inner1 invalidate];
        [inner invalidate];
    }
}


-(void)humantime{
    NSTimeInterval n=1.71/(float)human;
    ti1=[NSTimer scheduledTimerWithTimeInterval:n target:self selector:@selector(humansum) userInfo:nil repeats:YES];
}

-(void)humansum{
    if(temphuman!=human){
        temphuman++;
        if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){
            humanscoreforipad.string=[NSString stringWithFormat:@"%d",temphuman];
        }else{
        humanscoreforiphone.string=[NSString stringWithFormat:@"%d",temphuman];
        }
    }
    else{
        [ti1 invalidate];
        [t1 invalidate];
    }
}

-(void)transporttime{
        NSTimeInterval n=1.71/(float)transport;
    ti2=[NSTimer scheduledTimerWithTimeInterval:n target:self selector:@selector(transportsum) userInfo:nil repeats:YES];
}

-(void)transportsum{
    if(temptransport!=transport){
        temptransport++;
                if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){
                    transportscoreforipad.string=[NSString stringWithFormat:@"%d",temptransport];
                }
                else{
        transportscoreforiphone.string=[NSString stringWithFormat:@"%d",temptransport];
                }
    }
    else{
        [ti2 invalidate];
        [t2 invalidate];
    }
}

-(void)middletime{
        NSTimeInterval n=1.71/(float)actual;
    middle1=[NSTimer scheduledTimerWithTimeInterval:n target:self selector:@selector(middlesum) userInfo:nil repeats:YES];
}

-(void)middlesum{
    if(middlecount!=actual){
        middlecount++;
        if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){
            middlescoreforipad.string=[NSString stringWithFormat:@"%d",middlecount];
        }
        else{
            middlescoreforiphone.string=[NSString stringWithFormat:@"%d",middlecount];
        }
    }
    else{
        [middle1 invalidate];
        [middle invalidate];
    }
}

-(void)wastetime{
        NSTimeInterval n=1.71/(float)waste;
    ti3=[NSTimer scheduledTimerWithTimeInterval:n target:self selector:@selector(wastesum) userInfo:nil repeats:YES];
}

-(void)wastesum{
    if(tempwaste!=waste){
        tempwaste++;
          if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){
        wastescoreforipad.string=[NSString stringWithFormat:@"%d",tempwaste];
          }
          else{
        wastescoreforiphone.string=[NSString stringWithFormat:@"%d",tempwaste];
          }
    }
    else{
        [ti3 invalidate];
        [t3 invalidate];
    }
}

-(void)outertime{
        NSTimeInterval n=1.71/(float)actual;
    outer1=[NSTimer scheduledTimerWithTimeInterval:n target:self selector:@selector(outersum) userInfo:nil repeats:YES];
}

-(void)outersum{
    if(outeractual!=actual){
        outeractual++;
        if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){
            outerscoreforipad.string=[NSString stringWithFormat:@"%d",outeractual];
        }
        else{
            outerscoreforiphone.string=[NSString stringWithFormat:@"%d",outeractual];
        }
    }
    else{
        [outer1 invalidate];
        [outer invalidate];
    }
}

-(void)watertime{
        NSTimeInterval n=1.71/(float)water;
    ti4=[NSTimer scheduledTimerWithTimeInterval:n target:self selector:@selector(watersum) userInfo:nil repeats:YES];
}

-(void)watersum{
    if(tempwater!=water){
        tempwater++;
         if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){
        waterscoreforipad.string=[NSString stringWithFormat:@"%d",tempwater];
         }else{
        waterscoreforiphone.string=[NSString stringWithFormat:@"%d",tempwater];
         }
    }
    else{
        [ti4 invalidate];
        [t4 invalidate];
    }
}

-(void)energytime{
        NSTimeInterval n=1.71/(float)energy;
    ti5=[NSTimer scheduledTimerWithTimeInterval:n target:self selector:@selector(energysum) userInfo:nil repeats:YES];
}

-(void)energysum{
    if(tempenergy!=energy){
        tempenergy++;
         if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){
        energyscoreforipad.string=[NSString stringWithFormat:@"%d",tempenergy];
         }else{
        energyscoreforiphone.string=[NSString stringWithFormat:@"%d",tempenergy];
         }
    }
    else{
        [ti5 invalidate];
        [t5 invalidate];
    }
}

- (void)addIphoneanimationAnimation{
    NSString * fillMode = kCAFillModeForwards;

    ////Puckforiphone animation
    CAKeyframeAnimation * puckforiphoneBoundsAnim = [CAKeyframeAnimation animationWithKeyPath:@"bounds"];
    puckforiphoneBoundsAnim.values   = @[[NSValue valueWithCGRect:CGRectMake(0, 0, 0, 0)], [NSValue valueWithCGRect:CGRectMake(0, 0, 89, 89)]];
    puckforiphoneBoundsAnim.keyTimes = @[@0, @1];
    puckforiphoneBoundsAnim.duration = 0.296;
    
    CAAnimationGroup * puckforiphoneIphoneanimationAnim = [QCMethod groupAnimations:@[puckforiphoneBoundsAnim] fillMode:fillMode];
    [self.layers[@"puckforiphone"] addAnimation:puckforiphoneIphoneanimationAnim forKey:@"puckforiphoneIphoneanimationAnim"];
    
    ////Puckscoreforiphone animation
    CAKeyframeAnimation * puckscoreforiphoneTransformAnim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    puckscoreforiphoneTransformAnim.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.2, 0.2, 1)],
                                               [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    puckscoreforiphoneTransformAnim.keyTimes = @[@0, @1];
    puckscoreforiphoneTransformAnim.duration = 0.289;
    
    CAAnimationGroup * puckscoreforiphoneIphoneanimationAnim = [QCMethod groupAnimations:@[puckscoreforiphoneTransformAnim] fillMode:fillMode];
    [self.layers[@"puckscoreforiphone"] addAnimation:puckscoreforiphoneIphoneanimationAnim forKey:@"puckscoreforiphoneIphoneanimationAnim"];
    
    ////Humanstartpathforiphone animation
    CAKeyframeAnimation * humanstartpathforiphoneStrokeEndAnim = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    humanstartpathforiphoneStrokeEndAnim.values = @[@0, @1];
    humanstartpathforiphoneStrokeEndAnim.keyTimes = @[@0, @1];
    humanstartpathforiphoneStrokeEndAnim.duration = 0.296;
    
    CAAnimationGroup * humanstartpathforiphoneIphoneanimationAnim = [QCMethod groupAnimations:@[humanstartpathforiphoneStrokeEndAnim] fillMode:fillMode];
    [self.layers[@"humanstartpathforiphone"] addAnimation:humanstartpathforiphoneIphoneanimationAnim forKey:@"humanstartpathforiphoneIphoneanimationAnim"];
    
    ////Humanarrowforiphone animation
    CAKeyframeAnimation * humanarrowforiphonePositionAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    humanarrowforiphonePositionAnim.path = [QCMethod offsetPath:[self humanstartingforiphonePath] by:CGPointMake(89.95, 5.46)].CGPath;
    humanarrowforiphonePositionAnim.rotationMode = kCAAnimationRotateAutoReverse;
    humanarrowforiphonePositionAnim.calculationMode = kCAAnimationCubicPaced;
    humanarrowforiphonePositionAnim.duration = 1.71;
    humanarrowforiphonePositionAnim.beginTime = 0.289;
    humanarrowforiphonePositionAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAKeyframeAnimation * humanarrowforiphoneHiddenAnim = [CAKeyframeAnimation animationWithKeyPath:@"hidden"];
    humanarrowforiphoneHiddenAnim.values   = @[@YES, @NO];
    humanarrowforiphoneHiddenAnim.keyTimes = @[@0, @1];
    humanarrowforiphoneHiddenAnim.duration = 0.583;
    
    CAKeyframeAnimation * humanarrowforiphoneOpacityAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    humanarrowforiphoneOpacityAnim.values = @[@1, @0];
    humanarrowforiphoneOpacityAnim.keyTimes = @[@0, @1];
    humanarrowforiphoneOpacityAnim.duration = 0.552;
    humanarrowforiphoneOpacityAnim.beginTime = 1.45;
    
    if(human<mhuman){
    CAAnimationGroup * humanarrowforiphoneIphoneanimationAnim = [QCMethod groupAnimations:@[humanarrowforiphonePositionAnim, humanarrowforiphoneHiddenAnim] fillMode:fillMode];
    [self.layers[@"humanarrowforiphone"] addAnimation:humanarrowforiphoneIphoneanimationAnim forKey:@"humanarrowforiphoneIphoneanimationAnim"];
    }else{
        CAAnimationGroup * humanarrowforiphoneIphoneanimationAnim = [QCMethod groupAnimations:@[humanarrowforiphonePositionAnim, humanarrowforiphoneHiddenAnim,humanarrowforiphoneOpacityAnim] fillMode:fillMode];
        [self.layers[@"humanarrowforiphone"] addAnimation:humanarrowforiphoneIphoneanimationAnim forKey:@"humanarrowforiphoneIphoneanimationAnim"];
    }
    
    ////Humanstartingforiphone animation
    CAKeyframeAnimation * humanstartingforiphoneStrokeEndAnim = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    humanstartingforiphoneStrokeEndAnim.values = @[@0, @1];
    humanstartingforiphoneStrokeEndAnim.keyTimes = @[@0, @1];
    temphuman=0;
    t1=[NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(humantime) userInfo:nil repeats:NO];
    humanstartingforiphoneStrokeEndAnim.duration = 1.71;
    humanstartingforiphoneStrokeEndAnim.beginTime = 0.296;
    humanstartingforiphoneStrokeEndAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup * humanstartingforiphoneIphoneanimationAnim = [QCMethod groupAnimations:@[humanstartingforiphoneStrokeEndAnim] fillMode:fillMode];
    [self.layers[@"humanstartingforiphone"] addAnimation:humanstartingforiphoneIphoneanimationAnim forKey:@"humanstartingforiphoneIphoneanimationAnim"];
    
    ////Humanscoreforiphone animation
    CAKeyframeAnimation * humanscoreforiphoneHiddenAnim = [CAKeyframeAnimation animationWithKeyPath:@"hidden"];
    humanscoreforiphoneHiddenAnim.values   = @[@YES, @NO];
    humanscoreforiphoneHiddenAnim.keyTimes = @[@0, @1];
    humanscoreforiphoneHiddenAnim.duration = 0.583;
    
    CAKeyframeAnimation * humanscoreforiphonePositionAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    humanscoreforiphonePositionAnim.path = [QCMethod offsetPath:[self humanscoreforiphonePath] by:CGPointMake(89.95, 5.46)].CGPath;
    
    humanscoreforiphonePositionAnim.calculationMode = kCAAnimationCubicPaced;
    humanscoreforiphonePositionAnim.duration = 1.71;
    humanscoreforiphonePositionAnim.beginTime = 0.289;
    humanscoreforiphonePositionAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup * humanscoreforiphoneIphoneanimationAnim = [QCMethod groupAnimations:@[humanscoreforiphoneHiddenAnim, humanscoreforiphonePositionAnim] fillMode:fillMode];
    [self.layers[@"humanscoreforiphone"] addAnimation:humanscoreforiphoneIphoneanimationAnim forKey:@"humanscoreforiphoneIphoneanimationAnim"];
    
    ////Transportstartpathforiphone animation
    CAKeyframeAnimation * transportstartpathforiphoneStrokeEndAnim = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    transportstartpathforiphoneStrokeEndAnim.values = @[@0, @1];
    transportstartpathforiphoneStrokeEndAnim.keyTimes = @[@0, @1];
    transportstartpathforiphoneStrokeEndAnim.duration = 0.296;
    
    CAAnimationGroup * transportstartpathforiphoneIphoneanimationAnim = [QCMethod groupAnimations:@[transportstartpathforiphoneStrokeEndAnim] fillMode:fillMode];
    [self.layers[@"transportstartpathforiphone"] addAnimation:transportstartpathforiphoneIphoneanimationAnim forKey:@"transportstartpathforiphoneIphoneanimationAnim"];
    
    ////Transportstartingforiphone animation
    CAKeyframeAnimation * transportstartingforiphoneStrokeEndAnim = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    transportstartingforiphoneStrokeEndAnim.values = @[@0, @1];
    transportstartingforiphoneStrokeEndAnim.keyTimes = @[@0, @1];
    temptransport=0;
    t2=[NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(transporttime) userInfo:nil repeats:NO];
    transportstartingforiphoneStrokeEndAnim.duration = 1.71;
    transportstartingforiphoneStrokeEndAnim.beginTime = 0.296;
    transportstartingforiphoneStrokeEndAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup * transportstartingforiphoneIphoneanimationAnim = [QCMethod groupAnimations:@[transportstartingforiphoneStrokeEndAnim] fillMode:fillMode];
    [self.layers[@"transportstartingforiphone"] addAnimation:transportstartingforiphoneIphoneanimationAnim forKey:@"transportstartingforiphoneIphoneanimationAnim"];
    
    ////Transportarrowforiphone animation
    CAKeyframeAnimation * transportarrowforiphonePositionAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    transportarrowforiphonePositionAnim.path = [QCMethod offsetPath:[self transportstartingforiphonePath] by:CGPointMake(70.22, 5.46)].CGPath;
    transportarrowforiphonePositionAnim.rotationMode = kCAAnimationRotateAutoReverse;
    transportarrowforiphonePositionAnim.calculationMode = kCAAnimationCubicPaced;
    transportarrowforiphonePositionAnim.duration = 1.71;
    transportarrowforiphonePositionAnim.beginTime = 0.289;
    transportarrowforiphonePositionAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAKeyframeAnimation * transportarrowforiphoneHiddenAnim = [CAKeyframeAnimation animationWithKeyPath:@"hidden"];
    transportarrowforiphoneHiddenAnim.values = @[@YES, @NO];
    transportarrowforiphoneHiddenAnim.keyTimes = @[@0, @1];
    transportarrowforiphoneHiddenAnim.duration = 0.583;
    
    CAKeyframeAnimation * transportarrowforiphoneOpacityAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    transportarrowforiphoneOpacityAnim.values = @[@1, @0];
    transportarrowforiphoneOpacityAnim.keyTimes = @[@0, @1];
    transportarrowforiphoneOpacityAnim.duration = 0.552;
    transportarrowforiphoneOpacityAnim.beginTime = 1.45;
    
    if(transport<mtransport){
    CAAnimationGroup * transportarrowforiphoneIphoneanimationAnim = [QCMethod groupAnimations:@[transportarrowforiphonePositionAnim, transportarrowforiphoneHiddenAnim] fillMode:fillMode];
    [self.layers[@"transportarrowforiphone"] addAnimation:transportarrowforiphoneIphoneanimationAnim forKey:@"transportarrowforiphoneIphoneanimationAnim"];
    }else{
        CAAnimationGroup * transportarrowforiphoneIphoneanimationAnim = [QCMethod groupAnimations:@[transportarrowforiphonePositionAnim, transportarrowforiphoneHiddenAnim,transportarrowforiphoneOpacityAnim] fillMode:fillMode];
        [self.layers[@"transportarrowforiphone"] addAnimation:transportarrowforiphoneIphoneanimationAnim forKey:@"transportarrowforiphoneIphoneanimationAnim"];
        
    }
    
    ////Transportscoreforiphone animation
    CAKeyframeAnimation * transportscoreforiphoneHiddenAnim = [CAKeyframeAnimation animationWithKeyPath:@"hidden"];
    transportscoreforiphoneHiddenAnim.values = @[@YES, @NO];
    transportscoreforiphoneHiddenAnim.keyTimes = @[@0, @1];
    transportscoreforiphoneHiddenAnim.duration = 0.583;
    
    CAKeyframeAnimation * transportscoreforiphonePositionAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    transportscoreforiphonePositionAnim.path = [QCMethod offsetPath:[self transportscoreforiphonePath] by:CGPointMake(70.22, 5.46)].CGPath;
    transportscoreforiphonePositionAnim.calculationMode = kCAAnimationCubicPaced;
    transportscoreforiphonePositionAnim.duration = 1.71;
    transportscoreforiphonePositionAnim.beginTime = 0.289;
    transportscoreforiphonePositionAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup * transportscoreforiphoneIphoneanimationAnim = [QCMethod groupAnimations:@[transportscoreforiphoneHiddenAnim, transportscoreforiphonePositionAnim] fillMode:fillMode];
    [self.layers[@"transportscoreforiphone"] addAnimation:transportscoreforiphoneIphoneanimationAnim forKey:@"transportscoreforiphoneIphoneanimationAnim"];
    
    ////Wastestartpathforiphone animation
    CAKeyframeAnimation * wastestartpathforiphoneStrokeEndAnim = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    wastestartpathforiphoneStrokeEndAnim.values = @[@0, @1];
    wastestartpathforiphoneStrokeEndAnim.keyTimes = @[@0, @1];
    wastestartpathforiphoneStrokeEndAnim.duration = 0.296;
    
    CAAnimationGroup * wastestartpathforiphoneIphoneanimationAnim = [QCMethod groupAnimations:@[wastestartpathforiphoneStrokeEndAnim] fillMode:fillMode];
    [self.layers[@"wastestartpathforiphone"] addAnimation:wastestartpathforiphoneIphoneanimationAnim forKey:@"wastestartpathforiphoneIphoneanimationAnim"];
    
    ////Wastestartingforiphone animation
    CAKeyframeAnimation * wastestartingforiphoneStrokeEndAnim = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    wastestartingforiphoneStrokeEndAnim.values = @[@0, @1];
    wastestartingforiphoneStrokeEndAnim.keyTimes = @[@0, @1];
    tempwaste=0;
    t3=[NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(wastetime) userInfo:nil repeats:NO];
    wastestartingforiphoneStrokeEndAnim.duration = 1.71;
    wastestartingforiphoneStrokeEndAnim.beginTime = 0.296;
    wastestartingforiphoneStrokeEndAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup * wastestartingforiphoneIphoneanimationAnim = [QCMethod groupAnimations:@[wastestartingforiphoneStrokeEndAnim] fillMode:fillMode];
    [self.layers[@"wastestartingforiphone"] addAnimation:wastestartingforiphoneIphoneanimationAnim forKey:@"wastestartingforiphoneIphoneanimationAnim"];
    
    ////Wastearrowforiphone animation
    CAKeyframeAnimation * wastearrowforiphonePositionAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    wastearrowforiphonePositionAnim.path = [QCMethod offsetPath:[self wastestartingforiphonePath] by:CGPointMake(50.88, 5.96)].CGPath;
    wastearrowforiphonePositionAnim.rotationMode = kCAAnimationRotateAutoReverse;
    wastearrowforiphonePositionAnim.calculationMode = kCAAnimationCubicPaced;
    wastearrowforiphonePositionAnim.duration = 1.71;
    wastearrowforiphonePositionAnim.beginTime = 0.289;
    wastearrowforiphonePositionAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAKeyframeAnimation * wastearrowforiphoneHiddenAnim = [CAKeyframeAnimation animationWithKeyPath:@"hidden"];
    wastearrowforiphoneHiddenAnim.values   = @[@YES, @NO];
    wastearrowforiphoneHiddenAnim.keyTimes = @[@0, @1];
    wastearrowforiphoneHiddenAnim.duration = 0.583;
    
    CAKeyframeAnimation * wastearrowforiphoneOpacityAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    wastearrowforiphoneOpacityAnim.values = @[@1, @0];
    wastearrowforiphoneOpacityAnim.keyTimes = @[@0, @1];
    wastearrowforiphoneOpacityAnim.duration = 0.552;
    wastearrowforiphoneOpacityAnim.beginTime = 1.45;
    
    if(waste<mwaste){
    CAAnimationGroup * wastearrowforiphoneIphoneanimationAnim = [QCMethod groupAnimations:@[wastearrowforiphonePositionAnim, wastearrowforiphoneHiddenAnim] fillMode:fillMode];
    [self.layers[@"wastearrowforiphone"] addAnimation:wastearrowforiphoneIphoneanimationAnim forKey:@"wastearrowforiphoneIphoneanimationAnim"];
    }else{
        CAAnimationGroup * wastearrowforiphoneIphoneanimationAnim = [QCMethod groupAnimations:@[wastearrowforiphonePositionAnim, wastearrowforiphoneHiddenAnim,wastearrowforiphoneOpacityAnim] fillMode:fillMode];
        [self.layers[@"wastearrowforiphone"] addAnimation:wastearrowforiphoneIphoneanimationAnim forKey:@"wastearrowforiphoneIphoneanimationAnim"];
        
    }
    
    ////Wastescoreforiphone animation
    CAKeyframeAnimation * wastescoreforiphoneHiddenAnim = [CAKeyframeAnimation animationWithKeyPath:@"hidden"];
    wastescoreforiphoneHiddenAnim.values   = @[@YES, @NO];
    wastescoreforiphoneHiddenAnim.keyTimes = @[@0, @1];
    wastescoreforiphoneHiddenAnim.duration = 0.583;
    
    CAKeyframeAnimation * wastescoreforiphonePositionAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    wastescoreforiphonePositionAnim.path = [QCMethod offsetPath:[self wastescoreforiphonePath] by:CGPointMake(50.88, 5.96)].CGPath;
    wastescoreforiphonePositionAnim.calculationMode = kCAAnimationCubicPaced;
    wastescoreforiphonePositionAnim.duration = 1.71;
    wastescoreforiphonePositionAnim.beginTime = 0.289;
    wastescoreforiphonePositionAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup * wastescoreforiphoneIphoneanimationAnim = [QCMethod groupAnimations:@[wastescoreforiphoneHiddenAnim, wastescoreforiphonePositionAnim] fillMode:fillMode];
    [self.layers[@"wastescoreforiphone"] addAnimation:wastescoreforiphoneIphoneanimationAnim forKey:@"wastescoreforiphoneIphoneanimationAnim"];
    
    ////Waterstartpathforiphone animation
    CAKeyframeAnimation * waterstartpathforiphoneStrokeEndAnim = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    waterstartpathforiphoneStrokeEndAnim.values = @[@0, @1];
    waterstartpathforiphoneStrokeEndAnim.keyTimes = @[@0, @1];
    waterstartpathforiphoneStrokeEndAnim.duration = 0.296;
    
    CAAnimationGroup * waterstartpathforiphoneIphoneanimationAnim = [QCMethod groupAnimations:@[waterstartpathforiphoneStrokeEndAnim] fillMode:fillMode];
    [self.layers[@"waterstartpathforiphone"] addAnimation:waterstartpathforiphoneIphoneanimationAnim forKey:@"waterstartpathforiphoneIphoneanimationAnim"];
    
    ////Waterstartingforiphone animation
    CAKeyframeAnimation * waterstartingforiphoneStrokeEndAnim = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    waterstartingforiphoneStrokeEndAnim.values = @[@0, @1];
    waterstartingforiphoneStrokeEndAnim.keyTimes = @[@0, @1];
    tempwater=0;
    t4=[NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(watertime) userInfo:nil repeats:NO];
    waterstartingforiphoneStrokeEndAnim.duration = 1.71;
    waterstartingforiphoneStrokeEndAnim.beginTime = 0.296;
    waterstartingforiphoneStrokeEndAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup * waterstartingforiphoneIphoneanimationAnim = [QCMethod groupAnimations:@[waterstartingforiphoneStrokeEndAnim] fillMode:fillMode];
    [self.layers[@"waterstartingforiphone"] addAnimation:waterstartingforiphoneIphoneanimationAnim forKey:@"waterstartingforiphoneIphoneanimationAnim"];
    
    ////Waterarrowforiphone animation
    CAKeyframeAnimation * waterarrowforiphonePositionAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    waterarrowforiphonePositionAnim.path = [QCMethod offsetPath:[self waterstartingforiphonePath] by:CGPointMake(31.28, 5.43)].CGPath;
    waterarrowforiphonePositionAnim.rotationMode = kCAAnimationRotateAutoReverse;
    waterarrowforiphonePositionAnim.calculationMode = kCAAnimationCubicPaced;
    waterarrowforiphonePositionAnim.duration = 1.71;
    waterarrowforiphonePositionAnim.beginTime = 0.289;
    waterarrowforiphonePositionAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAKeyframeAnimation * waterarrowforiphoneHiddenAnim = [CAKeyframeAnimation animationWithKeyPath:@"hidden"];
    waterarrowforiphoneHiddenAnim.values   = @[@YES, @NO];
    waterarrowforiphoneHiddenAnim.keyTimes = @[@0, @1];
    waterarrowforiphoneHiddenAnim.duration = 0.583;
    
    if(water<mwater){
    CAAnimationGroup * waterarrowforiphoneIphoneanimationAnim = [QCMethod groupAnimations:@[waterarrowforiphonePositionAnim, waterarrowforiphoneHiddenAnim] fillMode:fillMode];
    [self.layers[@"waterarrowforiphone"] addAnimation:waterarrowforiphoneIphoneanimationAnim forKey:@"waterarrowforiphoneIphoneanimationAnim"];
    }else{
        CAAnimationGroup * waterarrowforiphoneIphoneanimationAnim = [QCMethod groupAnimations:@[waterarrowforiphonePositionAnim, waterarrowforiphoneHiddenAnim,wastearrowforiphoneOpacityAnim] fillMode:fillMode];
        [self.layers[@"waterarrowforiphone"] addAnimation:waterarrowforiphoneIphoneanimationAnim forKey:@"waterarrowforiphoneIphoneanimationAnim"];
    }
    
    ////Waterscoreforiphone animation
    CAKeyframeAnimation * waterscoreforiphoneHiddenAnim = [CAKeyframeAnimation animationWithKeyPath:@"hidden"];
    waterscoreforiphoneHiddenAnim.values   = @[@YES, @NO];
    waterscoreforiphoneHiddenAnim.keyTimes = @[@0, @1];
    waterscoreforiphoneHiddenAnim.duration = 0.583;
    
    CAKeyframeAnimation * waterscoreforiphonePositionAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    waterscoreforiphonePositionAnim.path = [QCMethod offsetPath:[self waterscoreforiphonePath] by:CGPointMake(31.28, 5.43)].CGPath;
    waterscoreforiphonePositionAnim.calculationMode = kCAAnimationCubicPaced;
    waterscoreforiphonePositionAnim.duration = 1.71;
    waterscoreforiphonePositionAnim.beginTime = 0.289;
    waterscoreforiphonePositionAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup * waterscoreforiphoneIphoneanimationAnim = [QCMethod groupAnimations:@[waterscoreforiphoneHiddenAnim, waterscoreforiphonePositionAnim] fillMode:fillMode];
    [self.layers[@"waterscoreforiphone"] addAnimation:waterscoreforiphoneIphoneanimationAnim forKey:@"waterscoreforiphoneIphoneanimationAnim"];
    
    ////Energystartingforiphone animation
    CAKeyframeAnimation * energystartingforiphoneStrokeEndAnim = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    energystartingforiphoneStrokeEndAnim.values = @[@0, @1];
    energystartingforiphoneStrokeEndAnim.keyTimes = @[@0, @1];
    tempenergy=0;
    t5=[NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(energytime) userInfo:nil repeats:NO];
    energystartingforiphoneStrokeEndAnim.duration = 1.71;
    energystartingforiphoneStrokeEndAnim.beginTime = 0.296;
    energystartingforiphoneStrokeEndAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup * energystartingforiphoneIphoneanimationAnim = [QCMethod groupAnimations:@[energystartingforiphoneStrokeEndAnim] fillMode:fillMode];
    [self.layers[@"energystartingforiphone"] addAnimation:energystartingforiphoneIphoneanimationAnim forKey:@"energystartingforiphoneIphoneanimationAnim"];
    
    ////Energyarrowforiphone animation
    CAKeyframeAnimation * energyarrowforiphonePositionAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    energyarrowforiphonePositionAnim.path = [QCMethod offsetPath:[self energystartingforiphonePath] by:CGPointMake(9.74, 5.72)].CGPath;
    energyarrowforiphonePositionAnim.rotationMode = kCAAnimationRotateAutoReverse;
    energyarrowforiphonePositionAnim.calculationMode = kCAAnimationCubicPaced;
    energyarrowforiphonePositionAnim.duration = 1.71;
    energyarrowforiphonePositionAnim.beginTime = 0.289;
    energyarrowforiphonePositionAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAKeyframeAnimation * energyarrowforiphoneHiddenAnim = [CAKeyframeAnimation animationWithKeyPath:@"hidden"];
    energyarrowforiphoneHiddenAnim.values = @[@YES, @NO];
    energyarrowforiphoneHiddenAnim.keyTimes = @[@0, @1];
    energyarrowforiphoneHiddenAnim.duration = 0.583;
    
    if(energy<menergy){
    CAAnimationGroup * energyarrowforiphoneIphoneanimationAnim = [QCMethod groupAnimations:@[energyarrowforiphonePositionAnim, energyarrowforiphoneHiddenAnim] fillMode:fillMode];
    [self.layers[@"energyarrowforiphone"] addAnimation:energyarrowforiphoneIphoneanimationAnim forKey:@"energyarrowforiphoneIphoneanimationAnim"];
    }else{
        CAAnimationGroup * energyarrowforiphoneIphoneanimationAnim = [QCMethod groupAnimations:@[energyarrowforiphonePositionAnim, energyarrowforiphoneHiddenAnim,wastearrowforiphoneOpacityAnim] fillMode:fillMode];
        [self.layers[@"energyarrowforiphone"] addAnimation:energyarrowforiphoneIphoneanimationAnim forKey:@"energyarrowforiphoneIphoneanimationAnim"];
    }
    
    ////Energyscoreforiphone animation
    CAKeyframeAnimation * energyscoreforiphoneHiddenAnim = [CAKeyframeAnimation animationWithKeyPath:@"hidden"];
    energyscoreforiphoneHiddenAnim.values = @[@YES, @NO];
    energyscoreforiphoneHiddenAnim.keyTimes = @[@0, @1];
    energyscoreforiphoneHiddenAnim.duration = 0.583;
    
    CAKeyframeAnimation * energyscoreforiphonePositionAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    energyscoreforiphonePositionAnim.path = [QCMethod offsetPath:[self energyscoreforiphonePath] by:CGPointMake(9.74, 5.72)].CGPath;
    tempenergy=0;

    
    energyscoreforiphonePositionAnim.calculationMode = kCAAnimationCubicPaced;
    energyscoreforiphonePositionAnim.duration = 1.71;
    energyscoreforiphonePositionAnim.beginTime = 0.289;
    energyscoreforiphonePositionAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup * energyscoreforiphoneIphoneanimationAnim = [QCMethod groupAnimations:@[energyscoreforiphoneHiddenAnim, energyscoreforiphonePositionAnim] fillMode:fillMode];
    [self.layers[@"energyscoreforiphone"] addAnimation:energyscoreforiphoneIphoneanimationAnim forKey:@"energyscoreforiphoneIphoneanimationAnim"];
    
    ////Energystartpathforiphone animation
    CAKeyframeAnimation * energystartpathforiphoneStrokeEndAnim = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    energystartpathforiphoneStrokeEndAnim.values = @[@0, @1];
    energystartpathforiphoneStrokeEndAnim.keyTimes = @[@0, @1];
    energystartpathforiphoneStrokeEndAnim.duration = 0.296;
    
    CAAnimationGroup * energystartpathforiphoneIphoneanimationAnim = [QCMethod groupAnimations:@[energystartpathforiphoneStrokeEndAnim] fillMode:fillMode];
    [self.layers[@"energystartpathforiphone"] addAnimation:energystartpathforiphoneIphoneanimationAnim forKey:@"energystartpathforiphoneIphoneanimationAnim"];
}


- (void)addIpadanimationAnimation{
    NSString * fillMode = kCAFillModeForwards;
    
    ////Puckforipad animation
    CAKeyframeAnimation * puckforipadBoundsAnim = [CAKeyframeAnimation animationWithKeyPath:@"bounds"];
    puckforipadBoundsAnim.values   = @[[NSValue valueWithCGRect:CGRectMake(0, 0, 0, 0)], [NSValue valueWithCGRect:CGRectMake(0, 0, 170, 170)]];
    puckforipadBoundsAnim.keyTimes = @[@0, @1];
    puckforipadBoundsAnim.duration = 0.296;
    
    CAAnimationGroup * puckforipadIpadanimationAnim = [QCMethod groupAnimations:@[puckforipadBoundsAnim] fillMode:fillMode];
    [self.layers[@"puckforipad"] addAnimation:puckforipadIpadanimationAnim forKey:@"puckforipadIpadanimationAnim"];
    
    ////Puckscoreforipad animation
    CAKeyframeAnimation * puckscoreforipadTransformAnim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    puckscoreforipadTransformAnim.values   = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.2, 0.2, 1)],
                                               [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    puckscoreforipadTransformAnim.keyTimes = @[@0, @1];
    puckscoreforipadTransformAnim.duration = 0.289;
    
    CAAnimationGroup * puckscoreforipadIpadanimationAnim = [QCMethod groupAnimations:@[puckscoreforipadTransformAnim] fillMode:fillMode];
    [self.layers[@"puckscoreforipad"] addAnimation:puckscoreforipadIpadanimationAnim forKey:@"puckscoreforipadIpadanimationAnim"];
    
    ////Humanstartpathforipad animation
    CAKeyframeAnimation * humanstartpathforipadStrokeEndAnim = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    humanstartpathforipadStrokeEndAnim.values = @[@0, @1];
    humanstartpathforipadStrokeEndAnim.keyTimes = @[@0, @1];
    humanstartpathforipadStrokeEndAnim.duration = 0.296;
    
    CAAnimationGroup * humanstartpathforipadIpadanimationAnim = [QCMethod groupAnimations:@[humanstartpathforipadStrokeEndAnim] fillMode:fillMode];
    [self.layers[@"humanstartpathforipad"] addAnimation:humanstartpathforipadIpadanimationAnim forKey:@"humanstartpathforipadIpadanimationAnim"];
    
    CAKeyframeAnimation * humanarrowforiphoneOpacityAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    humanarrowforiphoneOpacityAnim.values = @[@1, @0];
    humanarrowforiphoneOpacityAnim.keyTimes = @[@0, @1];
    humanarrowforiphoneOpacityAnim.duration = 0.552;
    humanarrowforiphoneOpacityAnim.beginTime = 1.45;
    
    ////Humanarrowforipad animation
    CAKeyframeAnimation * humanarrowforipadPositionAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    humanarrowforipadPositionAnim.path     = [QCMethod offsetPath:[self humanstartingforipadPath] by:CGPointMake(240.27, 10.32)].CGPath;
    humanarrowforipadPositionAnim.rotationMode = kCAAnimationRotateAutoReverse;
    humanarrowforipadPositionAnim.calculationMode = kCAAnimationCubicPaced;
    humanarrowforipadPositionAnim.duration = 1.71;
    humanarrowforipadPositionAnim.beginTime = 0.289;
    humanarrowforipadPositionAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAKeyframeAnimation * humanarrowforipadHiddenAnim = [CAKeyframeAnimation animationWithKeyPath:@"hidden"];
    humanarrowforipadHiddenAnim.values   = @[@YES, @NO];
    humanarrowforipadHiddenAnim.keyTimes = @[@0, @1];
    humanarrowforipadHiddenAnim.duration = 0.583;
    
    if(human<mhuman){
    CAAnimationGroup * humanarrowforipadIpadanimationAnim = [QCMethod groupAnimations:@[humanarrowforipadPositionAnim, humanarrowforipadHiddenAnim] fillMode:fillMode];
    [self.layers[@"humanarrowforipad"] addAnimation:humanarrowforipadIpadanimationAnim forKey:@"humanarrowforipadIpadanimationAnim"];
    }else{
        CAAnimationGroup * humanarrowforipadIpadanimationAnim = [QCMethod groupAnimations:@[humanarrowforipadPositionAnim, humanarrowforipadHiddenAnim,humanarrowforiphoneOpacityAnim] fillMode:fillMode];
        [self.layers[@"humanarrowforipad"] addAnimation:humanarrowforipadIpadanimationAnim forKey:@"humanarrowforipadIpadanimationAnim"];
    }
    
    ////Humanstartingforipad animation
    CAKeyframeAnimation * humanstartingforipadStrokeEndAnim = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    humanstartingforipadStrokeEndAnim.values = @[@0, @1];
    humanstartingforipadStrokeEndAnim.keyTimes = @[@0, @1];
    humanstartingforipadStrokeEndAnim.duration = 1.71;
    humanstartingforipadStrokeEndAnim.beginTime = 0.296;
    humanstartingforipadStrokeEndAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup * humanstartingforipadIpadanimationAnim = [QCMethod groupAnimations:@[humanstartingforipadStrokeEndAnim] fillMode:fillMode];
    [self.layers[@"humanstartingforipad"] addAnimation:humanstartingforipadIpadanimationAnim forKey:@"humanstartingforipadIpadanimationAnim"];
    
    ////Humanscoreforipad animation
    CAKeyframeAnimation * humanscoreforipadHiddenAnim = [CAKeyframeAnimation animationWithKeyPath:@"hidden"];
    humanscoreforipadHiddenAnim.values   = @[@YES, @NO];
    humanscoreforipadHiddenAnim.keyTimes = @[@0, @1];
    humanscoreforipadHiddenAnim.duration = 0.583;
    
    CAKeyframeAnimation * humanscoreforipadPositionAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    humanscoreforipadPositionAnim.path     = [QCMethod offsetPath:[self humanscoreforipadPath] by:CGPointMake(240.27, 10.32)].CGPath;
    temphuman=0;
    t1=[NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(humantime) userInfo:nil repeats:NO];

    humanscoreforipadPositionAnim.calculationMode = kCAAnimationCubicPaced;
    humanscoreforipadPositionAnim.duration = 1.71;
    humanscoreforipadPositionAnim.beginTime = 0.289;
    humanscoreforipadPositionAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup * humanscoreforipadIpadanimationAnim = [QCMethod groupAnimations:@[humanscoreforipadHiddenAnim, humanscoreforipadPositionAnim] fillMode:fillMode];
    [self.layers[@"humanscoreforipad"] addAnimation:humanscoreforipadIpadanimationAnim forKey:@"humanscoreforipadIpadanimationAnim"];
    
    ////Transportstartingforipad animation
    CAKeyframeAnimation * transportstartingforipadStrokeEndAnim = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    transportstartingforipadStrokeEndAnim.values = @[@0, @1];
    transportstartingforipadStrokeEndAnim.keyTimes = @[@0, @1];
    transportstartingforipadStrokeEndAnim.duration = 1.71;
    transportstartingforipadStrokeEndAnim.beginTime = 0.289;
    transportstartingforipadStrokeEndAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup * transportstartingforipadIpadanimationAnim = [QCMethod groupAnimations:@[transportstartingforipadStrokeEndAnim] fillMode:fillMode];
    [self.layers[@"transportstartingforipad"] addAnimation:transportstartingforipadIpadanimationAnim forKey:@"transportstartingforipadIpadanimationAnim"];
    
    ////Transportstartpathforipad animation
    CAKeyframeAnimation * transportstartpathforipadStrokeEndAnim = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    transportstartpathforipadStrokeEndAnim.values = @[@0, @1];
    transportstartpathforipadStrokeEndAnim.keyTimes = @[@0, @1];
    transportstartpathforipadStrokeEndAnim.duration = 0.296;
    
    CAAnimationGroup * transportstartpathforipadIpadanimationAnim = [QCMethod groupAnimations:@[transportstartpathforipadStrokeEndAnim] fillMode:fillMode];
    [self.layers[@"transportstartpathforipad"] addAnimation:transportstartpathforipadIpadanimationAnim forKey:@"transportstartpathforipadIpadanimationAnim"];
    
    ////Transportarrowforipad animation
    CAKeyframeAnimation * transportarrowforipadPositionAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    transportarrowforipadPositionAnim.path = [QCMethod offsetPath:[self transportstartingforipadPath] by:CGPointMake(200.12, 9.48)].CGPath;
    transportarrowforipadPositionAnim.rotationMode = kCAAnimationRotateAutoReverse;
    transportarrowforipadPositionAnim.calculationMode = kCAAnimationCubicPaced;
    transportarrowforipadPositionAnim.duration = 1.71;
    transportarrowforipadPositionAnim.beginTime = 0.289;
    transportarrowforipadPositionAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAKeyframeAnimation * transportarrowforipadHiddenAnim = [CAKeyframeAnimation animationWithKeyPath:@"hidden"];
    transportarrowforipadHiddenAnim.values = @[@YES, @NO];
    transportarrowforipadHiddenAnim.keyTimes = @[@0, @1];
    transportarrowforipadHiddenAnim.duration = 0.583;
    
    
    if(transport<mtransport){
    CAAnimationGroup * transportarrowforipadIpadanimationAnim = [QCMethod groupAnimations:@[transportarrowforipadPositionAnim, transportarrowforipadHiddenAnim] fillMode:fillMode];
    [self.layers[@"transportarrowforipad"] addAnimation:transportarrowforipadIpadanimationAnim forKey:@"transportarrowforipadIpadanimationAnim"];
    }else{
        CAAnimationGroup * transportarrowforipadIpadanimationAnim = [QCMethod groupAnimations:@[transportarrowforipadPositionAnim, transportarrowforipadHiddenAnim,humanarrowforiphoneOpacityAnim] fillMode:fillMode];
        [self.layers[@"transportarrowforipad"] addAnimation:transportarrowforipadIpadanimationAnim forKey:@"transportarrowforipadIpadanimationAnim"];
    }
    
    ////Transportscoreforipad animation
    CAKeyframeAnimation * transportscoreforipadHiddenAnim = [CAKeyframeAnimation animationWithKeyPath:@"hidden"];
    transportscoreforipadHiddenAnim.values = @[@YES, @NO];
    transportscoreforipadHiddenAnim.keyTimes = @[@0, @1];
    transportscoreforipadHiddenAnim.duration = 0.583;
    
    CAKeyframeAnimation * transportscoreforipadPositionAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    transportscoreforipadPositionAnim.path = [QCMethod offsetPath:[self transportscoreforipadPath] by:CGPointMake(200.12, 9.48)].CGPath;
    temptransport=0;
    t2=[NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(transporttime) userInfo:nil repeats:NO];
    
    transportscoreforipadPositionAnim.calculationMode = kCAAnimationCubicPaced;
    transportscoreforipadPositionAnim.duration = 1.71;
    transportscoreforipadPositionAnim.beginTime = 0.289;
    transportscoreforipadPositionAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup * transportscoreforipadIpadanimationAnim = [QCMethod groupAnimations:@[transportscoreforipadHiddenAnim, transportscoreforipadPositionAnim] fillMode:fillMode];
    [self.layers[@"transportscoreforipad"] addAnimation:transportscoreforipadIpadanimationAnim forKey:@"transportscoreforipadIpadanimationAnim"];
    
    ////Wastestartingforipad animation
    CAKeyframeAnimation * wastestartingforipadStrokeEndAnim = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    wastestartingforipadStrokeEndAnim.values = @[@0, @1];
    wastestartingforipadStrokeEndAnim.keyTimes = @[@0, @1];
    wastestartingforipadStrokeEndAnim.duration = 1.71;
    wastestartingforipadStrokeEndAnim.beginTime = 0.289;
    wastestartingforipadStrokeEndAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup * wastestartingforipadIpadanimationAnim = [QCMethod groupAnimations:@[wastestartingforipadStrokeEndAnim] fillMode:fillMode];
    [self.layers[@"wastestartingforipad"] addAnimation:wastestartingforipadIpadanimationAnim forKey:@"wastestartingforipadIpadanimationAnim"];
    
    ////Wastestartpathforipad animation
    CAKeyframeAnimation * wastestartpathforipadStrokeEndAnim = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    wastestartpathforipadStrokeEndAnim.values = @[@0, @1];
    wastestartpathforipadStrokeEndAnim.keyTimes = @[@0, @1];
    wastestartpathforipadStrokeEndAnim.duration = 0.296;
    
    CAAnimationGroup * wastestartpathforipadIpadanimationAnim = [QCMethod groupAnimations:@[wastestartpathforipadStrokeEndAnim] fillMode:fillMode];
    [self.layers[@"wastestartpathforipad"] addAnimation:wastestartpathforipadIpadanimationAnim forKey:@"wastestartpathforipadIpadanimationAnim"];
    
    ////Wastearrowforipad animation
    CAKeyframeAnimation * wastearrowforipadPositionAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    wastearrowforipadPositionAnim.path     = [QCMethod offsetPath:[self wastestartingforipadPath] by:CGPointMake(159.98, 9.9)].CGPath;
    wastearrowforipadPositionAnim.rotationMode = kCAAnimationRotateAutoReverse;
    wastearrowforipadPositionAnim.calculationMode = kCAAnimationCubicPaced;
    wastearrowforipadPositionAnim.duration = 1.71;
    wastearrowforipadPositionAnim.beginTime = 0.289;
    wastearrowforipadPositionAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAKeyframeAnimation * wastearrowforipadHiddenAnim = [CAKeyframeAnimation animationWithKeyPath:@"hidden"];
    wastearrowforipadHiddenAnim.values   = @[@YES, @NO];
    wastearrowforipadHiddenAnim.keyTimes = @[@0, @1];
    wastearrowforipadHiddenAnim.duration = 0.583;
    
    if(waste<mwaste){
    CAAnimationGroup * wastearrowforipadIpadanimationAnim = [QCMethod groupAnimations:@[wastearrowforipadPositionAnim, wastearrowforipadHiddenAnim] fillMode:fillMode];
    [self.layers[@"wastearrowforipad"] addAnimation:wastearrowforipadIpadanimationAnim forKey:@"wastearrowforipadIpadanimationAnim"];
    }else{
        CAAnimationGroup * wastearrowforipadIpadanimationAnim = [QCMethod groupAnimations:@[wastearrowforipadPositionAnim, wastearrowforipadHiddenAnim,humanarrowforiphoneOpacityAnim] fillMode:fillMode];
        [self.layers[@"wastearrowforipad"] addAnimation:wastearrowforipadIpadanimationAnim forKey:@"wastearrowforipadIpadanimationAnim"];
    }
    
    ////Wastescoreforipad animation
    CAKeyframeAnimation * wastescoreforipadHiddenAnim = [CAKeyframeAnimation animationWithKeyPath:@"hidden"];
    wastescoreforipadHiddenAnim.values   = @[@YES, @NO];
    wastescoreforipadHiddenAnim.keyTimes = @[@0, @1];
    wastescoreforipadHiddenAnim.duration = 0.583;
    
    CAKeyframeAnimation * wastescoreforipadPositionAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    wastescoreforipadPositionAnim.path     = [QCMethod offsetPath:[self wastescoreforipadPath] by:CGPointMake(159.98, 9.9)].CGPath;
    tempwaste=0;
    t3=[NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(wastetime) userInfo:nil repeats:NO];
    
    wastescoreforipadPositionAnim.calculationMode = kCAAnimationCubicPaced;
    wastescoreforipadPositionAnim.duration = 1.71;
    wastescoreforipadPositionAnim.beginTime = 0.289;
    wastescoreforipadPositionAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup * wastescoreforipadIpadanimationAnim = [QCMethod groupAnimations:@[wastescoreforipadHiddenAnim, wastescoreforipadPositionAnim] fillMode:fillMode];
    [self.layers[@"wastescoreforipad"] addAnimation:wastescoreforipadIpadanimationAnim forKey:@"wastescoreforipadIpadanimationAnim"];
    
    ////Waterstartingforipad animation
    CAKeyframeAnimation * waterstartingforipadStrokeEndAnim = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    waterstartingforipadStrokeEndAnim.values = @[@0, @1];
    waterstartingforipadStrokeEndAnim.keyTimes = @[@0, @1];
    waterstartingforipadStrokeEndAnim.duration = 1.71;
    waterstartingforipadStrokeEndAnim.beginTime = 0.289;
    waterstartingforipadStrokeEndAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup * waterstartingforipadIpadanimationAnim = [QCMethod groupAnimations:@[waterstartingforipadStrokeEndAnim] fillMode:fillMode];
    [self.layers[@"waterstartingforipad"] addAnimation:waterstartingforipadIpadanimationAnim forKey:@"waterstartingforipadIpadanimationAnim"];
    
    ////Waterstartpathforipad animation
    CAKeyframeAnimation * waterstartpathforipadStrokeEndAnim = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    waterstartpathforipadStrokeEndAnim.values = @[@0, @1];
    waterstartpathforipadStrokeEndAnim.keyTimes = @[@0, @1];
    waterstartpathforipadStrokeEndAnim.duration = 0.296;
    
    CAAnimationGroup * waterstartpathforipadIpadanimationAnim = [QCMethod groupAnimations:@[waterstartpathforipadStrokeEndAnim] fillMode:fillMode];
    [self.layers[@"waterstartpathforipad"] addAnimation:waterstartpathforipadIpadanimationAnim forKey:@"waterstartpathforipadIpadanimationAnim"];
    
    ////Waterarrowforipad animation
    CAKeyframeAnimation * waterarrowforipadPositionAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    waterarrowforipadPositionAnim.path     = [QCMethod offsetPath:[self waterstartingforipadPath] by:CGPointMake(120.77, 9.82)].CGPath;
    waterarrowforipadPositionAnim.rotationMode = kCAAnimationRotateAutoReverse;
    waterarrowforipadPositionAnim.calculationMode = kCAAnimationCubicPaced;
    waterarrowforipadPositionAnim.duration = 1.71;
    waterarrowforipadPositionAnim.beginTime = 0.289;
    waterarrowforipadPositionAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAKeyframeAnimation * waterarrowforipadHiddenAnim = [CAKeyframeAnimation animationWithKeyPath:@"hidden"];
    waterarrowforipadHiddenAnim.values   = @[@YES, @NO];
    waterarrowforipadHiddenAnim.keyTimes = @[@0, @1];
    waterarrowforipadHiddenAnim.duration = 0.583;
    
    if(water<mwater){
    CAAnimationGroup * waterarrowforipadIpadanimationAnim = [QCMethod groupAnimations:@[waterarrowforipadPositionAnim, waterarrowforipadHiddenAnim] fillMode:fillMode];
    [self.layers[@"waterarrowforipad"] addAnimation:waterarrowforipadIpadanimationAnim forKey:@"waterarrowforipadIpadanimationAnim"];
    }else{
        CAAnimationGroup * waterarrowforipadIpadanimationAnim = [QCMethod groupAnimations:@[waterarrowforipadPositionAnim, waterarrowforipadHiddenAnim,humanarrowforiphoneOpacityAnim] fillMode:fillMode];
        [self.layers[@"waterarrowforipad"] addAnimation:waterarrowforipadIpadanimationAnim forKey:@"waterarrowforipadIpadanimationAnim"];
    }
    
    ////Waterscoreforipad animation
    CAKeyframeAnimation * waterscoreforipadHiddenAnim = [CAKeyframeAnimation animationWithKeyPath:@"hidden"];
    waterscoreforipadHiddenAnim.values   = @[@YES, @NO];
    waterscoreforipadHiddenAnim.keyTimes = @[@0, @1];
    waterscoreforipadHiddenAnim.duration = 0.583;
    
    CAKeyframeAnimation * waterscoreforipadPositionAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    waterscoreforipadPositionAnim.path     = [QCMethod offsetPath:[self waterscoreforipadPath] by:CGPointMake(120.77, 9.82)].CGPath;
    tempwater=0;
    t4=[NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(watertime) userInfo:nil repeats:NO];
    
    waterscoreforipadPositionAnim.calculationMode = kCAAnimationCubicPaced;
    waterscoreforipadPositionAnim.duration = 1.71;
    waterscoreforipadPositionAnim.beginTime = 0.289;
    waterscoreforipadPositionAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup * waterscoreforipadIpadanimationAnim = [QCMethod groupAnimations:@[waterscoreforipadHiddenAnim, waterscoreforipadPositionAnim] fillMode:fillMode];
    [self.layers[@"waterscoreforipad"] addAnimation:waterscoreforipadIpadanimationAnim forKey:@"waterscoreforipadIpadanimationAnim"];
    
    ////Energystartingforipad animation
    CAKeyframeAnimation * energystartingforipadStrokeEndAnim = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    energystartingforipadStrokeEndAnim.values = @[@0, @1];
    energystartingforipadStrokeEndAnim.keyTimes = @[@0, @1];
    energystartingforipadStrokeEndAnim.duration = 1.71;
    energystartingforipadStrokeEndAnim.beginTime = 0.289;
    energystartingforipadStrokeEndAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup * energystartingforipadIpadanimationAnim = [QCMethod groupAnimations:@[energystartingforipadStrokeEndAnim] fillMode:fillMode];
    [self.layers[@"energystartingforipad"] addAnimation:energystartingforipadIpadanimationAnim forKey:@"energystartingforipadIpadanimationAnim"];
    
    ////Energystartpathforipad animation
    CAKeyframeAnimation * energystartpathforipadStrokeEndAnim = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    energystartpathforipadStrokeEndAnim.values = @[@0, @1];
    energystartpathforipadStrokeEndAnim.keyTimes = @[@0, @1];
    energystartpathforipadStrokeEndAnim.duration = 0.296;
    
    CAAnimationGroup * energystartpathforipadIpadanimationAnim = [QCMethod groupAnimations:@[energystartpathforipadStrokeEndAnim] fillMode:fillMode];
    [self.layers[@"energystartpathforipad"] addAnimation:energystartpathforipadIpadanimationAnim forKey:@"energystartpathforipadIpadanimationAnim"];
    
    ////Energyarrowforipad animation
    CAKeyframeAnimation * energyarrowforipadPositionAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    energyarrowforipadPositionAnim.path = [QCMethod offsetPath:[self energystartingforipadPath] by:CGPointMake(80.12, 10.29)].CGPath;
    energyarrowforipadPositionAnim.rotationMode = kCAAnimationRotateAutoReverse;
    energyarrowforipadPositionAnim.calculationMode = kCAAnimationCubicPaced;
    energyarrowforipadPositionAnim.duration = 1.71;
    energyarrowforipadPositionAnim.beginTime = 0.289;
    energyarrowforipadPositionAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAKeyframeAnimation * energyarrowforipadHiddenAnim = [CAKeyframeAnimation animationWithKeyPath:@"hidden"];
    energyarrowforipadHiddenAnim.values   = @[@YES, @NO];
    energyarrowforipadHiddenAnim.keyTimes = @[@0, @1];
    energyarrowforipadHiddenAnim.duration = 0.583;
    
    if(energy<menergy){
    CAAnimationGroup * energyarrowforipadIpadanimationAnim = [QCMethod groupAnimations:@[energyarrowforipadPositionAnim, energyarrowforipadHiddenAnim] fillMode:fillMode];
    [self.layers[@"energyarrowforipad"] addAnimation:energyarrowforipadIpadanimationAnim forKey:@"energyarrowforipadIpadanimationAnim"];
    }else{
        CAAnimationGroup * energyarrowforipadIpadanimationAnim = [QCMethod groupAnimations:@[energyarrowforipadPositionAnim, energyarrowforipadHiddenAnim,humanarrowforiphoneOpacityAnim] fillMode:fillMode];
        [self.layers[@"energyarrowforipad"] addAnimation:energyarrowforipadIpadanimationAnim forKey:@"energyarrowforipadIpadanimationAnim"];
    }
    
    ////Energyscoreforipad animation
    CAKeyframeAnimation * energyscoreforipadHiddenAnim = [CAKeyframeAnimation animationWithKeyPath:@"hidden"];
    energyscoreforipadHiddenAnim.values   = @[@YES, @NO];
    energyscoreforipadHiddenAnim.keyTimes = @[@0, @1];
    energyscoreforipadHiddenAnim.duration = 0.583;
    
    CAKeyframeAnimation * energyscoreforipadPositionAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    energyscoreforipadPositionAnim.path = [QCMethod offsetPath:[self energyscoreforipadPath] by:CGPointMake(80.12, 10.29)].CGPath;
    tempenergy=0;
    t5=[NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(energytime) userInfo:nil repeats:NO];
    
    energyscoreforipadPositionAnim.calculationMode = kCAAnimationCubicPaced;
    energyscoreforipadPositionAnim.duration = 1.71;
    energyscoreforipadPositionAnim.beginTime = 0.289;
    energyscoreforipadPositionAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup * energyscoreforipadIpadanimationAnim = [QCMethod groupAnimations:@[energyscoreforipadHiddenAnim, energyscoreforipadPositionAnim] fillMode:fillMode];
    [self.layers[@"energyscoreforipad"] addAnimation:energyscoreforipadIpadanimationAnim forKey:@"energyscoreforipadIpadanimationAnim"];
}


#pragma mark - Animation Cleanup

- (void)updateLayerValuesForAnimationId:(NSString *)identifier{
    if([identifier isEqualToString:@"iphoneanimation"]){
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layers[@"puckforiphone"] animationForKey:@"puckforiphoneIphoneanimationAnim"] theLayer:self.layers[@"puckforiphone"]];
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layers[@"puckscoreforiphone"] animationForKey:@"puckscoreforiphoneIphoneanimationAnim"] theLayer:self.layers[@"puckscoreforiphone"]];
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layers[@"humanstartpathforiphone"] animationForKey:@"humanstartpathforiphoneIphoneanimationAnim"] theLayer:self.layers[@"humanstartpathforiphone"]];
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layers[@"humanarrowforiphone"] animationForKey:@"humanarrowforiphoneIphoneanimationAnim"] theLayer:self.layers[@"humanarrowforiphone"]];
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layers[@"humanstartingforiphone"] animationForKey:@"humanstartingforiphoneIphoneanimationAnim"] theLayer:self.layers[@"humanstartingforiphone"]];
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layers[@"humanscoreforiphone"] animationForKey:@"humanscoreforiphoneIphoneanimationAnim"] theLayer:self.layers[@"humanscoreforiphone"]];
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layers[@"transportstartpathforiphone"] animationForKey:@"transportstartpathforiphoneIphoneanimationAnim"] theLayer:self.layers[@"transportstartpathforiphone"]];
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layers[@"transportstartingforiphone"] animationForKey:@"transportstartingforiphoneIphoneanimationAnim"] theLayer:self.layers[@"transportstartingforiphone"]];
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layers[@"transportarrowforiphone"] animationForKey:@"transportarrowforiphoneIphoneanimationAnim"] theLayer:self.layers[@"transportarrowforiphone"]];
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layers[@"transportscoreforiphone"] animationForKey:@"transportscoreforiphoneIphoneanimationAnim"] theLayer:self.layers[@"transportscoreforiphone"]];
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layers[@"wastestartpathforiphone"] animationForKey:@"wastestartpathforiphoneIphoneanimationAnim"] theLayer:self.layers[@"wastestartpathforiphone"]];
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layers[@"wastestartingforiphone"] animationForKey:@"wastestartingforiphoneIphoneanimationAnim"] theLayer:self.layers[@"wastestartingforiphone"]];
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layers[@"wastearrowforiphone"] animationForKey:@"wastearrowforiphoneIphoneanimationAnim"] theLayer:self.layers[@"wastearrowforiphone"]];
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layers[@"wastescoreforiphone"] animationForKey:@"wastescoreforiphoneIphoneanimationAnim"] theLayer:self.layers[@"wastescoreforiphone"]];
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layers[@"waterstartpathforiphone"] animationForKey:@"waterstartpathforiphoneIphoneanimationAnim"] theLayer:self.layers[@"waterstartpathforiphone"]];
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layers[@"waterstartingforiphone"] animationForKey:@"waterstartingforiphoneIphoneanimationAnim"] theLayer:self.layers[@"waterstartingforiphone"]];
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layers[@"waterarrowforiphone"] animationForKey:@"waterarrowforiphoneIphoneanimationAnim"] theLayer:self.layers[@"waterarrowforiphone"]];
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layers[@"waterscoreforiphone"] animationForKey:@"waterscoreforiphoneIphoneanimationAnim"] theLayer:self.layers[@"waterscoreforiphone"]];
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layers[@"energystartingforiphone"] animationForKey:@"energystartingforiphoneIphoneanimationAnim"] theLayer:self.layers[@"energystartingforiphone"]];
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layers[@"energyarrowforiphone"] animationForKey:@"energyarrowforiphoneIphoneanimationAnim"] theLayer:self.layers[@"energyarrowforiphone"]];
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layers[@"energyscoreforiphone"] animationForKey:@"energyscoreforiphoneIphoneanimationAnim"] theLayer:self.layers[@"energyscoreforiphone"]];
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layers[@"energystartpathforiphone"] animationForKey:@"energystartpathforiphoneIphoneanimationAnim"] theLayer:self.layers[@"energystartpathforiphone"]];
    }
}

- (void)removeAnimationsForAnimationId:(NSString *)identifier{
    if([identifier isEqualToString:@"iphoneanimation"]){
        [self.layers[@"puckforiphone"] removeAnimationForKey:@"puckforiphoneIphoneanimationAnim"];
        [self.layers[@"puckscoreforiphone"] removeAnimationForKey:@"puckscoreforiphoneIphoneanimationAnim"];
        [self.layers[@"humanstartpathforiphone"] removeAnimationForKey:@"humanstartpathforiphoneIphoneanimationAnim"];
        [self.layers[@"humanarrowforiphone"] removeAnimationForKey:@"humanarrowforiphoneIphoneanimationAnim"];
        [self.layers[@"humanstartingforiphone"] removeAnimationForKey:@"humanstartingforiphoneIphoneanimationAnim"];
        [self.layers[@"humanscoreforiphone"] removeAnimationForKey:@"humanscoreforiphoneIphoneanimationAnim"];
        [self.layers[@"transportstartpathforiphone"] removeAnimationForKey:@"transportstartpathforiphoneIphoneanimationAnim"];
        [self.layers[@"transportstartingforiphone"] removeAnimationForKey:@"transportstartingforiphoneIphoneanimationAnim"];
        [self.layers[@"transportarrowforiphone"] removeAnimationForKey:@"transportarrowforiphoneIphoneanimationAnim"];
        [self.layers[@"transportscoreforiphone"] removeAnimationForKey:@"transportscoreforiphoneIphoneanimationAnim"];
        [self.layers[@"wastestartpathforiphone"] removeAnimationForKey:@"wastestartpathforiphoneIphoneanimationAnim"];
        [self.layers[@"wastestartingforiphone"] removeAnimationForKey:@"wastestartingforiphoneIphoneanimationAnim"];
        [self.layers[@"wastearrowforiphone"] removeAnimationForKey:@"wastearrowforiphoneIphoneanimationAnim"];
        [self.layers[@"wastescoreforiphone"] removeAnimationForKey:@"wastescoreforiphoneIphoneanimationAnim"];
        [self.layers[@"waterstartpathforiphone"] removeAnimationForKey:@"waterstartpathforiphoneIphoneanimationAnim"];
        [self.layers[@"waterstartingforiphone"] removeAnimationForKey:@"waterstartingforiphoneIphoneanimationAnim"];
        [self.layers[@"waterarrowforiphone"] removeAnimationForKey:@"waterarrowforiphoneIphoneanimationAnim"];
        [self.layers[@"waterscoreforiphone"] removeAnimationForKey:@"waterscoreforiphoneIphoneanimationAnim"];
        [self.layers[@"energystartingforiphone"] removeAnimationForKey:@"energystartingforiphoneIphoneanimationAnim"];
        [self.layers[@"energyarrowforiphone"] removeAnimationForKey:@"energyarrowforiphoneIphoneanimationAnim"];
        [self.layers[@"energyscoreforiphone"] removeAnimationForKey:@"energyscoreforiphoneIphoneanimationAnim"];
        [self.layers[@"energystartpathforiphone"] removeAnimationForKey:@"energystartpathforiphoneIphoneanimationAnim"];
    }
}

- (void)removeAllAnimations{
    [self.layers enumerateKeysAndObjectsUsingBlock:^(id key, CALayer *layer, BOOL *stop) {
        [layer removeAllAnimations];
    }];
}

#pragma mark - Bezier Path

- (UIBezierPath*)humanbackforiphonePath{
    UIBezierPath *humanbackforiphonePath = [UIBezierPath bezierPath];
    [humanbackforiphonePath moveToPoint:CGPointMake(0, 0.055)];
    [humanbackforiphonePath addCurveToPoint:CGPointMake(152.1, 0.055) controlPoint1:CGPointMake(1.565, 0.055) controlPoint2:CGPointMake(150.566, -0.068)];
    [humanbackforiphonePath addCurveToPoint:CGPointMake(204.951, 57.369) controlPoint1:CGPointMake(181.682, 2.422) controlPoint2:CGPointMake(204.951, 27.178)];
    [humanbackforiphonePath addCurveToPoint:CGPointMake(147.451, 114.869) controlPoint1:CGPointMake(204.951, 89.126) controlPoint2:CGPointMake(179.207, 114.869)];
    [humanbackforiphonePath addCurveToPoint:CGPointMake(90.002, 62.953) controlPoint1:CGPointMake(117.578, 114.869) controlPoint2:CGPointMake(92.832, 92.089)];
    [humanbackforiphonePath addCurveToPoint:CGPointMake(90.002, 15.403) controlPoint1:CGPointMake(89.823, 61.116) controlPoint2:CGPointMake(90.002, 17.287)];
    
    return humanbackforiphonePath;
}

- (UIBezierPath*)humanstartpathforiphonePath{
    UIBezierPath *humanstartpathforiphonePath = [UIBezierPath bezierPath];
    [humanstartpathforiphonePath moveToPoint:CGPointMake(0, 0)];
    [humanstartpathforiphonePath addCurveToPoint:CGPointMake(147, 0) controlPoint1:CGPointMake(49, 0) controlPoint2:CGPointMake(98, 0)];
    
    return humanstartpathforiphonePath;
}

- (UIBezierPath*)humanarrowforiphonePath{
    UIBezierPath*  humanarrowforiphonePath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 10, 10)];
    return humanarrowforiphonePath;
}

- (UIBezierPath*)humanstartingforiphonePath{
    if(human<mhuman){
    float f=(180*((float)human/(float)mhuman));
    f=f+(2*(180-f));
    CGRect bound = CGRectMake(0, 0, 115, 115);
    UIBezierPath*  ovalPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, 0) radius:CGRectGetWidth(bound)/2 startAngle:-90 * M_PI/180 endAngle:-f * M_PI/180 clockwise:YES];
    CGAffineTransform pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound));;
    pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound));;
    [ovalPath applyTransform:pathTransform];
    return ovalPath;
    }
    else{
        UIBezierPath *ovalPath = [UIBezierPath bezierPath];
        [ovalPath moveToPoint:CGPointMake(57.257, 0)];
        [ovalPath addCurveToPoint:CGPointMake(114.757, 57.5) controlPoint1:CGPointMake(89.013, 0) controlPoint2:CGPointMake(114.757, 25.744)];
        [ovalPath addCurveToPoint:CGPointMake(57.257, 115) controlPoint1:CGPointMake(114.757, 89.256) controlPoint2:CGPointMake(89.013, 115)];
        [ovalPath addCurveToPoint:CGPointMake(0.101, 63.83) controlPoint1:CGPointMake(27.64, 115) controlPoint2:CGPointMake(3.252, 92.608)];
        [ovalPath addCurveToPoint:CGPointMake(0.101, 15.034) controlPoint1:CGPointMake(-0.126, 61.751) controlPoint2:CGPointMake(0.101, 17.173)];
        
        return ovalPath;
    }
}

- (UIBezierPath*)humanscoreforiphonePath{
    if(human<mhuman){
    float f=(180*((float)human/(float)mhuman));
    f=f+(2*(180-f))+2;
    CGRect bound = CGRectMake(0, 0, 115, 115);
    UIBezierPath*  ovalPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, 0) radius:CGRectGetWidth(bound)/2 startAngle:-90 * M_PI/180 endAngle:-f * M_PI/180 clockwise:YES];
    CGAffineTransform pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound));;
    pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound));;
    [ovalPath applyTransform:pathTransform];
        return ovalPath;
    }else{
        UIBezierPath *ovalPath = [UIBezierPath bezierPath];
        [ovalPath moveToPoint:CGPointMake(57.257, 0)];
        [ovalPath addCurveToPoint:CGPointMake(114.757, 57.5) controlPoint1:CGPointMake(89.013, 0) controlPoint2:CGPointMake(114.757, 25.744)];
        [ovalPath addCurveToPoint:CGPointMake(57.257, 115) controlPoint1:CGPointMake(114.757, 89.256) controlPoint2:CGPointMake(89.013, 115)];
        [ovalPath addCurveToPoint:CGPointMake(0.101, 63.83) controlPoint1:CGPointMake(27.64, 115) controlPoint2:CGPointMake(3.252, 92.608)];
        [ovalPath addCurveToPoint:CGPointMake(0.101, 22.034) controlPoint1:CGPointMake(-0.126, 61.751) controlPoint2:CGPointMake(0.101, 17.173)];
        
        return ovalPath;

    }
}

- (UIBezierPath*)transportbackforiphonePath{
    UIBezierPath *transportbackforiphonePath = [UIBezierPath bezierPath];
    [transportbackforiphonePath moveToPoint:CGPointMake(0, 0)];
    [transportbackforiphonePath addCurveToPoint:CGPointMake(153.792, 0.403) controlPoint1:CGPointMake(2.043, 0) controlPoint2:CGPointMake(151.789, 0.248)];
    [transportbackforiphonePath addCurveToPoint:CGPointMake(225.221, 77.669) controlPoint1:CGPointMake(193.757, 3.5) controlPoint2:CGPointMake(225.221, 36.91)];
    [transportbackforiphonePath addCurveToPoint:CGPointMake(147.721, 155.169) controlPoint1:CGPointMake(225.221, 120.471) controlPoint2:CGPointMake(190.523, 155.169)];
    [transportbackforiphonePath addCurveToPoint:CGPointMake(70.499, 84.272) controlPoint1:CGPointMake(107.144, 155.169) controlPoint2:CGPointMake(73.849, 123.984)];
    [transportbackforiphonePath addCurveToPoint:CGPointMake(70.499, 35.82) controlPoint1:CGPointMake(70.315, 82.096) controlPoint2:CGPointMake(70.499, 38.044)];
    
    return transportbackforiphonePath;
}

- (UIBezierPath*)transportstartpathforiphonePath{
    UIBezierPath *transportstartpathforiphonePath = [UIBezierPath bezierPath];
    [transportstartpathforiphonePath moveToPoint:CGPointMake(0, 0)];
    [transportstartpathforiphonePath addCurveToPoint:CGPointMake(147, 0) controlPoint1:CGPointMake(49, 0) controlPoint2:CGPointMake(98, 0)];
    
    return transportstartpathforiphonePath;
}

- (UIBezierPath*)transportstartingforiphonePath{
    if (transport<mtransport) {
    float f=(180*((float)transport/(float)mtransport));
    f=f+(2*(180-f));
    CGRect bound = CGRectMake(0, 0, 155, 155);
    UIBezierPath*  ovalPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, 0) radius:CGRectGetWidth(bound)/2 startAngle:-90 * M_PI/180 endAngle:-f * M_PI/180 clockwise:YES];
    CGAffineTransform pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound));;
    pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound));;
    [ovalPath applyTransform:pathTransform];
    return ovalPath;
}else{
    UIBezierPath *ovalPath = [UIBezierPath bezierPath];
    [ovalPath moveToPoint:CGPointMake(77.309, 0)];
    [ovalPath addCurveToPoint:CGPointMake(154.809, 77.5) controlPoint1:CGPointMake(120.111, 0) controlPoint2:CGPointMake(154.809, 34.698)];
    [ovalPath addCurveToPoint:CGPointMake(77.309, 155) controlPoint1:CGPointMake(154.809, 120.302) controlPoint2:CGPointMake(120.111, 155)];
    [ovalPath addCurveToPoint:CGPointMake(0.08, 84.017) controlPoint1:CGPointMake(36.702, 155) controlPoint2:CGPointMake(3.389, 123.769)];
    [ovalPath addCurveToPoint:CGPointMake(0.079, 36.029) controlPoint1:CGPointMake(-0.099, 81.868) controlPoint2:CGPointMake(0.079, 38.223)];
    
    return ovalPath;
}
}

- (UIBezierPath*)transportscoreforiphonePath{
    if(transport<mtransport){
    float f=(180*((float)transport/(float)mtransport));
    f=f+(2*(180-f))+2;
    CGRect bound = CGRectMake(0, 0, 155, 155);
    UIBezierPath*  ovalPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, 0) radius:CGRectGetWidth(bound)/2 startAngle:-90 * M_PI/180 endAngle:-f * M_PI/180 clockwise:YES];
    CGAffineTransform pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound));;
    pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound));;
    [ovalPath applyTransform:pathTransform];
    return ovalPath;
    }else{
        UIBezierPath *ovalPath = [UIBezierPath bezierPath];
        [ovalPath moveToPoint:CGPointMake(77.309, 0)];
        [ovalPath addCurveToPoint:CGPointMake(154.809, 77.5) controlPoint1:CGPointMake(120.111, 0) controlPoint2:CGPointMake(154.809, 34.698)];
        [ovalPath addCurveToPoint:CGPointMake(77.309, 155) controlPoint1:CGPointMake(154.809, 120.302) controlPoint2:CGPointMake(120.111, 155)];
        [ovalPath addCurveToPoint:CGPointMake(0.08, 84.017) controlPoint1:CGPointMake(36.702, 155) controlPoint2:CGPointMake(3.389, 123.769)];
        [ovalPath addCurveToPoint:CGPointMake(0.079, 43.029) controlPoint1:CGPointMake(-0.099, 81.868) controlPoint2:CGPointMake(0.079, 38.223)];
        
        return ovalPath;
    }
}

- (UIBezierPath*)transportarrowforiphonePath{
    UIBezierPath*  transportarrowforiphonePath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 10, 10)];
    return transportarrowforiphonePath;
}

- (UIBezierPath*)wastebackforiphonePath{
    UIBezierPath *wastebackforiphonePath = [UIBezierPath bezierPath];
    [wastebackforiphonePath moveToPoint:CGPointMake(2, 0.066)];
    [wastebackforiphonePath addCurveToPoint:CGPointMake(155.156, 0.066) controlPoint1:CGPointMake(2.245, 0.066) controlPoint2:CGPointMake(152.95, -0.083)];
    [wastebackforiphonePath addCurveToPoint:CGPointMake(245.978, 97.341) controlPoint1:CGPointMake(205.889, 3.498) controlPoint2:CGPointMake(245.978, 45.738)];
    [wastebackforiphonePath addCurveToPoint:CGPointMake(148.478, 194.841) controlPoint1:CGPointMake(245.978, 151.189) controlPoint2:CGPointMake(202.326, 194.841)];
    [wastebackforiphonePath addCurveToPoint:CGPointMake(51.282, 105.097) controlPoint1:CGPointMake(97.241, 194.841) controlPoint2:CGPointMake(55.235, 155.319)];
    [wastebackforiphonePath addCurveToPoint:CGPointMake(51.282, 55.156) controlPoint1:CGPointMake(51.081, 102.538) controlPoint2:CGPointMake(51.282, 57.767)];
    
    return wastebackforiphonePath;
}

- (UIBezierPath*)wastestartpathforiphonePath{
    UIBezierPath *wastestartpathforiphonePath = [UIBezierPath bezierPath];
    [wastestartpathforiphonePath moveToPoint:CGPointMake(0, 0)];
    [wastestartpathforiphonePath addCurveToPoint:CGPointMake(147, 0) controlPoint1:CGPointMake(49, 0) controlPoint2:CGPointMake(98, 0)];
    
    return wastestartpathforiphonePath;
}

- (UIBezierPath*)wastestartingforiphonePath{
    if(waste<mwaste){
    float f=(180*((float)waste/(float)mwaste));
    f=f+(2*(180-f));
    CGRect bound = CGRectMake(0, 0, 195, 195);
    UIBezierPath*  ovalPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, 0) radius:CGRectGetWidth(bound)/2 startAngle:-90 * M_PI/180 endAngle:-f * M_PI/180 clockwise:YES];
    CGAffineTransform pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound));;
    pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound));;
    [ovalPath applyTransform:pathTransform];
    return ovalPath;
    }else{
        UIBezierPath *ovalPath = [UIBezierPath bezierPath];
        [ovalPath moveToPoint:CGPointMake(97.349, 0)];
        [ovalPath addCurveToPoint:CGPointMake(194.849, 97.5) controlPoint1:CGPointMake(151.197, 0) controlPoint2:CGPointMake(194.849, 43.652)];
        [ovalPath addCurveToPoint:CGPointMake(97.349, 195) controlPoint1:CGPointMake(194.849, 151.348) controlPoint2:CGPointMake(151.197, 195)];
        [ovalPath addCurveToPoint:CGPointMake(0.063, 104.017) controlPoint1:CGPointMake(45.691, 195) controlPoint2:CGPointMake(3.416, 154.826)];
        [ovalPath addCurveToPoint:CGPointMake(0.063, 55.594) controlPoint1:CGPointMake(-0.079, 101.863) controlPoint2:CGPointMake(0.063, 57.784)];
        
        return ovalPath;
    }

}

- (UIBezierPath*)wastescoreforiphonePath{
    if(waste<mwaste){
    float f=(180*((float)waste/(float)mwaste));
    f=f+(2*(180-f))+2;
    CGRect bound = CGRectMake(0, 0, 195, 195);
    UIBezierPath*  ovalPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, 0) radius:CGRectGetWidth(bound)/2 startAngle:-90 * M_PI/180 endAngle:-f * M_PI/180 clockwise:YES];
    CGAffineTransform pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound));;
    pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound));;
    [ovalPath applyTransform:pathTransform];
    return ovalPath;
    }else{
        UIBezierPath *ovalPath = [UIBezierPath bezierPath];
        [ovalPath moveToPoint:CGPointMake(97.349, 0)];
        [ovalPath addCurveToPoint:CGPointMake(194.849, 97.5) controlPoint1:CGPointMake(151.197, 0) controlPoint2:CGPointMake(194.849, 43.652)];
        [ovalPath addCurveToPoint:CGPointMake(97.349, 195) controlPoint1:CGPointMake(194.849, 151.348) controlPoint2:CGPointMake(151.197, 195)];
        [ovalPath addCurveToPoint:CGPointMake(0.063, 104.017) controlPoint1:CGPointMake(45.691, 195) controlPoint2:CGPointMake(3.416, 154.826)];
        [ovalPath addCurveToPoint:CGPointMake(0.063, 62.594) controlPoint1:CGPointMake(-0.079, 101.863) controlPoint2:CGPointMake(0.063, 57.784)];
        
        return ovalPath;
    }
}

- (UIBezierPath*)wastearrowforiphonePath{
    UIBezierPath*  wastearrowforiphonePath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 10, 10)];
    return wastearrowforiphonePath;
}

- (UIBezierPath*)waterbackforiphonePath{
    UIBezierPath *waterbackforiphonePath = [UIBezierPath bezierPath];
    [waterbackforiphonePath moveToPoint:CGPointMake(2, 0)];
    [waterbackforiphonePath addCurveToPoint:CGPointMake(155.513, 0.838) controlPoint1:CGPointMake(2.205, 0) controlPoint2:CGPointMake(153.338, 0.719)];
    [waterbackforiphonePath addCurveToPoint:CGPointMake(266.443, 117.66) controlPoint1:CGPointMake(217.35, 4.232) controlPoint2:CGPointMake(266.443, 55.237)];
    [waterbackforiphonePath addCurveToPoint:CGPointMake(148.943, 234.661) controlPoint1:CGPointMake(266.443, 182.278) controlPoint2:CGPointMake(213.836, 234.661)];
    [waterbackforiphonePath addCurveToPoint:CGPointMake(31.592, 123.608) controlPoint1:CGPointMake(86.052, 234.661) controlPoint2:CGPointMake(34.702, 185.462)];
    [waterbackforiphonePath addCurveToPoint:CGPointMake(31.638, 74.718) controlPoint1:CGPointMake(31.493, 121.638) controlPoint2:CGPointMake(31.638, 76.713)];
    
    return waterbackforiphonePath;
}

- (UIBezierPath*)waterstartpathforiphonePath{
    UIBezierPath *waterstartpathforiphonePath = [UIBezierPath bezierPath];
    [waterstartpathforiphonePath moveToPoint:CGPointMake(0, 0)];
    [waterstartpathforiphonePath addCurveToPoint:CGPointMake(147, 0) controlPoint1:CGPointMake(49, 0) controlPoint2:CGPointMake(98, 0)];
    
    return waterstartpathforiphonePath;
}

- (UIBezierPath*)waterstartingforiphonePath{
    if(water<mwater){
    float f=(180*((float)water/(float)mwater));
        f=f+(2*(180-f));
    CGRect bound = CGRectMake(0, 0, 235, 235);
    UIBezierPath*  ovalPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, 0) radius:CGRectGetWidth(bound)/2 startAngle:-90 * M_PI/180 endAngle:-f * M_PI/180 clockwise:YES];
    CGAffineTransform pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound));;
    pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound));;
    [ovalPath applyTransform:pathTransform];
    return ovalPath;
    }else{
        UIBezierPath *ovalPath = [UIBezierPath bezierPath];
        [ovalPath moveToPoint:CGPointMake(117.349, 0)];
        [ovalPath addCurveToPoint:CGPointMake(234.849, 117.5) controlPoint1:CGPointMake(182.243, 0) controlPoint2:CGPointMake(234.849, 52.607)];
        [ovalPath addCurveToPoint:CGPointMake(117.349, 235) controlPoint1:CGPointMake(234.849, 182.393) controlPoint2:CGPointMake(182.243, 235)];
        [ovalPath addCurveToPoint:CGPointMake(0.063, 124.644) controlPoint1:CGPointMake(54.855, 235) controlPoint2:CGPointMake(3.755, 186.211)];
        [ovalPath addCurveToPoint:CGPointMake(0.063, 75.326) controlPoint1:CGPointMake(-0.079, 122.281) controlPoint2:CGPointMake(0.063, 77.724)];
        
        return ovalPath;

    }

}

- (UIBezierPath*)waterscoreforiphonePath{
    if(water<mwater){
    float f=(180*((float)water/(float)mwater));
    f=f+(2*(180-f))+2;
    CGRect bound = CGRectMake(0, 0, 235, 235);
    UIBezierPath*  ovalPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, 0) radius:CGRectGetWidth(bound)/2 startAngle:-90 * M_PI/180 endAngle:-f * M_PI/180 clockwise:YES];
    CGAffineTransform pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound));;
    pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound));;
    [ovalPath applyTransform:pathTransform];
    return ovalPath;
    }else{
        UIBezierPath *ovalPath = [UIBezierPath bezierPath];
        [ovalPath moveToPoint:CGPointMake(117.349, 0)];
        [ovalPath addCurveToPoint:CGPointMake(234.849, 117.5) controlPoint1:CGPointMake(182.243, 0) controlPoint2:CGPointMake(234.849, 52.607)];
        [ovalPath addCurveToPoint:CGPointMake(117.349, 235) controlPoint1:CGPointMake(234.849, 182.393) controlPoint2:CGPointMake(182.243, 235)];
        [ovalPath addCurveToPoint:CGPointMake(0.063, 124.644) controlPoint1:CGPointMake(54.855, 235) controlPoint2:CGPointMake(3.755, 186.211)];
        [ovalPath addCurveToPoint:CGPointMake(0.063, 82.326) controlPoint1:CGPointMake(-0.079, 122.281) controlPoint2:CGPointMake(0.063, 77.724)];
        
        return ovalPath;

    }
}

- (UIBezierPath*)waterarrowforiphonePath{
    UIBezierPath*  waterarrowforiphonePath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 10, 10)];
    return waterarrowforiphonePath;
}

- (UIBezierPath*)energybackforiphonePath{
    UIBezierPath *energybackforiphonePath = [UIBezierPath bezierPath];
    [energybackforiphonePath moveToPoint:CGPointMake(0, 0.057)];
    [energybackforiphonePath addCurveToPoint:CGPointMake(155.291, 0.057) controlPoint1:CGPointMake(2.473, 0.057) controlPoint2:CGPointMake(152.85, -0.072)];
    [energybackforiphonePath addCurveToPoint:CGPointMake(285.418, 137.363) controlPoint1:CGPointMake(227.802, 3.888) controlPoint2:CGPointMake(285.418, 63.897)];
    [energybackforiphonePath addCurveToPoint:CGPointMake(147.918, 274.863) controlPoint1:CGPointMake(285.418, 213.302) controlPoint2:CGPointMake(223.857, 274.863)];
    [energybackforiphonePath addCurveToPoint:CGPointMake(10.932, 149.34) controlPoint1:CGPointMake(76.014, 274.863) controlPoint2:CGPointMake(17.001, 219.671)];
    [energybackforiphonePath addCurveToPoint:CGPointMake(10.932, 94.414) controlPoint1:CGPointMake(10.592, 145.393) controlPoint2:CGPointMake(10.932, 98.449)];
    
    return energybackforiphonePath;
}

- (UIBezierPath*)energystartingforiphonePath{
    if(energy<menergy){
    float f=(180*((float)energy/(float)menergy));
        f=f+(2*(180-f));
    CGRect bound = CGRectMake(0, 0, 275, 275);
    UIBezierPath*  ovalPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, 0) radius:CGRectGetWidth(bound)/2 startAngle:-90 * M_PI/180 endAngle:-f * M_PI/180 clockwise:YES];
    CGAffineTransform pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound));;
    pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound));;
    [ovalPath applyTransform:pathTransform];
    return ovalPath;
    }else{
        UIBezierPath *ovalPath = [UIBezierPath bezierPath];
        [ovalPath moveToPoint:CGPointMake(137.326, 0)];
        [ovalPath addCurveToPoint:CGPointMake(274.826, 137.5) controlPoint1:CGPointMake(213.265, 0) controlPoint2:CGPointMake(274.826, 61.561)];
        [ovalPath addCurveToPoint:CGPointMake(137.326, 275) controlPoint1:CGPointMake(274.826, 213.439) controlPoint2:CGPointMake(213.265, 275)];
        [ovalPath addCurveToPoint:CGPointMake(0.073, 145.807) controlPoint1:CGPointMake(64.176, 275) controlPoint2:CGPointMake(4.367, 217.878)];
        [ovalPath addCurveToPoint:CGPointMake(0.073, 94.81) controlPoint1:CGPointMake(-0.091, 143.059) controlPoint2:CGPointMake(0.073, 97.599)];
        
        return ovalPath;
    }
}

- (UIBezierPath*)energyscoreforiphonePath{
    if(energy<menergy){
    float f=(180*((float)energy/(float)menergy));
    f=f+(2*(180-f))+2;
    CGRect bound = CGRectMake(0, 0, 275, 275);
    UIBezierPath*  ovalPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, 0) radius:CGRectGetWidth(bound)/2 startAngle:-90 * M_PI/180 endAngle:-f * M_PI/180 clockwise:YES];
    CGAffineTransform pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound));;
    pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound));;
    [ovalPath applyTransform:pathTransform];
    return ovalPath;
    }else{
        UIBezierPath *ovalPath = [UIBezierPath bezierPath];
        [ovalPath moveToPoint:CGPointMake(137.326, 0)];
        [ovalPath addCurveToPoint:CGPointMake(274.826, 137.5) controlPoint1:CGPointMake(213.265, 0) controlPoint2:CGPointMake(274.826, 61.561)];
        [ovalPath addCurveToPoint:CGPointMake(137.326, 275) controlPoint1:CGPointMake(274.826, 213.439) controlPoint2:CGPointMake(213.265, 275)];
        [ovalPath addCurveToPoint:CGPointMake(0.073, 145.807) controlPoint1:CGPointMake(64.176, 275) controlPoint2:CGPointMake(4.367, 217.878)];
        [ovalPath addCurveToPoint:CGPointMake(0.073, 101.81) controlPoint1:CGPointMake(-0.091, 143.059) controlPoint2:CGPointMake(0.073, 97.599)];
        
        return ovalPath;
    }
}

- (UIBezierPath*)energyarrowforiphonePath{
    UIBezierPath*  energyarrowforiphonePath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 10, 10)];
    return energyarrowforiphonePath;
}

- (UIBezierPath*)energystartpathforiphonePath{
    UIBezierPath *energystartpathforiphonePath = [UIBezierPath bezierPath];
    [energystartpathforiphonePath moveToPoint:CGPointMake(0, 0)];
    [energystartpathforiphonePath addCurveToPoint:CGPointMake(147, 0) controlPoint1:CGPointMake(49, 0) controlPoint2:CGPointMake(98, 0)];
    
    return energystartpathforiphonePath;
}


- (UIBezierPath*)humanbackforipadPath{
    UIBezierPath *humanbackforipadPath = [UIBezierPath bezierPath];
    [humanbackforipadPath moveToPoint:CGPointMake(6, 0.097)];
    [humanbackforipadPath addCurveToPoint:CGPointMake(316.507, 0.507) controlPoint1:CGPointMake(5.702, 0.097) controlPoint2:CGPointMake(311.029, -0.298)];
    [humanbackforipadPath addCurveToPoint:CGPointMake(414.222, 113.785) controlPoint1:CGPointMake(371.786, 8.627) controlPoint2:CGPointMake(414.222, 56.25)];
    [humanbackforipadPath addCurveToPoint:CGPointMake(299.722, 228.285) controlPoint1:CGPointMake(414.222, 177.022) controlPoint2:CGPointMake(362.958, 228.285)];
    [humanbackforipadPath addCurveToPoint:CGPointMake(186.627, 131.774) controlPoint1:CGPointMake(242.606, 228.285) controlPoint2:CGPointMake(195.257, 186.464)];
    [humanbackforipadPath addCurveToPoint:CGPointMake(186.627, 34.378) controlPoint1:CGPointMake(185.702, 125.913) controlPoint2:CGPointMake(186.627, 40.499)];
    
    return humanbackforipadPath;
}

- (UIBezierPath*)humanstartpathforipadPath{
    UIBezierPath *humanstartpathforipadPath = [UIBezierPath bezierPath];
    [humanstartpathforipadPath moveToPoint:CGPointMake(0, 0)];
    [humanstartpathforipadPath addCurveToPoint:CGPointMake(302, -1) controlPoint1:CGPointMake(100.667, -1) controlPoint2:CGPointMake(201.333, -1)];
    
    return humanstartpathforipadPath;
}

- (UIBezierPath*)humanarrowforipadPath{
    UIBezierPath*  humanarrowforipadPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 22, 22)];
    return humanarrowforipadPath;
}

- (UIBezierPath*)humanstartingforipadPath{
    if(human<mhuman){
    float f=(180*((float)human/(float)mhuman));
        f=f+(2*(180-f));
    CGRect bound = CGRectMake(0, 0, 229, 229);
    UIBezierPath*  ovalPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, 0) radius:CGRectGetWidth(bound)/2 startAngle:-90 * M_PI/180 endAngle:-f  * M_PI/180 clockwise:YES];
    CGAffineTransform pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound));;
    pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound));;
    [ovalPath applyTransform:pathTransform];
    return ovalPath;
    }else{
        UIBezierPath *ovalPath = [UIBezierPath bezierPath];
        [ovalPath moveToPoint:CGPointMake(113.887, 0)];
        [ovalPath addCurveToPoint:CGPointMake(228.387, 114.5) controlPoint1:CGPointMake(177.123, 0) controlPoint2:CGPointMake(228.387, 51.263)];
        [ovalPath addCurveToPoint:CGPointMake(113.887, 229) controlPoint1:CGPointMake(228.387, 177.737) controlPoint2:CGPointMake(177.123, 229)];
        [ovalPath addCurveToPoint:CGPointMake(0.255, 128.666) controlPoint1:CGPointMake(55.447, 229) controlPoint2:CGPointMake(7.233, 185.219)];
        [ovalPath addCurveToPoint:CGPointMake(0.255, 33.386) controlPoint1:CGPointMake(-0.318, 124.025) controlPoint2:CGPointMake(0.255, 38.183)];
        
        return ovalPath;
    }
}

- (UIBezierPath*)humanscoreforipadPath{
 
    if(human<mhuman){
    float f=(180*((float)human/(float)mhuman));
    f=f+(2*(180-f))+2;
    CGRect bound = CGRectMake(0, 0, 229, 229);
    UIBezierPath*  ovalPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, 0) radius:CGRectGetWidth(bound)/2 startAngle:-90 * M_PI/180 endAngle:-f  * M_PI/180 clockwise:YES];
    CGAffineTransform pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound));;
    pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound));;
    [ovalPath applyTransform:pathTransform];
        return ovalPath;
    }else{
        UIBezierPath *ovalPath = [UIBezierPath bezierPath];
        [ovalPath moveToPoint:CGPointMake(113.887, 0)];
        [ovalPath addCurveToPoint:CGPointMake(228.387, 114.5) controlPoint1:CGPointMake(177.123, 0) controlPoint2:CGPointMake(228.387, 51.263)];
        [ovalPath addCurveToPoint:CGPointMake(113.887, 229) controlPoint1:CGPointMake(228.387, 177.737) controlPoint2:CGPointMake(177.123, 229)];
        [ovalPath addCurveToPoint:CGPointMake(0.255, 128.666) controlPoint1:CGPointMake(55.447, 229) controlPoint2:CGPointMake(7.233, 185.219)];
        [ovalPath addCurveToPoint:CGPointMake(0.255, 49.386) controlPoint1:CGPointMake(-0.318, 124.025) controlPoint2:CGPointMake(0.255, 38.183)];
        
        return ovalPath;
    }
}

- (UIBezierPath*)transportbackforipadPath{
    UIBezierPath *transportbackforipadPath = [UIBezierPath bezierPath];
    [transportbackforipadPath moveToPoint:CGPointMake(8, 0.321)];
    [transportbackforipadPath addCurveToPoint:CGPointMake(321.358, 0.321) controlPoint1:CGPointMake(8.254, 0.321) controlPoint2:CGPointMake(315.299, -0.401)];
    [transportbackforipadPath addCurveToPoint:CGPointMake(457.378, 153.727) controlPoint1:CGPointMake(397.974, 9.453) controlPoint2:CGPointMake(457.378, 74.653)];
    [transportbackforipadPath addCurveToPoint:CGPointMake(302.878, 308.227) controlPoint1:CGPointMake(457.378, 239.055) controlPoint2:CGPointMake(388.206, 308.227)];
    [transportbackforipadPath addCurveToPoint:CGPointMake(149.47, 172.193) controlPoint1:CGPointMake(223.799, 308.227) controlPoint2:CGPointMake(158.596, 248.816)];
    [transportbackforipadPath addCurveToPoint:CGPointMake(149.47, 75.43) controlPoint1:CGPointMake(148.749, 166.138) controlPoint2:CGPointMake(149.47, 81.679)];
    
    return transportbackforipadPath;
}

- (UIBezierPath*)transportstartingforipadPath{
    
    if(transport<mtransport){
    float f=(180*((float)transport/(float)mtransport));
        f=f+(2*(180-f));
    CGRect bound = CGRectMake(0, 0, 308, 308);
    UIBezierPath*  ovalPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, 0) radius:CGRectGetWidth(bound)/2 startAngle:-90 * M_PI/180 endAngle:-f * M_PI/180 clockwise:YES];
    CGAffineTransform pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound));;
    pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound));;
    [ovalPath applyTransform:pathTransform];
    return ovalPath;
    }else{
        UIBezierPath *ovalPath = [UIBezierPath bezierPath];
        [ovalPath moveToPoint:CGPointMake(153.536, 0)];
        [ovalPath addCurveToPoint:CGPointMake(307.536, 154) controlPoint1:CGPointMake(238.588, 0) controlPoint2:CGPointMake(307.536, 68.948)];
        [ovalPath addCurveToPoint:CGPointMake(153.536, 308) controlPoint1:CGPointMake(307.536, 239.052) controlPoint2:CGPointMake(238.588, 308)];
        [ovalPath addCurveToPoint:CGPointMake(0.193, 168.319) controlPoint1:CGPointMake(73.313, 308) controlPoint2:CGPointMake(7.416, 246.658)];
        [ovalPath addCurveToPoint:CGPointMake(0.193, 74.133) controlPoint1:CGPointMake(-0.242, 163.604) controlPoint2:CGPointMake(0.193, 78.961)];
        
        return ovalPath;
    }
}

- (UIBezierPath*)transportscoreforipadPath{
   
    if(transport<mtransport){
    float f=(180*((float)transport/(float)mtransport));
    f=f+(2*(180-f))+2;
    CGRect bound = CGRectMake(0, 0, 308, 308);
    UIBezierPath*  ovalPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, 0) radius:CGRectGetWidth(bound)/2 startAngle:-90 * M_PI/180 endAngle:-f * M_PI/180 clockwise:YES];
    CGAffineTransform pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound));;
    pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound));;
    [ovalPath applyTransform:pathTransform];
    return ovalPath;
    }else{
        UIBezierPath *ovalPath = [UIBezierPath bezierPath];
        [ovalPath moveToPoint:CGPointMake(153.536, 0)];
        [ovalPath addCurveToPoint:CGPointMake(307.536, 154) controlPoint1:CGPointMake(238.588, 0) controlPoint2:CGPointMake(307.536, 68.948)];
        [ovalPath addCurveToPoint:CGPointMake(153.536, 308) controlPoint1:CGPointMake(307.536, 239.052) controlPoint2:CGPointMake(238.588, 308)];
        [ovalPath addCurveToPoint:CGPointMake(0.193, 168.319) controlPoint1:CGPointMake(73.313, 308) controlPoint2:CGPointMake(7.416, 246.658)];
        [ovalPath addCurveToPoint:CGPointMake(0.193, 90.133) controlPoint1:CGPointMake(-0.242, 163.604) controlPoint2:CGPointMake(0.193, 90.961)];
        
        return ovalPath;
    }
}

- (UIBezierPath*)transportstartpathforipadPath{
    UIBezierPath *transportstartpathforipadPath = [UIBezierPath bezierPath];
    [transportstartpathforipadPath moveToPoint:CGPointMake(0, 0)];
    [transportstartpathforipadPath addCurveToPoint:CGPointMake(302, 0) controlPoint1:CGPointMake(100.667, 0) controlPoint2:CGPointMake(201.333, 0)];
    
    return transportstartpathforipadPath;
}

- (UIBezierPath*)transportarrowforipadPath{
    UIBezierPath*  transportarrowforipadPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 22, 22)];
    return transportarrowforipadPath;
}

- (UIBezierPath*)wastebackforipadPath{
    UIBezierPath *wastebackforipadPath = [UIBezierPath bezierPath];
    [wastebackforipadPath moveToPoint:CGPointMake(6, 0.214)];
    [wastebackforipadPath addCurveToPoint:CGPointMake(318.201, 0.214) controlPoint1:CGPointMake(5.707, 0.214) controlPoint2:CGPointMake(312.618, -0.267)];
    [wastebackforipadPath addCurveToPoint:CGPointMake(496.261, 194.488) controlPoint1:CGPointMake(417.964, 8.798) controlPoint2:CGPointMake(496.261, 92.5)];
    [wastebackforipadPath addCurveToPoint:CGPointMake(301.261, 389.488) controlPoint1:CGPointMake(496.261, 302.183) controlPoint2:CGPointMake(408.956, 389.488)];
    [wastebackforipadPath addCurveToPoint:CGPointMake(107.188, 213.625) controlPoint1:CGPointMake(200.023, 389.488) controlPoint2:CGPointMake(116.803, 312.339)];
    [wastebackforipadPath addCurveToPoint:CGPointMake(106.266, 117.498) controlPoint1:CGPointMake(106.575, 207.329) controlPoint2:CGPointMake(106.266, 123.956)];
    
    return wastebackforipadPath;
}

- (UIBezierPath*)wastestartingforipadPath{
    if(waste<mwaste){
    float f=(180*((float)waste/(float)mwaste));
        f=f+(2*(180-f));
    CGRect bound = CGRectMake(0, 0, 389, 389);
    UIBezierPath*  ovalPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, 0) radius:CGRectGetWidth(bound)/2 startAngle:-90 * M_PI/180 endAngle:-f * M_PI/180 clockwise:YES];
    CGAffineTransform pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound));;
    pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound));;
    [ovalPath applyTransform:pathTransform];
    return ovalPath;
    }else{
        UIBezierPath *ovalPath = [UIBezierPath bezierPath];
        [ovalPath moveToPoint:CGPointMake(194.315, 0)];
        [ovalPath addCurveToPoint:CGPointMake(388.815, 194.5) controlPoint1:CGPointMake(301.734, 0) controlPoint2:CGPointMake(388.815, 87.081)];
        [ovalPath addCurveToPoint:CGPointMake(194.315, 389) controlPoint1:CGPointMake(388.815, 301.919) controlPoint2:CGPointMake(301.734, 389)];
        [ovalPath addCurveToPoint:CGPointMake(0.078, 204.703) controlPoint1:CGPointMake(90.318, 389) controlPoint2:CGPointMake(5.384, 307.38)];
        [ovalPath addCurveToPoint:CGPointMake(0.078, 117.46) controlPoint1:CGPointMake(-0.097, 201.324) controlPoint2:CGPointMake(0.078, 120.883)];
        
        return ovalPath;
    }
}

- (UIBezierPath*)wastescoreforipadPath{
    if(waste<mwaste){
    float f=(180*((float)waste/(float)mwaste));
    f=f+(2*(180-f))+2;
    CGRect bound = CGRectMake(0, 0, 389, 389);
    UIBezierPath*  ovalPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, 0) radius:CGRectGetWidth(bound)/2 startAngle:-90 * M_PI/180 endAngle:-f * M_PI/180 clockwise:YES];
    CGAffineTransform pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound));;
    pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound));;
    [ovalPath applyTransform:pathTransform];
    return ovalPath;
    }else{
        UIBezierPath *ovalPath = [UIBezierPath bezierPath];
        [ovalPath moveToPoint:CGPointMake(194.315, 0)];
        [ovalPath addCurveToPoint:CGPointMake(388.815, 194.5) controlPoint1:CGPointMake(301.734, 0) controlPoint2:CGPointMake(388.815, 87.081)];
        [ovalPath addCurveToPoint:CGPointMake(194.315, 389) controlPoint1:CGPointMake(388.815, 301.919) controlPoint2:CGPointMake(301.734, 389)];
        [ovalPath addCurveToPoint:CGPointMake(0.078, 204.703) controlPoint1:CGPointMake(90.318, 389) controlPoint2:CGPointMake(5.384, 307.38)];
        [ovalPath addCurveToPoint:CGPointMake(0.078, 132.46) controlPoint1:CGPointMake(-0.097, 201.324) controlPoint2:CGPointMake(0.078, 120.883)];
        
        return ovalPath;
    }
}
- (UIBezierPath*)wastestartpathforipadPath{
    UIBezierPath *wastestartpathforipadPath = [UIBezierPath bezierPath];
    [wastestartpathforipadPath moveToPoint:CGPointMake(0, 0)];
    [wastestartpathforipadPath addCurveToPoint:CGPointMake(302, 0) controlPoint1:CGPointMake(100.667, 0) controlPoint2:CGPointMake(201.333, 0)];
    
    return wastestartpathforipadPath;
}

- (UIBezierPath*)wastearrowforipadPath{
    UIBezierPath*  wastearrowforipadPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 22, 22)];
    return wastearrowforipadPath;
}

- (UIBezierPath*)waterbackforipadPath{
    UIBezierPath *waterbackforipadPath = [UIBezierPath bezierPath];
    [waterbackforipadPath moveToPoint:CGPointMake(6, 0.152)];
    [waterbackforipadPath addCurveToPoint:CGPointMake(317.031, 0.152) controlPoint1:CGPointMake(5.281, 0.152) controlPoint2:CGPointMake(311.837, -0.191)];
    [waterbackforipadPath addCurveToPoint:CGPointMake(536.316, 234.635) controlPoint1:CGPointMake(439.491, 8.238) controlPoint2:CGPointMake(536.316, 110.129)];
    [waterbackforipadPath addCurveToPoint:CGPointMake(301.316, 469.635) controlPoint1:CGPointMake(536.316, 364.422) controlPoint2:CGPointMake(431.103, 469.635)];
    [waterbackforipadPath addCurveToPoint:CGPointMake(67.229, 255.501) controlPoint1:CGPointMake(178.56, 469.635) controlPoint2:CGPointMake(77.788, 375.514)];
    [waterbackforipadPath addCurveToPoint:CGPointMake(67.229, 157.233) controlPoint1:CGPointMake(66.624, 248.626) controlPoint2:CGPointMake(67.229, 164.265)];
    
    return waterbackforipadPath;
}

- (UIBezierPath*)waterstartingforipadPath{
    if(water<mwater){
    float f=(180*((float)water/(float)mwater));
        f=f+(2*(180-f));
    CGRect bound = CGRectMake(0, 0, 470, 470);
    UIBezierPath*  ovalPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, 0) radius:CGRectGetWidth(bound)/2 startAngle:-90 * M_PI/180 endAngle:-f * M_PI/180 clockwise:YES];
    CGAffineTransform pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound));;
    pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound));;
    [ovalPath applyTransform:pathTransform];
        return ovalPath;}
    else{
        UIBezierPath *ovalPath = [UIBezierPath bezierPath];
        [ovalPath moveToPoint:CGPointMake(234.735, 0)];
        [ovalPath addCurveToPoint:CGPointMake(469.734, 235) controlPoint1:CGPointMake(364.521, 0) controlPoint2:CGPointMake(469.734, 105.213)];
        [ovalPath addCurveToPoint:CGPointMake(234.735, 470) controlPoint1:CGPointMake(469.734, 364.787) controlPoint2:CGPointMake(364.521, 470)];
        [ovalPath addCurveToPoint:CGPointMake(0.111, 248.417) controlPoint1:CGPointMake(109.45, 470) controlPoint2:CGPointMake(7.065, 371.961)];
        [ovalPath addCurveToPoint:CGPointMake(0.111, 157.123) controlPoint1:CGPointMake(-0.139, 243.976) controlPoint2:CGPointMake(0.111, 161.626)];
        
        return ovalPath;
    }
}

- (UIBezierPath*)waterscoreforipadPath{
    if(water<mwater){
    
    float f=(180*((float)water/(float)mwater));
    f=f+(2*(180-f))+2;
    CGRect bound = CGRectMake(0, 0, 470, 470);
    UIBezierPath*  ovalPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, 0) radius:CGRectGetWidth(bound)/2 startAngle:-90 * M_PI/180 endAngle:-f * M_PI/180 clockwise:YES];
    CGAffineTransform pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound));;
    pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound));;
    [ovalPath applyTransform:pathTransform];
    return ovalPath;
    }else{
        UIBezierPath *ovalPath = [UIBezierPath bezierPath];
        [ovalPath moveToPoint:CGPointMake(234.735, 0)];
        [ovalPath addCurveToPoint:CGPointMake(469.734, 235) controlPoint1:CGPointMake(364.521, 0) controlPoint2:CGPointMake(469.734, 105.213)];
        [ovalPath addCurveToPoint:CGPointMake(234.735, 470) controlPoint1:CGPointMake(469.734, 364.787) controlPoint2:CGPointMake(364.521, 470)];
        [ovalPath addCurveToPoint:CGPointMake(0.111, 248.417) controlPoint1:CGPointMake(109.45, 470) controlPoint2:CGPointMake(7.065, 371.961)];
        [ovalPath addCurveToPoint:CGPointMake(0.111, 172.123) controlPoint1:CGPointMake(-0.139, 243.976) controlPoint2:CGPointMake(0.111, 161.626)];
        
        return ovalPath;
    }
}
- (UIBezierPath*)waterstartpathforipadPath{
    UIBezierPath *waterstartpathforipadPath = [UIBezierPath bezierPath];
    [waterstartpathforipadPath moveToPoint:CGPointMake(0, 0)];
    [waterstartpathforipadPath addCurveToPoint:CGPointMake(302, 0) controlPoint1:CGPointMake(100.667, 0) controlPoint2:CGPointMake(201.333, 0)];
    
    return waterstartpathforipadPath;
}

- (UIBezierPath*)waterarrowforipadPath{
    UIBezierPath*  waterarrowforipadPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 22, 22)];
    return waterarrowforipadPath;
}

- (UIBezierPath*)energybackforipadPath{
    UIBezierPath *energybackforipadPath = [UIBezierPath bezierPath];
    [energybackforipadPath moveToPoint:CGPointMake(8, 0.131)];
    [energybackforipadPath addCurveToPoint:CGPointMake(317.763, 0.131) controlPoint1:CGPointMake(5.285, 0.131) controlPoint2:CGPointMake(312.551, -0.163)];
    [energybackforipadPath addCurveToPoint:CGPointMake(577.016, 274.687) controlPoint1:CGPointMake(462.314, 8.291) controlPoint2:CGPointMake(577.016, 128.094)];
    [energybackforipadPath addCurveToPoint:CGPointMake(302.016, 549.687) controlPoint1:CGPointMake(577.016, 426.566) controlPoint2:CGPointMake(453.894, 549.687)];
    [energybackforipadPath addCurveToPoint:CGPointMake(27.68, 293.952) controlPoint1:CGPointMake(156.614, 549.687) controlPoint2:CGPointMake(37.568, 436.842)];
    [energybackforipadPath addCurveToPoint:CGPointMake(27.68, 198.672) controlPoint1:CGPointMake(27.24, 287.588) controlPoint2:CGPointMake(27.68, 280.148)];
    
    return energybackforipadPath;
}

- (UIBezierPath*)energystartingforipadPath{
    if(energy<menergy){
    float f=(180*((float)energy/(float)menergy));
    f=f+(2*(180-f));
    CGRect bound = CGRectMake(0, 0, 550, 550);
    UIBezierPath*  ovalPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, 0) radius:CGRectGetWidth(bound)/2 startAngle:-90 * M_PI/180 endAngle:-f * M_PI/180 clockwise:YES];
    CGAffineTransform pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound));;
    pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound));;
    [ovalPath applyTransform:pathTransform];
    return ovalPath;
    }else{
        UIBezierPath *ovalPath = [UIBezierPath bezierPath];
        [ovalPath moveToPoint:CGPointMake(274.763, 0)];
        [ovalPath addCurveToPoint:CGPointMake(549.763, 275) controlPoint1:CGPointMake(426.642, 0) controlPoint2:CGPointMake(549.763, 123.122)];
        [ovalPath addCurveToPoint:CGPointMake(274.763, 550) controlPoint1:CGPointMake(549.763, 426.878) controlPoint2:CGPointMake(426.642, 550)];
        [ovalPath addCurveToPoint:CGPointMake(0.099, 288.711) controlPoint1:CGPointMake(127.483, 550) controlPoint2:CGPointMake(7.244, 434.22)];
        [ovalPath addCurveToPoint:CGPointMake(0.099, 196.219) controlPoint1:CGPointMake(-0.124, 284.169) controlPoint2:CGPointMake(0.099, 198.816)];
        
        return ovalPath;
    }
}

- (UIBezierPath*)energyscoreforipadPath{
    if(energy<menergy){
    float f=(180*((float)energy/(float)menergy));
    f=f+(2*(180-f))+2;
    CGRect bound = CGRectMake(0, 0, 550, 550);
    UIBezierPath*  ovalPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, 0) radius:CGRectGetWidth(bound)/2 startAngle:-90 * M_PI/180 endAngle:-f * M_PI/180 clockwise:YES];
    CGAffineTransform pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound));;
    pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound));;
    [ovalPath applyTransform:pathTransform];
    return ovalPath;
    }else{
        UIBezierPath *ovalPath = [UIBezierPath bezierPath];
        [ovalPath moveToPoint:CGPointMake(274.763, 0)];
        [ovalPath addCurveToPoint:CGPointMake(549.763, 275) controlPoint1:CGPointMake(426.642, 0) controlPoint2:CGPointMake(549.763, 123.122)];
        [ovalPath addCurveToPoint:CGPointMake(274.763, 550) controlPoint1:CGPointMake(549.763, 426.878) controlPoint2:CGPointMake(426.642, 550)];
        [ovalPath addCurveToPoint:CGPointMake(0.099, 288.711) controlPoint1:CGPointMake(127.483, 550) controlPoint2:CGPointMake(7.244, 434.22)];
        [ovalPath addCurveToPoint:CGPointMake(0.099, 211.219) controlPoint1:CGPointMake(-0.124, 284.169) controlPoint2:CGPointMake(0.099, 198.816)];
        
        return ovalPath;
    }
    
}

- (UIBezierPath*)energystartpathforipadPath{
    UIBezierPath *energystartpathforipadPath = [UIBezierPath bezierPath];
    [energystartpathforipadPath moveToPoint:CGPointMake(0, 0)];
    [energystartpathforipadPath addCurveToPoint:CGPointMake(302, 0) controlPoint1:CGPointMake(100.667, 0) controlPoint2:CGPointMake(201.333, 0)];
    
    return energystartpathforipadPath;
}

- (UIBezierPath*)energyarrowforipadPath{
    UIBezierPath*  energyarrowforipadPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 22, 22)];
    return energyarrowforipadPath;
}


- (UIBezierPath*)centercircleforiphonePath{
    UIBezierPath*  centercircleforiphonePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 56, 56)];
    return centercircleforiphonePath;
}

- (UIBezierPath*)innerbackforiphonePath{
    UIBezierPath *innerbackforiphonePath = [UIBezierPath bezierPath];
    [innerbackforiphonePath moveToPoint:CGPointMake(0, 0.071)];
    [innerbackforiphonePath addCurveToPoint:CGPointMake(125.763, 0.071) controlPoint1:CGPointMake(1.509, 0.071) controlPoint2:CGPointMake(124.296, -0.088)];
    [innerbackforiphonePath addCurveToPoint:CGPointMake(162.297, 40.83) controlPoint1:CGPointMake(146.306, 2.296) controlPoint2:CGPointMake(162.297, 19.696)];
    [innerbackforiphonePath addCurveToPoint:CGPointMake(121.297, 81.83) controlPoint1:CGPointMake(162.297, 63.474) controlPoint2:CGPointMake(143.941, 81.83)];
    [innerbackforiphonePath addCurveToPoint:CGPointMake(80.623, 46.027) controlPoint1:CGPointMake(100.414, 81.83) controlPoint2:CGPointMake(83.177, 66.217)];
    [innerbackforiphonePath addCurveToPoint:CGPointMake(80.527, 12.942) controlPoint1:CGPointMake(80.408, 44.325) controlPoint2:CGPointMake(80.527, 14.702)];
    
    return innerbackforiphonePath;
}

- (UIBezierPath*)innerstartpathforiphonePath{
    UIBezierPath *innerstartpathforiphonePath = [UIBezierPath bezierPath];
    [innerstartpathforiphonePath moveToPoint:CGPointMake(0, 0)];
    [innerstartpathforiphonePath addCurveToPoint:CGPointMake(121, 0) controlPoint1:CGPointMake(40.333, 0) controlPoint2:CGPointMake(80.667, 0)];
    
    return innerstartpathforiphonePath;
}

- (UIBezierPath*)innerstartingforiphonePath{
    if(actual!=maxx){
    float f=(180*((float)actual/(float)maxx));
    f=f+(2*(180-f));
    CGRect bound = CGRectMake(0, 0, 82, 82);
    UIBezierPath*  needle1pathforiphonePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, 0) radius:CGRectGetWidth(bound)/2 startAngle:-90 * M_PI/180 endAngle:-f * M_PI/180 clockwise:YES];
    CGAffineTransform pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound));;
    pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound));;
    [needle1pathforiphonePath applyTransform:pathTransform];
    return needle1pathforiphonePath;
    }else{
        UIBezierPath *ovalPath = [UIBezierPath bezierPath];
        [ovalPath moveToPoint:CGPointMake(41.236, 0)];
        [ovalPath addCurveToPoint:CGPointMake(82.236, 41) controlPoint1:CGPointMake(63.88, 0) controlPoint2:CGPointMake(82.236, 18.356)];
        [ovalPath addCurveToPoint:CGPointMake(41.236, 82) controlPoint1:CGPointMake(82.236, 63.644) controlPoint2:CGPointMake(63.88, 82)];
        [ovalPath addCurveToPoint:CGPointMake(0.52, 45.85) controlPoint1:CGPointMake(20.234, 82) controlPoint2:CGPointMake(2.919, 66.208)];
        [ovalPath addCurveToPoint:CGPointMake(0, 14.061) controlPoint1:CGPointMake(0.333, 44.259) controlPoint2:CGPointMake(0, 15.702)];
        
        return ovalPath;
    }
}

- (UIBezierPath*)innerscoreforiphonePath{
    if(actual!=maxx){
    float f=(180*((float)actual/(float)maxx));
    f=f+(2*(180-f))+4;
    CGRect bound = CGRectMake(0, 0, 82, 82);
    UIBezierPath*  needle1pathforiphonePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, 0) radius:CGRectGetWidth(bound)/2 startAngle:-90 * M_PI/180 endAngle:-f * M_PI/180 clockwise:YES];
    CGAffineTransform pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound));;
    pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound));;
    [needle1pathforiphonePath applyTransform:pathTransform];
    return needle1pathforiphonePath;
    }
    else{
        UIBezierPath *ovalPath = [UIBezierPath bezierPath];
        [ovalPath moveToPoint:CGPointMake(41.236, 0)];
        [ovalPath addCurveToPoint:CGPointMake(82.236, 41) controlPoint1:CGPointMake(63.88, 0) controlPoint2:CGPointMake(82.236, 18.356)];
        [ovalPath addCurveToPoint:CGPointMake(41.236, 82) controlPoint1:CGPointMake(82.236, 63.644) controlPoint2:CGPointMake(63.88, 82)];
        [ovalPath addCurveToPoint:CGPointMake(0.52, 45.85) controlPoint1:CGPointMake(20.234, 82) controlPoint2:CGPointMake(2.919, 66.208)];
        [ovalPath addCurveToPoint:CGPointMake(0, 22.061) controlPoint1:CGPointMake(0.333, 44.259) controlPoint2:CGPointMake(0, 15.702)];
        
        return ovalPath;
    }
}

- (UIBezierPath*)innerarrowforiphonePath{
    UIBezierPath*  innerarrowforiphonePath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 10, 10)];
    return innerarrowforiphonePath;
}

- (UIBezierPath*)middlebackforiphonePath{
    UIBezierPath *middlebackforiphonePath = [UIBezierPath bezierPath];
    [middlebackforiphonePath moveToPoint:CGPointMake(0, 0)];
    [middlebackforiphonePath addCurveToPoint:CGPointMake(124.889, 0.109) controlPoint1:CGPointMake(1.243, 0) controlPoint2:CGPointMake(123.664, 0.037)];
    [middlebackforiphonePath addCurveToPoint:CGPointMake(183.186, 62) controlPoint1:CGPointMake(157.407, 2.025) controlPoint2:CGPointMake(183.186, 29.002)];
    [middlebackforiphonePath addCurveToPoint:CGPointMake(121.186, 124) controlPoint1:CGPointMake(183.186, 96.242) controlPoint2:CGPointMake(155.427, 124)];
    [middlebackforiphonePath addCurveToPoint:CGPointMake(59.375, 66.887) controlPoint1:CGPointMake(88.589, 124) controlPoint2:CGPointMake(61.867, 98.844)];
    [middlebackforiphonePath addCurveToPoint:CGPointMake(59.281, 34.338) controlPoint1:CGPointMake(59.25, 65.274) controlPoint2:CGPointMake(59.281, 35.983)];
    
    return middlebackforiphonePath;
}

- (UIBezierPath*)middlestartpathforiphonePath{
    UIBezierPath *middlestartpathforiphonePath = [UIBezierPath bezierPath];
    [middlestartpathforiphonePath moveToPoint:CGPointMake(0, 0)];
    [middlestartpathforiphonePath addCurveToPoint:CGPointMake(121, 0) controlPoint1:CGPointMake(40.333, 0) controlPoint2:CGPointMake(80.667, 0)];
    
    return middlestartpathforiphonePath;
}

- (UIBezierPath*)middlestartingforiphonePath{
   if(actual!=maxx)
   {    float f=(180*((float)actual/(float)maxx));
    f=f+(2*(180-f));
    CGRect bound = CGRectMake(0, 0, 124, 124);
    UIBezierPath*  needle1pathforiphonePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, 0) radius:CGRectGetWidth(bound)/2 startAngle:-90 * M_PI/180 endAngle:-f * M_PI/180 clockwise:YES];
    CGAffineTransform pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound));;
    pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound));;
    [needle1pathforiphonePath applyTransform:pathTransform];
    return needle1pathforiphonePath;
   }else{
       UIBezierPath *ovalPath = [UIBezierPath bezierPath];
       [ovalPath moveToPoint:CGPointMake(61.87, 0)];
       [ovalPath addCurveToPoint:CGPointMake(123.87, 62) controlPoint1:CGPointMake(96.112, 0) controlPoint2:CGPointMake(123.87, 27.758)];
       [ovalPath addCurveToPoint:CGPointMake(61.87, 124) controlPoint1:CGPointMake(123.87, 96.242) controlPoint2:CGPointMake(96.112, 124)];
       [ovalPath addCurveToPoint:CGPointMake(0.054, 66.814) controlPoint1:CGPointMake(29.248, 124) controlPoint2:CGPointMake(2.511, 98.806)];
       [ovalPath addCurveToPoint:CGPointMake(0.054, 35.168) controlPoint1:CGPointMake(-0.068, 65.226) controlPoint2:CGPointMake(0.054, 36.788)];
       
       return ovalPath;
   }
}

- (UIBezierPath*)middlescoreforiphonePath{
    if(actual!=maxx){
    float f=(180*((float)actual/(float)maxx));
    f=f+(2*(180-f))+4;
    CGRect bound = CGRectMake(0, 0, 124, 124);
    UIBezierPath*  needle1pathforiphonePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, 0) radius:CGRectGetWidth(bound)/2 startAngle:-90 * M_PI/180 endAngle:-f * M_PI/180 clockwise:YES];
    CGAffineTransform pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound));;
    pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound));;
    [needle1pathforiphonePath applyTransform:pathTransform];
    return needle1pathforiphonePath;
    }else{
        UIBezierPath *ovalPath = [UIBezierPath bezierPath];
        [ovalPath moveToPoint:CGPointMake(61.87, 0)];
        [ovalPath addCurveToPoint:CGPointMake(123.87, 62) controlPoint1:CGPointMake(96.112, 0) controlPoint2:CGPointMake(123.87, 27.758)];
        [ovalPath addCurveToPoint:CGPointMake(61.87, 124) controlPoint1:CGPointMake(123.87, 96.242) controlPoint2:CGPointMake(96.112, 124)];
        [ovalPath addCurveToPoint:CGPointMake(0.054, 66.814) controlPoint1:CGPointMake(29.248, 124) controlPoint2:CGPointMake(2.511, 98.806)];
        [ovalPath addCurveToPoint:CGPointMake(0.054, 43.168) controlPoint1:CGPointMake(-0.068, 65.226) controlPoint2:CGPointMake(0.054, 36.788)];
        
        return ovalPath;
    }
}

- (UIBezierPath*)middlearrowforiphonePath{
    UIBezierPath*  middlearrowforiphonePath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 10, 10)];
    return middlearrowforiphonePath;
}

- (UIBezierPath*)outerbackforiphonePath{
    UIBezierPath *outerbackforiphonePath = [UIBezierPath bezierPath];
    [outerbackforiphonePath moveToPoint:CGPointMake(0, 0.03)];
    [outerbackforiphonePath addCurveToPoint:CGPointMake(125.896, 0.03) controlPoint1:CGPointMake(1.512, 0.03) controlPoint2:CGPointMake(124.401, -0.038)];
    [outerbackforiphonePath addCurveToPoint:CGPointMake(218.885, 97.428) controlPoint1:CGPointMake(177.649, 2.387) controlPoint2:CGPointMake(218.885, 45.092)];
    [outerbackforiphonePath addCurveToPoint:CGPointMake(121.385, 194.928) controlPoint1:CGPointMake(218.885, 151.276) controlPoint2:CGPointMake(175.233, 194.928)];
    [outerbackforiphonePath addCurveToPoint:CGPointMake(23.982, 101.833) controlPoint1:CGPointMake(69.013, 194.928) controlPoint2:CGPointMake(26.286, 153.636)];
    [outerbackforiphonePath addCurveToPoint:CGPointMake(23.982, 101.833) controlPoint1:CGPointMake(23.982, 101.833) controlPoint2:CGPointMake(23.982, 101.833)];
    [outerbackforiphonePath addCurveToPoint:CGPointMake(23.703, 69.607) controlPoint1:CGPointMake(23.918, 100.373) controlPoint2:CGPointMake(23.703, 71.084)];
    
    return outerbackforiphonePath;
}

- (UIBezierPath*)outerstartpathforiphonePath{
    UIBezierPath *outerstartpathforiphonePath = [UIBezierPath bezierPath];
    [outerstartpathforiphonePath moveToPoint:CGPointMake(0, 0)];
    [outerstartpathforiphonePath addCurveToPoint:CGPointMake(121, 0) controlPoint1:CGPointMake(40.333, 0) controlPoint2:CGPointMake(80.667, 0)];
    
    return outerstartpathforiphonePath;
}

- (UIBezierPath*)outerstartingforiphonePath{
    if(actual!=maxx){
    float f=(180*((float)actual/(float)maxx));
    f=f+(2*(180-f));
    CGRect bound = CGRectMake(0, 0, 195, 195);
    UIBezierPath*  needle1pathforiphonePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, 0) radius:CGRectGetWidth(bound)/2 startAngle:-90 * M_PI/180 endAngle:-f * M_PI/180 clockwise:YES];
    CGAffineTransform pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound));;
    pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound));;
    [needle1pathforiphonePath applyTransform:pathTransform];
    return needle1pathforiphonePath;
    }
    else{
        UIBezierPath *ovalPath = [UIBezierPath bezierPath];
        [ovalPath moveToPoint:CGPointMake(97.76, 0)];
        [ovalPath addCurveToPoint:CGPointMake(195.26, 97.5) controlPoint1:CGPointMake(151.608, 0) controlPoint2:CGPointMake(195.26, 43.652)];
        [ovalPath addCurveToPoint:CGPointMake(97.76, 195) controlPoint1:CGPointMake(195.26, 151.348) controlPoint2:CGPointMake(151.608, 195)];
        [ovalPath addCurveToPoint:CGPointMake(0.455, 103.713) controlPoint1:CGPointMake(46, 195) controlPoint2:CGPointMake(3.66, 154.666)];
        [ovalPath addCurveToPoint:CGPointMake(0, 72.161) controlPoint1:CGPointMake(0.326, 101.659) controlPoint2:CGPointMake(0, 74.249)];
        
        return ovalPath;
    }
}

- (UIBezierPath*)outerscoreforiphonePath{
    if(actual!=maxx){
        float f=(180*((float)actual/(float)maxx));
        f=f+(2*(180-f));
        CGRect bound = CGRectMake(0, 0, 195, 195);
        UIBezierPath*  needle1pathforiphonePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, 0) radius:CGRectGetWidth(bound)/2 startAngle:-90 * M_PI/180 endAngle:-f * M_PI/180 clockwise:YES];
        CGAffineTransform pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound));;
        pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound));;
        [needle1pathforiphonePath applyTransform:pathTransform];
        return needle1pathforiphonePath;
    }
    else{
        UIBezierPath *ovalPath = [UIBezierPath bezierPath];
        [ovalPath moveToPoint:CGPointMake(97.76, 0)];
        [ovalPath addCurveToPoint:CGPointMake(195.26, 97.5) controlPoint1:CGPointMake(151.608, 0) controlPoint2:CGPointMake(195.26, 43.652)];
        [ovalPath addCurveToPoint:CGPointMake(97.76, 195) controlPoint1:CGPointMake(195.26, 151.348) controlPoint2:CGPointMake(151.608, 195)];
        [ovalPath addCurveToPoint:CGPointMake(0.455, 103.713) controlPoint1:CGPointMake(46, 195) controlPoint2:CGPointMake(3.66, 154.666)];
        [ovalPath addCurveToPoint:CGPointMake(0, 80.161) controlPoint1:CGPointMake(0.326, 101.659) controlPoint2:CGPointMake(0, 74.249)];
        
        return ovalPath;
    }
}

- (UIBezierPath*)outerarrowforiphonePath{
    UIBezierPath*  outerarrowforiphonePath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 32, 32)];
    return outerarrowforiphonePath;
}

- (UIBezierPath*)needle1pathforiphonePath{
    if(globalavg!=maxx){
    float f=(180*((float)globalavg/(float)maxx));
    if(globalavg==localavg){
        f=f+(2*(180-f))-4;
    }else{
        f=f+(2*(180-f));
    }
    CGRect bound = CGRectMake(0, 0, 260, 260);
    UIBezierPath*  needle1pathforiphonePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, 0) radius:CGRectGetWidth(bound)/2 startAngle:-90 * M_PI/180 endAngle:-f * M_PI/180 clockwise:YES];
    CGAffineTransform pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound));;
    pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound));;
    [needle1pathforiphonePath applyTransform:pathTransform];
    return needle1pathforiphonePath;
    }else{
        UIBezierPath *ovalPath = [UIBezierPath bezierPath];
        [ovalPath moveToPoint:CGPointMake(97.76, 0)];
        [ovalPath addCurveToPoint:CGPointMake(195.26, 97.5) controlPoint1:CGPointMake(151.608, 0) controlPoint2:CGPointMake(195.26, 43.652)];
        [ovalPath addCurveToPoint:CGPointMake(97.76, 195) controlPoint1:CGPointMake(195.26, 151.348) controlPoint2:CGPointMake(151.608, 195)];
        [ovalPath addCurveToPoint:CGPointMake(0.455, 103.713) controlPoint1:CGPointMake(46, 195) controlPoint2:CGPointMake(3.66, 154.666)];
        [ovalPath addCurveToPoint:CGPointMake(0, 78.161) controlPoint1:CGPointMake(0.326, 101.659) controlPoint2:CGPointMake(0, 74.249)];
        
        return ovalPath;
    }
}

- (UIBezierPath*)needle2pathforiphonePath{
    if(localavg!=maxx){
    float f=(180*((float)localavg/(float)maxx));
    if(globalavg==localavg){
        f=f+(2*(180-f))+4;
    }else{
        f=f+(2*(180-f));
    }
    CGRect bound = CGRectMake(0, 0, 260, 260);
    UIBezierPath*  needle2pathforiphonePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, 0) radius:CGRectGetWidth(bound)/2 startAngle:-90 * M_PI/180 endAngle:-f * M_PI/180 clockwise:YES];
    CGAffineTransform pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound));;
    pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound));;
    [needle2pathforiphonePath applyTransform:pathTransform];
    return needle2pathforiphonePath;
    }else{
        UIBezierPath *ovalPath = [UIBezierPath bezierPath];
        [ovalPath moveToPoint:CGPointMake(97.76, 0)];
        [ovalPath addCurveToPoint:CGPointMake(195.26, 97.5) controlPoint1:CGPointMake(151.608, 0) controlPoint2:CGPointMake(195.26, 43.652)];
        [ovalPath addCurveToPoint:CGPointMake(97.76, 195) controlPoint1:CGPointMake(195.26, 151.348) controlPoint2:CGPointMake(151.608, 195)];
        [ovalPath addCurveToPoint:CGPointMake(0.455, 103.713) controlPoint1:CGPointMake(46, 195) controlPoint2:CGPointMake(3.66, 154.666)];
        [ovalPath addCurveToPoint:CGPointMake(0, 82.161) controlPoint1:CGPointMake(0.326, 101.659) controlPoint2:CGPointMake(0, 74.249)];
        
        return ovalPath;
    }
}

- (UIBezierPath*)localpathforiphonePath{
    if(localavg!=maxx){
    float f=(180*((float)localavg/(float)maxx));
    if(globalavg==localavg){
        f=f+(2*(180-f))+4;
    }else{
        f=f+(2*(180-f));
    }
    CGRect bound = CGRectMake(0, 0, 295, 295);
    UIBezierPath*  localpathforiphonePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, 0) radius:CGRectGetWidth(bound)/2 startAngle:-90 * M_PI/180 endAngle:-f * M_PI/180 clockwise:YES];
    CGAffineTransform pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound));;
    pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound));;
    [localpathforiphonePath applyTransform:pathTransform];
    return localpathforiphonePath;
    }else{
        UIBezierPath *ovalPath = [UIBezierPath bezierPath];
        [ovalPath moveToPoint:CGPointMake(97.76, 0)];
        [ovalPath addCurveToPoint:CGPointMake(195.26, 97.5) controlPoint1:CGPointMake(151.608, 0) controlPoint2:CGPointMake(195.26, 43.652)];
        [ovalPath addCurveToPoint:CGPointMake(97.76, 195) controlPoint1:CGPointMake(195.26, 151.348) controlPoint2:CGPointMake(151.608, 195)];
        [ovalPath addCurveToPoint:CGPointMake(0.455, 103.713) controlPoint1:CGPointMake(46, 195) controlPoint2:CGPointMake(3.66, 154.666)];
        [ovalPath addCurveToPoint:CGPointMake(0, 78.161) controlPoint1:CGPointMake(0.326, 101.659) controlPoint2:CGPointMake(0, 74.249)];
        
        return ovalPath;
    }
}

- (UIBezierPath*)globalpathforiphonePath{
    if(globalavg!=maxx){
    float f=(180*((float)globalavg/(float)maxx));
    if(globalavg==localavg){
        f=f+(2*(180-f))-4;
    }else{
        f=f+(2*(180-f));
    }
    CGRect bound = CGRectMake(0, 0, 295, 295);
    UIBezierPath*  globalpathforiphonePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, 0) radius:CGRectGetWidth(bound)/2 startAngle:-90 * M_PI/180 endAngle:-f * M_PI/180 clockwise:YES];
    CGAffineTransform pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound));;
    pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound));;
    [globalpathforiphonePath applyTransform:pathTransform];
    return globalpathforiphonePath;
    }
    else{
        UIBezierPath *ovalPath = [UIBezierPath bezierPath];
        [ovalPath moveToPoint:CGPointMake(97.76, 0)];
        [ovalPath addCurveToPoint:CGPointMake(195.26, 97.5) controlPoint1:CGPointMake(151.608, 0) controlPoint2:CGPointMake(195.26, 43.652)];
        [ovalPath addCurveToPoint:CGPointMake(97.76, 195) controlPoint1:CGPointMake(195.26, 151.348) controlPoint2:CGPointMake(151.608, 195)];
        [ovalPath addCurveToPoint:CGPointMake(0.455, 103.713) controlPoint1:CGPointMake(46, 195) controlPoint2:CGPointMake(3.66, 154.666)];
        [ovalPath addCurveToPoint:CGPointMake(0, 82.161) controlPoint1:CGPointMake(0.326, 101.659) controlPoint2:CGPointMake(0, 74.249)];
        
        return ovalPath;
    }
}


- (UIBezierPath*)centercircleforipadPath{
    UIBezierPath*  centercircleforipadPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 140, 140)];
    return centercircleforipadPath;
}

- (UIBezierPath*)innerbackforipadPath{
    UIBezierPath *innerbackforipadPath = [UIBezierPath bezierPath];
    [innerbackforipadPath moveToPoint:CGPointMake(0, 0.119)];
    [innerbackforipadPath addCurveToPoint:CGPointMake(288.102, 0.119) controlPoint1:CGPointMake(3.064, 0.119) controlPoint2:CGPointMake(285.107, -0.148)];
    [innerbackforipadPath addCurveToPoint:CGPointMake(380.012, 100.715) controlPoint1:CGPointMake(339.623, 4.714) controlPoint2:CGPointMake(380.012, 47.998)];
    [innerbackforipadPath addCurveToPoint:CGPointMake(279.012, 201.715) controlPoint1:CGPointMake(380.012, 156.496) controlPoint2:CGPointMake(334.792, 201.715)];
    [innerbackforipadPath addCurveToPoint:CGPointMake(178.433, 109.998) controlPoint1:CGPointMake(226.361, 201.715) controlPoint2:CGPointMake(183.119, 161.428)];
    [innerbackforipadPath addCurveToPoint:CGPointMake(178.433, 32.27) controlPoint1:CGPointMake(178.154, 106.941) controlPoint2:CGPointMake(178.433, 35.399)];
    
    return innerbackforipadPath;
}

- (UIBezierPath*)innerstartpathforipadPath{
    UIBezierPath *innerstartpathforipadPath = [UIBezierPath bezierPath];
    [innerstartpathforipadPath moveToPoint:CGPointMake(0, 0)];
    [innerstartpathforipadPath addCurveToPoint:CGPointMake(281, 0) controlPoint1:CGPointMake(93.667, 0) controlPoint2:CGPointMake(187.333, 0)];
    
    return innerstartpathforipadPath;
}

- (UIBezierPath*)innerstartingforipadPath{
    if(actual==maxx){
        UIBezierPath *innerstartingforipad2Path = [UIBezierPath bezierPath];
        [innerstartingforipad2Path moveToPoint:CGPointMake(99.291, 0)];
        [innerstartingforipad2Path addCurveToPoint:CGPointMake(199.291, 101) controlPoint1:CGPointMake(154.519, 0) controlPoint2:CGPointMake(199.291, 45.219)];
        [innerstartingforipad2Path addCurveToPoint:CGPointMake(99.291, 202) controlPoint1:CGPointMake(199.291, 156.781) controlPoint2:CGPointMake(154.519, 202)];
        [innerstartingforipad2Path addCurveToPoint:CGPointMake(0.294, 115.363) controlPoint1:CGPointMake(48.89, 202) controlPoint2:CGPointMake(7.198, 164.341)];
        [innerstartingforipad2Path addCurveToPoint:CGPointMake(0.294, 29.691) controlPoint1:CGPointMake(-0.367, 110.671) controlPoint2:CGPointMake(0.294, 34.567)];
        
        return innerstartingforipad2Path;
    }
    else{
        float f=(180*((float)actual/(float)maxx));
            f=f+(2*(180-f));
        CGRect bound = CGRectMake(0, 0, 202, 202);
        UIBezierPath*  globalpathforiphonePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, 0) radius:CGRectGetWidth(bound)/2 startAngle:-90 * M_PI/180 endAngle:-f * M_PI/180 clockwise:YES];
        CGAffineTransform pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound));;
        pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound));;
        [globalpathforiphonePath applyTransform:pathTransform];
        return globalpathforiphonePath;
    }
}

- (UIBezierPath*)innerscoreforipadPath{
    if(actual==maxx){
        UIBezierPath *innerstartingforipad2Path = [UIBezierPath bezierPath];
        [innerstartingforipad2Path moveToPoint:CGPointMake(99.291, 0)];
        [innerstartingforipad2Path addCurveToPoint:CGPointMake(199.291, 101) controlPoint1:CGPointMake(154.519, 0) controlPoint2:CGPointMake(199.291, 45.219)];
        [innerstartingforipad2Path addCurveToPoint:CGPointMake(99.291, 202) controlPoint1:CGPointMake(199.291, 156.781) controlPoint2:CGPointMake(154.519, 202)];
        [innerstartingforipad2Path addCurveToPoint:CGPointMake(0.294, 115.363) controlPoint1:CGPointMake(48.89, 202) controlPoint2:CGPointMake(7.198, 164.341)];
        [innerstartingforipad2Path addCurveToPoint:CGPointMake(0.294, 48.691) controlPoint1:CGPointMake(-0.367, 110.671) controlPoint2:CGPointMake(0.294, 34.567)];
        
        return innerstartingforipad2Path;
    }
    else{
        float f=(180*((float)actual/(float)maxx));
        f=f+(2*(180-f));
        CGRect bound = CGRectMake(0, 0, 202, 202);
        UIBezierPath*  globalpathforiphonePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, 0) radius:CGRectGetWidth(bound)/2 startAngle:-90 * M_PI/180 endAngle:-f * M_PI/180 clockwise:YES];
        CGAffineTransform pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound));;
        pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound));;
        [globalpathforiphonePath applyTransform:pathTransform];
        return globalpathforiphonePath;
    }
}



- (UIBezierPath*)innerarrowforipadPath{
    UIBezierPath*  innerarrowforipadPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 28, 28)];
    return innerarrowforipadPath;
}

- (UIBezierPath*)middlebackforipadPath{
    UIBezierPath *middlebackforipadPath = [UIBezierPath bezierPath];
    [middlebackforipadPath moveToPoint:CGPointMake(0, 0.07)];
    [middlebackforipadPath addCurveToPoint:CGPointMake(287.619, 0.07) controlPoint1:CGPointMake(2.868, 0.07) controlPoint2:CGPointMake(284.791, -0.088)];
    [middlebackforipadPath addCurveToPoint:CGPointMake(430.074, 150.832) controlPoint1:CGPointMake(367.039, 4.501) controlPoint2:CGPointMake(430.074, 70.305)];
    [middlebackforipadPath addCurveToPoint:CGPointMake(279.074, 301.832) controlPoint1:CGPointMake(430.074, 234.227) controlPoint2:CGPointMake(362.469, 301.832)];
    [middlebackforipadPath addCurveToPoint:CGPointMake(128.521, 162.529) controlPoint1:CGPointMake(199.615, 301.832) controlPoint2:CGPointMake(134.491, 240.458)];
    [middlebackforipadPath addCurveToPoint:CGPointMake(128.355, 160.125) controlPoint1:CGPointMake(128.459, 161.73) controlPoint2:CGPointMake(128.404, 160.928)];
    [middlebackforipadPath addCurveToPoint:CGPointMake(128.355, 83.184) controlPoint1:CGPointMake(128.169, 157.052) controlPoint2:CGPointMake(128.355, 86.305)];
    
    return middlebackforipadPath;
}

- (UIBezierPath*)middlestartpathforipadPath{
    UIBezierPath *middlestartpathforipadPath = [UIBezierPath bezierPath];
    [middlestartpathforipadPath moveToPoint:CGPointMake(0, 0)];
    [middlestartpathforipadPath addCurveToPoint:CGPointMake(281, 0) controlPoint1:CGPointMake(93.667, 0) controlPoint2:CGPointMake(187.333, 0)];
    
    return middlestartpathforipadPath;
}

- (UIBezierPath*)middlestartingforipadPath{
    if(actual==maxx){
        UIBezierPath *middlestartingforipad2Path = [UIBezierPath bezierPath];
        [middlestartingforipad2Path moveToPoint:CGPointMake(150.842, 0)];
        [middlestartingforipad2Path addCurveToPoint:CGPointMake(301.842, 151) controlPoint1:CGPointMake(234.237, 0) controlPoint2:CGPointMake(301.842, 67.605)];
        [middlestartingforipad2Path addCurveToPoint:CGPointMake(150.842, 302) controlPoint1:CGPointMake(301.842, 234.395) controlPoint2:CGPointMake(234.237, 302)];
        [middlestartingforipad2Path addCurveToPoint:CGPointMake(0.066, 159.292) controlPoint1:CGPointMake(70.229, 302) controlPoint2:CGPointMake(4.371, 238.831)];
        [middlestartingforipad2Path addCurveToPoint:CGPointMake(0.066, 83.756) controlPoint1:CGPointMake(-0.083, 156.547) controlPoint2:CGPointMake(0.066, 86.538)];
        
        return middlestartingforipad2Path;
    }else{
        float f=(180*((float)actual/(float)maxx));
        f=f+(2*(180-f));
        CGRect bound = CGRectMake(0, 0, 302, 302);
        UIBezierPath*  globalpathforiphonePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, 0) radius:CGRectGetWidth(bound)/2 startAngle:-90 * M_PI/180 endAngle:-f * M_PI/180 clockwise:YES];
        CGAffineTransform pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound));;
        pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound));;
        [globalpathforiphonePath applyTransform:pathTransform];
        return globalpathforiphonePath;
    }

}

- (UIBezierPath*)middlescoreforipadPath{
    if(actual==maxx){
        UIBezierPath *middlestartingforipad2Path = [UIBezierPath bezierPath];
        [middlestartingforipad2Path moveToPoint:CGPointMake(150.842, 0)];
        [middlestartingforipad2Path addCurveToPoint:CGPointMake(301.842, 151) controlPoint1:CGPointMake(234.237, 0) controlPoint2:CGPointMake(301.842, 67.605)];
        [middlestartingforipad2Path addCurveToPoint:CGPointMake(150.842, 302) controlPoint1:CGPointMake(301.842, 234.395) controlPoint2:CGPointMake(234.237, 302)];
        [middlestartingforipad2Path addCurveToPoint:CGPointMake(0.066, 159.292) controlPoint1:CGPointMake(70.229, 302) controlPoint2:CGPointMake(4.371, 238.831)];
        [middlestartingforipad2Path addCurveToPoint:CGPointMake(0.066, 102.756) controlPoint1:CGPointMake(-0.083, 156.547) controlPoint2:CGPointMake(0.066, 86.538)];
        
        return middlestartingforipad2Path;
    }else{
        float f=(180*((float)actual/(float)maxx));
        f=f+(2*(180-f));
        CGRect bound = CGRectMake(0, 0, 302, 302);
        UIBezierPath*  globalpathforiphonePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, 0) radius:CGRectGetWidth(bound)/2 startAngle:-90 * M_PI/180 endAngle:-f * M_PI/180 clockwise:YES];
        CGAffineTransform pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound));;
        pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound));;
        [globalpathforiphonePath applyTransform:pathTransform];
        return globalpathforiphonePath;
    }
    
}

- (UIBezierPath*)middlearrowforipadPath{
    UIBezierPath*  middlearrowforipadPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 28, 28)];
    return middlearrowforipadPath;
}

- (UIBezierPath*)outerbackforipadPath{
    UIBezierPath *outerbackforipadPath = [UIBezierPath bezierPath];
    [outerbackforipadPath moveToPoint:CGPointMake(0, 0.054)];
    [outerbackforipadPath addCurveToPoint:CGPointMake(288.435, 0.054) controlPoint1:CGPointMake(3.084, 0.054) controlPoint2:CGPointMake(285.381, -0.068)];
    [outerbackforipadPath addCurveToPoint:CGPointMake(505.227, 225.87) controlPoint1:CGPointMake(408.982, 4.885) controlPoint2:CGPointMake(505.227, 104.138)];
    [outerbackforipadPath addCurveToPoint:CGPointMake(279.227, 451.87) controlPoint1:CGPointMake(505.227, 350.687) controlPoint2:CGPointMake(404.043, 451.87)];
    [outerbackforipadPath addCurveToPoint:CGPointMake(53.514, 237.367) controlPoint1:CGPointMake(158.266, 451.87) controlPoint2:CGPointMake(59.5, 356.841)];
    [outerbackforipadPath addCurveToPoint:CGPointMake(53.514, 158.441) controlPoint1:CGPointMake(53.323, 233.559) controlPoint2:CGPointMake(53.514, 162.296)];
    
    return outerbackforipadPath;
}

- (UIBezierPath*)outerstartpathforipadPath{
    UIBezierPath *outerstartpathforipadPath = [UIBezierPath bezierPath];
    [outerstartpathforipadPath moveToPoint:CGPointMake(0, 0)];
    [outerstartpathforipadPath addCurveToPoint:CGPointMake(281, 0) controlPoint1:CGPointMake(93.667, 0) controlPoint2:CGPointMake(187.333, 0)];
    
    return outerstartpathforipadPath;
}

- (UIBezierPath*)outerstartingforipadPath{
    if(actual!=maxx){
    float f=(180*((float)actual/(float)maxx));
    f=f+(2*(180-f));
    CGRect bound = CGRectMake(0, 0, 452, 452);
    UIBezierPath*  needle1pathforipadPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, 0) radius:CGRectGetWidth(bound)/2 startAngle:-90 * M_PI/180 endAngle:-f * M_PI/180 clockwise:YES];
    CGAffineTransform pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound));;
    pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound));;
    [needle1pathforipadPath applyTransform:pathTransform];
    return needle1pathforipadPath;
    }else{
        UIBezierPath *localavgscoreforipadpath2Path = [UIBezierPath bezierPath];
        [localavgscoreforipadpath2Path moveToPoint:CGPointMake(225.477, 0)];
        [localavgscoreforipadpath2Path addCurveToPoint:CGPointMake(451.477, 226) controlPoint1:CGPointMake(350.294, 0) controlPoint2:CGPointMake(451.477, 101.184)];
        [localavgscoreforipadpath2Path addCurveToPoint:CGPointMake(225.477, 452) controlPoint1:CGPointMake(451.477, 350.816) controlPoint2:CGPointMake(350.294, 452)];
        [localavgscoreforipadpath2Path addCurveToPoint:CGPointMake(0.218, 244.429) controlPoint1:CGPointMake(106.866, 452) controlPoint2:CGPointMake(9.595, 360.626)];
        [localavgscoreforipadpath2Path addCurveToPoint:CGPointMake(0.218, 159.812) controlPoint1:CGPointMake(-0.273, 238.351) controlPoint2:CGPointMake(0.218, 169.017)];
        
        return localavgscoreforipadpath2Path;
    }
}

- (UIBezierPath*)outerscoreforipadPath{
    if(actual!=maxx){
        float f=(180*((float)actual/(float)maxx));
        f=f+(2*(180-f));
        CGRect bound = CGRectMake(0, 0, 452, 452);
        UIBezierPath*  needle1pathforipadPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, 0) radius:CGRectGetWidth(bound)/2 startAngle:-90 * M_PI/180 endAngle:-f * M_PI/180 clockwise:YES];
        CGAffineTransform pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound));;
        pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound));;
        [needle1pathforipadPath applyTransform:pathTransform];
        return needle1pathforipadPath;
    }else{
        UIBezierPath *localavgscoreforipadpath2Path = [UIBezierPath bezierPath];
        [localavgscoreforipadpath2Path moveToPoint:CGPointMake(225.477, 0)];
        [localavgscoreforipadpath2Path addCurveToPoint:CGPointMake(451.477, 226) controlPoint1:CGPointMake(350.294, 0) controlPoint2:CGPointMake(451.477, 101.184)];
        [localavgscoreforipadpath2Path addCurveToPoint:CGPointMake(225.477, 452) controlPoint1:CGPointMake(451.477, 350.816) controlPoint2:CGPointMake(350.294, 452)];
        [localavgscoreforipadpath2Path addCurveToPoint:CGPointMake(0.218, 244.429) controlPoint1:CGPointMake(106.866, 452) controlPoint2:CGPointMake(9.595, 360.626)];
        [localavgscoreforipadpath2Path addCurveToPoint:CGPointMake(0.218, 181.812) controlPoint1:CGPointMake(-0.273, 238.351) controlPoint2:CGPointMake(0.218, 169.017)];
        
        return localavgscoreforipadpath2Path;
    }
}

- (UIBezierPath*)outerarrowforipadPath{
    UIBezierPath*  outerarrowforipadPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 64, 64)];
    return outerarrowforipadPath;
}

- (UIBezierPath*)needle1pathforipadPath{
    if(localavg!=maxx){
    float f=(180*((float)localavg/(float)maxx));
    if(globalavg==localavg){
        f=f+(2*(180-f))-6;
    }else{
    f=f+(2*(180-f));
    }
    CGRect bound = CGRectMake(0, 0, 572, 572);
    UIBezierPath*  needle1pathforipadPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, 0) radius:CGRectGetWidth(bound)/2 startAngle:-90 * M_PI/180 endAngle:-f * M_PI/180 clockwise:YES];
    CGAffineTransform pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound));;
    pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound));;
    [needle1pathforipadPath applyTransform:pathTransform];
    return needle1pathforipadPath;
    }
    else{
        UIBezierPath *localavgscoreforipadpath2Path = [UIBezierPath bezierPath];
        [localavgscoreforipadpath2Path moveToPoint:CGPointMake(225.477, 0)];
        [localavgscoreforipadpath2Path addCurveToPoint:CGPointMake(451.477, 226) controlPoint1:CGPointMake(350.294, 0) controlPoint2:CGPointMake(451.477, 101.184)];
        [localavgscoreforipadpath2Path addCurveToPoint:CGPointMake(225.477, 452) controlPoint1:CGPointMake(451.477, 350.816) controlPoint2:CGPointMake(350.294, 452)];
        [localavgscoreforipadpath2Path addCurveToPoint:CGPointMake(0.218, 244.429) controlPoint1:CGPointMake(106.866, 452) controlPoint2:CGPointMake(9.595, 360.626)];
        [localavgscoreforipadpath2Path addCurveToPoint:CGPointMake(0.218, 147.812) controlPoint1:CGPointMake(-0.273, 238.351) controlPoint2:CGPointMake(0.218, 169.017)];
        
        return localavgscoreforipadpath2Path;
    }
}

- (UIBezierPath*)needle2pathforipadPath{
    if(globalavg!=maxx){
    float f=(180*((float)globalavg/(float)maxx));
    if(globalavg==localavg){
        f=f+(2*(180-f))+6;
    }else{
        f=f+(2*(180-f));
    }
    CGRect bound = CGRectMake(0, 0, 572, 572);
    UIBezierPath*  needle2pathforipadPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, 0) radius:CGRectGetWidth(bound)/2 startAngle:-90 * M_PI/180 endAngle:-f * M_PI/180 clockwise:YES];
    CGAffineTransform pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound));;
    pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound));;
    [needle2pathforipadPath applyTransform:pathTransform];
    return needle2pathforipadPath;
    }else{
        UIBezierPath *localavgscoreforipadpath2Path = [UIBezierPath bezierPath];
        [localavgscoreforipadpath2Path moveToPoint:CGPointMake(225.477, 0)];
        [localavgscoreforipadpath2Path addCurveToPoint:CGPointMake(451.477, 226) controlPoint1:CGPointMake(350.294, 0) controlPoint2:CGPointMake(451.477, 101.184)];
        [localavgscoreforipadpath2Path addCurveToPoint:CGPointMake(225.477, 452) controlPoint1:CGPointMake(451.477, 350.816) controlPoint2:CGPointMake(350.294, 452)];
        [localavgscoreforipadpath2Path addCurveToPoint:CGPointMake(0.218, 244.429) controlPoint1:CGPointMake(106.866, 452) controlPoint2:CGPointMake(9.595, 360.626)];
        [localavgscoreforipadpath2Path addCurveToPoint:CGPointMake(0.218, 177.812) controlPoint1:CGPointMake(-0.273, 238.351) controlPoint2:CGPointMake(0.218, 169.017)];
        
        return localavgscoreforipadpath2Path;
    }
}

- (UIBezierPath*)localpathforipadPath{
    if(localavg!=maxx){
    float f=(180*((float)localavg/(float)maxx));
    if(globalavg==localavg){
        f=f+(2*(180-f))-6;
    }else{
        f=f+(2*(180-f));
    }
    CGRect bound = CGRectMake(0, 0, 662, 662);
    UIBezierPath*  localpathforipadPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, 0) radius:CGRectGetWidth(bound)/2 startAngle:-90 * M_PI/180 endAngle:-f * M_PI/180 clockwise:YES];
    CGAffineTransform pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound));;
    pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound));;
    [localpathforipadPath applyTransform:pathTransform];
    return localpathforipadPath;
    }
    else{
        UIBezierPath *localavgscoreforipadpath2Path = [UIBezierPath bezierPath];
        [localavgscoreforipadpath2Path moveToPoint:CGPointMake(225.477, 0)];
        [localavgscoreforipadpath2Path addCurveToPoint:CGPointMake(451.477, 226) controlPoint1:CGPointMake(350.294, 0) controlPoint2:CGPointMake(451.477, 101.184)];
        [localavgscoreforipadpath2Path addCurveToPoint:CGPointMake(225.477, 452) controlPoint1:CGPointMake(451.477, 350.816) controlPoint2:CGPointMake(350.294, 452)];
        [localavgscoreforipadpath2Path addCurveToPoint:CGPointMake(0.218, 244.429) controlPoint1:CGPointMake(106.866, 452) controlPoint2:CGPointMake(9.595, 360.626)];
        [localavgscoreforipadpath2Path addCurveToPoint:CGPointMake(0.218, 147.812) controlPoint1:CGPointMake(-0.273, 238.351) controlPoint2:CGPointMake(0.218, 169.017)];
        
        return localavgscoreforipadpath2Path;
    }
}

- (UIBezierPath*)globalpathforipadPath{
    if(globalavg!=maxx){
    float f=(180*((float)globalavg/(float)maxx));
    if(globalavg==localavg){
        f=f+(2*(180-f))+6;
    }else{
        f=f+(2*(180-f));
    }
    CGRect bound = CGRectMake(0, 0, 662, 662);
    UIBezierPath*  globalpathforipadPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, 0) radius:CGRectGetWidth(bound)/2 startAngle:-90 * M_PI/180 endAngle:-f * M_PI/180 clockwise:YES];
    CGAffineTransform pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound));;
    pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound));;
    [globalpathforipadPath applyTransform:pathTransform];
    return globalpathforipadPath;
    }
    else{
        UIBezierPath *localavgscoreforipadpath2Path = [UIBezierPath bezierPath];
        [localavgscoreforipadpath2Path moveToPoint:CGPointMake(225.477, 0)];
        [localavgscoreforipadpath2Path addCurveToPoint:CGPointMake(451.477, 226) controlPoint1:CGPointMake(350.294, 0) controlPoint2:CGPointMake(451.477, 101.184)];
        [localavgscoreforipadpath2Path addCurveToPoint:CGPointMake(225.477, 452) controlPoint1:CGPointMake(451.477, 350.816) controlPoint2:CGPointMake(350.294, 452)];
        [localavgscoreforipadpath2Path addCurveToPoint:CGPointMake(0.218, 244.429) controlPoint1:CGPointMake(106.866, 452) controlPoint2:CGPointMake(9.595, 360.626)];
        [localavgscoreforipadpath2Path addCurveToPoint:CGPointMake(0.218, 177.812) controlPoint1:CGPointMake(-0.273, 238.351) controlPoint2:CGPointMake(0.218, 169.017)];
        
        return localavgscoreforipadpath2Path;
    }
}

- (UIBezierPath*)localavgscoreforipadpathPath{
    if(localavg!=maxx){
    float f=(180*((float)localavg/(float)maxx));
    f=f+(2*(180-f));
    CGRect bound = CGRectMake(0, 0, 452, 452);
    UIBezierPath*  localavgscoreforipadpathPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, 0) radius:CGRectGetWidth(bound)/2 startAngle:-90 * M_PI/180 endAngle:-f * M_PI/180 clockwise:YES];
    CGAffineTransform pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound));;
    pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound));;
    [localavgscoreforipadpathPath applyTransform:pathTransform];
    return localavgscoreforipadpathPath;
    }else{
        UIBezierPath *localavgscoreforipadpath2Path = [UIBezierPath bezierPath];
        [localavgscoreforipadpath2Path moveToPoint:CGPointMake(225.477, 0)];
        [localavgscoreforipadpath2Path addCurveToPoint:CGPointMake(451.477, 226) controlPoint1:CGPointMake(350.294, 0) controlPoint2:CGPointMake(451.477, 101.184)];
        [localavgscoreforipadpath2Path addCurveToPoint:CGPointMake(225.477, 452) controlPoint1:CGPointMake(451.477, 350.816) controlPoint2:CGPointMake(350.294, 452)];
        [localavgscoreforipadpath2Path addCurveToPoint:CGPointMake(0.218, 244.429) controlPoint1:CGPointMake(106.866, 452) controlPoint2:CGPointMake(9.595, 360.626)];
        [localavgscoreforipadpath2Path addCurveToPoint:CGPointMake(0.218, 147.812) controlPoint1:CGPointMake(-0.273, 238.351) controlPoint2:CGPointMake(0.218, 169.017)];
        
        return localavgscoreforipadpath2Path;
    }
}

- (UIBezierPath*)globalavgscoreforipadpathPath{
    if(globalavg!=maxx){
    float f=(180*((float)globalavg/(float)maxx));
    f=f+(2*(180-f));
    CGRect bound = CGRectMake(0, 0, 452, 452);
    UIBezierPath*  globalavgscoreforipadpathPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, 0) radius:CGRectGetWidth(bound)/2 startAngle:-90 * M_PI/180 endAngle:-f * M_PI/180 clockwise:YES];
    CGAffineTransform pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound));;
    pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound));;
    [globalavgscoreforipadpathPath applyTransform:pathTransform];
    return globalavgscoreforipadpathPath;
    }else{
        UIBezierPath *localavgscoreforipadpath2Path = [UIBezierPath bezierPath];
        [localavgscoreforipadpath2Path moveToPoint:CGPointMake(225.477, 0)];
        [localavgscoreforipadpath2Path addCurveToPoint:CGPointMake(451.477, 226) controlPoint1:CGPointMake(350.294, 0) controlPoint2:CGPointMake(451.477, 101.184)];
        [localavgscoreforipadpath2Path addCurveToPoint:CGPointMake(225.477, 452) controlPoint1:CGPointMake(451.477, 350.816) controlPoint2:CGPointMake(350.294, 452)];
        [localavgscoreforipadpath2Path addCurveToPoint:CGPointMake(0.218, 244.429) controlPoint1:CGPointMake(106.866, 452) controlPoint2:CGPointMake(9.595, 360.626)];
        [localavgscoreforipadpath2Path addCurveToPoint:CGPointMake(0.218, 177.812) controlPoint1:CGPointMake(-0.273, 238.351) controlPoint2:CGPointMake(0.218, 169.017)];
        
        return localavgscoreforipadpath2Path;
    }
}

- (UIBezierPath*)localavgscorepathforiphonePath{
    float f=(180*((float)localavg/(float)maxx));
    f=f+(2*(180-f));
    CGRect bound = CGRectMake(0, 0, 195, 195);
    UIBezierPath*  localavgscorepathforiphonePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, 0) radius:CGRectGetWidth(bound)/2 startAngle:-90 * M_PI/180 endAngle:-f * M_PI/180 clockwise:YES];
    CGAffineTransform pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound));;
    pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound));;
    [localavgscorepathforiphonePath applyTransform:pathTransform];
    return localavgscorepathforiphonePath;
}

- (UIBezierPath*)globalavgscorepathforiphonePath{
    float f=(180*((float)globalavg/(float)maxx));
    f=f+(2*(180-f));
    CGRect bound = CGRectMake(0, 0, 195, 195);
    UIBezierPath*  globalavgscorepathforiphonePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, 0) radius:CGRectGetWidth(bound)/2 startAngle:-90 * M_PI/180 endAngle:-f * M_PI/180 clockwise:YES];
    CGAffineTransform pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound));;
    pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound));;
    [globalavgscorepathforiphonePath applyTransform:pathTransform];
    return globalavgscorepathforiphonePath;
}

@end
