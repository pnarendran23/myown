//
//  circularprogress.swift
//
//  Code generated using QuartzCode 1.52.0 on 22/12/16.
//  www.quartzcodeapp.com
//

import UIKit


class circularprogress: UIView {
    var current = 0.0
    var max = 100.0
    var layers : Dictionary<String, AnyObject> = [:]
    var completionBlocks : Dictionary<CAAnimation, (Bool) -> Void> = [:]
    var updateLayerValueForCompletedAnimation : Bool = false    
    var strokecolor = UIColor(red:0.122, green: 0.781, blue:0.809, alpha:1)
    
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
            if let progresscircle : CAShapeLayer = layers["progresscircle"] as? CAShapeLayer{
                progresscircle.strokeColor   = strokecolor.cgColor
        }
    }
    
    func setupLayers(){
        let currentscore = CATextLayer()
        self.layer.addSublayer(currentscore)
        currentscore.contentsScale   = UIScreen.main.scale
        currentscore.string          = String(format: "%d",Int(current))
        currentscore.font            = "OpenSans-Semibold" as CFTypeRef?
        currentscore.fontSize        = 17
        currentscore.alignmentMode   = kCAAlignmentCenter;
        currentscore.foregroundColor = UIColor.darkGray.cgColor;
        layers["currentscore"] = currentscore
        
        let outof = CATextLayer()
        self.layer.addSublayer(outof)
        outof.contentsScale   = UIScreen.main.scale
        outof.string          = String(format: "Out of %d",Int(max))
        outof.font            = "OpenSans-Semibold" as CFTypeRef?
        outof.fontSize        = 12
        outof.alignmentMode   = kCAAlignmentCenter;        
        outof.foregroundColor = UIColor.darkGray.cgColor;
        layers["outof"] = outof
        
        
        let outercircle = CAShapeLayer()
        self.layer.addSublayer(outercircle)
        outercircle.lineCap     = kCALineCapRound
        outercircle.fillColor   = nil
        outercircle.strokeColor = UIColor.lightGray.cgColor
            //UIColor(red:0.936, green: 0.957, blue:0.957, alpha:1).CGColor
        outercircle.lineWidth   = 10
        outercircle.opacity = 0.2
        layers["outercircle"] = outercircle
        
        let progresscircle = CAShapeLayer()
        self.layer.addSublayer(progresscircle)
        progresscircle.lineCap     = kCALineCapRound
        progresscircle.fillColor   = nil
        progresscircle.strokeColor   = strokecolor.cgColor
        progresscircle.lineWidth     = 10
        progresscircle.strokeStart   = 1
        layers["progresscircle"] = progresscircle
        setupLayerFrames()
    }
    
    func setupLayerFrames(){
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        if let currentscore : CATextLayer = layers["currentscore"] as? CATextLayer{
            currentscore.frame = CGRect(x: 0.35526 * currentscore.superlayer!.bounds.width, y: 0.34153 * currentscore.superlayer!.bounds.height, width: 0.28749 * currentscore.superlayer!.bounds.width, height: 0.29115 * currentscore.superlayer!.bounds.height)
            currentscore.fontSize        = 0.24749 * currentscore.superlayer!.bounds.width
        }
        
        if let outof : CATextLayer = layers["outof"] as? CATextLayer{
            outof.frame = CGRect(x: 0.25 * outof.superlayer!.bounds.width, y: 0.605 * outof.superlayer!.bounds.height, width: 0.5 * outof.superlayer!.bounds.width, height: 0.12769 * outof.superlayer!.bounds.height)
            
            outof.fontSize = 0.08 * outof.superlayer!.bounds.width
        }
        
        if let outercircle : CAShapeLayer = layers["outercircle"] as? CAShapeLayer{
            outercircle.frame = CGRect(x: 0.125 * outercircle.superlayer!.bounds.width, y: 0.165 * outercircle.superlayer!.bounds.height, width: 0.75 * outercircle.superlayer!.bounds.width, height: 0.75 * outercircle.superlayer!.bounds.width)
            outercircle.path  = outercirclePathWithBounds((layers["outercircle"] as! CAShapeLayer).bounds).cgPath
            outercircle.lineWidth =  0.092 * outercircle.superlayer!.bounds.height
        }
        
        if let progresscircle : CAShapeLayer = layers["progresscircle"] as? CAShapeLayer{
            progresscircle.frame = CGRect(x: 0.125 * progresscircle.superlayer!.bounds.width, y: 0.165 * progresscircle.superlayer!.bounds.height, width: 0.75 * progresscircle.superlayer!.bounds.width, height: 0.75 * progresscircle.superlayer!.bounds.width)
            progresscircle.path  = progresscirclePathWithBounds((layers["progresscircle"] as! CAShapeLayer).bounds).cgPath
            progresscircle.lineWidth =  0.092 * progresscircle.superlayer!.bounds.height
        }
        
        CATransaction.commit()
    }
    
    //MARK: - Animation Setup
    
    func addUntitled1Animation(){
        addUntitled1AnimationCompletionBlock(nil)
    }
    
    func addUntitled1AnimationCompletionBlock(_ completionBlock: ((_ finished: Bool) -> Void)? = nil){
        let fillMode : String = kCAFillModeForwards
        
        
        let currenttextlayer =  layers["currentscore"] as! CATextLayer
        currenttextlayer.string = String(format: "%d",Int(current))
        layers["currentscore"] = currenttextlayer
        
        let maxtextlayer =  layers["outof"] as! CATextLayer
        maxtextlayer.string = String(format: "Out of %d",Int(max))
        layers["outof"] = maxtextlayer
        
        ////Progresscircle animation
        let progresscircleStrokeStartAnim      = CAKeyframeAnimation(keyPath:"strokeStart")
        let calculate = current/max
        progresscircleStrokeStartAnim.values   = [1, 1-calculate]
        progresscircleStrokeStartAnim.keyTimes = [0, 1]
        progresscircleStrokeStartAnim.duration = 1
        
        let progresscircleUntitled1Anim : CAAnimationGroup = QCMethod.groupAnimations([progresscircleStrokeStartAnim], fillMode:fillMode)
        layers["progresscircle"]?.add(progresscircleUntitled1Anim, forKey:"progresscircleUntitled1Anim")
    }
    
    //MARK: - Animation Cleanup
    
   func updateLayerValuesForAnimationId(_ identifier: String){
        if identifier == "Untitled1"{
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["progresscircle"] as! CALayer).animation(forKey: "progresscircleUntitled1Anim"), theLayer:(layers["progresscircle"] as! CALayer))
        }
    }
    
    func removeAnimationsForAnimationId(_ identifier: String){
        if identifier == "Untitled1"{
            (layers["progresscircle"] as! CALayer).removeAnimation(forKey: "progresscircleUntitled1Anim")
        }
    }
    
    func removeAllAnimations(){
        for layer in layers.values{
            (layer as! CALayer).removeAllAnimations()
        }
    }
    
    //MARK: - Bezier Path
    
    func outercirclePathWithBounds(_ bounds: CGRect) -> UIBezierPath{
        let progresscirclePath = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        progresscirclePath.move(to: CGPoint(x: minX + 0.5 * w, y: minY))
        progresscirclePath.addCurve(to: CGPoint(x: minX, y: minY + 0.5 * h), controlPoint1:CGPoint(x: minX + 0.22386 * w, y: minY), controlPoint2:CGPoint(x: minX, y: minY + 0.22386 * h))
        progresscirclePath.addCurve(to: CGPoint(x: minX + 0.5 * w, y: minY + h), controlPoint1:CGPoint(x: minX, y: minY + 0.77614 * h), controlPoint2:CGPoint(x: minX + 0.22386 * w, y: minY + h))
        progresscirclePath.addCurve(to: CGPoint(x: minX + w, y: minY + 0.5 * h), controlPoint1:CGPoint(x: minX + 0.77614 * w, y: minY + h), controlPoint2:CGPoint(x: minX + w, y: minY + 0.77614 * h))
        progresscirclePath.addCurve(to: CGPoint(x: minX + 0.5 * w, y: minY), controlPoint1:CGPoint(x: minX + w, y: minY + 0.22386 * h), controlPoint2:CGPoint(x: minX + 0.77614 * w, y: minY))
        
        return progresscirclePath

    }
    
    func progresscirclePathWithBounds(_ bounds: CGRect) -> UIBezierPath{
        let progresscirclePath = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        progresscirclePath.move(to: CGPoint(x: minX + 0.5 * w, y: minY))
        progresscirclePath.addCurve(to: CGPoint(x: minX, y: minY + 0.5 * h), controlPoint1:CGPoint(x: minX + 0.22386 * w, y: minY), controlPoint2:CGPoint(x: minX, y: minY + 0.22386 * h))
        progresscirclePath.addCurve(to: CGPoint(x: minX + 0.5 * w, y: minY + h), controlPoint1:CGPoint(x: minX, y: minY + 0.77614 * h), controlPoint2:CGPoint(x: minX + 0.22386 * w, y: minY + h))
        progresscirclePath.addCurve(to: CGPoint(x: minX + w, y: minY + 0.5 * h), controlPoint1:CGPoint(x: minX + 0.77614 * w, y: minY + h), controlPoint2:CGPoint(x: minX + w, y: minY + 0.77614 * h))
        progresscirclePath.addCurve(to: CGPoint(x: minX + 0.5 * w, y: minY), controlPoint1:CGPoint(x: minX + w, y: minY + 0.22386 * h), controlPoint2:CGPoint(x: minX + 0.77614 * w, y: minY))
        
        return progresscirclePath
    }
    
    
    
    
    
}
