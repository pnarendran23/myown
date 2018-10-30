//
//  plaque.h
//
//  Code generated using QuartzCode 1.38.3 on 11/01/16.
//  www.quartzcodeapp.com
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
@import SpriteKit;
@import QuartzCore;

IB_DESIGNABLE
@interface plaquebig : UIView
{
    int i;
    NSTimer *rotatetimer;
    float widthh;
    float heightt;
    UIDevice *d;
    int width1,height1,nu1,nu2,tmp,actualtxt,resizee;
    BOOL loadedd,initiall;
    CFTimeInterval duration;
    CADisplayLink  *displayLink;
    NSString *lastorientation;
    int totalls,ww,hh,ii;
    
    NSTimer *timer1,*timer2,*timer3,*starter,*suspender,*startupp,*fliptimer;
    float energyvalue,watervalue,wastevalue,transportvalue,humanvalue,basevalue;
    float menergyvalue,mwatervalue,mwastevalue,mtransportvalue,mhumanvalue,mbasevalue;
}


@property (nonatomic,strong) NSString *resizer;
- (void)removeAnimationsForAnimationId:(NSString *)identifier;
- (void)removeAllAnimations;
-(void)setupLayerFrames;
-(void)continueagain;
-(void)adjustlinewidth;
//-(void)resizeme;
@end



