//
//  graphlist.swift
//
//  Code generated using QuartzCode 1.52.0 on 11/01/17.
//  www.quartzcodeapp.com
//

import UIKit


class listgraph: UIView {
    var waterscore = 0.0, wastescore = 0.0, transportscore = 0.0, humanscore = 0.0, energyscore = 0.0
    var maxwaterscore = 0.0, maxwastescore = 0.0, maxtransportscore = 0.0, maxhumanscore = 0.0, maxenergyscore = 0.0
    var datetext = ""
    var maxscore = 0
    var layers : Dictionary<String, AnyObject> = [:]
    
    
    
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
        
    }
    
    func setupLayers(){
        
        let Group = CALayer()
        self.layer.addSublayer(Group)
        
        layers["Group"] = Group
        let text2 = CATextLayer()
        Group.addSublayer(text2)
        text2.contentsScale   = UIScreen.mainScreen().scale
        text2.string          = "0"
        text2.font            = "OpenSans"
        text2.fontSize        = 0.03*self.frame.size.width
        text2.alignmentMode   = kCAAlignmentCenter;
        text2.foregroundColor = UIColor.whiteColor().CGColor;
        layers["text2"] = text2
        let text3 = CATextLayer()
        Group.addSublayer(text3)
        text3.contentsScale   = UIScreen.mainScreen().scale
        text3.string          = "199\n"
        text3.font            = "OpenSans"
        text3.fontSize        = 0.03*self.frame.size.width
        text3.alignmentMode   = kCAAlignmentCenter;
        text3.foregroundColor = UIColor.whiteColor().CGColor;
        layers["text3"] = text3
        let text = CATextLayer()
        Group.addSublayer(text)
        text.contentsScale   = UIScreen.mainScreen().scale
        text.string          = datetext
        text.font            = "OpenSans"
        text.fontSize        = 0.05*self.frame.size.width
        text.alignmentMode   = kCAAlignmentCenter;
        text.foregroundColor = UIColor.whiteColor().CGColor;
        layers["text"] = text
        let rectangle = CAShapeLayer()
        Group.addSublayer(rectangle)
        rectangle.lineCap         = kCALineCapRound
        rectangle.lineJoin        = kCALineJoinBevel
        rectangle.fillColor       = UIColor(red:0.677, green: 0.685, blue:0.685, alpha:1).CGColor
        rectangle.strokeColor     = UIColor(red:0.329, green: 0.329, blue:0.329, alpha:1).CGColor
        rectangle.lineWidth       = 0
        rectangle.lineDashPattern = [0, 1]
        layers["rectangle"] = rectangle
        let path = CAShapeLayer()
        Group.addSublayer(path)
        path.setValue(-180 * CGFloat(M_PI)/180, forKeyPath:"transform.rotation")
        path.lineCap     = kCALineCapRound
        path.fillColor   = nil
        path.strokeColor = UIColor(red:0.816, green: 0.865, blue:0.24, alpha:1).CGColor
        path.lineWidth   = 0.04*self.frame.size.width
        layers["path"] = path
        let path2 = CAShapeLayer()
        Group.addSublayer(path2)
        path2.setValue(-180 * CGFloat(M_PI)/180, forKeyPath:"transform.rotation")
        path2.lineCap     = kCALineCapRound
        path2.fillColor   = nil
        path2.strokeColor = UIColor(red:0.333, green: 0.794, blue:0.961, alpha:1).CGColor
        path2.lineWidth   = 0.04*self.frame.size.width
        path2.strokeEnd   = 0
        layers["path2"] = path2
        let path3 = CAShapeLayer()
        Group.addSublayer(path3)
        path3.setValue(-180 * CGFloat(M_PI)/180, forKeyPath:"transform.rotation")
        path3.lineCap     = kCALineCapRound
        path3.fillColor   = nil
        path3.strokeColor = UIColor(red:0.516, green: 0.799, blue:0.684, alpha:1).CGColor
        path3.lineWidth   = 0.04*self.frame.size.width
        path3.strokeEnd   = 0
        layers["path3"] = path3
        let path4 = CAShapeLayer()
        Group.addSublayer(path4)
        path4.setValue(-180 * CGFloat(M_PI)/180, forKeyPath:"transform.rotation")
        path4.lineCap     = kCALineCapRound
        path4.fillColor   = nil
        path4.strokeColor = UIColor(red:0.64, green: 0.632, blue:0.574, alpha:1).CGColor
        path4.lineWidth   = 0.04*self.frame.size.width
        path4.strokeEnd   = 0
        layers["path4"] = path4
        let path5 = CAShapeLayer()
        Group.addSublayer(path5)
        path5.setValue(-180 * CGFloat(M_PI)/180, forKeyPath:"transform.rotation")
        path5.lineCap     = kCALineCapRound
        path5.fillColor   = nil
        path5.strokeColor = UIColor(red:0.97, green: 0.733, blue:0.268, alpha:1).CGColor
        path5.lineWidth   = 0.04*self.frame.size.width
        path5.strokeEnd   = 0
        layers["path5"] = path5
        let ic_lomobile_navitem_energy = CALayer()
        Group.addSublayer(ic_lomobile_navitem_energy)
        ic_lomobile_navitem_energy.contents = UIImage(named:"ic_lomobile_navitem_energy")?.CGImage
        layers["ic_lomobile_navitem_energy"] = ic_lomobile_navitem_energy
        let ic_lomobile_navitem_water = CALayer()
        Group.addSublayer(ic_lomobile_navitem_water)
        ic_lomobile_navitem_water.contents = UIImage(named:"ic_lomobile_navitem_water")?.CGImage
        layers["ic_lomobile_navitem_water"] = ic_lomobile_navitem_water
        let ic_lomobile_navitem_waste = CALayer()
        Group.addSublayer(ic_lomobile_navitem_waste)
        ic_lomobile_navitem_waste.contents = UIImage(named:"ic_lomobile_navitem_waste")?.CGImage
        layers["ic_lomobile_navitem_waste"] = ic_lomobile_navitem_waste
        let ic_lomobile_navitem_transport = CALayer()
        Group.addSublayer(ic_lomobile_navitem_transport)
        ic_lomobile_navitem_transport.contents = UIImage(named:"ic_lomobile_navitem_transport")?.CGImage
        layers["ic_lomobile_navitem_transport"] = ic_lomobile_navitem_transport
        let ic_lomobile_navitem_human = CALayer()
        Group.addSublayer(ic_lomobile_navitem_human)
        ic_lomobile_navitem_human.contents = UIImage(named:"ic_lomobile_navitem_human")?.CGImage
        layers["ic_lomobile_navitem_human"] = ic_lomobile_navitem_human
        setupLayerFrames()
    }
    
    
    func setupLayerFrames(){
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        if let Group : CALayer = layers["Group"] as? CALayer{
            Group.frame = CGRectMake(0.02 * Group.superlayer!.bounds.width, 0.12017 * Group.superlayer!.bounds.height, 0.94 * Group.superlayer!.bounds.width, 0.85075 * Group.superlayer!.bounds.height)
        }
        
        if let text2 : CATextLayer = layers["text2"] as? CATextLayer{
            text2.frame = CGRectMake(0.97872 * text2.superlayer!.bounds.width, 0.70268 * text2.superlayer!.bounds.height, 0.06383 * text2.superlayer!.bounds.width, 0.07053 * text2.superlayer!.bounds.width)
        }
        
        if let text3 : CATextLayer = layers["text3"] as? CATextLayer{
            text3.frame = CGRectMake(0.96277 * text3.superlayer!.bounds.width, -0.05877 * text3.superlayer!.bounds.height, 0.07447 * text3.superlayer!.bounds.width, 0.06465 * text3.superlayer!.bounds.width)
        }
        
        if let text : CATextLayer = layers["text"] as? CATextLayer{
            text.frame = CGRectMake(0, 0.92119 * text.superlayer!.bounds.height,  text.superlayer!.bounds.width, 0.11881 * text.superlayer!.bounds.width)
        }
        
        if let rectangle : CAShapeLayer = layers["rectangle"] as? CAShapeLayer{
            rectangle.frame = CGRectMake(0.01064 * rectangle.superlayer!.bounds.width, 0.72992 * rectangle.superlayer!.bounds.height, 0.97872 * rectangle.superlayer!.bounds.width, 0.01022 * rectangle.superlayer!.bounds.height)
            rectangle.path  = rectanglePathWithBounds((layers["rectangle"] as! CAShapeLayer).bounds).CGPath
        }
        
        if let path : CAShapeLayer = layers["path"] as? CAShapeLayer{
            path.transform = CATransform3DIdentity
            path.frame     = CGRectMake(0.08835 * path.superlayer!.bounds.width, 0, 0, 0.65785 * path.superlayer!.bounds.height)
            path.setValue(-180 * CGFloat(M_PI)/180, forKeyPath:"transform.rotation")
            path.path      = pathPathWithBounds((layers["path"] as! CAShapeLayer).bounds).CGPath
        }
        
        if let path2 : CAShapeLayer = layers["path2"] as? CAShapeLayer{
            path2.transform = CATransform3DIdentity
            path2.frame     = CGRectMake(0.30111 * path2.superlayer!.bounds.width, 0, 0, 0.65785 * path2.superlayer!.bounds.height)
            path2.setValue(-180 * CGFloat(M_PI)/180, forKeyPath:"transform.rotation")
            path2.path      = path2PathWithBounds((layers["path2"] as! CAShapeLayer).bounds).CGPath
        }
        
        if let path3 : CAShapeLayer = layers["path3"] as? CAShapeLayer{
            path3.transform = CATransform3DIdentity
            path3.frame     = CGRectMake(0.5 * path3.superlayer!.bounds.width, 0, 0, 0.65785 * path3.superlayer!.bounds.height)
            path3.setValue(-180 * CGFloat(M_PI)/180, forKeyPath:"transform.rotation")
            path3.path      = path3PathWithBounds((layers["path3"] as! CAShapeLayer).bounds).CGPath
        }
        
        if let path4 : CAShapeLayer = layers["path4"] as? CAShapeLayer{
            path4.transform = CATransform3DIdentity
            path4.frame     = CGRectMake(0.72665 * path4.superlayer!.bounds.width, 0, 0, 0.65785 * path4.superlayer!.bounds.height)
            path4.setValue(-180 * CGFloat(M_PI)/180, forKeyPath:"transform.rotation")
            path4.path      = path4PathWithBounds((layers["path4"] as! CAShapeLayer).bounds).CGPath
        }
        
        if let path5 : CAShapeLayer = layers["path5"] as? CAShapeLayer{
            path5.transform = CATransform3DIdentity
            path5.frame     = CGRectMake(0.92877 * path5.superlayer!.bounds.width, 0, 0, 0.65785 * path5.superlayer!.bounds.height)
            path5.setValue(-180 * CGFloat(M_PI)/180, forKeyPath:"transform.rotation")
            path5.path      = path5PathWithBounds((layers["path5"] as! CAShapeLayer).bounds).CGPath
        }
        
        if let ic_lomobile_navitem_energy : CALayer = layers["ic_lomobile_navitem_energy"] as? CALayer{
            ic_lomobile_navitem_energy.frame = CGRectMake(0.04579 * ic_lomobile_navitem_energy.superlayer!.bounds.width, 0.7754 * ic_lomobile_navitem_energy.superlayer!.bounds.height, 0.07511 * ic_lomobile_navitem_energy.superlayer!.bounds.width, 0.08403 * ic_lomobile_navitem_energy.superlayer!.bounds.width)
        }
        
        if let ic_lomobile_navitem_water : CALayer = layers["ic_lomobile_navitem_water"] as? CALayer{
            ic_lomobile_navitem_water.frame = CGRectMake(0.25856 * ic_lomobile_navitem_water.superlayer!.bounds.width, 0.7754 * ic_lomobile_navitem_water.superlayer!.bounds.height, 0.07511 * ic_lomobile_navitem_water.superlayer!.bounds.width, 0.08403 * ic_lomobile_navitem_water.superlayer!.bounds.width)
        }
        
        if let ic_lomobile_navitem_waste : CALayer = layers["ic_lomobile_navitem_waste"] as? CALayer{
            ic_lomobile_navitem_waste.frame = CGRectMake(0.45745 * ic_lomobile_navitem_waste.superlayer!.bounds.width, 0.7754 * ic_lomobile_navitem_waste.superlayer!.bounds.height, 0.07511 * ic_lomobile_navitem_waste.superlayer!.bounds.width, 0.08403 * ic_lomobile_navitem_waste.superlayer!.bounds.width)
        }
        
        if let ic_lomobile_navitem_transport : CALayer = layers["ic_lomobile_navitem_transport"] as? CALayer{
            ic_lomobile_navitem_transport.frame = CGRectMake(0.68409 * ic_lomobile_navitem_transport.superlayer!.bounds.width, 0.7754 * ic_lomobile_navitem_transport.superlayer!.bounds.height, 0.07511 * ic_lomobile_navitem_transport.superlayer!.bounds.width, 0.08403 * ic_lomobile_navitem_transport.superlayer!.bounds.width)
        }
        
        if let ic_lomobile_navitem_human : CALayer = layers["ic_lomobile_navitem_human"] as? CALayer{
            ic_lomobile_navitem_human.frame = CGRectMake(0.88622 * ic_lomobile_navitem_human.superlayer!.bounds.width, 0.7754 * ic_lomobile_navitem_human.superlayer!.bounds.height, 0.07511 * ic_lomobile_navitem_human.superlayer!.bounds.width, 0.08403 * ic_lomobile_navitem_human.superlayer!.bounds.width)
        }
        
        CATransaction.commit()
    }
    
    //MARK: - Animation Setup
    
    func addUntitled1Animation(){
        let fillMode : String = kCAFillModeForwards
        var text3 = self.layers["text3"] as! CATextLayer
        let temparr = [Int(energyscore),Int(waterscore),Int(wastescore),Int(transportscore),Int(humanscore)]
        text3.string = String(format:"%d",temparr.maxElement()!)
        
        
        print(energyscore,waterscore,wastescore,transportscore,humanscore)
        print("max")
        print(maxenergyscore,maxwaterscore,maxwastescore,maxtransportscore,maxhumanscore)        
        ////Path animation
        let pathStrokeEndAnim      = CAKeyframeAnimation(keyPath:"strokeEnd")
        var c = Double(energyscore/maxenergyscore).roundToPlaces(2)
        pathStrokeEndAnim.keyTimes = [0, 1]
        pathStrokeEndAnim.values   = [0, c]
        pathStrokeEndAnim.duration = 1
        
        let pathUntitled1Anim : CAAnimationGroup = QCMethod.groupAnimations([pathStrokeEndAnim], fillMode:fillMode)
        layers["path"]?.addAnimation(pathUntitled1Anim, forKey:"pathUntitled1Anim")
        
        ////Path2 animation
        let path2StrokeEndAnim      = CAKeyframeAnimation(keyPath:"strokeEnd")
        c = Double(waterscore/maxwaterscore).roundToPlaces(2)
        path2StrokeEndAnim.values   = [0, c]
        
        path2StrokeEndAnim.keyTimes = [0, 1]
        path2StrokeEndAnim.duration = 1
        
        let path2Untitled1Anim : CAAnimationGroup = QCMethod.groupAnimations([path2StrokeEndAnim], fillMode:fillMode)
        layers["path2"]?.addAnimation(path2Untitled1Anim, forKey:"path2Untitled1Anim")
        
        ////Path3 animation
        let path3StrokeEndAnim      = CAKeyframeAnimation(keyPath:"strokeEnd")
        c = Double(wastescore/maxwastescore).roundToPlaces(2)
        path3StrokeEndAnim.values   = [0, c]
        path3StrokeEndAnim.keyTimes = [0, 1]
        path3StrokeEndAnim.duration = 1
        
        let path3Untitled1Anim : CAAnimationGroup = QCMethod.groupAnimations([path3StrokeEndAnim], fillMode:fillMode)
        layers["path3"]?.addAnimation(path3Untitled1Anim, forKey:"path3Untitled1Anim")
        
        ////Path4 animation
        let path4StrokeEndAnim      = CAKeyframeAnimation(keyPath:"strokeEnd")
        c = Double(transportscore/maxtransportscore).roundToPlaces(2)
        path4StrokeEndAnim.values   = [0, c]
        path4StrokeEndAnim.keyTimes = [0, 1]
        path4StrokeEndAnim.duration = 1
        
        let path4Untitled1Anim : CAAnimationGroup = QCMethod.groupAnimations([path4StrokeEndAnim], fillMode:fillMode)
        layers["path4"]?.addAnimation(path4Untitled1Anim, forKey:"path4Untitled1Anim")
        
        ////Path5 animation
        let path5StrokeEndAnim      = CAKeyframeAnimation(keyPath:"strokeEnd")
        c = Double(humanscore/maxhumanscore).roundToPlaces(2)
        path5StrokeEndAnim.values   = [0, c]
        path5StrokeEndAnim.keyTimes = [0, 1]
        path5StrokeEndAnim.duration = 1
        
        let path5Untitled1Anim : CAAnimationGroup = QCMethod.groupAnimations([path5StrokeEndAnim], fillMode:fillMode)
        layers["path5"]?.addAnimation(path5Untitled1Anim, forKey:"path5Untitled1Anim")
    }
    
    func updateLayerValuesForAnimationId(identifier: String){
        if identifier == "Untitled1"{
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["path"] as! CALayer).animationForKey("pathUntitled1Anim"), theLayer:(layers["path"] as! CALayer))
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["path2"] as! CALayer).animationForKey("path2Untitled1Anim"), theLayer:(layers["path2"] as! CALayer))
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["path3"] as! CALayer).animationForKey("path3Untitled1Anim"), theLayer:(layers["path3"] as! CALayer))
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["path4"] as! CALayer).animationForKey("path4Untitled1Anim"), theLayer:(layers["path4"] as! CALayer))
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["path5"] as! CALayer).animationForKey("path5Untitled1Anim"), theLayer:(layers["path5"] as! CALayer))
        }
    }
    
    func removeAnimationsForAnimationId(identifier: String){
        if identifier == "Untitled1"{
            (layers["path"] as! CALayer).removeAnimationForKey("pathUntitled1Anim")
            (layers["path2"] as! CALayer).removeAnimationForKey("path2Untitled1Anim")
            (layers["path3"] as! CALayer).removeAnimationForKey("path3Untitled1Anim")
            (layers["path4"] as! CALayer).removeAnimationForKey("path4Untitled1Anim")
            (layers["path5"] as! CALayer).removeAnimationForKey("path5Untitled1Anim")
        }
    }
    
    func removeAllAnimations(){
        for layer in layers.values{
            (layer as! CALayer).removeAllAnimations()
        }
    }
    
    //MARK: - Bezier Path
    
    func rectanglePathWithBounds(bounds: CGRect) -> UIBezierPath{
        let rectanglePath = UIBezierPath(rect:bounds)
        return rectanglePath
    }
    
    func pathPathWithBounds(bounds: CGRect) -> UIBezierPath{
        let pathPath = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        pathPath.moveToPoint(CGPointMake(minX + 0 * w, minY))
        pathPath.addCurveToPoint(CGPointMake(minX + 0 * w, minY + h), controlPoint1:CGPointMake(minX + 0 * w, minY + 0.33333 * h), controlPoint2:CGPointMake(minX + 0 * w, minY + 0.66667 * h))
        
        return pathPath
    }
    
    func path2PathWithBounds(bounds: CGRect) -> UIBezierPath{
        let path2Path = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        path2Path.moveToPoint(CGPointMake(minX + 0 * w, minY))
        path2Path.addCurveToPoint(CGPointMake(minX + 0 * w, minY + h), controlPoint1:CGPointMake(minX + 0 * w, minY + 0.33333 * h), controlPoint2:CGPointMake(minX + 0 * w, minY + 0.66667 * h))
        
        return path2Path
    }
    
    func path3PathWithBounds(bounds: CGRect) -> UIBezierPath{
        let path3Path = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        path3Path.moveToPoint(CGPointMake(minX + 0 * w, minY))
        path3Path.addCurveToPoint(CGPointMake(minX + 0 * w, minY + h), controlPoint1:CGPointMake(minX + 0 * w, minY + 0.33333 * h), controlPoint2:CGPointMake(minX + 0 * w, minY + 0.66667 * h))
        
        return path3Path
    }
    
    func path4PathWithBounds(bounds: CGRect) -> UIBezierPath{
        let path4Path = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        path4Path.moveToPoint(CGPointMake(minX + 0 * w, minY))
        path4Path.addCurveToPoint(CGPointMake(minX + 0 * w, minY + h), controlPoint1:CGPointMake(minX + 0 * w, minY + 0.33333 * h), controlPoint2:CGPointMake(minX + 0 * w, minY + 0.66667 * h))
        
        return path4Path
    }
    
    func path5PathWithBounds(bounds: CGRect) -> UIBezierPath{
        let path5Path = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        path5Path.moveToPoint(CGPointMake(minX + 0 * w, minY))
        path5Path.addCurveToPoint(CGPointMake(minX + 0 * w, minY + h), controlPoint1:CGPointMake(minX + 0 * w, minY + 0.33333 * h), controlPoint2:CGPointMake(minX + 0 * w, minY + 0.66667 * h))
        
        return path5Path
    }
    
    
}

extension Double {
    /// Rounds the double to decimal places value
    func roundToPlaces(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return round(self * divisor) / divisor
    }
}
