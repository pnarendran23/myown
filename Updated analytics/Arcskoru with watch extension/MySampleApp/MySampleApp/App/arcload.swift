//
//  arcload.swift
//
//  Code generated using QuartzCode 1.52.0 on 16/01/17.
//  www.quartzcodeapp.com
//

import UIKit


class arcload: UIView {
    var timer1 = NSTimer()
    var layers : Dictionary<String, AnyObject> = [:]
    var linewidth = 0 as! CGFloat
    var fontsizeforarc = 0 as!  CGFloat
    var validatefontsize = 0 as! CGFloat
    var i = 0
    
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
            if(UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad){
                linewidth = 0.067 * self.frame.size.width;
                fontsizeforarc = 0.145 * self.frame.size.width;
                validatefontsize =  0.087 * self.frame.size.width;
            }else{
                linewidth = 0.027 * self.frame.size.width;
                fontsizeforarc = 0.105 * self.frame.size.width;
                validatefontsize =  0.047 * self.frame.size.width;
            }
            
            

            setupLayerFrames()
        }
    }
    
    override var bounds: CGRect{
        didSet{
            setupLayerFrames()
        }
    }
    
    func setupProperties(){
        
    }
    
    func adjustwidth(){
        removeAllAnimations()        
        setupLayerFrames()
        timer1 = NSTimer.scheduledTimerWithTimeInterval(4.0, target: self, selector: #selector(self.addUntitled1Animation), userInfo: nil, repeats: true)
    }
    
    func setupLayers(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.adjustwidth), name: UIDeviceOrientationDidChangeNotification, object: nil)
        let text = CATextLayer()
        self.layer.addSublayer(text)
        text.hidden         = true
        text.alignmentMode  = kCAAlignmentCenter;
        text.wrapped        = true
        text.truncationMode = kCATruncationMiddle;
        text.contentsScale  = UIScreen.mainScreen().scale
        var textAttributes  = [NSFontAttributeName: UIFont(name:"STHeitiTC-Medium", size:17)!,
                               NSForegroundColorAttributeName: UIColor(red:0.404, green: 0.404, blue:0.404, alpha:1)]
        var textText        = "arc\n"
        var textAttributedText = NSAttributedString(string: textText, attributes: textAttributes)
        text.string = textAttributedText
        layers["text"] = text
        
        let inner = CALayer()
        self.layer.addSublayer(inner)
        
        layers["inner"] = inner
        let layer = CAShapeLayer()
        inner.addSublayer(layer)
        layer.fillColor   = nil
        layer.strokeColor = UIColor(red:0.868, green: 0.878, blue:0.878, alpha:1).CGColor
        layer.lineWidth   = linewidth
        layer.strokeStart = 0.1
        layer.strokeEnd   = 0.9
        layers["layer"] = layer
        let layer2 = CAShapeLayer()
        inner.addSublayer(layer2)
        layer2.fillColor   = nil
        layer2.strokeColor = UIColor(red:0.868, green: 0.878, blue:0.878, alpha:1).CGColor
        layer2.lineWidth   = linewidth
        layer2.strokeStart = 0.1
        layer2.strokeEnd   = 0.9
        layers["layer2"] = layer2
        let layer3 = CAShapeLayer()
        inner.addSublayer(layer3)
        layer3.fillColor   = nil
        layer3.strokeColor = UIColor(red:0.868, green: 0.878, blue:0.878, alpha:1).CGColor
        layer3.lineWidth   = linewidth
        layer3.strokeStart = 0.1
        layer3.strokeEnd   = 0.9
        layers["layer3"] = layer3
        let layer4 = CAShapeLayer()
        inner.addSublayer(layer4)
        layer4.fillColor   = nil
        layer4.strokeColor = UIColor(red:0.868, green: 0.878, blue:0.878, alpha:1).CGColor
        layer4.lineWidth   = linewidth
        layer4.strokeStart = 0.1
        layer4.strokeEnd   = 0.9
        layers["layer4"] = layer4
        let layer5 = CAShapeLayer()
        inner.addSublayer(layer5)
        layer5.fillColor   = nil
        layer5.strokeColor = UIColor(red:0.868, green: 0.878, blue:0.878, alpha:1).CGColor
        layer5.lineWidth   = linewidth
        layer5.strokeStart = 0.1
        layer5.strokeEnd   = 0.9
        layers["layer5"] = layer5
        
        let outer = CALayer()
        self.layer.addSublayer(outer)
        
        layers["outer"] = outer
        let outerlayer = CAShapeLayer()
        outer.addSublayer(outerlayer)
        outerlayer.fillColor   = nil
        outerlayer.strokeColor = UIColor(red:0.92,green: 0.609,blue:0.236, alpha:1).CGColor
        outerlayer.lineWidth   = linewidth
        outerlayer.strokeStart = 0.1
        outerlayer.strokeEnd   = 0.9
        layers["outerlayer"] = outerlayer
        let outerlayer2 = CAShapeLayer()
        outer.addSublayer(outerlayer2)
        outerlayer2.fillColor   = nil
        outerlayer2.strokeColor = UIColor(red:0.572, green: 0.556, blue:0.505, alpha:1).CGColor
        outerlayer2.lineWidth   = linewidth
        outerlayer2.strokeStart = 0.1
        outerlayer2.strokeEnd   = 0.9
        layers["outerlayer2"] = outerlayer2
        let outerlayer3 = CAShapeLayer()
        outer.addSublayer(outerlayer3)
        outerlayer3.fillColor   = nil
        outerlayer3.strokeColor = UIColor(red:0.691, green: 0.789, blue:0.762, alpha:1).CGColor
        outerlayer3.lineWidth   = linewidth
        outerlayer3.strokeStart = 0.1
        outerlayer3.strokeEnd   = 0.9
        layers["outerlayer3"] = outerlayer3
        let outerlayer4 = CAShapeLayer()
        outer.addSublayer(outerlayer4)
        outerlayer4.fillColor   = nil
        outerlayer4.strokeColor = UIColor(red:0.303, green: 0.751, blue:0.94, alpha:1).CGColor
        outerlayer4.lineWidth   = linewidth
        outerlayer4.strokeStart = 0.1
        outerlayer4.strokeEnd   = 0.9
        layers["outerlayer4"] = outerlayer4
        let outerlayer5 = CAShapeLayer()
        outer.addSublayer(outerlayer5)
        outerlayer5.fillColor   = nil
        outerlayer5.strokeColor = UIColor(red:0.776, green: 0.859, blue:0.122, alpha:1).CGColor
        outerlayer5.lineWidth   = linewidth
        outerlayer5.strokeStart = 0.1
        outerlayer5.strokeEnd   = 0.9
        layers["outerlayer5"] = outerlayer5
        
        let validatingtext = CATextLayer()
        self.layer.addSublayer(validatingtext)
        validatingtext.contentsScale   = UIScreen.mainScreen().scale
        validatingtext.string          = "Validating credentials.."
        validatingtext.font            = "Helvetica"
        validatingtext.fontSize        = validatefontsize
        validatingtext.alignmentMode   = kCAAlignmentCenter;
        validatingtext.foregroundColor = UIColor.blackColor().CGColor;
        layers["validatingtext"] = validatingtext
        
        let arc_back = CALayer()
        self.layer.addSublayer(arc_back)
        arc_back.hidden   = true
        arc_back.contents = UIImage(named:"arc_back")?.CGImage
        layers["arc_back"] = arc_back
        
        let xcv = CALayer()
        self.layer.addSublayer(xcv)
        xcv.contents = UIImage(named:"xcv")?.CGImage
        layers["xcv"] = xcv
        setupLayerFrames()
    }
    
    func setupLayerFrames(){
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        if let text : CATextLayer = layers["text"] as? CATextLayer{
            text.frame = CGRectMake(0.19951 * text.superlayer!.bounds.width, 0.4 * text.superlayer!.bounds.height, 0.40099 * text.superlayer!.bounds.width, 0.2 * text.superlayer!.bounds.height)
        }
        
        if let inner : CALayer = layers["inner"] as? CALayer{
            inner.frame = CGRectMake(0.5 * inner.superlayer!.bounds.width, 0.2 * inner.superlayer!.bounds.height, 0.3 * inner.superlayer!.bounds.width, 0.6 * inner.superlayer!.bounds.height)
        }
        
        if let layer : CAShapeLayer = layers["layer"] as? CAShapeLayer{
            layer.frame = CGRectMake(0, 0.33333 * layer.superlayer!.bounds.height, 0.33333 * layer.superlayer!.bounds.width, 0.33333 * layer.superlayer!.bounds.height)
            layer.path  = layerPathWithBounds((layers["layer"] as! CAShapeLayer).bounds).CGPath
        }
        
        if let layer2 : CAShapeLayer = layers["layer2"] as? CAShapeLayer{
            layer2.frame = CGRectMake(0, 0.25 * layer2.superlayer!.bounds.height, 0.5 * layer2.superlayer!.bounds.width, 0.5 * layer2.superlayer!.bounds.height)
            layer2.path  = layer2PathWithBounds((layers["layer2"] as! CAShapeLayer).bounds).CGPath
        }
        
        if let layer3 : CAShapeLayer = layers["layer3"] as? CAShapeLayer{
            layer3.frame = CGRectMake(0, 0.16667 * layer3.superlayer!.bounds.height, 0.66667 * layer3.superlayer!.bounds.width, 0.66667 * layer3.superlayer!.bounds.height)
            layer3.path  = layer3PathWithBounds((layers["layer3"] as! CAShapeLayer).bounds).CGPath
        }
        
        if let layer4 : CAShapeLayer = layers["layer4"] as? CAShapeLayer{
            layer4.frame = CGRectMake(0, 0.08333 * layer4.superlayer!.bounds.height, 0.83333 * layer4.superlayer!.bounds.width, 0.83333 * layer4.superlayer!.bounds.height)
            layer4.path  = layer4PathWithBounds((layers["layer4"] as! CAShapeLayer).bounds).CGPath
        }
        
        if let layer5 : CAShapeLayer = layers["layer5"] as? CAShapeLayer{
            layer5.frame = CGRectMake(0, 0,  layer5.superlayer!.bounds.width,  layer5.superlayer!.bounds.height)
            layer5.path  = layer5PathWithBounds((layers["layer5"] as! CAShapeLayer).bounds).CGPath
        }
        
        if let outer : CALayer = layers["outer"] as? CALayer{
            outer.frame = CGRectMake(0.5 * outer.superlayer!.bounds.width, 0.2 * outer.superlayer!.bounds.height, 0.3 * outer.superlayer!.bounds.width, 0.6 * outer.superlayer!.bounds.height)
        }
        
        if let outerlayer : CAShapeLayer = layers["outerlayer"] as? CAShapeLayer{
            outerlayer.frame = CGRectMake(0, 0.33333 * outerlayer.superlayer!.bounds.height, 0.33333 * outerlayer.superlayer!.bounds.width, 0.33333 * outerlayer.superlayer!.bounds.height)
            outerlayer.path  = outerlayerPathWithBounds((layers["outerlayer"] as! CAShapeLayer).bounds).CGPath
        }
        
        if let outerlayer2 : CAShapeLayer = layers["outerlayer2"] as? CAShapeLayer{
            outerlayer2.frame = CGRectMake(0, 0.25 * outerlayer2.superlayer!.bounds.height, 0.5 * outerlayer2.superlayer!.bounds.width, 0.5 * outerlayer2.superlayer!.bounds.height)
            outerlayer2.path  = outerlayer2PathWithBounds((layers["outerlayer2"] as! CAShapeLayer).bounds).CGPath
        }
        
        if let outerlayer3 : CAShapeLayer = layers["outerlayer3"] as? CAShapeLayer{
            outerlayer3.frame = CGRectMake(0, 0.16667 * outerlayer3.superlayer!.bounds.height, 0.66667 * outerlayer3.superlayer!.bounds.width, 0.66667 * outerlayer3.superlayer!.bounds.height)
            outerlayer3.path  = outerlayer3PathWithBounds((layers["outerlayer3"] as! CAShapeLayer).bounds).CGPath
        }
        
        if let outerlayer4 : CAShapeLayer = layers["outerlayer4"] as? CAShapeLayer{
            outerlayer4.frame = CGRectMake(0, 0.08333 * outerlayer4.superlayer!.bounds.height, 0.83333 * outerlayer4.superlayer!.bounds.width, 0.83333 * outerlayer4.superlayer!.bounds.height)
            outerlayer4.path  = outerlayer4PathWithBounds((layers["outerlayer4"] as! CAShapeLayer).bounds).CGPath
        }
        
        if let outerlayer5 : CAShapeLayer = layers["outerlayer5"] as? CAShapeLayer{
            outerlayer5.frame = CGRectMake(0, 0,  outerlayer5.superlayer!.bounds.width,  outerlayer5.superlayer!.bounds.height)
            outerlayer5.path  = outerlayer5PathWithBounds((layers["outerlayer5"] as! CAShapeLayer).bounds).CGPath
        }
        
        if let validatingtext : CATextLayer = layers["validatingtext"] as? CATextLayer{
            validatingtext.frame = CGRectMake(0.19232 * validatingtext.superlayer!.bounds.width, 0.89 * validatingtext.superlayer!.bounds.height, 0.63536 * validatingtext.superlayer!.bounds.width, 0.07216 * validatingtext.superlayer!.bounds.height)
        }
        
        if let arc_back : CALayer = layers["arc_back"] as? CALayer{
            arc_back.frame = CGRectMake(0, 0,  arc_back.superlayer!.bounds.width, 1 * arc_back.superlayer!.bounds.height)
        }
        
        if let xcv : CALayer = layers["xcv"] as? CALayer{
            xcv.frame = CGRectMake(0.07 * xcv.superlayer!.bounds.width, 0.29016 * xcv.superlayer!.bounds.height, 0.57 * xcv.superlayer!.bounds.width, 0.43969 * xcv.superlayer!.bounds.height)
        }
        
        CATransaction.commit()
     //   self.performSelector(#selector(self.addUntitled1Animation), withObject: nil, withObject: nil)
    }
    
    
    
    //MARK: - Animation Setup
    
    func addUntitled1Animation(){
        i = i+1
        print(i)
        let fillMode : String = kCAFillModeForwards
        
        ////Outerlayer animation
        let outerlayerStrokeEndAnim            = CAKeyframeAnimation(keyPath:"strokeEnd")
        outerlayerStrokeEndAnim.values         = [0.1, 0.9]
        outerlayerStrokeEndAnim.keyTimes       = [0, 1]
        outerlayerStrokeEndAnim.duration       = 0.798
        outerlayerStrokeEndAnim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)
        
        let outerlayerUntitled1Anim : CAAnimationGroup = QCMethod.groupAnimations([outerlayerStrokeEndAnim], fillMode:fillMode)
        layers["outerlayer"]?.addAnimation(outerlayerUntitled1Anim, forKey:"outerlayerUntitled1Anim")
        
        ////Outerlayer2 animation
        let outerlayer2StrokeEndAnim      = CAKeyframeAnimation(keyPath:"strokeEnd")
        outerlayer2StrokeEndAnim.values   = [0.1, 0.1, 0.9]
        outerlayer2StrokeEndAnim.keyTimes = [0, 0.5, 1]
        outerlayer2StrokeEndAnim.duration = 1.6
        outerlayer2StrokeEndAnim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)
        
        let outerlayer2Untitled1Anim : CAAnimationGroup = QCMethod.groupAnimations([outerlayer2StrokeEndAnim], fillMode:fillMode)
        layers["outerlayer2"]?.addAnimation(outerlayer2Untitled1Anim, forKey:"outerlayer2Untitled1Anim")
        
        ////Outerlayer3 animation
        let outerlayer3StrokeEndAnim      = CAKeyframeAnimation(keyPath:"strokeEnd")
        outerlayer3StrokeEndAnim.values   = [0.1, 0.1, 0.9]
        outerlayer3StrokeEndAnim.keyTimes = [0, 0.667, 1]
        outerlayer3StrokeEndAnim.duration = 2.4
        outerlayer3StrokeEndAnim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)
        
        let outerlayer3Untitled1Anim : CAAnimationGroup = QCMethod.groupAnimations([outerlayer3StrokeEndAnim], fillMode:fillMode)
        layers["outerlayer3"]?.addAnimation(outerlayer3Untitled1Anim, forKey:"outerlayer3Untitled1Anim")
        
        ////Outerlayer4 animation
        let outerlayer4StrokeEndAnim      = CAKeyframeAnimation(keyPath:"strokeEnd")
        outerlayer4StrokeEndAnim.values   = [0.1, 0.1, 0.9]
        outerlayer4StrokeEndAnim.keyTimes = [0, 0.75, 1]
        outerlayer4StrokeEndAnim.duration = 3.19
        outerlayer4StrokeEndAnim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)
        
        let outerlayer4Untitled1Anim : CAAnimationGroup = QCMethod.groupAnimations([outerlayer4StrokeEndAnim], fillMode:fillMode)
        layers["outerlayer4"]?.addAnimation(outerlayer4Untitled1Anim, forKey:"outerlayer4Untitled1Anim")
        
        ////Outerlayer5 animation
        let outerlayer5StrokeEndAnim      = CAKeyframeAnimation(keyPath:"strokeEnd")
        outerlayer5StrokeEndAnim.values   = [0.1, 0.1, 0.9]
        outerlayer5StrokeEndAnim.keyTimes = [0, 0.8, 1]
        outerlayer5StrokeEndAnim.duration = 3.99
        outerlayer5StrokeEndAnim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)
        
        let outerlayer5Untitled1Anim : CAAnimationGroup = QCMethod.groupAnimations([outerlayer5StrokeEndAnim], fillMode:fillMode)
        layers["outerlayer5"]?.addAnimation(outerlayer5Untitled1Anim, forKey:"outerlayer5Untitled1Anim")
    }
    
    //MARK: - Animation Cleanup
    
    func updateLayerValuesForAnimationId(identifier: String){
        if identifier == "Untitled1"{
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["outerlayer"] as! CALayer).animationForKey("outerlayerUntitled1Anim"), theLayer:(layers["outerlayer"] as! CALayer))
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["outerlayer2"] as! CALayer).animationForKey("outerlayer2Untitled1Anim"), theLayer:(layers["outerlayer2"] as! CALayer))
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["outerlayer3"] as! CALayer).animationForKey("outerlayer3Untitled1Anim"), theLayer:(layers["outerlayer3"] as! CALayer))
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["outerlayer4"] as! CALayer).animationForKey("outerlayer4Untitled1Anim"), theLayer:(layers["outerlayer4"] as! CALayer))
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["outerlayer5"] as! CALayer).animationForKey("outerlayer5Untitled1Anim"), theLayer:(layers["outerlayer5"] as! CALayer))
        }
    }
    
    func removeAnimationsForAnimationId(identifier: String){
        if identifier == "Untitled1"{
            (layers["outerlayer"] as! CALayer).removeAnimationForKey("outerlayerUntitled1Anim")
            (layers["outerlayer2"] as! CALayer).removeAnimationForKey("outerlayer2Untitled1Anim")
            (layers["outerlayer3"] as! CALayer).removeAnimationForKey("outerlayer3Untitled1Anim")
            (layers["outerlayer4"] as! CALayer).removeAnimationForKey("outerlayer4Untitled1Anim")
            (layers["outerlayer5"] as! CALayer).removeAnimationForKey("outerlayer5Untitled1Anim")
        }
    }
    
    func removeAllAnimations(){
        for layer in layers.values{
            (layer as! CALayer).removeAllAnimations()
        }
    }
    
    //MARK: - Bezier Path
    
    func layerPathWithBounds(bounds: CGRect) -> UIBezierPath{
        let layerPath = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        layerPath.moveToPoint(CGPointMake(minX, minY))
        layerPath.addCurveToPoint(CGPointMake(minX + w, minY + 0.5 * h), controlPoint1:CGPointMake(minX + 0.55228 * w, minY), controlPoint2:CGPointMake(minX + w, minY + 0.22386 * h))
        layerPath.addCurveToPoint(CGPointMake(minX, minY + h), controlPoint1:CGPointMake(minX + w, minY + 0.77614 * h), controlPoint2:CGPointMake(minX + 0.55228 * w, minY + h))
        
        return layerPath
    }
    
    func layer2PathWithBounds(bounds: CGRect) -> UIBezierPath{
        let layer2Path = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        layer2Path.moveToPoint(CGPointMake(minX, minY))
        layer2Path.addCurveToPoint(CGPointMake(minX + w, minY + 0.5 * h), controlPoint1:CGPointMake(minX + 0.55228 * w, minY), controlPoint2:CGPointMake(minX + w, minY + 0.22386 * h))
        layer2Path.addCurveToPoint(CGPointMake(minX, minY + h), controlPoint1:CGPointMake(minX + w, minY + 0.77614 * h), controlPoint2:CGPointMake(minX + 0.55228 * w, minY + h))
        
        return layer2Path
    }
    
    func layer3PathWithBounds(bounds: CGRect) -> UIBezierPath{
        let layer3Path = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        layer3Path.moveToPoint(CGPointMake(minX, minY))
        layer3Path.addCurveToPoint(CGPointMake(minX + w, minY + 0.5 * h), controlPoint1:CGPointMake(minX + 0.55228 * w, minY), controlPoint2:CGPointMake(minX + w, minY + 0.22386 * h))
        layer3Path.addCurveToPoint(CGPointMake(minX, minY + h), controlPoint1:CGPointMake(minX + w, minY + 0.77614 * h), controlPoint2:CGPointMake(minX + 0.55228 * w, minY + h))
        
        return layer3Path
    }
    
    func layer4PathWithBounds(bounds: CGRect) -> UIBezierPath{
        let layer4Path = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        layer4Path.moveToPoint(CGPointMake(minX, minY))
        layer4Path.addCurveToPoint(CGPointMake(minX + w, minY + 0.5 * h), controlPoint1:CGPointMake(minX + 0.55228 * w, minY), controlPoint2:CGPointMake(minX + w, minY + 0.22386 * h))
        layer4Path.addCurveToPoint(CGPointMake(minX, minY + h), controlPoint1:CGPointMake(minX + w, minY + 0.77614 * h), controlPoint2:CGPointMake(minX + 0.55228 * w, minY + h))
        
        return layer4Path
    }
    
    func layer5PathWithBounds(bounds: CGRect) -> UIBezierPath{
        let layer5Path = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        layer5Path.moveToPoint(CGPointMake(minX, minY))
        layer5Path.addCurveToPoint(CGPointMake(minX + w, minY + 0.5 * h), controlPoint1:CGPointMake(minX + 0.55228 * w, minY), controlPoint2:CGPointMake(minX + w, minY + 0.22386 * h))
        layer5Path.addCurveToPoint(CGPointMake(minX, minY + h), controlPoint1:CGPointMake(minX + w, minY + 0.77614 * h), controlPoint2:CGPointMake(minX + 0.55228 * w, minY + h))
        
        return layer5Path
    }
    
    func outerlayerPathWithBounds(bounds: CGRect) -> UIBezierPath{
        let outerlayerPath = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        outerlayerPath.moveToPoint(CGPointMake(minX, minY))
        outerlayerPath.addCurveToPoint(CGPointMake(minX + w, minY + 0.5 * h), controlPoint1:CGPointMake(minX + 0.55228 * w, minY), controlPoint2:CGPointMake(minX + w, minY + 0.22386 * h))
        outerlayerPath.addCurveToPoint(CGPointMake(minX, minY + h), controlPoint1:CGPointMake(minX + w, minY + 0.77614 * h), controlPoint2:CGPointMake(minX + 0.55228 * w, minY + h))
        
        return outerlayerPath
    }
    
    func outerlayer2PathWithBounds(bounds: CGRect) -> UIBezierPath{
        let outerlayer2Path = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        outerlayer2Path.moveToPoint(CGPointMake(minX, minY))
        outerlayer2Path.addCurveToPoint(CGPointMake(minX + w, minY + 0.5 * h), controlPoint1:CGPointMake(minX + 0.55228 * w, minY), controlPoint2:CGPointMake(minX + w, minY + 0.22386 * h))
        outerlayer2Path.addCurveToPoint(CGPointMake(minX, minY + h), controlPoint1:CGPointMake(minX + w, minY + 0.77614 * h), controlPoint2:CGPointMake(minX + 0.55228 * w, minY + h))
        
        return outerlayer2Path
    }
    
    func outerlayer3PathWithBounds(bounds: CGRect) -> UIBezierPath{
        let outerlayer3Path = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        outerlayer3Path.moveToPoint(CGPointMake(minX, minY))
        outerlayer3Path.addCurveToPoint(CGPointMake(minX + w, minY + 0.5 * h), controlPoint1:CGPointMake(minX + 0.55228 * w, minY), controlPoint2:CGPointMake(minX + w, minY + 0.22386 * h))
        outerlayer3Path.addCurveToPoint(CGPointMake(minX, minY + h), controlPoint1:CGPointMake(minX + w, minY + 0.77614 * h), controlPoint2:CGPointMake(minX + 0.55228 * w, minY + h))
        
        return outerlayer3Path
    }
    
    func outerlayer4PathWithBounds(bounds: CGRect) -> UIBezierPath{
        let outerlayer4Path = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        outerlayer4Path.moveToPoint(CGPointMake(minX, minY))
        outerlayer4Path.addCurveToPoint(CGPointMake(minX + w, minY + 0.5 * h), controlPoint1:CGPointMake(minX + 0.55228 * w, minY), controlPoint2:CGPointMake(minX + w, minY + 0.22386 * h))
        outerlayer4Path.addCurveToPoint(CGPointMake(minX, minY + h), controlPoint1:CGPointMake(minX + w, minY + 0.77614 * h), controlPoint2:CGPointMake(minX + 0.55228 * w, minY + h))
        
        return outerlayer4Path
    }
    
    func outerlayer5PathWithBounds(bounds: CGRect) -> UIBezierPath{
        let outerlayer5Path = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        outerlayer5Path.moveToPoint(CGPointMake(minX, minY))
        outerlayer5Path.addCurveToPoint(CGPointMake(minX + w, minY + 0.5 * h), controlPoint1:CGPointMake(minX + 0.55228 * w, minY), controlPoint2:CGPointMake(minX + w, minY + 0.22386 * h))
        outerlayer5Path.addCurveToPoint(CGPointMake(minX, minY + h), controlPoint1:CGPointMake(minX + w, minY + 0.77614 * h), controlPoint2:CGPointMake(minX + 0.55228 * w, minY + h))
        
        return outerlayer5Path
    }
    
    
}
