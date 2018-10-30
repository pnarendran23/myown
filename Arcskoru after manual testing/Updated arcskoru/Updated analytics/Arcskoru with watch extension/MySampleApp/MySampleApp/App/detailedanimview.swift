//
//  graphlist.swift
//
//  Code generated using QuartzCode 1.52.0 on 11/01/17.
//  www.quartzcodeapp.com
//

import UIKit


class detailedanimview: UIView {
    var waterscore = 0.0, wastescore = 0.0, transportscore = 0.0, humanscore = 0.0, energyscore = 0.0
    var maxwaterscore = 0.0, maxwastescore = 0.0, maxtransportscore = 0.0, maxhumanscore = 0.0, maxenergyscore = 0.0
    var layers : Dictionary<String, AnyObject> = [:]
    var datetext = ""
    var maxscore = 0
    
    
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
        text2.contentsScale   = UIScreen.main.scale
        text2.string          = "0"
        text2.font            = "OpenSans" as CFTypeRef?
        text2.fontSize        = 0.03*self.frame.size.width
        text2.alignmentMode   = kCAAlignmentRight;
        text2.foregroundColor = UIColor.black.cgColor;
        layers["text2"] = text2
        let text3 = CATextLayer()
        Group.addSublayer(text3)
        text3.contentsScale   = UIScreen.main.scale
        text3.string          = "199\n"
        text3.font            = "OpenSans" as CFTypeRef?
        text3.fontSize        = 0.03*self.frame.size.width
        text3.alignmentMode   = kCAAlignmentRight;
        text3.foregroundColor = UIColor.black.cgColor;
        layers["text3"] = text3
        let text = CATextLayer()
        Group.addSublayer(text)
        text.contentsScale   = UIScreen.main.scale
        text.string          = datetext
        text.font            = "OpenSans" as CFTypeRef?
        text.fontSize        = 0.02*self.frame.size.width
        text.alignmentMode   = kCAAlignmentCenter;
        text.foregroundColor = UIColor.black.cgColor;
        layers["text"] = text
        let rectangle = CAShapeLayer()
        Group.addSublayer(rectangle)
        rectangle.lineCap         = kCALineCapRound
        rectangle.lineJoin        = kCALineJoinBevel
        rectangle.fillColor       = UIColor(red:0.677, green: 0.685, blue:0.685, alpha:1).cgColor
        rectangle.strokeColor     = UIColor(red:0.329, green: 0.329, blue:0.329, alpha:1).cgColor
        rectangle.lineWidth       = 0
        rectangle.lineDashPattern = [0, 1]
        layers["rectangle"] = rectangle
        let path = CAShapeLayer()
        Group.addSublayer(path)
        path.setValue(-180 * CGFloat(M_PI)/180, forKeyPath:"transform.rotation")
        path.lineCap     = kCALineCapRound
        path.fillColor   = nil
        path.strokeColor = UIColor(red:0.816, green: 0.865, blue:0.24, alpha:1).cgColor
        path.lineWidth   = 0.04*self.frame.size.width
        layers["path"] = path
        let path2 = CAShapeLayer()
        Group.addSublayer(path2)
        path2.setValue(-180 * CGFloat(M_PI)/180, forKeyPath:"transform.rotation")
        path2.lineCap     = kCALineCapRound
        path2.fillColor   = nil
        path2.strokeColor = UIColor(red:0.333, green: 0.794, blue:0.961, alpha:1).cgColor
        path2.lineWidth   = 0.04*self.frame.size.width
        path2.strokeEnd   = 0
        layers["path2"] = path2
        let path3 = CAShapeLayer()
        Group.addSublayer(path3)
        path3.setValue(-180 * CGFloat(M_PI)/180, forKeyPath:"transform.rotation")
        path3.lineCap     = kCALineCapRound
        path3.fillColor   = nil
        path3.strokeColor = UIColor(red:0.516, green: 0.799, blue:0.684, alpha:1).cgColor
        path3.lineWidth   = 0.04*self.frame.size.width
        path3.strokeEnd   = 0
        layers["path3"] = path3
        let path4 = CAShapeLayer()
        Group.addSublayer(path4)
        path4.setValue(-180 * CGFloat(M_PI)/180, forKeyPath:"transform.rotation")
        path4.lineCap     = kCALineCapRound
        path4.fillColor   = nil
        path4.strokeColor = UIColor(red:0.64, green: 0.632, blue:0.574, alpha:1).cgColor
        path4.lineWidth   = 0.04*self.frame.size.width
        path4.strokeEnd   = 0
        layers["path4"] = path4
        let path5 = CAShapeLayer()
        Group.addSublayer(path5)
        path5.setValue(-180 * CGFloat(M_PI)/180, forKeyPath:"transform.rotation")
        path5.lineCap     = kCALineCapRound
        path5.fillColor   = nil
        path5.strokeColor = UIColor(red:0.97, green: 0.733, blue:0.268, alpha:1).cgColor
        path5.lineWidth   = 0.04*self.frame.size.width
        path5.strokeEnd   = 0
        layers["path5"] = path5
        let ic_lomobile_navitem_energy = CALayer()
        Group.addSublayer(ic_lomobile_navitem_energy)
        ic_lomobile_navitem_energy.contents = UIImage(named:"ic_lomobile_navitem_energy")?.cgImage
        layers["ic_lomobile_navitem_energy"] = ic_lomobile_navitem_energy
        let ic_lomobile_navitem_water = CALayer()
        Group.addSublayer(ic_lomobile_navitem_water)
        ic_lomobile_navitem_water.contents = UIImage(named:"ic_lomobile_navitem_water")?.cgImage
        layers["ic_lomobile_navitem_water"] = ic_lomobile_navitem_water
        let ic_lomobile_navitem_waste = CALayer()
        Group.addSublayer(ic_lomobile_navitem_waste)
        ic_lomobile_navitem_waste.contents = UIImage(named:"ic_lomobile_navitem_waste")?.cgImage
        layers["ic_lomobile_navitem_waste"] = ic_lomobile_navitem_waste
        let ic_lomobile_navitem_transport = CALayer()
        Group.addSublayer(ic_lomobile_navitem_transport)
        ic_lomobile_navitem_transport.contents = UIImage(named:"ic_lomobile_navitem_transport")?.cgImage
        layers["ic_lomobile_navitem_transport"] = ic_lomobile_navitem_transport
        let ic_lomobile_navitem_human = CALayer()
        Group.addSublayer(ic_lomobile_navitem_human)
        ic_lomobile_navitem_human.contents = UIImage(named:"ic_lomobile_navitem_human")?.cgImage
        layers["ic_lomobile_navitem_human"] = ic_lomobile_navitem_human
        setupLayerFrames()
    }

    
    func setupLayerFrames(){
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        if let Group : CALayer = layers["Group"] as? CALayer{
            Group.frame = CGRect(x: 0.02 * Group.superlayer!.bounds.width, y: 0.12017 * Group.superlayer!.bounds.height, width: 0.94 * Group.superlayer!.bounds.width, height: 0.85075 * Group.superlayer!.bounds.height)
        }
        
        if let text2 : CATextLayer = layers["text2"] as? CATextLayer{
            text2.frame = CGRect(x: 0.97872 * text2.superlayer!.bounds.width, y: 0.70268 * text2.superlayer!.bounds.height, width: 0.06383 * text2.superlayer!.bounds.width, height: 0.07053 * text2.superlayer!.bounds.width)
        }
        
        if let text3 : CATextLayer = layers["text3"] as? CATextLayer{
            text3.frame = CGRect(x: 0.96277 * text3.superlayer!.bounds.width, y: -0.05877 * text3.superlayer!.bounds.height, width: 0.07447 * text3.superlayer!.bounds.width, height: 0.06465 * text3.superlayer!.bounds.width)
        }
        
        if let text : CATextLayer = layers["text"] as? CATextLayer{
            text.frame = CGRect(x: 0, y: 0.94119 * text.superlayer!.bounds.height,  width: text.superlayer!.bounds.width, height: 0.11881 * text.superlayer!.bounds.width)
        }
        
        if let rectangle : CAShapeLayer = layers["rectangle"] as? CAShapeLayer{
            rectangle.frame = CGRect(x: 0.01064 * rectangle.superlayer!.bounds.width, y: 0.72992 * rectangle.superlayer!.bounds.height, width: 0.97872 * rectangle.superlayer!.bounds.width, height: 0.01022 * rectangle.superlayer!.bounds.height)
            rectangle.path  = rectanglePathWithBounds((layers["rectangle"] as! CAShapeLayer).bounds).cgPath
        }
        
        if let path : CAShapeLayer = layers["path"] as? CAShapeLayer{
            path.transform = CATransform3DIdentity
            path.frame     = CGRect(x: 0.08835 * path.superlayer!.bounds.width, y: 0, width: 0, height: 0.65785 * path.superlayer!.bounds.height)
            path.setValue(-180 * CGFloat(M_PI)/180, forKeyPath:"transform.rotation")
            path.path      = pathPathWithBounds((layers["path"] as! CAShapeLayer).bounds).cgPath
        }
        
        if let path2 : CAShapeLayer = layers["path2"] as? CAShapeLayer{
            path2.transform = CATransform3DIdentity
            path2.frame     = CGRect(x: 0.30111 * path2.superlayer!.bounds.width, y: 0, width: 0, height: 0.65785 * path2.superlayer!.bounds.height)
            path2.setValue(-180 * CGFloat(M_PI)/180, forKeyPath:"transform.rotation")
            path2.path      = path2PathWithBounds((layers["path2"] as! CAShapeLayer).bounds).cgPath
        }
        
        if let path3 : CAShapeLayer = layers["path3"] as? CAShapeLayer{
            path3.transform = CATransform3DIdentity
            path3.frame     = CGRect(x: 0.5 * path3.superlayer!.bounds.width, y: 0, width: 0, height: 0.65785 * path3.superlayer!.bounds.height)
            path3.setValue(-180 * CGFloat(M_PI)/180, forKeyPath:"transform.rotation")
            path3.path      = path3PathWithBounds((layers["path3"] as! CAShapeLayer).bounds).cgPath
        }
        
        if let path4 : CAShapeLayer = layers["path4"] as? CAShapeLayer{
            path4.transform = CATransform3DIdentity
            path4.frame     = CGRect(x: 0.72665 * path4.superlayer!.bounds.width, y: 0, width: 0, height: 0.65785 * path4.superlayer!.bounds.height)
            path4.setValue(-180 * CGFloat(M_PI)/180, forKeyPath:"transform.rotation")
            path4.path      = path4PathWithBounds((layers["path4"] as! CAShapeLayer).bounds).cgPath
        }
        
        if let path5 : CAShapeLayer = layers["path5"] as? CAShapeLayer{
            path5.transform = CATransform3DIdentity
            path5.frame     = CGRect(x: 0.92877 * path5.superlayer!.bounds.width, y: 0, width: 0, height: 0.65785 * path5.superlayer!.bounds.height)
            path5.setValue(-180 * CGFloat(M_PI)/180, forKeyPath:"transform.rotation")
            path5.path      = path5PathWithBounds((layers["path5"] as! CAShapeLayer).bounds).cgPath
        }
        
        if let ic_lomobile_navitem_energy : CALayer = layers["ic_lomobile_navitem_energy"] as? CALayer{
            ic_lomobile_navitem_energy.frame = CGRect(x: 0.04579 * ic_lomobile_navitem_energy.superlayer!.bounds.width, y: 0.7754 * ic_lomobile_navitem_energy.superlayer!.bounds.height, width: 0.08511 * ic_lomobile_navitem_energy.superlayer!.bounds.width, height: 0.09403 * ic_lomobile_navitem_energy.superlayer!.bounds.width)
        }
        
        if let ic_lomobile_navitem_water : CALayer = layers["ic_lomobile_navitem_water"] as? CALayer{
            ic_lomobile_navitem_water.frame = CGRect(x: 0.25856 * ic_lomobile_navitem_water.superlayer!.bounds.width, y: 0.7754 * ic_lomobile_navitem_water.superlayer!.bounds.height, width: 0.08511 * ic_lomobile_navitem_water.superlayer!.bounds.width, height: 0.09403 * ic_lomobile_navitem_water.superlayer!.bounds.width)
        }
        
        if let ic_lomobile_navitem_waste : CALayer = layers["ic_lomobile_navitem_waste"] as? CALayer{
            ic_lomobile_navitem_waste.frame = CGRect(x: 0.45745 * ic_lomobile_navitem_waste.superlayer!.bounds.width, y: 0.7754 * ic_lomobile_navitem_waste.superlayer!.bounds.height, width: 0.08511 * ic_lomobile_navitem_waste.superlayer!.bounds.width, height: 0.09403 * ic_lomobile_navitem_waste.superlayer!.bounds.width)
        }
        
        if let ic_lomobile_navitem_transport : CALayer = layers["ic_lomobile_navitem_transport"] as? CALayer{
            ic_lomobile_navitem_transport.frame = CGRect(x: 0.68409 * ic_lomobile_navitem_transport.superlayer!.bounds.width, y: 0.7754 * ic_lomobile_navitem_transport.superlayer!.bounds.height, width: 0.08511 * ic_lomobile_navitem_transport.superlayer!.bounds.width, height: 0.09403 * ic_lomobile_navitem_transport.superlayer!.bounds.width)
        }
        
        if let ic_lomobile_navitem_human : CALayer = layers["ic_lomobile_navitem_human"] as? CALayer{
            ic_lomobile_navitem_human.frame = CGRect(x: 0.88622 * ic_lomobile_navitem_human.superlayer!.bounds.width, y: 0.7754 * ic_lomobile_navitem_human.superlayer!.bounds.height, width: 0.08511 * ic_lomobile_navitem_human.superlayer!.bounds.width, height: 0.09403 * ic_lomobile_navitem_human.superlayer!.bounds.width)
        }
        
        CATransaction.commit()
    }
    
    //MARK: - Animation Setup
    
    func addUntitled1Animation(){
        let fillMode : String = kCAFillModeForwards
        //print(energyscore,waterscore,wastescore,transportscore,humanscore)
        //print("max")
        //print(maxenergyscore,maxwaterscore,maxwastescore,maxtransportscore,maxhumanscore)
        
        var text = self.layers["text"] as! CATextLayer
        text.string = datetext
        
        var text3 = self.layers["text3"] as! CATextLayer
        let temparr = [Int(energyscore),Int(waterscore),Int(wastescore),Int(transportscore),Int(humanscore)]
        text3.string = String(format:"%d",temparr.max()!)
        
        ////Path animation
        let pathStrokeEndAnim      = CAKeyframeAnimation(keyPath:"strokeEnd")
        var c = Double(energyscore/maxenergyscore).roundToPlaces(places:2)
        pathStrokeEndAnim.keyTimes = [0, 1]
        pathStrokeEndAnim.values   = [0, c]
        pathStrokeEndAnim.duration = 1
        
        let pathUntitled1Anim : CAAnimationGroup = QCMethod.groupAnimations([pathStrokeEndAnim], fillMode:fillMode)
        layers["path"]?.add(pathUntitled1Anim, forKey:"pathUntitled1Anim")
        
        ////Path2 animation
        let path2StrokeEndAnim      = CAKeyframeAnimation(keyPath:"strokeEnd")
        c = Double(waterscore/maxwaterscore).roundToPlaces(places:2)
        path2StrokeEndAnim.values   = [0, c]
        
        path2StrokeEndAnim.keyTimes = [0, 1]
        path2StrokeEndAnim.duration = 1
        
        let path2Untitled1Anim : CAAnimationGroup = QCMethod.groupAnimations([path2StrokeEndAnim], fillMode:fillMode)
        layers["path2"]?.add(path2Untitled1Anim, forKey:"path2Untitled1Anim")
        
        ////Path3 animation
        let path3StrokeEndAnim      = CAKeyframeAnimation(keyPath:"strokeEnd")
        c = Double(wastescore/maxwastescore).roundToPlaces(places:2)
        path3StrokeEndAnim.values   = [0, c]
        path3StrokeEndAnim.keyTimes = [0, 1]
        path3StrokeEndAnim.duration = 1
        
        let path3Untitled1Anim : CAAnimationGroup = QCMethod.groupAnimations([path3StrokeEndAnim], fillMode:fillMode)
        layers["path3"]?.add(path3Untitled1Anim, forKey:"path3Untitled1Anim")
        
        ////Path4 animation
        let path4StrokeEndAnim      = CAKeyframeAnimation(keyPath:"strokeEnd")
        c = Double(transportscore/maxtransportscore).roundToPlaces(places:2)
        path4StrokeEndAnim.values   = [0, c]
        path4StrokeEndAnim.keyTimes = [0, 1]
        path4StrokeEndAnim.duration = 1
        
        let path4Untitled1Anim : CAAnimationGroup = QCMethod.groupAnimations([path4StrokeEndAnim], fillMode:fillMode)
        layers["path4"]?.add(path4Untitled1Anim, forKey:"path4Untitled1Anim")
        
        ////Path5 animation
        let path5StrokeEndAnim      = CAKeyframeAnimation(keyPath:"strokeEnd")
        c = Double(humanscore/maxhumanscore).roundToPlaces(places:2)
        path5StrokeEndAnim.values   = [0, c]
        path5StrokeEndAnim.keyTimes = [0, 1]
        path5StrokeEndAnim.duration = 1
        
        let path5Untitled1Anim : CAAnimationGroup = QCMethod.groupAnimations([path5StrokeEndAnim], fillMode:fillMode)
        layers["path5"]?.add(path5Untitled1Anim, forKey:"path5Untitled1Anim")
    }
    
    func updateLayerValuesForAnimationId(_ identifier: String){
        if identifier == "Untitled1"{
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["path"] as! CALayer).animation(forKey: "pathUntitled1Anim"), theLayer:(layers["path"] as! CALayer))
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["path2"] as! CALayer).animation(forKey: "path2Untitled1Anim"), theLayer:(layers["path2"] as! CALayer))
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["path3"] as! CALayer).animation(forKey: "path3Untitled1Anim"), theLayer:(layers["path3"] as! CALayer))
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["path4"] as! CALayer).animation(forKey: "path4Untitled1Anim"), theLayer:(layers["path4"] as! CALayer))
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["path5"] as! CALayer).animation(forKey: "path5Untitled1Anim"), theLayer:(layers["path5"] as! CALayer))
        }
    }
    
    func removeAnimationsForAnimationId(_ identifier: String){
        if identifier == "Untitled1"{
            (layers["path"] as! CALayer).removeAnimation(forKey: "pathUntitled1Anim")
            (layers["path2"] as! CALayer).removeAnimation(forKey: "path2Untitled1Anim")
            (layers["path3"] as! CALayer).removeAnimation(forKey: "path3Untitled1Anim")
            (layers["path4"] as! CALayer).removeAnimation(forKey: "path4Untitled1Anim")
            (layers["path5"] as! CALayer).removeAnimation(forKey: "path5Untitled1Anim")
        }
    }
    
    func removeAllAnimations(){
        for layer in layers.values{
            (layer as! CALayer).removeAllAnimations()
        }
    }
    
    //MARK: - Bezier Path
    
    func rectanglePathWithBounds(_ bounds: CGRect) -> UIBezierPath{
        let rectanglePath = UIBezierPath(rect:bounds)
        return rectanglePath
    }
    
    func pathPathWithBounds(_ bounds: CGRect) -> UIBezierPath{
        let pathPath = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        pathPath.move(to: CGPoint(x: minX + 0 * w, y: minY))
        pathPath.addCurve(to: CGPoint(x: minX + 0 * w, y: minY + h), controlPoint1:CGPoint(x: minX + 0 * w, y: minY + 0.33333 * h), controlPoint2:CGPoint(x: minX + 0 * w, y: minY + 0.66667 * h))
        
        return pathPath
    }
    
    func path2PathWithBounds(_ bounds: CGRect) -> UIBezierPath{
        let path2Path = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        path2Path.move(to: CGPoint(x: minX + 0 * w, y: minY))
        path2Path.addCurve(to: CGPoint(x: minX + 0 * w, y: minY + h), controlPoint1:CGPoint(x: minX + 0 * w, y: minY + 0.33333 * h), controlPoint2:CGPoint(x: minX + 0 * w, y: minY + 0.66667 * h))
        
        return path2Path
    }
    
    func path3PathWithBounds(_ bounds: CGRect) -> UIBezierPath{
        let path3Path = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        path3Path.move(to: CGPoint(x: minX + 0 * w, y: minY))
        path3Path.addCurve(to: CGPoint(x: minX + 0 * w, y: minY + h), controlPoint1:CGPoint(x: minX + 0 * w, y: minY + 0.33333 * h), controlPoint2:CGPoint(x: minX + 0 * w, y: minY + 0.66667 * h))
        
        return path3Path
    }
    
    func path4PathWithBounds(_ bounds: CGRect) -> UIBezierPath{
        let path4Path = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        path4Path.move(to: CGPoint(x: minX + 0 * w, y: minY))
        path4Path.addCurve(to: CGPoint(x: minX + 0 * w, y: minY + h), controlPoint1:CGPoint(x: minX + 0 * w, y: minY + 0.33333 * h), controlPoint2:CGPoint(x: minX + 0 * w, y: minY + 0.66667 * h))
        
        return path4Path
    }
    
    func path5PathWithBounds(_ bounds: CGRect) -> UIBezierPath{
        let path5Path = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        path5Path.move(to: CGPoint(x: minX + 0 * w, y: minY))
        path5Path.addCurve(to: CGPoint(x: minX + 0 * w, y: minY + h), controlPoint1:CGPoint(x: minX + 0 * w, y: minY + 0.33333 * h), controlPoint2:CGPoint(x: minX + 0 * w, y: minY + 0.66667 * h))
        
        return path5Path
    }
    
    
}
