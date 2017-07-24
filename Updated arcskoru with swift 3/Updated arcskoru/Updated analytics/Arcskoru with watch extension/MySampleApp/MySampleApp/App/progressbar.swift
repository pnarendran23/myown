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
    
    var strokecolor = UIColor.brown
    
    func setupLayers(){
        let progressback = CAShapeLayer()
        self.layer.addSublayer(progressback)
        progressback.lineCap     = kCALineCapRound
        progressback.fillColor   = nil
        progressback.strokeColor = UIColor(red:0.835, green: 0.835, blue:0.835, alpha:1).cgColor
        progressback.lineWidth   = 5
        linewidth = 0.9 * self.frame.size.height
        progressback.lineWidth = linewidth
        layers["progressback"] = progressback
        
        let progress = CAShapeLayer()
        self.layer.addSublayer(progress)
        progress.lineCap     = kCALineCapRound
        progress.fillColor   = nil
        progress.strokeColor = strokecolor.cgColor
        linewidth = 0.9 * self.frame.size.height
        progress.lineWidth   = linewidth
        progress.strokeEnd   = 0
        layers["progress"] = progress
        setupLayerFrames()
    }
    
    func setupLayerFrames(){
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        if let progressback : CAShapeLayer = layers["progressback"] as? CAShapeLayer{
            progressback.frame = CGRect(x: 0.04 * progressback.superlayer!.bounds.width, y: 0.5 * progressback.superlayer!.bounds.height, width: 0.8365 * progressback.superlayer!.bounds.width, height: 0)
            progressback.path  = progressbackPathWithBounds((layers["progressback"] as! CAShapeLayer).bounds).cgPath
        }
        
        if let progress : CAShapeLayer = layers["progress"] as? CAShapeLayer{
            progress.frame = CGRect(x: 0.04 * progress.superlayer!.bounds.width, y: 0.5 * progress.superlayer!.bounds.height, width: 0.84 * progress.superlayer!.bounds.width, height: 0)
            progress.path  = progressPathWithBounds((layers["progress"] as! CAShapeLayer).bounds).cgPath
        }
        
        CATransaction.commit()
    }
    
    //MARK: - Animation Setup
    
    func addUntitled1Animation(){
        let fillMode : String = kCAFillModeForwards
        
        ////Progress animation
        let layer = layers["progress"] as! CAShapeLayer
        layer.strokeColor = strokecolor.cgColor
        layers["progress"] = layer
        
        let progressStrokeEndAnim      = CAKeyframeAnimation(keyPath:"strokeEnd")
        progressStrokeEndAnim.values   = [0, strokevalue]
        progressStrokeEndAnim.keyTimes = [0, 1]
        progressStrokeEndAnim.duration = 1
        
        let progressUntitled1Anim : CAAnimationGroup = QCMethod.groupAnimations([progressStrokeEndAnim], fillMode:fillMode)
        layers["progress"]?.add(progressUntitled1Anim, forKey:"progressUntitled1Anim")
    }
    
    func updateLayerValuesForAnimationId(_ identifier: String){
        if identifier == "Untitled1"{
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["progress"] as! CALayer).animation(forKey: "progressUntitled1Anim"), theLayer:(layers["progress"] as! CALayer))
        }
    }
    
    func removeAnimationsForAnimationId(_ identifier: String){
        if identifier == "Untitled1"{
            (layers["progress"] as! CALayer).removeAnimation(forKey: "progressUntitled1Anim")
        }
    }
    
    func removeAllAnimations(){
        for layer in layers.values{
            (layer as! CALayer).removeAllAnimations()
        }
    }
    
    //MARK: - Bezier Path
    
    func progressbackPathWithBounds(_ bounds: CGRect) -> UIBezierPath{
        let progressbackPath = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        progressbackPath.move(to: CGPoint(x: minX, y: minY + 0 * h))
        progressbackPath.addCurve(to: CGPoint(x: minX + w, y: minY + 0 * h), controlPoint1:CGPoint(x: minX + 0.33333 * w, y: minY + 0 * h), controlPoint2:CGPoint(x: minX + 0.66667 * w, y: minY + 0 * h))
        
        return progressbackPath
    }
    
    func progressPathWithBounds(_ bounds: CGRect) -> UIBezierPath{
        let progressPath = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        progressPath.move(to: CGPoint(x: minX, y: minY + 0 * h))
        progressPath.addCurve(to: CGPoint(x: minX + w, y: minY + 0 * h), controlPoint1:CGPoint(x: minX + 0.33333 * w, y: minY + 0 * h), controlPoint2:CGPoint(x: minX + 0.66667 * w, y: minY + 0 * h))
        
        return progressPath
    }
    
    
}
