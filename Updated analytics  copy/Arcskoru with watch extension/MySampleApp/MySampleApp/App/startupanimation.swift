//
//  startupanimation.swift
//
//  Code generated using QuartzCode 1.52.0 on 02/01/17.
//  www.quartzcodeapp.com
//

import UIKit


class startupanimation: UIView {
	
	var layers : Dictionary<String, AnyObject> = [:]
	
	var grayColor : UIColor!
	var progressColor : UIColor!
	var finishColor : UIColor!
	
	//MARK: - Life Cycle
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupProperties()
		setupLayers()
	}
	
	required init?(coder aDecoder: NSCoder)
	{
		super.init(coder: aDecoder)
		setupProperties()
		setupLayers()
	}
	
	override var frame: CGRect{
		didSet{
			setupLayerFrames()
		}
	}
	
	override var bounds: CGRect{
		didSet{
			setupLayerFrames()
		}
	}
	
	func setupProperties(){
		self.grayColor = UIColor(red:0.831, green: 0.831, blue:0.831, alpha:1)
		self.progressColor = UIColor(red:0.176, green: 0.408, blue:0.996, alpha:1)
		self.finishColor = UIColor(red:0.298, green: 0.843, blue:0.267, alpha:1)
	}
	
	func setupLayers(){
		let path = CAShapeLayer()
		self.layer.addSublayer(path)
		path.hidden      = true
		path.fillColor   = nil
		path.strokeColor = UIColor(red:0.831, green: 0.831, blue:0.831, alpha:1).CGColor
		path.lineWidth   = 15
		layers["path"] = path
		
		let oval = CAShapeLayer()
		self.layer.addSublayer(oval)
		oval.fillColor   = nil
		oval.strokeColor = self.grayColor.CGColor
		oval.lineWidth   = 24
		layers["oval"] = oval
		
		let oval2 = CAShapeLayer()
		self.layer.addSublayer(oval2)
		oval2.lineCap     = kCALineCapRound
		oval2.lineJoin    = kCALineJoinRound
		oval2.fillColor   = nil
		oval2.strokeColor = self.progressColor.CGColor
		oval2.lineWidth   = 24
		oval2.strokeStart = 1
		oval2.strokeEnd   = 0.99
		layers["oval2"] = oval2
		
		let path2 = CAShapeLayer()
		self.layer.addSublayer(path2)
		path2.lineCap     = kCALineCapRound
		path2.lineJoin    = kCALineJoinRound
		path2.fillColor   = nil
		path2.strokeColor = self.grayColor.CGColor
		path2.lineWidth   = 15
		layers["path2"] = path2
		
		let path3 = CAShapeLayer()
		self.layer.addSublayer(path3)
		path3.hidden      = true
		path3.setValue(-180 * CGFloat(M_PI)/180, forKeyPath:"transform.rotation")
		path3.lineCap     = kCALineCapRound
		path3.lineJoin    = kCALineJoinRound
		path3.fillColor   = nil
		path3.strokeColor = self.progressColor.CGColor
		path3.lineWidth   = 15
		layers["path3"] = path3
		
		let text = CATextLayer()
		self.layer.addSublayer(text)
		text.hidden          = true
		text.contentsScale   = UIScreen.mainScreen().scale
		text.string          = "Completed\n"
		text.font            = "HelveticaNeue-Medium"
		text.fontSize        = 23
		text.alignmentMode   = kCAAlignmentCenter;
		text.foregroundColor = self.finishColor.CGColor;
		layers["text"] = text        
		setupLayerFrames()
	}
	
	func setupLayerFrames(){
		CATransaction.begin()
		CATransaction.setDisableActions(true)
		
		if let path : CAShapeLayer = layers["path"] as? CAShapeLayer{
			path.frame = CGRectMake(0.46751 * path.superlayer!.bounds.width, 0.71402 * path.superlayer!.bounds.height, 0.24953 * path.superlayer!.bounds.width, 0.17552 * path.superlayer!.bounds.height)
			path.path  = pathPathWithBounds((layers["path"] as! CAShapeLayer).bounds).CGPath
		}
		
		if let oval : CAShapeLayer = layers["oval"] as? CAShapeLayer{
			oval.frame = CGRectMake(0.1506 * oval.superlayer!.bounds.width, 0.06658 * oval.superlayer!.bounds.height, 0.6988 * oval.superlayer!.bounds.width, 0.6988 * oval.superlayer!.bounds.height)
			oval.path  = ovalPathWithBounds((layers["oval"] as! CAShapeLayer).bounds).CGPath
		}
		
		if let oval2 : CAShapeLayer = layers["oval2"] as? CAShapeLayer{
			oval2.frame = CGRectMake(0.1506 * oval2.superlayer!.bounds.width, 0.06658 * oval2.superlayer!.bounds.height, 0.6988 * oval2.superlayer!.bounds.width, 0.6988 * oval2.superlayer!.bounds.height)
			oval2.path  = oval2PathWithBounds((layers["oval2"] as! CAShapeLayer).bounds).CGPath
		}
		
		if let path2 : CAShapeLayer = layers["path2"] as? CAShapeLayer{
			path2.frame = CGRectMake(0.37815 * path2.superlayer!.bounds.width, 0.3564 * path2.superlayer!.bounds.height, 0.2437 * path2.superlayer!.bounds.width, 0.11917 * path2.superlayer!.bounds.height)
			path2.path  = path2PathWithBounds((layers["path2"] as! CAShapeLayer).bounds).CGPath
		}
		
		if let path3 : CAShapeLayer = layers["path3"] as? CAShapeLayer{
			path3.transform = CATransform3DIdentity
			path3.frame     = CGRectMake(0.37815 * path3.superlayer!.bounds.width, 0.35839 * path3.superlayer!.bounds.height, 0.2437 * path3.superlayer!.bounds.width, 0.11718 * path3.superlayer!.bounds.height)
			path3.setValue(-180 * CGFloat(M_PI)/180, forKeyPath:"transform.rotation")
			path3.path      = path3PathWithBounds((layers["path3"] as! CAShapeLayer).bounds).CGPath
		}
		
		if let text : CATextLayer = layers["text"] as? CATextLayer{
			text.frame = CGRectMake(0.11917 * text.superlayer!.bounds.width, 0.80573 * text.superlayer!.bounds.height, 0.76167 * text.superlayer!.bounds.width, 0.21915 * text.superlayer!.bounds.height)
		}
		
		CATransaction.commit()
	}
	
	//MARK: - Animation Setup
	
	func addOldAnimation(){
		let fillMode : String = kCAFillModeForwards
		
		let path = layers["path"] as! CAShapeLayer
		
		////Path animation
		let pathTransformAnim       = CABasicAnimation(keyPath:"transform.rotation")
		pathTransformAnim.fromValue = 0;
		pathTransformAnim.toValue   = 360 * CGFloat(M_PI/180);
		pathTransformAnim.duration  = 1.46
		
		let pathStrokeColorAnim      = CAKeyframeAnimation(keyPath:"strokeColor")
		pathStrokeColorAnim.values   = [self.grayColor.CGColor, 
			 self.progressColor.CGColor, 
			 self.progressColor.CGColor]
		pathStrokeColorAnim.keyTimes = [0, 0.0699, 1]
		pathStrokeColorAnim.duration = 1.46
		
		let pathOldAnim : CAAnimationGroup = QCMethod.groupAnimations([pathTransformAnim, pathStrokeColorAnim], fillMode:fillMode)
		path.addAnimation(pathOldAnim, forKey:"pathOldAnim")
		
		////Oval2 animation
		let oval2StrokeStartAnim       = CABasicAnimation(keyPath:"strokeStart")
		oval2StrokeStartAnim.fromValue = 1;
		oval2StrokeStartAnim.toValue   = 0;
		oval2StrokeStartAnim.duration  = 1.46
		
		let oval2StrokeColorAnim       = CABasicAnimation(keyPath:"strokeColor")
		oval2StrokeColorAnim.fromValue = UIColor(red:0.176, green: 0.408, blue:0.996, alpha:1).CGColor;
		oval2StrokeColorAnim.toValue   = self.finishColor.CGColor;
		oval2StrokeColorAnim.duration  = 0.077
		oval2StrokeColorAnim.beginTime = 1.68
		
		let oval2OldAnim : CAAnimationGroup = QCMethod.groupAnimations([oval2StrokeStartAnim, oval2StrokeColorAnim], fillMode:fillMode)
		layers["oval2"]?.addAnimation(oval2OldAnim, forKey:"oval2OldAnim")
		
		let path2 = layers["path2"] as! CAShapeLayer
		
		////Path2 animation
		let path2TransformAnim      = CAKeyframeAnimation(keyPath:"transform.rotation.z")
		path2TransformAnim.values   = [0, 
			 360 * CGFloat(M_PI/180)]
		path2TransformAnim.keyTimes = [0, 1]
		path2TransformAnim.duration = 1.46
		
		let path2StrokeColorAnim      = CAKeyframeAnimation(keyPath:"strokeColor")
		path2StrokeColorAnim.values   = [self.grayColor.CGColor, 
			 self.progressColor.CGColor, 
			 self.progressColor.CGColor]
		path2StrokeColorAnim.keyTimes = [0, 0.0699, 1]
		path2StrokeColorAnim.duration = 1.46
		
		let path2HiddenAnim       = CABasicAnimation(keyPath:"hidden")
		path2HiddenAnim.fromValue = true;
		path2HiddenAnim.toValue   = true;
		path2HiddenAnim.duration  = 0.107
		path2HiddenAnim.beginTime = 1.46
		
		let path2OldAnim : CAAnimationGroup = QCMethod.groupAnimations([path2TransformAnim, path2StrokeColorAnim, path2HiddenAnim], fillMode:fillMode)
		path2.addAnimation(path2OldAnim, forKey:"path2OldAnim")
		
		let path3 = layers["path3"] as! CAShapeLayer
		
		////Path3 animation
		let path3TransformAnim            = CAKeyframeAnimation(keyPath:"transform")
		path3TransformAnim.values         = [NSValue(CATransform3D: CATransform3DMakeRotation(CGFloat(M_PI), 0, 0, -1)), 
			 NSValue(CATransform3D: CATransform3DMakeRotation(1 * CGFloat(M_PI/180), 0, 0, -1)), 
			 NSValue(CATransform3D: CATransform3DMakeScale(1.1, 1.1, 1)), 
			 NSValue(CATransform3D: CATransform3DIdentity)]
		path3TransformAnim.keyTimes       = [0, 0.461, 0.814, 1]
		path3TransformAnim.duration       = 0.413
		path3TransformAnim.beginTime      = 1.45
		path3TransformAnim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseIn)
		
		let path3HiddenAnim       = CABasicAnimation(keyPath:"hidden")
		path3HiddenAnim.fromValue = false;
		path3HiddenAnim.toValue   = false;
		path3HiddenAnim.duration  = 0.377
		path3HiddenAnim.beginTime = 1.45
		
		let path3PathAnim            = CABasicAnimation(keyPath:"path")
		path3PathAnim.fromValue      = QCMethod.alignToBottomPath(path3PathWithBounds((layers["path3"] as! CAShapeLayer).bounds), layer:layers["path3"] as! CALayer).CGPath;
		path3PathAnim.toValue        = QCMethod.alignToBottomPath(pathPathWithBounds((layers["path"] as! CAShapeLayer).bounds), layer:layers["path3"] as! CALayer).CGPath;
		path3PathAnim.duration       = 0.077
		path3PathAnim.beginTime      = 1.68
		path3PathAnim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseIn)
		
		let path3PositionAnim            = CABasicAnimation(keyPath:"position")
		path3PositionAnim.fromValue      = NSValue(CGPoint: CGPointMake(0.5 * path3.superlayer!.bounds.width, 0.41698 * path3.superlayer!.bounds.height));
		path3PositionAnim.toValue        = NSValue(CGPoint: CGPointMake(0.49667 * path3.superlayer!.bounds.width, 0.46 * path3.superlayer!.bounds.height));
		path3PositionAnim.duration       = 0.0585
		path3PositionAnim.beginTime      = 1.68
		path3PositionAnim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseIn)
		
		let path3StrokeColorAnim       = CABasicAnimation(keyPath:"strokeColor")
		path3StrokeColorAnim.fromValue = UIColor(red:0.176, green: 0.408, blue:0.996, alpha:1).CGColor;
		path3StrokeColorAnim.toValue   = self.finishColor.CGColor;
		path3StrokeColorAnim.duration  = 0.077
		path3StrokeColorAnim.beginTime = 1.68
		
		let path3LineWidthAnim       = CABasicAnimation(keyPath:"lineWidth")
		path3LineWidthAnim.fromValue = 15;
		path3LineWidthAnim.toValue   = 20;
		path3LineWidthAnim.duration  = 0.077
		path3LineWidthAnim.beginTime = 1.68
		
		let path3OldAnim : CAAnimationGroup = QCMethod.groupAnimations([path3TransformAnim, path3HiddenAnim, path3PathAnim, path3PositionAnim, path3StrokeColorAnim, path3LineWidthAnim], fillMode:fillMode)
		path3.addAnimation(path3OldAnim, forKey:"path3OldAnim")
		
		let text = layers["text"] as! CATextLayer
		
		////Text animation
		let textTransformAnim            = CABasicAnimation(keyPath:"transform")
		textTransformAnim.fromValue      = NSValue(CATransform3D: CATransform3DMakeScale(0, 0, 1));
		textTransformAnim.toValue        = NSValue(CATransform3D: CATransform3DIdentity);
		textTransformAnim.duration       = 0.142
		textTransformAnim.beginTime      = 1.7
		textTransformAnim.timingFunction = CAMediaTimingFunction(controlPoints: 0.42, 0, 0.737, 1.52)
		
		let textHiddenAnim       = CABasicAnimation(keyPath:"hidden")
		textHiddenAnim.fromValue = false;
		textHiddenAnim.toValue   = false;
		textHiddenAnim.duration  = 0.142
		textHiddenAnim.beginTime = 1.7
		
		let textOldAnim : CAAnimationGroup = QCMethod.groupAnimations([textTransformAnim, textHiddenAnim], fillMode:fillMode)
		text.addAnimation(textOldAnim, forKey:"textOldAnim")
	}
	
	func updateLayerValuesForAnimationId(identifier: String){
		if identifier == "old"{
			QCMethod.updateValueFromPresentationLayerForAnimation((layers["path"] as! CALayer).animationForKey("pathOldAnim"), theLayer:(layers["path"] as! CALayer))
			QCMethod.updateValueFromPresentationLayerForAnimation((layers["oval2"] as! CALayer).animationForKey("oval2OldAnim"), theLayer:(layers["oval2"] as! CALayer))
			QCMethod.updateValueFromPresentationLayerForAnimation((layers["path2"] as! CALayer).animationForKey("path2OldAnim"), theLayer:(layers["path2"] as! CALayer))
			QCMethod.updateValueFromPresentationLayerForAnimation((layers["path3"] as! CALayer).animationForKey("path3OldAnim"), theLayer:(layers["path3"] as! CALayer))
			QCMethod.updateValueFromPresentationLayerForAnimation((layers["text"] as! CALayer).animationForKey("textOldAnim"), theLayer:(layers["text"] as! CALayer))
		}
	}
	
	func removeAnimationsForAnimationId(identifier: String){
		if identifier == "old"{
			(layers["path"] as! CALayer).removeAnimationForKey("pathOldAnim")
			(layers["oval2"] as! CALayer).removeAnimationForKey("oval2OldAnim")
			(layers["path2"] as! CALayer).removeAnimationForKey("path2OldAnim")
			(layers["path3"] as! CALayer).removeAnimationForKey("path3OldAnim")
			(layers["text"] as! CALayer).removeAnimationForKey("textOldAnim")
		}
	}
	
	func removeAllAnimations(){
		for layer in layers.values{
			(layer as! CALayer).removeAllAnimations()
		}
	}
	
	//MARK: - Bezier Path
	
	func pathPathWithBounds(bounds: CGRect) -> UIBezierPath{
		let pathPath = UIBezierPath()
		let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
		
		pathPath.moveToPoint(CGPointMake(minX, minY + 0.51752 * h))
		pathPath.addLineToPoint(CGPointMake(minX + 0.37141 * w, minY + h))
		pathPath.addLineToPoint(CGPointMake(minX + w, minY))
		
		return pathPath
	}
	
	func ovalPathWithBounds(bounds: CGRect) -> UIBezierPath{
		let ovalPath = UIBezierPath(ovalInRect:bounds)
		return ovalPath
	}
	
	func oval2PathWithBounds(bounds: CGRect) -> UIBezierPath{
		let oval2Path = UIBezierPath()
		let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
		
		oval2Path.moveToPoint(CGPointMake(minX + 0.5 * w, minY))
		oval2Path.addCurveToPoint(CGPointMake(minX, minY + 0.5 * h), controlPoint1:CGPointMake(minX + 0.22386 * w, minY), controlPoint2:CGPointMake(minX, minY + 0.22386 * h))
		oval2Path.addCurveToPoint(CGPointMake(minX + 0.5 * w, minY + h), controlPoint1:CGPointMake(minX, minY + 0.77614 * h), controlPoint2:CGPointMake(minX + 0.22386 * w, minY + h))
		oval2Path.addCurveToPoint(CGPointMake(minX + w, minY + 0.5 * h), controlPoint1:CGPointMake(minX + 0.77614 * w, minY + h), controlPoint2:CGPointMake(minX + w, minY + 0.77614 * h))
		oval2Path.addCurveToPoint(CGPointMake(minX + 0.5 * w, minY), controlPoint1:CGPointMake(minX + w, minY + 0.22386 * h), controlPoint2:CGPointMake(minX + 0.77614 * w, minY))
		
		return oval2Path
	}
	
	func path2PathWithBounds(bounds: CGRect) -> UIBezierPath{
		let path2Path = UIBezierPath()
		let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
		
		path2Path.moveToPoint(CGPointMake(minX, minY + h))
		path2Path.addLineToPoint(CGPointMake(minX + 0.48901 * w, minY))
		path2Path.addLineToPoint(CGPointMake(minX + w, minY + h))
		
		return path2Path
	}
	
	func path3PathWithBounds(bounds: CGRect) -> UIBezierPath{
		let path3Path = UIBezierPath()
		let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
		
		path3Path.moveToPoint(CGPointMake(minX, minY))
		path3Path.addLineToPoint(CGPointMake(minX + 0.5 * w, minY + h))
		path3Path.addLineToPoint(CGPointMake(minX + w, minY))
		
		return path3Path
	}
	
	
}
