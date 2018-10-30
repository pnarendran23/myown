//
//  arcloading.m
//
//  Code generated using QuartzCode 1.52.0 on 19/12/16.
//  www.quartzcodeapp.com
//

#import "arcloading.h"
#import "QCMethod.h"

@interface arcloading ()

@property (nonatomic, strong) NSMutableDictionary * layers;


@end

@implementation arcloading
CADisplayLink *displayLink;
#pragma mark - Life Cycle
float linewidth = 0.0;
float fontsizeforarc = 0.0;
float validatefontsize = 0.0;
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

- (void)setFrame:(CGRect)frame{
	[super setFrame:frame];
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
       linewidth = 0.067 * self.frame.size.width;
        fontsizeforarc = 0.145*self.frame.size.width;
        validatefontsize =  0.087*self.frame.size.width;
    }else{
       linewidth = 0.027 * self.frame.size.width;
        fontsizeforarc = 0.105*self.frame.size.width;
        validatefontsize =  0.047*self.frame.size.width;
    }
	[self setupLayerFrames];
}

- (void)setBounds:(CGRect)bounds{
	[super setBounds:bounds];
	[self setupLayerFrames];
}

- (void)setupProperties{
	self.layers = [NSMutableDictionary dictionary];
	
}


- (void)setupLayers{
	CATextLayer * text = [CATextLayer layer];
	[self.layer addSublayer:text];
    text.contentsScale   = 2;
    text.wrapped                  = YES;
    text.truncationMode           = kCATruncationMiddle;
	text.string          = @"\n";
	text.font            = (__bridge CFTypeRef)@"OpenSans-Bold";
	text.fontSize        = fontsizeforarc;
	text.alignmentMode   = kCAAlignmentRight;
    text.foregroundColor = [UIColor whiteColor].CGColor;//[UIColor colorWithRed:0.404 green: 0.404 blue:0.404 alpha:1].CGColor;
	self.layers[@"text"] = text;
	
	CALayer * inner = [CALayer layer];
	[self.layer addSublayer:inner];
	
	self.layers[@"inner"] = inner;
	{
		CAShapeLayer * layer1 = [CAShapeLayer layer];
		[inner addSublayer:layer1];
		layer1.fillColor   = nil;
		layer1.strokeColor = [UIColor colorWithRed:0.835 green: 0.835 blue:0.835 alpha:1].CGColor;
		layer1.lineWidth   =
		layer1.strokeStart = 0.1;
		layer1.strokeEnd   = 0.9;
		self.layers[@"layer1"] = layer1;
		CAShapeLayer * layer2 = [CAShapeLayer layer];
		[inner addSublayer:layer2];
		layer2.fillColor   = nil;
		layer2.strokeColor = [UIColor colorWithRed:0.835 green: 0.835 blue:0.835 alpha:1].CGColor;
		layer2.lineWidth   = linewidth;
		layer2.strokeStart = 0.1;
		layer2.strokeEnd   = 0.9;
		self.layers[@"layer2"] = layer2;
		CAShapeLayer * layer3 = [CAShapeLayer layer];
		[inner addSublayer:layer3];
		layer3.fillColor   = nil;
		layer3.strokeColor = [UIColor colorWithRed:0.835 green: 0.835 blue:0.835 alpha:1].CGColor;
		layer3.lineWidth   = linewidth;
		layer3.strokeStart = 0.1;
		layer3.strokeEnd   = 0.9;
		self.layers[@"layer3"] = layer3;
		CAShapeLayer * layer4 = [CAShapeLayer layer];
		[inner addSublayer:layer4];
		layer4.fillColor   = nil;
		layer4.strokeColor = [UIColor colorWithRed:0.835 green: 0.835 blue:0.835 alpha:1].CGColor;
		layer4.lineWidth   = linewidth;
		layer4.strokeStart = 0.1;
		layer4.strokeEnd   = 0.9;
		self.layers[@"layer4"] = layer4;
		CAShapeLayer * layer5 = [CAShapeLayer layer];
		[inner addSublayer:layer5];
		layer5.fillColor   = nil;
		layer5.strokeColor = [UIColor colorWithRed:0.835 green: 0.835 blue:0.835 alpha:1].CGColor;
		layer5.lineWidth   = linewidth;
		layer5.strokeStart = 0.1;
		layer5.strokeEnd   = 0.9;
		self.layers[@"layer5"] = layer5;
	}
	
	
	CALayer * outer = [CALayer layer];
	[self.layer addSublayer:outer];
	
	self.layers[@"outer"] = outer;
	{
		CAShapeLayer * outerlayer1 = [CAShapeLayer layer];
		[outer addSublayer:outerlayer1];
		outerlayer1.fillColor   = nil;
		outerlayer1.strokeColor = [UIColor colorWithRed:0.92 green: 0.609 blue:0.236 alpha:1].CGColor;
		outerlayer1.lineWidth   = linewidth;
		outerlayer1.strokeStart = 0.1;
		outerlayer1.strokeEnd   = 0.9;
		self.layers[@"outerlayer1"] = outerlayer1;
		CAShapeLayer * outerlayer2 = [CAShapeLayer layer];
		[outer addSublayer:outerlayer2];
		outerlayer2.fillColor   = nil;
		outerlayer2.strokeColor = [UIColor colorWithRed:0.572 green: 0.556 blue:0.505 alpha:1].CGColor;
		outerlayer2.lineWidth   = linewidth;
		outerlayer2.strokeStart = 0.1;
		outerlayer2.strokeEnd   = 0.9;
		self.layers[@"outerlayer2"] = outerlayer2;
		CAShapeLayer * outerlayer3 = [CAShapeLayer layer];
		[outer addSublayer:outerlayer3];
		outerlayer3.fillColor   = nil;
		outerlayer3.strokeColor = [UIColor colorWithRed:0.691 green: 0.789 blue:0.762 alpha:1].CGColor;
		outerlayer3.lineWidth   = linewidth;
		outerlayer3.strokeStart = 0.1;
		outerlayer3.strokeEnd   = 0.9;
		self.layers[@"outerlayer3"] = outerlayer3;
		CAShapeLayer * outerlayer4 = [CAShapeLayer layer];
		[outer addSublayer:outerlayer4];
		outerlayer4.fillColor   = nil;
		outerlayer4.strokeColor = [UIColor colorWithRed:0.303 green: 0.751 blue:0.94 alpha:1].CGColor;
		outerlayer4.lineWidth   = linewidth;
		outerlayer4.strokeStart = 0.1;
		outerlayer4.strokeEnd   = 0.9;
		self.layers[@"outerlayer4"] = outerlayer4;
		CAShapeLayer * outerlayer5 = [CAShapeLayer layer];
		[outer addSublayer:outerlayer5];
		outerlayer5.fillColor   = nil;
		outerlayer5.strokeColor = [UIColor colorWithRed:0.776 green: 0.859 blue:0.122 alpha:1].CGColor;
		outerlayer5.lineWidth   = linewidth;
		outerlayer5.strokeStart = 0.1;
		outerlayer5.strokeEnd   = 0.9;
		self.layers[@"outerlayer5"] = outerlayer5;
        
       
    }
    CATextLayer * validatingtext = [CATextLayer layer];
    [self.layer addSublayer:validatingtext];
    validatingtext.contentsScale   = [[UIScreen mainScreen] scale];
    validatingtext.string          = @"Validating credentials..";
    validatingtext.font            = (__bridge CFTypeRef)@"OpenSans-semibold";
    validatingtext.fontSize        = validatefontsize;
    validatingtext.alignmentMode   = kCAAlignmentCenter;
    validatingtext.foregroundColor = [UIColor blackColor].CGColor;
    self.layers[@"validatingtext"] = validatingtext;

    CALayer * arc_back = [CALayer layer];
    [self.layer addSublayer:arc_back];
    arc_back.contents = (id)[UIImage imageNamed:@"arc_back"].CGImage;
    self.layers[@"arc_back"] = arc_back;
    
    
	[self setupLayerFrames];
}

- (void)setupLayerFrames{
	[CATransaction begin];
	[CATransaction setDisableActions:YES];
	
    CATextLayer * text           = self.layers[@"text"];
    text.frame                   = CGRectMake(0.19951 * CGRectGetWidth(text.superlayer.bounds), 0.4 * CGRectGetHeight(text.superlayer.bounds), 0.40099 * CGRectGetWidth(text.superlayer.bounds), 0.2 * CGRectGetHeight(text.superlayer.bounds));
    
    CALayer * inner              = self.layers[@"inner"];
    inner.frame                  = CGRectMake(0.5 * CGRectGetWidth(inner.superlayer.bounds), 0.2 * CGRectGetHeight(inner.superlayer.bounds), 0.3 * CGRectGetWidth(inner.superlayer.bounds), 0.6 * CGRectGetHeight(inner.superlayer.bounds));
    
    CAShapeLayer * layer         = self.layers[@"layer1"];
    layer.frame                  = CGRectMake(0, 0.33333 * CGRectGetHeight(layer.superlayer.bounds), 0.33333 * CGRectGetWidth(layer.superlayer.bounds), 0.33333 * CGRectGetHeight(layer.superlayer.bounds));
    layer.path                   = [self layer1PathWithBounds:[self.layers[@"layer1"] bounds]].CGPath;
    
    CAShapeLayer * layer2        = self.layers[@"layer2"];
    layer2.frame                 = CGRectMake(0, 0.25 * CGRectGetHeight(layer2.superlayer.bounds), 0.5 * CGRectGetWidth(layer2.superlayer.bounds), 0.5 * CGRectGetHeight(layer2.superlayer.bounds));
    layer2.path                  = [self layer2PathWithBounds:[self.layers[@"layer2"] bounds]].CGPath;
    
    CAShapeLayer * layer3        = self.layers[@"layer3"];
    layer3.frame                 = CGRectMake(0, 0.16667 * CGRectGetHeight(layer3.superlayer.bounds), 0.66667 * CGRectGetWidth(layer3.superlayer.bounds), 0.66667 * CGRectGetHeight(layer3.superlayer.bounds));
    layer3.path                  = [self layer3PathWithBounds:[self.layers[@"layer3"] bounds]].CGPath;
    
    CAShapeLayer * layer4        = self.layers[@"layer4"];
    layer4.frame                 = CGRectMake(0, 0.08333 * CGRectGetHeight(layer4.superlayer.bounds), 0.83333 * CGRectGetWidth(layer4.superlayer.bounds), 0.83333 * CGRectGetHeight(layer4.superlayer.bounds));
    layer4.path                  = [self layer4PathWithBounds:[self.layers[@"layer4"] bounds]].CGPath;
    
    CAShapeLayer * layer5        = self.layers[@"layer5"];
    layer5.frame                 = CGRectMake(0, 0,  CGRectGetWidth(layer5.superlayer.bounds),  CGRectGetHeight(layer5.superlayer.bounds));
    layer5.path                  = [self layer5PathWithBounds:[self.layers[@"layer5"] bounds]].CGPath;
    
    CALayer * outer              = self.layers[@"outer"];
    outer.frame                  = CGRectMake(0.5 * CGRectGetWidth(outer.superlayer.bounds), 0.2 * CGRectGetHeight(outer.superlayer.bounds), 0.3 * CGRectGetWidth(outer.superlayer.bounds), 0.6 * CGRectGetHeight(outer.superlayer.bounds));
    
    CAShapeLayer * outerlayer    = self.layers[@"outerlayer1"];
    outerlayer.frame             = CGRectMake(0, 0.33333 * CGRectGetHeight(outerlayer.superlayer.bounds), 0.33333 * CGRectGetWidth(outerlayer.superlayer.bounds), 0.33333 * CGRectGetHeight(outerlayer.superlayer.bounds));
    outerlayer.path              = [self outerlayer1PathWithBounds:[self.layers[@"outerlayer1"] bounds]].CGPath;
    
    CAShapeLayer * outerlayer2   = self.layers[@"outerlayer2"];
    outerlayer2.frame            = CGRectMake(0, 0.25 * CGRectGetHeight(outerlayer2.superlayer.bounds), 0.5 * CGRectGetWidth(outerlayer2.superlayer.bounds), 0.5 * CGRectGetHeight(outerlayer2.superlayer.bounds));
    outerlayer2.path             = [self outerlayer2PathWithBounds:[self.layers[@"outerlayer2"] bounds]].CGPath;
    
    CAShapeLayer * outerlayer3   = self.layers[@"outerlayer3"];
    outerlayer3.frame            = CGRectMake(0, 0.16667 * CGRectGetHeight(outerlayer3.superlayer.bounds), 0.66667 * CGRectGetWidth(outerlayer3.superlayer.bounds), 0.66667 * CGRectGetHeight(outerlayer3.superlayer.bounds));
    outerlayer3.path             = [self outerlayer3PathWithBounds:[self.layers[@"outerlayer3"] bounds]].CGPath;
    
    CAShapeLayer * outerlayer4   = self.layers[@"outerlayer4"];
    outerlayer4.frame            = CGRectMake(0, 0.08333 * CGRectGetHeight(outerlayer4.superlayer.bounds), 0.83333 * CGRectGetWidth(outerlayer4.superlayer.bounds), 0.83333 * CGRectGetHeight(outerlayer4.superlayer.bounds));
    outerlayer4.path             = [self outerlayer4PathWithBounds:[self.layers[@"outerlayer4"] bounds]].CGPath;
    
    CAShapeLayer * outerlayer5   = self.layers[@"outerlayer5"];
    outerlayer5.frame            = CGRectMake(0, 0,  CGRectGetWidth(outerlayer5.superlayer.bounds),  CGRectGetHeight(outerlayer5.superlayer.bounds));
    outerlayer5.path             = [self outerlayer5PathWithBounds:[self.layers[@"outerlayer5"] bounds]].CGPath;
    
    CATextLayer * validatingtext = self.layers[@"validatingtext"];
    validatingtext.frame         = CGRectMake(0.19232 * CGRectGetWidth(validatingtext.superlayer.bounds), 0.89 * CGRectGetHeight(validatingtext.superlayer.bounds), 0.63536 * CGRectGetWidth(validatingtext.superlayer.bounds), 0.07216 * CGRectGetHeight(validatingtext.superlayer.bounds));
    
    CALayer * arc_back           = self.layers[@"arc_back"];
    arc_back.frame               = CGRectMake(0, 0, 1 * CGRectGetWidth(arc_back.superlayer.bounds), 1 * CGRectGetHeight(arc_back.superlayer.bounds));

    
    
    
	[CATransaction commit];
    [self performSelectorOnMainThread:@selector(tick) withObject:nil waitUntilDone:NO];
    
}

-(void)tick{
    [self addUntitled1Animation];
    NSTimer *timer2=[NSTimer scheduledTimerWithTimeInterval:(4) target:self selector:@selector(addUntitled1Animation) userInfo:nil repeats:YES];
}

#pragma mark - Animation Setup


- (void)addUntitled1Animation{
	NSString * fillMode = kCAFillModeForwards;
	
	////Outerlayer1 animation
	CAKeyframeAnimation * outerlayer1StrokeEndAnim = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
	outerlayer1StrokeEndAnim.values   = @[@0.1, @0.9];
	outerlayer1StrokeEndAnim.keyTimes = @[@0, @1];
	outerlayer1StrokeEndAnim.duration = 0.798;
	outerlayer1StrokeEndAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
	
	CAAnimationGroup * outerlayer1Untitled1Anim = [QCMethod groupAnimations:@[outerlayer1StrokeEndAnim] fillMode:fillMode];
	[self.layers[@"outerlayer1"] addAnimation:outerlayer1Untitled1Anim forKey:@"outerlayer1Untitled1Anim"];
	
	////Outerlayer2 animation
	CAKeyframeAnimation * outerlayer2StrokeEndAnim = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
	outerlayer2StrokeEndAnim.values   = @[@0.1, @0.1, @0.9];
	outerlayer2StrokeEndAnim.keyTimes = @[@0, @0.5, @1];
	outerlayer2StrokeEndAnim.duration = 1.6;
	outerlayer2StrokeEndAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
	
	CAAnimationGroup * outerlayer2Untitled1Anim = [QCMethod groupAnimations:@[outerlayer2StrokeEndAnim] fillMode:fillMode];
	[self.layers[@"outerlayer2"] addAnimation:outerlayer2Untitled1Anim forKey:@"outerlayer2Untitled1Anim"];
	
	////Outerlayer3 animation
	CAKeyframeAnimation * outerlayer3StrokeEndAnim = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
	outerlayer3StrokeEndAnim.values   = @[@0.1, @0.1, @0.9];
	outerlayer3StrokeEndAnim.keyTimes = @[@0, @0.667, @1];
	outerlayer3StrokeEndAnim.duration = 2.4;
	outerlayer3StrokeEndAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
	
	CAAnimationGroup * outerlayer3Untitled1Anim = [QCMethod groupAnimations:@[outerlayer3StrokeEndAnim] fillMode:fillMode];
	[self.layers[@"outerlayer3"] addAnimation:outerlayer3Untitled1Anim forKey:@"outerlayer3Untitled1Anim"];
	
	////Outerlayer4 animation
	CAKeyframeAnimation * outerlayer4StrokeEndAnim = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
	outerlayer4StrokeEndAnim.values   = @[@0.1, @0.1, @0.9];
	outerlayer4StrokeEndAnim.keyTimes = @[@0, @0.75, @1];
	outerlayer4StrokeEndAnim.duration = 3.19;
	outerlayer4StrokeEndAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
	
	CAAnimationGroup * outerlayer4Untitled1Anim = [QCMethod groupAnimations:@[outerlayer4StrokeEndAnim] fillMode:fillMode];
	[self.layers[@"outerlayer4"] addAnimation:outerlayer4Untitled1Anim forKey:@"outerlayer4Untitled1Anim"];
	
	////Outerlayer5 animation
	CAKeyframeAnimation * outerlayer5StrokeEndAnim = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
	outerlayer5StrokeEndAnim.values   = @[@0.1, @0.1, @0.9];
	outerlayer5StrokeEndAnim.keyTimes = @[@0, @0.8, @1];
	outerlayer5StrokeEndAnim.duration = 3.99;
	outerlayer5StrokeEndAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
	CAAnimationGroup * outerlayer5Untitled1Anim = [QCMethod groupAnimations:@[outerlayer5StrokeEndAnim] fillMode:fillMode];
	[self.layers[@"outerlayer5"] addAnimation:outerlayer5Untitled1Anim forKey:@"outerlayer5Untitled1Anim"];    
}

#pragma mark - Animation Cleanup

- (void)updateLayerValuesForAnimationId:(NSString *)identifier{
	if([identifier isEqualToString:@"Untitled1"]){
		[QCMethod updateValueFromPresentationLayerForAnimation:[self.layers[@"outerlayer1"] animationForKey:@"outerlayer1Untitled1Anim"] theLayer:self.layers[@"outerlayer1"]];
		[QCMethod updateValueFromPresentationLayerForAnimation:[self.layers[@"outerlayer2"] animationForKey:@"outerlayer2Untitled1Anim"] theLayer:self.layers[@"outerlayer2"]];
		[QCMethod updateValueFromPresentationLayerForAnimation:[self.layers[@"outerlayer3"] animationForKey:@"outerlayer3Untitled1Anim"] theLayer:self.layers[@"outerlayer3"]];
		[QCMethod updateValueFromPresentationLayerForAnimation:[self.layers[@"outerlayer4"] animationForKey:@"outerlayer4Untitled1Anim"] theLayer:self.layers[@"outerlayer4"]];
		[QCMethod updateValueFromPresentationLayerForAnimation:[self.layers[@"outerlayer5"] animationForKey:@"outerlayer5Untitled1Anim"] theLayer:self.layers[@"outerlayer5"]];
	}
}

- (void)removeAnimationsForAnimationId:(NSString *)identifier{
	if([identifier isEqualToString:@"Untitled1"]){
		[self.layers[@"outerlayer1"] removeAnimationForKey:@"outerlayer1Untitled1Anim"];
		[self.layers[@"outerlayer2"] removeAnimationForKey:@"outerlayer2Untitled1Anim"];
		[self.layers[@"outerlayer3"] removeAnimationForKey:@"outerlayer3Untitled1Anim"];
		[self.layers[@"outerlayer4"] removeAnimationForKey:@"outerlayer4Untitled1Anim"];
		[self.layers[@"outerlayer5"] removeAnimationForKey:@"outerlayer5Untitled1Anim"];
	}
}

- (void)removeAllAnimations{
	[self.layers enumerateKeysAndObjectsUsingBlock:^(id key, CALayer *layer, BOOL *stop) {
		[layer removeAllAnimations];
	}];
}

#pragma mark - Bezier Path

- (UIBezierPath*)layer1PathWithBounds:(CGRect)bounds{
	UIBezierPath *layer1Path = [UIBezierPath bezierPath];
	CGFloat minX = CGRectGetMinX(bounds), minY = CGRectGetMinY(bounds), w = CGRectGetWidth(bounds), h = CGRectGetHeight(bounds);
	
	[layer1Path moveToPoint:CGPointMake(minX, minY)];
	[layer1Path addCurveToPoint:CGPointMake(minX + w, minY + 0.5 * h) controlPoint1:CGPointMake(minX + 0.55228 * w, minY) controlPoint2:CGPointMake(minX + w, minY + 0.22386 * h)];
	[layer1Path addCurveToPoint:CGPointMake(minX, minY + h) controlPoint1:CGPointMake(minX + w, minY + 0.77614 * h) controlPoint2:CGPointMake(minX + 0.55228 * w, minY + h)];
	
	return layer1Path;
}

- (UIBezierPath*)layer2PathWithBounds:(CGRect)bounds{
	UIBezierPath *layer2Path = [UIBezierPath bezierPath];
	CGFloat minX = CGRectGetMinX(bounds), minY = CGRectGetMinY(bounds), w = CGRectGetWidth(bounds), h = CGRectGetHeight(bounds);
	
	[layer2Path moveToPoint:CGPointMake(minX, minY)];
	[layer2Path addCurveToPoint:CGPointMake(minX + w, minY + 0.5 * h) controlPoint1:CGPointMake(minX + 0.55228 * w, minY) controlPoint2:CGPointMake(minX + w, minY + 0.22386 * h)];
	[layer2Path addCurveToPoint:CGPointMake(minX, minY + h) controlPoint1:CGPointMake(minX + w, minY + 0.77614 * h) controlPoint2:CGPointMake(minX + 0.55228 * w, minY + h)];
	
	return layer2Path;
}

- (UIBezierPath*)layer3PathWithBounds:(CGRect)bounds{
	UIBezierPath *layer3Path = [UIBezierPath bezierPath];
	CGFloat minX = CGRectGetMinX(bounds), minY = CGRectGetMinY(bounds), w = CGRectGetWidth(bounds), h = CGRectGetHeight(bounds);
	
	[layer3Path moveToPoint:CGPointMake(minX, minY)];
	[layer3Path addCurveToPoint:CGPointMake(minX + w, minY + 0.5 * h) controlPoint1:CGPointMake(minX + 0.55228 * w, minY) controlPoint2:CGPointMake(minX + w, minY + 0.22386 * h)];
	[layer3Path addCurveToPoint:CGPointMake(minX, minY + h) controlPoint1:CGPointMake(minX + w, minY + 0.77614 * h) controlPoint2:CGPointMake(minX + 0.55228 * w, minY + h)];
	
	return layer3Path;
}

- (UIBezierPath*)layer4PathWithBounds:(CGRect)bounds{
	UIBezierPath *layer4Path = [UIBezierPath bezierPath];
	CGFloat minX = CGRectGetMinX(bounds), minY = CGRectGetMinY(bounds), w = CGRectGetWidth(bounds), h = CGRectGetHeight(bounds);
	
	[layer4Path moveToPoint:CGPointMake(minX, minY)];
	[layer4Path addCurveToPoint:CGPointMake(minX + w, minY + 0.5 * h) controlPoint1:CGPointMake(minX + 0.55228 * w, minY) controlPoint2:CGPointMake(minX + w, minY + 0.22386 * h)];
	[layer4Path addCurveToPoint:CGPointMake(minX, minY + h) controlPoint1:CGPointMake(minX + w, minY + 0.77614 * h) controlPoint2:CGPointMake(minX + 0.55228 * w, minY + h)];
	
	return layer4Path;
}

- (UIBezierPath*)layer5PathWithBounds:(CGRect)bounds{
	UIBezierPath *layer5Path = [UIBezierPath bezierPath];
	CGFloat minX = CGRectGetMinX(bounds), minY = CGRectGetMinY(bounds), w = CGRectGetWidth(bounds), h = CGRectGetHeight(bounds);
	
	[layer5Path moveToPoint:CGPointMake(minX, minY)];
	[layer5Path addCurveToPoint:CGPointMake(minX + w, minY + 0.5 * h) controlPoint1:CGPointMake(minX + 0.55228 * w, minY) controlPoint2:CGPointMake(minX + w, minY + 0.22386 * h)];
	[layer5Path addCurveToPoint:CGPointMake(minX, minY + h) controlPoint1:CGPointMake(minX + w, minY + 0.77614 * h) controlPoint2:CGPointMake(minX + 0.55228 * w, minY + h)];
	
	return layer5Path;
}

- (UIBezierPath*)outerlayer1PathWithBounds:(CGRect)bounds{
	UIBezierPath *outerlayer1Path = [UIBezierPath bezierPath];
	CGFloat minX = CGRectGetMinX(bounds), minY = CGRectGetMinY(bounds), w = CGRectGetWidth(bounds), h = CGRectGetHeight(bounds);
	
	[outerlayer1Path moveToPoint:CGPointMake(minX, minY)];
	[outerlayer1Path addCurveToPoint:CGPointMake(minX + w, minY + 0.5 * h) controlPoint1:CGPointMake(minX + 0.55228 * w, minY) controlPoint2:CGPointMake(minX + w, minY + 0.22386 * h)];
	[outerlayer1Path addCurveToPoint:CGPointMake(minX, minY + h) controlPoint1:CGPointMake(minX + w, minY + 0.77614 * h) controlPoint2:CGPointMake(minX + 0.55228 * w, minY + h)];
	
	return outerlayer1Path;
}

- (UIBezierPath*)outerlayer2PathWithBounds:(CGRect)bounds{
	UIBezierPath *outerlayer2Path = [UIBezierPath bezierPath];
	CGFloat minX = CGRectGetMinX(bounds), minY = CGRectGetMinY(bounds), w = CGRectGetWidth(bounds), h = CGRectGetHeight(bounds);
	
	[outerlayer2Path moveToPoint:CGPointMake(minX, minY)];
	[outerlayer2Path addCurveToPoint:CGPointMake(minX + w, minY + 0.5 * h) controlPoint1:CGPointMake(minX + 0.55228 * w, minY) controlPoint2:CGPointMake(minX + w, minY + 0.22386 * h)];
	[outerlayer2Path addCurveToPoint:CGPointMake(minX, minY + h) controlPoint1:CGPointMake(minX + w, minY + 0.77614 * h) controlPoint2:CGPointMake(minX + 0.55228 * w, minY + h)];
	
	return outerlayer2Path;
}

- (UIBezierPath*)outerlayer3PathWithBounds:(CGRect)bounds{
	UIBezierPath *outerlayer3Path = [UIBezierPath bezierPath];
	CGFloat minX = CGRectGetMinX(bounds), minY = CGRectGetMinY(bounds), w = CGRectGetWidth(bounds), h = CGRectGetHeight(bounds);
	
	[outerlayer3Path moveToPoint:CGPointMake(minX, minY)];
	[outerlayer3Path addCurveToPoint:CGPointMake(minX + w, minY + 0.5 * h) controlPoint1:CGPointMake(minX + 0.55228 * w, minY) controlPoint2:CGPointMake(minX + w, minY + 0.22386 * h)];
	[outerlayer3Path addCurveToPoint:CGPointMake(minX, minY + h) controlPoint1:CGPointMake(minX + w, minY + 0.77614 * h) controlPoint2:CGPointMake(minX + 0.55228 * w, minY + h)];
	
	return outerlayer3Path;
}

- (UIBezierPath*)outerlayer4PathWithBounds:(CGRect)bounds{
	UIBezierPath *outerlayer4Path = [UIBezierPath bezierPath];
	CGFloat minX = CGRectGetMinX(bounds), minY = CGRectGetMinY(bounds), w = CGRectGetWidth(bounds), h = CGRectGetHeight(bounds);
	
	[outerlayer4Path moveToPoint:CGPointMake(minX, minY)];
	[outerlayer4Path addCurveToPoint:CGPointMake(minX + w, minY + 0.5 * h) controlPoint1:CGPointMake(minX + 0.55228 * w, minY) controlPoint2:CGPointMake(minX + w, minY + 0.22386 * h)];
	[outerlayer4Path addCurveToPoint:CGPointMake(minX, minY + h) controlPoint1:CGPointMake(minX + w, minY + 0.77614 * h) controlPoint2:CGPointMake(minX + 0.55228 * w, minY + h)];
	
	return outerlayer4Path;
}

- (UIBezierPath*)outerlayer5PathWithBounds:(CGRect)bounds{
	UIBezierPath *outerlayer5Path = [UIBezierPath bezierPath];
	CGFloat minX = CGRectGetMinX(bounds), minY = CGRectGetMinY(bounds), w = CGRectGetWidth(bounds), h = CGRectGetHeight(bounds);
	
	[outerlayer5Path moveToPoint:CGPointMake(minX, minY)];
	[outerlayer5Path addCurveToPoint:CGPointMake(minX + w, minY + 0.5 * h) controlPoint1:CGPointMake(minX + 0.55228 * w, minY) controlPoint2:CGPointMake(minX + w, minY + 0.22386 * h)];
	[outerlayer5Path addCurveToPoint:CGPointMake(minX, minY + h) controlPoint1:CGPointMake(minX + w, minY + 0.77614 * h) controlPoint2:CGPointMake(minX + 0.55228 * w, minY + h)];
	
	return outerlayer5Path;
}


@end
