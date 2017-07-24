//
//  arcload.swift
//
//  Code generated using QuartzCode 1.52.0 on 16/01/17.
//  www.quartzcodeapp.com
//

import UIKit


class arcload: UIView {
    var timer1 = Timer()
    var layers : Dictionary<String, AnyObject> = [:]
    var linewidth = 0 
    var fontsizeforarc = 0 
    var validatefontsize = 0 
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
            if(UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad){
                linewidth = Int(0.067 * self.frame.size.width);
                fontsizeforarc = Int(0.145 * self.frame.size.width);
                validatefontsize =  Int(0.087 * self.frame.size.width);
            }else{
                linewidth = Int(0.027 * self.frame.size.width);
                fontsizeforarc = Int(0.105 * self.frame.size.width);
                validatefontsize =  Int(0.047 * self.frame.size.width);
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
        timer1 = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(self.addUntitled1Animation), userInfo: nil, repeats: true)
    }
    
    func setupLayers(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.adjustwidth), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        let text = CATextLayer()
        self.layer.addSublayer(text)
        text.isHidden         = true
        text.alignmentMode  = kCAAlignmentCenter;
        text.isWrapped        = true
        text.truncationMode = kCATruncationMiddle;
        text.contentsScale  = UIScreen.main.scale
        let textAttributes  = [NSFontAttributeName: UIFont(name:"STHeitiTC-Medium", size:17)!,
                               NSForegroundColorAttributeName: UIColor(red:0.404, green: 0.404, blue:0.404, alpha:1)]
        let textText        = "arc\n"
        let textAttributedText = NSAttributedString(string: textText, attributes: textAttributes)
        text.string = textAttributedText
        layers["text"] = text
        
        let inner = CALayer()
        self.layer.addSublayer(inner)
        
        layers["inner"] = inner
        let layer = CAShapeLayer()
        inner.addSublayer(layer)
        layer.fillColor   = nil
        layer.strokeColor = UIColor(red:0.868, green: 0.878, blue:0.878, alpha:1).cgColor
        layer.lineWidth   = CGFloat(linewidth)
        layer.strokeStart = 0.1
        layer.strokeEnd   = 0.9
        layers["layer"] = layer
        let layer2 = CAShapeLayer()
        inner.addSublayer(layer2)
        layer2.fillColor   = nil
        layer2.strokeColor = UIColor(red:0.868, green: 0.878, blue:0.878, alpha:1).cgColor
        layer2.lineWidth   = CGFloat(linewidth)
        layer2.strokeStart = 0.1
        layer2.strokeEnd   = 0.9
        layers["layer2"] = layer2
        let layer3 = CAShapeLayer()
        inner.addSublayer(layer3)
        layer3.fillColor   = nil
        layer3.strokeColor = UIColor(red:0.868, green: 0.878, blue:0.878, alpha:1).cgColor
        layer3.lineWidth   = CGFloat(linewidth)
        layer3.strokeStart = 0.1
        layer3.strokeEnd   = 0.9
        layers["layer3"] = layer3
        let layer4 = CAShapeLayer()
        inner.addSublayer(layer4)
        layer4.fillColor   = nil
        layer4.strokeColor = UIColor(red:0.868, green: 0.878, blue:0.878, alpha:1).cgColor
        layer4.lineWidth   = CGFloat(linewidth)
        layer4.strokeStart = 0.1
        layer4.strokeEnd   = 0.9
        layers["layer4"] = layer4
        let layer5 = CAShapeLayer()
        inner.addSublayer(layer5)
        layer5.fillColor   = nil
        layer5.strokeColor = UIColor(red:0.868, green: 0.878, blue:0.878, alpha:1).cgColor
        layer5.lineWidth   = CGFloat(linewidth)
        layer5.strokeStart = 0.1
        layer5.strokeEnd   = 0.9
        layers["layer5"] = layer5
        
        let outer = CALayer()
        self.layer.addSublayer(outer)
        
        layers["outer"] = outer
        let outerlayer = CAShapeLayer()
        outer.addSublayer(outerlayer)
        outerlayer.fillColor   = nil
        outerlayer.strokeColor = UIColor(red:0.92,green: 0.609,blue:0.236, alpha:1).cgColor
        outerlayer.lineWidth   = CGFloat(linewidth)
        outerlayer.strokeStart = 0.1
        outerlayer.strokeEnd   = 0.9
        layers["outerlayer"] = outerlayer
        let outerlayer2 = CAShapeLayer()
        outer.addSublayer(outerlayer2)
        outerlayer2.fillColor   = nil
        outerlayer2.strokeColor = UIColor(red:0.572, green: 0.556, blue:0.505, alpha:1).cgColor
        outerlayer2.lineWidth   = CGFloat(linewidth)
        outerlayer2.strokeStart = 0.1
        outerlayer2.strokeEnd   = 0.9
        layers["outerlayer2"] = outerlayer2
        let outerlayer3 = CAShapeLayer()
        outer.addSublayer(outerlayer3)
        outerlayer3.fillColor   = nil
        outerlayer3.strokeColor = UIColor(red:0.691, green: 0.789, blue:0.762, alpha:1).cgColor
        outerlayer3.lineWidth   = CGFloat(linewidth)
        outerlayer3.strokeStart = 0.1
        outerlayer3.strokeEnd   = 0.9
        layers["outerlayer3"] = outerlayer3
        let outerlayer4 = CAShapeLayer()
        outer.addSublayer(outerlayer4)
        outerlayer4.fillColor   = nil
        outerlayer4.strokeColor = UIColor(red:0.303, green: 0.751, blue:0.94, alpha:1).cgColor
        outerlayer4.lineWidth   = CGFloat(linewidth)
        outerlayer4.strokeStart = 0.1
        outerlayer4.strokeEnd   = 0.9
        layers["outerlayer4"] = outerlayer4
        let outerlayer5 = CAShapeLayer()
        outer.addSublayer(outerlayer5)
        outerlayer5.fillColor   = nil
        outerlayer5.strokeColor = UIColor(red:0.776, green: 0.859, blue:0.122, alpha:1).cgColor
        outerlayer5.lineWidth   = CGFloat(linewidth)
        outerlayer5.strokeStart = 0.1
        outerlayer5.strokeEnd   = 0.9
        layers["outerlayer5"] = outerlayer5
        
        let validatingtext = CATextLayer()
        self.layer.addSublayer(validatingtext)
        validatingtext.contentsScale   = UIScreen.main.scale
        validatingtext.string          = "Validating credentials.."
        validatingtext.font            = "Helvetica" as CFTypeRef?
        validatingtext.fontSize        = CGFloat(validatefontsize)
        validatingtext.alignmentMode   = kCAAlignmentCenter;
        validatingtext.foregroundColor = UIColor.black.cgColor;
        layers["validatingtext"] = validatingtext
        
        let arc_back = CALayer()
        self.layer.addSublayer(arc_back)
        arc_back.isHidden   = true
        arc_back.contents = UIImage(named:"arc_back")?.cgImage
        layers["arc_back"] = arc_back
        
        let xcv = CALayer()
        self.layer.addSublayer(xcv)
        xcv.contents = UIImage(named:"xcv")?.cgImage
        layers["xcv"] = xcv
        setupLayerFrames()
    }
    
    func setupLayerFrames(){
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        if let text : CATextLayer = layers["text"] as? CATextLayer{
            text.frame = CGRect(x: 0.19951 * text.superlayer!.bounds.width, y: 0.4 * text.superlayer!.bounds.height, width: 0.40099 * text.superlayer!.bounds.width, height: 0.2 * text.superlayer!.bounds.height)
        }
        
        if let inner : CALayer = layers["inner"] as? CALayer{
            inner.frame = CGRect(x: 0.5 * inner.superlayer!.bounds.width, y: 0.2 * inner.superlayer!.bounds.height, width: 0.3 * inner.superlayer!.bounds.width, height: 0.6 * inner.superlayer!.bounds.height)
        }
        
        if let layer : CAShapeLayer = layers["layer"] as? CAShapeLayer{
            layer.frame = CGRect(x: 0, y: 0.33333 * layer.superlayer!.bounds.height, width: 0.33333 * layer.superlayer!.bounds.width, height: 0.33333 * layer.superlayer!.bounds.height)
            layer.path  = layerPathWithBounds((layers["layer"] as! CAShapeLayer).bounds).cgPath
        }
        
        if let layer2 : CAShapeLayer = layers["layer2"] as? CAShapeLayer{
            layer2.frame = CGRect(x: 0, y: 0.25 * layer2.superlayer!.bounds.height, width: 0.5 * layer2.superlayer!.bounds.width, height: 0.5 * layer2.superlayer!.bounds.height)
            layer2.path  = layer2PathWithBounds((layers["layer2"] as! CAShapeLayer).bounds).cgPath
        }
        
        if let layer3 : CAShapeLayer = layers["layer3"] as? CAShapeLayer{
            layer3.frame = CGRect(x: 0, y: 0.16667 * layer3.superlayer!.bounds.height, width: 0.66667 * layer3.superlayer!.bounds.width, height: 0.66667 * layer3.superlayer!.bounds.height)
            layer3.path  = layer3PathWithBounds((layers["layer3"] as! CAShapeLayer).bounds).cgPath
        }
        
        if let layer4 : CAShapeLayer = layers["layer4"] as? CAShapeLayer{
            layer4.frame = CGRect(x: 0, y: 0.08333 * layer4.superlayer!.bounds.height, width: 0.83333 * layer4.superlayer!.bounds.width, height: 0.83333 * layer4.superlayer!.bounds.height)
            layer4.path  = layer4PathWithBounds((layers["layer4"] as! CAShapeLayer).bounds).cgPath
        }
        
        if let layer5 : CAShapeLayer = layers["layer5"] as? CAShapeLayer{
            layer5.frame = CGRect(x: 0, y: 0,  width: layer5.superlayer!.bounds.width,  height: layer5.superlayer!.bounds.height)
            layer5.path  = layer5PathWithBounds((layers["layer5"] as! CAShapeLayer).bounds).cgPath
        }
        
        if let outer : CALayer = layers["outer"] as? CALayer{
            outer.frame = CGRect(x: 0.5 * outer.superlayer!.bounds.width, y: 0.2 * outer.superlayer!.bounds.height, width: 0.3 * outer.superlayer!.bounds.width, height: 0.6 * outer.superlayer!.bounds.height)
        }
        
        if let outerlayer : CAShapeLayer = layers["outerlayer"] as? CAShapeLayer{
            outerlayer.frame = CGRect(x: 0, y: 0.33333 * outerlayer.superlayer!.bounds.height, width: 0.33333 * outerlayer.superlayer!.bounds.width, height: 0.33333 * outerlayer.superlayer!.bounds.height)
            outerlayer.path  = outerlayerPathWithBounds((layers["outerlayer"] as! CAShapeLayer).bounds).cgPath
        }
        
        if let outerlayer2 : CAShapeLayer = layers["outerlayer2"] as? CAShapeLayer{
            outerlayer2.frame = CGRect(x: 0, y: 0.25 * outerlayer2.superlayer!.bounds.height, width: 0.5 * outerlayer2.superlayer!.bounds.width, height: 0.5 * outerlayer2.superlayer!.bounds.height)
            outerlayer2.path  = outerlayer2PathWithBounds((layers["outerlayer2"] as! CAShapeLayer).bounds).cgPath
        }
        
        if let outerlayer3 : CAShapeLayer = layers["outerlayer3"] as? CAShapeLayer{
            outerlayer3.frame = CGRect(x: 0, y: 0.16667 * outerlayer3.superlayer!.bounds.height, width: 0.66667 * outerlayer3.superlayer!.bounds.width, height: 0.66667 * outerlayer3.superlayer!.bounds.height)
            outerlayer3.path  = outerlayer3PathWithBounds((layers["outerlayer3"] as! CAShapeLayer).bounds).cgPath
        }
        
        if let outerlayer4 : CAShapeLayer = layers["outerlayer4"] as? CAShapeLayer{
            outerlayer4.frame = CGRect(x: 0, y: 0.08333 * outerlayer4.superlayer!.bounds.height, width: 0.83333 * outerlayer4.superlayer!.bounds.width, height: 0.83333 * outerlayer4.superlayer!.bounds.height)
            outerlayer4.path  = outerlayer4PathWithBounds((layers["outerlayer4"] as! CAShapeLayer).bounds).cgPath
        }
        
        if let outerlayer5 : CAShapeLayer = layers["outerlayer5"] as? CAShapeLayer{
            outerlayer5.frame = CGRect(x: 0, y: 0,  width: outerlayer5.superlayer!.bounds.width,  height: outerlayer5.superlayer!.bounds.height)
            outerlayer5.path  = outerlayer5PathWithBounds((layers["outerlayer5"] as! CAShapeLayer).bounds).cgPath
        }
        
        if let validatingtext : CATextLayer = layers["validatingtext"] as? CATextLayer{
            validatingtext.frame = CGRect(x: 0.19232 * validatingtext.superlayer!.bounds.width, y: 0.89 * validatingtext.superlayer!.bounds.height, width: 0.63536 * validatingtext.superlayer!.bounds.width, height: 0.07216 * validatingtext.superlayer!.bounds.height)
        }
        
        if let arc_back : CALayer = layers["arc_back"] as? CALayer{
            arc_back.frame = CGRect(x: 0, y: 0,  width: arc_back.superlayer!.bounds.width, height: 1 * arc_back.superlayer!.bounds.height)
        }
        
        if let xcv : CALayer = layers["xcv"] as? CALayer{
            xcv.frame = CGRect(x: 0.07 * xcv.superlayer!.bounds.width, y: 0.29016 * xcv.superlayer!.bounds.height, width: 0.57 * xcv.superlayer!.bounds.width, height: 0.43969 * xcv.superlayer!.bounds.height)
        }
        
        CATransaction.commit()
     //   self.performSelector(#selector(self.addUntitled1Animation), withObject: nil, withObject: nil)
    }
    
    
    
    //MARK: - Animation Setup
    
    func addUntitled1Animation(){
        i = i+1
        //print(i)
        let fillMode : String = kCAFillModeForwards
        
        ////Outerlayer animation
        let outerlayerStrokeEndAnim            = CAKeyframeAnimation(keyPath:"strokeEnd")
        outerlayerStrokeEndAnim.values         = [0.1, 0.9]
        outerlayerStrokeEndAnim.keyTimes       = [0, 1]
        outerlayerStrokeEndAnim.duration       = 0.798
        outerlayerStrokeEndAnim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)
        
        let outerlayerUntitled1Anim : CAAnimationGroup = QCMethod.groupAnimations([outerlayerStrokeEndAnim], fillMode:fillMode)
        layers["outerlayer"]?.add(outerlayerUntitled1Anim, forKey:"outerlayerUntitled1Anim")
        
        ////Outerlayer2 animation
        let outerlayer2StrokeEndAnim      = CAKeyframeAnimation(keyPath:"strokeEnd")
        outerlayer2StrokeEndAnim.values   = [0.1, 0.1, 0.9]
        outerlayer2StrokeEndAnim.keyTimes = [0, 0.5, 1]
        outerlayer2StrokeEndAnim.duration = 1.6
        outerlayer2StrokeEndAnim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)
        
        let outerlayer2Untitled1Anim : CAAnimationGroup = QCMethod.groupAnimations([outerlayer2StrokeEndAnim], fillMode:fillMode)
        layers["outerlayer2"]?.add(outerlayer2Untitled1Anim, forKey:"outerlayer2Untitled1Anim")
        
        ////Outerlayer3 animation
        let outerlayer3StrokeEndAnim      = CAKeyframeAnimation(keyPath:"strokeEnd")
        outerlayer3StrokeEndAnim.values   = [0.1, 0.1, 0.9]
        outerlayer3StrokeEndAnim.keyTimes = [0, 0.667, 1]
        outerlayer3StrokeEndAnim.duration = 2.4
        outerlayer3StrokeEndAnim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)
        
        let outerlayer3Untitled1Anim : CAAnimationGroup = QCMethod.groupAnimations([outerlayer3StrokeEndAnim], fillMode:fillMode)
        layers["outerlayer3"]?.add(outerlayer3Untitled1Anim, forKey:"outerlayer3Untitled1Anim")
        
        ////Outerlayer4 animation
        let outerlayer4StrokeEndAnim      = CAKeyframeAnimation(keyPath:"strokeEnd")
        outerlayer4StrokeEndAnim.values   = [0.1, 0.1, 0.9]
        outerlayer4StrokeEndAnim.keyTimes = [0, 0.75, 1]
        outerlayer4StrokeEndAnim.duration = 3.19
        outerlayer4StrokeEndAnim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)
        
        let outerlayer4Untitled1Anim : CAAnimationGroup = QCMethod.groupAnimations([outerlayer4StrokeEndAnim], fillMode:fillMode)
        layers["outerlayer4"]?.add(outerlayer4Untitled1Anim, forKey:"outerlayer4Untitled1Anim")
        
        ////Outerlayer5 animation
        let outerlayer5StrokeEndAnim      = CAKeyframeAnimation(keyPath:"strokeEnd")
        outerlayer5StrokeEndAnim.values   = [0.1, 0.1, 0.9]
        outerlayer5StrokeEndAnim.keyTimes = [0, 0.8, 1]
        outerlayer5StrokeEndAnim.duration = 3.99
        outerlayer5StrokeEndAnim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)
        
        let outerlayer5Untitled1Anim : CAAnimationGroup = QCMethod.groupAnimations([outerlayer5StrokeEndAnim], fillMode:fillMode)
        layers["outerlayer5"]?.add(outerlayer5Untitled1Anim, forKey:"outerlayer5Untitled1Anim")
    }
    
    //MARK: - Animation Cleanup
    
    func updateLayerValuesForAnimationId(_ identifier: String){
        if identifier == "Untitled1"{
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["outerlayer"] as! CALayer).animation(forKey: "outerlayerUntitled1Anim"), theLayer:(layers["outerlayer"] as! CALayer))
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["outerlayer2"] as! CALayer).animation(forKey: "outerlayer2Untitled1Anim"), theLayer:(layers["outerlayer2"] as! CALayer))
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["outerlayer3"] as! CALayer).animation(forKey: "outerlayer3Untitled1Anim"), theLayer:(layers["outerlayer3"] as! CALayer))
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["outerlayer4"] as! CALayer).animation(forKey: "outerlayer4Untitled1Anim"), theLayer:(layers["outerlayer4"] as! CALayer))
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["outerlayer5"] as! CALayer).animation(forKey: "outerlayer5Untitled1Anim"), theLayer:(layers["outerlayer5"] as! CALayer))
        }
    }
    
    func removeAnimationsForAnimationId(_ identifier: String){
        if identifier == "Untitled1"{
            (layers["outerlayer"] as! CALayer).removeAnimation(forKey: "outerlayerUntitled1Anim")
            (layers["outerlayer2"] as! CALayer).removeAnimation(forKey: "outerlayer2Untitled1Anim")
            (layers["outerlayer3"] as! CALayer).removeAnimation(forKey: "outerlayer3Untitled1Anim")
            (layers["outerlayer4"] as! CALayer).removeAnimation(forKey: "outerlayer4Untitled1Anim")
            (layers["outerlayer5"] as! CALayer).removeAnimation(forKey: "outerlayer5Untitled1Anim")
        }
    }
    
    func removeAllAnimations(){
        for layer in layers.values{
            (layer as! CALayer).removeAllAnimations()
        }
    }
    
    //MARK: - Bezier Path
    
    func layerPathWithBounds(_ bounds: CGRect) -> UIBezierPath{
        let layerPath = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        layerPath.move(to: CGPoint(x: minX, y: minY))
        layerPath.addCurve(to: CGPoint(x: minX + w, y: minY + 0.5 * h), controlPoint1:CGPoint(x: minX + 0.55228 * w, y: minY), controlPoint2:CGPoint(x: minX + w, y: minY + 0.22386 * h))
        layerPath.addCurve(to: CGPoint(x: minX, y: minY + h), controlPoint1:CGPoint(x: minX + w, y: minY + 0.77614 * h), controlPoint2:CGPoint(x: minX + 0.55228 * w, y: minY + h))
        
        return layerPath
    }
    
    func layer2PathWithBounds(_ bounds: CGRect) -> UIBezierPath{
        let layer2Path = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        layer2Path.move(to: CGPoint(x: minX, y: minY))
        layer2Path.addCurve(to: CGPoint(x: minX + w, y: minY + 0.5 * h), controlPoint1:CGPoint(x: minX + 0.55228 * w, y: minY), controlPoint2:CGPoint(x: minX + w, y: minY + 0.22386 * h))
        layer2Path.addCurve(to: CGPoint(x: minX, y: minY + h), controlPoint1:CGPoint(x: minX + w, y: minY + 0.77614 * h), controlPoint2:CGPoint(x: minX + 0.55228 * w, y: minY + h))
        
        return layer2Path
    }
    
    func layer3PathWithBounds(_ bounds: CGRect) -> UIBezierPath{
        let layer3Path = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        layer3Path.move(to: CGPoint(x: minX, y: minY))
        layer3Path.addCurve(to: CGPoint(x: minX + w, y: minY + 0.5 * h), controlPoint1:CGPoint(x: minX + 0.55228 * w, y: minY), controlPoint2:CGPoint(x: minX + w, y: minY + 0.22386 * h))
        layer3Path.addCurve(to: CGPoint(x: minX, y: minY + h), controlPoint1:CGPoint(x: minX + w, y: minY + 0.77614 * h), controlPoint2:CGPoint(x: minX + 0.55228 * w, y: minY + h))
        
        return layer3Path
    }
    
    func layer4PathWithBounds(_ bounds: CGRect) -> UIBezierPath{
        let layer4Path = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        layer4Path.move(to: CGPoint(x: minX, y: minY))
        layer4Path.addCurve(to: CGPoint(x: minX + w, y: minY + 0.5 * h), controlPoint1:CGPoint(x: minX + 0.55228 * w, y: minY), controlPoint2:CGPoint(x: minX + w, y: minY + 0.22386 * h))
        layer4Path.addCurve(to: CGPoint(x: minX, y: minY + h), controlPoint1:CGPoint(x: minX + w, y: minY + 0.77614 * h), controlPoint2:CGPoint(x: minX + 0.55228 * w, y: minY + h))
        
        return layer4Path
    }
    
    func layer5PathWithBounds(_ bounds: CGRect) -> UIBezierPath{
        let layer5Path = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        layer5Path.move(to: CGPoint(x: minX, y: minY))
        layer5Path.addCurve(to: CGPoint(x: minX + w, y: minY + 0.5 * h), controlPoint1:CGPoint(x: minX + 0.55228 * w, y: minY), controlPoint2:CGPoint(x: minX + w, y: minY + 0.22386 * h))
        layer5Path.addCurve(to: CGPoint(x: minX, y: minY + h), controlPoint1:CGPoint(x: minX + w, y: minY + 0.77614 * h), controlPoint2:CGPoint(x: minX + 0.55228 * w, y: minY + h))
        
        return layer5Path
    }
    
    func outerlayerPathWithBounds(_ bounds: CGRect) -> UIBezierPath{
        let outerlayerPath = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        outerlayerPath.move(to: CGPoint(x: minX, y: minY))
        outerlayerPath.addCurve(to: CGPoint(x: minX + w, y: minY + 0.5 * h), controlPoint1:CGPoint(x: minX + 0.55228 * w, y: minY), controlPoint2:CGPoint(x: minX + w, y: minY + 0.22386 * h))
        outerlayerPath.addCurve(to: CGPoint(x: minX, y: minY + h), controlPoint1:CGPoint(x: minX + w, y: minY + 0.77614 * h), controlPoint2:CGPoint(x: minX + 0.55228 * w, y: minY + h))
        
        return outerlayerPath
    }
    
    func outerlayer2PathWithBounds(_ bounds: CGRect) -> UIBezierPath{
        let outerlayer2Path = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        outerlayer2Path.move(to: CGPoint(x: minX, y: minY))
        outerlayer2Path.addCurve(to: CGPoint(x: minX + w, y: minY + 0.5 * h), controlPoint1:CGPoint(x: minX + 0.55228 * w, y: minY), controlPoint2:CGPoint(x: minX + w, y: minY + 0.22386 * h))
        outerlayer2Path.addCurve(to: CGPoint(x: minX, y: minY + h), controlPoint1:CGPoint(x: minX + w, y: minY + 0.77614 * h), controlPoint2:CGPoint(x: minX + 0.55228 * w, y: minY + h))
        
        return outerlayer2Path
    }
    
    func outerlayer3PathWithBounds(_ bounds: CGRect) -> UIBezierPath{
        let outerlayer3Path = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        outerlayer3Path.move(to: CGPoint(x: minX, y: minY))
        outerlayer3Path.addCurve(to: CGPoint(x: minX + w, y: minY + 0.5 * h), controlPoint1:CGPoint(x: minX + 0.55228 * w, y: minY), controlPoint2:CGPoint(x: minX + w, y: minY + 0.22386 * h))
        outerlayer3Path.addCurve(to: CGPoint(x: minX, y: minY + h), controlPoint1:CGPoint(x: minX + w, y: minY + 0.77614 * h), controlPoint2:CGPoint(x: minX + 0.55228 * w, y: minY + h))
        
        return outerlayer3Path
    }
    
    func outerlayer4PathWithBounds(_ bounds: CGRect) -> UIBezierPath{
        let outerlayer4Path = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        outerlayer4Path.move(to: CGPoint(x: minX, y: minY))
        outerlayer4Path.addCurve(to: CGPoint(x: minX + w, y: minY + 0.5 * h), controlPoint1:CGPoint(x: minX + 0.55228 * w, y: minY), controlPoint2:CGPoint(x: minX + w, y: minY + 0.22386 * h))
        outerlayer4Path.addCurve(to: CGPoint(x: minX, y: minY + h), controlPoint1:CGPoint(x: minX + w, y: minY + 0.77614 * h), controlPoint2:CGPoint(x: minX + 0.55228 * w, y: minY + h))
        
        return outerlayer4Path
    }
    
    func outerlayer5PathWithBounds(_ bounds: CGRect) -> UIBezierPath{
        let outerlayer5Path = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        outerlayer5Path.move(to: CGPoint(x: minX, y: minY))
        outerlayer5Path.addCurve(to: CGPoint(x: minX + w, y: minY + 0.5 * h), controlPoint1:CGPoint(x: minX + 0.55228 * w, y: minY), controlPoint2:CGPoint(x: minX + w, y: minY + 0.22386 * h))
        outerlayer5Path.addCurve(to: CGPoint(x: minX, y: minY + h), controlPoint1:CGPoint(x: minX + w, y: minY + 0.77614 * h), controlPoint2:CGPoint(x: minX + 0.55228 * w, y: minY + h))
        
        return outerlayer5Path
    }
    
    
}
