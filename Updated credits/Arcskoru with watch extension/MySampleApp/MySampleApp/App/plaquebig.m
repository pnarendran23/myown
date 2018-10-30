
//0.993 has been chanegd to 0.982 for scores and backs opaque animation

//  plaque.m
//
//  Code generated using QuartzCode 1.39.2 on 12/01/16.
//  www.quartzcodeapp.com
//

#import "plaquebig.h"
#import "QCMethod.h"

@interface plaquebig ()

@property (nonatomic, strong) NSMutableDictionary * layerss;


@end

@implementation plaquebig

int width1,height1,nu1,nu2,tmp=0,actualtxt=0,resizee=0;
BOOL loadedd=NO,initiall;
CFTimeInterval durationn;
CADisplayLink  *displayLinkk;
NSString *lastorientationn;
int totalls,ww,hh,ii;

NSTimer *timer1,*timer2,*timer3,*starterr,*suspenderr,*startupp,*fliptimer;
float energyvaluee,watervaluee,wastevaluee,transportvaluee,humanvaluee,basevaluee;
float menergyvaluee,mwatervaluee,mwastevaluee,mtransportvaluee,mhumanvaluee,mbasevaluee;
#pragma mark - Life Cycle

-(void)sumup{
    NSLog(@"welcome");
    NSLog(@"asd s{0}",height1);
    
    
}

-(void)flip{
    CATextLayer *t=self.layerss[@"maxscore"];
    t.opacity=0;
    [UIView transitionWithView:self
                      duration:1
                       options:UIViewAnimationOptionTransitionFlipFromLeft | UIViewAnimationOptionAllowAnimatedContent
                    animations:^{
                        CATextLayer *t=self.layerss[@"maxscore"];
                        t.opacity=1;
                    }
                    completion:NULL];
}


-(void)pauseLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = pausedTime;
    [self resumeLayer:layer];
    [self performSelector:@selector(resumeLayer:) withObject:layer afterDelay:0.3];
}

-(void)resumeLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer timeOffset];
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime = timeSincePause;
}



- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.hidden=YES;
        [self setupProperties];
        [self setupLayers];
        if([[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortrait || [[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortraitUpsideDown){
            NSLog(@"Portrait");
        }else if([[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeRight ){
            NSLog(@"Landscape");
        }else{
            NSLog(@"Other");
        }
        
    }
    return self;
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self setupLayerFrames];
}

- (void)setBounds:(CGRect)bounds{
    [super setBounds:bounds];
    [self setupLayerFrames];
    
}

- (void)setupProperties{
    self.layerss = [NSMutableDictionary dictionary];
    
}


- (void) deviceOrientationDidChangeNotification:(NSNotification *)note
{
    if(resizee ==1){
        [self suspendit];
        [self continueagain];
    }
    else{
        UIDevice * device = note.object;
        width1=[[UIScreen mainScreen] bounds].size.width;
        height1=[[UIScreen mainScreen] bounds].size.height;
        ww=width1;
        hh=height1;
        NSLog(@"ww %d",ww);
        if(device.orientation==UIDeviceOrientationPortrait || device.orientation==UIDeviceOrientationLandscapeLeft || device.orientation==UIDeviceOrientationLandscapeRight){ //|| device.orientation==UIDeviceOrientationPortraitUpsideDown){
            
            self.hidden=YES;
            starterr=[NSTimer scheduledTimerWithTimeInterval:(0.4) target:self selector:@selector(avoidflick) userInfo:nil repeats:NO];
            
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                if(width1<height1){
                    self.frame=CGRectMake(0, 0.15*height1, ww, ww);
                }else{
                    self.frame=CGRectMake(0.15*width1, 0, hh, hh);
                }
                if(UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation)){
                    if([lastorientationn isEqualToString:@"landscape"] || lastorientationn.length==0){
                        self.hidden=YES;
                        starterr=[NSTimer scheduledTimerWithTimeInterval:(0.4) target:self selector:@selector(avoidflick) userInfo:nil repeats:NO];
                        lastorientationn=@"portrait";
                        self.frame=CGRectMake(0, 0.15*hh, ww, ww);
                    }
                }
                else{
                    if([lastorientationn isEqualToString:@"portrait"] || lastorientationn.length==0){
                        self.hidden=YES;
                        starterr=[NSTimer scheduledTimerWithTimeInterval:(0.4) target:self selector:@selector(avoidflick) userInfo:nil repeats:NO];
                        self.frame=CGRectMake(0.15*ww, 0, hh, hh);
                        lastorientationn=@"landscape";
                    }
                }
                
                
            }else{
                if(width1<height1){
                    self.frame=CGRectMake(0, 0.26*height1, ww, ww);
                }else{
                    self.frame=CGRectMake(0.26*width1, 0, hh, hh);
                }
                if(UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation)){
                    if([lastorientationn isEqualToString:@"landscape"] || lastorientationn.length==0){
                        self.hidden=YES;
                        starterr=[NSTimer scheduledTimerWithTimeInterval:(0.4) target:self selector:@selector(avoidflick) userInfo:nil repeats:NO];
                        lastorientationn=@"portrait";
                        self.frame=CGRectMake(0, 0.25*hh, ww, ww);
                    }
                }
                else{
                    if([lastorientationn isEqualToString:@"portrait"] || lastorientationn.length==0){
                        self.hidden=YES;
                        starterr=[NSTimer scheduledTimerWithTimeInterval:(0.4) target:self selector:@selector(avoidflick) userInfo:nil repeats:NO];
                        self.frame=CGRectMake(0.25*ww, 0, hh, hh);
                        lastorientationn=@"landscape";
                    }
                }
            }
            [self adjustlinewidth];
            if(loadedd==NO){
                loadedd=YES;
                initiall=YES;
                [timer1 invalidate];
                if(            [timer1 isValid]){
                    NSLog(@"Timer started");
                }
                
                [self removeAllAnimations];
                if(initiall==YES){
                    displayLinkk = [CADisplayLink displayLinkWithTarget:self
                                                               selector:@selector(tick:)];
                    [displayLinkk addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
                }
            }
            
            /*     if(UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation) && (lastorientationn.length==0 || ![lastorientationn isEqualToString:@"portrait"])){
             self.hidden=YES;
             starterr=[NSTimer scheduledTimerWithTimeInterval:(0.4) target:self selector:@selector(avoidflick) userInfo:nil repeats:NO];
             lastorientationn=@"portrait";
             if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
             self.frame=CGRectMake(0,0.15*height1, ww,ww);
             
             }else{
             self.frame=CGRectMake(0*width1,0.2*height1, 1*width1, 1*width1);
             }
             [self adjustlinewidth];
             if(loadedd==NO){
             loadedd=YES;
             initiall=YES;
             [timer1 invalidate];
             if(            [timer1 isValid]){
             NSLog(@"Timer started");
             }
             
             [self removeAllAnimations];
             if(initiall==YES){
             displayLinkk = [CADisplayLink displayLinkWithTarget:self
             selector:@selector(tick:)];
             [displayLinkk addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
             }
             }
             
             
             }*/
        }else{
            self.hidden=YES;
            starterr=[NSTimer scheduledTimerWithTimeInterval:(0.4) target:self selector:@selector(avoidflick) userInfo:nil repeats:NO];
            lastorientationn=@"portrait";
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                self.frame=CGRectMake(0,0.15*height1, ww,ww);
                
            }else{
                self.frame=CGRectMake(0*width1,0.2*height1, 1*width1, 1*width1);
            }
            [self adjustlinewidth];
            if(loadedd==NO){
                loadedd=YES;
                initiall=YES;
                [timer1 invalidate];
                if(            [timer1 isValid]){
                    NSLog(@"Timer started");
                }
                
                [self removeAllAnimations];
                if(initiall==YES){
                    displayLinkk = [CADisplayLink displayLinkWithTarget:self
                                                               selector:@selector(tick:)];
                    [displayLinkk addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
                }
            }
        }
    }
}





-(void)avoidflick{
    self.hidden=NO;
}

- (void)tick:(CADisplayLink *)sender
{
    durationn = sender.duration;
    // here, we update the position for all the UIView objects. example:
    CATextLayer * stepscore = self.layerss[@"stepscore"];
    stepscore.hidden=YES;
    CATextLayer * maxscore = self.layerss[@"maxscore"];
    maxscore.hidden=YES;
    CALayer * leed_plaque = self.layerss[@"leed_plaque"];
    leed_plaque.hidden=YES;
    CALayer * score = self.layerss[@"score"];
    score.hidden   = YES;
    CALayer * gold = self.layerss[@"gold"];
    gold.hidden   = YES;
    CALayer * certified = self.layerss[@"certified"];
    certified.hidden   = YES;
    CALayer * nonleed  = self.layerss[@"nonleed"];
    nonleed.hidden   = YES;
    CALayer * platinum = self.layerss[@"platinum"];
    platinum.hidden=YES;
    CALayer * silver = self.layerss[@"silver"];
    CALayer * blank = self.layerss[@"blank"];
    blank.hidden=NO;
    silver.hidden=YES;
    if(totalls==0){
        blank.hidden=YES;
    }
    
    [timer1 invalidate];
    [timer2 invalidate];
    [timer3 invalidate];
    [starterr invalidate];
    [startupp invalidate];
    timer1=nil;
    timer2=nil;
    timer3=nil;
    starterr=nil;
    startupp=nil;
    suspenderr=nil;
    
    stepscore.string=[NSString stringWithFormat:@"%d",(int)basevaluee];
    
    
    
    startupp=[NSTimer scheduledTimerWithTimeInterval:(2+(0.05*durationn)) target:self selector:@selector(addUntitled1Animation) userInfo:nil repeats:NO];
    
    
    if(initiall==YES){
        //        t2=[NSTimer scheduledTimerWithTimeInterval:6.8 target:self selector:@selector(flip) userInfo:nil repeats:NO];
        timer2=[NSTimer scheduledTimerWithTimeInterval:(7.75+(0.05*durationn)) target:self selector:@selector(flip) userInfo:nil repeats:NO];
    }
    else{
        //   t2=[NSTimer scheduledTimerWithTimeInterval:5.5 target:self selector:@selector(flip) userInfo:nil repeats:NO];
    }
    
    if(initiall==YES){
        //
        timer2=[NSTimer scheduledTimerWithTimeInterval:(15.4+(0.05*durationn)) target:self selector:@selector(sum1) userInfo:nil repeats:NO];
    }
    else{
        timer2=[NSTimer scheduledTimerWithTimeInterval:13.4 target:self selector:@selector(sum1) userInfo:nil repeats:NO];
    }
    
    
    if(initiall==YES){
        //
        timer2=[NSTimer scheduledTimerWithTimeInterval:(21.7+(0.2*durationn)) target:self selector:@selector(sum2) userInfo:nil repeats:NO];
    }else{
        timer2=[NSTimer scheduledTimerWithTimeInterval:19.7 target:self selector:@selector(sum2) userInfo:nil repeats:NO];
    }
    
    
    if(initiall==YES){
        //
        //         [self performSelector:@selector(sum3) withObject:nil afterDelay:24.4];
        
        timer2=[NSTimer scheduledTimerWithTimeInterval:(28+(0.2*durationn)) target:self selector:@selector(sum3) userInfo:nil repeats:NO];
    }else{
        timer2=[NSTimer scheduledTimerWithTimeInterval:26 target:self selector:@selector(sum3) userInfo:nil repeats:NO];
    }
    
    if(initiall==YES){
        //
        //         [self performSelector:@selector(sum4) withObject:nil afterDelay:29.2];
        timer2=[NSTimer scheduledTimerWithTimeInterval:(34+(0.2*durationn)) target:self selector:@selector(sum4) userInfo:nil repeats:NO];
    }
    else{
        timer2=[NSTimer scheduledTimerWithTimeInterval:32 target:self selector:@selector(sum4) userInfo:nil repeats:NO];
    }
    
    if(initiall==YES){
        //
        //         [self performSelector:@selector(sum5) withObject:nil afterDelay:34.5];
        timer2=[NSTimer scheduledTimerWithTimeInterval:(39.5+(0.2*durationn)) target:self selector:@selector(sum5) userInfo:nil repeats:NO];
    }else{
        timer2=[NSTimer scheduledTimerWithTimeInterval:37.5 target:self selector:@selector(sum5) userInfo:nil repeats:NO];
    }
    
    
    if(initiall==YES){
        timer1=[NSTimer scheduledTimerWithTimeInterval:72.001 target:self selector:@selector(repeatme) userInfo:nil repeats:NO];
    }
    
    
    
    [displayLinkk removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    // here we might update the windForceX and Y values or this might happen somewhere
    // else
}


/*
 -(void)resizeme{
 
 //    NSArray *a=[resizer componentsSeparatedByString:@" "];
 ww=[[a objectAtIndex:0] floatValue];
 hh=[[a objectAtIndex:1] floatValue];
 width1=ww;
 height1=hh;
 
 lastorientationn=@"";
 
 UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
 if(orientation==UIInterfaceOrientationPortrait){
 NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
 [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
 }
 else{
 NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
 [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
 }
 
 
 
 }
 */



-(void)repeatme{
    
    
    CATextLayer *t=self.layerss[@"maxscore"];
    t.opacity=0;
    [timer2 invalidate];
    [timer3 invalidate];
    if(initiall==YES){
        timer1=[NSTimer scheduledTimerWithTimeInterval:69.971 target:self selector:@selector(repeatme) userInfo:nil repeats:YES];
    }
    initiall=NO;
    CATextLayer *stepscore=self.layerss[@"stepscore"];
    stepscore.string=[NSString stringWithFormat:@"%d",(int)basevaluee];
    [self addUntitled1Animation];
    if(initiall==YES){
        //
        
        timer2=[NSTimer scheduledTimerWithTimeInterval:13.4 target:self selector:@selector(sum1) userInfo:nil repeats:NO];
    }
    else{
        timer2=[NSTimer scheduledTimerWithTimeInterval:13.4 target:self selector:@selector(sum1) userInfo:nil repeats:NO];
    }
    
    if(initiall==YES){
        //        t2=[NSTimer scheduledTimerWithTimeInterval:6.8 target:self selector:@selector(flip) userInfo:nil repeats:NO];
        //  t2=[NSTimer scheduledTimerWithTimeInterval:(5.5+(0.05*duration)) target:self selector:@selector(flip) userInfo:nil repeats:NO];
    }
    else{
        timer2=[NSTimer scheduledTimerWithTimeInterval:(5.5+(0.05*durationn)) target:self selector:@selector(flip) userInfo:nil repeats:NO];
    }
    
    
    
    if(initiall==YES){
        //
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            //         [self performSelector:@selector(sum2) withObject:nil afterDelay:19.6];
            timer2=[NSTimer scheduledTimerWithTimeInterval:19 target:self selector:@selector(sum2) userInfo:nil repeats:NO];
        }else{
            timer2=[NSTimer scheduledTimerWithTimeInterval:20.5 target:self selector:@selector(sum2) userInfo:nil repeats:NO];
        }
    }else{
        timer2=[NSTimer scheduledTimerWithTimeInterval:19.7 target:self selector:@selector(sum2) userInfo:nil repeats:NO];
    }
    
    
    if(initiall==YES){
        //
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            //         [self performSelector:@selector(sum3) withObject:nil afterDelay:24.4];
            
            timer2=[NSTimer scheduledTimerWithTimeInterval:23.8 target:self selector:@selector(sum3) userInfo:nil repeats:NO];
        }else{
            timer2=[NSTimer scheduledTimerWithTimeInterval:25.3 target:self selector:@selector(sum3) userInfo:nil repeats:NO];
        }
    }else{
        timer2=[NSTimer scheduledTimerWithTimeInterval:26 target:self selector:@selector(sum3) userInfo:nil repeats:NO];
    }
    
    if(initiall==YES){
        //
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            //         [self performSelector:@selector(sum4) withObject:nil afterDelay:29.2];
            timer2=[NSTimer scheduledTimerWithTimeInterval:28.6 target:self selector:@selector(sum4) userInfo:nil repeats:NO];
        }else{
            timer2=[NSTimer scheduledTimerWithTimeInterval:30.1 target:self selector:@selector(sum4) userInfo:nil repeats:NO];
        }
    }
    else{
        timer2=[NSTimer scheduledTimerWithTimeInterval:32 target:self selector:@selector(sum4) userInfo:nil repeats:NO];
    }
    
    if(initiall==YES){
        //
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            //         [self performSelector:@selector(sum5) withObject:nil afterDelay:34.5];
            timer2=[NSTimer scheduledTimerWithTimeInterval:33.9 target:self selector:@selector(sum5) userInfo:nil repeats:NO];
        }else{
            timer2=[NSTimer scheduledTimerWithTimeInterval:35.4 target:self selector:@selector(sum5) userInfo:nil repeats:NO];
        }
    }else{
        timer2=[NSTimer scheduledTimerWithTimeInterval:37.5 target:self selector:@selector(sum5) userInfo:nil repeats:NO];
    }
    
}



-(void)adjustlinewidth{
    CAShapeLayer * oval  = self.layerss[@"oval"];
    CAShapeLayer * oval2  = self.layerss[@"oval2"];
    CAShapeLayer * oval3  = self.layerss[@"oval3"];
    CAShapeLayer * oval4  = self.layerss[@"oval4"];
    CAShapeLayer * oval5  = self.layerss[@"oval5"];
    CAShapeLayer * humanstarting = self.layerss[@"humanstarting"];
    CAShapeLayer * transportstarting = self.layerss[@"transportstarting"];
    CAShapeLayer * wastestarting = self.layerss[@"wastestarting"];
    CAShapeLayer * waterstarting = self.layerss[@"waterstarting"];
    CAShapeLayer * energystarting = self.layerss[@"energystarting"];
    CAShapeLayer * humanfill = self.layerss[@"humanstarting"];
    CAShapeLayer * transportfill = self.layerss[@"transportstarting"];
    CAShapeLayer * wastefill = self.layerss[@"wastestarting"];
    CAShapeLayer * waterfill = self.layerss[@"waterstarting"];
    CAShapeLayer * energyfill = self.layerss[@"energystarting"];
    CATextLayer * text = [CATextLayer layer];
    CATextLayer * text2 = [CATextLayer layer];
    CATextLayer * text3 = [CATextLayer layer];
    CATextLayer * text4 = [CATextLayer layer];
    CATextLayer * text5 = [CATextLayer layer];
    CATextLayer *stepscore = self.layerss[@"stepscore"];
    CATextLayer *maxscore = self.layerss[@"maxscore"];
    text=self.layerss[@"energytext"];
    text2=self.layerss[@"watertext"];
    text3=self.layerss[@"wastetext"];
    text4=self.layerss[@"transporttext"];
    text5=self.layerss[@"humantext"];
    CATextLayer * humanmaxscore = [CATextLayer layer];
    CATextLayer * transportmaxscore = [CATextLayer layer];
    CATextLayer * wastemaxscore = [CATextLayer layer];
    CATextLayer * watermaxscore = [CATextLayer layer];
    CATextLayer * energymaxscore = [CATextLayer layer];
    humanmaxscore=self.layerss[@"humanmaxscore"];
    transportmaxscore=self.layerss[@"transportmaxscore"];
    wastemaxscore=self.layerss[@"wastemaxscore"];
    watermaxscore=self.layerss[@"watermaxscore"];
    energymaxscore=self.layerss[@"energymaxscore"];
    
    
    CATextLayer * humanscore = [CATextLayer layer];
    CATextLayer * transportscore = [CATextLayer layer];
    CATextLayer * wastescore = [CATextLayer layer];
    CATextLayer * waterscore = [CATextLayer layer];
    CATextLayer * energyscore = [CATextLayer layer];
    humanscore=self.layerss[@"humanscore"];
    transportscore=self.layerss[@"transportscore"];
    wastescore=self.layerss[@"wastescore"];
    waterscore=self.layerss[@"waterscore"];
    energyscore=self.layerss[@"energyscore"];
    
    CAShapeLayer * energyback = self.layerss[@"energyback"];
    CAShapeLayer * humanback = self.layerss[@"humanback"];
    CAShapeLayer * transportback = self.layerss[@"transportback"];
    CAShapeLayer * wasteback = self.layerss[@"wasteback"];
    CAShapeLayer * waterback = self.layerss[@"waterback"];
    
    CAShapeLayer * energystartline = self.layerss[@"energystartline"];
    CAShapeLayer * humanstartline = self.layerss[@"humanstartline"];
    CAShapeLayer * waterstartline = self.layerss[@"waterstartline"];
    CAShapeLayer * wastestartline = self.layerss[@"wastestartline"];
    CAShapeLayer * transportstartline = self.layerss[@"transportstartline"];
    CAShapeLayer * energyleveler = self.layerss[@"energyblock"];
    
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
    {
        /*oval.lineWidth=(self.frame.size.height/23)*(self.bounds.size.height/height1);
         oval2.lineWidth=(self.frame.size.height/23)*(self.bounds.size.height/height1);
         oval3.lineWidth=(self.frame.size.height/23)*(self.bounds.size.height/height1);
         oval4.lineWidth=(self.frame.size.height/23)*(self.bounds.size.height/height1);
         oval5.lineWidth=(self.frame.size.height/23)*(self.bounds.size.height/height1);
         humanstarting.lineWidth=(self.frame.size.height/23)*(self.bounds.size.height/height1);
         transportstarting.lineWidth=(self.frame.size.height/23)*(self.bounds.size.height/height1);
         wastestarting.lineWidth=(self.frame.size.height/23)*(self.bounds.size.height/height1);
         waterstarting.lineWidth=(self.frame.size.height/23)*(self.bounds.size.height/height1);
         energystarting.lineWidth=(self.frame.size.height/23)*(self.bounds.size.height/height1);
         humanfill.lineWidth=(self.frame.size.height/23)*(self.bounds.size.height/height1);
         transportfill.lineWidth=(self.frame.size.height/23)*(self.bounds.size.height/height1);
         wastefill.lineWidth=(self.frame.size.height/23)*(self.bounds.size.height/height1);
         waterfill.lineWidth=(self.frame.size.height/23)*(self.bounds.size.height/height1);
         energyfill.lineWidth=(self.frame.size.height/23)*(self.bounds.size.height/height1);
         energystartline.lineWidth=(self.frame.size.height/23)*(self.bounds.size.height/height1);
         waterstartline.lineWidth=(self.frame.size.height/23)*(self.bounds.size.height/height1);
         wastestartline.lineWidth=(self.frame.size.height/23)*(self.bounds.size.height/height1);
         transportstartline.lineWidth=(self.frame.size.height/23)*(self.bounds.size.height/height1);
         humanstartline.lineWidth=(self.frame.size.height/23)*(self.bounds.size.height/height1);
         humanback.lineWidth=(self.frame.size.height/23)*(self.bounds.size.height/height1);
         transportback.lineWidth=(self.frame.size.height/23)*(self.bounds.size.height/height1);
         wasteback.lineWidth=(self.frame.size.height/23)*(self.bounds.size.height/height1);
         waterback.lineWidth=(self.frame.size.height/23)*(self.bounds.size.height/height1);
         energyback.lineWidth=(self.frame.size.height/23)*(self.bounds.size.height/height1);
         text.fontSize=(self.frame.size.height/23)*(self.bounds.size.height/height1)/2;
         text2.fontSize=(self.frame.size.height/23)*(self.bounds.size.height/height1)/2;
         text3.fontSize=(self.frame.size.height/23)*(self.bounds.size.height/height1)/2;
         text4.fontSize=(self.frame.size.height/23)*(self.bounds.size.height/height1)/2;
         text5.fontSize=(self.frame.size.height/23)*(self.bounds.size.height/height1)/2;
         humanmaxscore.fontSize=(self.frame.size.height/23)*(self.bounds.size.height/height1)/2;
         transportmaxscore.fontSize=(self.frame.size.height/23)*(self.bounds.size.height/height1)/2;
         wastemaxscore.fontSize=(self.frame.size.height/23)*(self.bounds.size.height/height1)/2;
         watermaxscore.fontSize=(self.frame.size.height/23)*(self.bounds.size.height/height1)/2;
         energymaxscore.fontSize=(self.frame.size.height/23)*(self.bounds.size.height/height1)/2;
         humanscore.fontSize=(self.frame.size.height/23)*(self.bounds.size.height/height1)/2;
         transportscore.fontSize=(self.frame.size.height/23)*(self.bounds.size.height/height1)/2;
         wastescore.fontSize=(self.frame.size.height/23)*(self.bounds.size.height/height1)/2;
         waterscore.fontSize=(self.frame.size.height/23)*(self.bounds.size.height/height1)/2;
         energyscore.fontSize=(self.frame.size.height/23)*(self.bounds.size.height/height1)/2;
         maxscore.fontSize = 0.3*((self.frame.size.height1)*(self.bounds.size.height/height1));
         stepscore.fontSize=0.3*((self.frame.size.height1)*(self.bounds.size.height/height1));*/
        
        
        oval.lineWidth=(self.frame.size.width/(0.06*self.frame.size.width))*(self.bounds.size.width/width1);
        oval2.lineWidth=(self.frame.size.width/(0.06*self.frame.size.width))*(self.bounds.size.width/width1);
        oval3.lineWidth=(self.frame.size.width/(0.06*self.frame.size.width))*(self.bounds.size.width/width1);
        oval4.lineWidth=(self.frame.size.width/(0.06*self.frame.size.width))*(self.bounds.size.width/width1);
        oval5.lineWidth=(self.frame.size.width/(0.06*self.frame.size.width))*(self.bounds.size.width/width1);
        humanstarting.lineWidth=(0.04*self.frame.size.width);
        NSLog(@"lwdith %f %f",humanstarting.lineWidth,self.frame.size.width);
        
        transportstarting.lineWidth=(0.04*self.frame.size.width);
        wastestarting.lineWidth=(0.04*self.frame.size.width);
        waterstarting.lineWidth=(0.04*self.frame.size.width);
        energystarting.lineWidth=(0.04*self.frame.size.width);
        energystartline.lineWidth=(0.04*self.frame.size.width);
        waterstartline.lineWidth=(0.04*self.frame.size.width);
        wastestartline.lineWidth=(0.04*self.frame.size.width);
        transportstartline.lineWidth=(0.04*self.frame.size.width);
        humanstartline.lineWidth=(0.04*self.frame.size.width);
        energyleveler.lineWidth=(0.04*self.frame.size.width);
        humanback.lineWidth=(0.04*self.frame.size.width);
        transportback.lineWidth=(0.04*self.frame.size.width);
        wasteback.lineWidth=(0.04*self.frame.size.width);
        waterback.lineWidth=(0.04*self.frame.size.width);
        energyback.lineWidth=(0.04*self.frame.size.width);
        text.fontSize=0.5*humanback.lineWidth;
        text2.fontSize=0.5*humanback.lineWidth;
        text3.fontSize=0.5*humanback.lineWidth;
        text4.fontSize=0.5*humanback.lineWidth;
        text5.fontSize=0.5*humanback.lineWidth;
        humanscore.fontSize=0.5*humanback.lineWidth;
        transportscore.fontSize=0.5*humanback.lineWidth;
        wastescore.fontSize=0.5*humanback.lineWidth;
        waterscore.fontSize=0.5*humanback.lineWidth;
        energyscore.fontSize=0.5*humanback.lineWidth;
        humanmaxscore.fontSize=0.5*humanback.lineWidth;
        transportmaxscore.fontSize=0.5*humanback.lineWidth;
        wastemaxscore.fontSize=0.5*humanback.lineWidth;
        watermaxscore.fontSize=0.5*humanback.lineWidth;
        energymaxscore.fontSize=0.5*humanback.lineWidth;
        maxscore.fontSize = 0.52*((self.frame.size.width)*(self.bounds.size.width/width1));
        stepscore.fontSize=0.52*((self.frame.size.width)*(self.bounds.size.width/width1));
        CAShapeLayer *pl=self.layerss[@"platinum"];
        maxscore.fontSize=0.39*pl.bounds.size.width;//0.35
        stepscore.fontSize=0.39*pl.bounds.size.width;//0.35
        NSLog(@"font sixe %f %f",maxscore.fontSize,pl.bounds.size.width);
        
    }
    else{
        
        NSLog(@"Fcc %f %f %f",self.frame.size.width,self.frame.size.height,0.06*self.frame.size.width);
        oval.lineWidth=(self.frame.size.width/(0.06*self.frame.size.width))*(self.bounds.size.width/width1);
        oval2.lineWidth=(self.frame.size.width/(0.06*self.frame.size.width))*(self.bounds.size.width/width1);
        oval3.lineWidth=(self.frame.size.width/(0.06*self.frame.size.width))*(self.bounds.size.width/width1);
        oval4.lineWidth=(self.frame.size.width/(0.06*self.frame.size.width))*(self.bounds.size.width/width1);
        oval5.lineWidth=(self.frame.size.width/(0.06*self.frame.size.width))*(self.bounds.size.width/width1);
        humanstarting.lineWidth=(0.04*self.frame.size.width);
        NSLog(@"lwdith %f %f",humanstarting.lineWidth,self.frame.size.width);
        
        transportstarting.lineWidth=(0.04*self.frame.size.width);
        wastestarting.lineWidth=(0.04*self.frame.size.width);
        waterstarting.lineWidth=(0.04*self.frame.size.width);
        energystarting.lineWidth=(0.04*self.frame.size.width);
        energystartline.lineWidth=(0.04*self.frame.size.width);
        waterstartline.lineWidth=(0.04*self.frame.size.width);
        wastestartline.lineWidth=(0.04*self.frame.size.width);
        transportstartline.lineWidth=(0.04*self.frame.size.width);
        humanstartline.lineWidth=(0.04*self.frame.size.width);
        humanback.lineWidth=(0.04*self.frame.size.width);
        transportback.lineWidth=(0.04*self.frame.size.width);
        wasteback.lineWidth=(0.04*self.frame.size.width);
        waterback.lineWidth=(0.04*self.frame.size.width);
        energyback.lineWidth=(0.04*self.frame.size.width);
        text.fontSize=0.5*humanback.lineWidth;
        text2.fontSize=0.5*humanback.lineWidth;
        text3.fontSize=0.5*humanback.lineWidth;
        text4.fontSize=0.5*humanback.lineWidth;
        text5.fontSize=0.5*humanback.lineWidth;
        humanscore.fontSize=0.5*humanback.lineWidth;
        transportscore.fontSize=0.5*humanback.lineWidth;
        wastescore.fontSize=0.5*humanback.lineWidth;
        waterscore.fontSize=0.5*humanback.lineWidth;
        energyscore.fontSize=0.5*humanback.lineWidth;
        humanmaxscore.fontSize=0.5*humanback.lineWidth;
        transportmaxscore.fontSize=0.5*humanback.lineWidth;
        wastemaxscore.fontSize=0.5*humanback.lineWidth;
        watermaxscore.fontSize=0.5*humanback.lineWidth;
        energymaxscore.fontSize=0.5*humanback.lineWidth;
        maxscore.fontSize = 0.52*((self.frame.size.width)*(self.bounds.size.width/width1));
        stepscore.fontSize=0.52*((self.frame.size.width)*(self.bounds.size.width/width1));
        CAShapeLayer *pl=self.layerss[@"platinum"];
        maxscore.fontSize=0.35*pl.bounds.size.width;
        stepscore.fontSize=0.35*pl.bounds.size.width;
        NSLog(@"font sixe %f %f",maxscore.fontSize,pl.bounds.size.width);
        
        
        
    }
}


- (void)setupLayers{
    [self sumup];
    NSString *strPath = [[NSBundle mainBundle] pathForResource:@"config" ofType:@"csv"];
    NSString *strFile = [NSString stringWithContentsOfFile:strPath encoding:NSUTF8StringEncoding error:nil];
    if (!strFile) {
        //NSLog(@"Error reading file.");
    }
    NSArray *leedarray = [[NSArray alloc] init];
    leedarray = [strFile componentsSeparatedByString:@","];
    // this .csv file is seperated with new line character
    // if .csv is seperated by comma use "," instesd of "\n"
    //NSLog(@"%@",leedarray[0]);
    
    //  NSString *url=[NSString stringWithFormat:@"http://%@/%@/performance/?key=%@",leedarray[0],leedarray[1],leedarray[2]];
    //   //NSLog(@"%@",url);
    
    NSString *leedurl= @"https://api.usgbc.org/stg/leed/assets/LEED:1000124631/scores/";//[[[[@"http://" stringByAppendingString:leedarray[0]]stringByAppendingString:@"LEED:"]stringByAppendingString:leedarray[1]]stringByAppendingString:@"/scores"];
    NSLog(@"LEED URL : %@",leedurl);
    NSString *subscriptionkey = @"8e0baacec376430ba0f81a5d960ccbb0";
    NSURL *blogURL = [NSURL URLWithString:leedurl];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:blogURL];
    request.HTTPMethod = @"GET";
    [request addValue:subscriptionkey forHTTPHeaderField:@"Ocp-Apim-Subscription-Key"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSString *bearertoken = @"1zb3PLr3D5WCiiSvXV90IaqQbbWeqe";
    [request addValue:[NSString stringWithFormat:@"Bearer %@",bearertoken] forHTTPHeaderField:@"Authorization"];
    
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:request
                                          returningResponse:&response
                                                      error:&error];
    
    if (error == nil)
    {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        if([httpResponse statusCode] == 200){
            NSDictionary *dataJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            NSLog(@"%@", dataJSON);
            NSError *error = nil;
            dispatch_async(dispatch_get_main_queue(), ^{
                NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
                NSDictionary *dataDictionary = [[NSDictionary alloc] init];
                dataDictionary = dataJSON;
                NSLog(@"%@",dataDictionary);
                NSLog(@"Plaque loading");
                NSDictionary *key = [dataDictionary objectForKey:@"scores"];
                NSLog(@"Data %@",key);
                if([key objectForKey:@"energy"]== [NSNull null])
                {
                    energyvaluee=[@"0.00" floatValue];
                }
                else
                {
                    energyvaluee=[[key objectForKey:@"energy"] floatValue];
                }
                
                if([key objectForKey:@"water"]== [NSNull null])
                {
                    watervaluee=[@"0.00" floatValue];
                }
                else
                {
                    watervaluee=[[key objectForKey:@"water"] floatValue];
                }
                
                if([key objectForKey:@"waste"]== [NSNull null])
                {
                    wastevaluee=[@"0.00" floatValue];
                }
                else
                {
                    wastevaluee=[[key objectForKey:@"waste"] floatValue];
                }
                
                if([key objectForKey:@"transport"]== [NSNull null])
                {
                    transportvaluee=[@"0.00" floatValue];
                }
                else
                {
                    transportvaluee=[[key objectForKey:@"transport"] floatValue];
                }
                
                if([key objectForKey:@"human_experience"]== [NSNull null])
                {
                    humanvaluee=[@"0.00" floatValue];
                }
                else
                {
                    humanvaluee=[[key objectForKey:@"human_experience"] floatValue];
                }
                
                if([key objectForKey:@"base"]== [NSNull null])
                {
                    basevaluee=[@"0.00" floatValue];
                }
                else
                {
                    basevaluee=[[key objectForKey:@"base"] floatValue];
                }
                
                key=[dataDictionary objectForKey:@"maxima"];
                
                if([key objectForKey:@"energy"]== [NSNull null])
                {
                    menergyvaluee=[@"0.00" floatValue];
                }
                else
                {
                    menergyvaluee=[[key objectForKey:@"energy"] floatValue];
                }
                
                if([key objectForKey:@"water"]== [NSNull null])
                {
                    mwatervaluee=[@"0.00" floatValue];
                }
                else
                {
                    mwatervaluee=[[key objectForKey:@"water"] floatValue];
                }
                
                if([key objectForKey:@"waste"]== [NSNull null])
                {
                    wastevaluee=[@"0.00" floatValue];
                }
                else
                {
                    mwastevaluee=[[key objectForKey:@"waste"] floatValue];
                }
                
                if([key objectForKey:@"transport"]== [NSNull null])
                {
                    mtransportvaluee=[@"0.00" floatValue];
                }
                else
                {
                    mtransportvaluee=[[key objectForKey:@"transport"] floatValue];
                }
                
                if([key objectForKey:@"human_experience"]== [NSNull null])
                {
                    mhumanvaluee=[@"0.00" floatValue];
                }
                else
                {
                    mhumanvaluee=[[key objectForKey:@"human_experience"] floatValue];
                }
                self.hidden=NO;
                
                self.backgroundColor = [UIColor blackColor];
                CALayer * dynamic_plaque = [CALayer layer];
                [self.layer addSublayer:dynamic_plaque];
                dynamic_plaque.hidden=YES;
                self.layerss[@"dynamic_plaque"] = dynamic_plaque;
                {
                    CALayer * leed_plaque = [CALayer layer];
                    [dynamic_plaque addSublayer:leed_plaque];
                    
                    self.layerss[@"leed_plaque"] = leed_plaque;
                    {
                        CALayer * transportgroup = [CALayer layer];
                        [leed_plaque addSublayer:transportgroup];
                        leed_plaque.hidden=YES;
                        self.layerss[@"transportgroup"] = transportgroup;
                        {
                            CAShapeLayer * transportback = [CAShapeLayer layer];
                            [transportgroup addSublayer:transportback];
                            transportback.fillColor   = nil;
                            transportback.strokeColor = [UIColor colorWithRed:0.196 green: 0.192 blue:0.196 alpha:1].CGColor;
                            transportback.lineWidth   = 4;
                            self.layerss[@"transportback"] = transportback;
                            
                            CATextLayer * transportmaxscore = [CATextLayer layer];
                            [transportgroup addSublayer:transportmaxscore];
                            transportmaxscore.contentsScale   = [[UIScreen mainScreen] scale];
                            transportmaxscore.string          = [NSString stringWithFormat:@"%d",(int)mtransportvaluee];
                            transportmaxscore.font            = (__bridge CFTypeRef)@"GothamBook";
                            transportmaxscore.fontSize        = 11;
                            transportmaxscore.alignmentMode   = kCAAlignmentCenter;
                            transportmaxscore.foregroundColor = [UIColor blackColor].CGColor;
                            self.layerss[@"transportmaxscore"] = transportmaxscore;
                            
                            CAShapeLayer * transportstarting = [CAShapeLayer layer];
                            [transportgroup addSublayer:transportstarting];
                            transportstarting.fillColor   = nil;
                            transportstarting.strokeColor = [UIColor colorWithRed:0.573 green: 0.557 blue:0.498 alpha:1].CGColor;
                            transportstarting.lineWidth   = 4;
                            transportstarting.strokeEnd   = 0;
                            self.layerss[@"transportstarting"] = transportstarting;
                            
                            CAShapeLayer * transportleveler = [CAShapeLayer layer];
                            [transportgroup addSublayer:transportleveler];
                            [transportleveler setValue:@(-90 * M_PI/180) forKeyPath:@"transform.rotation"];
                            transportleveler.fillColor = [UIColor colorWithRed:0.573 green: 0.557 blue:0.498 alpha:1].CGColor;
                            transportleveler.lineWidth = 0;
                            self.layerss[@"transportleveler"] = transportleveler;
                            if(transportvaluee!=mtransportvaluee){
                                transportleveler.hidden=YES;
                            }
                            
                            CAShapeLayer * transportstartline = [CAShapeLayer layer];
                            [transportgroup addSublayer:transportstartline];
                            transportstartline.fillColor   = nil;
                            transportstartline.strokeColor = [UIColor colorWithRed:0.573 green: 0.557 blue:0.498 alpha:1].CGColor;
                            transportstartline.lineWidth   = 4;
                            transportstartline.strokeEnd   = 0;
                            self.layerss[@"transportstartline"] = transportstartline;
                            
                            CAShapeLayer * transportstartarrow = [CAShapeLayer layer];
                            [transportgroup addSublayer:transportstartarrow];
                            [transportstartarrow setValue:@(-135 * M_PI/180) forKeyPath:@"transform.rotation"];
                            transportstartarrow.fillColor = [UIColor colorWithRed:0.573 green: 0.557 blue:0.498 alpha:1].CGColor;
                            transportstartarrow.lineWidth = 0;
                            self.layerss[@"transportstartarrow"] = transportstartarrow;
                            
                            CATextLayer * transporttext = [CATextLayer layer];
                            [transportgroup addSublayer:transporttext];
                            transporttext.contentsScale   = [[UIScreen mainScreen] scale];
                            transporttext.string          = @"TRANSPORT";
                            transporttext.font            = (__bridge CFTypeRef)@"GothamBook";
                            transporttext.fontSize        = 2;
                            transporttext.alignmentMode   = kCAAlignmentLeft;
                            transporttext.foregroundColor = [UIColor blackColor].CGColor;
                            self.layerss[@"transporttext"] = transporttext;
                            CALayer * transport = [CALayer layer];
                            [transportgroup addSublayer:transport];
                            transport.contents = (id)[UIImage imageNamed:@"transport"].CGImage;
                            self.layerss[@"transport"] = transport;
                            
                            CAShapeLayer * transportarrow = [CAShapeLayer layer];
                            [transportgroup addSublayer:transportarrow];
                            [transportarrow setValue:@(-45 * M_PI/180) forKeyPath:@"transform.rotation"];
                            transportarrow.fillColor = [UIColor colorWithRed:0.573 green: 0.557 blue:0.498 alpha:1].CGColor;
                            transportarrow.lineWidth = 0;
                            self.layerss[@"transportarrow"] = transportarrow;
                            
                            CATextLayer * transportscore = [CATextLayer layer];
                            [transportgroup addSublayer:transportscore];
                            transportscore.contentsScale   = [[UIScreen mainScreen] scale];
                            transportscore.string          = @"0";
                            transportscore.font            = (__bridge CFTypeRef)@"GothamBook";
                            transportscore.fontSize        = 11;
                            transportscore.alignmentMode   = kCAAlignmentCenter;
                            transportscore.foregroundColor = [UIColor blackColor].CGColor;
                            self.layerss[@"transportscore"] = transportscore;
                            
                        }
                        
                        CALayer * wastegroup = [CALayer layer];
                        [leed_plaque addSublayer:wastegroup];
                        
                        self.layerss[@"wastegroup"] = wastegroup;
                        {
                            CAShapeLayer * wasteback = [CAShapeLayer layer];
                            [wastegroup addSublayer:wasteback];
                            wasteback.fillColor   = nil;
                            wasteback.strokeColor = [UIColor colorWithRed:0.196 green: 0.192 blue:0.196 alpha:1].CGColor;
                            wasteback.lineWidth   = 4;
                            self.layerss[@"wasteback"] = wasteback;
                            CATextLayer * wastemaxscore = [CATextLayer layer];
                            [wastegroup addSublayer:wastemaxscore];
                            wastemaxscore.contentsScale   = [[UIScreen mainScreen] scale];
                            wastemaxscore.string          = [NSString stringWithFormat:@"%d",(int)mwastevaluee];
                            wastemaxscore.font            = (__bridge CFTypeRef)@"GothamBook";
                            wastemaxscore.fontSize        = 11;
                            wastemaxscore.alignmentMode   = kCAAlignmentCenter;
                            wastemaxscore.foregroundColor = [UIColor blackColor].CGColor;
                            self.layerss[@"wastemaxscore"] = wastemaxscore;
                            CAShapeLayer * wastestarting = [CAShapeLayer layer];
                            [wastegroup addSublayer:wastestarting];
                            wastestarting.fillColor   = nil;
                            wastestarting.strokeColor = [UIColor colorWithRed:0.443 green: 0.769 blue:0.634 alpha:1].CGColor;
                            wastestarting.lineWidth   = 4;
                            wastestarting.strokeEnd   = 0;
                            self.layerss[@"wastestarting"] = wastestarting;
                            
                            CAShapeLayer * wasteleveler = [CAShapeLayer layer];
                            [wastegroup addSublayer:wasteleveler];
                            [wasteleveler setValue:@(-90 * M_PI/180) forKeyPath:@"transform.rotation"];
                            wasteleveler.fillColor = [UIColor colorWithRed:0.443 green: 0.769 blue:0.634 alpha:1].CGColor;
                            wasteleveler.lineWidth = 0;
                            self.layerss[@"wasteleveler"] = wasteleveler;
                            if(wastevaluee!=mwastevaluee){
                                wasteleveler.hidden=YES;
                            }
                            
                            
                            CAShapeLayer * wastestartline = [CAShapeLayer layer];
                            [wastegroup addSublayer:wastestartline];
                            wastestartline.fillColor   = nil;
                            wastestartline.strokeColor = [UIColor colorWithRed:0.443 green: 0.769 blue:0.634 alpha:1].CGColor;
                            wastestartline.lineWidth   = 4;
                            wastestartline.strokeEnd   = 0;
                            self.layerss[@"wastestartline"] = wastestartline;
                            
                            CAShapeLayer * wastestartarrow = [CAShapeLayer layer];
                            [wastegroup addSublayer:wastestartarrow];
                            [wastestartarrow setValue:@(-135 * M_PI/180) forKeyPath:@"transform.rotation"];
                            wastestartarrow.fillColor = [UIColor colorWithRed:0.443 green: 0.769 blue:0.624 alpha:1].CGColor;
                            wastestartarrow.lineWidth = 0;
                            self.layerss[@"wastestartarrow"] = wastestartarrow;
                            
                            CALayer * waste = [CALayer layer];
                            [wastegroup addSublayer:waste];
                            waste.contents = (id)[UIImage imageNamed:@"waste"].CGImage;
                            self.layerss[@"waste"] = waste;
                            
                            
                            
                            CAShapeLayer * wastearrow = [CAShapeLayer layer];
                            [wastegroup addSublayer:wastearrow];
                            [wastearrow setValue:@(-45 * M_PI/180) forKeyPath:@"transform.rotation"];
                            wastearrow.fillColor = [UIColor colorWithRed:0.443 green: 0.769 blue:0.634 alpha:1].CGColor;
                            wastearrow.lineWidth = 0;
                            self.layerss[@"wastearrow"] = wastearrow;
                            CATextLayer * wastescore = [CATextLayer layer];
                            [wastegroup addSublayer:wastescore];
                            wastescore.contentsScale   = [[UIScreen mainScreen] scale];
                            wastescore.string          = @"0";
                            wastescore.font            = (__bridge CFTypeRef)@"GothamBook";
                            wastescore.fontSize        = 11;
                            wastescore.alignmentMode   = kCAAlignmentCenter;
                            wastescore.foregroundColor = [UIColor blackColor].CGColor;
                            self.layerss[@"wastescore"] = wastescore;
                            CATextLayer * wastetext = [CATextLayer layer];
                            [wastegroup addSublayer:wastetext];
                            wastetext.contentsScale   = [[UIScreen mainScreen] scale];
                            wastetext.string          = @"WASTE\n";
                            wastetext.font            = (__bridge CFTypeRef)@"GothamBook";
                            wastetext.fontSize        = 11;
                            wastetext.alignmentMode   = kCAAlignmentLeft;
                            wastetext.foregroundColor = [UIColor blackColor].CGColor;
                            self.layerss[@"wastetext"] = wastetext;
                        }
                        
                        CALayer * humangroup = [CALayer layer];
                        [leed_plaque addSublayer:humangroup];
                        
                        self.layerss[@"humangroup"] = humangroup;
                        {
                            CAShapeLayer * humanback = [CAShapeLayer layer];
                            [humangroup addSublayer:humanback];
                            humanback.fillColor   = nil;
                            humanback.strokeColor = [UIColor colorWithRed:0.196 green: 0.192 blue:0.196 alpha:1].CGColor;
                            humanback.lineWidth   = 4;
                            self.layerss[@"humanback"] = humanback;
                            CATextLayer * humanmaxscore = [CATextLayer layer];
                            [humangroup addSublayer:humanmaxscore];
                            humanmaxscore.contentsScale   = [[UIScreen mainScreen] scale];
                            humanmaxscore.string          = [NSString stringWithFormat:@"%d",(int)mhumanvaluee];
                            humanmaxscore.font            = (__bridge CFTypeRef)@"GothamBook";
                            humanmaxscore.fontSize        = 11;
                            humanmaxscore.alignmentMode   = kCAAlignmentCenter;
                            humanmaxscore.foregroundColor = [UIColor blackColor].CGColor;
                            self.layerss[@"humanmaxscore"] = humanmaxscore;
                            CAShapeLayer * humanstarting = [CAShapeLayer layer];
                            [humangroup addSublayer:humanstarting];
                            humanstarting.fillColor   = nil;
                            humanstarting.strokeColor = [UIColor colorWithRed:0.937 green: 0.62 blue:0.153 alpha:1].CGColor;
                            humanstarting.lineWidth   = 4;
                            humanstarting.strokeEnd   = 0;
                            self.layerss[@"humanstarting"] = humanstarting;
                            
                            CAShapeLayer * humanleveler = [CAShapeLayer layer];
                            [humangroup addSublayer:humanleveler];
                            [humanleveler setValue:@(-90 * M_PI/180) forKeyPath:@"transform.rotation"];
                            humanleveler.fillColor = [UIColor colorWithRed:0.937 green: 0.62 blue:0.153 alpha:1].CGColor;
                            humanleveler.lineWidth = 0;
                            self.layerss[@"humanleveler"] = humanleveler;
                            
                            
                            CAShapeLayer * humanstartline = [CAShapeLayer layer];
                            [humangroup addSublayer:humanstartline];
                            humanstartline.fillColor   = nil;
                            humanstartline.strokeColor = [UIColor colorWithRed:0.937 green: 0.62 blue:0.153 alpha:1].CGColor;
                            humanstartline.lineWidth   = 4;
                            humanstartline.strokeEnd   = 0;
                            self.layerss[@"humanstartline"] = humanstartline;
                            CAShapeLayer * humanstartarrow = [CAShapeLayer layer];
                            [humangroup addSublayer:humanstartarrow];
                            [humanstartarrow setValue:@(-135 * M_PI/180) forKeyPath:@"transform.rotation"];
                            humanstartarrow.fillColor = [UIColor colorWithRed:0.937 green: 0.62 blue:0.153 alpha:1].CGColor;
                            humanstartarrow.lineWidth = 0;
                            self.layerss[@"humanstartarrow"] = humanstartarrow;
                            
                            
                            CATextLayer * humantext = [CATextLayer layer];
                            [humangroup addSublayer:humantext];
                            humantext.contentsScale   = [[UIScreen mainScreen] scale];
                            humantext.string          = @"HUMAN EXPERIENCE";
                            humantext.font            = (__bridge CFTypeRef)@"GothamBook";
                            humantext.fontSize        = 11;
                            humantext.alignmentMode   = kCAAlignmentLeft;
                            humantext.foregroundColor = [UIColor blackColor].CGColor;
                            self.layerss[@"humantext"] = humantext;
                            
                            CALayer * human = [CALayer layer];
                            [humangroup addSublayer:human];
                            human.contents = (id)[UIImage imageNamed:@"human"].CGImage;
                            self.layerss[@"human"] = human;
                            
                            
                            
                            CAShapeLayer * humanarrow = [CAShapeLayer layer];
                            [humangroup addSublayer:humanarrow];
                            [humanarrow setValue:@(-45 * M_PI/180) forKeyPath:@"transform.rotation"];
                            humanarrow.fillColor = [UIColor colorWithRed:0.937 green: 0.62 blue:0.153 alpha:1].CGColor;
                            humanarrow.lineWidth = 0;
                            self.layerss[@"humanarrow"] = humanarrow;
                            CATextLayer * humanscore = [CATextLayer layer];
                            [humangroup addSublayer:humanscore];
                            humanscore.contentsScale   = [[UIScreen mainScreen] scale];
                            humanscore.string          = @"0";
                            humanscore.font            = (__bridge CFTypeRef)@"GothamBook";
                            humanscore.fontSize        = 11;
                            humanscore.alignmentMode   = kCAAlignmentCenter;
                            humanscore.foregroundColor = [UIColor blackColor].CGColor;
                            self.layerss[@"humanscore"] = humanscore;
                        }
                        
                        CALayer * watergroup = [CALayer layer];
                        [leed_plaque addSublayer:watergroup];
                        
                        self.layerss[@"watergroup"] = watergroup;
                        {
                            CAShapeLayer * waterback = [CAShapeLayer layer];
                            [watergroup addSublayer:waterback];
                            waterback.fillColor   = nil;
                            waterback.strokeColor = [UIColor colorWithRed:0.196 green: 0.192 blue:0.196 alpha:1].CGColor;
                            waterback.lineWidth   = 4;
                            self.layerss[@"waterback"] = waterback;
                            CATextLayer * watermaxscore = [CATextLayer layer];
                            [watergroup addSublayer:watermaxscore];
                            watermaxscore.contentsScale   = [[UIScreen mainScreen] scale];
                            watermaxscore.string          = [NSString stringWithFormat:@"%d",(int)mwatervaluee];
                            watermaxscore.font            = (__bridge CFTypeRef)@"GothamBook";
                            watermaxscore.fontSize        = 11;
                            watermaxscore.alignmentMode   = kCAAlignmentCenter;
                            watermaxscore.foregroundColor = [UIColor blackColor].CGColor;
                            self.layerss[@"watermaxscore"] = watermaxscore;
                            CAShapeLayer * waterstarting = [CAShapeLayer layer];
                            [watergroup addSublayer:waterstarting];
                            waterstarting.fillColor   = nil;
                            waterstarting.strokeColor = [UIColor colorWithRed:0.255 green: 0.678 blue:0.871 alpha:1].CGColor;
                            waterstarting.lineWidth   = 4;
                            waterstarting.strokeEnd= 0;
                            self.layerss[@"waterstarting"] = waterstarting;
                            CAShapeLayer * waterleveler = [CAShapeLayer layer];
                            [watergroup addSublayer:waterleveler];
                            [waterleveler setValue:@(-90 * M_PI/180) forKeyPath:@"transform.rotation"];
                            waterleveler.fillColor = [UIColor colorWithRed:0.255 green: 0.678 blue:0.871 alpha:1].CGColor;
                            waterleveler.lineWidth = 0;
                            self.layerss[@"waterleveler"] = waterleveler;
                            
                            if(watervaluee!=mwatervaluee){
                                waterleveler.hidden=YES;
                            }
                            
                            CAShapeLayer * waterstartline = [CAShapeLayer layer];
                            [watergroup addSublayer:waterstartline];
                            waterstartline.fillColor   = nil;
                            waterstartline.strokeColor = [UIColor colorWithRed:0.255 green: 0.678 blue:0.871 alpha:1].CGColor;
                            waterstartline.lineWidth   = 4;
                            waterstartline.strokeEnd   = 0;
                            self.layerss[@"waterstartline"] = waterstartline;
                            
                            CAShapeLayer * waterstartarrow = [CAShapeLayer layer];
                            [watergroup addSublayer:waterstartarrow];
                            [waterstartarrow setValue:@(-135 * M_PI/180) forKeyPath:@"transform.rotation"];
                            waterstartarrow.fillColor = [UIColor colorWithRed:0.255 green: 0.678 blue:0.871 alpha:1].CGColor;
                            waterstartarrow.lineWidth = 0;
                            self.layerss[@"waterstartarrow"] = waterstartarrow;
                            
                            
                            CATextLayer * watertext = [CATextLayer layer];
                            [watergroup addSublayer:watertext];
                            watertext.contentsScale   = [[UIScreen mainScreen] scale];
                            watertext.string          = @"WATER\n";
                            watertext.font            = (__bridge CFTypeRef)@"GothamBook";
                            watertext.fontSize        = 11;
                            watertext.alignmentMode   = kCAAlignmentLeft;
                            watertext.foregroundColor = [UIColor blackColor].CGColor;
                            self.layerss[@"watertext"] = watertext;
                            CALayer * water = [CALayer layer];
                            [watergroup addSublayer:water];
                            water.contents = (id)[UIImage imageNamed:@"water"].CGImage;
                            self.layerss[@"water"] = water;
                            CAShapeLayer * waterarrow = [CAShapeLayer layer];
                            [watergroup addSublayer:waterarrow];
                            [waterarrow setValue:@(-45 * M_PI/180) forKeyPath:@"transform.rotation"];
                            waterarrow.fillColor = [UIColor colorWithRed:0.255 green: 0.678 blue:0.871 alpha:1].CGColor;
                            waterarrow.lineWidth = 0;
                            self.layerss[@"waterarrow"] = waterarrow;
                            CATextLayer * waterscore = [CATextLayer layer];
                            [watergroup addSublayer:waterscore];
                            waterscore.contentsScale   = [[UIScreen mainScreen] scale];
                            waterscore.string          = @"0";
                            waterscore.font            = (__bridge CFTypeRef)@"GothamBook";
                            waterscore.fontSize        = 11;
                            waterscore.alignmentMode   = kCAAlignmentCenter;
                            waterscore.foregroundColor = [UIColor blackColor].CGColor;
                            self.layerss[@"waterscore"] = waterscore;
                        }
                        
                        CALayer * energygroup = [CALayer layer];
                        [leed_plaque addSublayer:energygroup];
                        
                        self.layerss[@"energygroup"] = energygroup;
                        {
                            CAShapeLayer * energyback = [CAShapeLayer layer];
                            [energygroup addSublayer:energyback];
                            energyback.fillColor   = nil;
                            energyback.strokeColor = [UIColor colorWithRed:0.196 green: 0.192 blue:0.196 alpha:1].CGColor;
                            energyback.lineWidth   = 4;
                            self.layerss[@"energyback"] = energyback;
                            CATextLayer * energymaxscore = [CATextLayer layer];
                            [energygroup addSublayer:energymaxscore];
                            energymaxscore.contentsScale   = [[UIScreen mainScreen] scale];
                            energymaxscore.string          = [NSString stringWithFormat:@"%d",(int)menergyvaluee];
                            energymaxscore.font            = (__bridge CFTypeRef)@"GothamBook";
                            energymaxscore.fontSize        = 11;
                            energymaxscore.alignmentMode   = kCAAlignmentCenter;
                            energymaxscore.foregroundColor = [UIColor blackColor].CGColor;
                            self.layerss[@"energymaxscore"] = energymaxscore;
                            CAShapeLayer * energystarting = [CAShapeLayer layer];
                            [energygroup addSublayer:energystarting];
                            energystarting.fillColor   = nil;
                            energystarting.strokeColor = [UIColor colorWithRed:0.776 green: 0.859 blue:0.122 alpha:1].CGColor;
                            energystarting.lineWidth   = 4;
                            energystarting.strokeEnd   = 0;
                            self.layerss[@"energystarting"] = energystarting;
                            CAShapeLayer * energystartline = [CAShapeLayer layer];
                            [energygroup addSublayer:energystartline];
                            energystartline.fillColor   = nil;
                            energystartline.strokeColor = [UIColor colorWithRed:0.776 green: 0.859 blue:0.122 alpha:1].CGColor;
                            energystartline.lineWidth   = 4;
                            energystartline.strokeEnd   = 0;
                            self.layerss[@"energystartline"] = energystartline;
                            CAShapeLayer * energystartarrow = [CAShapeLayer layer];
                            [energygroup addSublayer:energystartarrow];
                            [energystartarrow setValue:@(-135 * M_PI/180) forKeyPath:@"transform.rotation"];
                            energystartarrow.fillColor = [UIColor colorWithRed:0.776 green: 0.859 blue:0.122 alpha:1].CGColor;
                            energystartarrow.lineWidth = 0;
                            self.layerss[@"energystartarrow"] = energystartarrow;
                            
                            
                            CATextLayer * energytext = [CATextLayer layer];
                            [energygroup addSublayer:energytext];
                            energytext.contentsScale   = [[UIScreen mainScreen] scale];
                            energytext.string          = @"ENERGY";
                            energytext.font            = (__bridge CFTypeRef)@"GothamBook";
                            energytext.fontSize        = 11;
                            energytext.alignmentMode   = kCAAlignmentLeft;
                            energytext.foregroundColor = [UIColor blackColor].CGColor;
                            self.layerss[@"energytext"] = energytext;
                            CALayer * energy = [CALayer layer];
                            [energygroup addSublayer:energy];
                            energy.contents = (id)[UIImage imageNamed:@"energy"].CGImage;
                            self.layerss[@"energy"] = energy;
                            CAShapeLayer * energyleveler = [CAShapeLayer layer];
                            [energygroup addSublayer:energyleveler];
                            [energyleveler setValue:@(-90 * M_PI/180) forKeyPath:@"transform.rotation"];
                            energyleveler.fillColor   = [UIColor colorWithRed:0.776 green: 0.859 blue:0.122 alpha:1].CGColor;
                            energyleveler.strokeColor = [UIColor colorWithRed:0.776 green: 0.859 blue:0.122 alpha:1].CGColor;
                            energyleveler.lineWidth   = 0;
                            self.layerss[@"energyleveler"] = energyleveler;
                            
                            if(energyvaluee!=menergyvaluee){
                                energyleveler.hidden=YES;
                            }
                            
                            CAShapeLayer * energyarrow = [CAShapeLayer layer];
                            [energygroup addSublayer:energyarrow];
                            [energyarrow setValue:@(-45 * M_PI/180) forKeyPath:@"transform.rotation"];
                            energyarrow.fillColor = [UIColor colorWithRed:0.776 green: 0.859 blue:0.122 alpha:1].CGColor;
                            energyarrow.lineWidth = 0;
                            self.layerss[@"energyarrow"] = energyarrow;
                            CATextLayer * energyscore = [CATextLayer layer];
                            [energygroup addSublayer:energyscore];
                            energyscore.contentsScale   = [[UIScreen mainScreen] scale];
                            energyscore.string          = @"0";
                            energyscore.font            = (__bridge CFTypeRef)@"GothamBook";
                            energyscore.fontSize        = 11;
                            energyscore.alignmentMode   = kCAAlignmentCenter;
                            energyscore.foregroundColor = [UIColor blackColor].CGColor;
                            self.layerss[@"energyscore"] = energyscore;
                            
                            
                            
                            
                        }
                        
                    }
                    
                    CALayer * plaque_coin = [CALayer layer];
                    [dynamic_plaque addSublayer:plaque_coin];
                    //    plaque_coin.hidden=YES;
                    self.layerss[@"plaque_coin"] = plaque_coin;
                    {
                        CALayer * booms = [CALayer layer];
                        [plaque_coin addSublayer:booms];
                        //            booms.hidden=YES;
                        self.layerss[@"booms"] = booms;
                        {
                            CAShapeLayer * energyboom = [CAShapeLayer layer];
                            [booms addSublayer:energyboom];
                            [energyboom setValue:@(-135 * M_PI/180) forKeyPath:@"transform.rotation"];
                            energyboom.fillColor   = nil;
                            energyboom.strokeColor = [UIColor colorWithRed:0.776 green: 0.859 blue:0.122 alpha:1].CGColor;
                            energyboom.strokeStart = 0.8;
                            self.layerss[@"energyboom"] = energyboom;
                            CAShapeLayer * waterboom = [CAShapeLayer layer];
                            [booms addSublayer:waterboom];
                            [waterboom setValue:@(-135 * M_PI/180) forKeyPath:@"transform.rotation"];
                            waterboom.fillColor   = nil;
                            waterboom.strokeColor = [UIColor colorWithRed:0.255 green: 0.678 blue:0.871 alpha:1].CGColor;
                            waterboom.strokeStart = 0.6;
                            waterboom.strokeEnd   = 0.8;
                            self.layerss[@"waterboom"] = waterboom;
                            CAShapeLayer * wasteboom = [CAShapeLayer layer];
                            [booms addSublayer:wasteboom];
                            [wasteboom setValue:@(-135 * M_PI/180) forKeyPath:@"transform.rotation"];
                            wasteboom.fillColor   = nil;
                            wasteboom.strokeColor = [UIColor colorWithRed:0.443 green: 0.769 blue:0.634 alpha:1].CGColor;
                            wasteboom.strokeStart = 0.4;
                            wasteboom.strokeEnd   = 0.6;
                            self.layerss[@"wasteboom"] = wasteboom;
                            CAShapeLayer * transportboom = [CAShapeLayer layer];
                            [booms addSublayer:transportboom];
                            [transportboom setValue:@(-135 * M_PI/180) forKeyPath:@"transform.rotation"];
                            transportboom.fillColor   = nil;
                            transportboom.strokeColor = [UIColor colorWithRed:0.573 green: 0.557 blue:0.498 alpha:1].CGColor;
                            transportboom.strokeStart = 0.2;
                            transportboom.strokeEnd   = 0.4;
                            self.layerss[@"transportboom"] = transportboom;
                            CAShapeLayer * humanboom = [CAShapeLayer layer];
                            [booms addSublayer:humanboom];
                            [humanboom setValue:@(-135 * M_PI/180) forKeyPath:@"transform.rotation"];
                            humanboom.fillColor   = nil;
                            humanboom.strokeColor = [UIColor colorWithRed:0.937 green: 0.62 blue:0.153 alpha:1].CGColor;
                            humanboom.strokeEnd   = 0.2;
                            self.layerss[@"humanboom"] = humanboom;
                            
                            if(transportvaluee==0 && wastevaluee==0 && watervaluee==0 && energyvaluee==0){
                                humanboom.strokeStart=0;
                                humanboom.strokeEnd=1;
                                
                            }
                            else if(humanvaluee==0 && wastevaluee==0 && watervaluee==0 && energyvaluee==0){
                                transportboom.strokeStart=0;
                                transportboom.strokeEnd=1;
                            }
                            else if(humanvaluee==0 && transportvaluee==0 && watervaluee==0 && energyvaluee==0){
                                wasteboom.strokeEnd=1;
                                wasteboom.strokeStart=0;
                            }
                            else if(humanvaluee==0 && wastevaluee==0 && transportvaluee==0 && energyvaluee==0){
                                waterboom.strokeStart=0;
                                waterboom.strokeEnd=1;
                            }
                            else if(humanvaluee==0 && wastevaluee==0 && watervaluee==0 && transportvaluee==0){
                                energyboom.strokeEnd=1;
                                energyboom.strokeStart=0;
                            }
                            else{
                                if(humanvaluee==0){
                                    humanboom.hidden=YES;
                                }
                                if(transportvaluee==0){
                                    transportboom.hidden=YES;
                                }
                                if(wastevaluee==0){
                                    wasteboom.hidden=YES;
                                }
                                if(watervaluee==0){
                                    waterboom.hidden=YES;
                                }
                                if(energyvaluee==0){
                                    energyboom.hidden=YES;
                                }
                                
                                if(humanvaluee>0){
                                    humanboom.strokeStart=0;
                                    humanboom.strokeEnd=humanboom.strokeStart+(humanvaluee/(humanvaluee+transportvaluee+wastevaluee+watervaluee+energyvaluee));
                                    
                                }
                                if(transportvaluee>0){
                                    if(humanvaluee==0){
                                        transportboom.strokeStart=0;
                                    }
                                    else{
                                        transportboom.strokeStart=humanboom.strokeEnd;
                                    }
                                    NSLog(@"Pie %.1f",transportvaluee/(humanvaluee+transportvaluee+wastevaluee+watervaluee+energyvaluee));
                                    
                                    transportboom.strokeEnd=transportboom.strokeStart+(transportvaluee/(humanvaluee+transportvaluee+wastevaluee+watervaluee+energyvaluee));
                                    //                        transportboom.strokeEnd=transportvaluee/(humanvaluee+transportvaluee+wastevaluee+watervaluee+energyvaluee);
                                }
                                if(wastevaluee>0){
                                    if(humanvaluee==0 && transportvaluee==0){
                                        wasteboom.strokeStart=0;
                                    }else if(humanvaluee>0 && transportvaluee==0){
                                        wasteboom.strokeStart=humanboom.strokeEnd;
                                    }
                                    else if(humanvaluee>0 && transportvaluee>0 && wastevaluee>0 && watervaluee==0){
                                        
                                    }
                                    wasteboom.strokeEnd=wasteboom.strokeStart+(wastevaluee/(humanvaluee+transportvaluee+wastevaluee+watervaluee+energyvaluee));
                                }
                                if(watervaluee>0){
                                    if(humanvaluee==0 && transportvaluee==0 && wastevaluee==0){
                                        waterboom.strokeStart=0;
                                    }else{
                                        if(wastevaluee==0 && transportvaluee>0 && humanvaluee>0){
                                            waterboom.strokeStart=transportboom.strokeEnd;
                                        }
                                        else if(wastevaluee==0 && transportvaluee==0 && humanvaluee>0){
                                            waterboom.strokeStart=waterboom.strokeEnd;
                                        }
                                        
                                    }
                                    waterboom.strokeEnd=waterboom.strokeStart+(watervaluee/(humanvaluee+transportvaluee+wastevaluee+watervaluee+energyvaluee));
                                }
                                if(energyvaluee>0){
                                    if(humanvaluee==0 && transportvaluee==0 && wastevaluee==0 && watervaluee==0){
                                        energyboom.strokeStart=0;
                                    }
                                    else if(humanvaluee>0 && transportvaluee>0 && wastevaluee>0 && watervaluee==0){
                                        energyboom.strokeStart=wasteboom.strokeEnd;
                                    }
                                    else if(humanvaluee>0 && transportvaluee>0 && wastevaluee==0 && watervaluee==0){
                                        energyboom.strokeStart=transportboom.strokeEnd;
                                    }
                                    else if(humanvaluee>0 && transportvaluee==0 && wastevaluee==0 && watervaluee==0){
                                        energyboom.strokeStart=humanboom.strokeEnd;
                                    }
                                    
                                    energyboom.strokeStart=waterboom.strokeEnd;
                                    energyboom.strokeEnd=energyboom.strokeStart+(energyvaluee/(humanvaluee+transportvaluee+wastevaluee+watervaluee+energyvaluee));
                                }
                                
                                if(energyvaluee>0 && watervaluee>0 && wastevaluee>0 && transportvaluee>0 && humanvaluee>0){
                                    humanboom.strokeStart=0;
                                    humanboom.strokeEnd=humanboom.strokeStart+(humanvaluee/(humanvaluee+transportvaluee+wastevaluee+watervaluee+energyvaluee));
                                    
                                    transportboom.strokeStart=humanboom.strokeEnd;
                                    transportboom.strokeEnd=transportboom.strokeStart+(transportvaluee/(humanvaluee+transportvaluee+wastevaluee+watervaluee+energyvaluee));
                                    wasteboom.strokeStart=transportboom.strokeEnd;
                                    wasteboom.strokeEnd=wasteboom.strokeStart+(wastevaluee/(humanvaluee+transportvaluee+wastevaluee+watervaluee+energyvaluee));
                                    waterboom.strokeStart=wasteboom.strokeEnd;
                                    waterboom.strokeEnd=waterboom.strokeStart+(watervaluee/(humanvaluee+transportvaluee+wastevaluee+watervaluee+energyvaluee));
                                    energyboom.strokeStart=waterboom.strokeEnd;
                                    energyboom.strokeEnd=energyboom.strokeStart+(energyvaluee/(humanvaluee+transportvaluee+wastevaluee+watervaluee+energyvaluee));
                                }
                            }
                            /*  energyboom.strokeStart=0.8;
                             energyboom.strokeEnd=1;
                             waterboom.strokeEnd=0.8;
                             waterboom.strokeStart=0.6;
                             wasteboom.strokeStart=0.4;
                             wasteboom.strokeEnd=0.6;
                             transportboom.strokeEnd=0.4;
                             transportboom.strokeStart=0.2;
                             humanboom.strokeStart=0;
                             humanboom.strokeEnd=0.2;*/
                            
                            float human,transport,waste,water,energy;
                            if (mhumanvaluee == 0){
                                mhumanvaluee = 20;
                            }
                            
                            if (mtransportvaluee == 0){
                                mtransportvaluee = 14;
                            }
                            
                            if (mwastevaluee == 0){
                                mwastevaluee = 8;
                            }
                            
                            if (mwatervaluee == 0){
                                mwatervaluee = 15;
                            }
                            
                            if (menergyvaluee == 0){
                                menergyvaluee = 33;
                            }
                            
                            human=humanvaluee/mhumanvaluee;
                            transport=transportvaluee/mtransportvaluee;
                            waste=wastevaluee/mwastevaluee;
                            water=watervaluee/mwatervaluee;
                            energy=energyvaluee/menergyvaluee;
                            float totalls=(human+transport+waste+water+energy);
                            humanboom.strokeStart=0;
                            humanboom.strokeEnd=humanboom.strokeStart+(human/totalls);
                            transportboom.strokeStart=humanboom.strokeEnd;
                            transportboom.strokeEnd=transportboom.strokeStart+(transport/totalls);
                            wasteboom.strokeStart=transportboom.strokeEnd;
                            wasteboom.strokeEnd=wasteboom.strokeStart+(waste/totalls);
                            waterboom.strokeStart=wasteboom.strokeEnd;
                            waterboom.strokeEnd=waterboom.strokeStart+(water/totalls);
                            energyboom.strokeStart=waterboom.strokeEnd;
                            energyboom.strokeEnd=energyboom.strokeStart+(energy/totalls);
                            NSLog(@"totall %f %f %f %f %f %f",human,transport,waste,water,energy,totalls);
                            NSLog(@"totall %f %f %f %f %f ",humanboom.strokeEnd,transportboom.strokeEnd,wasteboom.strokeEnd,waterboom.strokeEnd,energyboom.strokeEnd);
                            
                            
                            self.layerss[@"humanboom"] = humanboom;
                        }
                        
                        CALayer * gold = [CALayer layer];
                        [plaque_coin addSublayer:gold];
                        gold.hidden   = YES;
                        gold.contents = (id)[UIImage imageNamed:@"gold"].CGImage;
                        self.layerss[@"gold"] = gold;
                        CALayer * certified = [CALayer layer];
                        [plaque_coin addSublayer:certified];
                        certified.hidden   = YES;
                        certified.contents = (id)[UIImage imageNamed:@"certified"].CGImage;
                        self.layerss[@"certified"] = certified;
                        CALayer * nonleed = [CALayer layer];
                        [plaque_coin addSublayer:nonleed];
                        nonleed.hidden   = YES;
                        nonleed.contents = (id)[UIImage imageNamed:@"nonleed"].CGImage;
                        self.layerss[@"nonleed"] = nonleed;
                        CALayer * platinum = [CALayer layer];
                        [plaque_coin addSublayer:platinum];
                        platinum.contents = (id)[UIImage imageNamed:@"platinum"].CGImage;
                        self.layerss[@"platinum"] = platinum;
                        platinum.hidden=YES;
                        CALayer * silver = [CALayer layer];
                        [plaque_coin addSublayer:silver];
                        silver.contents = (id)[UIImage imageNamed:@"silver"].CGImage;
                        self.layerss[@"silver"] = silver;
                        CALayer * blank = [CALayer layer];
                        [plaque_coin addSublayer:blank];
                        blank.contents = (id)[UIImage imageNamed:@"blank"].CGImage;
                        self.layerss[@"blank"] = blank;
                        blank.hidden=YES;
                        silver.hidden=YES;
                        CALayer * leed = [CALayer layer];
                        [plaque_coin addSublayer:leed];
                        leed.contents = (id)[UIImage imageNamed:@"leed"].CGImage;
                        self.layerss[@"leed"] = leed;
                        totalls=(int)(energyvaluee+basevaluee+watervaluee+wastevaluee+transportvaluee+humanvaluee);
                        NSLog(@"%f %f %f %f %f",(humanvaluee/mhumanvaluee),(transportvaluee/mtransportvaluee),(wastevaluee/mwastevaluee),(watervaluee/mwatervaluee),(energyvaluee/menergyvaluee));
                        platinum.hidden=YES;
                        gold.hidden=YES;
                        silver.hidden=YES;
                        certified.hidden=YES;
                        nonleed.hidden=YES;
                        blank.hidden=YES;
                        if(totalls>=80){
                            platinum.hidden=NO;
                            if(initiall==YES){
                                blank.hidden=NO;
                            }else{
                                blank.hidden=YES;
                            }
                        }else if(totalls>=40 && totalls<=49){
                            certified.hidden=NO;
                        }
                        else if (totalls>=60 && totalls<=79){
                            gold.hidden=NO;
                            if(initiall==YES){
                                blank.hidden=NO;
                            }else{
                                blank.hidden=YES;
                            }
                        }
                        else if(totalls>=50 && totalls<=59){
                            silver.hidden=NO;
                            if(initiall==YES){
                                blank.hidden=NO;
                            }else{
                                blank.hidden=YES;
                            }
                        }
                        else if(totalls<=40 && totalls>0){
                            blank.hidden=NO;
                            
                        }
                        else{
                            blank.hidden=YES;
                            leed.hidden=YES;
                            booms.hidden=YES;
                            nonleed.hidden=NO;
                            mhumanvaluee=mtransportvaluee=mwastevaluee=mwatervaluee=menergyvaluee=1;
                        }
                        
                        
                        CATextLayer * stepscore = [CATextLayer layer];
                        [plaque_coin addSublayer:stepscore];
                        stepscore.contentsScale   = [[UIScreen mainScreen] scale];
                        stepscore.string          = [NSString stringWithFormat:@"%d",(int)basevaluee];
                        stepscore.font            = (__bridge CFTypeRef)@"DINCondensed-Bold";
                        stepscore.fontSize        = 110;
                        stepscore.alignmentMode   = kCAAlignmentCenter;
                        stepscore.foregroundColor = [UIColor whiteColor].CGColor;
                        self.layerss[@"stepscore"] = stepscore;
                        CATextLayer * maxscore = [CATextLayer layer];
                        [plaque_coin addSublayer:maxscore];
                        maxscore.contentsScale   = [[UIScreen mainScreen] scale];
                        maxscore.string          = [NSString stringWithFormat:@"%d",(int)(energyvaluee+basevaluee+watervaluee+wastevaluee+transportvaluee+humanvaluee)];
                        maxscore.font            = (__bridge CFTypeRef)@"DINCondensed-Bold";
                        maxscore.fontSize        = 10;
                        maxscore.opacity=0;
                        NSLog(@"fsize %f",maxscore.fontSize);
                        maxscore.alignmentMode   = kCAAlignmentCenter;
                        maxscore.foregroundColor = [UIColor whiteColor].CGColor;
                        self.layerss[@"maxscore"] = maxscore;
                    }
                    
                }
                self.hidden=YES;
                width1=[[UIScreen mainScreen] bounds].size.width;
                height1=[[UIScreen mainScreen] bounds].size.height;
                [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deviceOrientationDidChangeNotification:) name:UIDeviceOrientationDidChangeNotification object:nil];
                
                [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(suspendit) name:UIApplicationWillResignActiveNotification object:nil];
                [self setupLayerFrames];
                    self.hidden=YES;
                    starterr=[NSTimer scheduledTimerWithTimeInterval:(0.4) target:self selector:@selector(avoidflick) userInfo:nil repeats:NO];
                    lastorientationn=@"portrait";
                    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                        self.frame=CGRectMake(0,0.15*height1, ww,ww);
                        
                    }else{
                        self.frame=CGRectMake(0*width1,0.2*height1, 1*width1, 1*width1);
                    }
                    [self adjustlinewidth];
                    if(loadedd==NO){
                        loadedd=YES;
                        initiall=YES;
                        [timer1 invalidate];
                        if(            [timer1 isValid]){
                            NSLog(@"Timer started");
                        }
                        
                        [self removeAllAnimations];
                        if(initiall==YES){
                            displayLinkk = [CADisplayLink displayLinkWithTarget:self
                                                                       selector:@selector(tick:)];
                            [displayLinkk addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
                        }
                    }
            });
        }else if([httpResponse statusCode] == 404){
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView  *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"The LEED ID you've entered is invalid. Please try using different LEED ID" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            });
        }else if([httpResponse statusCode] == 400){
            NSLog(@"%d",[httpResponse statusCode]);
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView  *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"The LEED ID you've entered is not public." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            });
        }else if([httpResponse statusCode] == 401){
            dispatch_async(dispatch_get_main_queue(), ^{
                
            });
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView  *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Device in offline. Please try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            });
        }
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView  *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Device in offline. Please try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        });
    }
    
    
}


-(void)suspendit{
    [timer1 invalidate];
    [timer2 invalidate];
    [timer3 invalidate];
    [starterr invalidate];
    [startupp invalidate];
    timer1=nil;
    timer2=nil;
    timer3=nil;
    starterr=nil;
    startupp=nil;
    suspenderr=nil;
    
    [self removeAllAnimations];
    loadedd=NO;
    CATextLayer *t=self.layerss[@"stepscore"];
    NSLog(@"base string %@",t.string);
    t.string=[NSString stringWithFormat:@"%d",(int)basevaluee];
    initiall=YES;
    [displayLinkk invalidate];
    displayLinkk=nil;
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(continueagain)
                                                name:UIApplicationDidBecomeActiveNotification
                                              object:nil];
    exit(0);
}

-(void)timerclearer{
    
    //    [self performSelectorInBackground:@selector(suspendit) withObject:nil];
    [self performSelectorOnMainThread:@selector(suspendit) withObject:nil waitUntilDone:YES];
    
    
}

-(void)continueagain{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIDeviceOrientationDidChangeNotification
                                                  object:nil];
    
    [suspenderr invalidate];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deviceOrientationDidChangeNotification:) name:UIDeviceOrientationDidChangeNotification object:nil];
    [self adjustlinewidth];
    if(loadedd==NO){
        loadedd=YES;
        initiall=YES;
        [timer1 invalidate];
        if(            [timer1 isValid]){
            NSLog(@"Timer started");
        }
        
        [self removeAllAnimations];
        if(initiall==YES){
            displayLinkk = [CADisplayLink displayLinkWithTarget:self
                                                       selector:@selector(tick:)];
            [displayLinkk addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        }
    }
    
}


-(void)sum1{
    nu1=humanvaluee;
    CATextLayer *t=self.layerss[@"stepscore"];
    nu2+=[t.string intValue];
    CATextLayer *humanscore=self.layerss[@"humanscore"];
    humanscore.string=@"0";
    actualtxt=0;
    tmp=0;
    if(nu1>(0.25*(int)mhumanvaluee)){
        timer3=[NSTimer scheduledTimerWithTimeInterval:(1.0/(0.7*nu1)) target:self selector:@selector(incrementer1) userInfo:nil repeats:YES];
    }
    else{
        timer3=[NSTimer scheduledTimerWithTimeInterval:(0.7/(0.7*nu1)) target:self selector:@selector(final1) userInfo:nil repeats:YES];
    }
    
}

-(void)final1{
    if(tmp<round(nu1)){
        tmp++;
        CATextLayer *t=self.layerss[@"stepscore"];
        int m=[t.string intValue];
        m++;
        t.string=[NSString stringWithFormat:@"%d",m];
        CATextLayer *humanscore=self.layerss[@"humanscore"];
        actualtxt++;
        humanscore.string=[NSString stringWithFormat:@"%d",actualtxt];
    }
    else{
        [timer3 invalidate];
    }
}

-(void)final3{
    if(tmp<round(nu1)){
        tmp++;
        CATextLayer *t=self.layerss[@"stepscore"];
        int m=[t.string intValue];
        m++;
        t.string=[NSString stringWithFormat:@"%d",m];
        CATextLayer *wastescore=self.layerss[@"wastescore"];
        actualtxt++;
        wastescore.string=[NSString stringWithFormat:@"%d",actualtxt];
    }
    else{
        [timer3 invalidate];
    }
}

-(void)final4{
    if(tmp<round(nu1)){
        tmp++;
        CATextLayer *t=self.layerss[@"stepscore"];
        int m=[t.string intValue];
        m++;
        t.string=[NSString stringWithFormat:@"%d",m];
        CATextLayer *waterscore=self.layerss[@"waterscore"];
        actualtxt++;
        waterscore.string=[NSString stringWithFormat:@"%d",actualtxt];
    }
    else{
        [timer3 invalidate];
    }
}

-(void)final5{
    if(tmp<round(nu1)){
        tmp++;
        CATextLayer *t=self.layerss[@"stepscore"];
        int m=[t.string intValue];
        m++;
        t.string=[NSString stringWithFormat:@"%d",m];
        CATextLayer *energyscore=self.layerss[@"energyscore"];
        actualtxt++;
        energyscore.string=[NSString stringWithFormat:@"%d",actualtxt];
    }
    else{
        [timer3 invalidate];
    }
}


-(void)incrementer1{
    if(tmp<round(0.6*nu1)){
        tmp++;
        CATextLayer *t=self.layerss[@"stepscore"];
        int m=[t.string intValue];
        m++;
        t.string=[NSString stringWithFormat:@"%d",m];
        CATextLayer *humanscore=self.layerss[@"humanscore"];
        actualtxt++;
        humanscore.string=[NSString stringWithFormat:@"%d",actualtxt];
        
    }
    else{
        [timer3 invalidate];
        timer3=[NSTimer scheduledTimerWithTimeInterval:(1.0/(0.25*nu1)) target:self selector:@selector(incrementers1) userInfo:nil repeats:YES];
        tmp=0;
    }
}

-(void)incrementers1{
    if(tmp<round(0.4*nu1)){
        tmp++;
        CATextLayer *t=self.layerss[@"stepscore"];
        int m=[t.string intValue];
        m++;
        t.string=[NSString stringWithFormat:@"%d",m];
        CATextLayer *humanscore=self.layerss[@"humanscore"];
        actualtxt++;
        humanscore.string=[NSString stringWithFormat:@"%d",actualtxt];
    }
    else{
        [timer3 invalidate];
    }
}

-(void)sum2{
    nu1=transportvaluee;
    CATextLayer *t=self.layerss[@"stepscore"];
    nu2+=[t.string intValue];
    CATextLayer *transportscore=self.layerss[@"transportscore"];
    transportscore.string=@"0";
    actualtxt=0;
    tmp=0;
    if(nu1>0.25*(int)mtransportvaluee){
        timer3=[NSTimer scheduledTimerWithTimeInterval:(1.0/(0.7*nu1)) target:self selector:@selector(incrementer2) userInfo:nil repeats:YES];
    }
    else{
        timer3=[NSTimer scheduledTimerWithTimeInterval:(0.7/(0.7*nu1)) target:self selector:@selector(final2) userInfo:nil repeats:YES];
    }
    
}

-(void)final2{
    if(tmp<round(nu1)){
        tmp++;
        CATextLayer *t=self.layerss[@"stepscore"];
        int m=[t.string intValue];
        m++;
        t.string=[NSString stringWithFormat:@"%d",m];
        CATextLayer *transportscore=self.layerss[@"transportscore"];
        actualtxt++;
        transportscore.string=[NSString stringWithFormat:@"%d",actualtxt];
    }
    else{
        [timer3 invalidate];
    }
}

-(void)incrementer2{
    if(tmp<round(0.6*nu1)){
        tmp++;
        CATextLayer *t=self.layerss[@"stepscore"];
        int m=[t.string intValue];
        m++;
        t.string=[NSString stringWithFormat:@"%d",m];
        CATextLayer *transportscore=self.layerss[@"transportscore"];
        actualtxt++;
        transportscore.string=[NSString stringWithFormat:@"%d",actualtxt];
        
    }
    else{
        [timer3 invalidate];
        timer3=[NSTimer scheduledTimerWithTimeInterval:(1.0/(0.25*nu1)) target:self selector:@selector(incrementers2) userInfo:nil repeats:YES];
        tmp=0;
    }
}

-(void)incrementers2{
    if(tmp<round(0.4*nu1)){
        tmp++;
        CATextLayer *t=self.layerss[@"stepscore"];
        int m=[t.string intValue];
        m++;
        t.string=[NSString stringWithFormat:@"%d",m];
        CATextLayer *transportscore=self.layerss[@"transportscore"];
        actualtxt++;
        transportscore.string=[NSString stringWithFormat:@"%d",actualtxt];
    }
    else{
        [timer3 invalidate];
    }
}


-(void)sum3{
    nu1=wastevaluee;
    CATextLayer *t=self.layerss[@"stepscore"];
    nu2+=[t.string intValue];
    CATextLayer *wastescore=self.layerss[@"wastescore"];
    wastescore.string=@"0";
    actualtxt=0;
    tmp=0;
    if(nu1>0.25*(int)mwastevaluee){
        timer3=[NSTimer scheduledTimerWithTimeInterval:(1.0/(0.7*nu1)) target:self selector:@selector(incrementer3) userInfo:nil repeats:YES];
    }
    else{
        timer3=[NSTimer scheduledTimerWithTimeInterval:(0.7/(0.7*nu1)) target:self selector:@selector(final3) userInfo:nil repeats:YES];
    }
    
}


-(void)incrementer3{
    if(tmp<round(0.6*nu1)){
        tmp++;
        CATextLayer *t=self.layerss[@"stepscore"];
        int m=[t.string intValue];
        m++;
        t.string=[NSString stringWithFormat:@"%d",m];
        CATextLayer *wastescore=self.layerss[@"wastescore"];
        actualtxt++;
        wastescore.string=[NSString stringWithFormat:@"%d",actualtxt];
        
    }
    else{
        [timer3 invalidate];
        timer3=[NSTimer scheduledTimerWithTimeInterval:(1.0/(0.25*nu1)) target:self selector:@selector(incrementers3) userInfo:nil repeats:YES];
        tmp=0;
    }
}

-(void)incrementers3{
    if(tmp<round(0.4*nu1)){
        tmp++;
        CATextLayer *t=self.layerss[@"stepscore"];
        int m=[t.string intValue];
        m++;
        t.string=[NSString stringWithFormat:@"%d",m];
        CATextLayer *wastescore=self.layerss[@"wastescore"];
        actualtxt++;
        wastescore.string=[NSString stringWithFormat:@"%d",actualtxt];
    }
    else{
        [timer3 invalidate];
    }
}



-(void)sum4{
    nu1=watervaluee;
    CATextLayer *t=self.layerss[@"stepscore"];
    nu2+=[t.string intValue];
    CATextLayer *waterscore=self.layerss[@"waterscore"];
    waterscore.string=@"0";
    actualtxt=0;
    tmp=0;
    if(nu1>0.25*(int)mwatervaluee){
        timer3=[NSTimer scheduledTimerWithTimeInterval:(1.0/(0.7*nu1)) target:self selector:@selector(incrementer4) userInfo:nil repeats:YES];
    }else{
        timer3=[NSTimer scheduledTimerWithTimeInterval:(0.7/(0.7*nu1)) target:self selector:@selector(final4) userInfo:nil repeats:YES];
    }
    
}


-(void)incrementer4{
    if(tmp<round(0.6*nu1)){
        tmp++;
        CATextLayer *t=self.layerss[@"stepscore"];
        int m=[t.string intValue];
        m++;
        t.string=[NSString stringWithFormat:@"%d",m];
        CATextLayer *waterscore=self.layerss[@"waterscore"];
        actualtxt++;
        waterscore.string=[NSString stringWithFormat:@"%d",actualtxt];
        
    }
    else{
        [timer3 invalidate];
        timer3=[NSTimer scheduledTimerWithTimeInterval:(1.0/(0.25*nu1)) target:self selector:@selector(incrementers4) userInfo:nil repeats:YES];
        tmp=0;
    }
}

-(void)incrementers4{
    if(tmp<round(0.4*nu1)){
        tmp++;
        CATextLayer *t=self.layerss[@"stepscore"];
        int m=[t.string intValue];
        m++;
        t.string=[NSString stringWithFormat:@"%d",m];
        CATextLayer *waterscore=self.layerss[@"waterscore"];
        actualtxt++;
        waterscore.string=[NSString stringWithFormat:@"%d",actualtxt];
    }
    else{
        [timer3 invalidate];
    }
}



-(void)sum5{
    nu1=energyvaluee;
    CATextLayer *t=self.layerss[@"stepscore"];
    nu2+=[t.string intValue];
    CATextLayer *energyscore=self.layerss[@"energyscore"];
    energyscore.string=@"0";
    actualtxt=0;
    tmp=0;
    if(nu1>0.25*(int)menergyvaluee){
        timer3=[NSTimer scheduledTimerWithTimeInterval:(1.0/(0.7*nu1)) target:self selector:@selector(incrementer5) userInfo:nil repeats:YES];
    }else{
        timer3=[NSTimer scheduledTimerWithTimeInterval:(0.7/(0.7*nu1)) target:self selector:@selector(final5) userInfo:nil repeats:YES];
    }
    
}


-(void)incrementer5{
    if(tmp<round(0.6*nu1)){
        tmp++;
        CATextLayer *t=self.layerss[@"stepscore"];
        int m=[t.string intValue];
        m++;
        t.string=[NSString stringWithFormat:@"%d",m];
        CATextLayer *energyscore=self.layerss[@"energyscore"];
        actualtxt++;
        energyscore.string=[NSString stringWithFormat:@"%d",actualtxt];
        
    }
    else{
        [timer3 invalidate];
        timer3=[NSTimer scheduledTimerWithTimeInterval:(1.0/(0.25*nu1)) target:self selector:@selector(incrementers5) userInfo:nil repeats:YES];
        tmp=0;
    }
}

-(void)incrementers5{
    if(tmp<round(0.4*nu1)){
        tmp++;
        CATextLayer *t=self.layerss[@"stepscore"];
        int m=[t.string intValue];
        m++;
        t.string=[NSString stringWithFormat:@"%d",m];
        CATextLayer *energyscore=self.layerss[@"energyscore"];
        actualtxt++;
        energyscore.string=[NSString stringWithFormat:@"%d",actualtxt];
    }
    else{
        [timer3 invalidate];
    }
}


- (void)setupLayerFrames{
    [CATransaction begin];
    [CATransaction setDisableActions:NO];
    
    
    
    
    CALayer * dynamic_plaque          = self.layerss[@"dynamic_plaque"];
    dynamic_plaque.frame              = CGRectMake(0.07003 * CGRectGetWidth(dynamic_plaque.superlayer.bounds), 0.06994 * CGRectGetHeight(dynamic_plaque.superlayer.bounds), 0.86 * CGRectGetWidth(dynamic_plaque.superlayer.bounds), 0.86 * CGRectGetHeight(dynamic_plaque.superlayer.bounds));
    
    CALayer * leed_plaque             = self.layerss[@"leed_plaque"];
    leed_plaque.frame                 = CGRectMake(0.06202 * CGRectGetWidth(leed_plaque.superlayer.bounds), 0.07936 * CGRectGetHeight(leed_plaque.superlayer.bounds), 0.84492 * CGRectGetWidth(leed_plaque.superlayer.bounds), 0.82769 * CGRectGetHeight(leed_plaque.superlayer.bounds));
    
    CALayer * transportgroup          = self.layerss[@"transportgroup"];
    transportgroup.frame              = CGRectMake(0.01376 * CGRectGetWidth(transportgroup.superlayer.bounds), 0.15761 * CGRectGetHeight(transportgroup.superlayer.bounds), 0.36415 * CGRectGetWidth(transportgroup.superlayer.bounds), 0.4733 * CGRectGetHeight(transportgroup.superlayer.bounds));
    
    CATextLayer * transportmaxscore   = self.layerss[@"transportmaxscore"];
    transportmaxscore.frame           = CGRectMake(0.57416 * CGRectGetWidth(transportmaxscore.superlayer.bounds), 0.44907 * CGRectGetHeight(transportmaxscore.superlayer.bounds), 0.11338 * CGRectGetWidth(transportmaxscore.superlayer.bounds), 0.05338 * CGRectGetHeight(transportmaxscore.superlayer.bounds));
    
    CATextLayer * transporttext       = self.layerss[@"transporttext"];
    transporttext.frame               = CGRectMake(0.13845 * CGRectGetWidth(transporttext.superlayer.bounds), 0.11814 * CGRectGetHeight(transporttext.superlayer.bounds), 0.56689 * CGRectGetWidth(transporttext.superlayer.bounds), 0.07011 * CGRectGetHeight(transporttext.superlayer.bounds));
    
    CALayer * transport               = self.layerss[@"transport"];
    transport.frame                   = CGRectMake(0, 0.11117 * CGRectGetHeight(transport.superlayer.bounds), 0.10618 * CGRectGetWidth(transport.superlayer.bounds), 0.06936 * CGRectGetHeight(transport.superlayer.bounds));
    
    
    
    
    CAShapeLayer * transportstarting = self.layerss[@"transportstarting"];
    
    CATextLayer * transportscore      = self.layerss[@"transportscore"];
    transportscore.frame              = CGRectMake(0.88662 * CGRectGetWidth(transportscore.superlayer.bounds), 0.90808 * CGRectGetHeight(transportscore.superlayer.bounds), 0.11338 * CGRectGetWidth(transportscore.superlayer.bounds), 0.05338 * CGRectGetHeight(transportscore.superlayer.bounds));
    
    CAShapeLayer * transportback      = self.layerss[@"transportback"];
    transportback.frame               = CGRectMake(-0.02885 * CGRectGetWidth(transportback.superlayer.bounds), 0.1449 * CGRectGetHeight(transportback.superlayer.bounds), 2.1703 * CGRectGetWidth(transportback.superlayer.bounds), 1.18969 * CGRectGetHeight(transportback.superlayer.bounds));
    transportback.path                = [self transportbackPathWithBounds:[self.layerss[@"transportback"] bounds]].CGPath;
    
    //xuv
    
    transportstarting.frame           = CGRectMake(0.62975 * CGRectGetWidth(transportstarting.superlayer.bounds), 0.14729 * CGRectGetHeight(transportstarting.superlayer.bounds), 1.51171 * CGRectGetWidth(transportstarting.superlayer.bounds), 1.1873 * CGRectGetHeight(transportstarting.superlayer.bounds));
    transportstarting.path            = [self transportstartingPathWithBounds:[self.layerss[@"transportstarting"] bounds]].CGPath;
    self.layerss[@"transportstarting"]=transportstarting;
    
    CAShapeLayer * transportarrow     = self.layerss[@"transportarrow"];
    transportarrow.transform          = CATransform3DIdentity;
    transportarrow.frame              = CGRectMake(0.95975 * CGRectGetWidth(transportstarting.superlayer.bounds), 0.10729 * CGRectGetHeight(transportstarting.superlayer.bounds), 0.11038 * CGRectGetWidth(transportarrow.superlayer.bounds), 0.08905 * CGRectGetHeight(transportarrow.superlayer.bounds));
    [transportarrow setValue:@(-45 * M_PI/180) forKeyPath:@"transform.rotation"];
    transportarrow.path               = [self transportarrowPathWithBounds:[self.layerss[@"transportarrow"] bounds]].CGPath;
    
    CAShapeLayer * transportstartarrow = self.layerss[@"transportstartarrow"];
    transportstartarrow.transform      = CATransform3DIdentity;
    transportstartarrow.frame          = CGRectMake(0.0 * CGRectGetWidth(transportstarting.superlayer.bounds), 0.10729 * CGRectGetHeight(transportstarting.superlayer.bounds), 0.11038 * CGRectGetWidth(transportarrow.superlayer.bounds), 0.08905 * CGRectGetHeight(transportarrow.superlayer.bounds));
    [transportstartarrow setValue:@(-45 * M_PI/180) forKeyPath:@"transform.rotation"];
    transportstartarrow.path           = [self transportarrowPathWithBounds:[self.layerss[@"transportarrow"] bounds]].CGPath;
    
    
    CAShapeLayer * transportstartline = self.layerss[@"transportstartline"];
    transportstartline.frame          = CGRectMake(-0.02273 * CGRectGetWidth(transportstartline.superlayer.bounds), 0.14729 * CGRectGetHeight(transportstartline.superlayer.bounds), 1.43634 * CGRectGetWidth(transportstartline.superlayer.bounds), 0.0019 * CGRectGetHeight(transportstartline.superlayer.bounds));
    transportstartline.path           = [self transportstartlinePathWithBounds:[self.layerss[@"transportstartline"] bounds]].CGPath;
    
    CALayer * wastegroup              = self.layerss[@"wastegroup"];
    wastegroup.frame                  = CGRectMake(0.00275 * CGRectGetWidth(wastegroup.superlayer.bounds), 0.13769 * CGRectGetHeight(wastegroup.superlayer.bounds), 0.85963 * CGRectGetWidth(wastegroup.superlayer.bounds), 0.72182 * CGRectGetHeight(wastegroup.superlayer.bounds));
    
    CAShapeLayer * wasteback          = self.layerss[@"wasteback"];
    wasteback.frame                   = CGRectMake(0, 0.02598 * CGRectGetHeight(wasteback.superlayer.bounds),  CGRectGetWidth(wasteback.superlayer.bounds), 0.97402 * CGRectGetHeight(wasteback.superlayer.bounds));
    wasteback.path                    = [self wastebackPathWithBounds:[self.layerss[@"wasteback"] bounds]].CGPath;
    
    CAShapeLayer * wastestarting      = self.layerss[@"wastestarting"];
    wastestarting.frame               = CGRectMake(0.19953 * CGRectGetWidth(wastestarting.superlayer.bounds), 0.02686 * CGRectGetHeight(wastestarting.superlayer.bounds), 0.80047 * CGRectGetWidth(wastestarting.superlayer.bounds), 0.97314 * CGRectGetHeight(wastestarting.superlayer.bounds));
    wastestarting.path                = [self wastestartingPathWithBounds:[self.layerss[@"wastestarting"] bounds]].CGPath;
    
    CAShapeLayer * wastestartline     = self.layerss[@"wastestartline"];
    wastestartline.frame              = CGRectMake(0.00401 * CGRectGetWidth(wastestartline.superlayer.bounds), 0.02686 * CGRectGetHeight(wastestartline.superlayer.bounds), 0.60807 * CGRectGetWidth(wastestartline.superlayer.bounds), 0.00129 * CGRectGetHeight(wastestartline.superlayer.bounds));
    wastestartline.path               = [self wastestartlinePathWithBounds:[self.layerss[@"wastestartline"] bounds]].CGPath;
    
    CATextLayer * wastemaxscore       = self.layerss[@"wastemaxscore"];
    wastemaxscore.frame               = CGRectMake(0.14751 * CGRectGetWidth(wastemaxscore.superlayer.bounds), 0.32200 * CGRectGetHeight(wastemaxscore.superlayer.bounds),0.11338 * CGRectGetWidth(wastemaxscore.superlayer.bounds), 0.05338 * CGRectGetHeight(wastemaxscore.superlayer.bounds));
    
    CALayer * waste                   = self.layerss[@"waste"];
    waste.frame                       = CGRectMake(0.01081 * CGRectGetWidth(waste.superlayer.bounds), 0, 0.04951 * CGRectGetWidth(waste.superlayer.bounds), 0.05839 * CGRectGetHeight(waste.superlayer.bounds));
    
    
    CAShapeLayer * wasteleveler       = self.layerss[@"wasteleveler"];
    wasteleveler.transform            = CATransform3DIdentity;
    wasteleveler.frame                = CGRectMake(0.40907 * CGRectGetWidth(wasteleveler.superlayer.bounds), 0.0090*CGRectGetHeight(wasteleveler.superlayer.bounds), 0.06145 * CGRectGetWidth(wasteleveler.superlayer.bounds), 0.03681 * CGRectGetHeight(wasteleveler.superlayer.bounds));
    [wasteleveler setValue:@(-90 * M_PI/180) forKeyPath:@"transform.rotation"];
    wasteleveler.path                 = [self wastelevelerPathWithBounds:[self.layerss[@"wasteleveler"] bounds]].CGPath;
    
    CAShapeLayer * transportleveler   = self.layerss[@"transportleveler"];
    transportleveler.transform        = CATransform3DIdentity;
    transportleveler.frame            = CGRectMake(0.44548 * CGRectGetWidth(transportleveler.superlayer.bounds), 0.0782*CGRectGetHeight(wasteleveler.superlayer.bounds), 0.06145 * CGRectGetWidth(wasteleveler.superlayer.bounds), 0.03681 * CGRectGetHeight(wasteleveler.superlayer.bounds));
    [transportleveler setValue:@(-90 * M_PI/180) forKeyPath:@"transform.rotation"];
    transportleveler.path             = [self transportlevelerPathWithBounds:[self.layerss[@"transportleveler"] bounds]].CGPath;
    
    
    CAShapeLayer * wastearrow         = self.layerss[@"wastearrow"];
    wastearrow.transform              = CATransform3DIdentity;
    wastearrow.frame                  = CGRectMake(0.41463 * CGRectGetWidth(wastearrow.superlayer.bounds), 0.00552 * CGRectGetHeight(wastearrow.superlayer.bounds), 0.04503 * CGRectGetWidth(wastearrow.superlayer.bounds), 0.05839 * CGRectGetHeight(wastearrow.superlayer.bounds));
    [wastearrow setValue:@(-45 * M_PI/180) forKeyPath:@"transform.rotation"];
    wastearrow.path                   = [self wastearrowPathWithBounds:[self.layerss[@"wastearrow"] bounds]].CGPath;
    
    
    CAShapeLayer * wastestartarrow     = self.layerss[@"wastestartarrow"];
    wastestartarrow.transform          = CATransform3DIdentity;
    wastestartarrow.frame              = CGRectMake(0.0 * CGRectGetWidth(wastearrow.superlayer.bounds), 0.00552 * CGRectGetHeight(wastearrow.superlayer.bounds), 0.04503 * CGRectGetWidth(wastearrow.superlayer.bounds), 0.05839 * CGRectGetHeight(wastearrow.superlayer.bounds));
    [wastestartarrow setValue:@(-45 * M_PI/180) forKeyPath:@"transform.rotation"];
    wastestartarrow.path               = [self wastearrowPathWithBounds:[self.layerss[@"wastearrow"] bounds]].CGPath;
    
    
    CATextLayer * wastescore          = self.layerss[@"wastescore"];
    wastescore.frame                  = CGRectMake(0.38839 * CGRectGetWidth(wastescore.superlayer.bounds), 0.62302 * CGRectGetHeight(wastescore.superlayer.bounds), 0.11338 * CGRectGetWidth(wastescore.superlayer.bounds), 0.03338 * CGRectGetHeight(wastescore.superlayer.bounds));
    
    CATextLayer * wastetext           = self.layerss[@"wastetext"];
    wastetext.frame                   = CGRectMake(0.07145 * CGRectGetWidth(wastetext.superlayer.bounds), 0.01387 * CGRectGetHeight(wastetext.superlayer.bounds), 0.24014 * CGRectGetWidth(wastetext.superlayer.bounds), 0.04597 * CGRectGetHeight(wastetext.superlayer.bounds));
    
    CALayer * humangroup              = self.layerss[@"humangroup"];
    humangroup.frame                  = CGRectMake(0.00338 * CGRectGetWidth(humangroup.superlayer.bounds), 0.2717 * CGRectGetHeight(humangroup.superlayer.bounds), 0.72138 * CGRectGetWidth(humangroup.superlayer.bounds), 0.44732 * CGRectGetHeight(humangroup.superlayer.bounds));
    
    CAShapeLayer * humanback          = self.layerss[@"humanback"];
    humanback.frame                   = CGRectMake(0, 0.05982 * CGRectGetHeight(humanback.superlayer.bounds),  CGRectGetWidth(humanback.superlayer.bounds), 0.94018 * CGRectGetHeight(humanback.superlayer.bounds));
    humanback.path                    = [self humanbackPathWithBounds:[self.layerss[@"humanback"] bounds]].CGPath;
    
    CAShapeLayer * humanstarting      = self.layerss[@"humanstarting"];
    humanstarting.frame               = CGRectMake(0.42768 * CGRectGetWidth(humanstarting.superlayer.bounds), 0.05782 * CGRectGetHeight(humanstarting.superlayer.bounds), 0.57232 * CGRectGetWidth(humanstarting.superlayer.bounds), 0.94218 * CGRectGetHeight(humanstarting.superlayer.bounds));
    humanstarting.path                = [self humanstartingPathWithBounds:[self.layerss[@"humanstarting"] bounds]].CGPath;
    
    CAShapeLayer * humanstartline     = self.layerss[@"humanstartline"];
    humanstartline.frame              = CGRectMake(0.00238 * CGRectGetWidth(humanstartline.superlayer.bounds), 0.05782 * CGRectGetHeight(humanstartline.superlayer.bounds), 0.7261 * CGRectGetWidth(humanstartline.superlayer.bounds), 0.00753 * CGRectGetHeight(humanstartline.superlayer.bounds));
    humanstartline.path               = [self humanstartlinePathWithBounds:[self.layerss[@"humanstartline"] bounds]].CGPath;
    
    CATextLayer * humanmaxscore       = self.layerss[@"humanmaxscore"];
    humanmaxscore.frame               = CGRectMake(0.36952 * CGRectGetWidth(humanmaxscore.superlayer.bounds), 0.21607 * CGRectGetHeight(humanmaxscore.superlayer.bounds), 0.11338 * CGRectGetWidth(humanmaxscore.superlayer.bounds), 0.05338 * CGRectGetHeight(humanmaxscore.superlayer.bounds));
    
    CATextLayer * humantext           = self.layerss[@"humantext"];
    humantext.frame                   = CGRectMake(0.08428 * CGRectGetWidth(humantext.superlayer.bounds), 0.03472 * CGRectGetHeight(humantext.superlayer.bounds), 0.43878 * CGRectGetWidth(humantext.superlayer.bounds), 0.07418 * CGRectGetHeight(humantext.superlayer.bounds));
    
    CALayer * human                   = self.layerss[@"human"];
    human.frame                       = CGRectMake(0.02705 * CGRectGetWidth(human.superlayer.bounds), 0.01824 * CGRectGetHeight(human.superlayer.bounds), 0.02623 * CGRectGetWidth(human.superlayer.bounds), 0.09422 * CGRectGetHeight(human.superlayer.bounds));
    
    CAShapeLayer * humanleveler       = self.layerss[@"humanleveler"];
    humanleveler.transform            = CATransform3DIdentity;
    humanleveler.frame                = CGRectMake(0.44548 * CGRectGetWidth(transportleveler.superlayer.bounds), 0.018*CGRectGetHeight(wasteleveler.superlayer.bounds), 0.06145 * CGRectGetWidth(wasteleveler.superlayer.bounds), 0.03681 * CGRectGetHeight(wasteleveler.superlayer.bounds));
    [humanleveler setValue:@(-90 * M_PI/180) forKeyPath:@"transform.rotation"];
    humanleveler.path                 = [self humanlevelerPathWithBounds:[self.layerss[@"humanleveler"] bounds]].CGPath;
    
    CAShapeLayer * humanarrow         = self.layerss[@"humanarrow"];
    humanarrow.transform              = CATransform3DIdentity;
    humanarrow.frame                  =CGRectMake(0.50513 * CGRectGetWidth(humanarrow.superlayer.bounds), 0.009* CGRectGetWidth(humanarrow.superlayer.bounds), 0.04503 * CGRectGetWidth(wastearrow.superlayer.bounds), 0.05839 * CGRectGetHeight(wastearrow.superlayer.bounds));
    [humanarrow setValue:@(-45 * M_PI/180) forKeyPath:@"transform.rotation"];
    humanarrow.path                   = [self wastearrowPathWithBounds:[self.layerss[@"wastearrow"] bounds]].CGPath;
    
    CAShapeLayer * humanstartarrow    = self.layerss[@"humanstartarrow"];
    humanstartarrow.transform         = CATransform3DIdentity;
    humanstartarrow.frame             = CGRectMake(0.00* CGRectGetWidth(humanarrow.superlayer.bounds), 0.009* CGRectGetWidth(humanarrow.superlayer.bounds), 0.04503 * CGRectGetWidth(wastearrow.superlayer.bounds), 0.05839 * CGRectGetHeight(wastearrow.superlayer.bounds));
    [humanstartarrow setValue:@(-45 * M_PI/180) forKeyPath:@"transform.rotation"];
    humanstartarrow.path              = [self humanarrowPathWithBounds:[self.layerss[@"humanarrow"] bounds]].CGPath;
    
    CATextLayer * humanscore          = self.layerss[@"humanscore"];
    humanscore.frame                  = CGRectMake(0.46196 * CGRectGetWidth(humanscore.superlayer.bounds), 0.70575 * CGRectGetHeight(humanscore.superlayer.bounds), 0.11338 * CGRectGetWidth(humanscore.superlayer.bounds), 0.05338 * CGRectGetHeight(humanscore.superlayer.bounds));
    
    CALayer * watergroup              = self.layerss[@"watergroup"];
    watergroup.frame                  = CGRectMake(0.00103 * CGRectGetWidth(watergroup.superlayer.bounds), 0.06745 * CGRectGetHeight(watergroup.superlayer.bounds), 0.93016 * CGRectGetWidth(watergroup.superlayer.bounds), 0.86231 * CGRectGetHeight(watergroup.superlayer.bounds));
    
    CAShapeLayer * waterback          = self.layerss[@"waterback"];
    waterback.frame                   = CGRectMake(0, 0.02324 * CGRectGetHeight(waterback.superlayer.bounds),  CGRectGetWidth(waterback.superlayer.bounds), 0.97676 * CGRectGetHeight(waterback.superlayer.bounds));
    waterback.path                    = [self waterbackPathWithBounds:[self.layerss[@"waterback"] bounds]].CGPath;
    
    CAShapeLayer * waterstarting      = self.layerss[@"waterstarting"];
    waterstarting.frame               = CGRectMake(0.11227 * CGRectGetWidth(waterstarting.superlayer.bounds), 0.02248 * CGRectGetHeight(waterstarting.superlayer.bounds), 0.88773 * CGRectGetWidth(waterstarting.superlayer.bounds), 0.97752 * CGRectGetHeight(waterstarting.superlayer.bounds));
    waterstarting.path                = [self waterstartingPathWithBounds:[self.layerss[@"waterstarting"] bounds]].CGPath;
    
    CAShapeLayer * waterstartline     = self.layerss[@"waterstartline"];
    waterstartline.frame              = CGRectMake(0.00338 * CGRectGetWidth(waterstartline.superlayer.bounds), 0.02248 * CGRectGetHeight(waterstartline.superlayer.bounds), 0.56488 * CGRectGetWidth(waterstartline.superlayer.bounds), 0.00237 * CGRectGetHeight(waterstartline.superlayer.bounds));
    waterstartline.path               = [self waterstartlinePathWithBounds:[self.layerss[@"waterstartline"] bounds]].CGPath;
    
    CATextLayer * watermaxscore       = self.layerss[@"watermaxscore"];
    watermaxscore.frame               = CGRectMake(0.05908 * CGRectGetWidth(watermaxscore.superlayer.bounds), 0.35207 * CGRectGetHeight(watermaxscore.superlayer.bounds),0.11338 * CGRectGetWidth(watermaxscore.superlayer.bounds), 0.05338 * CGRectGetHeight(watermaxscore.superlayer.bounds));
    
    CATextLayer * watertext           = self.layerss[@"watertext"];
    watertext.frame                   = CGRectMake(0.06789 * CGRectGetWidth(watertext.superlayer.bounds), 0.01324 * CGRectGetHeight(watertext.superlayer.bounds), 0.22193 * CGRectGetWidth(watertext.superlayer.bounds), 0.03848 * CGRectGetHeight(watertext.superlayer.bounds));
    
    CALayer * water                   = self.layerss[@"water"];
    water.frame                       = CGRectMake(0.02069 * CGRectGetWidth(water.superlayer.bounds), 0, 0.02959 * CGRectGetWidth(water.superlayer.bounds), 0.04888 * CGRectGetHeight(water.superlayer.bounds));
    
    CAShapeLayer * waterleveler       = self.layerss[@"waterleveler"];
    waterleveler.transform            = CATransform3DIdentity;
    waterleveler.frame                = CGRectMake(0.38041 * CGRectGetWidth(waterleveler.superlayer.bounds), 0.0102*CGRectGetHeight(waterleveler.superlayer.bounds), 0.05677 * CGRectGetWidth(waterleveler.superlayer.bounds), 0.03401 * CGRectGetHeight(waterleveler.superlayer.bounds));
    [waterleveler setValue:@(-90 * M_PI/180) forKeyPath:@"transform.rotation"];
    waterleveler.path                 = [self waterlevelerPathWithBounds:[self.layerss[@"waterleveler"] bounds]].CGPath;
    
    
    CAShapeLayer * waterarrow         = self.layerss[@"waterarrow"];
    waterarrow.transform              = CATransform3DIdentity;
    waterarrow.frame                  = CGRectMake(0.38519 * CGRectGetWidth(waterarrow.superlayer.bounds), 0.00 * CGRectGetHeight(waterarrow.superlayer.bounds), 0.04139 * CGRectGetWidth(waterarrow.superlayer.bounds), 0.04888 * CGRectGetHeight(waterarrow.superlayer.bounds));
    [waterarrow setValue:@(-45 * M_PI/180) forKeyPath:@"transform.rotation"];
    waterarrow.path                   = [self waterarrowPathWithBounds:[self.layerss[@"waterarrow"] bounds]].CGPath;
    
    CAShapeLayer * waterstartarrow     = self.layerss[@"waterstartarrow"];
    waterstartarrow.transform          = CATransform3DIdentity;
    waterstartarrow.frame              = CGRectMake(0.0 * CGRectGetWidth(waterarrow.superlayer.bounds), 0.00 * CGRectGetHeight(waterarrow.superlayer.bounds), 0.04139 * CGRectGetWidth(waterarrow.superlayer.bounds), 0.04888 * CGRectGetHeight(waterarrow.superlayer.bounds));
    [waterstartarrow setValue:@(-45 * M_PI/180) forKeyPath:@"transform.rotation"];
    waterstartarrow.path               = [self waterarrowPathWithBounds:[self.layerss[@"waterarrow"] bounds]].CGPath;
    
    
    CATextLayer * waterscore          = self.layerss[@"waterscore"];
    waterscore.frame                  = CGRectMake(0.36079 * CGRectGetWidth(waterscore.superlayer.bounds), 0.60298 * CGRectGetHeight(waterscore.superlayer.bounds),0.11338 * CGRectGetWidth(waterscore.superlayer.bounds), 0.03338 * CGRectGetHeight(waterscore.superlayer.bounds));
    
    CALayer * energygroup             = self.layerss[@"energygroup"];
    energygroup.frame                 = CGRectMake(0, 0,  CGRectGetWidth(energygroup.superlayer.bounds),  CGRectGetHeight(energygroup.superlayer.bounds));
    
    CAShapeLayer * energyback         = self.layerss[@"energyback"];
    energyback.frame                  = CGRectMake(0, 0.01681 * CGRectGetHeight(energyback.superlayer.bounds),  CGRectGetWidth(energyback.superlayer.bounds), 0.98319 * CGRectGetHeight(energyback.superlayer.bounds));
    energyback.path                   = [self energybackPathWithBounds:[self.layerss[@"energyback"] bounds]].CGPath;
    
    
    
    CAShapeLayer * energystarting     = self.layerss[@"energystarting"];
    energystarting.frame              = CGRectMake(0.03665 * CGRectGetWidth(energystarting.superlayer.bounds), 0.01659 * CGRectGetHeight(energystarting.superlayer.bounds), 0.96335 * CGRectGetWidth(energystarting.superlayer.bounds), 0.98341 * CGRectGetHeight(energystarting.superlayer.bounds));
    energystarting.path               = [self energystartingPathWithBounds:[self.layerss[@"energystarting"] bounds]].CGPath;
    
    CAShapeLayer * energystartline    = self.layerss[@"energystartline"];
    energystartline.frame             = CGRectMake(0.00156 * CGRectGetWidth(energystartline.superlayer.bounds), 0.01659 * CGRectGetHeight(energystartline.superlayer.bounds), 0.52734 * CGRectGetWidth(energystartline.superlayer.bounds), 0.00047 * CGRectGetHeight(energystartline.superlayer.bounds));
    energystartline.path              = [self energystartlinePathWithBounds:[self.layerss[@"energystartline"] bounds]].CGPath;
    
    
    CATextLayer * energymaxscore      = self.layerss[@"energymaxscore"];
    energymaxscore.frame              = CGRectMake(-0.01913 * CGRectGetWidth(energymaxscore.superlayer.bounds), 0.37010 * CGRectGetHeight(energymaxscore.superlayer.bounds),0.11338 * CGRectGetWidth(energymaxscore.superlayer.bounds), 0.05338 * CGRectGetHeight(energymaxscore.superlayer.bounds));
    
    CATextLayer * energytext          = self.layerss[@"energytext"];
    energytext.frame                  = CGRectMake(0.06418 * CGRectGetWidth(energytext.superlayer.bounds), 0.9, 0.20643 * CGRectGetWidth(energytext.superlayer.bounds), 0.03318 * CGRectGetHeight(energytext.superlayer.bounds));
    
    CALayer * energy                  = self.layerss[@"energy"];
    energy.frame                      = CGRectMake(0.01876 * CGRectGetWidth(energy.superlayer.bounds), 0.00088 * CGRectGetHeight(energy.superlayer.bounds), 0.02651 * CGRectGetWidth(energy.superlayer.bounds), 0.04591 * CGRectGetHeight(energy.superlayer.bounds));
    
    CAShapeLayer * energyleveler      = self.layerss[@"energyleveler"];
    energyleveler.transform           = CATransform3DIdentity;
    energyleveler.frame               = CGRectMake(0.35292 * CGRectGetWidth(energyleveler.superlayer.bounds), 0.00 * CGRectGetHeight(energyleveler.superlayer.bounds), 0.05298 * CGRectGetWidth(energyleveler.superlayer.bounds), 0.02878 * CGRectGetHeight(energyleveler.superlayer.bounds));
    [energyleveler setValue:@(-90 * M_PI/180) forKeyPath:@"transform.rotation"];
    energyleveler.path                = [self energylevelerPathWithBounds:[self.layerss[@"energyleveler"] bounds]].CGPath;
    
    
    
    CAShapeLayer * energyarrow        = self.layerss[@"energyarrow"];
    energyarrow.transform             = CATransform3DIdentity;
    energyarrow.frame                 = CGRectMake(0.36667 * CGRectGetWidth(energyarrow.superlayer.bounds), 0.0 * CGRectGetHeight(energyarrow.superlayer.bounds), 0.03829 * CGRectGetWidth(energyarrow.superlayer.bounds), 0.04215 * CGRectGetHeight(energyarrow.superlayer.bounds));
    [energyarrow setValue:@(-45 * M_PI/180) forKeyPath:@"transform.rotation"];
    energyarrow.path                  = [self energyarrowPathWithBounds:[self.layerss[@"energyarrow"] bounds]].CGPath;
    
    CAShapeLayer * energystartarrow    = self.layerss[@"energystartarrow"];
    energystartarrow.transform         = CATransform3DIdentity;
    energystartarrow.frame             = CGRectMake(0.0 * CGRectGetWidth(energyarrow.superlayer.bounds), 0.0 * CGRectGetHeight(energyarrow.superlayer.bounds), 0.03829 * CGRectGetWidth(energyarrow.superlayer.bounds), 0.04215 * CGRectGetHeight(energyarrow.superlayer.bounds));
    [energystartarrow setValue:@(-45 * M_PI/180) forKeyPath:@"transform.rotation"];
    energystartarrow.path              = [self energyarrowPathWithBounds:[self.layerss[@"energyarrow"] bounds]].CGPath;
    
    CAShapeLayer * rectangle          = self.layerss[@"rectangle"];
    rectangle.transform               = CATransform3DIdentity;
    rectangle.frame                   = CGRectMake(0.23478 * CGRectGetWidth(rectangle.superlayer.bounds), 0.00 * CGRectGetHeight(rectangle.superlayer.bounds), 0.03710 * CGRectGetWidth(rectangle.superlayer.bounds), 0.03710 * CGRectGetHeight(rectangle.superlayer.bounds));
    [rectangle setValue:@(-133 * M_PI/180) forKeyPath:@"transform.rotation"];
    rectangle.path                    = [self rectanglePathWithBounds:[self.layerss[@"rectangle"] bounds]].CGPath;
    
    
    CATextLayer * energyscore         = self.layerss[@"energyscore"];
    energyscore.frame                 = CGRectMake(0.33662 * CGRectGetWidth(energyscore.superlayer.bounds), 0.5874 * CGRectGetHeight(energyscore.superlayer.bounds),0.11338 * CGRectGetWidth(energyscore.superlayer.bounds), 0.02338 * CGRectGetHeight(energyscore.superlayer.bounds));
    
    
    
    
    CALayer * plaque_coin             = self.layerss[@"plaque_coin"];
    plaque_coin.frame                 = CGRectMake(0, 0,  CGRectGetWidth(plaque_coin.superlayer.bounds),  CGRectGetHeight(plaque_coin.superlayer.bounds));
    
    CALayer * booms                   = self.layerss[@"booms"];
    booms.frame                       = CGRectMake(0.33552 * CGRectGetWidth(booms.superlayer.bounds), 0.38379 * CGRectGetHeight(booms.superlayer.bounds), 0.28072 * CGRectGetWidth(booms.superlayer.bounds), 0.28072 * CGRectGetHeight(booms.superlayer.bounds));
    
    CAShapeLayer * energyboom         = self.layerss[@"energyboom"];
    energyboom.transform              = CATransform3DIdentity;
    energyboom.frame                  = CGRectMake(0.17157 * CGRectGetWidth(energyboom.superlayer.bounds), 0, 0.82843 * CGRectGetWidth(energyboom.superlayer.bounds), 0.82843 * CGRectGetHeight(energyboom.superlayer.bounds));
    [energyboom setValue:@(-135 * M_PI/180) forKeyPath:@"transform.rotation"];
    energyboom.path                   = [self energyboomPathWithBounds:[self.layerss[@"energyboom"] bounds]].CGPath;
    
    CAShapeLayer * waterboom          = self.layerss[@"waterboom"];
    waterboom.transform               = CATransform3DIdentity;
    waterboom.frame                   = CGRectMake(0.17157 * CGRectGetWidth(waterboom.superlayer.bounds), 0, 0.82843 * CGRectGetWidth(waterboom.superlayer.bounds), 0.82843 * CGRectGetHeight(waterboom.superlayer.bounds));
    [waterboom setValue:@(-135 * M_PI/180) forKeyPath:@"transform.rotation"];
    waterboom.path                    = [self waterboomPathWithBounds:[self.layerss[@"waterboom"] bounds]].CGPath;
    
    CAShapeLayer * wasteboom          = self.layerss[@"wasteboom"];
    wasteboom.transform               = CATransform3DIdentity;
    wasteboom.frame                   = CGRectMake(0.17157 * CGRectGetWidth(wasteboom.superlayer.bounds), 0, 0.82843 * CGRectGetWidth(wasteboom.superlayer.bounds), 0.82843 * CGRectGetHeight(wasteboom.superlayer.bounds));
    [wasteboom setValue:@(-135 * M_PI/180) forKeyPath:@"transform.rotation"];
    wasteboom.path                    = [self wasteboomPathWithBounds:[self.layerss[@"wasteboom"] bounds]].CGPath;
    
    CAShapeLayer * transportboom      = self.layerss[@"transportboom"];
    transportboom.transform           = CATransform3DIdentity;
    transportboom.frame               = CGRectMake(0.17157 * CGRectGetWidth(transportboom.superlayer.bounds), 0, 0.82843 * CGRectGetWidth(transportboom.superlayer.bounds), 0.82843 * CGRectGetHeight(transportboom.superlayer.bounds));
    [transportboom setValue:@(-135 * M_PI/180) forKeyPath:@"transform.rotation"];
    transportboom.path                = [self transportboomPathWithBounds:[self.layerss[@"transportboom"] bounds]].CGPath;
    
    CAShapeLayer * humanboom          = self.layerss[@"humanboom"];
    humanboom.transform               = CATransform3DIdentity;
    humanboom.frame                   = CGRectMake(0.17157 * CGRectGetWidth(humanboom.superlayer.bounds), 0, 0.82843 * CGRectGetWidth(humanboom.superlayer.bounds), 0.82843 * CGRectGetHeight(humanboom.superlayer.bounds));
    [humanboom setValue:@(-135 * M_PI/180) forKeyPath:@"transform.rotation"];
    humanboom.path                    = [self humanboomPathWithBounds:[self.layerss[@"humanboom"] bounds]].CGPath;
    
    CALayer * score                   = self.layerss[@"score"];
    score.frame                       = CGRectMake(0.06392 * CGRectGetWidth(score.superlayer.bounds), 0.06402 * CGRectGetHeight(score.superlayer.bounds), 0.87209 * CGRectGetWidth(score.superlayer.bounds), 0.87209 * CGRectGetHeight(score.superlayer.bounds));
    
    CALayer * gold                    = self.layerss[@"gold"];
    gold.frame                        = CGRectMake(0.06392 * CGRectGetWidth(gold.superlayer.bounds), 0.06402 * CGRectGetHeight(gold.superlayer.bounds), 0.87209 * CGRectGetWidth(gold.superlayer.bounds), 0.87209 * CGRectGetHeight(gold.superlayer.bounds));
    
    CALayer * certified               = self.layerss[@"certified"];
    certified.frame                   = CGRectMake(0.06392 * CGRectGetWidth(certified.superlayer.bounds), 0.06402 * CGRectGetHeight(certified.superlayer.bounds), 0.87209 * CGRectGetWidth(certified.superlayer.bounds), 0.87209 * CGRectGetHeight(certified.superlayer.bounds));
    
    CALayer * nonleed                 = self.layerss[@"nonleed"];
    nonleed.frame                     = CGRectMake(0.06392 * CGRectGetWidth(nonleed.superlayer.bounds), 0.06402 * CGRectGetHeight(nonleed.superlayer.bounds), 0.87209 * CGRectGetWidth(nonleed.superlayer.bounds), 0.87209 * CGRectGetHeight(nonleed.superlayer.bounds));
    
    CALayer * platinum                = self.layerss[@"platinum"];
    platinum.frame                    = CGRectMake(0.06392 * CGRectGetWidth(platinum.superlayer.bounds), 0.06402 * CGRectGetHeight(platinum.superlayer.bounds), 0.87209 * CGRectGetWidth(platinum.superlayer.bounds), 0.87209 * CGRectGetHeight(platinum.superlayer.bounds));
    
    CALayer * silver                  = self.layerss[@"silver"];
    silver.frame                      = CGRectMake(0.06392 * CGRectGetWidth(silver.superlayer.bounds), 0.06402 * CGRectGetHeight(silver.superlayer.bounds), 0.87209 * CGRectGetWidth(silver.superlayer.bounds), 0.87209 * CGRectGetHeight(silver.superlayer.bounds));
    
    
    CALayer * blank                   = self.layerss[@"blank"];
    blank.frame                       = CGRectMake(0.06392 * CGRectGetWidth(blank.superlayer.bounds), 0.06402 * CGRectGetHeight(blank.superlayer.bounds), 0.87209 * CGRectGetWidth(blank.superlayer.bounds), 0.87209 * CGRectGetHeight(blank.superlayer.bounds));
    
    
    
    
    CALayer * leed                    = self.layerss[@"leed"];
    leed.frame                        = CGRectMake(0, 0,  CGRectGetWidth(leed.superlayer.bounds),  CGRectGetHeight(leed.superlayer.bounds));
    
    CATextLayer * stepscore           = self.layerss[@"stepscore"];
    stepscore.frame                   = CGRectMake(0.36953 * CGRectGetWidth(stepscore.superlayer.bounds), 0.35484 * CGRectGetHeight(stepscore.superlayer.bounds), 0.26155 * CGRectGetWidth(stepscore.superlayer.bounds), 0.28438 * CGRectGetHeight(stepscore.superlayer.bounds));
    
    CATextLayer * maxscore            = self.layerss[@"maxscore"];
    maxscore.frame                    = CGRectMake(0.36953 * CGRectGetWidth(maxscore.superlayer.bounds), 0.35484 * CGRectGetHeight(maxscore.superlayer.bounds), 0.26155 * CGRectGetWidth(maxscore.superlayer.bounds), 0.28438 * CGRectGetHeight(maxscore.superlayer.bounds));
    [CATransaction commit];
    //        [self addUntitled1Animation];
}

#pragma mark - Animation Setup

- (void)addUntitled1Animation{
    
    
    
    CALayer *t=self.layerss[@"plaque_coin"];
    
    //[self pauseLayer:t];
    //   t.shouldRasterize=YES;
    
    
    
    
    
    CALayer *dynamic_plaque = self.layerss[@"dynamic_plaque"];
    dynamic_plaque.hidden=NO;
    
    self.hidden=NO;
    CATextLayer * stepscore = self.layerss[@"stepscore"];
    stepscore.hidden=NO;
    CATextLayer * maxscore = self.layerss[@"maxscore"];
    maxscore.hidden=NO;
    CALayer * leed_plaque = self.layerss[@"leed_plaque"];
    leed_plaque.hidden=NO;
    CALayer * score = self.layerss[@"score"];
    score.hidden   = YES;
    CALayer * gold = self.layerss[@"gold"];
    gold.hidden   = YES;
    CALayer * certified = self.layerss[@"certified"];
    certified.hidden   = YES;
    CALayer * nonleed  = self.layerss[@"nonleed"];
    nonleed.hidden   = YES;
    CALayer * platinum = self.layerss[@"platinum"];
    platinum.hidden=YES;
    CALayer * silver = self.layerss[@"silver"];
    CALayer * blank = self.layerss[@"blank"];
    
    silver.hidden=YES;
    score.hidden=YES;
    if(totalls>=80){
        platinum.hidden=NO;
        if(initiall==YES){
            blank.hidden=NO;
        }else{
            blank.hidden=YES;
        }
    }else if(totalls>=40 && totalls<=49){
        certified.hidden=NO;
    }
    else if (totalls>=60 && totalls<=79){
        gold.hidden=NO;
        if(initiall==YES){
            blank.hidden=NO;
        }else{
            blank.hidden=YES;
        }
    }
    else if(totalls>=50 && totalls<=59){
        silver.hidden=NO;
        if(initiall==YES){
            blank.hidden=NO;
        }else{
            blank.hidden=YES;
        }
    }
    else if(totalls<=40 && totalls>0){
        blank.hidden=NO;
        
    }
    else{
        blank.hidden=YES;
        nonleed.hidden=NO;
        mhumanvaluee=mtransportvaluee=mwastevaluee=mwatervaluee=menergyvaluee=1;
    }
    
    CAShapeLayer *humanleveler=self.layerss[@"humanleveler"];
    CAShapeLayer *transportleveler=self.layerss[@"transportleveler"];
    CAShapeLayer *wasteleveler=self.layerss[@"wasteleveler"];
    CAShapeLayer *waterleveler=self.layerss[@"waterleveler"];
    CAShapeLayer *energyleveler=self.layerss[@"energyleveler"];
    if(humanvaluee!=mhumanvaluee){
        humanleveler.hidden=YES;
    }
    else{
        humanleveler.hidden=NO;
    }
    if (transportvaluee!=mtransportvaluee){
        transportleveler.hidden=YES;
    }
    else{
        transportleveler.hidden=NO;
    }
    if(wastevaluee!=mwastevaluee){
        wasteleveler.hidden=YES;
    }
    else{
        wasteleveler.hidden=NO;
    }
    if(watervaluee!=mwatervaluee){
        waterleveler.hidden=YES;
    }
    else{
        waterleveler.hidden=NO;
    }
    if(energyvaluee!=menergyvaluee){
        energyleveler.hidden=YES;
    }
    else{
        energyleveler.hidden=NO;
    }
    self.layer.speed = 1;
    NSString * fillMode = kCAFillModeForwards;
    
    
    ////Energystartarrow animation
    CAKeyframeAnimation * energystartarrowOpacityAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    energystartarrowOpacityAnim.values   = @[@0, @0, @1];
    energystartarrowOpacityAnim.keyTimes = @[@0, @0.999, @1];
    energystartarrowOpacityAnim.duration = 37;
    
    CAShapeLayer * energystartarrow = self.layerss[@"energystartarrow"];
    
    CAShapeLayer * energystartline         = self.layerss[@"energystartline"];
    CAKeyframeAnimation * energystartarrowPositionAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    energystartarrowPositionAnim.path      = [QCMethod offsetPath:[self energystartlinePathWithBounds:[self.layerss[@"energystartline"] bounds]] by:CGPointMake(137.3, 121.86)].CGPath;
    energystartarrowPositionAnim.rotationMode = kCAAnimationRotateAutoReverse;
    energystartarrowPositionAnim.calculationMode = kCAAnimationCubicPaced;
    energystartarrowPositionAnim.duration  = 0.5;
    energystartarrowPositionAnim.beginTime = 37;
    energystartarrowPositionAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    
    
    energystartarrowPositionAnim.path      = [QCMethod offsetPath:[self energystartlinePathWithBounds:[self.layerss[@"energystartline"] bounds]] by:CGPointMake(energystartline.frame.origin.x,energystartline.frame.origin.y)].CGPath;
    if(energyvaluee>0){
        energystartarrowPositionAnim.duration  = 0.5;
        energystartarrowPositionAnim.beginTime = 37;
        energystartarrowOpacityAnim.duration = 37.15;
    }else{
        energystartarrowPositionAnim.duration  = 1;
        energystartarrowPositionAnim.beginTime = 37;
        energystartarrowOpacityAnim.duration = 37.15;
    }
    if(energyvaluee!=0){
        energystartarrowPositionAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    }
    else{
        energystartarrowPositionAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    }
    
    CAAnimationGroup * energystartarrowUntitleAnim = [QCMethod groupAnimations:@[energystartarrowOpacityAnim, energystartarrowPositionAnim] fillMode:fillMode];
    [energystartarrow addAnimation:energystartarrowUntitleAnim forKey:@"energystartarrowUntitleAnim"];
    
    
    ////Waterstartarrow animation
    CAKeyframeAnimation * waterstartarrowOpacityAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    waterstartarrowOpacityAnim.values   = @[@0, @0, @1];
    waterstartarrowOpacityAnim.keyTimes = @[@0, @0.999, @1];
    waterstartarrowOpacityAnim.duration = 31.5;
    
    CAShapeLayer * waterstartarrow = self.layerss[@"waterstartarrow"];
    
    CAShapeLayer * waterstartline         = self.layerss[@"waterstartline"];
    CAKeyframeAnimation * waterstartarrowPositionAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    waterstartarrowPositionAnim.path      = [QCMethod offsetPath:[self waterstartlinePathWithBounds:[self.layerss[@"waterstartline"] bounds]] by:CGPointMake(125.2, 126.86)].CGPath;
    waterstartarrowPositionAnim.rotationMode = kCAAnimationRotateAutoReverse;
    waterstartarrowPositionAnim.calculationMode = kCAAnimationCubicPaced;
    waterstartarrowPositionAnim.duration  = 0.5;
    waterstartarrowPositionAnim.beginTime = 31.5;
    waterstartarrowPositionAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    
    
    waterstartarrowPositionAnim.path      = [QCMethod offsetPath:[self waterstartlinePathWithBounds:[self.layerss[@"waterstartline"] bounds]] by:CGPointMake(waterstartline.frame.origin.x,waterstartline.frame.origin.y)].CGPath;
    if(watervaluee>0){
        waterstartarrowPositionAnim.duration  = 0.5;
        waterstartarrowPositionAnim.beginTime = 31.5;
        waterstartarrowOpacityAnim.duration = 31.65;
    }else{
        waterstartarrowPositionAnim.duration  = 1;
        waterstartarrowPositionAnim.beginTime = 31.5;
        waterstartarrowOpacityAnim.duration = 31.65;
    }
    if(watervaluee!=0){
        waterstartarrowPositionAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    }
    else{
        waterstartarrowPositionAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    }
    
    CAAnimationGroup * waterstartarrowUntitleAnim = [QCMethod groupAnimations:@[waterstartarrowOpacityAnim, waterstartarrowPositionAnim] fillMode:fillMode];
    [waterstartarrow addAnimation:waterstartarrowUntitleAnim forKey:@"waterstartarrowUntitleAnim"];
    
    
    ////Wastestartarrow animation
    CAKeyframeAnimation * wastestartarrowOpacityAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    wastestartarrowOpacityAnim.values   = @[@0, @0, @1];
    wastestartarrowOpacityAnim.keyTimes = @[@0, @0.999, @1];
    wastestartarrowOpacityAnim.duration = 25.6;
    
    CAShapeLayer * wastestartarrow = self.layerss[@"wastestartarrow"];
    
    CAShapeLayer * wastestartline         = self.layerss[@"wastestartline"];
    CAKeyframeAnimation * wastestartarrowPositionAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    wastestartarrowPositionAnim.rotationMode = kCAAnimationRotateAutoReverse;
    wastestartarrowPositionAnim.calculationMode = kCAAnimationCubicPaced;
    wastestartarrowPositionAnim.duration  = 0.5;
    wastestartarrowPositionAnim.beginTime = 25.5;
    wastestartarrowPositionAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    wastestartarrowPositionAnim.path      = [QCMethod offsetPath:[self wastestartlinePathWithBounds:[self.layerss[@"wastestartline"] bounds]] by:CGPointMake(wastestartline.frame.origin.x,wastestartline.frame.origin.y)].CGPath;
    
    if(wastevaluee>0){
        wastestartarrowPositionAnim.duration  = 0.5;
        wastestartarrowPositionAnim.beginTime = 25.5;
        wastestartarrowOpacityAnim.duration = 25.65;
    }else{
        wastestartarrowPositionAnim.duration  = 1;
        wastestartarrowPositionAnim.beginTime = 25.5;
        wastestartarrowOpacityAnim.duration = 25.65;
    }
    if(wastevaluee!=0){
        wastestartarrowPositionAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    }else{
        wastestartarrowPositionAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    }
    
    CAAnimationGroup * wastestartarrowUntitleAnim = [QCMethod groupAnimations:@[wastestartarrowOpacityAnim, wastestartarrowPositionAnim] fillMode:fillMode];
    [wastestartarrow addAnimation:wastestartarrowUntitleAnim forKey:@"wastestartarrowUntitleAnim"];
    
    ////Transportstartarrow animation
    CAKeyframeAnimation * transportstartarrowOpacityAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    transportstartarrowOpacityAnim.values = @[@0, @0, @1];
    transportstartarrowOpacityAnim.keyTimes = @[@0, @0.999, @1];
    transportstartarrowOpacityAnim.duration = 19.3;
    transportstartarrowOpacityAnim.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0 :0 :1 :1];
    
    CAShapeLayer * transportstartarrow = self.layerss[@"transportstartarrow"];
    
    CAShapeLayer * transportstartline    = self.layerss[@"transportstartline"];
    CAKeyframeAnimation * transportstartarrowPositionAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    transportstartarrowPositionAnim.rotationMode = kCAAnimationRotateAutoReverse;
    transportstartarrowPositionAnim.calculationMode = kCAAnimationCubicPaced;
    transportstartarrowPositionAnim.duration = 0.5;
    transportstartarrowPositionAnim.beginTime = 19.2;
    transportstartarrowPositionAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    transportstartarrowPositionAnim.path = [QCMethod offsetPath:[self transportstartlinePathWithBounds:[self.layerss[@"transportstartline"] bounds]] by:CGPointMake(transportstartline.frame.origin.x,transportstartline.frame.origin.y)].CGPath;
    if(transportvaluee>0){
        transportstartarrowPositionAnim.duration = 0.5;
        transportstartarrowOpacityAnim.duration = 19.3;
    }
    else{
        transportstartarrowPositionAnim.beginTime = 19.2;
        transportstartarrowPositionAnim.duration = 1;
        transportstartarrowOpacityAnim.duration = 19.35;
    }
    if(transportvaluee!=0){
        transportstartarrowPositionAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    }else{
        transportstartarrowPositionAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    }
    
    CAAnimationGroup * transportstartarrowUntitleAnim = [QCMethod groupAnimations:@[transportstartarrowOpacityAnim, transportstartarrowPositionAnim] fillMode:fillMode];
    [transportstartarrow addAnimation:transportstartarrowUntitleAnim forKey:@"transportstartarrowUntitleAnim"];
    
    
    
    
    ////Energyblock animation
    CAKeyframeAnimation * energyblockStrokeEndAnim = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    energyblockStrokeEndAnim.values    = @[@0, @1];
    energyblockStrokeEndAnim.keyTimes  = @[@0, @1];
    energyblockStrokeEndAnim.duration  = 0.23;
    //    energyblockStrokeEndAnim.timingFunction= [CAMediaTimingFunction functionWithControlPoints:0 :0.2 :0.63 :1];
    //  energyblockStrokeEndAnim.beginTime = 35.99;//35.7;
    energyblockStrokeEndAnim.beginTime = 2.108;//35.7;
    CAAnimationGroup * energyblockUntitleAnim = [QCMethod groupAnimations:@[energyblockStrokeEndAnim] fillMode:fillMode];
    [self.layerss[@"energyblock"] addAnimation:energyblockUntitleAnim forKey:@"energyblockUntitleAnim"];
    
    ////Leed_plaque animation
    CAKeyframeAnimation * leed_plaqueOpacityAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    /*  leed_plaqueOpacityAnim.values   = @[@1, @1, @0];
     leed_plaqueOpacityAnim.keyTimes = @[@0, @0.984, @1];
     leed_plaqueOpacityAnim.duration = 64.1;*/
    leed_plaqueOpacityAnim.values   = @[@1, @1, @0];
    leed_plaqueOpacityAnim.keyTimes = @[@0, @0.986, @1];
    leed_plaqueOpacityAnim.duration = 69.1;
    
    
    CAAnimationGroup * leed_plaqueUntitled1Anim = [QCMethod groupAnimations:@[leed_plaqueOpacityAnim] fillMode:fillMode];
    [self.layerss[@"leed_plaque"] addAnimation:leed_plaqueUntitled1Anim forKey:@"leed_plaqueUntitled1Anim"];
    
    ////Backsides animation
    CAKeyframeAnimation * backsidesOpacityAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    backsidesOpacityAnim.values    = @[@1, @1, @0];
    backsidesOpacityAnim.keyTimes  = @[@0, @0.931, @1];
    backsidesOpacityAnim.duration  = 14.6;
    backsidesOpacityAnim.beginTime = 35.5;
    
    CAAnimationGroup * backsidesUntitled1Anim = [QCMethod groupAnimations:@[backsidesOpacityAnim] fillMode:fillMode];
    [self.layerss[@"backsides"] addAnimation:backsidesUntitled1Anim forKey:@"backsidesUntitled1Anim"];
    
    ////Humanback animation
    CAKeyframeAnimation * humanbackOpacityAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    humanbackOpacityAnim.values   = @[@0, @0, @1, @1, @0];
    humanbackOpacityAnim.keyTimes = @[@0, @0.205, @0.219, @0.982, @1];
    humanbackOpacityAnim.duration = 54.7;
    humanbackOpacityAnim.keyTimes = @[@0, @0.201, @0.215, @0.973, @1];
    humanbackOpacityAnim.duration = 55.7;
    
    //11.21, 11.97
    
    CAAnimationGroup * humanbackUntitleAnim = [QCMethod groupAnimations:@[humanbackOpacityAnim] fillMode:fillMode];
    [self.layerss[@"humanback"] addAnimation:humanbackUntitleAnim forKey:@"humanbackUntitleAnim"];
    
    ////Transportback animation
    CAKeyframeAnimation * transportbackOpacityAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    transportbackOpacityAnim.values   = @[@0, @0, @1, @1, @0];
    transportbackOpacityAnim.keyTimes = @[@0, @0.312, @0.327, @0.982, @1];
    transportbackOpacityAnim.duration = 54.7;
    transportbackOpacityAnim.keyTimes = @[@0, @0.306, @0.321, @0.973, @1];
    transportbackOpacityAnim.duration = 55.7;
    
    // 17.06, 17.88
    
    CAAnimationGroup * transportbackUntitleAnim = [QCMethod groupAnimations:@[transportbackOpacityAnim] fillMode:fillMode];
    [self.layerss[@"transportback"] addAnimation:transportbackUntitleAnim forKey:@"transportbackUntitleAnim"];
    
    ////Wasteback animation
    CAKeyframeAnimation * wastebackOpacityAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    wastebackOpacityAnim.values   = @[@0, @0, @1, @1, @0];
    wastebackOpacityAnim.keyTimes = @[@0, @0.428, @0.442, @0.982, @1];
    wastebackOpacityAnim.duration = 54.7;
    wastebackOpacityAnim.keyTimes = @[@0, @0.42, @0.434, @0.973, @1];
    wastebackOpacityAnim.duration = 55.7;
    
    //23.41, 24.17
    
    CAAnimationGroup * wastebackUntitleAnim = [QCMethod groupAnimations:@[wastebackOpacityAnim] fillMode:fillMode];
    [self.layerss[@"wasteback"] addAnimation:wastebackUntitleAnim forKey:@"wastebackUntitleAnim"];
    
    ////Waterback animation
    CAKeyframeAnimation * waterbackOpacityAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    waterbackOpacityAnim.values   = @[@0, @0, @1, @1, @0];
    waterbackOpacityAnim.keyTimes = @[@0, @0.535, @0.55, @0.982, @1];
    waterbackOpacityAnim.duration = 54.7;
    waterbackOpacityAnim.keyTimes = @[@0, @0.525, @0.54, @0.973, @1];
    waterbackOpacityAnim.duration = 55.7;
    //29.26, 30.08,
    
    CAAnimationGroup * waterbackUntitleAnim = [QCMethod groupAnimations:@[waterbackOpacityAnim] fillMode:fillMode];
    [self.layerss[@"waterback"] addAnimation:waterbackUntitleAnim forKey:@"waterbackUntitleAnim"];
    
    ////Energyback animation
    CAKeyframeAnimation * energybackOpacityAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    energybackOpacityAnim.values   = @[@0, @0, @1, @1, @0];
    //  energybackOpacityAnim.keyTimes = @[@0, @0.636, @0.651, @0.993, @1];
    energybackOpacityAnim.keyTimes = @[@0, @0.645, @0.659, @0.982, @1];
    
    //                                      0 ,35.28, 36.04,
    energybackOpacityAnim.duration = 54.7;
    
    energybackOpacityAnim.keyTimes = @[@0, @0.634, @0.647, @0.973, @1];
    energybackOpacityAnim.duration = 55.7;
    
    CAAnimationGroup * energybackUntitleAnim = [QCMethod groupAnimations:@[energybackOpacityAnim] fillMode:fillMode];
    [self.layerss[@"energyback"] addAnimation:energybackUntitleAnim forKey:@"energybackUntitleAnim"];
    
    ////Humanstarting animation
    CAKeyframeAnimation * humanstartingStrokeEndAnim = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    humanstartingStrokeEndAnim.values    = @[@0, @1];
    humanstartingStrokeEndAnim.keyTimes  = @[@0, @1];
    humanstartingStrokeEndAnim.duration  = 2.2;
    humanstartingStrokeEndAnim.beginTime = 13.4;
    humanstartingStrokeEndAnim.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0 :0 :0.586 :1.1];
    
    CAKeyframeAnimation * humanstartingOpacityAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    humanstartingOpacityAnim.values   = @[@0, @1];
    humanstartingOpacityAnim.keyTimes = @[@0, @1];
    humanstartingOpacityAnim.duration = 13.4;
    
    
    if(humanvaluee>0){
        humanstartingStrokeEndAnim.beginTime = 13.4;
        humanstartingStrokeEndAnim.duration  = 2.9;//2.2;
    }else{
        humanstartingStrokeEndAnim.beginTime = 13.9;
        humanstartingStrokeEndAnim.duration  = 0.1;
        
    }
    
    //0,0.2,0.63,1
    
    if(humanvaluee==mhumanvaluee){
        humanstartingStrokeEndAnim.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0 :0.2 :0.63 :1];
    }
    else{
        humanstartingStrokeEndAnim.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0 :0.2 :0.63 :1];
    }
    
    CAAnimationGroup * humanstartingUntitleAnim = [QCMethod groupAnimations:@[humanstartingStrokeEndAnim, humanstartingOpacityAnim] fillMode:fillMode];
    [self.layerss[@"humanstarting"] addAnimation:humanstartingUntitleAnim forKey:@"humanstartingUntitleAnim"];
    
    
    
    CAAnimationGroup * humanstartingUntitled1Anim = [QCMethod groupAnimations:@[humanstartingStrokeEndAnim] fillMode:fillMode];
    [self.layerss[@"humanstarting"] addAnimation:humanstartingUntitled1Anim forKey:@"humanstartingUntitled1Anim"];
    
    ////Transportstarting animation
    CAKeyframeAnimation * transportstartingStrokeEndAnim = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    transportstartingStrokeEndAnim.values = @[@0, @1];
    transportstartingStrokeEndAnim.keyTimes = @[@0, @1];
    transportstartingStrokeEndAnim.duration = 2.2;
    transportstartingStrokeEndAnim.beginTime = 19.7;
    transportstartingStrokeEndAnim.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0 :0 :0.586 :1.1];
    
    CAKeyframeAnimation * transportstartingOpacityAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    transportstartingOpacityAnim.values   = @[@0, @0, @1];
    transportstartingOpacityAnim.keyTimes = @[@0, @0.999, @1];
    transportstartingOpacityAnim.duration = 19.7;
    
    if(transportvaluee>0){
        transportstartingStrokeEndAnim.duration = 2.9;//2.2;
        if(transportvaluee<3){
            transportstartingStrokeEndAnim.duration = 1.7;//2.2;
        }
        
        transportstartingStrokeEndAnim.beginTime = 19.7;
    }
    else{
        transportstartingStrokeEndAnim.beginTime = 20.2;
        transportstartingStrokeEndAnim.duration = 0.1;
    }
    
    if(transportvaluee==mtransportvaluee){
        transportstartingStrokeEndAnim.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0 :0.2 :0.63 :1];
    }
    else{
        transportstartingStrokeEndAnim.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0 :0.2 :0.63 :1];
    }
    CAAnimationGroup * transportstartingUntitleAnim = [QCMethod groupAnimations:@[transportstartingStrokeEndAnim, transportstartingOpacityAnim] fillMode:fillMode];
    [self.layerss[@"transportstarting"] addAnimation:transportstartingUntitleAnim forKey:@"transportstartingUntitleAnim"];
    
    ////Wastestarting animation
    CAKeyframeAnimation * wastestartingStrokeEndAnim = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    wastestartingStrokeEndAnim.values    = @[@0, @1];
    wastestartingStrokeEndAnim.keyTimes  = @[@0, @1];
    wastestartingStrokeEndAnim.duration  = 2.2;
    wastestartingStrokeEndAnim.beginTime = 26;
    wastestartingStrokeEndAnim.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0 :0 :0.586 :1.1];
    
    CAKeyframeAnimation * wastestartingOpacityAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    wastestartingOpacityAnim.values   = @[@0, @0, @1];
    wastestartingOpacityAnim.keyTimes = @[@0, @0.999, @1];
    wastestartingOpacityAnim.duration = 26;
    
    if(wastevaluee>0){
        wastestartingStrokeEndAnim.duration  = 2.9;//2.2;
        if(wastevaluee<3){
            wastestartingStrokeEndAnim.duration  = 1.7;
        }
        wastestartingStrokeEndAnim.beginTime = 26;
    }else{
        wastestartingStrokeEndAnim.duration  = 0.1;
        wastestartingStrokeEndAnim.beginTime = 26.5;
    }
    
    if(wastevaluee==mwastevaluee){
        wastestartingStrokeEndAnim.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0 :0.2 :0.63 :1];
    }
    else{
        wastestartingStrokeEndAnim.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0 :0.2 :0.63 :1];
    }
    
    
    CAAnimationGroup * wastestartingUntitleAnim = [QCMethod groupAnimations:@[wastestartingStrokeEndAnim, wastestartingOpacityAnim] fillMode:fillMode];
    [self.layerss[@"wastestarting"] addAnimation:wastestartingUntitleAnim forKey:@"wastestartingUntitleAnim"];
    
    
    ////Waterstarting animation
    CAKeyframeAnimation * waterstartingStrokeEndAnim = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    waterstartingStrokeEndAnim.values    = @[@0, @1];
    waterstartingStrokeEndAnim.keyTimes  = @[@0, @1];
    waterstartingStrokeEndAnim.duration  = 2.2;
    waterstartingStrokeEndAnim.beginTime = 32;
    waterstartingStrokeEndAnim.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0 :0.2 :0.63 :1];
    
    CAKeyframeAnimation * waterstartingOpacityAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    waterstartingOpacityAnim.values   = @[@0, @0, @1];
    waterstartingOpacityAnim.keyTimes = @[@0, @0.999, @1];
    waterstartingOpacityAnim.duration = 32;
    
    
    if(watervaluee>0){
        waterstartingStrokeEndAnim.duration  = 2.9;//2.2;
        if(watervaluee<3){
            waterstartingStrokeEndAnim.duration  = 1.7;//2.2;
        }
        waterstartingStrokeEndAnim.beginTime = 32;
    }else{
        waterstartingStrokeEndAnim.beginTime = 32.5;
        waterstartingStrokeEndAnim.duration  = 0.1;
    }
    if(watervaluee==mwatervaluee){
        waterstartingStrokeEndAnim.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0 :0.2 :0.63 :1];
    }else{
        waterstartingStrokeEndAnim.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0 :0.2 :0.63 :1];
    }
    
    CAAnimationGroup * waterstartingUntitleAnim = [QCMethod groupAnimations:@[waterstartingStrokeEndAnim, waterstartingOpacityAnim] fillMode:fillMode];
    [self.layerss[@"waterstarting"] addAnimation:waterstartingUntitleAnim forKey:@"waterstartingUntitleAnim"];
    
    ////Energystarting animation
    CAKeyframeAnimation * energystartingStrokeEndAnim = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    energystartingStrokeEndAnim.values    = @[@0, @1];
    energystartingStrokeEndAnim.keyTimes  = @[@0, @1];
    energystartingStrokeEndAnim.duration  = 2.2;
    energystartingStrokeEndAnim.beginTime = 37.5;
    energystartingStrokeEndAnim.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0 :0 :0.586 :1.1];
    
    CAKeyframeAnimation * energystartingOpacityAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    energystartingOpacityAnim.values   = @[@0, @0, @1];
    energystartingOpacityAnim.keyTimes = @[@0, @0.999, @1];
    energystartingOpacityAnim.duration = 37.5;
    
    if(energyvaluee>0){
        energystartingStrokeEndAnim.duration  = 2.9;//2.9;//2.2;
        if(energyvaluee<3){
            energystartingStrokeEndAnim.duration  = 1.7;//2.2;
        }
        energystartingStrokeEndAnim.beginTime = 37.5;
        
        
    }else{
        energystartingStrokeEndAnim.duration  = 0.1;
        // energystartingStrokeEndAnim.beginTime = 35.4;
        energystartingStrokeEndAnim.beginTime = 38;
    }
    
    if(energyvaluee==menergyvaluee){
        energystartingStrokeEndAnim.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0 :0.2 :0.63 :1];
        // energystartingStrokeEndAnim.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        
    }
    else{
        energystartingStrokeEndAnim.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0 :0.2 :0.63 :1];
    }
    CAAnimationGroup * energystartingUntitleAnim = [QCMethod groupAnimations:@[energystartingStrokeEndAnim, energystartingOpacityAnim] fillMode:fillMode];
    [self.layerss[@"energystarting"] addAnimation:energystartingUntitleAnim forKey:@"energystartingUntitleAnim"];
    
    
    
    ////Energystartline animation
    CAKeyframeAnimation * energystartlineStrokeEndAnim = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    energystartlineStrokeEndAnim.values    = @[@0, @1];
    energystartlineStrokeEndAnim.keyTimes  = @[@0, @1];
    energystartlineStrokeEndAnim.duration  = 0.5;
    energystartlineStrokeEndAnim.beginTime = 37;
    energystartlineStrokeEndAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CAKeyframeAnimation * energystartlineOpacityAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    energystartlineOpacityAnim.values   = @[@0, @0, @1];
    energystartlineOpacityAnim.keyTimes = @[@0, @0.999, @1];
    energystartlineOpacityAnim.duration = 37;
    
    
    
    if(energyvaluee>0){
        energystartlineStrokeEndAnim.duration  = 0.5;
        energystartlineStrokeEndAnim.beginTime = 37;
    }else{
        energystartlineStrokeEndAnim.duration  = 1;
        energystartlineStrokeEndAnim.beginTime = 37;
    }
    if(energyvaluee!=0){
        energystartlineStrokeEndAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    }else{
        energystartlineStrokeEndAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    }
    
    CAAnimationGroup * energystartlineUntitleAnim = [QCMethod groupAnimations:@[energystartlineStrokeEndAnim, energystartlineOpacityAnim] fillMode:fillMode];
    [self.layerss[@"energystartline"] addAnimation:energystartlineUntitleAnim forKey:@"energystartlineUntitleAnim"];
    
    ////Waterstartline animation
    CAKeyframeAnimation * waterstartlineStrokeEndAnim = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    waterstartlineStrokeEndAnim.values    = @[@0, @1];
    waterstartlineStrokeEndAnim.keyTimes  = @[@0, @1];
    waterstartlineStrokeEndAnim.duration  = 0.5;
    waterstartlineStrokeEndAnim.beginTime = 31.5;
    waterstartlineStrokeEndAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CAKeyframeAnimation * waterstartlineOpacityAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    waterstartlineOpacityAnim.values   = @[@0, @0, @1];
    waterstartlineOpacityAnim.keyTimes = @[@0, @0.999, @1];
    waterstartlineOpacityAnim.duration = 31.5;
    
    
    
    if(watervaluee>0){
        waterstartlineStrokeEndAnim.duration  = 0.5;
        waterstartlineStrokeEndAnim.beginTime = 31.5;
    }else{
        waterstartlineStrokeEndAnim.duration  = 1;
        waterstartlineStrokeEndAnim.beginTime = 31.5;
    }
    if(watervaluee!=0){
        waterstartlineStrokeEndAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    }else{
        waterstartlineStrokeEndAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    }
    
    CAAnimationGroup * waterstartlineUntitleAnim = [QCMethod groupAnimations:@[waterstartlineStrokeEndAnim, waterstartlineOpacityAnim] fillMode:fillMode];
    [self.layerss[@"waterstartline"] addAnimation:waterstartlineUntitleAnim forKey:@"waterstartlineUntitleAnim"];
    
    ////Wastestartline animation
    CAKeyframeAnimation * wastestartlineStrokeEndAnim = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    wastestartlineStrokeEndAnim.values    = @[@0, @1];
    wastestartlineStrokeEndAnim.keyTimes  = @[@0, @1];
    wastestartlineStrokeEndAnim.duration  = 0.5;
    wastestartlineStrokeEndAnim.beginTime = 25.5;
    wastestartlineStrokeEndAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CAKeyframeAnimation * wastestartlineOpacityAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    wastestartlineOpacityAnim.values   = @[@0, @0, @1];
    wastestartlineOpacityAnim.keyTimes = @[@0, @0.999, @1];
    wastestartlineOpacityAnim.duration = 25.5;
    
    if(wastevaluee>0){
        wastestartlineStrokeEndAnim.duration  = 0.5;
        wastestartlineStrokeEndAnim.beginTime = 25.5;
    }else{
        wastestartlineStrokeEndAnim.duration  = 1;
        wastestartlineStrokeEndAnim.beginTime = 25.5;
    }
    if(wastevaluee!=0){
        wastestartlineStrokeEndAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    }
    else{
        wastestartlineStrokeEndAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    }
    CAAnimationGroup * wastestartlineUntitleAnim = [QCMethod groupAnimations:@[wastestartlineStrokeEndAnim, wastestartlineOpacityAnim] fillMode:fillMode];
    [self.layerss[@"wastestartline"] addAnimation:wastestartlineUntitleAnim forKey:@"wastestartlineUntitleAnim"];
    
    ////Transportstartline animation
    CAKeyframeAnimation * transportstartlineStrokeEndAnim = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    transportstartlineStrokeEndAnim.values = @[@0, @1];
    transportstartlineStrokeEndAnim.keyTimes = @[@0, @1];
    transportstartlineStrokeEndAnim.duration = 0.5;
    transportstartlineStrokeEndAnim.beginTime = 19.2;
    transportstartlineStrokeEndAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CAKeyframeAnimation * transportstartlineOpacityAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    transportstartlineOpacityAnim.values   = @[@0, @0, @1];
    transportstartlineOpacityAnim.keyTimes = @[@0, @0.999, @1];
    transportstartlineOpacityAnim.duration = 19.2;
    if(transportvaluee!=0){
        transportstartlineStrokeEndAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    }else{
        transportstartlineStrokeEndAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    }
    if(transportvaluee>0){
        transportstartlineStrokeEndAnim.duration = 0.5;
    }
    else{
        transportstartlineStrokeEndAnim.beginTime = 19.2;
        transportstartlineStrokeEndAnim.duration = 1;
    }
    
    CAAnimationGroup * transportstartlineUntitleAnim = [QCMethod groupAnimations:@[transportstartlineStrokeEndAnim, transportstartlineOpacityAnim] fillMode:fillMode];
    [self.layerss[@"transportstartline"] addAnimation:transportstartlineUntitleAnim forKey:@"transportstartlineUntitleAnim"];
    
    ///!~~~~
    
    ////Transportarrow animation
    CAKeyframeAnimation * transportarrowOpacityAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    transportarrowOpacityAnim.values   = @[@0, @0, @1];
    transportarrowOpacityAnim.keyTimes = @[@0, @0.999, @1];
    transportarrowOpacityAnim.duration = 19.7;
    transportarrowOpacityAnim.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0 :0 :1 :1];
    
    
    
    
    if(transportvaluee>0){
        transportarrowOpacityAnim.duration = 19.7;
    }
    else{
        transportarrowOpacityAnim.duration = 20.2;
    }
    //  transportarrowOpacityAnim.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0 :0 :1 :1];
    
    CAShapeLayer * transportarrow = self.layerss[@"transportarrow"];
    CAShapeLayer * transportstarting     = self.layerss[@"transportstarting"];
    CAKeyframeAnimation * transportarrowPositionAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    transportarrowPositionAnim.path      = [QCMethod offsetPath:[self transportstartingPathWithBounds:[self.layerss[@"transportstarting"] bounds]] by:CGPointMake(142.74, 136.86)].CGPath;
    transportarrowPositionAnim.rotationMode = kCAAnimationRotateAutoReverse;
    transportarrowPositionAnim.calculationMode = kCAAnimationCubicPaced;
    transportarrowPositionAnim.duration  = 2.2;
    transportarrowPositionAnim.beginTime = 19.7;
    transportarrowPositionAnim.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0 :0 :0.586 :1.1];
    
    
    
    transportarrowPositionAnim.path      = [QCMethod offsetPath:[self transportstartingPathWithBounds:[self.layerss[@"transportstarting"] bounds]] by:CGPointMake(transportstarting.frame.origin.x, transportstarting.frame.origin.y)].CGPath;
    transportarrowPositionAnim.rotationMode = kCAAnimationRotateAutoReverse;
    transportarrowPositionAnim.calculationMode = kCAAnimationCubicPaced;
    if(transportvaluee>0){
        transportarrowPositionAnim.duration  = 2.9;//2.2;
        if(transportvaluee<3){
            transportarrowPositionAnim.duration=1.7;
        }
        transportarrowPositionAnim.beginTime = 19.7;
    }else{
        transportarrowPositionAnim.duration  = 0.1;
        transportarrowPositionAnim.beginTime = 20.2;
    }
    
    if(transportvaluee==mtransportvaluee){
        transportarrowPositionAnim.beginTime = 19.7;
        transportarrowPositionAnim.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0 :0.2 :0.63 :1];
    }
    else{
        transportarrowPositionAnim.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0 :0.2 :0.63 :1];
    }
    
    
    CAAnimationGroup * transportarrowUntitleAnim = [QCMethod groupAnimations:@[transportarrowOpacityAnim, transportarrowPositionAnim] fillMode:fillMode];
    [transportarrow addAnimation:transportarrowUntitleAnim forKey:@"transportarrowUntitleAnim"];
    
    
    
    ////Humanstartline animation
    CAKeyframeAnimation * humanstartlineStrokeEndAnim = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    humanstartlineStrokeEndAnim.values    = @[@0, @1];
    humanstartlineStrokeEndAnim.keyTimes  = @[@0, @0.999];
    humanstartlineStrokeEndAnim.duration  = 0.5;
    humanstartlineStrokeEndAnim.beginTime = 12.9;
    humanstartlineStrokeEndAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    
    
    
    
    if(humanvaluee>0){
    }
    else{
        humanstartlineStrokeEndAnim.duration  = 1;
    }
    if(humanvaluee!=0){
        humanstartlineStrokeEndAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    }
    else{
        humanstartlineStrokeEndAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    }
    
    CAAnimationGroup * humanstartlineUntitleAnim = [QCMethod groupAnimations:@[humanstartlineStrokeEndAnim] fillMode:fillMode];
    [self.layerss[@"humanstartline"] addAnimation:humanstartlineUntitleAnim forKey:@"humanstartlineUntitleAnim"];
    
    ////Maxscores animation
    CAKeyframeAnimation * maxscoresOpacityAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    maxscoresOpacityAnim.values    = @[@1, @1];
    maxscoresOpacityAnim.keyTimes  = @[@0, @1];
    maxscoresOpacityAnim.duration  = 1;
    maxscoresOpacityAnim.beginTime = 49.1;
    
    CAAnimationGroup * maxscoresUntitled1Anim = [QCMethod groupAnimations:@[maxscoresOpacityAnim] fillMode:fillMode];
    [self.layerss[@"maxscores"] addAnimation:maxscoresUntitled1Anim forKey:@"maxscoresUntitled1Anim"];
    
    ////Energymaxscore animation
    CAKeyframeAnimation * energymaxscoreOpacityAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    energymaxscoreOpacityAnim.values   = @[@0, @0, @1, @1, @0];
    energymaxscoreOpacityAnim.keyTimes = @[@0, @0.636, @0.651, @0.993, @1];
    energymaxscoreOpacityAnim.duration = 54.7;
    
    CAAnimationGroup * energymaxscoreUntitleAnim = [QCMethod groupAnimations:@[energymaxscoreOpacityAnim] fillMode:fillMode];
    [self.layerss[@"energymaxscore"] addAnimation:energymaxscoreUntitleAnim forKey:@"energymaxscoreUntitleAnim"];
    
    ////Watermaxscore animation
    CAKeyframeAnimation * watermaxscoreOpacityAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    watermaxscoreOpacityAnim.values   = @[@0, @0, @1, @1, @0];
    watermaxscoreOpacityAnim.keyTimes = @[@0, @0.535, @0.55, @0.993, @1];
    watermaxscoreOpacityAnim.duration = 54.7;
    
    CAAnimationGroup * watermaxscoreUntitleAnim = [QCMethod groupAnimations:@[watermaxscoreOpacityAnim] fillMode:fillMode];
    [self.layerss[@"watermaxscore"] addAnimation:watermaxscoreUntitleAnim forKey:@"watermaxscoreUntitleAnim"];
    
    ////Wastemaxscore animation
    CAKeyframeAnimation * wastemaxscoreOpacityAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    wastemaxscoreOpacityAnim.values   = @[@0, @0, @1, @1, @0];
    wastemaxscoreOpacityAnim.keyTimes = @[@0, @0.428, @0.442, @0.993, @1];
    wastemaxscoreOpacityAnim.duration = 54.7;
    
    CAAnimationGroup * wastemaxscoreUntitleAnim = [QCMethod groupAnimations:@[wastemaxscoreOpacityAnim] fillMode:fillMode];
    [self.layerss[@"wastemaxscore"] addAnimation:wastemaxscoreUntitleAnim forKey:@"wastemaxscoreUntitleAnim"];
    
    ////Transportmaxscore animation
    CAKeyframeAnimation * transportmaxscoreOpacityAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    transportmaxscoreOpacityAnim.values   = @[@0, @0, @1, @1, @0];
    transportmaxscoreOpacityAnim.keyTimes = @[@0, @0.312, @0.327, @0.993, @1];
    transportmaxscoreOpacityAnim.duration = 54.7;
    
    CAAnimationGroup * transportmaxscoreUntitleAnim = [QCMethod groupAnimations:@[transportmaxscoreOpacityAnim] fillMode:fillMode];
    [self.layerss[@"transportmaxscore"] addAnimation:transportmaxscoreUntitleAnim forKey:@"transportmaxscoreUntitleAnim"];
    
    ////Humanmaxscore animation
    CAKeyframeAnimation * humanmaxscoreOpacityAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    humanmaxscoreOpacityAnim.values   = @[@0, @0, @1, @1, @0];
    humanmaxscoreOpacityAnim.keyTimes = @[@0, @0.205, @0.219, @0.993, @1];
    humanmaxscoreOpacityAnim.duration = 54.7;
    
    CAAnimationGroup * humanmaxscoreUntitleAnim = [QCMethod groupAnimations:@[humanmaxscoreOpacityAnim] fillMode:fillMode];
    [self.layerss[@"humanmaxscore"] addAnimation:humanmaxscoreUntitleAnim forKey:@"humanmaxscoreUntitleAnim"];
    
    ////Energytext animation
    CAKeyframeAnimation * energytextOpacityAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    energytextOpacityAnim.values   = @[@0, @0, @1];
    energytextOpacityAnim.keyTimes = @[@0, @0.999, @1];
    energytextOpacityAnim.duration = 37;
    
    CAAnimationGroup * energytextUntitled1Anim = [QCMethod groupAnimations:@[energytextOpacityAnim] fillMode:fillMode];
    [self.layerss[@"energytext"] addAnimation:energytextUntitled1Anim forKey:@"energytextUntitled1Anim"];
    
    ////Watertext animation
    CAKeyframeAnimation * watertextOpacityAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    watertextOpacityAnim.values   = @[@0, @0, @1];
    watertextOpacityAnim.keyTimes = @[@0, @0.997, @1];
    watertextOpacityAnim.duration = 31.6;
    
    CAAnimationGroup * watertextUntitled1Anim = [QCMethod groupAnimations:@[watertextOpacityAnim] fillMode:fillMode];
    [self.layerss[@"watertext"] addAnimation:watertextUntitled1Anim forKey:@"watertextUntitled1Anim"];
    
    ////Wastetext animation
    CAKeyframeAnimation * wastetextOpacityAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    wastetextOpacityAnim.values   = @[@0, @0, @1];
    wastetextOpacityAnim.keyTimes = @[@0, @0.997, @1];
    wastetextOpacityAnim.duration = 25.6;
    
    CAAnimationGroup * wastetextUntitled1Anim = [QCMethod groupAnimations:@[wastetextOpacityAnim] fillMode:fillMode];
    [self.layerss[@"wastetext"] addAnimation:wastetextUntitled1Anim forKey:@"wastetextUntitled1Anim"];
    
    ////Transporttext animation
    CAKeyframeAnimation * transporttextOpacityAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    transporttextOpacityAnim.values   = @[@0, @0, @1];
    transporttextOpacityAnim.keyTimes = @[@0, @0.996, @1];
    transporttextOpacityAnim.duration = 19.3;
    
    CAAnimationGroup * transporttextUntitleAnim = [QCMethod groupAnimations:@[transporttextOpacityAnim] fillMode:fillMode];
    [self.layerss[@"transporttext"] addAnimation:transporttextUntitleAnim forKey:@"transporttextUntitleAnim"];
    
    ////Humantext animation
    CAKeyframeAnimation * humantextOpacityAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    humantextOpacityAnim.values   = @[@0, @0, @1];
    humantextOpacityAnim.keyTimes = @[@0, @0.994, @1];
    humantextOpacityAnim.duration = 13;
    
    CAAnimationGroup * humantextUntitleAnim = [QCMethod groupAnimations:@[humantextOpacityAnim] fillMode:fillMode];
    [self.layerss[@"humantext"] addAnimation:humantextUntitleAnim forKey:@"humantextUntitleAnim"];
    
    
    ////Water animation
    CAKeyframeAnimation * waterOpacityAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    waterOpacityAnim.values                = @[@0, @0, @1];
    waterOpacityAnim.keyTimes              = @[@0, @0.997, @1];
    waterOpacityAnim.duration              = 31.6;
    
    CAAnimationGroup * waterUntitled1Anim = [QCMethod groupAnimations:@[waterOpacityAnim] fillMode:fillMode];
    [self.layerss[@"water"] addAnimation:waterUntitled1Anim forKey:@"waterUntitled1Anim"];
    
    ////Waste animation
    CAKeyframeAnimation * wasteOpacityAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    wasteOpacityAnim.values                = @[@0, @0, @1];
    wasteOpacityAnim.keyTimes              = @[@0, @0.997, @1];
    wasteOpacityAnim.duration              = 25.6;
    
    CAAnimationGroup * wasteUntitled1Anim = [QCMethod groupAnimations:@[wasteOpacityAnim] fillMode:fillMode];
    [self.layerss[@"waste"] addAnimation:wasteUntitled1Anim forKey:@"wasteUntitled1Anim"];
    
    ////Transport animation
    CAKeyframeAnimation * transportOpacityAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    transportOpacityAnim.values   = @[@0, @0, @1];
    transportOpacityAnim.keyTimes = @[@0, @0.996, @1];
    transportOpacityAnim.duration = 19.3;
    
    CAAnimationGroup * transportUntitleAnim = [QCMethod groupAnimations:@[transportOpacityAnim] fillMode:fillMode];
    [self.layerss[@"transport"] addAnimation:transportUntitleAnim forKey:@"transportUntitleAnim"];
    
    
    ////Human animation
    CAKeyframeAnimation * humanOpacityAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    humanOpacityAnim.values                = @[@0, @0, @1];
    humanOpacityAnim.keyTimes              = @[@0, @0.994, @1];
    humanOpacityAnim.duration              = 13;
    
    CAAnimationGroup * humanUntitleAnim = [QCMethod groupAnimations:@[humanOpacityAnim] fillMode:fillMode];
    [self.layerss[@"human"] addAnimation:humanUntitleAnim forKey:@"humanUntitleAnim"];
    
    ////Energy animation
    CAKeyframeAnimation * energyOpacityAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    energyOpacityAnim.values   = @[@0, @0, @1];
    energyOpacityAnim.keyTimes = @[@0, @0.999, @1];
    energyOpacityAnim.duration = 37;
    
    CAAnimationGroup * energyUntitled1Anim = [QCMethod groupAnimations:@[energyOpacityAnim] fillMode:fillMode];
    [self.layerss[@"energy"] addAnimation:energyUntitled1Anim forKey:@"energyUntitled1Anim"];
    
    ////Humanarrow animation
    CAKeyframeAnimation * humanarrowOpacityAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    humanarrowOpacityAnim.values   = @[@0, @0, @1];
    if(humanvaluee>0){
        humanarrowOpacityAnim.keyTimes = @[@0, @0.999, @1];
        humanarrowOpacityAnim.duration = 13.4;
    }
    else{
        humanarrowOpacityAnim.keyTimes = @[@0, @0.999, @1];
        humanarrowOpacityAnim.duration = 14.4;
    }
    CAShapeLayer * humanarrow = self.layerss[@"humanarrow"];
    
    CAShapeLayer * humanstarting           = self.layerss[@"humanstarting"];
    CAKeyframeAnimation * humanarrowPositionAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    humanarrowPositionAnim.path            = [QCMethod offsetPath:[self humanstartingPathWithBounds:[self.layerss[@"humanstarting"] bounds]] by:CGPointMake(humanstarting.frame.origin.x,humanstarting.frame.origin.y)].CGPath;
    
    humanarrowPositionAnim.rotationMode    = kCAAnimationRotateAuto;
    humanarrowPositionAnim.calculationMode = kCAAnimationCubicPaced;
    if(humanvaluee>0){
        humanarrowPositionAnim.duration        = 2.9;//2.2;
        humanarrowPositionAnim.beginTime       = 13.4;
    }
    else{
        humanarrowPositionAnim.beginTime       = 14.4;
        humanarrowPositionAnim.duration        = 0.1;
    }
    //    0,0.2,0.63,1
    if(humanvaluee!=mhumanvaluee){
        humanarrowPositionAnim.beginTime=13.4;
        humanarrowPositionAnim.timingFunction  = [CAMediaTimingFunction functionWithControlPoints:0 :0.2 :0.63 :1];
    }
    else{
        humanarrowPositionAnim.timingFunction  = [CAMediaTimingFunction functionWithControlPoints:0 :0.2 :0.63 :1];
    }
    
    CAAnimationGroup * humanarrowUntitled1Anim = [QCMethod groupAnimations:@[humanarrowOpacityAnim,humanarrowPositionAnim] fillMode:fillMode];
    [humanarrow addAnimation:humanarrowUntitled1Anim forKey:@"humanarrowUntitled1Anim"];
    
    
    
    ////Wastearrow animation
    CAKeyframeAnimation * wastearrowOpacityAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    wastearrowOpacityAnim.values   = @[@0, @0, @1];
    wastearrowOpacityAnim.keyTimes = @[@0, @0.999, @1];
    wastearrowOpacityAnim.duration = 26;
    
    
    
    if(wastevaluee>0){
        wastearrowOpacityAnim.duration = 26;
    }
    else{
        wastearrowOpacityAnim.duration = 26.7;
    }
    
    
    CAShapeLayer * wastearrow = self.layerss[@"wastearrow"];
    
    CAShapeLayer * wastestarting           = self.layerss[@"wastestarting"];
    CAKeyframeAnimation * wastearrowPositionAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    wastearrowPositionAnim.path            = [QCMethod offsetPath:[self wastestartingPathWithBounds:[self.layerss[@"wastestarting"] bounds]] by:CGPointMake(130.02, 131.86)].CGPath;
    wastearrowPositionAnim.rotationMode    = kCAAnimationRotateAutoReverse;
    wastearrowPositionAnim.calculationMode = kCAAnimationCubicPaced;
    wastearrowPositionAnim.duration        = 2.2;
    wastearrowPositionAnim.beginTime       = 26;
    wastearrowPositionAnim.timingFunction  = [CAMediaTimingFunction functionWithControlPoints:0 :0 :0.586 :1.1];
    wastearrowPositionAnim.path            = [QCMethod offsetPath:[self wastestartingPathWithBounds:[self.layerss[@"wastestarting"] bounds]] by:CGPointMake(wastestarting.frame.origin.x,wastestarting.frame.origin.y)].CGPath;
    wastearrowPositionAnim.rotationMode    = kCAAnimationRotateAutoReverse;
    wastearrowPositionAnim.calculationMode = kCAAnimationCubicPaced;
    if(wastevaluee>0){
        wastearrowPositionAnim.duration        = 2.9;//2.2;
        if(wastevaluee<3){
            wastearrowPositionAnim.duration        = 1.7;//2.2;
        }
        wastearrowPositionAnim.beginTime       = 26;
    }else{
        wastearrowPositionAnim.beginTime       = 26.5;
        wastearrowPositionAnim.duration        = 0.1;
    }
    if(wastevaluee==mwastevaluee){
        wastearrowPositionAnim.timingFunction  = [CAMediaTimingFunction functionWithControlPoints:0 :0.2 :0.63 :1];
        wastearrowPositionAnim.beginTime       = 26;
    }
    else{
        wastearrowPositionAnim.timingFunction  = [CAMediaTimingFunction functionWithControlPoints:0 :0.2 :0.63 :1];
    }
    
    CAAnimationGroup * wastearrowUntitleAnim = [QCMethod groupAnimations:@[wastearrowOpacityAnim, wastearrowPositionAnim] fillMode:fillMode];
    [wastearrow addAnimation:wastearrowUntitleAnim forKey:@"wastearrowUntitleAnim"];
    
    ////Waterarrow animation
    CAKeyframeAnimation * waterarrowOpacityAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    waterarrowOpacityAnim.values   = @[@0, @0, @1];
    waterarrowOpacityAnim.keyTimes = @[@0, @0.999, @1];
    waterarrowOpacityAnim.duration = 32;
    
    
    
    if(watervaluee>0){
        waterarrowOpacityAnim.duration = 32;
    }
    else{
        waterarrowOpacityAnim.duration = 32.6;
    }
    CAShapeLayer * waterarrow = self.layerss[@"waterarrow"];
    
    CAShapeLayer * waterstarting           = self.layerss[@"waterstarting"];
    CAKeyframeAnimation * waterarrowPositionAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    waterarrowPositionAnim.path            = [QCMethod offsetPath:[self waterstartingPathWithBounds:[self.layerss[@"waterstarting"] bounds]] by:CGPointMake(132.56, 126.86)].CGPath;
    waterarrowPositionAnim.rotationMode    = kCAAnimationRotateAutoReverse;
    waterarrowPositionAnim.calculationMode = kCAAnimationCubicPaced;
    waterarrowPositionAnim.duration        = 2.2;
    waterarrowPositionAnim.beginTime       = 32;
    waterarrowPositionAnim.timingFunction  = [CAMediaTimingFunction functionWithControlPoints:0 :0 :0.586 :1.1];
    
    
    
    waterarrowPositionAnim.path            = [QCMethod offsetPath:[self waterstartingPathWithBounds:[self.layerss[@"waterstarting"] bounds]] by:CGPointMake(waterstarting.frame.origin.x, waterstarting.frame.origin.y)].CGPath;
    waterarrowPositionAnim.rotationMode    = kCAAnimationRotateAutoReverse;
    waterarrowPositionAnim.calculationMode = kCAAnimationCubicPaced;
    if(watervaluee>0){
        waterarrowPositionAnim.duration        = 2.9;//2.2;
        if(watervaluee<3){
            waterarrowPositionAnim.duration        = 1.7;//2.2;
        }
    }else{
        waterarrowPositionAnim.duration        = 32.5;
        waterarrowPositionAnim.duration        = 0.1;
    }
    waterarrowPositionAnim.beginTime       = 32;
    if(watervaluee==mwatervaluee){
        waterarrowPositionAnim.beginTime       = 32;
    }
    
    if(watervaluee==mwatervaluee){
        waterarrowPositionAnim.timingFunction  = [CAMediaTimingFunction functionWithControlPoints:0 :0.2 :0.63 :1];
    }else{
        waterarrowPositionAnim.timingFunction  = [CAMediaTimingFunction functionWithControlPoints:0 :0.2 :0.63 :1];
    }
    
    
    CAAnimationGroup * waterarrowUntitleAnim = [QCMethod groupAnimations:@[waterarrowOpacityAnim, waterarrowPositionAnim] fillMode:fillMode];
    [waterarrow addAnimation:waterarrowUntitleAnim forKey:@"waterarrowUntitleAnim"];
    
    ////Energyarrow animation
    CAKeyframeAnimation * energyarrowOpacityAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    energyarrowOpacityAnim.values   = @[@0, @0, @1];
    energyarrowOpacityAnim.keyTimes = @[@0, @0.999, @1];
    energyarrowOpacityAnim.duration = 37.5;
    
    if(energyvaluee>0){
        energyarrowOpacityAnim.duration = 37.5;
    }else{
        energyarrowOpacityAnim.duration = 39;
    }
    CAShapeLayer * energyarrow = self.layerss[@"energyarrow"];
    
    CAShapeLayer * energystarting          = self.layerss[@"energystarting"];
    CAKeyframeAnimation * energyarrowPositionAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    energyarrowPositionAnim.path           = [QCMethod offsetPath:[self energystartingPathWithBounds:[self.layerss[@"energystarting"] bounds]] by:CGPointMake(139.85, 121.86)].CGPath;
    energyarrowPositionAnim.rotationMode   = kCAAnimationRotateAutoReverse;
    energyarrowPositionAnim.calculationMode = kCAAnimationCubicPaced;
    energyarrowPositionAnim.duration       = 2.2;
    energyarrowPositionAnim.beginTime      = 37.5;
    energyarrowPositionAnim.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0 :0 :0.586 :1.1];
    
    energyarrowPositionAnim.path           = [QCMethod offsetPath:[self energystartingPathWithBounds:[self.layerss[@"energystarting"] bounds]] by:CGPointMake(energystarting.frame.origin.x, energystarting.frame.origin.y)].CGPath;
    energyarrowPositionAnim.rotationMode   = kCAAnimationRotateAutoReverse;
    energyarrowPositionAnim.calculationMode = kCAAnimationCubicPaced;
    if(energyvaluee>0){
        energyarrowPositionAnim.duration       = 2.9;//2.9;//2.2;
        if(energyvaluee<3){
            energyarrowPositionAnim.duration       = 1.7;//2.2;
        }
        energyarrowPositionAnim.beginTime      = 37.5;
        
    }else{
        energyarrowPositionAnim.duration       = 0.1;
        energyarrowPositionAnim.beginTime      = 39;
    }
    
    
    if(energyvaluee==menergyvaluee){
        energyarrowPositionAnim.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0 :0.2 :0.63 :1];
        //    energyarrowPositionAnim.timingFunction = [CAMediaTimingFunction functionWithControlPoints:1 :1 :1 :1];
        // energyarrowPositionAnim.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0 :0.2 :0.63 :1];
        // energyarrowPositionAnim.beginTime      = 35.41;
    }
    else{
        energyarrowPositionAnim.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0 :0.2 :0.63 :1];
    }
    
    CAAnimationGroup * energyarrowUntitleAnim = [QCMethod groupAnimations:@[energyarrowOpacityAnim, energyarrowPositionAnim] fillMode:fillMode];
    [energyarrow addAnimation:energyarrowUntitleAnim forKey:@"energyarrowUntitleAnim"];
    
    
    
    
    
    
    ////Scores animation
    CAKeyframeAnimation * scoresOpacityAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    scoresOpacityAnim.values    = @[@1, @0];
    scoresOpacityAnim.keyTimes  = @[@0, @1];
    scoresOpacityAnim.duration  = 1;
    scoresOpacityAnim.beginTime = 49.1;
    
    CAAnimationGroup * scoresUntitled1Anim = [QCMethod groupAnimations:@[scoresOpacityAnim] fillMode:fillMode];
    [self.layerss[@"scores"] addAnimation:scoresUntitled1Anim forKey:@"scoresUntitled1Anim"];
    
    ////Energyscore animation
    CAKeyframeAnimation * energyscoreOpacityAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    energyscoreOpacityAnim.values   = @[@0, @0, @1, @1, @0];
    energyscoreOpacityAnim.keyTimes = @[@0, @0.685, @0.685, @0.982, @1];
    energyscoreOpacityAnim.duration = 54.7;
    energyscoreOpacityAnim.keyTimes = @[@0, @0.634, @0.647, @0.973, @1];
    energyscoreOpacityAnim.duration = 55.7;
    
    if(energyvaluee==0){
        energyscoreOpacityAnim.keyTimes = @[@0, @0.6435, @0.6436, @0.973, @1];
    }
    
    CATextLayer * energyscore = self.layerss[@"energyscore"];
    
    
    ////energy eveler animation
    CAKeyframeAnimation * levelerOpacityAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    levelerOpacityAnim.values   = @[@0, @0, @1];
    if(energyvaluee==menergyvaluee){
        levelerOpacityAnim.keyTimes = @[@0, @0.999, @1];
    }
    else{
        levelerOpacityAnim.keyTimes = @[@0, @1, @1];
    }
    levelerOpacityAnim.duration = 37.7;
    
    CAShapeLayer * leveler = self.layerss[@"energyleveler"];
    
    CAKeyframeAnimation * levelerPositionAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    levelerPositionAnim.path            = [QCMethod offsetPath:[self energystartinggPathWithBounds:[self.layerss[@"energystarting"] bounds]] by:CGPointMake(energystarting.frame.origin.x, energystarting.frame.origin.y)].CGPath;
    levelerPositionAnim.rotationMode    = kCAAnimationRotateAutoReverse;
    levelerPositionAnim.calculationMode = kCAAnimationCubicPaced;
    levelerPositionAnim.duration        = 2.9;//2.9;
    levelerPositionAnim.beginTime       = 37.5;
    levelerPositionAnim.timingFunction  = [CAMediaTimingFunction functionWithControlPoints:0 :0.2 :0.63 :1];
    
    CAAnimationGroup * levelerUntitleAnim = [QCMethod groupAnimations:@[levelerOpacityAnim, levelerPositionAnim] fillMode:fillMode];
    [leveler addAnimation:levelerUntitleAnim forKey:@"levelerUntitleAnim"];
    
    
    ////Waterleveler animation
    CAKeyframeAnimation * waterlevelerOpacityAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    waterlevelerOpacityAnim.values   = @[@0, @0, @1];
    if(watervaluee==mwatervaluee){
        waterlevelerOpacityAnim.keyTimes = @[@0, @0.99, @1];
    }else{
        waterlevelerOpacityAnim.keyTimes = @[@0, @1, @1];
    }
    waterlevelerOpacityAnim.duration = 32.2;
    CAKeyframeAnimation * waterlevelerPositionAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    waterlevelerPositionAnim.path         = [QCMethod offsetPath:[self waterstartinggPathWithBounds:[self.layerss[@"waterstarting"] bounds]] by:CGPointMake(waterstarting.frame.origin.x,waterstarting.frame.origin.y)].CGPath;
    waterlevelerPositionAnim.rotationMode = kCAAnimationRotateAutoReverse;
    waterlevelerPositionAnim.calculationMode = kCAAnimationCubicPaced;
    waterlevelerPositionAnim.duration     = 2.9;
    waterlevelerPositionAnim.beginTime    = 32;
    waterlevelerPositionAnim.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0 :0.2 :0.63 :1];
    
    CAAnimationGroup * waterlevelerUntitleAnim = [QCMethod groupAnimations:@[waterlevelerOpacityAnim, waterlevelerPositionAnim] fillMode:fillMode];
    [waterleveler addAnimation:waterlevelerUntitleAnim forKey:@"waterlevelerUntitleAnim"];
    
    ////Wasteleveler animation
    CAKeyframeAnimation * wastelevelerOpacityAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    wastelevelerOpacityAnim.values   = @[@0, @0, @1];
    if(wastevaluee==mwastevaluee){
        wastelevelerOpacityAnim.keyTimes = @[@0, @0.99, @1];
    }else{
        wastelevelerOpacityAnim.keyTimes = @[@0, @1, @1];
    }
    wastelevelerOpacityAnim.duration = 26.2;
    
    
    CAKeyframeAnimation * wastelevelerPositionAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    wastelevelerPositionAnim.path         = [QCMethod offsetPath:[self wastestartinggPathWithBounds:[self.layerss[@"wastestarting"] bounds]] by:CGPointMake(wastestarting.frame.origin.x,wastestarting.frame.origin.y)].CGPath;
    wastelevelerPositionAnim.rotationMode = kCAAnimationRotateAutoReverse;
    wastelevelerPositionAnim.calculationMode = kCAAnimationCubicPaced;
    wastelevelerPositionAnim.duration     = 2.9;
    wastelevelerPositionAnim.beginTime    = 26;
    wastelevelerPositionAnim.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0 :0.2 :0.63 :1];
    
    CAAnimationGroup * wastelevelerUntitleAnim = [QCMethod groupAnimations:@[wastelevelerOpacityAnim, wastelevelerPositionAnim] fillMode:fillMode];
    [wasteleveler addAnimation:wastelevelerUntitleAnim forKey:@"wastelevelerUntitleAnim"];
    
    
    ////Transportleveler animation
    CAKeyframeAnimation * transportlevelerOpacityAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    transportlevelerOpacityAnim.values   = @[@0, @0, @1];
    if(transportvaluee==mtransportvaluee){
        transportlevelerOpacityAnim.keyTimes = @[@0, @0.99, @1];
    }else{
        transportlevelerOpacityAnim.keyTimes = @[@0, @1, @1];
    }
    transportlevelerOpacityAnim.duration = 19.9;
    
    
    CAKeyframeAnimation * transportlevelerPositionAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    transportlevelerPositionAnim.path      = [QCMethod offsetPath:[self transportstartinggPathWithBounds:[self.layerss[@"transportstarting"] bounds]] by:CGPointMake(transportstarting.frame.origin.x,transportstarting.frame.origin.y)].CGPath;
    transportlevelerPositionAnim.rotationMode = kCAAnimationRotateAutoReverse;
    transportlevelerPositionAnim.calculationMode = kCAAnimationCubicPaced;
    transportlevelerPositionAnim.duration  = 2.9;
    transportlevelerPositionAnim.beginTime = 19.7;
    transportlevelerPositionAnim.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0 :0.2 :0.63 :1];
    
    CAAnimationGroup * transportlevelerUntitleAnim = [QCMethod groupAnimations:@[transportlevelerOpacityAnim, transportlevelerPositionAnim] fillMode:fillMode];
    [transportleveler addAnimation:transportlevelerUntitleAnim forKey:@"transportlevelerUntitleAnim"];
    
    
    ////Humanleveler animation
    CAKeyframeAnimation * humanlevelerOpacityAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    /* humanlevelerOpacityAnim.values   = @[@0, @0, @1, @1];
     if(humanvaluee==mhumanvaluee){
     humanlevelerOpacityAnim.keyTimes = @[@0, @0.9755, @0.982, @1];
     }
     else{
     humanlevelerOpacityAnim.keyTimes = @[@0, @1, @1, @1];
     
     }
     humanlevelerOpacityAnim.duration = 15.627;*/
    humanlevelerOpacityAnim.values   = @[@0, @0, @1];
    if(humanvaluee==mhumanvaluee){
        humanlevelerOpacityAnim.keyTimes = @[@0, @0.999, @1];
    }else{
        humanlevelerOpacityAnim.keyTimes = @[@0, @1, @1];
    }
    humanlevelerOpacityAnim.duration = 13.6;
    
    CAKeyframeAnimation * humanlevelerPositionAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    humanlevelerPositionAnim.path         = [QCMethod offsetPath:[self humanstartinggPathWithBounds:[self.layerss[@"humanstarting"] bounds]] by:CGPointMake(humanstarting.frame.origin.x,humanstarting.frame.origin.y)].CGPath;
    humanlevelerPositionAnim.rotationMode = kCAAnimationRotateAutoReverse;
    humanlevelerPositionAnim.calculationMode = kCAAnimationCubicPaced;
    humanlevelerPositionAnim.duration     = 2.9;//2.2;
    humanlevelerPositionAnim.beginTime    = 13.4;
    
    humanlevelerPositionAnim.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0 :0.2 :0.63 :1];
    
    
    CAAnimationGroup * humanlevelerUntitleAnim = [QCMethod groupAnimations:@[humanlevelerOpacityAnim,humanlevelerPositionAnim] fillMode:fillMode];
    [humanleveler addAnimation:humanlevelerUntitleAnim forKey:@"humanlevelerUntitleAnim"];
    
    
    
    //~~~~
    
    
    //    CAShapeLayer * energystarting          = self.layerss[@"energystarting"];
    CAKeyframeAnimation * energyscorePositionAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    energyscorePositionAnim.path           = [QCMethod offsetPath:[self energystartinggPathWithBounds:[self.layerss[@"energystarting"] bounds]] by:CGPointMake(energystarting.frame.origin.x, energystarting.frame.origin.y)].CGPath;
    energyscorePositionAnim.calculationMode = kCAAnimationCubicPaced;
    if(energyvaluee>0){
        energyscorePositionAnim.duration       = 2.9;//2.2;
        if(energyvaluee<3){
            energyscorePositionAnim.duration       = 1.7;//2.2;
        }
        energyscorePositionAnim.beginTime      = 37.5;
    }else{
        energyscorePositionAnim.duration       = 0.1;
        energyscorePositionAnim.beginTime      = 38;
    }
    energyscorePositionAnim.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0 :0.2 :0.63 :1];
    
    if(energyvaluee==menergyvaluee){
        energyscorePositionAnim.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0 :0.2 :0.63 :1];
    }
    
    CAAnimationGroup * energyscoreUntitled1Anim = [QCMethod groupAnimations:@[energyscoreOpacityAnim,energyscorePositionAnim] fillMode:fillMode];
    [energyscore addAnimation:energyscoreUntitled1Anim forKey:@"energyscoreUntitled1Anim"];
    
    CATextLayer * waterscore = self.layerss[@"waterscore"];
    
    ////Waterscore animation
    //  CAShapeLayer * waterstarting           = self.layerss[@"waterstarting"];
    CAKeyframeAnimation * waterscorePositionAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    waterscorePositionAnim.path            = [QCMethod offsetPath:[self waterstartinggPathWithBounds:[self.layerss[@"waterstarting"] bounds]] by:CGPointMake(waterstarting.frame.origin.x, waterstarting.frame.origin.y)].CGPath;
    waterscorePositionAnim.calculationMode = kCAAnimationCubicPaced;
    if(watervaluee>0){
        waterscorePositionAnim.duration        = 2.9;//2.2;
        if(watervaluee<3){
            waterscorePositionAnim.duration        = 1.7;//2.2;
        }
        waterscorePositionAnim.beginTime       = 32;
    }else{
        waterscorePositionAnim.duration        = 0.1;
        waterscorePositionAnim.beginTime       = 32.5;
    }
    waterscorePositionAnim.timingFunction  = [CAMediaTimingFunction functionWithControlPoints:0 :0.2 :0.63 :1];
    
    CAKeyframeAnimation * waterscoreOpacityAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    waterscoreOpacityAnim.values   = @[@0, @0, @1, @1, @0];
    waterscoreOpacityAnim.keyTimes = @[@0, @0.585, @0.585, @0.982, @1];
    waterscoreOpacityAnim.duration = 54.7;
    waterscoreOpacityAnim.keyTimes = @[@0, @0.525, @0.54, @0.973, @1];
    waterscoreOpacityAnim.duration = 55.7;
    if(watervaluee==0){
        waterscoreOpacityAnim.keyTimes = @[@0, @0.534, @0.5341, @0.973, @1];
    }
    
    
    CAAnimationGroup * waterscoreUntitled1Anim = [QCMethod groupAnimations:@[waterscoreOpacityAnim,waterscorePositionAnim] fillMode:fillMode];
    [waterscore addAnimation:waterscoreUntitled1Anim forKey:@"waterscoreUntitled1Anim"];
    
    ////Wastescore animation
    CAKeyframeAnimation * wastescoreOpacityAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    wastescoreOpacityAnim.values   = @[@0, @0, @1, @1, @0];
    wastescoreOpacityAnim.keyTimes = @[@0, @0.475, @0.475, @0.982, @1];
    wastescoreOpacityAnim.duration = 54.7;
    CATextLayer * wastescore = self.layerss[@"wastescore"];
    
    // CAShapeLayer * wastestarting           = self.layerss[@"wastestarting"];
    CAKeyframeAnimation * wastescorePositionAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    wastescorePositionAnim.path            = [QCMethod offsetPath:[self wastestartinggPathWithBounds:[self.layerss[@"wastestarting"] bounds]] by:CGPointMake(wastestarting.frame.origin.x,wastestarting.frame.origin.y)].CGPath;
    wastescorePositionAnim.calculationMode = kCAAnimationCubicPaced;
    wastescoreOpacityAnim.keyTimes = @[@0, @0.42, @0.434, @0.973, @1];
    wastescoreOpacityAnim.duration = 55.7;
    if(wastevaluee>0){
        wastescorePositionAnim.duration        = 2.9;//2.2;
        if(wastevaluee<3){
            wastescorePositionAnim.duration        = 1.7;//2.2;
        }
        wastescorePositionAnim.beginTime       = 26;
    }
    else{
        wastescorePositionAnim.duration        = 0.1;
        wastescorePositionAnim.beginTime       = 26.5;
        wastescoreOpacityAnim.keyTimes = @[@0, @0.4294, @0.4295, @0.973, @1];
        
    }
    
    
    wastescorePositionAnim.timingFunction  = [CAMediaTimingFunction functionWithControlPoints:0 :0.2 :0.63 :1];
    
    CAAnimationGroup * wastescoreUntitled1Anim = [QCMethod groupAnimations:@[wastescoreOpacityAnim, wastescorePositionAnim] fillMode:fillMode];
    [wastescore addAnimation:wastescoreUntitled1Anim forKey:@"wastescoreUntitled1Anim"];
    
    CATextLayer * transportscore = self.layerss[@"transportscore"];
    
    ////Transportscore animation
    // CAShapeLayer * transportstarting     = self.layerss[@"transportstarting"];
    CAKeyframeAnimation * transportscorePositionAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    transportscorePositionAnim.path      = [QCMethod offsetPath:[self transportstartinggPathWithBounds:[self.layerss[@"transportstarting"] bounds]] by:CGPointMake(transportstarting.frame.origin.x,transportstarting.frame.origin.y)].CGPath;
    transportscorePositionAnim.calculationMode = kCAAnimationCubicPaced;
    if(transportvaluee>0){
        transportscorePositionAnim.duration  = 2.9;//2.2;
        transportscorePositionAnim.beginTime = 19.7;
        if(transportvaluee<3){
            transportscorePositionAnim.duration=1.7;
        }
    }else{
        transportscorePositionAnim.duration  = 0.1;
        transportscorePositionAnim.beginTime = 20.2;
    }
    transportscorePositionAnim.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0 :0.2 :0.63 :1];
    
    CAKeyframeAnimation * transportscoreOpacityAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    transportscoreOpacityAnim.values   = @[@0, @0, @1, @1, @0];
    transportscoreOpacityAnim.keyTimes = @[@0, @0.36, @0.36, @0.982, @1];
    transportscoreOpacityAnim.duration = 54.7;
    transportscoreOpacityAnim.keyTimes = @[@0, @0.306, @0.321, @0.973, @1];
    transportscoreOpacityAnim.duration = 55.7;
    if(transportvaluee==0){
        transportscoreOpacityAnim.keyTimes = @[@0, @0.3141, @0.3142, @0.973, @1];
    }
    
    
    transportscoreOpacityAnim.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0 :0 :1 :1];
    
    CAAnimationGroup * transportscoreUntitled1Anim = [QCMethod groupAnimations:@[transportscoreOpacityAnim,transportscorePositionAnim] fillMode:fillMode];
    [transportscore addAnimation:transportscoreUntitled1Anim forKey:@"transportscoreUntitled1Anim"];
    
    ////Humanstartarrow animation
    CAKeyframeAnimation * humanstartarrowOpacityAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    humanstartarrowOpacityAnim.values   = @[@0, @0, @1];
    humanstartarrowOpacityAnim.keyTimes = @[@0, @0.997, @1];
    humanstartarrowOpacityAnim.duration = 13.1;
    
    CAShapeLayer * humanstartarrow = self.layerss[@"humanstartarrow"];
    
    CAShapeLayer * humanstartline         = self.layerss[@"humanstartline"];
    CAKeyframeAnimation * humanstartarrowPositionAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    humanstartarrowPositionAnim.path      = [QCMethod offsetPath:[self humanstartlinePathWithBounds:[self.layerss[@"humanstartline"] bounds]] by:CGPointMake(humanstartline.frame.origin.x,humanstartline.frame.origin.y)].CGPath;
    humanstartarrowPositionAnim.calculationMode = kCAAnimationCubicPaced;
    humanstartarrowPositionAnim.duration  = 0.5;
    humanstartarrowPositionAnim.beginTime = 12.9;
    if(humanvaluee>0){
    }
    else{
        humanstartarrowPositionAnim.duration  = 1;
    }
    
    if(humanvaluee!=0){
        humanstartarrowPositionAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    }else{
        humanstartarrowPositionAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    }
    CAAnimationGroup * humanstartarrowUntitleAnim = [QCMethod groupAnimations:@[humanstartarrowOpacityAnim, humanstartarrowPositionAnim] fillMode:fillMode];
    [humanstartarrow addAnimation:humanstartarrowUntitleAnim forKey:@"humanstartarrowUntitleAnim"];
    
    ////Humanscore animation
    CAKeyframeAnimation * humanscoreOpacityAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    humanscoreOpacityAnim.values   = @[@0, @0, @1, @1, @0];
    humanscoreOpacityAnim.keyTimes = @[@0, @0.245, @0.245, @0.982, @1];
    humanscoreOpacityAnim.keyTimes = @[@0, @0.201, @0.215, @0.973, @1];
    humanscoreOpacityAnim.duration = 55.7;
    if(humanvaluee==0){
        humanscoreOpacityAnim.keyTimes = @[@0, @0.2101, @0.2102, @0.973, @1];
    }
    
    
    //12.9,1.5
    CATextLayer * humanscore = self.layerss[@"humanscore"];
    
    //  CAShapeLayer * humanstarting           = self.layerss[@"humanstarting"];
    CAKeyframeAnimation * humanscorePositionAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    humanscorePositionAnim.path            = [QCMethod offsetPath:[self humanstartinggPathWithBounds:[self.layerss[@"humanstarting"] bounds]] by:CGPointMake(humanstarting.frame.origin.x, humanstarting.frame.origin.y)].CGPath;
    humanscorePositionAnim.calculationMode = kCAAnimationCubicPaced;
    humanscorePositionAnim.duration        = 2.9;//2.2;
    humanscorePositionAnim.beginTime       = 13.4;
    if(humanvaluee==0){
        humanscorePositionAnim.duration        = 0.1;//2.2;
        humanscorePositionAnim.beginTime       = 13.9;
    }
    //0,0.2,0.63,1
    humanscorePositionAnim.timingFunction  = [CAMediaTimingFunction functionWithControlPoints:0 :0.2 :0.63 :1];
    
    CAAnimationGroup * humanscoreUntitled1Anim = [QCMethod groupAnimations:@[humanscoreOpacityAnim,humanscorePositionAnim] fillMode:fillMode];
    [humanscore addAnimation:humanscoreUntitled1Anim forKey:@"humanscoreUntitled1Anim"];
    
    CALayer * plaque_coin = self.layerss[@"plaque_coin"];
    
    ////Plaque_coin animation
    CAKeyframeAnimation * plaque_coinTransformAnim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    plaque_coinTransformAnim.values    = @[[NSValue valueWithCATransform3D:CATransform3DIdentity],
                                           [NSValue valueWithCATransform3D:CATransform3DIdentity],
                                           [NSValue valueWithCATransform3D:CATransform3DIdentity],
                                           [NSValue valueWithCATransform3D:CATransform3DIdentity],
                                           [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.03, 1, 1)],
                                           [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    /*  plaque_coinTransformAnim.keyTimes  = @[@0, @0.00295, @0.00589, @0.994, @0.997, @1];
     plaque_coinTransformAnim.duration  = 58.4;
     plaque_coinTransformAnim.beginTime = 6;*/
    plaque_coinTransformAnim.keyTimes  = @[@0, @0.00271, @0.00542, @0.994, @0.997, @1];
    plaque_coinTransformAnim.duration  = 63.5;
    plaque_coinTransformAnim.beginTime = 6;
    
    CAAnimationGroup * plaque_coinUntitled1Anim = [QCMethod groupAnimations:@[plaque_coinTransformAnim] fillMode:fillMode];
    [plaque_coin addAnimation:plaque_coinUntitled1Anim forKey:@"plaque_coinUntitled1Anim"];
    
    ////Energyboom animation
    int a,b,n1,n2,n3,n4,n5;
    CALayer *pl=self.layerss[@"platinum"];
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if(orientation == UIInterfaceOrientationLandscapeLeft){
        // Do something if Left
        a=14*(self.frame.size.height/21.5)*(self.bounds.size.height/height1); //58
        b=15*(self.frame.size.height/21.5)*(self.bounds.size.height/height1); //61
        a=0.78*pl.bounds.size.width;
        b=0.81*pl.bounds.size.width;
        n1=13*(self.frame.size.height/21.5)*(self.bounds.size.height/height1);
        n2=12*(self.frame.size.height/21.5)*(self.bounds.size.height/height1);
        n3=11*(self.frame.size.height/21.5)*(self.bounds.size.height/height1);
        n4=10*(self.frame.size.height/21.5)*(self.bounds.size.height/height1);
        n5=9*(self.frame.size.height/21.5)*(self.bounds.size.height/height1);
        n1=0.7*pl.bounds.size.width;
        n2=0.6*pl.bounds.size.width;
        n3=0.5*pl.bounds.size.width;
        n4=0.4*pl.bounds.size.width;
        n5=0.3*pl.bounds.size.width;
        
        
    }
    else if(orientation == UIInterfaceOrientationLandscapeRight){
        a=14*(self.frame.size.height/21.5)*(self.bounds.size.height/height1);
        b=15*(self.frame.size.height/21.5)*(self.bounds.size.height/height1);
        a=0.78*pl.bounds.size.width;
        b=0.81*pl.bounds.size.width;
        n1=13*(self.frame.size.height/21.5)*(self.bounds.size.height/height1);
        n2=12*(self.frame.size.height/21.5)*(self.bounds.size.height/height1);
        n3=11*(self.frame.size.height/21.5)*(self.bounds.size.height/height1);
        n4=10*(self.frame.size.height/21.5)*(self.bounds.size.height/height1);
        n5=9*(self.frame.size.height/21.5)*(self.bounds.size.height/height1);
        
        n1=0.7*pl.bounds.size.width;
        n2=0.6*pl.bounds.size.width;
        n3=0.5*pl.bounds.size.width;
        n4=0.4*pl.bounds.size.width;
        n5=0.3*pl.bounds.size.width;
    }
    else{
        
        NSLog(@"platinum %f",pl.bounds.size.width);
        a=14*(self.frame.size.width/12)*(self.bounds.size.width/width1);
        a=((0.06*self.frame.size.width)/50)*a;
        b=15*(self.frame.size.width/12)*(self.bounds.size.width/width1);
        b=((0.06*self.frame.size.width)/50)*b;
        a=0.78*pl.bounds.size.width;
        b=0.81*pl.bounds.size.width;
        
        n1=13*(self.frame.size.width/12)*(self.bounds.size.width/width1);
        n2=12*(self.frame.size.width/12)*(self.bounds.size.width/width1);
        n3=11*(self.frame.size.width/12)*(self.bounds.size.width/width1);
        n4=10*(self.frame.size.width/12)*(self.bounds.size.width/width1);
        n5=9*(self.frame.size.width/12)*(self.bounds.size.width/width1);
        
        n1=0.7*pl.bounds.size.width;
        n2=0.6*pl.bounds.size.width;
        n3=0.5*pl.bounds.size.width;
        n4=0.4*pl.bounds.size.width;
        n5=0.3*pl.bounds.size.width;
        
    }
    
    
    NSLog(@"n1 %d %d %d %d %d",n1,n2,n3,n4,n5);
    
    
    NSLog(@"Line width %d %d",a,b);
    /*
     CAKeyframeAnimation * energyboomLineWidthAnim = [CAKeyframeAnimation animationWithKeyPath:@"lineWidth"];
     
     if(initiall==YES){
     energyboomLineWidthAnim.values   = @[@1, @1, [NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:b], [NSNumber numberWithInt:b], [NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:b], [NSNumber numberWithInt:b], [NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:b], [NSNumber numberWithInt:b], [NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:b], [NSNumber numberWithInt:b], [NSNumber numberWithInt:a], [NSNumber numberWithInt:n5], @1, @1, [NSNumber numberWithInt:a], [NSNumber numberWithInt:a]];
     }
     else{
     energyboomLineWidthAnim.values   = @[[NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:b], [NSNumber numberWithInt:b], [NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:b], [NSNumber numberWithInt:b], [NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:b], [NSNumber numberWithInt:b], [NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:b], [NSNumber numberWithInt:b], [NSNumber numberWithInt:a], [NSNumber numberWithInt:n5], @1, @1, [NSNumber numberWithInt:a], [NSNumber numberWithInt:a]];
     }
     energyboomLineWidthAnim.keyTimes = @[@0, @0.00143, @0.00133, @0.0221, @0.0298, @0.0398, @0.0464, @0.0608, @0.0674, @0.0774, @0.084, @0.106, @0.113, @0.123, @0.13, @0.144, @0.15, @0.159, @0.165, @0.169, @0.174, @0.992, @0.993, @1];
     energyboomLineWidthAnim.duration = 65.2;
     
     CAAnimationGroup * energyboomUntitled1Anim = [QCMethod groupAnimations:@[energyboomLineWidthAnim] fillMode:fillMode];
     [self.layerss[@"energyboom"] addAnimation:energyboomUntitled1Anim forKey:@"energyboomUntitled1Anim"];
     
     ////Waterboom animation
     CAKeyframeAnimation * waterboomLineWidthAnim = [CAKeyframeAnimation animationWithKeyPath:@"lineWidth"];
     
     if(initiall==YES){
     waterboomLineWidthAnim.values   =@[@1, @1, [NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:b], [NSNumber numberWithInt:b], [NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:b], [NSNumber numberWithInt:b], [NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:b], [NSNumber numberWithInt:b], [NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:b], [NSNumber numberWithInt:b], [NSNumber numberWithInt:a], [NSNumber numberWithInt:n4], @1, @1, [NSNumber numberWithInt:a], [NSNumber numberWithInt:a]];
     }else{
     waterboomLineWidthAnim.values   =@[[NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:b], [NSNumber numberWithInt:b], [NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:b], [NSNumber numberWithInt:b], [NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:b], [NSNumber numberWithInt:b], [NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:b], [NSNumber numberWithInt:b], [NSNumber numberWithInt:a], [NSNumber numberWithInt:n4], @1, @1, [NSNumber numberWithInt:a], [NSNumber numberWithInt:a]];
     }
     
     waterboomLineWidthAnim.keyTimes = @[@0, @0.00143, @0.00133, @0.0221, @0.0298, @0.0398, @0.0464, @0.0608, @0.0674, @0.0774, @0.084, @0.106, @0.113, @0.123, @0.13, @0.144, @0.15, @0.159, @0.165, @0.169, @0.174, @0.993, @0.994, @1];
     waterboomLineWidthAnim.duration = 65.2;
     
     CAAnimationGroup * waterboomUntitled1Anim = [QCMethod groupAnimations:@[waterboomLineWidthAnim] fillMode:fillMode];
     [self.layerss[@"waterboom"] addAnimation:waterboomUntitled1Anim forKey:@"waterboomUntitled1Anim"];
     
     ////Wasteboom animation
     CAKeyframeAnimation * wasteboomLineWidthAnim = [CAKeyframeAnimation animationWithKeyPath:@"lineWidth"];
     if(initiall==YES){
     wasteboomLineWidthAnim.values   = @[@1, @1, [NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:b], [NSNumber numberWithInt:b], [NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:b], [NSNumber numberWithInt:b], [NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:b], [NSNumber numberWithInt:b], [NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:b], [NSNumber numberWithInt:b], [NSNumber numberWithInt:a], [NSNumber numberWithInt:n3], @1, @1, [NSNumber numberWithInt:a], [NSNumber numberWithInt:a]];
     }
     else{
     wasteboomLineWidthAnim.values   = @[[NSNumber numberWithInt:a],[NSNumber numberWithInt:a],[NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:b], [NSNumber numberWithInt:b], [NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:b], [NSNumber numberWithInt:b], [NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:b], [NSNumber numberWithInt:b], [NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:b], [NSNumber numberWithInt:b], [NSNumber numberWithInt:a], [NSNumber numberWithInt:n3], @1, @1, [NSNumber numberWithInt:a], [NSNumber numberWithInt:a]];
     }
     
     wasteboomLineWidthAnim.keyTimes = @[@0, @0.00143, @0.00133, @0.0221, @0.0298, @0.0398, @0.0464, @0.0608, @0.0674, @0.0774, @0.084, @0.106, @0.113, @0.123, @0.13, @0.144, @0.15, @0.159, @0.165, @0.169, @0.174, @0.993, @0.995, @1];
     wasteboomLineWidthAnim.duration = 65.2;
     
     CAAnimationGroup * wasteboomUntitled1Anim = [QCMethod groupAnimations:@[wasteboomLineWidthAnim] fillMode:fillMode];
     [self.layerss[@"wasteboom"] addAnimation:wasteboomUntitled1Anim forKey:@"wasteboomUntitled1Anim"];
     
     ////Transportboom animation
     CAKeyframeAnimation * transportboomLineWidthAnim = [CAKeyframeAnimation animationWithKeyPath:@"lineWidth"];
     if(initiall==YES){
     transportboomLineWidthAnim.values   = @[@1, @1, [NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:b], [NSNumber numberWithInt:b], [NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:b], [NSNumber numberWithInt:b], [NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:b], [NSNumber numberWithInt:b], [NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:b], [NSNumber numberWithInt:b], [NSNumber numberWithInt:a], [NSNumber numberWithInt:n2], @1, @1, [NSNumber numberWithInt:a], [NSNumber numberWithInt:a]];
     }
     else{
     transportboomLineWidthAnim.values   = @[[NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:b], [NSNumber numberWithInt:b], [NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:b], [NSNumber numberWithInt:b], [NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:b], [NSNumber numberWithInt:b], [NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:b], [NSNumber numberWithInt:b], [NSNumber numberWithInt:a], [NSNumber numberWithInt:n2], @1, @1, [NSNumber numberWithInt:a], [NSNumber numberWithInt:a]];
     }
     transportboomLineWidthAnim.keyTimes = @[@0, @0.00143, @0.00133, @0.0221, @0.0298, @0.0398, @0.0464, @0.0608, @0.0674, @0.0774, @0.084, @0.106, @0.113, @0.123, @0.13, @0.144, @0.15, @0.159, @0.165, @0.169, @0.174, @0.994, @0.996, @1];
     transportboomLineWidthAnim.duration = 65.2;
     
     CAAnimationGroup * transportboomUntitled1Anim = [QCMethod groupAnimations:@[transportboomLineWidthAnim] fillMode:fillMode];
     [self.layerss[@"transportboom"] addAnimation:transportboomUntitled1Anim forKey:@"transportboomUntitled1Anim"];
     
     ////Humanboom animation
     CAKeyframeAnimation * humanboomLineWidthAnim = [CAKeyframeAnimation animationWithKeyPath:@"lineWidth"];
     if(initiall==YES){
     humanboomLineWidthAnim.values   = @[@1, @1, [NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:b], [NSNumber numberWithInt:b], [NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:b], [NSNumber numberWithInt:b], [NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:b], [NSNumber numberWithInt:b], [NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:b], [NSNumber numberWithInt:b], [NSNumber numberWithInt:a], [NSNumber numberWithInt:n1], @1, @1, [NSNumber numberWithInt:a], [NSNumber numberWithInt:a]];
     }
     else{
     humanboomLineWidthAnim.values   = @[[NSNumber numberWithInt:a],[NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:b], [NSNumber numberWithInt:b], [NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:b], [NSNumber numberWithInt:b], [NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:b], [NSNumber numberWithInt:b], [NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:b], [NSNumber numberWithInt:b], [NSNumber numberWithInt:a], [NSNumber numberWithInt:n1], @1, @1, [NSNumber numberWithInt:a], [NSNumber numberWithInt:a]];
     }
     humanboomLineWidthAnim.keyTimes = @[@0, @0.00143, @0.00133, @0.0221, @0.0298, @0.0398, @0.0464, @0.0608, @0.0674, @0.0774, @0.084, @0.106, @0.113, @0.123, @0.13, @0.144, @0.15, @0.159, @0.165, @0.169, @0.174, @0.992, @0.996, @1];
     humanboomLineWidthAnim.duration = 65.2;
     
     CAAnimationGroup * humanboomUntitled1Anim = [QCMethod groupAnimations:@[humanboomLineWidthAnim] fillMode:fillMode];
     [self.layerss[@"humanboom"] addAnimation:humanboomUntitled1Anim forKey:@"humanboomUntitled1Anim"];
     */
    
    
    ////Energyboom animation
    
    CAKeyframeAnimation * energyboomLineWidthAnim = [CAKeyframeAnimation animationWithKeyPath:@"lineWidth"];
    if(initiall==YES){
        energyboomLineWidthAnim.values   = @[@1, [NSNumber numberWithInt:b], [NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:b], [NSNumber numberWithInt:b], [NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:b], [NSNumber numberWithInt:b], [NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:b], [NSNumber numberWithInt:b], [NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:b], [NSNumber numberWithInt:b], [NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:n5], @1, @1, [NSNumber numberWithInt:a], [NSNumber numberWithInt:a]];
    }else{
        energyboomLineWidthAnim.values   = @[[NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:b], [NSNumber numberWithInt:b], [NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:b], [NSNumber numberWithInt:b], [NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:b], [NSNumber numberWithInt:b], [NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:b], [NSNumber numberWithInt:b], [NSNumber numberWithInt:a],[NSNumber numberWithInt:a], [NSNumber numberWithInt:n5], @1, @1, [NSNumber numberWithInt:a], [NSNumber numberWithInt:a]];
    }
    //    energyboomLineWidthAnim.keyTimes = @[@0, @0.00175, @0.00712, @0.0205, @0.0277, @0.037, @0.0431, @0.0564, @0.0626, @0.0719, @0.078, @0.0987, @0.105, @0.114, @0.12, @0.134, @0.14, @0.147, @0.153, @0.157, @0.161, @0.992, @0.993, @1];
    energyboomLineWidthAnim.keyTimes = @[@0, @0.00548, @0.00719, @0.0205, @0.0277, @0.037, @0.0431, @0.0564, @0.0626, @0.0719, @0.078, @0.0987, @0.105, @0.114, @0.12, @0.134, @0.14, @0.147, @0.153, @0.158, @0.161,@0.164, @0.992, @0.993, @1];
    energyboomLineWidthAnim.duration = 70.2;
    
    CAAnimationGroup * energyboomUntitled1Anim = [QCMethod groupAnimations:@[energyboomLineWidthAnim] fillMode:fillMode];
    [self.layerss[@"energyboom"] addAnimation:energyboomUntitled1Anim forKey:@"energyboomUntitled1Anim"];
    
    ////Wasteboom animation
    CAKeyframeAnimation * wasteboomLineWidthAnim = [CAKeyframeAnimation animationWithKeyPath:@"lineWidth"];
    if(initiall==YES){
        wasteboomLineWidthAnim.values   = @[@1, [NSNumber numberWithInt:b], [NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:b], [NSNumber numberWithInt:b], [NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:b], [NSNumber numberWithInt:b], [NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:b], [NSNumber numberWithInt:b], [NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:b], [NSNumber numberWithInt:b], [NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:n3], @1, @1, [NSNumber numberWithInt:a], [NSNumber numberWithInt:a]];
    }else{
        wasteboomLineWidthAnim.values   = @[[NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:b], [NSNumber numberWithInt:b], [NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:b], [NSNumber numberWithInt:b], [NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:b], [NSNumber numberWithInt:b], [NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:b], [NSNumber numberWithInt:b], [NSNumber numberWithInt:a],[NSNumber numberWithInt:a], [NSNumber numberWithInt:n3], @1, @1, [NSNumber numberWithInt:a], [NSNumber numberWithInt:a]];
    }
    //    wasteboomLineWidthAnim.keyTimes = @[@0, @0.00175, @0.00712, @0.0205, @0.0277, @0.037, @0.0431, @0.0564, @0.0626, @0.0719, @0.078, @0.0987, @0.105, @0.114, @0.12, @0.134, @0.14, @0.147, @0.153, @0.157, @0.161, @0.993, @0.995, @1];
    wasteboomLineWidthAnim.keyTimes = @[@0, @0.00833, @0.01, @0.0205, @0.0277, @0.037, @0.0431, @0.0564, @0.0626, @0.0719, @0.078, @0.0987, @0.105, @0.114, @0.12, @0.134, @0.14, @0.147, @0.153, @0.158, @0.161,@0.164, @0.993, @0.995, @1];
    wasteboomLineWidthAnim.duration = 70.2;
    
    CAAnimationGroup * wasteboomUntitled1Anim = [QCMethod groupAnimations:@[wasteboomLineWidthAnim] fillMode:fillMode];
    [self.layerss[@"wasteboom"] addAnimation:wasteboomUntitled1Anim forKey:@"wasteboomUntitled1Anim"];
    
    ////Humanboom animation
    CAKeyframeAnimation * humanboomLineWidthAnim = [CAKeyframeAnimation animationWithKeyPath:@"lineWidth"];
    if(initiall==YES){
        humanboomLineWidthAnim.values   = @[@1, [NSNumber numberWithInt:b], [NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:b], [NSNumber numberWithInt:b], [NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:b], [NSNumber numberWithInt:b], [NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:b], [NSNumber numberWithInt:b], [NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:b], [NSNumber numberWithInt:b], [NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:n1], @1, @1, [NSNumber numberWithInt:a], [NSNumber numberWithInt:a]];
    }else{
        humanboomLineWidthAnim.values   = @[[NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:b], [NSNumber numberWithInt:b], [NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:b], [NSNumber numberWithInt:b], [NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:b], [NSNumber numberWithInt:b], [NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:b], [NSNumber numberWithInt:b], [NSNumber numberWithInt:a],[NSNumber numberWithInt:a], [NSNumber numberWithInt:n1], @1, @1, [NSNumber numberWithInt:a], [NSNumber numberWithInt:a]];
    }
    //   humanboomLineWidthAnim.keyTimes = @[@0, @0.00175, @0.00712, @0.0205, @0.0277, @0.037, @0.0431, @0.0564, @0.0626, @0.0719, @0.078, @0.0987, @0.105, @0.114, @0.12, @0.134, @0.14, @0.147, @0.153, @0.157, @0.161, @0.992, @0.996, @1];
    humanboomLineWidthAnim.keyTimes = @[@0, @0.0112, @0.0129, @0.0205, @0.0277, @0.037, @0.0431, @0.0564, @0.0626, @0.0719, @0.078, @0.0987, @0.105, @0.114, @0.12, @0.134, @0.14, @0.147, @0.153, @0.158, @0.161,@0.164, @0.992, @0.996, @1];
    humanboomLineWidthAnim.duration = 70.2;
    
    
    CAAnimationGroup * humanboomUntitled1Anim = [QCMethod groupAnimations:@[humanboomLineWidthAnim] fillMode:fillMode];
    [self.layerss[@"humanboom"] addAnimation:humanboomUntitled1Anim forKey:@"humanboomUntitled1Anim"];
    
    
    
    ////Transportboom animation
    CAKeyframeAnimation * transportboomLineWidthAnim = [CAKeyframeAnimation animationWithKeyPath:@"lineWidth"];
    if(initiall==YES){
        transportboomLineWidthAnim.values   = @[@1, [NSNumber numberWithInt:b], [NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:b], [NSNumber numberWithInt:b], [NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:b], [NSNumber numberWithInt:b], [NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:b], [NSNumber numberWithInt:b], [NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:b], [NSNumber numberWithInt:b], [NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:n2], @1, @1, [NSNumber numberWithInt:a], [NSNumber numberWithInt:a]];
    }else{
        transportboomLineWidthAnim.values   = @[[NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:b], [NSNumber numberWithInt:b], [NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:b], [NSNumber numberWithInt:b], [NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:b], [NSNumber numberWithInt:b], [NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:b], [NSNumber numberWithInt:b], [NSNumber numberWithInt:a],[NSNumber numberWithInt:a], [NSNumber numberWithInt:n2], @1, @1, [NSNumber numberWithInt:a], [NSNumber numberWithInt:a]];
    }
    // transportboomLineWidthAnim.keyTimes = @[@0, @0.00175, @0.00712, @0.0205, @0.0277, @0.037, @0.0431, @0.0564, @0.0626, @0.0719, @0.078, @0.0987, @0.105, @0.114, @0.12, @0.134, @0.14, @0.147, @0.153, @0.157, @0.161, @0.994, @0.996, @1];
    transportboomLineWidthAnim.keyTimes = @[@0, @0.00976, @0.0115, @0.0205, @0.0277, @0.037, @0.0431, @0.0564, @0.0626, @0.0719, @0.078, @0.0987, @0.105, @0.114, @0.12, @0.134, @0.14, @0.147, @0.153, @0.158, @0.161,@0.164, @0.994, @0.996, @1];
    transportboomLineWidthAnim.duration = 70.2;
    
    
    CAAnimationGroup * transportboomUntitled1Anim = [QCMethod groupAnimations:@[transportboomLineWidthAnim] fillMode:fillMode];
    [self.layerss[@"transportboom"] addAnimation:transportboomUntitled1Anim forKey:@"transportboomUntitled1Anim"];
    
    ////Waterboom animation
    CAKeyframeAnimation * waterboomLineWidthAnim = [CAKeyframeAnimation animationWithKeyPath:@"lineWidth"];
    if(initiall==YES){
        waterboomLineWidthAnim.values   = @[@1, [NSNumber numberWithInt:b], [NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:b], [NSNumber numberWithInt:b], [NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:b], [NSNumber numberWithInt:b], [NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:b], [NSNumber numberWithInt:b], [NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:b], [NSNumber numberWithInt:b], [NSNumber numberWithInt:a],[NSNumber numberWithInt:a], [NSNumber numberWithInt:n4], @1, @1, [NSNumber numberWithInt:a], [NSNumber numberWithInt:a]];
        
    }else{
        waterboomLineWidthAnim.values   = @[[NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:b], [NSNumber numberWithInt:b], [NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:b], [NSNumber numberWithInt:b], [NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:b], [NSNumber numberWithInt:b], [NSNumber numberWithInt:a], [NSNumber numberWithInt:a], [NSNumber numberWithInt:b], [NSNumber numberWithInt:b], [NSNumber numberWithInt:a],[NSNumber numberWithInt:a], [NSNumber numberWithInt:n4], @1, @1, [NSNumber numberWithInt:a], [NSNumber numberWithInt:a]];
    }
    //  waterboomLineWidthAnim.keyTimes = @[@0, @0.00175, @0.00712, @0.0205, @0.0277, @0.037, @0.0431, @0.0564, @0.0626, @0.0719, @0.078, @0.0987, @0.105, @0.114, @0.12, @0.134, @0.14, @0.147, @0.153, @0.157, @0.161, @0.993, @0.994, @1];
    waterboomLineWidthAnim.keyTimes = @[@0, @0.00691, @0.00862, @0.0205, @0.0277, @0.037, @0.0431, @0.0564, @0.0626, @0.0719, @0.078, @0.0987, @0.105, @0.114, @0.12, @0.134, @0.14, @0.147, @0.153, @0.158, @0.161, @0.164, @0.993, @0.994, @1];
    waterboomLineWidthAnim.duration = 70.2;
    
    CAAnimationGroup * waterboomUntitled1Anim = [QCMethod groupAnimations:@[waterboomLineWidthAnim] fillMode:fillMode];
    [self.layerss[@"waterboom"] addAnimation:waterboomUntitled1Anim forKey:@"waterboomUntitled1Anim"];
    
    
    
    ////Score animation
    CAKeyframeAnimation * scoreBoundsAnim = [CAKeyframeAnimation animationWithKeyPath:@"bounds"];
    scoreBoundsAnim.values                = @[[NSValue valueWithCGRect:CGRectMake(0, 0, 0.87209 * CGRectGetWidth(score.superlayer.bounds), 0.87209 * CGRectGetHeight(score.superlayer.bounds))], [NSValue valueWithCGRect:CGRectMake(0, 0, 0.87209 * CGRectGetWidth(score.superlayer.bounds), 0.87209 * CGRectGetHeight(score.superlayer.bounds))], [NSValue valueWithCGRect:CGRectMake(0, 0, 0.27907 * CGRectGetWidth(score.superlayer.bounds), 0.27907 * CGRectGetHeight(score.superlayer.bounds))], [NSValue valueWithCGRect:CGRectMake(0, 0, 0.27907 * CGRectGetWidth(score.superlayer.bounds), 0.27907 * CGRectGetHeight(score.superlayer.bounds))], [NSValue valueWithCGRect:CGRectMake(0, 0, 0.27907 * CGRectGetWidth(score.superlayer.bounds), 0.27907 * CGRectGetHeight(score.superlayer.bounds))], [NSValue valueWithCGRect:CGRectMake(0, 0, 0.87209 * CGRectGetWidth(score.superlayer.bounds), 0.87209 * CGRectGetHeight(score.superlayer.bounds))]];
    scoreBoundsAnim.keyTimes              = @[@0, @0.00505, @0.991, @0.996, @1];
    scoreBoundsAnim.duration              = 59.4;
    scoreBoundsAnim.beginTime             = 10.8;
    scoreBoundsAnim.keyTimes              = @[@0, @0.00505, @0.991, @0.998, @1];
    scoreBoundsAnim.duration              = 59.2;
    scoreBoundsAnim.beginTime             = 11;
    
    CAKeyframeAnimation * scoreHiddenAnim = [CAKeyframeAnimation animationWithKeyPath:@"hidden"];
    scoreHiddenAnim.values                = @[@NO, @YES];
    scoreHiddenAnim.keyTimes              = @[@0, @1];
    scoreHiddenAnim.duration              = 1;
    scoreHiddenAnim.beginTime             = 4.78;
    
    CAAnimationGroup * scoreUntitleAnim = [QCMethod groupAnimations:@[scoreBoundsAnim, scoreHiddenAnim] fillMode:fillMode];
    [score addAnimation:scoreUntitleAnim forKey:@"scoreUntitleAnim"];
    
    
    ////Platinum animation
    CAKeyframeAnimation * platinumBoundsAnim = [CAKeyframeAnimation animationWithKeyPath:@"bounds"];
    platinumBoundsAnim.values    = @[[NSValue valueWithCGRect:CGRectMake(0, 0, 0.87209 * CGRectGetWidth(platinum.superlayer.bounds), 0.87209 * CGRectGetHeight(platinum.superlayer.bounds))], [NSValue valueWithCGRect:CGRectMake(0, 0, 0.27907 * CGRectGetWidth(platinum.superlayer.bounds), 0.27907 * CGRectGetHeight(platinum.superlayer.bounds))], [NSValue valueWithCGRect:CGRectMake(0, 0, 0.27907 * CGRectGetWidth(platinum.superlayer.bounds), 0.27907 * CGRectGetHeight(platinum.superlayer.bounds))], [NSValue valueWithCGRect:CGRectMake(0, 0, 0.87209 * CGRectGetWidth(platinum.superlayer.bounds), 0.87209 * CGRectGetHeight(platinum.superlayer.bounds))]];
    /* platinumBoundsAnim.keyTimes  = @[@0, @0.00552, @0.99, @1];
     platinumBoundsAnim.duration  = 54.4;
     platinumBoundsAnim.beginTime = 10.8;*/
    /* platinumBoundsAnim.keyTimes              = @[@0, @0.00505, @0.991, @1]; better one
     platinumBoundsAnim.duration              = 59.4;
     platinumBoundsAnim.beginTime             = 10.8;*/
    platinumBoundsAnim.keyTimes              = @[@0, @0.00505, @0.991, @0.996, @1];
    platinumBoundsAnim.duration              = 59.4;
    platinumBoundsAnim.beginTime             = 10.8;
    platinumBoundsAnim.keyTimes              = @[@0, @0.00505, @0.991, @0.998, @1];
    platinumBoundsAnim.duration              = 59.2;
    platinumBoundsAnim.beginTime             = 11;
    
    CAAnimationGroup * platinumUntitled1Anim = [QCMethod groupAnimations:@[platinumBoundsAnim] fillMode:fillMode];
    [platinum addAnimation:platinumUntitled1Anim forKey:@"platinumUntitled1Anim"];
    
    ////Silver animation
    CAKeyframeAnimation * silverBoundsAnim = [CAKeyframeAnimation animationWithKeyPath:@"bounds"];
    silverBoundsAnim.values    = @[[NSValue valueWithCGRect:CGRectMake(0, 0, 0.87209 * CGRectGetWidth(silver.superlayer.bounds), 0.87209 * CGRectGetHeight(silver.superlayer.bounds))], [NSValue valueWithCGRect:CGRectMake(0, 0, 0.27907 * CGRectGetWidth(silver.superlayer.bounds), 0.27907 * CGRectGetHeight(silver.superlayer.bounds))], [NSValue valueWithCGRect:CGRectMake(0, 0, 0.27907 * CGRectGetWidth(silver.superlayer.bounds), 0.27907 * CGRectGetHeight(silver.superlayer.bounds))], [NSValue valueWithCGRect:CGRectMake(0, 0, 0.87209 * CGRectGetWidth(silver.superlayer.bounds), 0.87209 * CGRectGetHeight(silver.superlayer.bounds))]];
    /*  silverBoundsAnim.keyTimes  = @[@0, @0.00552, @0.99, @1];
     silverBoundsAnim.duration  = 54.4;
     silverBoundsAnim.beginTime = 10.8;*/
    
    /*silverBoundsAnim.keyTimes              = @[@0, @0.00505, @0.991, @1]; better one
     silverBoundsAnim.duration              = 59.4;
     silverBoundsAnim.beginTime             = 10.8;*/
    silverBoundsAnim.keyTimes              = @[@0, @0.00505, @0.991, @0.996, @1];
    silverBoundsAnim.duration              = 59.4;
    silverBoundsAnim.beginTime             = 10.8;
    silverBoundsAnim.keyTimes              = @[@0, @0.00505, @0.991, @0.998, @1];
    silverBoundsAnim.duration              = 59.2;
    silverBoundsAnim.beginTime             = 11;
    
    CAAnimationGroup * silverUntitleAnim = [QCMethod groupAnimations:@[silverBoundsAnim] fillMode:fillMode];
    [silver addAnimation:silverUntitleAnim forKey:@"silverUntitleAnim"];
    
    
    ////Blank animation
    
    CAKeyframeAnimation * blankBoundsAnim = [CAKeyframeAnimation animationWithKeyPath:@"bounds"];
    blankBoundsAnim.values    = @[[NSValue valueWithCGRect:CGRectMake(0, 0, 0.87209 * CGRectGetWidth(blank.superlayer.bounds), 0.87209 * CGRectGetHeight(blank.superlayer.bounds))], [NSValue valueWithCGRect:CGRectMake(0, 0, 0.27907 * CGRectGetWidth(blank.superlayer.bounds), 0.27907 * CGRectGetHeight(blank.superlayer.bounds))], [NSValue valueWithCGRect:CGRectMake(0, 0, 0.27907 * CGRectGetWidth(blank.superlayer.bounds), 0.27907 * CGRectGetHeight(blank.superlayer.bounds))], [NSValue valueWithCGRect:CGRectMake(0, 0, 0.87209 * CGRectGetWidth(blank.superlayer.bounds), 0.87209 * CGRectGetHeight(blank.superlayer.bounds))]];
    /*    blankBoundsAnim.keyTimes              = @[@0, @0.00552, @0.99, @1];
     blankBoundsAnim.duration              = 54.4;
     blankBoundsAnim.beginTime             = 10.8;*/
    /*  blankBoundsAnim.keyTimes              = @[@0, @0.00505, @0.991, @1]; better one
     blankBoundsAnim.duration              = 59.4;
     blankBoundsAnim.beginTime             = 10.8;*/
    blankBoundsAnim.keyTimes              = @[@0, @0.00505, @0.991, @0.996, @1];
    blankBoundsAnim.duration              = 59.4;
    blankBoundsAnim.beginTime             = 10.8;
    
    CAKeyframeAnimation * blankHiddenAnim = [CAKeyframeAnimation animationWithKeyPath:@"hidden"];
    blankHiddenAnim.values                = @[@NO, @YES];
    blankHiddenAnim.keyTimes              = @[@0, @1];
    blankHiddenAnim.duration              = 0.7;
    blankHiddenAnim.beginTime             = 0;
    
    if(totalls>0){
        if(totalls>0 && totalls<40){
            CAAnimationGroup * blankUntitleAnim = [QCMethod groupAnimations:@[blankBoundsAnim] fillMode:fillMode];
            
            [blank addAnimation:blankUntitleAnim forKey:@"blankUntitleAnim"];
        }
        else{
            CAAnimationGroup * blankUntitleAnim;
            if(initiall==YES){
                blankUntitleAnim = [QCMethod groupAnimations:@[blankHiddenAnim, blankBoundsAnim] fillMode:fillMode];
            }else{
                blankUntitleAnim = [QCMethod groupAnimations:@[blankBoundsAnim] fillMode:fillMode];
            }
            [blank addAnimation:blankUntitleAnim forKey:@"blankUntitleAnim"];
        }
    }
    
    
    ////gold animation
    CAKeyframeAnimation * goldBoundsAnim = [CAKeyframeAnimation animationWithKeyPath:@"bounds"];
    goldBoundsAnim.values    = @[[NSValue valueWithCGRect:CGRectMake(0, 0, 0.87209 * CGRectGetWidth(gold.superlayer.bounds), 0.87209 * CGRectGetHeight(gold.superlayer.bounds))], [NSValue valueWithCGRect:CGRectMake(0, 0, 0.27907 * CGRectGetWidth(gold.superlayer.bounds), 0.27907 * CGRectGetHeight(gold.superlayer.bounds))], [NSValue valueWithCGRect:CGRectMake(0, 0, 0.27907 * CGRectGetWidth(gold.superlayer.bounds), 0.27907 * CGRectGetHeight(gold.superlayer.bounds))], [NSValue valueWithCGRect:CGRectMake(0, 0, 0.87209 * CGRectGetWidth(gold.superlayer.bounds), 0.87209 * CGRectGetHeight(gold.superlayer.bounds))]];
    /* goldBoundsAnim.keyTimes  = @[@0, @0.00552, @0.99, @1];
     goldBoundsAnim.duration  = 54.4;
     goldBoundsAnim.beginTime = 10.8;*/
    //goldBoundsAnim.keyTimes              = @[@0, @0.00505, @0.991,@1];
    // goldBoundsAnim.keyTimes              = @[@0, @0.00505, @0.991, @0.996, @1]; Fast one
    goldBoundsAnim.keyTimes              = @[@0, @0.00505, @0.991, @0.998, @1];
    goldBoundsAnim.duration              = 59.4;
    goldBoundsAnim.beginTime             = 10.8;
    goldBoundsAnim.keyTimes              = @[@0, @0.00505, @0.991, @0.998, @1];
    goldBoundsAnim.duration              = 59.2;
    goldBoundsAnim.beginTime             = 11;
    
    
    CAAnimationGroup * goldUntitleAnim = [QCMethod groupAnimations:@[goldBoundsAnim] fillMode:fillMode];
    [gold addAnimation:goldUntitleAnim forKey:@"goldUntitleAnim"];
    
    //certified animation
    CAKeyframeAnimation * certifiedBoundsAnim = [CAKeyframeAnimation animationWithKeyPath:@"bounds"];
    certifiedBoundsAnim.values    = @[[NSValue valueWithCGRect:CGRectMake(0, 0, 0.87209 * CGRectGetWidth(certified.superlayer.bounds), 0.87209 * CGRectGetHeight(certified.superlayer.bounds))], [NSValue valueWithCGRect:CGRectMake(0, 0, 0.27907 * CGRectGetWidth(certified.superlayer.bounds), 0.27907 * CGRectGetHeight(certified.superlayer.bounds))], [NSValue valueWithCGRect:CGRectMake(0, 0, 0.27907 * CGRectGetWidth(certified.superlayer.bounds), 0.27907 * CGRectGetHeight(certified.superlayer.bounds))], [NSValue valueWithCGRect:CGRectMake(0, 0, 0.87209 * CGRectGetWidth(certified.superlayer.bounds), 0.87209 * CGRectGetHeight(certified.superlayer.bounds))]];
    /* certifiedBoundsAnim.keyTimes  = @[@0, @0.00552, @0.99, @1];
     certifiedBoundsAnim.duration  = 54.4;
     certifiedBoundsAnim.beginTime = 10.8;*/
    /*  certifiedBoundsAnim.keyTimes              = @[@0, @0.00505, @0.991, @1]; better one
     certifiedBoundsAnim.duration              = 59.4;
     certifiedBoundsAnim.beginTime             = 10.8;*/
    
    certifiedBoundsAnim.keyTimes              = @[@0, @0.00505, @0.991, @0.998, @1];
    certifiedBoundsAnim.duration              = 59.4;
    certifiedBoundsAnim.beginTime             = 10.8;
    certifiedBoundsAnim.keyTimes              = @[@0, @0.00505, @0.991, @0.998, @1];
    certifiedBoundsAnim.duration              = 59.2;
    certifiedBoundsAnim.beginTime             = 11;
    
    CAAnimationGroup * certifiedUntitleAnim = [QCMethod groupAnimations:@[certifiedBoundsAnim] fillMode:fillMode];
    [certified addAnimation:certifiedUntitleAnim forKey:@"certifiedUntitleAnim"];
    
    //nonleed animation
    CAKeyframeAnimation * nonleedBoundsAnim = [CAKeyframeAnimation animationWithKeyPath:@"bounds"];
    nonleedBoundsAnim.values    = @[[NSValue valueWithCGRect:CGRectMake(0, 0, 0.87209 * CGRectGetWidth(nonleed.superlayer.bounds), 0.87209 * CGRectGetHeight(nonleed.superlayer.bounds))], [NSValue valueWithCGRect:CGRectMake(0, 0, 0.27907 * CGRectGetWidth(nonleed.superlayer.bounds), 0.27907 * CGRectGetHeight(nonleed.superlayer.bounds))], [NSValue valueWithCGRect:CGRectMake(0, 0, 0.27907 * CGRectGetWidth(nonleed.superlayer.bounds), 0.27907 * CGRectGetHeight(nonleed.superlayer.bounds))], [NSValue valueWithCGRect:CGRectMake(0, 0, 0.87209 * CGRectGetWidth(nonleed.superlayer.bounds), 0.87209 * CGRectGetHeight(nonleed.superlayer.bounds))]];
    /* nonleedBoundsAnim.keyTimes  = @[@0, @0.00552, @0.99, @1];
     nonleedBoundsAnim.duration  = 54.4;
     nonleedBoundsAnim.beginTime = 10.8;*/
    /*  nonleedBoundsAnim.keyTimes              = @[@0, @0.00505, @0.991, @1]; better one
     nonleedBoundsAnim.duration              = 59.4;
     nonleedBoundsAnim.beginTime             = 10.8;*/
    
    nonleedBoundsAnim.keyTimes              = @[@0, @0.00505, @0.991, @0.998, @1];
    nonleedBoundsAnim.duration              = 59.4;
    nonleedBoundsAnim.beginTime             = 10.8;
    nonleedBoundsAnim.keyTimes              = @[@0, @0.00505, @0.991, @0.998, @1];
    nonleedBoundsAnim.duration              = 59.2;
    nonleedBoundsAnim.beginTime             = 11;
    
    CAAnimationGroup * nonleedUntitleAnim = [QCMethod groupAnimations:@[nonleedBoundsAnim] fillMode:fillMode];
    [nonleed addAnimation:nonleedUntitleAnim forKey:@"nonleedUntitleAnim"];
    
    
    ////Leed animation
    CALayer * leed = self.layerss[@"leed"];
    CAKeyframeAnimation * leedOpacityAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    
    leedOpacityAnim.values                = @[@1, @0, @0, @1];
    leedOpacityAnim.keyTimes              = @[@0, @0.000143, @0.999, @1];
    leedOpacityAnim.duration              = 63.1;
    leedOpacityAnim.beginTime             = 6.17;
    CAKeyframeAnimation * leedTransformAnim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    leedTransformAnim.values    = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.3, 0.3, 1)],
                                    [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.3, 0.3, 1)],
                                    [NSValue valueWithCATransform3D:CATransform3DIdentity],
                                    [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    // leedTransformAnim.keyTimes  = @[@0, @0.5, @0.898, @1]; Fast one
    leedTransformAnim.keyTimes  = @[@0, @0.5, @0.898, @1];
    leedTransformAnim.duration  = 1.08;
    leedTransformAnim.beginTime = 69.1;
    
    
    CAAnimationGroup * leedUntitled1Anim = [QCMethod groupAnimations:@[leedOpacityAnim, leedTransformAnim] fillMode:fillMode];
    [leed addAnimation:leedUntitled1Anim forKey:@"leedUntitled1Anim"];
    
    
    ////Stepscore animation
    CAKeyframeAnimation * stepscoreOpacityAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    stepscoreOpacityAnim.values   = @[@0, @0, @1, @1, @0];
    stepscoreOpacityAnim.keyTimes = @[@0, @0.157, @0.158, @0.999, @1];
    stepscoreOpacityAnim.duration = 69.3;
    stepscoreOpacityAnim.keyTimes = @[@0, @0.159, @0.159, @0.999, @1];
    stepscoreOpacityAnim.duration = 69.3;
    
    
    
    CAKeyframeAnimation * stepscoreTransformAnim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    stepscoreTransformAnim.values   = @[[NSValue valueWithCATransform3D:CATransform3DIdentity],
                                        [NSValue valueWithCATransform3D:CATransform3DIdentity],
                                        [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.3, 0.3, 1)],
                                        [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.3, 0.3, 1)]];
    stepscoreTransformAnim.keyTimes = @[@0, @0.889, @0.912, @1];
    stepscoreTransformAnim.duration = 12.2;
    stepscoreTransformAnim.keyTimes = @[@0, @0.906, @0.928, @1];
    stepscoreTransformAnim.duration = 12.2;
    
    CAAnimationGroup * stepscoreUntitled1Anim = [QCMethod groupAnimations:@[stepscoreOpacityAnim, stepscoreTransformAnim] fillMode:fillMode];
    [stepscore addAnimation:stepscoreUntitled1Anim forKey:@"stepscoreUntitled1Anim"];
    
    ////Maxscore animation
    CAKeyframeAnimation * maxscoreOpacityAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    /*   maxscoreOpacityAnim.values   = @[@0, @0, @1, @1, @0];
     maxscoreOpacityAnim.keyTimes = @[@0, @0.564, @0.564, @0.99, @1];
     maxscoreOpacityAnim.duration = 11;*/
    
    maxscoreOpacityAnim.values    = @[@1, @0];
    maxscoreOpacityAnim.keyTimes  = @[@0, @1];
    maxscoreOpacityAnim.duration  = 0.107;
    maxscoreOpacityAnim.beginTime = 10.8;
    maxscoreOpacityAnim.beginTime = 11;
    
    CAAnimationGroup * maxscoreUntitled1Anim = [QCMethod groupAnimations:@[maxscoreOpacityAnim] fillMode:fillMode];
    [self.layerss[@"maxscore"] addAnimation:maxscoreUntitled1Anim forKey:@"maxscoreUntitled1Anim"];
}

#pragma mark - Animation Cleanup

- (void)updateLayerValuesForAnimationId:(NSString *)identifier{
    if([identifier isEqualToString:@"Untitled1"]){
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layerss[@"leed_plaque"] animationForKey:@"leed_plaqueUntitled1Anim"] theLayer:self.layerss[@"leed_plaque"]];
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layerss[@"backsides"] animationForKey:@"backsidesUntitled1Anim"] theLayer:self.layerss[@"backsides"]];
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layerss[@"humanback"] animationForKey:@"humanbackUntitled1Anim"] theLayer:self.layerss[@"humanback"]];
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layerss[@"energyleveler"] animationForKey:@"energylevelerUntitleAnim"] theLayer:self.layerss[@"energyleveler"]];
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layerss[@"waterleveler"] animationForKey:@"waterlevelerUntitleAnim"] theLayer:self.layerss[@"waterleveler"]];
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layerss[@"wasteeveler"] animationForKey:@"wastelevelerUntitleAnim"] theLayer:self.layerss[@"wasteleveler"]];
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layerss[@"transportleveler"] animationForKey:@"transportlevelerUntitleAnim"] theLayer:self.layerss[@"transportleveler"]];
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layerss[@"humanleveler"] animationForKey:@"humanlevelerUntitleAnim"] theLayer:self.layerss[@"humanleveler"]];
        
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layerss[@"transportback"] animationForKey:@"transportbackUntitled1Anim"] theLayer:self.layerss[@"transportback"]];
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layerss[@"wasteback"] animationForKey:@"wastebackUntitled1Anim"] theLayer:self.layerss[@"wasteback"]];
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layerss[@"waterback"] animationForKey:@"waterbackUntitled1Anim"] theLayer:self.layerss[@"waterback"]];
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layerss[@"energyback"] animationForKey:@"energybackUntitled1Anim"] theLayer:self.layerss[@"energyback"]];
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layerss[@"humanstarting"] animationForKey:@"humanstartingUntitled1Anim"] theLayer:self.layerss[@"humanstarting"]];
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layerss[@"transportstarting"] animationForKey:@"transportstartingUntitled1Anim"] theLayer:self.layerss[@"transportstarting"]];
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layerss[@"wastestarting"] animationForKey:@"wastestartingUntitled1Anim"] theLayer:self.layerss[@"wastestarting"]];
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layerss[@"waterstarting"] animationForKey:@"waterstartingUntitled1Anim"] theLayer:self.layerss[@"waterstarting"]];
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layerss[@"energystarting"] animationForKey:@"energystartingUntitled1Anim"] theLayer:self.layerss[@"energystarting"]];
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layerss[@"energystartline"] animationForKey:@"energystartlineUntitled1Anim"] theLayer:self.layerss[@"energystartline"]];
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layerss[@"waterstartline"] animationForKey:@"waterstartlineUntitled1Anim"] theLayer:self.layerss[@"waterstartline"]];
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layerss[@"wastestartline"] animationForKey:@"wastestartlineUntitled1Anim"] theLayer:self.layerss[@"wastestartline"]];
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layerss[@"transportstartline"] animationForKey:@"transportstartlineUntitled1Anim"] theLayer:self.layerss[@"transportstartline"]];
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layerss[@"humanstartline"] animationForKey:@"humanstartlineUntitled1Anim"] theLayer:self.layerss[@"humanstartline"]];
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layerss[@"maxscores"] animationForKey:@"maxscoresUntitled1Anim"] theLayer:self.layerss[@"maxscores"]];
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layerss[@"energymaxscore"] animationForKey:@"energymaxscoreUntitled1Anim"] theLayer:self.layerss[@"energymaxscore"]];
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layerss[@"watermaxscore"] animationForKey:@"watermaxscoreUntitled1Anim"] theLayer:self.layerss[@"watermaxscore"]];
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layerss[@"wastemaxscore"] animationForKey:@"wastemaxscoreUntitled1Anim"] theLayer:self.layerss[@"wastemaxscore"]];
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layerss[@"transportmaxscore"] animationForKey:@"transportmaxscoreUntitled1Anim"] theLayer:self.layerss[@"transportmaxscore"]];
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layerss[@"humanmaxscore"] animationForKey:@"humanmaxscoreUntitled1Anim"] theLayer:self.layerss[@"humanmaxscore"]];
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layerss[@"energytext"] animationForKey:@"energytextUntitled1Anim"] theLayer:self.layerss[@"energytext"]];
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layerss[@"watertext"] animationForKey:@"watertextUntitled1Anim"] theLayer:self.layerss[@"watertext"]];
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layerss[@"wastetext"] animationForKey:@"wastetextUntitled1Anim"] theLayer:self.layerss[@"wastetext"]];
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layerss[@"transporttext"] animationForKey:@"transporttextUntitled1Anim"] theLayer:self.layerss[@"transporttext"]];
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layerss[@"humantext"] animationForKey:@"humantextUntitled1Anim"] theLayer:self.layerss[@"humantext"]];
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layerss[@"water"] animationForKey:@"waterUntitled1Anim"] theLayer:self.layerss[@"water"]];
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layerss[@"waste"] animationForKey:@"wasteUntitled1Anim"] theLayer:self.layerss[@"waste"]];
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layerss[@"transport"] animationForKey:@"transportUntitled1Anim"] theLayer:self.layerss[@"transport"]];
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layerss[@"human"] animationForKey:@"humanUntitled1Anim"] theLayer:self.layerss[@"human"]];
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layerss[@"energy"] animationForKey:@"energyUntitled1Anim"] theLayer:self.layerss[@"energy"]];
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layerss[@"humanarrow"] animationForKey:@"humanarrowUntitled1Anim"] theLayer:self.layerss[@"humanarrow"]];
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layerss[@"transportarrow"] animationForKey:@"transportarrowUntitled1Anim"] theLayer:self.layerss[@"transportarrow"]];
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layerss[@"wastearrow"] animationForKey:@"wastearrowUntitled1Anim"] theLayer:self.layerss[@"wastearrow"]];
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layerss[@"waterarrow"] animationForKey:@"waterarrowUntitled1Anim"] theLayer:self.layerss[@"waterarrow"]];
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layerss[@"energyarrow"] animationForKey:@"energyarrowUntitled1Anim"] theLayer:self.layerss[@"energyarrow"]];
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layerss[@"scores"] animationForKey:@"scoresUntitled1Anim"] theLayer:self.layerss[@"scores"]];
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layerss[@"energyscore"] animationForKey:@"energyscoreUntitled1Anim"] theLayer:self.layerss[@"energyscore"]];
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layerss[@"waterscore"] animationForKey:@"waterscoreUntitled1Anim"] theLayer:self.layerss[@"waterscore"]];
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layerss[@"wastescore"] animationForKey:@"wastescoreUntitled1Anim"] theLayer:self.layerss[@"wastescore"]];
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layerss[@"transportscore"] animationForKey:@"transportscoreUntitled1Anim"] theLayer:self.layerss[@"transportscore"]];
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layerss[@"humanscore"] animationForKey:@"humanscoreUntitled1Anim"] theLayer:self.layerss[@"humanscore"]];
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layerss[@"plaque_coin"] animationForKey:@"plaque_coinUntitled1Anim"] theLayer:self.layerss[@"plaque_coin"]];
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layerss[@"energyboom"] animationForKey:@"energyboomUntitled1Anim"] theLayer:self.layerss[@"energyboom"]];
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layerss[@"waterboom"] animationForKey:@"waterboomUntitled1Anim"] theLayer:self.layerss[@"waterboom"]];
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layerss[@"wasteboom"] animationForKey:@"wasteboomUntitled1Anim"] theLayer:self.layerss[@"wasteboom"]];
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layerss[@"transportboom"] animationForKey:@"transportboomUntitled1Anim"] theLayer:self.layerss[@"transportboom"]];
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layerss[@"humanboom"] animationForKey:@"humanboomUntitled1Anim"] theLayer:self.layerss[@"humanboom"]];
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layerss[@"platinum"] animationForKey:@"platinumUntitled1Anim"] theLayer:self.layerss[@"platinum"]];
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layerss[@"leed"] animationForKey:@"leedUntitled1Anim"] theLayer:self.layerss[@"leed"]];
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layerss[@"stepscore"] animationForKey:@"stepscoreUntitled1Anim"] theLayer:self.layerss[@"stepscore"]];
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layerss[@"maxscore"] animationForKey:@"maxscoreUntitled1Anim"] theLayer:self.layerss[@"maxscore"]];
    }
}

- (void)removeAnimationsForAnimationId:(NSString *)identifier{
    if([identifier isEqualToString:@"Untitled1"]){
        [self.layerss[@"leed_plaque"] removeAnimationForKey:@"leed_plaqueUntitled1Anim"];
        [self.layerss[@"backsides"] removeAnimationForKey:@"backsidesUntitled1Anim"];
        [self.layerss[@"humanback"] removeAnimationForKey:@"humanbackUntitled1Anim"];
        [self.layerss[@"humanleveler"] removeAnimationForKey:@"humanlevelerUntitleAnim"];
        [self.layerss[@"transportleveler"] removeAnimationForKey:@"transportlevelerUntitleAnim"];
        [self.layerss[@"wasteleveler"] removeAnimationForKey:@"wastelevelerUntitleAnim"];
        [self.layerss[@"waterleveler"] removeAnimationForKey:@"waterlevelerUntitleAnim"];
        [self.layerss[@"energyleveler"] removeAnimationForKey:@"energylevelerUntitleAnim"];
        [self.layerss[@"transportback"] removeAnimationForKey:@"transportbackUntitled1Anim"];
        [self.layerss[@"wasteback"] removeAnimationForKey:@"wastebackUntitled1Anim"];
        [self.layerss[@"waterback"] removeAnimationForKey:@"waterbackUntitled1Anim"];
        [self.layerss[@"energyback"] removeAnimationForKey:@"energybackUntitled1Anim"];
        [self.layerss[@"humanstarting"] removeAnimationForKey:@"humanstartingUntitled1Anim"];
        [self.layerss[@"transportstarting"] removeAnimationForKey:@"transportstartingUntitled1Anim"];
        [self.layerss[@"wastestarting"] removeAnimationForKey:@"wastestartingUntitled1Anim"];
        [self.layerss[@"waterstarting"] removeAnimationForKey:@"waterstartingUntitled1Anim"];
        [self.layerss[@"energystarting"] removeAnimationForKey:@"energystartingUntitled1Anim"];
        [self.layerss[@"energystartline"] removeAnimationForKey:@"energystartlineUntitled1Anim"];
        [self.layerss[@"waterstartline"] removeAnimationForKey:@"waterstartlineUntitled1Anim"];
        [self.layerss[@"wastestartline"] removeAnimationForKey:@"wastestartlineUntitled1Anim"];
        [self.layerss[@"transportstartline"] removeAnimationForKey:@"transportstartlineUntitled1Anim"];
        [self.layerss[@"humanstartline"] removeAnimationForKey:@"humanstartlineUntitled1Anim"];
        [self.layerss[@"maxscores"] removeAnimationForKey:@"maxscoresUntitled1Anim"];
        [self.layerss[@"energymaxscore"] removeAnimationForKey:@"energymaxscoreUntitled1Anim"];
        [self.layerss[@"watermaxscore"] removeAnimationForKey:@"watermaxscoreUntitled1Anim"];
        [self.layerss[@"wastemaxscore"] removeAnimationForKey:@"wastemaxscoreUntitled1Anim"];
        [self.layerss[@"transportmaxscore"] removeAnimationForKey:@"transportmaxscoreUntitled1Anim"];
        [self.layerss[@"humanmaxscore"] removeAnimationForKey:@"humanmaxscoreUntitled1Anim"];
        [self.layerss[@"energytext"] removeAnimationForKey:@"energytextUntitled1Anim"];
        [self.layerss[@"watertext"] removeAnimationForKey:@"watertextUntitled1Anim"];
        [self.layerss[@"wastetext"] removeAnimationForKey:@"wastetextUntitled1Anim"];
        [self.layerss[@"transporttext"] removeAnimationForKey:@"transporttextUntitled1Anim"];
        [self.layerss[@"humantext"] removeAnimationForKey:@"humantextUntitled1Anim"];
        [self.layerss[@"water"] removeAnimationForKey:@"waterUntitled1Anim"];
        [self.layerss[@"waste"] removeAnimationForKey:@"wasteUntitled1Anim"];
        [self.layerss[@"transport"] removeAnimationForKey:@"transportUntitled1Anim"];
        [self.layerss[@"human"] removeAnimationForKey:@"humanUntitled1Anim"];
        [self.layerss[@"energy"] removeAnimationForKey:@"energyUntitled1Anim"];
        [self.layerss[@"humanarrow"] removeAnimationForKey:@"humanarrowUntitled1Anim"];
        [self.layerss[@"transportarrow"] removeAnimationForKey:@"transportarrowUntitled1Anim"];
        [self.layerss[@"wastearrow"] removeAnimationForKey:@"wastearrowUntitled1Anim"];
        [self.layerss[@"waterarrow"] removeAnimationForKey:@"waterarrowUntitled1Anim"];
        [self.layerss[@"energyarrow"] removeAnimationForKey:@"energyarrowUntitled1Anim"];
        [self.layerss[@"scores"] removeAnimationForKey:@"scoresUntitled1Anim"];
        [self.layerss[@"energyscore"] removeAnimationForKey:@"energyscoreUntitled1Anim"];
        [self.layerss[@"waterscore"] removeAnimationForKey:@"waterscoreUntitled1Anim"];
        [self.layerss[@"wastescore"] removeAnimationForKey:@"wastescoreUntitled1Anim"];
        [self.layerss[@"transportscore"] removeAnimationForKey:@"transportscoreUntitled1Anim"];
        [self.layerss[@"humanscore"] removeAnimationForKey:@"humanscoreUntitled1Anim"];
        [self.layerss[@"plaque_coin"] removeAnimationForKey:@"plaque_coinUntitled1Anim"];
        [self.layerss[@"energyboom"] removeAnimationForKey:@"energyboomUntitled1Anim"];
        [self.layerss[@"waterboom"] removeAnimationForKey:@"waterboomUntitled1Anim"];
        [self.layerss[@"wasteboom"] removeAnimationForKey:@"wasteboomUntitled1Anim"];
        [self.layerss[@"transportboom"] removeAnimationForKey:@"transportboomUntitled1Anim"];
        [self.layerss[@"humanboom"] removeAnimationForKey:@"humanboomUntitled1Anim"];
        [self.layerss[@"platinum"] removeAnimationForKey:@"platinumUntitled1Anim"];
        [self.layerss[@"leed"] removeAnimationForKey:@"leedUntitled1Anim"];
        [self.layerss[@"stepscore"] removeAnimationForKey:@"stepscoreUntitled1Anim"];
        [self.layerss[@"maxscore"] removeAnimationForKey:@"maxscoreUntitled1Anim"];
    }
}

- (void)removeAllAnimations{
    [self.layerss enumerateKeysAndObjectsUsingBlock:^(id key, CALayer *layer, BOOL *stop) {
        [layer removeAllAnimations];
    }];
}

#pragma mark - Bezier Path

- (UIBezierPath*)energybackPathWithBounds:(CGRect)bound{
    UIBezierPath *energybackPath = [UIBezierPath bezierPath];
    CGFloat minX = CGRectGetMinX(bound), minY = CGRectGetMinY(bound), w = CGRectGetWidth(bound), h = CGRectGetHeight(bound);
    
    [energybackPath moveToPoint:CGPointMake(minX+(0.0045*w), minY)];
    [energybackPath addCurveToPoint:CGPointMake(minX + 0.53517 * w, minY + 0.00054 * h) controlPoint1:CGPointMake(minX + 0.00564 * w, minY) controlPoint2:CGPointMake(minX + 0.52958 * w, minY + 0.00034 * h)];
    [energybackPath addCurveToPoint:CGPointMake(minX + w, minY + 0.50012 * h) controlPoint1:CGPointMake(minX + 0.79339 * w, minY + 0.00975 * h) controlPoint2:CGPointMake(minX + w, minY + 0.22989 * h)];
    [energybackPath addCurveToPoint:CGPointMake(minX + 0.51833 * w, minY + h) controlPoint1:CGPointMake(minX + w, minY + 0.7762 * h) controlPoint2:CGPointMake(minX + 0.78435 * w, minY + h)];
    [energybackPath addCurveToPoint:CGPointMake(minX + 0.03699 * w, minY + 0.51868 * h) controlPoint1:CGPointMake(minX + 0.2583 * w, minY + h) controlPoint2:CGPointMake(minX + 0.0464 * w, minY + 0.78616 * h)];
    [energybackPath addCurveToPoint:CGPointMake(minX + 0.03595 * w, minY + 0.337 * h) controlPoint1:CGPointMake(minX + 0.03677 * w, minY + 0.51252 * h) controlPoint2:CGPointMake(minX + 0.03595 * w, minY + 0.34321 * h)];
    
    return energybackPath;
    
}

- (UIBezierPath*)waterbackPathWithBounds:(CGRect)bound{
    UIBezierPath *waterbackPath = [UIBezierPath bezierPath];
    CGFloat minX = CGRectGetMinX(bound), minY = CGRectGetMinY(bound), w = CGRectGetWidth(bound), h = CGRectGetHeight(bound);
    
    [waterbackPath moveToPoint:CGPointMake(minX+(0.0025*w), minY)];
    [waterbackPath addCurveToPoint:CGPointMake(minX + 0.57435 * w, minY + 0.00163 * h) controlPoint1:CGPointMake(minX + 0.0063 * w, minY) controlPoint2:CGPointMake(minX + 0.56811 * w, minY + 0.00134 * h)];
    [waterbackPath addCurveToPoint:CGPointMake(minX + w, minY + 0.5006 * h) controlPoint1:CGPointMake(minX + 0.8111 * w, minY + 0.01271 * h) controlPoint2:CGPointMake(minX + w, minY + 0.23187 * h)];
    [waterbackPath addCurveToPoint:CGPointMake(minX + 0.55553 * w, minY + h) controlPoint1:CGPointMake(minX + w, minY + 0.77641 * h) controlPoint2:CGPointMake(minX + 0.80101 * w, minY + h)];
    [waterbackPath addCurveToPoint:CGPointMake(minX + 0.11145 * w, minY + 0.5215 * h) controlPoint1:CGPointMake(minX + 0.3163 * w, minY + h) controlPoint2:CGPointMake(minX + 0.1212 * w, minY + 0.78762 * h)];
    [waterbackPath addCurveToPoint:CGPointMake(minX + 0.11145 * w, minY + 0.31066 * h) controlPoint1:CGPointMake(minX + 0.1112 * w, minY + 0.51457 * h) controlPoint2:CGPointMake(minX + 0.11145 * w, minY + 0.31767 * h)];
    
    return waterbackPath;
}

- (UIBezierPath*)wastebackPathWithBounds:(CGRect)bound{
    UIBezierPath *wastebackPath = [UIBezierPath bezierPath];
    CGFloat minX = CGRectGetMinX(bound), minY = CGRectGetMinY(bound), w = CGRectGetWidth(bound), h = CGRectGetHeight(bound);
    
    [wastebackPath moveToPoint:CGPointMake(minX+(0.0008*w), minY)];
    [wastebackPath addCurveToPoint:CGPointMake(minX + 0.61567 * w, minY + 0.00068 * h) controlPoint1:CGPointMake(minX + 0.00537 * w, minY) controlPoint2:CGPointMake(minX + 0.61034 * w, minY + 0.00042 * h)];
    [wastebackPath addCurveToPoint:CGPointMake(minX + w, minY + 0.50014 * h) controlPoint1:CGPointMake(minX + 0.82935 * w, minY + 0.0112 * h) controlPoint2:CGPointMake(minX + w, minY + 0.23079 * h)];
    [wastebackPath addCurveToPoint:CGPointMake(minX + 0.59962 * w, minY + h) controlPoint1:CGPointMake(minX + w, minY + 0.77621 * h) controlPoint2:CGPointMake(minX + 0.82074 * w, minY + h)];
    [wastebackPath addCurveToPoint:CGPointMake(minX + 0.1998 * w, minY + 0.52673 * h) controlPoint1:CGPointMake(minX + 0.38564 * w, minY + h) controlPoint2:CGPointMake(minX + 0.21087 * w, minY + 0.79044 * h)];
    [wastebackPath addCurveToPoint:CGPointMake(minX + 0.19897 * w, minY + 0.27115 * h) controlPoint1:CGPointMake(minX + 0.19943 * w, minY + 0.51793 * h) controlPoint2:CGPointMake(minX + 0.19897 * w, minY + 0.28007 * h)];
    
    return wastebackPath;
}

- (UIBezierPath*)transportbackPathWithBounds:(CGRect)bound{
    UIBezierPath *transportbackPath = [UIBezierPath bezierPath];
    CGFloat minX = CGRectGetMinX(bound), minY = CGRectGetMinY(bound), w = CGRectGetWidth(bound), h = CGRectGetHeight(bound);
    
    [transportbackPath moveToPoint:CGPointMake(minX, minY + 0.00018 * h)];
    [transportbackPath addCurveToPoint:CGPointMake(minX + 0.66614 * w, minY + 0.00012 * h) controlPoint1:CGPointMake(minX + 0.0051 * w, minY + 0.00018 * h) controlPoint2:CGPointMake(minX + 0.6611 * w, minY + -0.00019 * h)];
    [transportbackPath addCurveToPoint:CGPointMake(minX + w, minY + 0.49983 * h) controlPoint1:CGPointMake(minX + 0.85187 * w, minY + 0.01154 * h) controlPoint2:CGPointMake(minX + w, minY + 0.2309 * h)];
    [transportbackPath addCurveToPoint:CGPointMake(minX + 0.65093 * w, minY + h) controlPoint1:CGPointMake(minX + w, minY + 0.77607 * h) controlPoint2:CGPointMake(minX + 0.84372 * w, minY + h)];
    [transportbackPath addCurveToPoint:CGPointMake(minX + 0.30283 * w, minY + 0.5373 * h) controlPoint1:CGPointMake(minX + 0.46694 * w, minY + h) controlPoint2:CGPointMake(minX + 0.3162 * w, minY + 0.79603 * h)];
    [transportbackPath addCurveToPoint:CGPointMake(minX + 0.30132 * w, minY + 0.21371 * h) controlPoint1:CGPointMake(minX + 0.30219 * w, minY + 0.52493 * h) controlPoint2:CGPointMake(minX + 0.30132 * w, minY + 0.22632 * h)];
    
    return transportbackPath;
}

- (UIBezierPath*)humanbackPathWithBounds:(CGRect)bound{
    UIBezierPath *humanbackPath = [UIBezierPath bezierPath];
    CGFloat minX = CGRectGetMinX(bound), minY = CGRectGetMinY(bound), w = CGRectGetWidth(bound), h = CGRectGetHeight(bound);
    
    [humanbackPath moveToPoint:CGPointMake(minX, minY + 0.00387 * h)];
    [humanbackPath addCurveToPoint:CGPointMake(minX + 0.73626 * w, minY + 0.00016 * h) controlPoint1:CGPointMake(minX + 0.00789 * w, minY + 0.00387 * h) controlPoint2:CGPointMake(minX + 0.72854 * w, minY + -0.00093 * h)];
    [humanbackPath addCurveToPoint:CGPointMake(minX + w, minY + 0.49926 * h) controlPoint1:CGPointMake(minX + 0.8839 * w, minY + 0.02094 * h) controlPoint2:CGPointMake(minX + w, minY + 0.23646 * h)];
    [humanbackPath addCurveToPoint:CGPointMake(minX + 0.71284 * w, minY + h) controlPoint1:CGPointMake(minX + w, minY + 0.77581 * h) controlPoint2:CGPointMake(minX + 0.87143 * w, minY + h)];
    [humanbackPath addCurveToPoint:CGPointMake(minX + 0.42668 * w, minY + 0.54138 * h) controlPoint1:CGPointMake(minX + 0.56238 * w, minY + h) controlPoint2:CGPointMake(minX + 0.43895 * w, minY + 0.79822 * h)];
    [humanbackPath addCurveToPoint:CGPointMake(minX + 0.4261 * w, minY + 0.11388 * h) controlPoint1:CGPointMake(minX + 0.42602 * w, minY + 0.5275 * h) controlPoint2:CGPointMake(minX + 0.4261 * w, minY + 0.11007 * h)];
    
    return humanbackPath;
}





- (UIBezierPath*)energystartingPathWithBounds:(CGRect)bound{
    if(energyvaluee>0 && energyvaluee!=menergyvaluee){
        float f=(180*(energyvaluee/menergyvaluee));
        f=f+(2*(180-f));
        if (CGRectEqualToRect(bound, CGRectZero)) return nil;
        UIBezierPath*  energystartingPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, 0) radius:CGRectGetWidth(bound)/2 startAngle:-90 * M_PI/180 endAngle:-f * M_PI/180 clockwise:YES];
        CGAffineTransform pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound));;
        pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound));;
        [energystartingPath applyTransform:pathTransform];
        return energystartingPath;
    }
    else if(energyvaluee==menergyvaluee){
        UIBezierPath *oval6Path = [UIBezierPath bezierPath];
        CGFloat minX = CGRectGetMinX(bound), minY = CGRectGetMinY(bound), w = CGRectGetWidth(bound), h = CGRectGetHeight(bound);
        
        [oval6Path moveToPoint:CGPointMake(minX + 0.50024 * w, minY)];
        [oval6Path addCurveToPoint:CGPointMake(minX + w, minY + 0.5 * h) controlPoint1:CGPointMake(minX + 0.77625 * w, minY) controlPoint2:CGPointMake(minX + w, minY + 0.22386 * h)];
        [oval6Path addCurveToPoint:CGPointMake(minX + 0.50024 * w, minY + h) controlPoint1:CGPointMake(minX + w, minY + 0.77614 * h) controlPoint2:CGPointMake(minX + 0.77625 * w, minY + h)];
        [oval6Path addCurveToPoint:CGPointMake(minX + 0.00066 * w, minY + 0.51338 * h) controlPoint1:CGPointMake(minX + 0.22871 * w, minY + h) controlPoint2:CGPointMake(minX + 0.00775 * w, minY + 0.78334 * h)];
        [oval6Path addCurveToPoint:CGPointMake(minX, minY + 0.35702 * h) controlPoint1:CGPointMake(minX + 0.00054 * w, minY + 0.50894 * h) controlPoint2:CGPointMake(minX, minY + 0.36149 * h)];
        
        return oval6Path;
        
    }
    else if (energyvaluee==0){
        UIBezierPath*  energystartingPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, 0) radius:CGRectGetWidth(bound)/2 startAngle:-90 * M_PI/180 endAngle:-88.8 * M_PI/180 clockwise:YES];
        CGAffineTransform pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound));;
        pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound));;
        [energystartingPath applyTransform:pathTransform];
        return energystartingPath;
        
    }
    return nil;
}


- (UIBezierPath*)energystartinggPathWithBounds:(CGRect)bound{
    if(energyvaluee>0 && energyvaluee!=menergyvaluee){
        float f=(180*((energyvaluee-0.2)/menergyvaluee));
        f=f+(2*(180-f));
        if (CGRectEqualToRect(bound, CGRectZero)) return nil;
        UIBezierPath*  energystartingPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, 0) radius:CGRectGetWidth(bound)/2 startAngle:-90 * M_PI/180 endAngle:-f * M_PI/180 clockwise:YES];
        CGAffineTransform pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound));;
        pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound));;
        [energystartingPath applyTransform:pathTransform];
        return energystartingPath;
    }
    else if(energyvaluee==menergyvaluee){
        UIBezierPath *oval6Path = [UIBezierPath bezierPath];
        CGFloat minX = CGRectGetMinX(bound), minY = CGRectGetMinY(bound), w = CGRectGetWidth(bound), h = CGRectGetHeight(bound);
        
        [oval6Path moveToPoint:CGPointMake(minX + 0.5006 * w, minY)];
        [oval6Path addCurveToPoint:CGPointMake(minX + w, minY + 0.5 * h) controlPoint1:CGPointMake(minX + 0.77641 * w, minY) controlPoint2:CGPointMake(minX + w, minY + 0.22386 * h)];
        [oval6Path addCurveToPoint:CGPointMake(minX + 0.5006 * w, minY + h) controlPoint1:CGPointMake(minX + w, minY + 0.77614 * h) controlPoint2:CGPointMake(minX + 0.77641 * w, minY + h)];
        [oval6Path addCurveToPoint:CGPointMake(minX + 0.00138 * w, minY + 0.51338 * h) controlPoint1:CGPointMake(minX + 0.22926 * w, minY + h) controlPoint2:CGPointMake(minX + 0.00847 * w, minY + 0.78334 * h)];
        [oval6Path addCurveToPoint:CGPointMake(minX, minY + 0.37144 * h) controlPoint1:CGPointMake(minX + 0.00127 * w, minY + 0.50894 * h) controlPoint2:CGPointMake(minX, minY + 0.37592 * h)];
        
        return oval6Path;
        
    }
    else if (energyvaluee==0){
        UIBezierPath*  energystartingPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, 0) radius:CGRectGetWidth(bound)/2 startAngle:-90 * M_PI/180 endAngle:-89.8 * M_PI/180 clockwise:YES];
        CGAffineTransform pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound));;
        pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound));;
        [energystartingPath applyTransform:pathTransform];
        return energystartingPath;
    }
    return nil;
}

- (UIBezierPath*)waterstartingPathWithBounds:(CGRect)bound{
    if(watervaluee>0 && watervaluee!=mwatervaluee){
        float f=(180*(watervaluee/mwatervaluee));
        f=f+(2*(180-f));
        if (CGRectEqualToRect(bound, CGRectZero)) return nil;
        UIBezierPath*  waterstartingPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, 0) radius:CGRectGetWidth(bound)/2 startAngle:-90 * M_PI/180 endAngle:-f * M_PI/180 clockwise:YES];
        CGAffineTransform pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound));;
        pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound));;
        [waterstartingPath applyTransform:pathTransform];
        return waterstartingPath;
    }
    else if (mwatervaluee==watervaluee){
        UIBezierPath *oval5Path = [UIBezierPath bezierPath];
        CGFloat minX = CGRectGetMinX(bound), minY = CGRectGetMinY(bound), w = CGRectGetWidth(bound), h = CGRectGetHeight(bound);
        
        [oval5Path moveToPoint:CGPointMake(minX + 0.49989 * w, minY)];
        [oval5Path addCurveToPoint:CGPointMake(minX + w, minY + 0.5 * h) controlPoint1:CGPointMake(minX + 0.77609 * w, minY) controlPoint2:CGPointMake(minX + w, minY + 0.22386 * h)];
        [oval5Path addCurveToPoint:CGPointMake(minX + 0.49989 * w, minY + h) controlPoint1:CGPointMake(minX + w, minY + 0.77614 * h) controlPoint2:CGPointMake(minX + 0.77609 * w, minY + h)];
        [oval5Path addCurveToPoint:CGPointMake(minX + 0.00002 * w, minY + 0.51574 * h) controlPoint1:CGPointMake(minX + 0.22895 * w, minY + h) controlPoint2:CGPointMake(minX + 0.00834 * w, minY + 0.7846 * h)];
        [oval5Path addCurveToPoint:CGPointMake(minX + 0.0008 * w, minY + 0.32982 * h) controlPoint1:CGPointMake(minX + -0.00014 * w, minY + 0.51052 * h) controlPoint2:CGPointMake(minX + 0.0008 * w, minY + 0.33508 * h)];
        
        return oval5Path;
    }
    else if (watervaluee==0){
        UIBezierPath*  waterstartingPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, 0) radius:CGRectGetWidth(bound)/2 startAngle:-90 * M_PI/180 endAngle:-88.5 * M_PI/180 clockwise:YES];
        CGAffineTransform pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound));;
        pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound));;
        [waterstartingPath applyTransform:pathTransform];
        return waterstartingPath;
    }
    return nil;
}

- (UIBezierPath*)waterstartinggPathWithBounds:(CGRect)bound{
    if(watervaluee>0 && watervaluee!=mwatervaluee){
        float f=(180*((watervaluee-0.2)/mwatervaluee));
        f=f+(2*(180-f));
        if (CGRectEqualToRect(bound, CGRectZero)) return nil;
        UIBezierPath*  waterstartingPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, 0) radius:CGRectGetWidth(bound)/2 startAngle:-90 * M_PI/180 endAngle:-f * M_PI/180 clockwise:YES];
        CGAffineTransform pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound));;
        pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound));;
        [waterstartingPath applyTransform:pathTransform];
        return waterstartingPath;
    }
    else if (mwatervaluee==watervaluee){
        UIBezierPath *oval5Path = [UIBezierPath bezierPath];
        CGFloat minX = CGRectGetMinX(bound), minY = CGRectGetMinY(bound), w = CGRectGetWidth(bound), h = CGRectGetHeight(bound);
        
        [oval5Path moveToPoint:CGPointMake(minX + 0.49989 * w, minY)];
        [oval5Path addCurveToPoint:CGPointMake(minX + w, minY + 0.5 * h) controlPoint1:CGPointMake(minX + 0.77609 * w, minY) controlPoint2:CGPointMake(minX + w, minY + 0.22386 * h)];
        [oval5Path addCurveToPoint:CGPointMake(minX + 0.49989 * w, minY + h) controlPoint1:CGPointMake(minX + w, minY + 0.77614 * h) controlPoint2:CGPointMake(minX + 0.77609 * w, minY + h)];
        [oval5Path addCurveToPoint:CGPointMake(minX + 0.00001 * w, minY + 0.51574 * h) controlPoint1:CGPointMake(minX + 0.22895 * w, minY + h) controlPoint2:CGPointMake(minX + 0.00833 * w, minY + 0.7846 * h)];
        [oval5Path addCurveToPoint:CGPointMake(minX + 0.00106 * w, minY + 0.35051 * h) controlPoint1:CGPointMake(minX + -0.00015 * w, minY + 0.51052 * h) controlPoint2:CGPointMake(minX + 0.00106 * w, minY + 0.35578 * h)];
        //34,35
        return oval5Path;
    }
    else if (watervaluee==0){
        UIBezierPath*  waterstartingPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, 0) radius:CGRectGetWidth(bound)/2 startAngle:-90 * M_PI/180 endAngle:-89.5 * M_PI/180 clockwise:YES];
        CGAffineTransform pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound));;
        pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound));;
        [waterstartingPath applyTransform:pathTransform];
        return waterstartingPath;
    }
    
    return nil;
}


- (UIBezierPath*)wastestartinggPathWithBounds:(CGRect)bound{
    if(wastevaluee>0 && wastevaluee!=mwastevaluee){
        float f=(180*((wastevaluee-0.05)/mwastevaluee));
        f=f+(2*(180-f));
        NSLog(@"Score %f",f);
        if (CGRectEqualToRect(bound, CGRectZero)) return nil;
        UIBezierPath*  wastestartingPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, 0) radius:CGRectGetWidth(bound)/2 startAngle:-90 * M_PI/180 endAngle:-f * M_PI/180 clockwise:YES];
        CGAffineTransform pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound));;
        pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound));;
        [wastestartingPath applyTransform:pathTransform];
        return wastestartingPath;
    }
    else if (mwastevaluee==wastevaluee){
        UIBezierPath *oval4Path = [UIBezierPath bezierPath];
        CGFloat minX = CGRectGetMinX(bound), minY = CGRectGetMinY(bound), w = CGRectGetWidth(bound), h = CGRectGetHeight(bound);
        
        [oval4Path moveToPoint:CGPointMake(minX + 0.49992 * w, minY)];
        [oval4Path addCurveToPoint:CGPointMake(minX + w, minY + 0.5 * h) controlPoint1:CGPointMake(minX + 0.77611 * w, minY) controlPoint2:CGPointMake(minX + w, minY + 0.22386 * h)];
        [oval4Path addCurveToPoint:CGPointMake(minX + 0.49992 * w, minY + h) controlPoint1:CGPointMake(minX + w, minY + 0.77614 * h) controlPoint2:CGPointMake(minX + 0.77611 * w, minY + h)];
        [oval4Path addCurveToPoint:CGPointMake(minX + 0.00025 * w, minY + 0.52057 * h) controlPoint1:CGPointMake(minX + 0.23062 * w, minY + h) controlPoint2:CGPointMake(minX + 0.01104 * w, minY + 0.78718 * h)];
        [oval4Path addCurveToPoint:CGPointMake(minX, minY + 0.31515 * h) controlPoint1:CGPointMake(minX + -0.00003 * w, minY + 0.51375 * h) controlPoint2:CGPointMake(minX, minY + 0.32204 * h)];
        
        return oval4Path;
        
    }
    else if(wastevaluee==0){
        UIBezierPath*  wastestartingPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, 0) radius:CGRectGetWidth(bound)/2 startAngle:-90 * M_PI/180 endAngle:-89 * M_PI/180 clockwise:YES];
        CGAffineTransform pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound));;
        pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound));;
        [wastestartingPath applyTransform:pathTransform];
        return wastestartingPath;
    }
    return nil;
}

- (UIBezierPath*)wastestartingPathWithBounds:(CGRect)bound{
    
    if(wastevaluee>0 && wastevaluee!=mwastevaluee){
        float f=(180*((wastevaluee)/mwastevaluee));
        f=f+(2*(180-f));
        NSLog(@"Arrow %f",f);
        if (CGRectEqualToRect(bound, CGRectZero)) return nil;
        UIBezierPath*  wastestartingPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, 0) radius:CGRectGetWidth(bound)/2 startAngle:-90 * M_PI/180 endAngle:-f * M_PI/180 clockwise:YES];
        CGAffineTransform pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound));;
        pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound));;
        [wastestartingPath applyTransform:pathTransform];
        return wastestartingPath;
    }
    else if (mwastevaluee==wastevaluee){
        UIBezierPath *oval4Path = [UIBezierPath bezierPath];
        CGFloat minX = CGRectGetMinX(bound), minY = CGRectGetMinY(bound), w = CGRectGetWidth(bound), h = CGRectGetHeight(bound);
        
        [oval4Path moveToPoint:CGPointMake(minX + 0.49992 * w, minY)];
        [oval4Path addCurveToPoint:CGPointMake(minX + w, minY + 0.5 * h) controlPoint1:CGPointMake(minX + 0.77611 * w, minY) controlPoint2:CGPointMake(minX + w, minY + 0.22386 * h)];
        [oval4Path addCurveToPoint:CGPointMake(minX + 0.49992 * w, minY + h) controlPoint1:CGPointMake(minX + w, minY + 0.77614 * h) controlPoint2:CGPointMake(minX + 0.77611 * w, minY + h)];
        [oval4Path addCurveToPoint:CGPointMake(minX + 0.00025 * w, minY + 0.52057 * h) controlPoint1:CGPointMake(minX + 0.23062 * w, minY + h) controlPoint2:CGPointMake(minX + 0.01104 * w, minY + 0.78718 * h)];
        [oval4Path addCurveToPoint:CGPointMake(minX, minY + 0.29515 * h) controlPoint1:CGPointMake(minX + -0.00003 * w, minY + 0.51375 * h) controlPoint2:CGPointMake(minX, minY + 0.30204 * h)];
        
        return oval4Path;
    }
    else if(wastevaluee==0){
        UIBezierPath*  wastestartingPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, 0) radius:CGRectGetWidth(bound)/2 startAngle:-90 * M_PI/180 endAngle:-88 * M_PI/180 clockwise:YES];
        CGAffineTransform pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound));;
        pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound));;
        [wastestartingPath applyTransform:pathTransform];
        return wastestartingPath;
    }
    return nil;
}


- (UIBezierPath*)transportstartingPathWithBounds:(CGRect)bound{
    if(transportvaluee>0 && transportvaluee!=mtransportvaluee){
        NSLog(@"Actual %f",bound.size.width);
        if (CGRectEqualToRect(bound, CGRectZero)) return nil;
        float f=(180*(transportvaluee/mtransportvaluee));
        f=f+(2*(180-f));
        
        UIBezierPath*  transportstartingPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, 0) radius:CGRectGetWidth(bound)/2 startAngle:-90 * M_PI/180 endAngle:-f * M_PI/180 clockwise:YES];
        CGAffineTransform pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound));;
        pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound));;
        [transportstartingPath applyTransform:pathTransform];
        return transportstartingPath;
    }else if (mtransportvaluee==transportvaluee){
        UIBezierPath *oval3Path = [UIBezierPath bezierPath];
        CGFloat minX = CGRectGetMinX(bound), minY = CGRectGetMinY(bound), w = CGRectGetWidth(bound), h = CGRectGetHeight(bound);
        
        [oval3Path moveToPoint:CGPointMake(minX + 0.49973 * w, minY)];
        [oval3Path addCurveToPoint:CGPointMake(minX + w, minY + 0.5 * h) controlPoint1:CGPointMake(minX + 0.77602 * w, minY) controlPoint2:CGPointMake(minX + w, minY + 0.22386 * h)];
        [oval3Path addCurveToPoint:CGPointMake(minX + 0.49973 * w, minY + h) controlPoint1:CGPointMake(minX + w, minY + 0.77614 * h) controlPoint2:CGPointMake(minX + 0.77602 * w, minY + h)];
        [oval3Path addCurveToPoint:CGPointMake(minX + 0.00013 * w, minY + 0.52615 * h) controlPoint1:CGPointMake(minX + 0.23221 * w, minY + h) controlPoint2:CGPointMake(minX + 0.01373 * w, minY + 0.79014 * h)];
        [oval3Path addCurveToPoint:CGPointMake(minX + 0.00055 * w, minY + 0.2437 * h) controlPoint1:CGPointMake(minX + -0.00032 * w, minY + 0.51749 * h) controlPoint2:CGPointMake(minX + 0.00055 * w, minY + 0.25247 * h)];
        
        return oval3Path;
    }
    else if (transportvaluee==0){
        UIBezierPath*  transportstartingPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, 0) radius:CGRectGetWidth(bound)/2 startAngle:-90 * M_PI/180 endAngle:-87.5 * M_PI/180 clockwise:YES];
        CGAffineTransform pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound));;
        pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound));;
        [transportstartingPath applyTransform:pathTransform];
        return transportstartingPath;
    }
    return nil;
}

- (UIBezierPath*)transportstartingggPathWithBounds:(CGRect)bound{
    UIBezierPath *oval3Path = [UIBezierPath bezierPath];
    CGFloat minX = CGRectGetMinX(bound), minY = CGRectGetMinY(bound), w = CGRectGetWidth(bound), h = CGRectGetHeight(bound);
    
    [oval3Path moveToPoint:CGPointMake(minX + 0.5005 * w, minY)];
    [oval3Path addCurveToPoint:CGPointMake(minX + w, minY + 0.5 * h) controlPoint1:CGPointMake(minX + 0.77637 * w, minY) controlPoint2:CGPointMake(minX + w, minY + 0.22386 * h)];
    [oval3Path addCurveToPoint:CGPointMake(minX + 0.5005 * w, minY + h) controlPoint1:CGPointMake(minX + w, minY + 0.77614 * h) controlPoint2:CGPointMake(minX + 0.77637 * w, minY + h)];
    [oval3Path addCurveToPoint:CGPointMake(minX + 0.00168 * w, minY + 0.52615 * h) controlPoint1:CGPointMake(minX + 0.2334 * w, minY + h) controlPoint2:CGPointMake(minX + 0.01527 * w, minY + 0.79014 * h)];
    [oval3Path addCurveToPoint:CGPointMake(minX, minY + 0.30599 * h) controlPoint1:CGPointMake(minX + 0.00123 * w, minY + 0.51749 * h) controlPoint2:CGPointMake(minX, minY + 0.31476 * h)];
    
    return oval3Path;
    
    
}


- (UIBezierPath*)transportstartinggPathWithBounds:(CGRect)bound{
    if(transportvaluee>0 && transportvaluee!=mtransportvaluee){
        float f=(180*((transportvaluee-0.2)/mtransportvaluee));
        f=f+(2*(180-f));
        if (CGRectEqualToRect(bound, CGRectZero)) return nil;
        UIBezierPath*  transportstartingPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, 0) radius:CGRectGetWidth(bound)/2 startAngle:-90 * M_PI/180 endAngle:-f * M_PI/180 clockwise:YES];
        CGAffineTransform pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound));;
        pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound));;
        [transportstartingPath applyTransform:pathTransform];
        return transportstartingPath;
    }else if (mtransportvaluee==transportvaluee){
        UIBezierPath *oval3Path = [UIBezierPath bezierPath];
        CGFloat minX = CGRectGetMinX(bound), minY = CGRectGetMinY(bound), w = CGRectGetWidth(bound), h = CGRectGetHeight(bound);
        
        [oval3Path moveToPoint:CGPointMake(minX + 0.5005 * w, minY)];
        [oval3Path addCurveToPoint:CGPointMake(minX + w, minY + 0.5 * h) controlPoint1:CGPointMake(minX + 0.77637 * w, minY) controlPoint2:CGPointMake(minX + w, minY + 0.22386 * h)];
        [oval3Path addCurveToPoint:CGPointMake(minX + 0.5005 * w, minY + h) controlPoint1:CGPointMake(minX + w, minY + 0.77614 * h) controlPoint2:CGPointMake(minX + 0.77637 * w, minY + h)];
        [oval3Path addCurveToPoint:CGPointMake(minX + 0.00168 * w, minY + 0.52615 * h) controlPoint1:CGPointMake(minX + 0.2334 * w, minY + h) controlPoint2:CGPointMake(minX + 0.01527 * w, minY + 0.79014 * h)];
        [oval3Path addCurveToPoint:CGPointMake(minX, minY + 0.27299 * h) controlPoint1:CGPointMake(minX + 0.00123 * w, minY + 0.51749 * h) controlPoint2:CGPointMake(minX, minY + 0.28276 * h)];
        
        return oval3Path;
    }
    else if(transportvaluee==0){
        UIBezierPath*  transportstartingPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, 0) radius:CGRectGetWidth(bound)/2 startAngle:-90 * M_PI/180 endAngle:-88.5 * M_PI/180 clockwise:YES];
        CGAffineTransform pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound));;
        pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound));;
        [transportstartingPath applyTransform:pathTransform];
        return transportstartingPath;
    }
    return nil;
    
}

- (UIBezierPath*)humanstartingPathWithBounds:(CGRect)bound{
    if(humanvaluee>0 && humanvaluee<mhumanvaluee){
        float f=(180*(humanvaluee/mhumanvaluee));
        f=f+(2*(180-f));
        if (CGRectEqualToRect(bound, CGRectZero)) return nil;
        UIBezierPath*  humanstartingPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, 0) radius:CGRectGetWidth(bound)/2 startAngle:-90 * M_PI/180 endAngle:-f * M_PI/180 clockwise:YES];
        CGAffineTransform pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound));;
        pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound));;
        [humanstartingPath applyTransform:pathTransform];
        return humanstartingPath;
    }
    else if(humanvaluee==mhumanvaluee){
        UIBezierPath *ovalPath = [UIBezierPath bezierPath];
        CGFloat minX = CGRectGetMinX(bound), minY = CGRectGetMinY(bound), w = CGRectGetWidth(bound), h = CGRectGetHeight(bound);
        
        [ovalPath moveToPoint:CGPointMake(minX + 0.50036 * w, minY)];
        [ovalPath addCurveToPoint:CGPointMake(minX + w, minY + 0.5 * h) controlPoint1:CGPointMake(minX + 0.7763 * w, minY) controlPoint2:CGPointMake(minX + w, minY + 0.22386 * h)];
        [ovalPath addCurveToPoint:CGPointMake(minX + 0.50036 * w, minY + h) controlPoint1:CGPointMake(minX + w, minY + 0.77614 * h) controlPoint2:CGPointMake(minX + 0.7763 * w, minY + h)];
        [ovalPath addCurveToPoint:CGPointMake(minX + 0.00105 * w, minY + 0.51835 * h) controlPoint1:CGPointMake(minX + 0.23055 * w, minY + h) controlPoint2:CGPointMake(minX + 0.0107 * w, minY + 0.78599 * h)];
        [ovalPath addCurveToPoint:CGPointMake(minX, minY + 0.17084 * h) controlPoint1:CGPointMake(minX + 0.00099 * w, minY + 0.51675 * h) controlPoint2:CGPointMake(minX, minY + 0.17219 * h)];
        
        return ovalPath;
    }
    else if (humanvaluee==0){
        float f=(180*(0.2/15));
        f=f+(2*(180-f));
        NSLog(@"value %f",f);
        if (CGRectEqualToRect(bound, CGRectZero)) return nil;
        UIBezierPath*  humanstartingPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, 0) radius:CGRectGetWidth(bound)/2 startAngle:-90 * M_PI/180 endAngle:-87.5 * M_PI/180 clockwise:YES];
        CGAffineTransform pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound));;
        pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound));;
        [humanstartingPath applyTransform:pathTransform];
        return humanstartingPath;
    }
    return nil;
}

- (UIBezierPath*)humanstartingggPathWithBounds:(CGRect)bound{
    UIBezierPath *oval2Path = [UIBezierPath bezierPath];
    CGFloat minX = CGRectGetMinX(bound), minY = CGRectGetMinY(bound), w = CGRectGetWidth(bound), h = CGRectGetHeight(bound);
    
    [oval2Path moveToPoint:CGPointMake(minX + 0.49954 * w, minY)];
    [oval2Path addCurveToPoint:CGPointMake(minX + w, minY + 0.5 * h) controlPoint1:CGPointMake(minX + 0.77594 * w, minY) controlPoint2:CGPointMake(minX + w, minY + 0.22386 * h)];
    [oval2Path addCurveToPoint:CGPointMake(minX + 0.49954 * w, minY + h) controlPoint1:CGPointMake(minX + w, minY + 0.77614 * h) controlPoint2:CGPointMake(minX + 0.77594 * w, minY + h)];
    [oval2Path addCurveToPoint:CGPointMake(minX + 0.00014 * w, minY + 0.53274 * h) controlPoint1:CGPointMake(minX + 0.23415 * w, minY + h) controlPoint2:CGPointMake(minX + 0.01701 * w, minY + 0.79362 * h)];
    [oval2Path addCurveToPoint:CGPointMake(minX + 0.00162 * w, minY + 0.28143 * h) controlPoint1:CGPointMake(minX + -0.00056 * w, minY + 0.52191 * h) controlPoint2:CGPointMake(minX + 0.00162 * w, minY + 0.29243 * h)];
    
    return oval2Path;
    
}

- (UIBezierPath*)humanstartinggPathWithBounds:(CGRect)bound{
    if(humanvaluee>0 && humanvaluee<mhumanvaluee){
        float f=(180*(humanvaluee/mhumanvaluee));
        f=f+(2*(180-f));
        if (CGRectEqualToRect(bound, CGRectZero)) return nil;
        UIBezierPath*  humanstartingPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, 0) radius:CGRectGetWidth(bound)/2 startAngle:-90 * M_PI/180 endAngle:-f * M_PI/180 clockwise:YES];
        CGAffineTransform pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound));;
        pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound));;
        [humanstartingPath applyTransform:pathTransform];
        return humanstartingPath;
    }
    else if(humanvaluee==mhumanvaluee){
        UIBezierPath *oval2Path = [UIBezierPath bezierPath];
        CGFloat minX = CGRectGetMinX(bound), minY = CGRectGetMinY(bound), w = CGRectGetWidth(bound), h = CGRectGetHeight(bound);
        
        [oval2Path moveToPoint:CGPointMake(minX + 0.49954 * w, minY)];
        [oval2Path addCurveToPoint:CGPointMake(minX + w, minY + 0.5 * h) controlPoint1:CGPointMake(minX + 0.77594 * w, minY) controlPoint2:CGPointMake(minX + w, minY + 0.22386 * h)];
        [oval2Path addCurveToPoint:CGPointMake(minX + 0.49954 * w, minY + h) controlPoint1:CGPointMake(minX + w, minY + 0.77614 * h) controlPoint2:CGPointMake(minX + 0.77594 * w, minY + h)];
        [oval2Path addCurveToPoint:CGPointMake(minX + 0.00014 * w, minY + 0.53274 * h) controlPoint1:CGPointMake(minX + 0.23415 * w, minY + h) controlPoint2:CGPointMake(minX + 0.01701 * w, minY + 0.79362 * h)];
        [oval2Path addCurveToPoint:CGPointMake(minX + 0.00162 * w, minY + 0.20143 * h) controlPoint1:CGPointMake(minX + -0.00056 * w, minY + 0.52191 * h) controlPoint2:CGPointMake(minX + 0.00162 * w, minY + 0.20243 * h)];
        
        return oval2Path;
    }
    else if(humanvaluee==0){
        UIBezierPath*  humanstartingPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, 0) radius:CGRectGetWidth(bound)/2 startAngle:-90 * M_PI/180 endAngle:-88.5 * M_PI/180 clockwise:YES];
        CGAffineTransform pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound));;
        pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound));;
        [humanstartingPath applyTransform:pathTransform];
        return humanstartingPath;
    }
    return nil;
}


- (UIBezierPath*)energystartlinePathWithBounds:(CGRect)bound{
    UIBezierPath *energystartlinePath = [UIBezierPath bezierPath];
    CGFloat minX = CGRectGetMinX(bound), minY = CGRectGetMinY(bound), w = CGRectGetWidth(bound), h = CGRectGetHeight(bound);
    
    [energystartlinePath moveToPoint:CGPointMake(minX+(0.0045*w), minY + h)];
    [energystartlinePath addCurveToPoint:CGPointMake(minX + w, minY) controlPoint1:CGPointMake(minX + 0.33927 * w, minY + h) controlPoint2:CGPointMake(minX + 0.66073 * w, minY)];
    
    return energystartlinePath;
}

- (UIBezierPath*)waterstartlinePathWithBounds:(CGRect)bound{
    UIBezierPath *waterstartlinePath = [UIBezierPath bezierPath];
    CGFloat minX = CGRectGetMinX(bound), minY = CGRectGetMinY(bound), w = CGRectGetWidth(bound), h = CGRectGetHeight(bound);
    
    [waterstartlinePath moveToPoint:CGPointMake(minX+(0.0025*w), minY + h)];
    [waterstartlinePath addCurveToPoint:CGPointMake(minX + w, minY) controlPoint1:CGPointMake(minX + 0.34354 * w, minY + h) controlPoint2:CGPointMake(minX + 0.65646 * w, minY)];
    
    return waterstartlinePath;
}

- (UIBezierPath*)wastestartlinePathWithBounds:(CGRect)bound{
    UIBezierPath *wastestartlinePath = [UIBezierPath bezierPath];
    CGFloat minX = CGRectGetMinX(bound), minY = CGRectGetMinY(bound), w = CGRectGetWidth(bound), h = CGRectGetHeight(bound);
    
    [wastestartlinePath moveToPoint:CGPointMake(minX, minY + h)];
    [wastestartlinePath addCurveToPoint:CGPointMake(minX + w, minY) controlPoint1:CGPointMake(minX + 0.34039 * w, minY + h) controlPoint2:CGPointMake(minX + 0.65961 * w, minY)];
    
    return wastestartlinePath;
}

- (UIBezierPath*)transportstartlinePathWithBounds:(CGRect)bound{
    UIBezierPath *transportstartlinePath = [UIBezierPath bezierPath];
    CGFloat minX = CGRectGetMinX(bound), minY = CGRectGetMinY(bound), w = CGRectGetWidth(bound), h = CGRectGetHeight(bound);
    
    [transportstartlinePath moveToPoint:CGPointMake(minX, minY + h)];
    [transportstartlinePath addCurveToPoint:CGPointMake(minX + w, minY) controlPoint1:CGPointMake(minX + 0.33991 * w, minY + h) controlPoint2:CGPointMake(minX + 0.66009 * w, minY)];
    
    return transportstartlinePath;
}

- (UIBezierPath*)humanstartlinePathWithBounds:(CGRect)bound{
    UIBezierPath *humanstartlinePath = [UIBezierPath bezierPath];
    CGFloat minX = CGRectGetMinX(bound), minY = CGRectGetMinY(bound), w = CGRectGetWidth(bound), h = CGRectGetHeight(bound);
    
    [humanstartlinePath moveToPoint:CGPointMake(minX, minY + h)];
    [humanstartlinePath addCurveToPoint:CGPointMake(minX + w, minY) controlPoint1:CGPointMake(minX + 0.34156 * w, minY + h) controlPoint2:CGPointMake(minX + 0.65844 * w, minY)];
    
    return humanstartlinePath;
}

- (UIBezierPath*)humanarrowPathWithBounds:(CGRect)bound{
    UIBezierPath *humanarrowPath = [UIBezierPath bezierPath];
    CGFloat minX = CGRectGetMinX(bound), minY = CGRectGetMinY(bound), w = CGRectGetWidth(bound), h = CGRectGetHeight(bound);
    
    [humanarrowPath moveToPoint:CGPointMake(minX, minY + h)];
    [humanarrowPath addLineToPoint:CGPointMake(minX + 0.83986 * w, minY + 0.86725 * h)];
    [humanarrowPath addLineToPoint:CGPointMake(minX + w, minY)];
    [humanarrowPath addLineToPoint:CGPointMake(minX + 0.24943 * w, minY + 0.2309 * h)];
    [humanarrowPath closePath];
    [humanarrowPath moveToPoint:CGPointMake(minX, minY + h)];
    
    return humanarrowPath;
    
}

- (UIBezierPath*)transportarrowPathWithBounds:(CGRect)bound{
    UIBezierPath *transportarrowPath = [UIBezierPath bezierPath];
    CGFloat minX = CGRectGetMinX(bound), minY = CGRectGetMinY(bound), w = CGRectGetWidth(bound), h = CGRectGetHeight(bound);
    
    [transportarrowPath moveToPoint:CGPointMake(minX, minY + h)];
    [transportarrowPath addLineToPoint:CGPointMake(minX + 0.83986 * w, minY + 0.86725 * h)];
    [transportarrowPath addLineToPoint:CGPointMake(minX + w, minY)];
    [transportarrowPath addLineToPoint:CGPointMake(minX + 0.24943 * w, minY + 0.2309 * h)];
    [transportarrowPath closePath];
    [transportarrowPath moveToPoint:CGPointMake(minX, minY + h)];
    
    return transportarrowPath;
}

- (UIBezierPath*)wastearrowPathWithBounds:(CGRect)bound{
    UIBezierPath *wastearrowPath = [UIBezierPath bezierPath];
    CGFloat minX = CGRectGetMinX(bound), minY = CGRectGetMinY(bound), w = CGRectGetWidth(bound), h = CGRectGetHeight(bound);
    
    [wastearrowPath moveToPoint:CGPointMake(minX, minY + h)];
    [wastearrowPath addLineToPoint:CGPointMake(minX + 0.83986 * w, minY + 0.86725 * h)];
    [wastearrowPath addLineToPoint:CGPointMake(minX + w, minY)];
    [wastearrowPath addLineToPoint:CGPointMake(minX + 0.24943 * w, minY + 0.2309 * h)];
    [wastearrowPath closePath];
    [wastearrowPath moveToPoint:CGPointMake(minX, minY + h)];
    
    return wastearrowPath;
}

- (UIBezierPath*)waterarrowPathWithBounds:(CGRect)bound{
    UIBezierPath *waterarrowPath = [UIBezierPath bezierPath];
    CGFloat minX = CGRectGetMinX(bound), minY = CGRectGetMinY(bound), w = CGRectGetWidth(bound), h = CGRectGetHeight(bound);
    
    [waterarrowPath moveToPoint:CGPointMake(minX, minY + h)];
    [waterarrowPath addLineToPoint:CGPointMake(minX + 0.83986 * w, minY + 0.86725 * h)];
    [waterarrowPath addLineToPoint:CGPointMake(minX + w, minY)];
    [waterarrowPath addLineToPoint:CGPointMake(minX + 0.24943 * w, minY + 0.2309 * h)];
    [waterarrowPath closePath];
    [waterarrowPath moveToPoint:CGPointMake(minX, minY + h)];
    
    return waterarrowPath;
}

- (UIBezierPath*)energyarrowPathWithBounds:(CGRect)bound{
    UIBezierPath *energyarrowPath = [UIBezierPath bezierPath];
    CGFloat minX = CGRectGetMinX(bound), minY = CGRectGetMinY(bound), w = CGRectGetWidth(bound), h = CGRectGetHeight(bound);
    
    [energyarrowPath moveToPoint:CGPointMake(minX, minY + h)];
    [energyarrowPath addLineToPoint:CGPointMake(minX + 0.83986 * w, minY + 0.86725 * h)];
    [energyarrowPath addLineToPoint:CGPointMake(minX + w, minY)];
    [energyarrowPath addLineToPoint:CGPointMake(minX + 0.24943 * w, minY + 0.2309 * h)];
    [energyarrowPath closePath];
    [energyarrowPath moveToPoint:CGPointMake(minX, minY + h)];
    
    return energyarrowPath;
}

- (UIBezierPath*)energyboomPathWithBounds:(CGRect)bound{
    UIBezierPath *energyboomPath = [UIBezierPath bezierPath];
    CGFloat minX = CGRectGetMinX(bound), minY = CGRectGetMinY(bound), w = CGRectGetWidth(bound), h = CGRectGetHeight(bound);
    
    [energyboomPath moveToPoint:CGPointMake(minX + 0.85355 * w, minY + 0.85355 * h)];
    [energyboomPath addCurveToPoint:CGPointMake(minX + 0.85355 * w, minY + 0.14645 * h) controlPoint1:CGPointMake(minX + 1.04882 * w, minY + 0.65829 * h) controlPoint2:CGPointMake(minX + 1.04882 * w, minY + 0.34171 * h)];
    [energyboomPath addCurveToPoint:CGPointMake(minX + 0.14645 * w, minY + 0.14645 * h) controlPoint1:CGPointMake(minX + 0.65829 * w, minY + -0.04882 * h) controlPoint2:CGPointMake(minX + 0.34171 * w, minY + -0.04882 * h)];
    [energyboomPath addCurveToPoint:CGPointMake(minX + 0.14645 * w, minY + 0.85355 * h) controlPoint1:CGPointMake(minX + -0.04882 * w, minY + 0.34171 * h) controlPoint2:CGPointMake(minX + -0.04882 * w, minY + 0.65829 * h)];
    [energyboomPath addCurveToPoint:CGPointMake(minX + 0.85355 * w, minY + 0.85355 * h) controlPoint1:CGPointMake(minX + 0.34171 * w, minY + 1.04882 * h) controlPoint2:CGPointMake(minX + 0.65829 * w, minY + 1.04882 * h)];
    
    return energyboomPath;
}

- (UIBezierPath*)waterboomPathWithBounds:(CGRect)bound{
    UIBezierPath *waterboomPath = [UIBezierPath bezierPath];
    CGFloat minX = CGRectGetMinX(bound), minY = CGRectGetMinY(bound), w = CGRectGetWidth(bound), h = CGRectGetHeight(bound);
    
    [waterboomPath moveToPoint:CGPointMake(minX + 0.85355 * w, minY + 0.85355 * h)];
    [waterboomPath addCurveToPoint:CGPointMake(minX + 0.85355 * w, minY + 0.14645 * h) controlPoint1:CGPointMake(minX + 1.04882 * w, minY + 0.65829 * h) controlPoint2:CGPointMake(minX + 1.04882 * w, minY + 0.34171 * h)];
    [waterboomPath addCurveToPoint:CGPointMake(minX + 0.14645 * w, minY + 0.14645 * h) controlPoint1:CGPointMake(minX + 0.65829 * w, minY + -0.04882 * h) controlPoint2:CGPointMake(minX + 0.34171 * w, minY + -0.04882 * h)];
    [waterboomPath addCurveToPoint:CGPointMake(minX + 0.14645 * w, minY + 0.85355 * h) controlPoint1:CGPointMake(minX + -0.04882 * w, minY + 0.34171 * h) controlPoint2:CGPointMake(minX + -0.04882 * w, minY + 0.65829 * h)];
    [waterboomPath addCurveToPoint:CGPointMake(minX + 0.85355 * w, minY + 0.85355 * h) controlPoint1:CGPointMake(minX + 0.34171 * w, minY + 1.04882 * h) controlPoint2:CGPointMake(minX + 0.65829 * w, minY + 1.04882 * h)];
    
    return waterboomPath;
}

- (UIBezierPath*)wasteboomPathWithBounds:(CGRect)bound{
    UIBezierPath *wasteboomPath = [UIBezierPath bezierPath];
    CGFloat minX = CGRectGetMinX(bound), minY = CGRectGetMinY(bound), w = CGRectGetWidth(bound), h = CGRectGetHeight(bound);
    
    [wasteboomPath moveToPoint:CGPointMake(minX + 0.85355 * w, minY + 0.85355 * h)];
    [wasteboomPath addCurveToPoint:CGPointMake(minX + 0.85355 * w, minY + 0.14645 * h) controlPoint1:CGPointMake(minX + 1.04882 * w, minY + 0.65829 * h) controlPoint2:CGPointMake(minX + 1.04882 * w, minY + 0.34171 * h)];
    [wasteboomPath addCurveToPoint:CGPointMake(minX + 0.14645 * w, minY + 0.14645 * h) controlPoint1:CGPointMake(minX + 0.65829 * w, minY + -0.04882 * h) controlPoint2:CGPointMake(minX + 0.34171 * w, minY + -0.04882 * h)];
    [wasteboomPath addCurveToPoint:CGPointMake(minX + 0.14645 * w, minY + 0.85355 * h) controlPoint1:CGPointMake(minX + -0.04882 * w, minY + 0.34171 * h) controlPoint2:CGPointMake(minX + -0.04882 * w, minY + 0.65829 * h)];
    [wasteboomPath addCurveToPoint:CGPointMake(minX + 0.85355 * w, minY + 0.85355 * h) controlPoint1:CGPointMake(minX + 0.34171 * w, minY + 1.04882 * h) controlPoint2:CGPointMake(minX + 0.65829 * w, minY + 1.04882 * h)];
    
    return wasteboomPath;
}

- (UIBezierPath*)transportboomPathWithBounds:(CGRect)bound{
    UIBezierPath *transportboomPath = [UIBezierPath bezierPath];
    CGFloat minX = CGRectGetMinX(bound), minY = CGRectGetMinY(bound), w = CGRectGetWidth(bound), h = CGRectGetHeight(bound);
    
    [transportboomPath moveToPoint:CGPointMake(minX + 0.85355 * w, minY + 0.85355 * h)];
    [transportboomPath addCurveToPoint:CGPointMake(minX + 0.85355 * w, minY + 0.14645 * h) controlPoint1:CGPointMake(minX + 1.04882 * w, minY + 0.65829 * h) controlPoint2:CGPointMake(minX + 1.04882 * w, minY + 0.34171 * h)];
    [transportboomPath addCurveToPoint:CGPointMake(minX + 0.14645 * w, minY + 0.14645 * h) controlPoint1:CGPointMake(minX + 0.65829 * w, minY + -0.04882 * h) controlPoint2:CGPointMake(minX + 0.34171 * w, minY + -0.04882 * h)];
    [transportboomPath addCurveToPoint:CGPointMake(minX + 0.14645 * w, minY + 0.85355 * h) controlPoint1:CGPointMake(minX + -0.04882 * w, minY + 0.34171 * h) controlPoint2:CGPointMake(minX + -0.04882 * w, minY + 0.65829 * h)];
    [transportboomPath addCurveToPoint:CGPointMake(minX + 0.85355 * w, minY + 0.85355 * h) controlPoint1:CGPointMake(minX + 0.34171 * w, minY + 1.04882 * h) controlPoint2:CGPointMake(minX + 0.65829 * w, minY + 1.04882 * h)];
    
    return transportboomPath;
}

- (UIBezierPath*)humanboomPathWithBounds:(CGRect)bound{
    UIBezierPath *humanboomPath = [UIBezierPath bezierPath];
    CGFloat minX = CGRectGetMinX(bound), minY = CGRectGetMinY(bound), w = CGRectGetWidth(bound), h = CGRectGetHeight(bound);
    
    [humanboomPath moveToPoint:CGPointMake(minX + 0.85355 * w, minY + 0.85355 * h)];
    [humanboomPath addCurveToPoint:CGPointMake(minX + 0.85355 * w, minY + 0.14645 * h) controlPoint1:CGPointMake(minX + 1.04882 * w, minY + 0.65829 * h) controlPoint2:CGPointMake(minX + 1.04882 * w, minY + 0.34171 * h)];
    [humanboomPath addCurveToPoint:CGPointMake(minX + 0.14645 * w, minY + 0.14645 * h) controlPoint1:CGPointMake(minX + 0.65829 * w, minY + -0.04882 * h) controlPoint2:CGPointMake(minX + 0.34171 * w, minY + -0.04882 * h)];
    [humanboomPath addCurveToPoint:CGPointMake(minX + 0.14645 * w, minY + 0.85355 * h) controlPoint1:CGPointMake(minX + -0.04882 * w, minY + 0.34171 * h) controlPoint2:CGPointMake(minX + -0.04882 * w, minY + 0.65829 * h)];
    [humanboomPath addCurveToPoint:CGPointMake(minX + 0.85355 * w, minY + 0.85355 * h) controlPoint1:CGPointMake(minX + 0.34171 * w, minY + 1.04882 * h) controlPoint2:CGPointMake(minX + 0.65829 * w, minY + 1.04882 * h)];
    
    return humanboomPath;
}

- (UIBezierPath*)adjustWithBounds:(CGRect)bound{
    UIBezierPath *rectanglePath = [UIBezierPath bezierPath];
    CGFloat minX = CGRectGetMinX(bound), minY = CGRectGetMinY(bound), w = CGRectGetWidth(bound), h = CGRectGetHeight(bound);
    
    [rectanglePath moveToPoint:CGPointMake(minX + w, minY + h)];
    [rectanglePath addLineToPoint:CGPointMake(minX, minY)];
    [rectanglePath closePath];
    [rectanglePath moveToPoint:CGPointMake(minX + w, minY + h)];
    
    return rectanglePath;
}

- (UIBezierPath*)energylevelerPathWithBounds:(CGRect)bound{
    UIBezierPath * energylevelerPath = [UIBezierPath bezierPathWithRect:bound];
    return energylevelerPath;
}


- (UIBezierPath*)waterlevelerPathWithBounds:(CGRect)bound{
    UIBezierPath * levelerPath = [UIBezierPath bezierPathWithRect:bound];
    return levelerPath;
}
- (UIBezierPath*)wastelevelerPathWithBounds:(CGRect)bound{
    UIBezierPath * levelerPath = [UIBezierPath bezierPathWithRect:bound];
    return levelerPath;
}
- (UIBezierPath*)transportlevelerPathWithBounds:(CGRect)bound{
    UIBezierPath * levelerPath = [UIBezierPath bezierPathWithRect:bound];
    return levelerPath;
}
- (UIBezierPath*)humanlevelerPathWithBounds:(CGRect)bound{
    UIBezierPath * levelerPath = [UIBezierPath bezierPathWithRect:bound];
    return levelerPath;
}

- (UIBezierPath*)rectanglePathWithBounds:(CGRect)bound{
    UIBezierPath *rectanglePath = [UIBezierPath bezierPath];
    CGFloat minX = CGRectGetMinX(bound), minY = CGRectGetMinY(bound), w = CGRectGetWidth(bound), h = CGRectGetHeight(bound);
    
    [rectanglePath moveToPoint:CGPointMake(minX, minY + h)];
    [rectanglePath addLineToPoint:CGPointMake(minX + w, minY + h)];
    [rectanglePath addLineToPoint:CGPointMake(minX, minY)];
    [rectanglePath addLineToPoint:CGPointMake(minX, minY)];
    [rectanglePath closePath];
    [rectanglePath moveToPoint:CGPointMake(minX, minY + h)];
    
    return rectanglePath;
}



@end
