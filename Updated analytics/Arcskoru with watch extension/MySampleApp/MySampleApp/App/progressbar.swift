//
//  progressbar.swift
//
//  Code generated using QuartzCode 1.52.0 on 03/04/17.
//  www.quartzcodeapp.com
//

import UIKit


class progressbar: UIView {
    var strokevalue = 0.0
    var linewidth = CGFloat(0.0)
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
    
    var strokecolor = UIColor.brownColor()
    
    func setupLayers(){
        let progressback = CAShapeLayer()
        self.layer.addSublayer(progressback)
        progressback.lineCap     = kCALineCapRound
        progressback.fillColor   = nil
        progressback.strokeColor = UIColor(red:0.921, green: 0.922, blue:0.921, alpha:1).CGColor
        progressback.lineWidth   = 5
        linewidth = 0.2 * self.frame.size.height
        progressback.lineWidth = linewidth
        layers["progressback"] = progressback
        
        let progress = CAShapeLayer()
        self.layer.addSublayer(progress)
        progress.lineCap     = kCALineCapRound
        progress.fillColor   = nil
        progress.strokeColor = strokecolor.CGColor
        linewidth = 0.2 * self.frame.size.height
        progress.lineWidth   = linewidth
        progress.strokeEnd   = 0
        layers["progress"] = progress
        setupLayerFrames()
    }
    
    func setupLayerFrames(){
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        if let progressback : CAShapeLayer = layers["progressback"] as? CAShapeLayer{
            progressback.frame = CGRectMake(0.04 * progressback.superlayer!.bounds.width, 0.35 * progressback.superlayer!.bounds.height, 0.8365 * progressback.superlayer!.bounds.width, 0)
            progressback.path  = progressbackPathWithBounds((layers["progressback"] as! CAShapeLayer).bounds).CGPath
        }
        
        if let progress : CAShapeLayer = layers["progress"] as? CAShapeLayer{
            progress.frame = CGRectMake(0.04 * progress.superlayer!.bounds.width, 0.35 * progress.superlayer!.bounds.height, 0.84 * progress.superlayer!.bounds.width, 0)
            progress.path  = progressPathWithBounds((layers["progress"] as! CAShapeLayer).bounds).CGPath
        }
        
        CATransaction.commit()
    }
    
    //MARK: - Animation Setup
    
    func addUntitled1Animation(){
        let fillMode : String = kCAFillModeForwards
        
        ////Progress animation
        let layer = layers["progress"] as! CAShapeLayer
        layer.strokeColor = strokecolor.CGColor
        layers["progress"] = layer
        
        let progressStrokeEndAnim      = CAKeyframeAnimation(keyPath:"strokeEnd")
        progressStrokeEndAnim.values   = [0, strokevalue]
        progressStrokeEndAnim.keyTimes = [0, 1]
        progressStrokeEndAnim.duration = 1
        
        let progressUntitled1Anim : CAAnimationGroup = QCMethod.groupAnimations([progressStrokeEndAnim], fillMode:fillMode)
        layers["progress"]?.addAnimation(progressUntitled1Anim, forKey:"progressUntitled1Anim")
    }
    
    func updateLayerValuesForAnimationId(identifier: String){
        if identifier == "Untitled1"{
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["progress"] as! CALayer).animationForKey("progressUntitled1Anim"), theLayer:(layers["progress"] as! CALayer))
        }
    }
    
    func removeAnimationsForAnimationId(identifier: String){
        if identifier == "Untitled1"{
            (layers["progress"] as! CALayer).removeAnimationForKey("progressUntitled1Anim")
        }
    }
    
    func removeAllAnimations(){
        for layer in layers.values{
            (layer as! CALayer).removeAllAnimations()
        }
    }
    
    //MARK: - Bezier Path
    
    func progressbackPathWithBounds(bounds: CGRect) -> UIBezierPath{
        let progressbackPath = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        progressbackPath.moveToPoint(CGPointMake(minX, minY + 0 * h))
        progressbackPath.addCurveToPoint(CGPointMake(minX + w, minY + 0 * h), controlPoint1:CGPointMake(minX + 0.33333 * w, minY + 0 * h), controlPoint2:CGPointMake(minX + 0.66667 * w, minY + 0 * h))
        
        return progressbackPath
    }
    
    func progressPathWithBounds(bounds: CGRect) -> UIBezierPath{
        let progressPath = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        progressPath.moveToPoint(CGPointMake(minX, minY + 0 * h))
        progressPath.addCurveToPoint(CGPointMake(minX + w, minY + 0 * h), controlPoint1:CGPointMake(minX + 0.33333 * w, minY + 0 * h), controlPoint2:CGPointMake(minX + 0.66667 * w, minY + 0 * h))
        
        return progressPath
    }
    
    
}
