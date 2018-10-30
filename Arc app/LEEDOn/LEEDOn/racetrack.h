//
//  racetrack.h
//
//  Code generated using QuartzCode 1.33.2 on 10/07/15.
//  www.quartzcodeapp.com
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface racetrack : UIView
{
    CATextLayer * humanscoreforiphone,*transportscoreforiphone,*wastescoreforiphone,*waterscoreforiphone,*energyscoreforiphone,* humanscoreforipad,* transportscoreforipad,* wastescoreforipad,* waterscoreforipad,* energyscoreforipad,*innerscoreforipad,*middlescoreforipad,*outerscoreforipad,*innerscoreforiphone,*middlescoreforiphone,*outerscoreforiphone;
    int width,height,row,energy,menergy,water,mwater,mwaste,waste,transport,mtransport,human,mhuman,base;
    NSUserDefaults *prefs;
    NSTimer *t1,*t2,*t3,*t4,*t5,*ti1,*ti2,*ti3,*ti4,*ti5,*inner,*outer,*middle,*inner1,*middle1,*outer1;
    int temphuman,temptransport,tempwaste,tempwater,tempenergy,globalavg,localavg,actual,maxx,outeractual,innercount,middlecount,inneractual,middleactual;
}

@property (nonatomic, assign) CGFloat  humananimationsAnimProgress;


- (void)addIphoneanimationAnimation;

@end

/*
CAShapeLayer * localavgscorepathforiphone = [CAShapeLayer layer];
localavgscorepathforiphone.frame     = CGRectMake(62.5, 141.5, 195, 195);
localavgscorepathforiphone.fillColor = nil;
localavgscorepathforiphone.lineWidth = 0;
localavgscorepathforiphone.path      = [self localavgscorepathforiphonePath].CGPath;
[self.layer addSublayer:localavgscorepathforiphone];
self.layers[@"localavgscorepathforiphone"] = localavgscorepathforiphone;


CAShapeLayer * globalavgscorepathforiphone = [CAShapeLayer layer];
globalavgscorepathforiphone.frame     = CGRectMake(62.5, 141.5, 195, 195);
globalavgscorepathforiphone.fillColor = nil;
globalavgscorepathforiphone.lineWidth = 0;
globalavgscorepathforiphone.path      = [self globalavgscorepathforiphonePath].CGPath;
[self.layer addSublayer:globalavgscorepathforiphone];
self.layers[@"globalavgscorepathforiphone"] = globalavgscorepathforiphone; 
 
 
 
 CAShapeLayer * localpathforiphone = [CAShapeLayer layer];
 localpathforiphone.frame     = CGRectMake(12.56, 91.52, 295, 295);
 localpathforiphone.fillColor = nil;
 localpathforiphone.lineWidth = 0;
 localpathforiphone.path      = [self localpathforiphonePath].CGPath;
 [self.layer addSublayer:localpathforiphone];
 self.layers[@"localpathforiphone"] = localpathforiphone;
 
 CAShapeLayer * globalpathforiphone = [CAShapeLayer layer];
 globalpathforiphone.frame     = CGRectMake(12.56, 91.52, 295, 295);
 globalpathforiphone.fillColor = nil;
 globalpathforiphone.lineWidth = 0;
 globalpathforiphone.path      = [self globalpathforiphonePath].CGPath;
 [self.layer addSublayer:globalpathforiphone];
 self.layers[@"globalpathforiphone"] = globalpathforiphone;
 
 
 */
