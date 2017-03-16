//
//  dashboardview.swift
//
//  Code generated using QuartzCode 1.52.0 on 19/01/17.
//  www.quartzcodeapp.com
//

import UIKit


class dashboardview: UIView {
    
    var layers : Dictionary<String, AnyObject> = [:]
    
    var energyscorevalue = 0, waterscorevalue = 0, wastescorevalue = 0, transportscorevalue = 0, humanscorevalue = 0
    var energymaxscorevalue = 0, watermaxscorevalue = 0, wastemaxscorevalue = 0, transportmaxscorevalue = 0, humanmaxscorevalue = 0, basescorevalue = 0
    
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
        
        if let blank : CALayer = layers["blank"] as? CALayer{
            blank.frame = CGRectMake(0.39726 * blank.superlayer!.bounds.width, 0.38641 * blank.superlayer!.bounds.height, 0.24304 * blank.superlayer!.bounds.width, 0.24742 * blank.superlayer!.bounds.height)
        }
        
        if let humanback : CAShapeLayer = layers["humanback"] as? CAShapeLayer{
            humanback.frame = CGRectMake(0.00211 * humanback.superlayer!.bounds.width, 0.33743 * humanback.superlayer!.bounds.height, 0.68679 * humanback.superlayer!.bounds.width, 0.34587 * humanback.superlayer!.bounds.height)
            humanback.path  = humanbackPathWithBounds((layers["humanback"] as! CAShapeLayer).bounds).CGPath
            humanback.lineWidth = (0.127 * self.frame.size.width)/3
        }
        
        if let transportback : CAShapeLayer = layers["transportback"] as? CAShapeLayer{
            transportback.frame = CGRectMake(0.00201 * transportback.superlayer!.bounds.width, 0.25775 * transportback.superlayer!.bounds.height, 0.76467 * transportback.superlayer!.bounds.width, 0.50473 * transportback.superlayer!.bounds.height)
            transportback.path  = transportbackPathWithBounds((layers["transportback"] as! CAShapeLayer).bounds).CGPath
            transportback.lineWidth = (0.127 * self.frame.size.width)/3
        }
        
        if let wasteback : CAShapeLayer = layers["wasteback"] as? CAShapeLayer{
            wasteback.frame = CGRectMake(0, 0.17654 * wasteback.superlayer!.bounds.height, 0.84445 * wasteback.superlayer!.bounds.width, 0.66511 * wasteback.superlayer!.bounds.height)
            wasteback.path  = wastebackPathWithBounds((layers["wasteback"] as! CAShapeLayer).bounds).CGPath
            wasteback.lineWidth = (0.127 * self.frame.size.width)/3
        }
        
        if let waterback : CAShapeLayer = layers["waterback"] as? CAShapeLayer{
            waterback.frame = CGRectMake(0.00177 * waterback.superlayer!.bounds.width, 0.09941 * waterback.superlayer!.bounds.height, 0.92045 * waterback.superlayer!.bounds.width, 0.82142 * waterback.superlayer!.bounds.height)
            waterback.path  = waterbackPathWithBounds((layers["waterback"] as! CAShapeLayer).bounds).CGPath
            waterback.lineWidth = (0.127 * self.frame.size.width)/3
        }
        
        if let energyback : CAShapeLayer = layers["energyback"] as? CAShapeLayer{
            energyback.frame = CGRectMake(0.00194 * energyback.superlayer!.bounds.width, 0.0207 * energyback.superlayer!.bounds.height, 0.99806 * energyback.superlayer!.bounds.width, 0.9793 * energyback.superlayer!.bounds.height)
            energyback.path  = energybackPathWithBounds((layers["energyback"] as! CAShapeLayer).bounds).CGPath
            energyback.lineWidth = (0.127 * self.frame.size.width)/3
        }
        
        if let humanstart : CAShapeLayer = layers["humanstart"] as? CAShapeLayer{
            humanstart.frame = CGRectMake(0.00211 * humanstart.superlayer!.bounds.width, 0.33743 * humanstart.superlayer!.bounds.height, 0.68679 * humanstart.superlayer!.bounds.width, 0.34587 * humanstart.superlayer!.bounds.height)
            humanstart.path  = humanstartPathWithBounds((layers["humanstart"] as! CAShapeLayer).bounds).CGPath
            humanstart.lineWidth = (0.127 * self.frame.size.width)/3
            if(humanscorevalue  == 0){
                humanstart.hidden = true
            }else{
                humanstart.hidden = false
            }
        }
        
        if let transportstart : CAShapeLayer = layers["transportstart"] as? CAShapeLayer{
            transportstart.frame = CGRectMake(0.00201 * transportstart.superlayer!.bounds.width, 0.25775 * transportstart.superlayer!.bounds.height, 0.76467 * transportstart.superlayer!.bounds.width, 0.50473 * transportstart.superlayer!.bounds.height)
            transportstart.path  = transportstartPathWithBounds((layers["transportstart"] as! CAShapeLayer).bounds).CGPath
            transportstart.lineWidth = (0.127 * self.frame.size.width)/3
            if(transportscorevalue == 0){
                transportstart.hidden = true
            }else{
                transportstart.hidden = false
            }
        }
        
        if let wastestart : CAShapeLayer = layers["wastestart"] as? CAShapeLayer{
            wastestart.frame = CGRectMake(0, 0.17654 * wastestart.superlayer!.bounds.height, 0.84445 * wastestart.superlayer!.bounds.width, 0.66511 * wastestart.superlayer!.bounds.height)
            wastestart.path  = wastestartPathWithBounds((layers["wastestart"] as! CAShapeLayer).bounds).CGPath
            wastestart.lineWidth = (0.127 * self.frame.size.width)/3
            if(wastescorevalue  == 0){
                wastestart.hidden = true
            }else{
                wastestart.hidden = false
            }
        }
        
        if let waterstart : CAShapeLayer = layers["waterstart"] as? CAShapeLayer{
            waterstart.frame = CGRectMake(0.00177 * waterstart.superlayer!.bounds.width, 0.09941 * waterstart.superlayer!.bounds.height, 0.92045 * waterstart.superlayer!.bounds.width, 0.82142 * waterstart.superlayer!.bounds.height)
            waterstart.path  = waterstartPathWithBounds((layers["waterstart"] as! CAShapeLayer).bounds).CGPath
            waterstart.lineWidth = (0.127 * self.frame.size.width)/3
            if(waterscorevalue  == 0){
                waterstart.hidden = true
            }else{
                waterstart.hidden = false
            }
        }
        
        if let energystart : CAShapeLayer = layers["energystart"] as? CAShapeLayer{
            energystart.frame = CGRectMake(0.00194 * energystart.superlayer!.bounds.width, 0.0207 * energystart.superlayer!.bounds.height, 0.99806 * energystart.superlayer!.bounds.width, 0.9793 * energystart.superlayer!.bounds.height)
            energystart.path  = energystartPathWithBounds((layers["energystart"] as! CAShapeLayer).bounds).CGPath
            energystart.lineWidth = (0.127 * self.frame.size.width)/3
            if(energyscorevalue  == 0){
                energystart.hidden = true
            }else{
                energystart.hidden = false
            }
        }
        
        if let humanlabel : CATextLayer = layers["humanlabel"] as? CATextLayer{
            humanlabel.frame = CGRectMake(0.05754 * humanlabel.superlayer!.bounds.width, 0.32237 * humanlabel.superlayer!.bounds.height, 0.3996 * humanlabel.superlayer!.bounds.width, 0.04701 * humanlabel.superlayer!.bounds.height)
            humanlabel.fontSize = (0.25 * humanlabel.superlayer!.bounds.height)/10
        }
        
        if let transportlabel : CATextLayer = layers["transportlabel"] as? CATextLayer{
            transportlabel.frame = CGRectMake(0.05754 * transportlabel.superlayer!.bounds.width, 0.2432 * transportlabel.superlayer!.bounds.height, 0.3996 * transportlabel.superlayer!.bounds.width, 0.04701 * transportlabel.superlayer!.bounds.height)
            transportlabel.fontSize = (0.25 * transportlabel.superlayer!.bounds.height)/10
        }
        
        if let wastelabel : CATextLayer = layers["wastelabel"] as? CATextLayer{
            wastelabel.frame = CGRectMake(0.05754 * wastelabel.superlayer!.bounds.width, 0.16402 * wastelabel.superlayer!.bounds.height, 0.3996 * wastelabel.superlayer!.bounds.width, 0.04701 * wastelabel.superlayer!.bounds.height)
            wastelabel.fontSize = (0.25 * wastelabel.superlayer!.bounds.height)/10
        }
        
        if let waterlabel : CATextLayer = layers["waterlabel"] as? CATextLayer{
            waterlabel.frame = CGRectMake(0.05754 * waterlabel.superlayer!.bounds.width, 0.08515 * waterlabel.superlayer!.bounds.height, 0.3996 * waterlabel.superlayer!.bounds.width, 0.04701 * waterlabel.superlayer!.bounds.height)
            waterlabel.fontSize = (0.25 * waterlabel.superlayer!.bounds.height)/10
        }
        
        if let energylabel : CATextLayer = layers["energylabel"] as? CATextLayer{
            energylabel.frame = CGRectMake(0.05754 * energylabel.superlayer!.bounds.width, 0.00468 * energylabel.superlayer!.bounds.height, 0.3996 * energylabel.superlayer!.bounds.width, 0.04701 * energylabel.superlayer!.bounds.height)
            energylabel.fontSize = (0.25 * energylabel.superlayer!.bounds.height)/10
        }
        
        if let energy : CALayer = layers["energy"] as? CALayer{
            energy.frame = CGRectMake(0.01811 * energy.superlayer!.bounds.width, 0, 0.02916 * energy.superlayer!.bounds.width, 0.05037 * energy.superlayer!.bounds.height)
        }
        
        if let water : CALayer = layers["water"] as? CALayer{
            water.frame = CGRectMake(0.02054 * water.superlayer!.bounds.width, 0.07742 * water.superlayer!.bounds.height, 0.0243 * water.superlayer!.bounds.width, 0.04398 * water.superlayer!.bounds.height)
        }
        
        if let waste : CALayer = layers["waste"] as? CALayer{
            waste.frame = CGRectMake(0.01136 * waste.superlayer!.bounds.width, 0.15938 * waste.superlayer!.bounds.height, 0.03889 * waste.superlayer!.bounds.width, 0.0384 * waste.superlayer!.bounds.height)
        }
        
        if let transport : CALayer = layers["transport"] as? CALayer{
            transport.frame = CGRectMake(0.01082 * transport.superlayer!.bounds.width, 0.24424 * transport.superlayer!.bounds.height, 0.03889 * transport.superlayer!.bounds.width, 0.03292 * transport.superlayer!.bounds.height)
        }
        
        if let human : CALayer = layers["human"] as? CALayer{
            human.frame = CGRectMake(0.02297 * human.superlayer!.bounds.width, 0.31533 * human.superlayer!.bounds.height, 0.01944 * human.superlayer!.bounds.width, 0.04319 * human.superlayer!.bounds.height)
        }
        
        if let humanmaxscore : CATextLayer = layers["humanmaxscore"] as? CATextLayer{
            humanmaxscore.frame = CGRectMake(0.32921 * humanmaxscore.superlayer!.bounds.width, 0.40125 * humanmaxscore.superlayer!.bounds.height, 0.03959 * humanmaxscore.superlayer!.bounds.height, 0.03959 * humanmaxscore.superlayer!.bounds.height)
            humanmaxscore.fontSize = (0.77 * humanmaxscore.bounds.width)
            humanmaxscore.string = "\(humanmaxscorevalue)"
        }
        
        if let transportmaxscore : CATextLayer = layers["transportmaxscore"] as? CATextLayer{
            transportmaxscore.frame = CGRectMake(0.25143 * transportmaxscore.superlayer!.bounds.width, 0.40125 * transportmaxscore.superlayer!.bounds.height, 0.03959 * transportmaxscore.superlayer!.bounds.height, 0.03959 * transportmaxscore.superlayer!.bounds.height)
            transportmaxscore.fontSize = (0.77 * transportmaxscore.bounds.width)
            transportmaxscore.string = "\(transportmaxscorevalue)"
        }
        
        if let wastemaxscore : CATextLayer = layers["wastemaxscore"] as? CATextLayer{
            wastemaxscore.frame = CGRectMake(0.17366 * wastemaxscore.superlayer!.bounds.width, 0.40125 * wastemaxscore.superlayer!.bounds.height, 0.03959 * wastemaxscore.superlayer!.bounds.height, 0.03959 * wastemaxscore.superlayer!.bounds.height)
            wastemaxscore.fontSize = (0.77 * wastemaxscore.bounds.width)
            wastemaxscore.string = "\(wastemaxscorevalue)"
        }
        
        if let watermaxscore : CATextLayer = layers["watermaxscore"] as? CATextLayer{
            watermaxscore.frame = CGRectMake(0.09346 * watermaxscore.superlayer!.bounds.width, 0.40125 * watermaxscore.superlayer!.bounds.height, 0.03959 * watermaxscore.superlayer!.bounds.height, 0.03959 * watermaxscore.superlayer!.bounds.height)
            watermaxscore.fontSize = (0.77 * watermaxscore.bounds.width)
            watermaxscore.string = "\(watermaxscorevalue)"
        }
        
        if let energymaxscore : CATextLayer = layers["energymaxscore"] as? CATextLayer{
            energymaxscore.frame = CGRectMake(0.01811 * energymaxscore.superlayer!.bounds.width, 0.40125 * energymaxscore.superlayer!.bounds.height, 0.03959 * energymaxscore.superlayer!.bounds.height, 0.03959 * energymaxscore.superlayer!.bounds.height)
            energymaxscore.fontSize = (0.77 * energymaxscore.bounds.width)
            energymaxscore.string = "\(energymaxscorevalue)"
        }
        
        if let energystarting : CAShapeLayer = layers["energystarting"] as? CAShapeLayer{
            energystarting.frame = CGRectMake(0.03756 * energystarting.superlayer!.bounds.width, 0.02024 * energystarting.superlayer!.bounds.height, 0.96244 * energystarting.superlayer!.bounds.width, 0.97976 * energystarting.superlayer!.bounds.height)
            energystarting.path  = energystartingPathWithBounds((layers["energystarting"] as! CAShapeLayer).bounds).CGPath
            energystarting.lineWidth = (0.127 * self.frame.size.width)/3
            if(energyscorevalue  == 0){
                energystarting.hidden = true
            }else{
                energystarting.hidden = false
            }
        }
        
        if let waterstarting : CAShapeLayer = layers["waterstarting"] as? CAShapeLayer{
            waterstarting.frame = CGRectMake(0.11533 * waterstarting.superlayer!.bounds.width, 0.09941 * waterstarting.superlayer!.bounds.height, 0.8069 * waterstarting.superlayer!.bounds.width, 0.82142 * waterstarting.superlayer!.bounds.height)
            waterstarting.path  = waterstartingPathWithBounds((layers["waterstarting"] as! CAShapeLayer).bounds).CGPath
            waterstarting.lineWidth = (0.127 * self.frame.size.width)/3
            if(waterscorevalue  == 0){
                waterstarting.hidden = true
            }else{
                waterstarting.hidden = false
            }
        }
        
        if let wastestarting : CAShapeLayer = layers["wastestarting"] as? CAShapeLayer{
            wastestarting.frame = CGRectMake(0.1931 * wastestarting.superlayer!.bounds.width, 0.17858 * wastestarting.superlayer!.bounds.height, 0.65135 * wastestarting.superlayer!.bounds.width, 0.66307 * wastestarting.superlayer!.bounds.height)
            wastestarting.path  = wastestartingPathWithBounds((layers["wastestarting"] as! CAShapeLayer).bounds).CGPath
            wastestarting.lineWidth = (0.127 * self.frame.size.width)/3
            if(wastescorevalue  == 0){
                wastestarting.hidden = true
            }else{
                wastestarting.hidden = false
            }
        }
        
        if let transportstarting : CAShapeLayer = layers["transportstarting"] as? CAShapeLayer{
            transportstarting.frame = CGRectMake(0.27088 * transportstarting.superlayer!.bounds.width, 0.25775 * transportstarting.superlayer!.bounds.height, 0.4958 * transportstarting.superlayer!.bounds.width, 0.50473 * transportstarting.superlayer!.bounds.height)
            transportstarting.path  = transportstartingPathWithBounds((layers["transportstarting"] as! CAShapeLayer).bounds).CGPath
            transportstarting.lineWidth = (0.127 * self.frame.size.width)/3
            if(transportscorevalue == 0){
                transportstarting.hidden = true
            }else{
                transportstarting.hidden = false
            }
        }
        
        if let humanstarting : CAShapeLayer = layers["humanstarting"] as? CAShapeLayer{
            humanstarting.frame = CGRectMake(0.34865 * humanstarting.superlayer!.bounds.width, 0.33693 * humanstarting.superlayer!.bounds.height, 0.34026 * humanstarting.superlayer!.bounds.width, 0.34638 * humanstarting.superlayer!.bounds.height)
            humanstarting.path  = humanstartingPathWithBounds((layers["humanstarting"] as! CAShapeLayer).bounds).CGPath
            humanstarting.lineWidth = (0.127 * self.frame.size.width)/3
            if(humanscorevalue  == 0){
                humanstarting.hidden = true
            }else{
                humanstarting.hidden = false
            }
        }
        
        if let humanstartingpath : CAShapeLayer = layers["humanstartingpath"] as? CAShapeLayer{
            humanstartingpath.frame = CGRectMake(0.34865 * humanstartingpath.superlayer!.bounds.width, 0.33693 * humanstartingpath.superlayer!.bounds.height, 0.34026 * humanstartingpath.superlayer!.bounds.width, 0.34638 * humanstartingpath.superlayer!.bounds.height)
            humanstartingpath.path  = humanstartingpathPathWithBounds((layers["humanstartingpath"] as! CAShapeLayer).bounds).CGPath
        }
        
        if let humanarrow : CAShapeLayer = layers["humanarrow"] as? CAShapeLayer{
            humanarrow.transform = CATransform3DIdentity
            humanarrow.frame     = CGRectMake(0.49691 * humanarrow.superlayer!.bounds.width, 0.31713 * humanarrow.superlayer!.bounds.height, 0.04375 * humanarrow.superlayer!.bounds.width, 0.04453 * humanarrow.superlayer!.bounds.height)
            humanarrow.setValue(-225 * CGFloat(M_PI)/180, forKeyPath:"transform.rotation")
            humanarrow.path      = humanarrowPathWithBounds((layers["humanarrow"] as! CAShapeLayer).bounds).CGPath
            if(humanscorevalue  == 0){
                humanarrow.hidden = true
            }else{
                humanarrow.hidden = false
            }
        }
        
        if let humanscore : CATextLayer = layers["humanscore"] as? CATextLayer{
            humanscore.frame = CGRectMake(0.48153 * humanscore.superlayer!.bounds.width, 0.31022 * humanscore.superlayer!.bounds.height, 0.03889 * humanscore.superlayer!.bounds.width, 0.03089 * humanscore.superlayer!.bounds.width)
            humanscore.fontSize = (0.77 * humanscore.bounds.width)
            humanscore.string = "\(humanscorevalue)"
            if(humanscorevalue  == 0){
                humanscore.hidden = true
            }else{
                humanscore.hidden = false
            }
        }
        
        if let transportstartingpath : CAShapeLayer = layers["transportstartingpath"] as? CAShapeLayer{
            transportstartingpath.frame = CGRectMake(0.27088 * transportstartingpath.superlayer!.bounds.width, 0.25775 * transportstartingpath.superlayer!.bounds.height, 0.4958 * transportstartingpath.superlayer!.bounds.width, 0.50473 * transportstartingpath.superlayer!.bounds.height)
            transportstartingpath.path  = transportstartingpathPathWithBounds((layers["transportstartingpath"] as! CAShapeLayer).bounds).CGPath
        }
        
        if let transportarrow : CAShapeLayer = layers["transportarrow"] as? CAShapeLayer{
            transportarrow.transform = CATransform3DIdentity
            transportarrow.frame     = CGRectMake(0.49691 * transportarrow.superlayer!.bounds.width, 0.31713 * transportarrow.superlayer!.bounds.height, 0.04375 * transportarrow.superlayer!.bounds.width, 0.04453 * transportarrow.superlayer!.bounds.height)
            transportarrow.setValue(-225 * CGFloat(M_PI)/180, forKeyPath:"transform.rotation")
            transportarrow.path      = transportarrowPathWithBounds((layers["transportarrow"] as! CAShapeLayer).bounds).CGPath
            if(transportscorevalue == 0){
                transportarrow.hidden = true
            }else{
                transportarrow.hidden = false
            }
        }
        
        if let transportscore : CATextLayer = layers["transportscore"] as? CATextLayer{
            transportscore.frame = CGRectMake(0.48153 * transportscore.superlayer!.bounds.width, 0.31022 * transportscore.superlayer!.bounds.height, 0.03889 * transportscore.superlayer!.bounds.width, 0.03089 * transportscore.superlayer!.bounds.width)
            transportscore.fontSize = (0.77 * transportscore.bounds.width)
            transportscore.string = "12"
            transportscore.string = "\(transportscorevalue)"
            if(transportscorevalue == 0){
                transportscore.hidden = true
            }else{
                transportscore.hidden = false
            }
        }
        
        if let wastestartingpath : CAShapeLayer = layers["wastestartingpath"] as? CAShapeLayer{
            wastestartingpath.frame = CGRectMake(0.1931 * wastestartingpath.superlayer!.bounds.width, 0.17858 * wastestartingpath.superlayer!.bounds.height, 0.65135 * wastestartingpath.superlayer!.bounds.width, 0.66307 * wastestartingpath.superlayer!.bounds.height)
            wastestartingpath.path  = wastestartingpathPathWithBounds((layers["wastestartingpath"] as! CAShapeLayer).bounds).CGPath
        }
        
        if let wastearrow : CAShapeLayer = layers["wastearrow"] as? CAShapeLayer{
            wastearrow.transform = CATransform3DIdentity
            wastearrow.frame     = CGRectMake(0.49691 * wastearrow.superlayer!.bounds.width, 0.31713 * wastearrow.superlayer!.bounds.height, 0.04375 * wastearrow.superlayer!.bounds.width, 0.04453 * wastearrow.superlayer!.bounds.height)
            wastearrow.setValue(-225 * CGFloat(M_PI)/180, forKeyPath:"transform.rotation")
            wastearrow.path      = wastearrowPathWithBounds((layers["wastearrow"] as! CAShapeLayer).bounds).CGPath
            if(wastescorevalue  == 0){
                wastearrow.hidden = true
            }else{
                wastearrow.hidden = false
            }
        }
        
        if let wastescore : CATextLayer = layers["wastescore"] as? CATextLayer{
            wastescore.frame = CGRectMake(0.48153 * wastescore.superlayer!.bounds.width, 0.31022 * wastescore.superlayer!.bounds.height, 0.03959 * wastescore.superlayer!.bounds.height, 0.03159 * wastescore.superlayer!.bounds.height)
            wastescore.fontSize = (0.77 * wastescore.bounds.width)
            wastescore.string = "\(wastescorevalue)"
            if(wastescorevalue  == 0){
                wastescore.hidden = true
            }else{
                wastescore.hidden = false
            }
        }
        
        if let waterstartingpath : CAShapeLayer = layers["waterstartingpath"] as? CAShapeLayer{
            waterstartingpath.frame = CGRectMake(0.11533 * waterstartingpath.superlayer!.bounds.width, 0.09941 * waterstartingpath.superlayer!.bounds.height, 0.8069 * waterstartingpath.superlayer!.bounds.width, 0.82142 * waterstartingpath.superlayer!.bounds.height)
            waterstartingpath.path  = waterstartingpathPathWithBounds((layers["waterstartingpath"] as! CAShapeLayer).bounds).CGPath
        }
        
        if let waterarrow : CAShapeLayer = layers["waterarrow"] as? CAShapeLayer{
            waterarrow.transform = CATransform3DIdentity
            waterarrow.frame     = CGRectMake(0.49691 * waterarrow.superlayer!.bounds.width, 0.31713 * waterarrow.superlayer!.bounds.height, 0.04375 * waterarrow.superlayer!.bounds.width, 0.04453 * waterarrow.superlayer!.bounds.height)
            waterarrow.setValue(-225 * CGFloat(M_PI)/180, forKeyPath:"transform.rotation")
            waterarrow.path      = waterarrowPathWithBounds((layers["waterarrow"] as! CAShapeLayer).bounds).CGPath
            if(waterscorevalue  == 0){
                waterarrow.hidden = true
            }else{
                waterarrow.hidden = false
            }
        }
        
        if let waterscore : CATextLayer = layers["waterscore"] as? CATextLayer{
            waterscore.frame = CGRectMake(0.48153 * waterscore.superlayer!.bounds.width, 0.31022 * waterscore.superlayer!.bounds.height, 0.03959 * waterscore.superlayer!.bounds.height, 0.03159 * waterscore.superlayer!.bounds.height)
            waterscore.fontSize = (0.77 * waterscore.bounds.width)
            print(0.76 * waterscore.bounds.height)
            waterscore.string = "\(waterscorevalue)"
            if(waterscorevalue  == 0){
                waterscore.hidden = true
            }else{
                waterscore.hidden = false
            }
        }
        
        if let energystartingpath : CAShapeLayer = layers["energystartingpath"] as? CAShapeLayer{
            energystartingpath.frame = CGRectMake(0.03756 * energystartingpath.superlayer!.bounds.width, 0.02024 * energystartingpath.superlayer!.bounds.height, 0.96244 * energystartingpath.superlayer!.bounds.width, 0.97976 * energystartingpath.superlayer!.bounds.height)
            energystartingpath.path  = energystartingpathPathWithBounds((layers["energystartingpath"] as! CAShapeLayer).bounds).CGPath
        }
        
        if let energyarrow : CAShapeLayer = layers["energyarrow"] as? CAShapeLayer{
            energyarrow.transform = CATransform3DIdentity
            energyarrow.frame     = CGRectMake(0.49691 * energyarrow.superlayer!.bounds.width, 0.31713 * energyarrow.superlayer!.bounds.height, 0.04375 * energyarrow.superlayer!.bounds.width, 0.04453 * energyarrow.superlayer!.bounds.height)
            energyarrow.setValue(-225 * CGFloat(M_PI)/180, forKeyPath:"transform.rotation")
            energyarrow.path      = energyarrowPathWithBounds((layers["energyarrow"] as! CAShapeLayer).bounds).CGPath
            if(energyscorevalue  == 0){
                energyarrow.hidden = true
            }else{
                energyarrow.hidden = false
            }
        }
        
        if let energyscore : CATextLayer = layers["energyscore"] as? CATextLayer{
            energyscore.frame = CGRectMake(0.48153 * energyscore.superlayer!.bounds.width, 0.31022 * energyscore.superlayer!.bounds.height, 0.03959 * energyscore.superlayer!.bounds.height, 0.03159 * energyscore.superlayer!.bounds.height)
            energyscore.fontSize = (0.77 * energyscore.bounds.width)
                //(0.25 * energyscore.superlayer!.bounds.height)/10
            energyscore.string = "\(energyscorevalue)"
            if(energyscorevalue  == 0){
                energyscore.hidden = true
            }else{
                energyscore.hidden = false
            }
        }
        
        if let puckscore : CATextLayer = layers["puckscore"] as? CATextLayer{
            puckscore.frame = CGRectMake(0.47017 * puckscore.superlayer!.bounds.width, 0.44826 * puckscore.superlayer!.bounds.height, 0.09722 * puckscore.superlayer!.bounds.width, 0.09897 * puckscore.superlayer!.bounds.height)
            puckscore.fontSize = (0.2 * puckscore.superlayer!.bounds.height)/2.5
            puckscore.string = "\(energyscorevalue + waterscorevalue + wastescorevalue + basescorevalue + transportscorevalue + humanscorevalue)"
        }
    }
    
    func setupLayers(){
        let Group = CALayer()
        self.layer.addSublayer(Group)
        
        layers["Group"] = Group
        let blank = CALayer()
        Group.addSublayer(blank)
        blank.contents = UIImage(named:"blank")?.CGImage
        layers["blank"] = blank
        let humanback = CAShapeLayer()
        Group.addSublayer(humanback)
        humanback.fillColor   = nil
        humanback.strokeColor = UIColor(red:0.835, green: 0.835, blue:0.835, alpha:1).CGColor
        humanback.lineWidth   = 13
        layers["humanback"] = humanback
        let transportback = CAShapeLayer()
        Group.addSublayer(transportback)
        transportback.fillColor   = nil
        transportback.strokeColor = UIColor(red:0.835, green: 0.835, blue:0.835, alpha:1).CGColor
        transportback.lineWidth   = 13
        layers["transportback"] = transportback
        let wasteback = CAShapeLayer()
        Group.addSublayer(wasteback)
        wasteback.fillColor   = nil
        wasteback.strokeColor = UIColor(red:0.835, green: 0.835, blue:0.835, alpha:1).CGColor
        wasteback.lineWidth   = 13
        layers["wasteback"] = wasteback
        let waterback = CAShapeLayer()
        Group.addSublayer(waterback)
        waterback.fillColor   = nil
        waterback.strokeColor = UIColor(red:0.835, green: 0.835, blue:0.835, alpha:1).CGColor
        waterback.lineWidth   = 13
        layers["waterback"] = waterback
        let energyback = CAShapeLayer()
        Group.addSublayer(energyback)
        energyback.fillColor   = nil
        energyback.strokeColor = UIColor(red:0.835, green: 0.835, blue:0.835, alpha:1).CGColor
        energyback.lineWidth   = 13
        layers["energyback"] = energyback
        let humanstart = CAShapeLayer()
        Group.addSublayer(humanstart)
        humanstart.fillColor   = nil
        humanstart.strokeColor = UIColor(red:0.909, green: 0.602, blue:0.268, alpha:1).CGColor
        humanstart.lineWidth   = 13
        humanstart.strokeEnd   = 0.35
        layers["humanstart"] = humanstart
        let transportstart = CAShapeLayer()
        Group.addSublayer(transportstart)
        transportstart.fillColor   = nil
        transportstart.strokeColor = UIColor(red:0.573, green: 0.557, blue:0.498, alpha:1).CGColor
        transportstart.lineWidth   = 13
        transportstart.strokeEnd   = 0.268
        layers["transportstart"] = transportstart
        let wastestart = CAShapeLayer()
        Group.addSublayer(wastestart)
        wastestart.fillColor   = nil
        wastestart.strokeColor = UIColor(red:0.465, green: 0.756, blue:0.629, alpha:1).CGColor
        wastestart.lineWidth   = 13
        wastestart.strokeEnd   = 0.225
        layers["wastestart"] = wastestart
        let waterstart = CAShapeLayer()
        Group.addSublayer(waterstart)
        waterstart.fillColor   = nil
        waterstart.strokeColor = UIColor(red:0.323, green: 0.755, blue:0.93, alpha:1).CGColor
        waterstart.lineWidth   = 13
        waterstart.strokeEnd   = 0.19
        layers["waterstart"] = waterstart
        let energystart = CAShapeLayer()
        Group.addSublayer(energystart)
        energystart.fillColor   = nil
        energystart.strokeColor = UIColor(red:0.776, green: 0.858, blue:0.124, alpha:1).CGColor
        energystart.lineWidth   = 13
        energystart.strokeEnd   = 0.166
        layers["energystart"] = energystart
        let humanlabel = CATextLayer()
        Group.addSublayer(humanlabel)
        humanlabel.contentsScale   = UIScreen.mainScreen().scale
        humanlabel.string          = "HUMAN EXPERIENCE"
        humanlabel.font            = "GothamBook"
        humanlabel.fontSize        = 7
        humanlabel.alignmentMode   = kCAAlignmentLeft;
        humanlabel.foregroundColor = UIColor.blackColor().CGColor;
        layers["humanlabel"] = humanlabel
        let transportlabel = CATextLayer()
        Group.addSublayer(transportlabel)
        transportlabel.contentsScale   = UIScreen.mainScreen().scale
        transportlabel.string          = "TRANSPORTATION"
        transportlabel.font            = "GothamBook"
        transportlabel.fontSize        = 7
        transportlabel.alignmentMode   = kCAAlignmentLeft;
        transportlabel.foregroundColor = UIColor.blackColor().CGColor;
        layers["transportlabel"] = transportlabel
        let wastelabel = CATextLayer()
        Group.addSublayer(wastelabel)
        wastelabel.contentsScale   = UIScreen.mainScreen().scale
        wastelabel.string          = "WASTE"
        wastelabel.font            = "GothamBook"
        wastelabel.fontSize        = 7
        wastelabel.alignmentMode   = kCAAlignmentLeft;
        wastelabel.foregroundColor = UIColor.blackColor().CGColor;
        layers["wastelabel"] = wastelabel
        let waterlabel = CATextLayer()
        Group.addSublayer(waterlabel)
        waterlabel.contentsScale   = UIScreen.mainScreen().scale
        waterlabel.string          = "WATER"
        waterlabel.font            = "GothamBook"
        waterlabel.fontSize        = 7
        waterlabel.alignmentMode   = kCAAlignmentLeft;
        waterlabel.foregroundColor = UIColor.blackColor().CGColor;
        layers["waterlabel"] = waterlabel
        let energylabel = CATextLayer()
        Group.addSublayer(energylabel)
        energylabel.contentsScale   = UIScreen.mainScreen().scale
        energylabel.string          = "ENERGY"
        energylabel.font            = "GothamBook"
        energylabel.fontSize        = 7
        energylabel.alignmentMode   = kCAAlignmentLeft;
        energylabel.foregroundColor = UIColor.blackColor().CGColor;
        layers["energylabel"] = energylabel
        let energy = CALayer()
        Group.addSublayer(energy)
        energy.contents = UIImage(named:"energy")?.CGImage
        layers["energy"] = energy
        let water = CALayer()
        Group.addSublayer(water)
        water.contents = UIImage(named:"water")?.CGImage
        layers["water"] = water
        let waste = CALayer()
        Group.addSublayer(waste)
        waste.contents = UIImage(named:"waste")?.CGImage
        layers["waste"] = waste
        let transport = CALayer()
        Group.addSublayer(transport)
        transport.contents = UIImage(named:"transport")?.CGImage
        layers["transport"] = transport
        let human = CALayer()
        Group.addSublayer(human)
        human.contents = UIImage(named:"human")?.CGImage
        layers["human"] = human
        let humanmaxscore = CATextLayer()
        Group.addSublayer(humanmaxscore)
        humanmaxscore.contentsScale   = UIScreen.mainScreen().scale
        humanmaxscore.string          = "99"
        humanmaxscore.font            = "GothamBook"
        humanmaxscore.fontSize        = 8
        humanmaxscore.alignmentMode   = kCAAlignmentCenter;
        humanmaxscore.foregroundColor = UIColor.blackColor().CGColor;
        humanmaxscore.wrapped         = true
        layers["humanmaxscore"] = humanmaxscore
        let transportmaxscore = CATextLayer()
        Group.addSublayer(transportmaxscore)
        transportmaxscore.contentsScale   = UIScreen.mainScreen().scale
        transportmaxscore.string          = "99"
        transportmaxscore.font            = "GothamBook"
        transportmaxscore.fontSize        = 8
        transportmaxscore.alignmentMode   = kCAAlignmentCenter;
        transportmaxscore.foregroundColor = UIColor.blackColor().CGColor;
        transportmaxscore.wrapped         = true
        layers["transportmaxscore"] = transportmaxscore
        let wastemaxscore = CATextLayer()
        Group.addSublayer(wastemaxscore)
        wastemaxscore.contentsScale   = UIScreen.mainScreen().scale
        wastemaxscore.string          = "99"
        wastemaxscore.font            = "GothamBook"
        wastemaxscore.fontSize        = 8
        wastemaxscore.alignmentMode   = kCAAlignmentCenter;
        wastemaxscore.foregroundColor = UIColor.blackColor().CGColor;
        wastemaxscore.wrapped         = true
        layers["wastemaxscore"] = wastemaxscore
        let watermaxscore = CATextLayer()
        Group.addSublayer(watermaxscore)
        watermaxscore.contentsScale   = UIScreen.mainScreen().scale
        watermaxscore.string          = "99"
        watermaxscore.font            = "GothamBook"
        watermaxscore.fontSize        = 8
        watermaxscore.alignmentMode   = kCAAlignmentCenter;
        watermaxscore.foregroundColor = UIColor.blackColor().CGColor;
        watermaxscore.wrapped         = true
        layers["watermaxscore"] = watermaxscore
        let energymaxscore = CATextLayer()
        Group.addSublayer(energymaxscore)
        energymaxscore.contentsScale   = UIScreen.mainScreen().scale
        energymaxscore.string          = "99"
        energymaxscore.font            = "GothamBook"
        energymaxscore.fontSize        = 8
        energymaxscore.alignmentMode   = kCAAlignmentCenter;
        energymaxscore.foregroundColor = UIColor.blackColor().CGColor;
        energymaxscore.wrapped         = true
        layers["energymaxscore"] = energymaxscore
        let energystarting = CAShapeLayer()
        Group.addSublayer(energystarting)
        energystarting.fillColor   = nil
        energystarting.strokeColor = UIColor(red:0.776, green: 0.858, blue:0.124, alpha:1).CGColor
        energystarting.lineWidth   = 13
        energystarting.strokeEnd   = 0.1
        layers["energystarting"] = energystarting
        let waterstarting = CAShapeLayer()
        Group.addSublayer(waterstarting)
        waterstarting.fillColor   = nil
        waterstarting.strokeColor = UIColor(red:0.323, green: 0.755, blue:0.93, alpha:1).CGColor
        waterstarting.lineWidth   = 13
        waterstarting.strokeEnd   = 0.1
        layers["waterstarting"] = waterstarting
        let wastestarting = CAShapeLayer()
        Group.addSublayer(wastestarting)
        wastestarting.fillColor   = nil
        wastestarting.strokeColor = UIColor(red:0.465, green: 0.756, blue:0.629, alpha:1).CGColor
        wastestarting.lineWidth   = 13
        wastestarting.strokeEnd   = 0.1
        layers["wastestarting"] = wastestarting
        let transportstarting = CAShapeLayer()
        Group.addSublayer(transportstarting)
        transportstarting.fillColor   = nil
        transportstarting.strokeColor = UIColor(red:0.573, green: 0.557, blue:0.498, alpha:1).CGColor
        transportstarting.lineWidth   = 13
        transportstarting.strokeEnd   = 0.9
        layers["transportstarting"] = transportstarting
        let humanstarting = CAShapeLayer()
        Group.addSublayer(humanstarting)
        humanstarting.fillColor   = nil
        humanstarting.strokeColor = UIColor(red:0.909, green: 0.602, blue:0.268, alpha:1).CGColor
        humanstarting.lineWidth   = 13
        humanstarting.strokeEnd   = 0.1
        layers["humanstarting"] = humanstarting
        let humanstartingpath = CAShapeLayer()
        Group.addSublayer(humanstartingpath)
        humanstartingpath.opacity     = 0
        humanstartingpath.fillColor   = nil
        humanstartingpath.strokeColor = UIColor(red:0.305, green: 0.909, blue:0.329, alpha:1).CGColor
        humanstartingpath.lineWidth   = 13
        humanstartingpath.strokeEnd   = 0.4
        humanstartingpath.strokeStart   = 0
        layers["humanstartingpath"] = humanstartingpath
        let humanarrow = CAShapeLayer()
        Group.addSublayer(humanarrow)
        humanarrow.setValue(-225 * CGFloat(M_PI)/180, forKeyPath:"transform.rotation")
        humanarrow.fillColor   = UIColor(red:0.909, green: 0.602, blue:0.268, alpha:1).CGColor
        humanarrow.strokeColor = UIColor(red:0.305, green: 0.909, blue:0.329, alpha:1).CGColor
        humanarrow.lineWidth   = 0
        layers["humanarrow"] = humanarrow
        let humanscore = CATextLayer()
        Group.addSublayer(humanscore)
        humanscore.contentsScale   = UIScreen.mainScreen().scale
        humanscore.string          = "0"
        humanscore.font            = "GothamBook"
        humanscore.fontSize        = 7
        humanscore.alignmentMode   = kCAAlignmentCenter;
        humanscore.foregroundColor = UIColor.blackColor().CGColor;
        humanscore.wrapped         = true
        layers["humanscore"] = humanscore
        let transportstartingpath = CAShapeLayer()
        Group.addSublayer(transportstartingpath)
        transportstartingpath.fillColor   = nil
        transportstartingpath.strokeColor = UIColor(red:0.305, green: 0.909, blue:0.329, alpha:1).CGColor
        transportstartingpath.lineWidth   = 13
        transportstartingpath.opacity     = 0
        transportstartingpath.strokeEnd   = 1
        transportstartingpath.strokeStart  = 0
        layers["transportstartingpath"] = transportstartingpath
        let transportarrow = CAShapeLayer()
        Group.addSublayer(transportarrow)
        transportarrow.setValue(-225 * CGFloat(M_PI)/180, forKeyPath:"transform.rotation")
        transportarrow.fillColor   = UIColor(red:0.573, green: 0.557, blue:0.498, alpha:1).CGColor
        transportarrow.strokeColor = UIColor(red:0.909, green: 0.602, blue:0.268, alpha:1).CGColor
        transportarrow.lineWidth   = 0
        layers["transportarrow"] = transportarrow
        let transportscore = CATextLayer()
        Group.addSublayer(transportscore)
        transportscore.contentsScale   = UIScreen.mainScreen().scale
        transportscore.string          = "0"
        transportscore.font            = "GothamBook"
        transportscore.fontSize        = 7
        transportscore.alignmentMode   = kCAAlignmentCenter;
        transportscore.foregroundColor = UIColor.blackColor().CGColor;
        transportscore.wrapped         = true
        layers["transportscore"] = transportscore
        let wastestartingpath = CAShapeLayer()
        Group.addSublayer(wastestartingpath)
        wastestartingpath.fillColor   = nil
        wastestartingpath.strokeColor = UIColor(red:0.305, green: 0.909, blue:0.329, alpha:1).CGColor
        wastestartingpath.lineWidth   = 0
        wastestartingpath.strokeEnd   = 0.1
        layers["wastestartingpath"] = wastestartingpath
        let wastearrow = CAShapeLayer()
        Group.addSublayer(wastearrow)
        wastearrow.setValue(-225 * CGFloat(M_PI)/180, forKeyPath:"transform.rotation")
        wastearrow.fillColor   = UIColor(red:0.465, green: 0.756, blue:0.629, alpha:1).CGColor
        wastearrow.strokeColor = UIColor(red:0.909, green: 0.602, blue:0.268, alpha:1).CGColor
        wastearrow.lineWidth   = 0
        layers["wastearrow"] = wastearrow
        let wastescore = CATextLayer()
        Group.addSublayer(wastescore)
        wastescore.contentsScale   = UIScreen.mainScreen().scale
        wastescore.string          = "0"
        wastescore.font            = "GothamBook"
        wastescore.fontSize        = 7
        wastescore.alignmentMode   = kCAAlignmentCenter;
        wastescore.foregroundColor = UIColor.blackColor().CGColor;
        wastescore.wrapped         = true
        layers["wastescore"] = wastescore
        let waterstartingpath = CAShapeLayer()
        Group.addSublayer(waterstartingpath)
        waterstartingpath.fillColor   = nil
        waterstartingpath.strokeColor = UIColor(red:0.305, green: 0.909, blue:0.329, alpha:1).CGColor
        waterstartingpath.lineWidth   = 0
        waterstartingpath.strokeEnd   = 0.1
        layers["waterstartingpath"] = waterstartingpath
        let waterarrow = CAShapeLayer()
        Group.addSublayer(waterarrow)
        waterarrow.setValue(-225 * CGFloat(M_PI)/180, forKeyPath:"transform.rotation")
        waterarrow.fillColor   = UIColor(red:0.323, green: 0.755, blue:0.93, alpha:1).CGColor
        waterarrow.strokeColor = UIColor(red:0.909, green: 0.602, blue:0.268, alpha:1).CGColor
        waterarrow.lineWidth   = 0
        layers["waterarrow"] = waterarrow
        let waterscore = CATextLayer()
        Group.addSublayer(waterscore)
        waterscore.contentsScale   = UIScreen.mainScreen().scale
        waterscore.string          = "0"
        waterscore.font            = "GothamBook"
        waterscore.fontSize        = 7
        waterscore.alignmentMode   = kCAAlignmentCenter;
        waterscore.foregroundColor = UIColor.blackColor().CGColor;
        waterscore.wrapped         = true
        layers["waterscore"] = waterscore
        let energystartingpath = CAShapeLayer()
        Group.addSublayer(energystartingpath)
        energystartingpath.fillColor   = nil
        energystartingpath.strokeColor = UIColor(red:0.305, green: 0.909, blue:0.329, alpha:1).CGColor
        energystartingpath.lineWidth   = 0
        energystartingpath.strokeEnd   = 0.1
        layers["energystartingpath"] = energystartingpath
        let energyarrow = CAShapeLayer()
        Group.addSublayer(energyarrow)
        energyarrow.setValue(-225 * CGFloat(M_PI)/180, forKeyPath:"transform.rotation")
        energyarrow.fillColor   = UIColor(red:0.776, green: 0.858, blue:0.124, alpha:1).CGColor
        energyarrow.strokeColor = UIColor(red:0.909, green: 0.602, blue:0.268, alpha:1).CGColor
        energyarrow.lineWidth   = 0
        layers["energyarrow"] = energyarrow
        let energyscore = CATextLayer()
        Group.addSublayer(energyscore)
        energyscore.contentsScale   = UIScreen.mainScreen().scale
        energyscore.string          = "0"
        energyscore.font            = "GothamBook"
        energyscore.fontSize        = 7
        energyscore.alignmentMode   = kCAAlignmentCenter;
        energyscore.foregroundColor = UIColor.blackColor().CGColor;
        energyscore.wrapped         = true
        layers["energyscore"] = energyscore
        let puckscore = CATextLayer()
        Group.addSublayer(puckscore)
        puckscore.masksToBounds   = true
        puckscore.contentsScale   = UIScreen.mainScreen().scale
        puckscore.string          = "77"
        puckscore.font            = "DINEngschrift"
        puckscore.fontSize        = 12
        puckscore.alignmentMode   = kCAAlignmentCenter;
        puckscore.foregroundColor = UIColor.whiteColor().CGColor;
        puckscore.wrapped         = true
        layers["puckscore"] = puckscore
        setupLayerFrames()
    }
    
    func setupLayerFrames(){
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        if let Group : CALayer = layers["Group"] as? CALayer{
            Group.frame = CGRectMake(0.15091 * Group.superlayer!.bounds.width, 0.16304 * Group.superlayer!.bounds.height, 0.68576 * Group.superlayer!.bounds.width, 0.67363 * Group.superlayer!.bounds.height)
        }
        
        if let blank : CALayer = layers["blank"] as? CALayer{
            blank.frame = CGRectMake(0.39726 * blank.superlayer!.bounds.width, 0.38641 * blank.superlayer!.bounds.height, 0.24304 * blank.superlayer!.bounds.width, 0.24742 * blank.superlayer!.bounds.height)
        }
        
        if let humanback : CAShapeLayer = layers["humanback"] as? CAShapeLayer{
            humanback.frame = CGRectMake(0.00211 * humanback.superlayer!.bounds.width, 0.33743 * humanback.superlayer!.bounds.height, 0.68679 * humanback.superlayer!.bounds.width, 0.34587 * humanback.superlayer!.bounds.height)
            humanback.path  = humanbackPathWithBounds((layers["humanback"] as! CAShapeLayer).bounds).CGPath
        }
        
        if let transportback : CAShapeLayer = layers["transportback"] as? CAShapeLayer{
            transportback.frame = CGRectMake(0.00201 * transportback.superlayer!.bounds.width, 0.25775 * transportback.superlayer!.bounds.height, 0.76467 * transportback.superlayer!.bounds.width, 0.50473 * transportback.superlayer!.bounds.height)
            transportback.path  = transportbackPathWithBounds((layers["transportback"] as! CAShapeLayer).bounds).CGPath
        }
        
        if let wasteback : CAShapeLayer = layers["wasteback"] as? CAShapeLayer{
            wasteback.frame = CGRectMake(0, 0.17654 * wasteback.superlayer!.bounds.height, 0.84445 * wasteback.superlayer!.bounds.width, 0.66511 * wasteback.superlayer!.bounds.height)
            wasteback.path  = wastebackPathWithBounds((layers["wasteback"] as! CAShapeLayer).bounds).CGPath
        }
        
        if let waterback : CAShapeLayer = layers["waterback"] as? CAShapeLayer{
            waterback.frame = CGRectMake(0.00177 * waterback.superlayer!.bounds.width, 0.09941 * waterback.superlayer!.bounds.height, 0.92045 * waterback.superlayer!.bounds.width, 0.82142 * waterback.superlayer!.bounds.height)
            waterback.path  = waterbackPathWithBounds((layers["waterback"] as! CAShapeLayer).bounds).CGPath
        }
        
        if let energyback : CAShapeLayer = layers["energyback"] as? CAShapeLayer{
            energyback.frame = CGRectMake(0.00194 * energyback.superlayer!.bounds.width, 0.0207 * energyback.superlayer!.bounds.height, 0.99806 * energyback.superlayer!.bounds.width, 0.9793 * energyback.superlayer!.bounds.height)
            energyback.path  = energybackPathWithBounds((layers["energyback"] as! CAShapeLayer).bounds).CGPath
        }
        
        if let humanstart : CAShapeLayer = layers["humanstart"] as? CAShapeLayer{
            humanstart.frame = CGRectMake(0.00211 * humanstart.superlayer!.bounds.width, 0.33743 * humanstart.superlayer!.bounds.height, 0.68679 * humanstart.superlayer!.bounds.width, 0.34587 * humanstart.superlayer!.bounds.height)
            humanstart.path  = humanstartPathWithBounds((layers["humanstart"] as! CAShapeLayer).bounds).CGPath
        }
        
        if let transportstart : CAShapeLayer = layers["transportstart"] as? CAShapeLayer{
            transportstart.frame = CGRectMake(0.00201 * transportstart.superlayer!.bounds.width, 0.25775 * transportstart.superlayer!.bounds.height, 0.76467 * transportstart.superlayer!.bounds.width, 0.50473 * transportstart.superlayer!.bounds.height)
            transportstart.path  = transportstartPathWithBounds((layers["transportstart"] as! CAShapeLayer).bounds).CGPath
        }
        
        if let wastestart : CAShapeLayer = layers["wastestart"] as? CAShapeLayer{
            wastestart.frame = CGRectMake(0, 0.17654 * wastestart.superlayer!.bounds.height, 0.84445 * wastestart.superlayer!.bounds.width, 0.66511 * wastestart.superlayer!.bounds.height)
            wastestart.path  = wastestartPathWithBounds((layers["wastestart"] as! CAShapeLayer).bounds).CGPath
        }
        
        if let waterstart : CAShapeLayer = layers["waterstart"] as? CAShapeLayer{
            waterstart.frame = CGRectMake(0.00177 * waterstart.superlayer!.bounds.width, 0.09941 * waterstart.superlayer!.bounds.height, 0.92045 * waterstart.superlayer!.bounds.width, 0.82142 * waterstart.superlayer!.bounds.height)
            waterstart.path  = waterstartPathWithBounds((layers["waterstart"] as! CAShapeLayer).bounds).CGPath
        }
        
        if let energystart : CAShapeLayer = layers["energystart"] as? CAShapeLayer{
            energystart.frame = CGRectMake(0.00194 * energystart.superlayer!.bounds.width, 0.0207 * energystart.superlayer!.bounds.height, 0.99806 * energystart.superlayer!.bounds.width, 0.9793 * energystart.superlayer!.bounds.height)
            energystart.path  = energystartPathWithBounds((layers["energystart"] as! CAShapeLayer).bounds).CGPath
        }
        
        if let humanlabel : CATextLayer = layers["humanlabel"] as? CATextLayer{
            humanlabel.frame = CGRectMake(0.05754 * humanlabel.superlayer!.bounds.width, 0.31837 * humanlabel.superlayer!.bounds.height, 0.3996 * humanlabel.superlayer!.bounds.width, 0.04701 * humanlabel.superlayer!.bounds.height)
        }
        
        if let transportlabel : CATextLayer = layers["transportlabel"] as? CATextLayer{
            transportlabel.frame = CGRectMake(0.05754 * transportlabel.superlayer!.bounds.width, 0.2392 * transportlabel.superlayer!.bounds.height, 0.3996 * transportlabel.superlayer!.bounds.width, 0.04701 * transportlabel.superlayer!.bounds.height)
        }
        
        if let wastelabel : CATextLayer = layers["wastelabel"] as? CATextLayer{
            wastelabel.frame = CGRectMake(0.05754 * wastelabel.superlayer!.bounds.width, 0.16002 * wastelabel.superlayer!.bounds.height, 0.3996 * wastelabel.superlayer!.bounds.width, 0.04701 * wastelabel.superlayer!.bounds.height)
        }
        
        if let waterlabel : CATextLayer = layers["waterlabel"] as? CATextLayer{
            waterlabel.frame = CGRectMake(0.05754 * waterlabel.superlayer!.bounds.width, 0.08085 * waterlabel.superlayer!.bounds.height, 0.3996 * waterlabel.superlayer!.bounds.width, 0.04701 * waterlabel.superlayer!.bounds.height)
        }
        
        if let energylabel : CATextLayer = layers["energylabel"] as? CATextLayer{
            energylabel.frame = CGRectMake(0.05754 * energylabel.superlayer!.bounds.width, 0.00168 * energylabel.superlayer!.bounds.height, 0.3996 * energylabel.superlayer!.bounds.width, 0.04701 * energylabel.superlayer!.bounds.height)
        }
        
        if let energy : CALayer = layers["energy"] as? CALayer{
            energy.frame = CGRectMake(0.01811 * energy.superlayer!.bounds.width, 0, 0.02916 * energy.superlayer!.bounds.width, 0.05037 * energy.superlayer!.bounds.height)
        }
        
        if let water : CALayer = layers["water"] as? CALayer{
            water.frame = CGRectMake(0.02054 * water.superlayer!.bounds.width, 0.07742 * water.superlayer!.bounds.height, 0.0243 * water.superlayer!.bounds.width, 0.04398 * water.superlayer!.bounds.height)
        }
        
        if let waste : CALayer = layers["waste"] as? CALayer{
            waste.frame = CGRectMake(0.01136 * waste.superlayer!.bounds.width, 0.15938 * waste.superlayer!.bounds.height, 0.03889 * waste.superlayer!.bounds.width, 0.0384 * waste.superlayer!.bounds.height)
        }
        
        if let transport : CALayer = layers["transport"] as? CALayer{
            transport.frame = CGRectMake(0.01082 * transport.superlayer!.bounds.width, 0.24624 * transport.superlayer!.bounds.height, 0.03889 * transport.superlayer!.bounds.width, 0.03292 * transport.superlayer!.bounds.height)
        }
        
        if let human : CALayer = layers["human"] as? CALayer{
            human.frame = CGRectMake(0.02297 * human.superlayer!.bounds.width, 0.31533 * human.superlayer!.bounds.height, 0.01944 * human.superlayer!.bounds.width, 0.04319 * human.superlayer!.bounds.height)
        }
        
        if let humanmaxscore : CATextLayer = layers["humanmaxscore"] as? CATextLayer{
            humanmaxscore.frame = CGRectMake(0.32921 * humanmaxscore.superlayer!.bounds.width, 0.40125 * humanmaxscore.superlayer!.bounds.height, 0.03889 * humanmaxscore.superlayer!.bounds.width, 0.03959 * humanmaxscore.superlayer!.bounds.height)
        }
        
        if let transportmaxscore : CATextLayer = layers["transportmaxscore"] as? CATextLayer{
            transportmaxscore.frame = CGRectMake(0.25143 * transportmaxscore.superlayer!.bounds.width, 0.40125 * transportmaxscore.superlayer!.bounds.height, 0.03889 * transportmaxscore.superlayer!.bounds.width, 0.03959 * transportmaxscore.superlayer!.bounds.height)
        }
        
        if let wastemaxscore : CATextLayer = layers["wastemaxscore"] as? CATextLayer{
            wastemaxscore.frame = CGRectMake(0.17366 * wastemaxscore.superlayer!.bounds.width, 0.40125 * wastemaxscore.superlayer!.bounds.height, 0.03889 * wastemaxscore.superlayer!.bounds.width, 0.03959 * wastemaxscore.superlayer!.bounds.height)
        }
        
        if let watermaxscore : CATextLayer = layers["watermaxscore"] as? CATextLayer{
            watermaxscore.frame = CGRectMake(0.09346 * watermaxscore.superlayer!.bounds.width, 0.40125 * watermaxscore.superlayer!.bounds.height, 0.03889 * watermaxscore.superlayer!.bounds.width, 0.03959 * watermaxscore.superlayer!.bounds.height)
        }
        
        if let energymaxscore : CATextLayer = layers["energymaxscore"] as? CATextLayer{
            energymaxscore.frame = CGRectMake(0.01811 * energymaxscore.superlayer!.bounds.width, 0.40125 * energymaxscore.superlayer!.bounds.height, 0.03889 * energymaxscore.superlayer!.bounds.width, 0.03959 * energymaxscore.superlayer!.bounds.height)
        }
        
        if let energystarting : CAShapeLayer = layers["energystarting"] as? CAShapeLayer{
            energystarting.frame = CGRectMake(0.03756 * energystarting.superlayer!.bounds.width, 0.02024 * energystarting.superlayer!.bounds.height, 0.96244 * energystarting.superlayer!.bounds.width, 0.97976 * energystarting.superlayer!.bounds.height)
            energystarting.path  = energystartingPathWithBounds((layers["energystarting"] as! CAShapeLayer).bounds).CGPath
        }
        
        if let waterstarting : CAShapeLayer = layers["waterstarting"] as? CAShapeLayer{
            waterstarting.frame = CGRectMake(0.11533 * waterstarting.superlayer!.bounds.width, 0.09941 * waterstarting.superlayer!.bounds.height, 0.8069 * waterstarting.superlayer!.bounds.width, 0.82142 * waterstarting.superlayer!.bounds.height)
            waterstarting.path  = waterstartingPathWithBounds((layers["waterstarting"] as! CAShapeLayer).bounds).CGPath
        }
        
        if let wastestarting : CAShapeLayer = layers["wastestarting"] as? CAShapeLayer{
            wastestarting.frame = CGRectMake(0.1931 * wastestarting.superlayer!.bounds.width, 0.17858 * wastestarting.superlayer!.bounds.height, 0.65135 * wastestarting.superlayer!.bounds.width, 0.66307 * wastestarting.superlayer!.bounds.height)
            wastestarting.path  = wastestartingPathWithBounds((layers["wastestarting"] as! CAShapeLayer).bounds).CGPath
        }
        
        if let transportstarting : CAShapeLayer = layers["transportstarting"] as? CAShapeLayer{
            transportstarting.frame = CGRectMake(0.27088 * transportstarting.superlayer!.bounds.width, 0.25775 * transportstarting.superlayer!.bounds.height, 0.4958 * transportstarting.superlayer!.bounds.width, 0.50473 * transportstarting.superlayer!.bounds.height)
            transportstarting.path  = transportstartingPathWithBounds((layers["transportstarting"] as! CAShapeLayer).bounds).CGPath
        }
        
        if let humanstarting : CAShapeLayer = layers["humanstarting"] as? CAShapeLayer{
            humanstarting.frame = CGRectMake(0.34865 * humanstarting.superlayer!.bounds.width, 0.33693 * humanstarting.superlayer!.bounds.height, 0.34026 * humanstarting.superlayer!.bounds.width, 0.34638 * humanstarting.superlayer!.bounds.height)
            humanstarting.path  = humanstartingPathWithBounds((layers["humanstarting"] as! CAShapeLayer).bounds).CGPath
        }
        
        if let humanstartingpath : CAShapeLayer = layers["humanstartingpath"] as? CAShapeLayer{
            humanstartingpath.frame = CGRectMake(0.34865 * humanstartingpath.superlayer!.bounds.width, 0.33693 * humanstartingpath.superlayer!.bounds.height, 0.34026 * humanstartingpath.superlayer!.bounds.width, 0.34638 * humanstartingpath.superlayer!.bounds.height)
            humanstartingpath.path  = humanstartingpathPathWithBounds((layers["humanstartingpath"] as! CAShapeLayer).bounds).CGPath
        }
        
        if let humanarrow : CAShapeLayer = layers["humanarrow"] as? CAShapeLayer{
            humanarrow.transform = CATransform3DIdentity
            humanarrow.frame     = CGRectMake(0.49691 * humanarrow.superlayer!.bounds.width, 0.31713 * humanarrow.superlayer!.bounds.height, 0.04375 * humanarrow.superlayer!.bounds.width, 0.04453 * humanarrow.superlayer!.bounds.height)
            humanarrow.setValue(-225 * CGFloat(M_PI)/180, forKeyPath:"transform.rotation")
            humanarrow.path      = humanarrowPathWithBounds((layers["humanarrow"] as! CAShapeLayer).bounds).CGPath
        }
        
        if let humanscore : CATextLayer = layers["humanscore"] as? CATextLayer{
            humanscore.frame = CGRectMake(0.48153 * humanscore.superlayer!.bounds.width, 0.31022 * humanscore.superlayer!.bounds.height, 0.03889 * humanscore.superlayer!.bounds.width, 0.03959 * humanscore.superlayer!.bounds.height)
        }
        
        if let transportstartingpath : CAShapeLayer = layers["transportstartingpath"] as? CAShapeLayer{
            transportstartingpath.frame = CGRectMake(0.27088 * transportstartingpath.superlayer!.bounds.width, 0.25775 * transportstartingpath.superlayer!.bounds.height, 0.4958 * transportstartingpath.superlayer!.bounds.width, 0.50473 * transportstartingpath.superlayer!.bounds.height)
            transportstartingpath.path  = transportstartingpathPathWithBounds((layers["transportstartingpath"] as! CAShapeLayer).bounds).CGPath
        }
        
        if let transportarrow : CAShapeLayer = layers["transportarrow"] as? CAShapeLayer{
            transportarrow.transform = CATransform3DIdentity
            transportarrow.frame     = CGRectMake(0.49691 * transportarrow.superlayer!.bounds.width, 0.31713 * transportarrow.superlayer!.bounds.height, 0.04375 * transportarrow.superlayer!.bounds.width, 0.04453 * transportarrow.superlayer!.bounds.height)
            transportarrow.setValue(-225 * CGFloat(M_PI)/180, forKeyPath:"transform.rotation")
            transportarrow.path      = transportarrowPathWithBounds((layers["transportarrow"] as! CAShapeLayer).bounds).CGPath
        }
        
        if let transportscore : CATextLayer = layers["transportscore"] as? CATextLayer{
            transportscore.frame = CGRectMake(0.48153 * transportscore.superlayer!.bounds.width, 0.31022 * transportscore.superlayer!.bounds.height, 0.03889 * transportscore.superlayer!.bounds.width, 0.03959 * transportscore.superlayer!.bounds.height)
        }
        
        if let wastestartingpath : CAShapeLayer = layers["wastestartingpath"] as? CAShapeLayer{
            wastestartingpath.frame = CGRectMake(0.1931 * wastestartingpath.superlayer!.bounds.width, 0.17858 * wastestartingpath.superlayer!.bounds.height, 0.65135 * wastestartingpath.superlayer!.bounds.width, 0.66307 * wastestartingpath.superlayer!.bounds.height)
            wastestartingpath.path  = wastestartingpathPathWithBounds((layers["wastestartingpath"] as! CAShapeLayer).bounds).CGPath
        }
        
        if let wastearrow : CAShapeLayer = layers["wastearrow"] as? CAShapeLayer{
            wastearrow.transform = CATransform3DIdentity
            wastearrow.frame     = CGRectMake(0.49691 * wastearrow.superlayer!.bounds.width, 0.31713 * wastearrow.superlayer!.bounds.height, 0.04375 * wastearrow.superlayer!.bounds.width, 0.04453 * wastearrow.superlayer!.bounds.height)
            wastearrow.setValue(-225 * CGFloat(M_PI)/180, forKeyPath:"transform.rotation")
            wastearrow.path      = wastearrowPathWithBounds((layers["wastearrow"] as! CAShapeLayer).bounds).CGPath
        }
        
        if let wastescore : CATextLayer = layers["wastescore"] as? CATextLayer{
            wastescore.frame = CGRectMake(0.48153 * wastescore.superlayer!.bounds.width, 0.31022 * wastescore.superlayer!.bounds.height, 0.03889 * wastescore.superlayer!.bounds.width, 0.03959 * wastescore.superlayer!.bounds.height)
        }
        
        if let waterstartingpath : CAShapeLayer = layers["waterstartingpath"] as? CAShapeLayer{
            waterstartingpath.frame = CGRectMake(0.11533 * waterstartingpath.superlayer!.bounds.width, 0.09941 * waterstartingpath.superlayer!.bounds.height, 0.8069 * waterstartingpath.superlayer!.bounds.width, 0.82142 * waterstartingpath.superlayer!.bounds.height)
            waterstartingpath.path  = waterstartingpathPathWithBounds((layers["waterstartingpath"] as! CAShapeLayer).bounds).CGPath
        }
        
        if let waterarrow : CAShapeLayer = layers["waterarrow"] as? CAShapeLayer{
            waterarrow.transform = CATransform3DIdentity
            waterarrow.frame     = CGRectMake(0.49691 * waterarrow.superlayer!.bounds.width, 0.31713 * waterarrow.superlayer!.bounds.height, 0.04375 * waterarrow.superlayer!.bounds.width, 0.04453 * waterarrow.superlayer!.bounds.height)
            waterarrow.setValue(-225 * CGFloat(M_PI)/180, forKeyPath:"transform.rotation")
            waterarrow.path      = waterarrowPathWithBounds((layers["waterarrow"] as! CAShapeLayer).bounds).CGPath
        }
        
        if let waterscore : CATextLayer = layers["waterscore"] as? CATextLayer{
            waterscore.frame = CGRectMake(0.48153 * waterscore.superlayer!.bounds.width, 0.31022 * waterscore.superlayer!.bounds.height, 0.03889 * waterscore.superlayer!.bounds.width, 0.03959 * waterscore.superlayer!.bounds.height)
        }
        
        if let energystartingpath : CAShapeLayer = layers["energystartingpath"] as? CAShapeLayer{
            energystartingpath.frame = CGRectMake(0.03756 * energystartingpath.superlayer!.bounds.width, 0.02024 * energystartingpath.superlayer!.bounds.height, 0.96244 * energystartingpath.superlayer!.bounds.width, 0.97976 * energystartingpath.superlayer!.bounds.height)
            energystartingpath.path  = energystartingpathPathWithBounds((layers["energystartingpath"] as! CAShapeLayer).bounds).CGPath
        }
        
        if let energyarrow : CAShapeLayer = layers["energyarrow"] as? CAShapeLayer{
            energyarrow.transform = CATransform3DIdentity
            energyarrow.frame     = CGRectMake(0.49691 * energyarrow.superlayer!.bounds.width, 0.31713 * energyarrow.superlayer!.bounds.height, 0.04375 * energyarrow.superlayer!.bounds.width, 0.04453 * energyarrow.superlayer!.bounds.height)
            energyarrow.setValue(-225 * CGFloat(M_PI)/180, forKeyPath:"transform.rotation")
            energyarrow.path      = energyarrowPathWithBounds((layers["energyarrow"] as! CAShapeLayer).bounds).CGPath
        }
        
        if let energyscore : CATextLayer = layers["energyscore"] as? CATextLayer{
            energyscore.frame = CGRectMake(0.48153 * energyscore.superlayer!.bounds.width, 0.31022 * energyscore.superlayer!.bounds.height, 0.03889 * energyscore.superlayer!.bounds.width, 0.03959 * energyscore.superlayer!.bounds.height)
        }
        
        if let puckscore : CATextLayer = layers["puckscore"] as? CATextLayer{
            puckscore.frame = CGRectMake(0.47017 * puckscore.superlayer!.bounds.width, 0.44826 * puckscore.superlayer!.bounds.height, 0.09722 * puckscore.superlayer!.bounds.width, 0.09897 * puckscore.superlayer!.bounds.height)
            puckscore.fontSize = 0.2 * puckscore.superlayer!.bounds.height
        }
        
        CATransaction.commit()
        setupProperties()
    }
    
    //MARK: - Animation Setup
    
    func addUntitled1Animation(){
        let fillMode : String = kCAFillModeForwards
        let innerscoreOpacityAnim            = CAKeyframeAnimation(keyPath:"opacity")
        innerscoreOpacityAnim.values         = [1, 1, 0]
        innerscoreOpacityAnim.keyTimes       = [0, 0.757, 1]
        innerscoreOpacityAnim.duration       = 1.88
        innerscoreOpacityAnim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)
        ////Energystarting animation
        let energystartingStrokeEndAnim      = CAKeyframeAnimation(keyPath:"strokeEnd")
        energystartingStrokeEndAnim.values   = [0, 1]
        energystartingStrokeEndAnim.keyTimes = [0, 1]
        energystartingStrokeEndAnim.duration = 1.8
        energystartingStrokeEndAnim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)
        
        let energystartingUntitled1Anim : CAAnimationGroup = QCMethod.groupAnimations([energystartingStrokeEndAnim], fillMode:fillMode)
        layers["energystarting"]?.addAnimation(energystartingUntitled1Anim, forKey:"energystartingUntitled1Anim")
        
        ////Waterstarting animation
        let waterstartingStrokeEndAnim      = CAKeyframeAnimation(keyPath:"strokeEnd")
        waterstartingStrokeEndAnim.values   = [0, 1]
        waterstartingStrokeEndAnim.keyTimes = [0, 1]
        waterstartingStrokeEndAnim.duration = 1.8
        waterstartingStrokeEndAnim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)
        
        let waterstartingUntitled1Anim : CAAnimationGroup = QCMethod.groupAnimations([waterstartingStrokeEndAnim], fillMode:fillMode)
        layers["waterstarting"]?.addAnimation(waterstartingUntitled1Anim, forKey:"waterstartingUntitled1Anim")
        
        ////Wastestarting animation
        let wastestartingStrokeEndAnim      = CAKeyframeAnimation(keyPath:"strokeEnd")
        wastestartingStrokeEndAnim.values   = [0, 1]
        wastestartingStrokeEndAnim.keyTimes = [0, 1]
        wastestartingStrokeEndAnim.duration = 1.8
        wastestartingStrokeEndAnim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)
        
        let wastestartingUntitled1Anim : CAAnimationGroup = QCMethod.groupAnimations([wastestartingStrokeEndAnim], fillMode:fillMode)
        layers["wastestarting"]?.addAnimation(wastestartingUntitled1Anim, forKey:"wastestartingUntitled1Anim")
        
        ////Transportstarting animation
        let transportstartingStrokeEndAnim    = CAKeyframeAnimation(keyPath:"strokeEnd")
        transportstartingStrokeEndAnim.values = [0, 1]
        transportstartingStrokeEndAnim.keyTimes = [0, 1]
        transportstartingStrokeEndAnim.duration = 1.8
        transportstartingStrokeEndAnim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)
        
        let transportstartingUntitled1Anim : CAAnimationGroup = QCMethod.groupAnimations([transportstartingStrokeEndAnim], fillMode:fillMode)
        layers["transportstarting"]?.addAnimation(transportstartingUntitled1Anim, forKey:"transportstartingUntitled1Anim")
        
        ////Humanstarting animation
        let humanstartingStrokeEndAnim      = CAKeyframeAnimation(keyPath:"strokeEnd")
        humanstartingStrokeEndAnim.values   = [0, 1]
        humanstartingStrokeEndAnim.keyTimes = [0, 1]
        humanstartingStrokeEndAnim.duration = 1.8
        humanstartingStrokeEndAnim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)
        
        let humanstartingUntitled1Anim : CAAnimationGroup = QCMethod.groupAnimations([humanstartingStrokeEndAnim], fillMode:fillMode)
        layers["humanstarting"]?.addAnimation(humanstartingUntitled1Anim, forKey:"humanstartingUntitled1Anim")
        
        let humanarrow = layers["humanarrow"] as! CAShapeLayer
        
        ////Humanarrow animation
        let humanarrowPositionAnim            = CAKeyframeAnimation(keyPath:"position")
        humanarrowPositionAnim.path           = humanstartingpathPathWithBounds((layers["humanstartingpath"] as! CAShapeLayer).frame).CGPath
        humanarrowPositionAnim.rotationMode   = kCAAnimationRotateAutoReverse
        humanarrowPositionAnim.calculationMode = kCAAnimationCubicPaced
        humanarrowPositionAnim.duration       = 1.8
        humanarrowPositionAnim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)
        if(humanscorevalue < humanmaxscorevalue){
        let humanarrowUntitled1Anim : CAAnimationGroup = QCMethod.groupAnimations([humanarrowPositionAnim], fillMode:fillMode)
        humanarrow.addAnimation(humanarrowUntitled1Anim, forKey:"humanarrowUntitled1Anim")
        }else{
            let humanarrowUntitled1Anim : CAAnimationGroup = QCMethod.groupAnimations([humanarrowPositionAnim, innerscoreOpacityAnim], fillMode:fillMode)
            humanarrow.addAnimation(humanarrowUntitled1Anim, forKey:"humanarrowUntitled1Anim")
        }
        let humanscore = layers["humanscore"] as! CATextLayer
        
        ////Humanscore animation
        let humanscorePositionAnim             = CAKeyframeAnimation(keyPath:"position")
        humanscorePositionAnim.path            = humanstartingscorepathPathWithBounds((layers["humanstartingpath"] as! CAShapeLayer).frame).CGPath
        humanscorePositionAnim.calculationMode = kCAAnimationCubicPaced
        humanscorePositionAnim.duration        = 1.8
        humanscorePositionAnim.timingFunction  = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)
        
        let humanscoreUntitled1Anim : CAAnimationGroup = QCMethod.groupAnimations([humanscorePositionAnim], fillMode:fillMode)
        humanscore.addAnimation(humanscoreUntitled1Anim, forKey:"humanscoreUntitled1Anim")
        
        let transportarrow = layers["transportarrow"] as! CAShapeLayer
        
        ////Transportarrow animation
        let transportarrowPositionAnim      = CAKeyframeAnimation(keyPath:"position")
        transportarrowPositionAnim.path     = transportstartingpathPathWithBounds((layers["transportstartingpath"] as! CAShapeLayer).frame).CGPath
        transportarrowPositionAnim.rotationMode = kCAAnimationRotateAutoReverse
        transportarrowPositionAnim.calculationMode = kCAAnimationCubicPaced
        transportarrowPositionAnim.duration = 1.8
        transportarrowPositionAnim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)
        if(transportscorevalue < transportmaxscorevalue){
        let transportarrowUntitled1Anim : CAAnimationGroup = QCMethod.groupAnimations([transportarrowPositionAnim], fillMode:fillMode)
        transportarrow.addAnimation(transportarrowUntitled1Anim, forKey:"transportarrowUntitled1Anim")
        }else{
            let transportarrowUntitled1Anim : CAAnimationGroup = QCMethod.groupAnimations([transportarrowPositionAnim,innerscoreOpacityAnim], fillMode:fillMode)
            transportarrow.addAnimation(transportarrowUntitled1Anim, forKey:"transportarrowUntitled1Anim")
        }
        let transportscore = layers["transportscore"] as! CATextLayer
        
        ////Transportscore animation
        let transportscorePositionAnim      = CAKeyframeAnimation(keyPath:"position")
        transportscorePositionAnim.path     = transportstartingscorepathPathWithBounds((layers["transportstartingpath"] as! CAShapeLayer).frame).CGPath
        transportscorePositionAnim.calculationMode = kCAAnimationCubicPaced
        transportscorePositionAnim.duration = 1.8
        transportscorePositionAnim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)
        
        let transportscoreUntitled1Anim : CAAnimationGroup = QCMethod.groupAnimations([transportscorePositionAnim], fillMode:fillMode)
        transportscore.addAnimation(transportscoreUntitled1Anim, forKey:"transportscoreUntitled1Anim")
        
        let wastearrow = layers["wastearrow"] as! CAShapeLayer
        
        ////Wastearrow animation
        let wastearrowPositionAnim            = CAKeyframeAnimation(keyPath:"position")
        wastearrowPositionAnim.path           = wastestartingpathPathWithBounds((layers["wastestartingpath"] as! CAShapeLayer).frame).CGPath
        wastearrowPositionAnim.rotationMode   = kCAAnimationRotateAutoReverse
        wastearrowPositionAnim.calculationMode = kCAAnimationCubicPaced
        wastearrowPositionAnim.duration       = 1.8
        wastearrowPositionAnim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)
        
        if(wastescorevalue < wastemaxscorevalue){
        let wastearrowUntitled1Anim : CAAnimationGroup = QCMethod.groupAnimations([wastearrowPositionAnim], fillMode:fillMode)
        wastearrow.addAnimation(wastearrowUntitled1Anim, forKey:"wastearrowUntitled1Anim")
        }else{
            let wastearrowUntitled1Anim : CAAnimationGroup = QCMethod.groupAnimations([wastearrowPositionAnim,innerscoreOpacityAnim], fillMode:fillMode)
            wastearrow.addAnimation(wastearrowUntitled1Anim, forKey:"wastearrowUntitled1Anim")
        }
        let wastescore = layers["wastescore"] as! CATextLayer
        
        ////Wastescore animation
        let wastescorePositionAnim             = CAKeyframeAnimation(keyPath:"position")
        wastescorePositionAnim.path            = wastestartingscorepathPathWithBounds((layers["wastestartingpath"] as! CAShapeLayer).frame).CGPath
        wastescorePositionAnim.calculationMode = kCAAnimationCubicPaced
        wastescorePositionAnim.duration        = 1.8
        wastescorePositionAnim.timingFunction  = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)
        
        let wastescoreUntitled1Anim : CAAnimationGroup = QCMethod.groupAnimations([wastescorePositionAnim], fillMode:fillMode)
        wastescore.addAnimation(wastescoreUntitled1Anim, forKey:"wastescoreUntitled1Anim")
        
        let waterarrow = layers["waterarrow"] as! CAShapeLayer
        
        ////Waterarrow animation
        let waterarrowPositionAnim            = CAKeyframeAnimation(keyPath:"position")
        waterarrowPositionAnim.path           = waterstartingpathPathWithBounds((layers["waterstartingpath"] as! CAShapeLayer).frame).CGPath
        waterarrowPositionAnim.rotationMode   = kCAAnimationRotateAutoReverse
        waterarrowPositionAnim.calculationMode = kCAAnimationCubicPaced
        waterarrowPositionAnim.duration       = 1.8
        waterarrowPositionAnim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)
        if(waterscorevalue < watermaxscorevalue){
        let waterarrowUntitled1Anim : CAAnimationGroup = QCMethod.groupAnimations([waterarrowPositionAnim], fillMode:fillMode)
        waterarrow.addAnimation(waterarrowUntitled1Anim, forKey:"waterarrowUntitled1Anim")
        }else{
            let waterarrowUntitled1Anim : CAAnimationGroup = QCMethod.groupAnimations([waterarrowPositionAnim,innerscoreOpacityAnim], fillMode:fillMode)
            waterarrow.addAnimation(waterarrowUntitled1Anim, forKey:"waterarrowUntitled1Anim")
        }
        let waterscore = layers["waterscore"] as! CATextLayer
        
        ////Waterscore animation
        let waterscorePositionAnim             = CAKeyframeAnimation(keyPath:"position")
        waterscorePositionAnim.path            = waterstartingscorepathPathWithBounds((layers["waterstartingpath"] as! CAShapeLayer).frame).CGPath
        waterscorePositionAnim.calculationMode = kCAAnimationCubicPaced
        waterscorePositionAnim.duration        = 1.8
        waterscorePositionAnim.timingFunction  = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)
        
        let waterscoreUntitled1Anim : CAAnimationGroup = QCMethod.groupAnimations([waterscorePositionAnim], fillMode:fillMode)
        waterscore.addAnimation(waterscoreUntitled1Anim, forKey:"waterscoreUntitled1Anim")
        
        let energyarrow = layers["energyarrow"] as! CAShapeLayer
        
        ////Energyarrow animation
        let energyarrowPositionAnim            = CAKeyframeAnimation(keyPath:"position")
        energyarrowPositionAnim.path           = energystartingpathPathWithBounds((layers["energystartingpath"] as! CAShapeLayer).frame).CGPath
        energyarrowPositionAnim.rotationMode   = kCAAnimationRotateAutoReverse
        energyarrowPositionAnim.calculationMode = kCAAnimationCubicPaced
        energyarrowPositionAnim.duration       = 1.8
        energyarrowPositionAnim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)
        if(energyscorevalue < energymaxscorevalue){
        let energyarrowUntitled1Anim : CAAnimationGroup = QCMethod.groupAnimations([energyarrowPositionAnim], fillMode:fillMode)
        energyarrow.addAnimation(energyarrowUntitled1Anim, forKey:"energyarrowUntitled1Anim")
        }else{
            let energyarrowUntitled1Anim : CAAnimationGroup = QCMethod.groupAnimations([energyarrowPositionAnim,innerscoreOpacityAnim], fillMode:fillMode)
            energyarrow.addAnimation(energyarrowUntitled1Anim, forKey:"energyarrowUntitled1Anim")
        }
        let energyscore = layers["energyscore"] as! CATextLayer
        
        ////Energyscore animation
        let energyscorePositionAnim            = CAKeyframeAnimation(keyPath:"position")
        energyscorePositionAnim.path           = energystartingscorepathPathWithBounds((layers["energystartingpath"] as! CAShapeLayer).frame).CGPath
        energyscorePositionAnim.calculationMode = kCAAnimationCubicPaced
        energyscorePositionAnim.duration       = 1.8
        energyscorePositionAnim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)
        
        let energyscoreUntitled1Anim : CAAnimationGroup = QCMethod.groupAnimations([energyscorePositionAnim], fillMode:fillMode)
        energyscore.addAnimation(energyscoreUntitled1Anim, forKey:"energyscoreUntitled1Anim")
    }
    
    //MARK: - Animation Cleanup
    
    func updateLayerValuesForAnimationId(identifier: String){
        if identifier == "Untitled1"{
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["energystarting"] as! CALayer).animationForKey("energystartingUntitled1Anim"), theLayer:(layers["energystarting"] as! CALayer))
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["waterstarting"] as! CALayer).animationForKey("waterstartingUntitled1Anim"), theLayer:(layers["waterstarting"] as! CALayer))
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["wastestarting"] as! CALayer).animationForKey("wastestartingUntitled1Anim"), theLayer:(layers["wastestarting"] as! CALayer))
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["transportstarting"] as! CALayer).animationForKey("transportstartingUntitled1Anim"), theLayer:(layers["transportstarting"] as! CALayer))
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["humanstarting"] as! CALayer).animationForKey("humanstartingUntitled1Anim"), theLayer:(layers["humanstarting"] as! CALayer))
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["humanarrow"] as! CALayer).animationForKey("humanarrowUntitled1Anim"), theLayer:(layers["humanarrow"] as! CALayer))
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["humanscore"] as! CALayer).animationForKey("humanscoreUntitled1Anim"), theLayer:(layers["humanscore"] as! CALayer))
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["transportarrow"] as! CALayer).animationForKey("transportarrowUntitled1Anim"), theLayer:(layers["transportarrow"] as! CALayer))
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["transportscore"] as! CALayer).animationForKey("transportscoreUntitled1Anim"), theLayer:(layers["transportscore"] as! CALayer))
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["wastearrow"] as! CALayer).animationForKey("wastearrowUntitled1Anim"), theLayer:(layers["wastearrow"] as! CALayer))
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["wastescore"] as! CALayer).animationForKey("wastescoreUntitled1Anim"), theLayer:(layers["wastescore"] as! CALayer))
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["waterarrow"] as! CALayer).animationForKey("waterarrowUntitled1Anim"), theLayer:(layers["waterarrow"] as! CALayer))
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["waterscore"] as! CALayer).animationForKey("waterscoreUntitled1Anim"), theLayer:(layers["waterscore"] as! CALayer))
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["energyarrow"] as! CALayer).animationForKey("energyarrowUntitled1Anim"), theLayer:(layers["energyarrow"] as! CALayer))
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["energyscore"] as! CALayer).animationForKey("energyscoreUntitled1Anim"), theLayer:(layers["energyscore"] as! CALayer))
        }
    }
    
    func removeAnimationsForAnimationId(identifier: String){
        if identifier == "Untitled1"{
            (layers["energystarting"] as! CALayer).removeAnimationForKey("energystartingUntitled1Anim")
            (layers["waterstarting"] as! CALayer).removeAnimationForKey("waterstartingUntitled1Anim")
            (layers["wastestarting"] as! CALayer).removeAnimationForKey("wastestartingUntitled1Anim")
            (layers["transportstarting"] as! CALayer).removeAnimationForKey("transportstartingUntitled1Anim")
            (layers["humanstarting"] as! CALayer).removeAnimationForKey("humanstartingUntitled1Anim")
            (layers["humanarrow"] as! CALayer).removeAnimationForKey("humanarrowUntitled1Anim")
            (layers["humanscore"] as! CALayer).removeAnimationForKey("humanscoreUntitled1Anim")
            (layers["transportarrow"] as! CALayer).removeAnimationForKey("transportarrowUntitled1Anim")
            (layers["transportscore"] as! CALayer).removeAnimationForKey("transportscoreUntitled1Anim")
            (layers["wastearrow"] as! CALayer).removeAnimationForKey("wastearrowUntitled1Anim")
            (layers["wastescore"] as! CALayer).removeAnimationForKey("wastescoreUntitled1Anim")
            (layers["waterarrow"] as! CALayer).removeAnimationForKey("waterarrowUntitled1Anim")
            (layers["waterscore"] as! CALayer).removeAnimationForKey("waterscoreUntitled1Anim")
            (layers["energyarrow"] as! CALayer).removeAnimationForKey("energyarrowUntitled1Anim")
            (layers["energyscore"] as! CALayer).removeAnimationForKey("energyscoreUntitled1Anim")
        }
    }
    
    func removeAllAnimations(){
        for layer in layers.values{
            (layer as! CALayer).removeAllAnimations()
        }
    }
    
    //MARK: - Bezier Path
    
    func humanbackPathWithBounds(bounds: CGRect) -> UIBezierPath{
        let humanbackPath = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        humanbackPath.moveToPoint(CGPointMake(minX, minY + 0.00061 * h))
        humanbackPath.addCurveToPoint(CGPointMake(minX + 0.77501 * w, minY + 0.00061 * h), controlPoint1:CGPointMake(minX + 0.00766 * w, minY + 0.00061 * h), controlPoint2:CGPointMake(minX + 0.76753 * w, minY + -0.00076 * h))
        humanbackPath.addCurveToPoint(CGPointMake(minX + w, minY + 0.49927 * h), controlPoint1:CGPointMake(minX + 0.90117 * w, minY + 0.02381 * h), controlPoint2:CGPointMake(minX + w, minY + 0.23821 * h))
        humanbackPath.addCurveToPoint(CGPointMake(minX + 0.75229 * w, minY + h), controlPoint1:CGPointMake(minX + w, minY + 0.77581 * h), controlPoint2:CGPointMake(minX + 0.88909 * w, minY + h))
        humanbackPath.addCurveToPoint(CGPointMake(minX + 0.50626 * w, minY + 0.55809 * h), controlPoint1:CGPointMake(minX + 0.62532 * w, minY + h), controlPoint2:CGPointMake(minX + 0.52067 * w, minY + 0.80692 * h))
        humanbackPath.addCurveToPoint(CGPointMake(minX + 0.50626 * w, minY + 0.14819 * h), controlPoint1:CGPointMake(minX + 0.50515 * w, minY + 0.5388 * h), controlPoint2:CGPointMake(minX + 0.50626 * w, minY + 0.16809 * h))
        
        return humanbackPath
    }
    
    func transportbackPathWithBounds(bounds: CGRect) -> UIBezierPath{
        let transportbackPath = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        transportbackPath.moveToPoint(CGPointMake(minX, minY))
        transportbackPath.addCurveToPoint(CGPointMake(minX + 0.69377 * w, minY + 0.00076 * h), controlPoint1:CGPointMake(minX + 0.00603 * w, minY), controlPoint2:CGPointMake(minX + 0.68783 * w, minY + 0.00025 * h))
        transportbackPath.addCurveToPoint(CGPointMake(minX + w, minY + 0.5 * h), controlPoint1:CGPointMake(minX + 0.86446 * w, minY + 0.01514 * h), controlPoint2:CGPointMake(minX + w, minY + 0.23316 * h))
        transportbackPath.addCurveToPoint(CGPointMake(minX + 0.6758 * w, minY + h), controlPoint1:CGPointMake(minX + w, minY + 0.77614 * h), controlPoint2:CGPointMake(minX + 0.85485 * w, minY + h))
        transportbackPath.addCurveToPoint(CGPointMake(minX + 0.35228 * w, minY + 0.53253 * h), controlPoint1:CGPointMake(minX + 0.50384 * w, minY + h), controlPoint2:CGPointMake(minX + 0.36315 * w, minY + 0.79351 * h))
        transportbackPath.addCurveToPoint(CGPointMake(minX + 0.35228 * w, minY + 0.26435 * h), controlPoint1:CGPointMake(minX + 0.35184 * w, minY + 0.52178 * h), controlPoint2:CGPointMake(minX + 0.35228 * w, minY + 0.27528 * h))
        
        return transportbackPath
    }
    
    func wastebackPathWithBounds(bounds: CGRect) -> UIBezierPath{
        let wastebackPath = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        wastebackPath.moveToPoint(CGPointMake(minX, minY))
        wastebackPath.addCurveToPoint(CGPointMake(minX + 0.63116 * w, minY + 0.00353 * h), controlPoint1:CGPointMake(minX + 0.00564 * w, minY), controlPoint2:CGPointMake(minX + 0.62558 * w, minY + 0.00322 * h))
        wastebackPath.addCurveToPoint(CGPointMake(minX + w, minY + 0.50153 * h), controlPoint1:CGPointMake(minX + 0.83635 * w, minY + 0.01491 * h), controlPoint2:CGPointMake(minX + w, minY + 0.23352 * h))
        wastebackPath.addCurveToPoint(CGPointMake(minX + 0.61434 * w, minY + h), controlPoint1:CGPointMake(minX + w, minY + 0.77683 * h), controlPoint2:CGPointMake(minX + 0.82733 * w, minY + h))
        wastebackPath.addCurveToPoint(CGPointMake(minX + 0.22932 * w, minY + 0.53055 * h), controlPoint1:CGPointMake(minX + 0.40888 * w, minY + h), controlPoint2:CGPointMake(minX + 0.24094 * w, minY + 0.79234 * h))
        wastebackPath.addCurveToPoint(CGPointMake(minX + 0.22932 * w, minY + 0.3233 * h), controlPoint1:CGPointMake(minX + 0.22889 * w, minY + 0.52094 * h), controlPoint2:CGPointMake(minX + 0.22932 * w, minY + 0.33304 * h))
        
        return wastebackPath
    }
    
    func waterbackPathWithBounds(bounds: CGRect) -> UIBezierPath{
        let waterbackPath = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        waterbackPath.moveToPoint(CGPointMake(minX, minY))
        waterbackPath.addCurveToPoint(CGPointMake(minX + 0.57722 * w, minY + 0.00031 * h), controlPoint1:CGPointMake(minX + 0.0052 * w, minY), controlPoint2:CGPointMake(minX + 0.57206 * w, minY + 0.0001 * h))
        waterbackPath.addCurveToPoint(CGPointMake(minX + w, minY + 0.5 * h), controlPoint1:CGPointMake(minX + 0.8121 * w, minY + 0.00964 * h), controlPoint2:CGPointMake(minX + w, minY + 0.22979 * h))
        waterbackPath.addCurveToPoint(CGPointMake(minX + 0.56169 * w, minY + h), controlPoint1:CGPointMake(minX + w, minY + 0.77614 * h), controlPoint2:CGPointMake(minX + 0.80376 * w, minY + h))
        waterbackPath.addCurveToPoint(CGPointMake(minX + 0.12371 * w, minY + 0.51995 * h), controlPoint1:CGPointMake(minX + 0.32547 * w, minY + h), controlPoint2:CGPointMake(minX + 0.13289 * w, minY + 0.78684 * h))
        waterbackPath.addCurveToPoint(CGPointMake(minX + 0.12371 * w, minY + 0.3568 * h), controlPoint1:CGPointMake(minX + 0.12349 * w, minY + 0.51333 * h), controlPoint2:CGPointMake(minX + 0.12371 * w, minY + 0.36348 * h))
        
        return waterbackPath
    }
    
    func energybackPathWithBounds(bounds: CGRect) -> UIBezierPath{
        let energybackPath = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        energybackPath.moveToPoint(CGPointMake(minX, minY + 0.0002 * h))
        energybackPath.addCurveToPoint(CGPointMake(minX + 0.54306 * w, minY + 0.0002 * h), controlPoint1:CGPointMake(minX + 0.00846 * w, minY + 0.0002 * h), controlPoint2:CGPointMake(minX + 0.53471 * w, minY + -0.00025 * h))
        energybackPath.addCurveToPoint(CGPointMake(minX + w, minY + 0.49976 * h), controlPoint1:CGPointMake(minX + 0.79762 * w, minY + 0.0138 * h), controlPoint2:CGPointMake(minX + w, minY + 0.23226 * h))
        energybackPath.addCurveToPoint(CGPointMake(minX + 0.51784 * w, minY + h), controlPoint1:CGPointMake(minX + w, minY + 0.77604 * h), controlPoint2:CGPointMake(minX + 0.78413 * w, minY + h))
        energybackPath.addCurveToPoint(CGPointMake(minX + 0.0359 * w, minY + 0.51457 * h), controlPoint1:CGPointMake(minX + 0.25633 * w, minY + h), controlPoint2:CGPointMake(minX + 0.04344 * w, minY + 0.78399 * h))
        energybackPath.addCurveToPoint(CGPointMake(minX + 0.03569 * w, minY + 0.38173 * h), controlPoint1:CGPointMake(minX + 0.03576 * w, minY + 0.50965 * h), controlPoint2:CGPointMake(minX + 0.03569 * w, minY + 0.38668 * h))
        
        return energybackPath
    }
    
    func humanstartPathWithBounds(bounds: CGRect) -> UIBezierPath{
        let humanstartPath = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        humanstartPath.moveToPoint(CGPointMake(minX, minY + 0.00061 * h))
        humanstartPath.addCurveToPoint(CGPointMake(minX + 0.77501 * w, minY + 0.00061 * h), controlPoint1:CGPointMake(minX + 0.00766 * w, minY + 0.00061 * h), controlPoint2:CGPointMake(minX + 0.76753 * w, minY + -0.00076 * h))
        humanstartPath.addCurveToPoint(CGPointMake(minX + w, minY + 0.49927 * h), controlPoint1:CGPointMake(minX + 0.90117 * w, minY + 0.02381 * h), controlPoint2:CGPointMake(minX + w, minY + 0.23821 * h))
        humanstartPath.addCurveToPoint(CGPointMake(minX + 0.75229 * w, minY + h), controlPoint1:CGPointMake(minX + w, minY + 0.77581 * h), controlPoint2:CGPointMake(minX + 0.88909 * w, minY + h))
        humanstartPath.addCurveToPoint(CGPointMake(minX + 0.50626 * w, minY + 0.55809 * h), controlPoint1:CGPointMake(minX + 0.62532 * w, minY + h), controlPoint2:CGPointMake(minX + 0.52067 * w, minY + 0.80692 * h))
        humanstartPath.addCurveToPoint(CGPointMake(minX + 0.50626 * w, minY + 0.14819 * h), controlPoint1:CGPointMake(minX + 0.50515 * w, minY + 0.5388 * h), controlPoint2:CGPointMake(minX + 0.50626 * w, minY + 0.16809 * h))
        
        return humanstartPath
    }
    
    func transportstartPathWithBounds(bounds: CGRect) -> UIBezierPath{
        let transportstartPath = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        transportstartPath.moveToPoint(CGPointMake(minX, minY))
        transportstartPath.addCurveToPoint(CGPointMake(minX + 0.69377 * w, minY + 0.00076 * h), controlPoint1:CGPointMake(minX + 0.00603 * w, minY), controlPoint2:CGPointMake(minX + 0.68783 * w, minY + 0.00025 * h))
        transportstartPath.addCurveToPoint(CGPointMake(minX + w, minY + 0.5 * h), controlPoint1:CGPointMake(minX + 0.86446 * w, minY + 0.01514 * h), controlPoint2:CGPointMake(minX + w, minY + 0.23316 * h))
        transportstartPath.addCurveToPoint(CGPointMake(minX + 0.6758 * w, minY + h), controlPoint1:CGPointMake(minX + w, minY + 0.77614 * h), controlPoint2:CGPointMake(minX + 0.85485 * w, minY + h))
        transportstartPath.addCurveToPoint(CGPointMake(minX + 0.35228 * w, minY + 0.53253 * h), controlPoint1:CGPointMake(minX + 0.50384 * w, minY + h), controlPoint2:CGPointMake(minX + 0.36315 * w, minY + 0.79351 * h))
        transportstartPath.addCurveToPoint(CGPointMake(minX + 0.35228 * w, minY + 0.26435 * h), controlPoint1:CGPointMake(minX + 0.35184 * w, minY + 0.52178 * h), controlPoint2:CGPointMake(minX + 0.35228 * w, minY + 0.27528 * h))
        
        return transportstartPath
    }
    
    func wastestartPathWithBounds(bounds: CGRect) -> UIBezierPath{
        let wastestartPath = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        wastestartPath.moveToPoint(CGPointMake(minX, minY))
        wastestartPath.addCurveToPoint(CGPointMake(minX + 0.63116 * w, minY + 0.00353 * h), controlPoint1:CGPointMake(minX + 0.00564 * w, minY), controlPoint2:CGPointMake(minX + 0.62558 * w, minY + 0.00322 * h))
        wastestartPath.addCurveToPoint(CGPointMake(minX + w, minY + 0.50153 * h), controlPoint1:CGPointMake(minX + 0.83635 * w, minY + 0.01491 * h), controlPoint2:CGPointMake(minX + w, minY + 0.23352 * h))
        wastestartPath.addCurveToPoint(CGPointMake(minX + 0.61434 * w, minY + h), controlPoint1:CGPointMake(minX + w, minY + 0.77683 * h), controlPoint2:CGPointMake(minX + 0.82733 * w, minY + h))
        wastestartPath.addCurveToPoint(CGPointMake(minX + 0.22932 * w, minY + 0.53055 * h), controlPoint1:CGPointMake(minX + 0.40888 * w, minY + h), controlPoint2:CGPointMake(minX + 0.24094 * w, minY + 0.79234 * h))
        wastestartPath.addCurveToPoint(CGPointMake(minX + 0.22932 * w, minY + 0.3233 * h), controlPoint1:CGPointMake(minX + 0.22889 * w, minY + 0.52094 * h), controlPoint2:CGPointMake(minX + 0.22932 * w, minY + 0.33304 * h))
        
        return wastestartPath
    }
    
    func waterstartPathWithBounds(bounds: CGRect) -> UIBezierPath{
        let waterstartPath = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        waterstartPath.moveToPoint(CGPointMake(minX, minY))
        waterstartPath.addCurveToPoint(CGPointMake(minX + 0.57722 * w, minY + 0.00031 * h), controlPoint1:CGPointMake(minX + 0.0052 * w, minY), controlPoint2:CGPointMake(minX + 0.57206 * w, minY + 0.0001 * h))
        waterstartPath.addCurveToPoint(CGPointMake(minX + w, minY + 0.5 * h), controlPoint1:CGPointMake(minX + 0.8121 * w, minY + 0.00964 * h), controlPoint2:CGPointMake(minX + w, minY + 0.22979 * h))
        waterstartPath.addCurveToPoint(CGPointMake(minX + 0.56169 * w, minY + h), controlPoint1:CGPointMake(minX + w, minY + 0.77614 * h), controlPoint2:CGPointMake(minX + 0.80376 * w, minY + h))
        waterstartPath.addCurveToPoint(CGPointMake(minX + 0.12371 * w, minY + 0.51995 * h), controlPoint1:CGPointMake(minX + 0.32547 * w, minY + h), controlPoint2:CGPointMake(minX + 0.13289 * w, minY + 0.78684 * h))
        waterstartPath.addCurveToPoint(CGPointMake(minX + 0.12371 * w, minY + 0.3568 * h), controlPoint1:CGPointMake(minX + 0.12349 * w, minY + 0.51333 * h), controlPoint2:CGPointMake(minX + 0.12371 * w, minY + 0.36348 * h))
        
        return waterstartPath
    }
    
    func energystartPathWithBounds(bounds: CGRect) -> UIBezierPath{
        let energystartPath = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        energystartPath.moveToPoint(CGPointMake(minX, minY + 0.0002 * h))
        energystartPath.addCurveToPoint(CGPointMake(minX + 0.54306 * w, minY + 0.0002 * h), controlPoint1:CGPointMake(minX + 0.00846 * w, minY + 0.0002 * h), controlPoint2:CGPointMake(minX + 0.53471 * w, minY + -0.00025 * h))
        energystartPath.addCurveToPoint(CGPointMake(minX + w, minY + 0.49976 * h), controlPoint1:CGPointMake(minX + 0.79762 * w, minY + 0.0138 * h), controlPoint2:CGPointMake(minX + w, minY + 0.23226 * h))
        energystartPath.addCurveToPoint(CGPointMake(minX + 0.51784 * w, minY + h), controlPoint1:CGPointMake(minX + w, minY + 0.77604 * h), controlPoint2:CGPointMake(minX + 0.78413 * w, minY + h))
        energystartPath.addCurveToPoint(CGPointMake(minX + 0.0359 * w, minY + 0.51457 * h), controlPoint1:CGPointMake(minX + 0.25633 * w, minY + h), controlPoint2:CGPointMake(minX + 0.04344 * w, minY + 0.78399 * h))
        energystartPath.addCurveToPoint(CGPointMake(minX + 0.03569 * w, minY + 0.38173 * h), controlPoint1:CGPointMake(minX + 0.03576 * w, minY + 0.50965 * h), controlPoint2:CGPointMake(minX + 0.03569 * w, minY + 0.38668 * h))
        
        return energystartPath
    }
    
    func energystartingPathWithBounds(bounds: CGRect) -> UIBezierPath{
        if(energyscorevalue < energymaxscorevalue){
        var f: CGFloat = (180 * (CGFloat(energyscorevalue) / CGFloat(energymaxscorevalue)))
        f = f + (2 * (180 - f))
            if(f == 360){
                f = 89
            }
        let bound = bounds
        let energystartingPath = UIBezierPath(arcCenter:CGPointMake(0, 0), radius:CGRectGetWidth(bound)/2, startAngle:-90 * CGFloat(M_PI)/180, endAngle:-f * CGFloat(M_PI)/180, clockwise:true)
        var pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound))
        pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound))
        energystartingPath.applyTransform(pathTransform)
        return energystartingPath
        }else{
            let energystartingpathPath = UIBezierPath()
            let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
            
            energystartingpathPath.moveToPoint(CGPointMake(minX + 0.49985 * w, minY))
            energystartingpathPath.addCurveToPoint(CGPointMake(minX + w, minY + 0.5 * h), controlPoint1:CGPointMake(minX + 0.77608 * w, minY), controlPoint2:CGPointMake(minX + w, minY + 0.22386 * h))
            energystartingpathPath.addCurveToPoint(CGPointMake(minX + 0.49985 * w, minY + h), controlPoint1:CGPointMake(minX + w, minY + 0.77614 * h), controlPoint2:CGPointMake(minX + 0.77608 * w, minY + h))
            energystartingpathPath.addCurveToPoint(CGPointMake(minX + 0.00038 * w, minY + 0.52137 * h), controlPoint1:CGPointMake(minX + 0.23079 * w, minY + h), controlPoint2:CGPointMake(minX + 0.01157 * w, minY + 0.7876 * h))
            energystartingpathPath.addCurveToPoint(CGPointMake(minX, minY + 0.38295 * h), controlPoint1:CGPointMake(minX + 0.00008 * w, minY + 0.51429 * h), controlPoint2:CGPointMake(minX, minY + 0.39011 * h))
            
            return energystartingpathPath

        }
    }
    
    func waterstartingPathWithBounds(bounds: CGRect) -> UIBezierPath{
        if(waterscorevalue < watermaxscorevalue){
        var f: CGFloat = (180 * (CGFloat(waterscorevalue) / CGFloat(watermaxscorevalue)))
        f = f + (2 * (180 - f))
            if(f == 360){
                f = 89
            }
        let bound = bounds
        let waterstartingPath = UIBezierPath(arcCenter:CGPointMake(0, 0), radius:CGRectGetWidth(bound)/2, startAngle:-90 * CGFloat(M_PI)/180, endAngle:-f * CGFloat(M_PI)/180, clockwise:true)
        var pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound))
        pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound))
        waterstartingPath.applyTransform(pathTransform)
        return waterstartingPath
        }else{
            let waterstartingpathPath = UIBezierPath()
            let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
            
            waterstartingpathPath.moveToPoint(CGPointMake(minX + 0.50003 * w, minY))
            waterstartingpathPath.addCurveToPoint(CGPointMake(minX + w, minY + 0.5 * h), controlPoint1:CGPointMake(minX + 0.77616 * w, minY), controlPoint2:CGPointMake(minX + w, minY + 0.22386 * h))
            waterstartingpathPath.addCurveToPoint(CGPointMake(minX + 0.50003 * w, minY + h), controlPoint1:CGPointMake(minX + w, minY + 0.77614 * h), controlPoint2:CGPointMake(minX + 0.77616 * w, minY + h))
            waterstartingpathPath.addCurveToPoint(CGPointMake(minX + 0.00059 * w, minY + 0.52318 * h), controlPoint1:CGPointMake(minX + 0.23167 * w, minY + h), controlPoint2:CGPointMake(minX + 0.0127 * w, minY + 0.78856 * h))
            waterstartingpathPath.addCurveToPoint(CGPointMake(minX, minY + 0.35679 * h), controlPoint1:CGPointMake(minX + 0.00024 * w, minY + 0.5155 * h), controlPoint2:CGPointMake(minX, minY + 0.36456 * h))
            
            return waterstartingpathPath

        }
    }
    
    func wastestartingPathWithBounds(bounds: CGRect) -> UIBezierPath{
        if(wastescorevalue < wastemaxscorevalue){
        var f: CGFloat = (180 * (CGFloat(wastescorevalue) / CGFloat(wastemaxscorevalue)))
        f = f + (2 * (180 - f))
            if(f == 360){
                f = 89
            }
        let bound = bounds
        let wastestartingPath = UIBezierPath(arcCenter:CGPointMake(0, 0), radius:CGRectGetWidth(bound)/2, startAngle:-90 * CGFloat(M_PI)/180, endAngle:-f * CGFloat(M_PI)/180, clockwise:true)
        var pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound))
        pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound))
        wastestartingPath.applyTransform(pathTransform)
        return wastestartingPath
        }else{
            let wastestartingpathPath = UIBezierPath()
            let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
            
            wastestartingpathPath.moveToPoint(CGPointMake(minX + 0.50039 * w, minY))
            wastestartingpathPath.addCurveToPoint(CGPointMake(minX + w, minY + 0.5 * h), controlPoint1:CGPointMake(minX + 0.77632 * w, minY), controlPoint2:CGPointMake(minX + w, minY + 0.22386 * h))
            wastestartingpathPath.addCurveToPoint(CGPointMake(minX + 0.50039 * w, minY + h), controlPoint1:CGPointMake(minX + w, minY + 0.77614 * h), controlPoint2:CGPointMake(minX + 0.77632 * w, minY + h))
            wastestartingpathPath.addCurveToPoint(CGPointMake(minX + 0.00116 * w, minY + 0.51987 * h), controlPoint1:CGPointMake(minX + 0.23111 * w, minY + h), controlPoint2:CGPointMake(minX + 0.01158 * w, minY + 0.7868 * h))
            wastestartingpathPath.addCurveToPoint(CGPointMake(minX, minY + 0.32278 * h), controlPoint1:CGPointMake(minX + 0.0009 * w, minY + 0.51328 * h), controlPoint2:CGPointMake(minX, minY + 0.32943 * h))
            
            return wastestartingpathPath

        }

    }
    
    func transportstartingPathWithBounds(bounds: CGRect) -> UIBezierPath{
        if(transportscorevalue < transportmaxscorevalue){
        var f: CGFloat = (180 * (CGFloat(transportscorevalue) / CGFloat(transportmaxscorevalue)))
        f = f + (2 * (180 - f))
        let bound = bounds
        if(f == 360){
            f = 89
        }
        let transportstartingPath = UIBezierPath(arcCenter:CGPointMake(0, 0), radius:CGRectGetWidth(bound)/2, startAngle:-90 * CGFloat(M_PI)/180, endAngle:-f * CGFloat(M_PI)/180, clockwise:true)
        var pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound))
        pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound))
        transportstartingPath.applyTransform(pathTransform)
        return transportstartingPath
        }else{
            let transportstartingpathPath = UIBezierPath()
            let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
            
            transportstartingpathPath.moveToPoint(CGPointMake(minX + 0.4996 * w, minY))
            transportstartingpathPath.addCurveToPoint(CGPointMake(minX + w, minY + 0.5 * h), controlPoint1:CGPointMake(minX + 0.77596 * w, minY), controlPoint2:CGPointMake(minX + w, minY + 0.22386 * h))
            transportstartingpathPath.addCurveToPoint(CGPointMake(minX + 0.4996 * w, minY + h), controlPoint1:CGPointMake(minX + w, minY + 0.77614 * h), controlPoint2:CGPointMake(minX + 0.77596 * w, minY + h))
            transportstartingpathPath.addCurveToPoint(CGPointMake(minX + 0.00019 * w, minY + 0.53189 * h), controlPoint1:CGPointMake(minX + 0.23395 * w, minY + h), controlPoint2:CGPointMake(minX + 0.01665 * w, minY + 0.79317 * h))
            transportstartingpathPath.addCurveToPoint(CGPointMake(minX + 0.0005 * w, minY + 0.26452 * h), controlPoint1:CGPointMake(minX + -0.00016 * w, minY + 0.52619 * h), controlPoint2:CGPointMake(minX + -0.00001 * w, minY + 0.28875 * h))
            
            return transportstartingpathPath

        }
    }
    
    func humanstartingPathWithBounds(bounds: CGRect) -> UIBezierPath{
        if(humanscorevalue < humanmaxscorevalue){
        var f: CGFloat = (180 * (CGFloat(humanscorevalue) / CGFloat(humanmaxscorevalue)))
        f = f + (2 * (180 - f))
            if(f == 360){
                f = 89
            }
        let bound = bounds
        let humanstartingPath = UIBezierPath(arcCenter:CGPointMake(0, 0), radius:CGRectGetWidth(bound)/2, startAngle:-90 * CGFloat(M_PI)/180, endAngle:-f * CGFloat(M_PI)/180, clockwise:true)
        var pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound))
        pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound))
        humanstartingPath.applyTransform(pathTransform)
        return humanstartingPath
        }else{
            let humanstartingpathPath = UIBezierPath()
            let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
            
            humanstartingpathPath.moveToPoint(CGPointMake(minX + 0.50079 * w, minY))
            humanstartingpathPath.addCurveToPoint(CGPointMake(minX + w, minY + 0.5 * h), controlPoint1:CGPointMake(minX + 0.7765 * w, minY), controlPoint2:CGPointMake(minX + w, minY + 0.22386 * h))
            humanstartingpathPath.addCurveToPoint(CGPointMake(minX + 0.50079 * w, minY + h), controlPoint1:CGPointMake(minX + w, minY + 0.77614 * h), controlPoint2:CGPointMake(minX + 0.7765 * w, minY + h))
            humanstartingpathPath.addCurveToPoint(CGPointMake(minX + 0.00273 * w, minY + 0.53411 * h), controlPoint1:CGPointMake(minX + 0.23654 * w, minY + h), controlPoint2:CGPointMake(minX + 0.02024 * w, minY + 0.79435 * h))
            humanstartingpathPath.addCurveToPoint(CGPointMake(minX, minY + 0.15143 * h), controlPoint1:CGPointMake(minX + 0.00197 * w, minY + 0.52284 * h), controlPoint2:CGPointMake(minX, minY + 0.1629 * h))
            
            return humanstartingpathPath        }
    }
    
    func humanstartingpathPathWithBounds(bounds: CGRect) -> UIBezierPath{
        if(humanscorevalue < humanmaxscorevalue){
        var f: CGFloat = (180 * (CGFloat(humanscorevalue) / CGFloat(humanmaxscorevalue)))
        f = f + (2 * (180 - f))
            if(f == 360){
                f = 89
            }
        let bound = bounds
        let humanstartingPath = UIBezierPath(arcCenter:CGPointMake(0, 0), radius:CGRectGetWidth(bound)/2, startAngle:-90 * CGFloat(M_PI)/180, endAngle:-f * CGFloat(M_PI)/180, clockwise:true)
        var pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound))
        pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound))
        humanstartingPath.applyTransform(pathTransform)
        return humanstartingPath
        }else{
            let humanstartingpathPath = UIBezierPath()
            let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
            
            humanstartingpathPath.moveToPoint(CGPointMake(minX + 0.50079 * w, minY))
            humanstartingpathPath.addCurveToPoint(CGPointMake(minX + w, minY + 0.5 * h), controlPoint1:CGPointMake(minX + 0.7765 * w, minY), controlPoint2:CGPointMake(minX + w, minY + 0.22386 * h))
            humanstartingpathPath.addCurveToPoint(CGPointMake(minX + 0.50079 * w, minY + h), controlPoint1:CGPointMake(minX + w, minY + 0.77614 * h), controlPoint2:CGPointMake(minX + 0.7765 * w, minY + h))
            humanstartingpathPath.addCurveToPoint(CGPointMake(minX + 0.00273 * w, minY + 0.53411 * h), controlPoint1:CGPointMake(minX + 0.23654 * w, minY + h), controlPoint2:CGPointMake(minX + 0.02024 * w, minY + 0.79435 * h))
            humanstartingpathPath.addCurveToPoint(CGPointMake(minX, minY + 0.15143 * h), controlPoint1:CGPointMake(minX + 0.00197 * w, minY + 0.52284 * h), controlPoint2:CGPointMake(minX, minY + 0.1629 * h))
            
            return humanstartingpathPath        }
    }
    
    func humanstartingscorepathPathWithBounds(bounds: CGRect) -> UIBezierPath{
        if(humanscorevalue < humanmaxscorevalue){
        var f: CGFloat = (180 * (CGFloat(humanscorevalue) / CGFloat(humanmaxscorevalue)))
        f = f + (2 * (180 - f))
        let bound = bounds
            if(f == 360){
                f = 89
            }else{
                f = f + 2
            }
        let humanstartingPath = UIBezierPath(arcCenter:CGPointMake(0, 0), radius:CGRectGetWidth(bound)/2, startAngle:-90 * CGFloat(M_PI)/180, endAngle:-f * CGFloat(M_PI)/180, clockwise:true)
        var pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound))
        pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound))
        humanstartingPath.applyTransform(pathTransform)
        return humanstartingPath
        }else{
            let humanstartingpathPath = UIBezierPath()
            let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
            
            humanstartingpathPath.moveToPoint(CGPointMake(minX + 0.49992 * w, minY))
            humanstartingpathPath.addCurveToPoint(CGPointMake(minX + w, minY + 0.5 * h), controlPoint1:CGPointMake(minX + 0.7761 * w, minY), controlPoint2:CGPointMake(minX + w, minY + 0.22386 * h))
            humanstartingpathPath.addCurveToPoint(CGPointMake(minX + 0.49992 * w, minY + h), controlPoint1:CGPointMake(minX + w, minY + 0.77614 * h), controlPoint2:CGPointMake(minX + 0.7761 * w, minY + h))
            humanstartingpathPath.addCurveToPoint(CGPointMake(minX + 0.00098 * w, minY + 0.53411 * h), controlPoint1:CGPointMake(minX + 0.23519 * w, minY + h), controlPoint2:CGPointMake(minX + 0.01851 * w, minY + 0.79435 * h))
            humanstartingpathPath.addCurveToPoint(CGPointMake(minX, minY + 0.23179 * h), controlPoint1:CGPointMake(minX + 0.00022 * w, minY + 0.52284 * h), controlPoint2:CGPointMake(minX, minY + 0.24325 * h))
            
            return humanstartingpathPath
        }
    }
    
    func humanarrowPathWithBounds(bounds: CGRect) -> UIBezierPath{
        let humanarrowPath = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        humanarrowPath.moveToPoint(CGPointMake(minX, minY + h))
        humanarrowPath.addLineToPoint(CGPointMake(minX + w, minY + h))
        humanarrowPath.addLineToPoint(CGPointMake(minX + w, minY))
        humanarrowPath.closePath()
        humanarrowPath.moveToPoint(CGPointMake(minX, minY + h))
        
        return humanarrowPath
    }
    
    func transportstartingpathPathWithBounds(bounds: CGRect) -> UIBezierPath{
        if(transportscorevalue < transportmaxscorevalue){
        var f: CGFloat = (180 * (CGFloat(transportscorevalue) / CGFloat(transportmaxscorevalue)))
        f = f + (2 * (180 - f))
        print(f,transportscorevalue,transportmaxscorevalue)
        let bound = bounds
        if(f == 360){
            f = 89
        }
        let transportstartingPath = UIBezierPath(arcCenter:CGPointMake(0, 0), radius:CGRectGetWidth(bound)/2, startAngle:-90 * CGFloat(M_PI)/180, endAngle:-f * CGFloat(M_PI)/180, clockwise:true)
        var pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound))
        pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound))
        transportstartingPath.applyTransform(pathTransform)
        return transportstartingPath
        }else{
            let transportstartingpathPath = UIBezierPath()
            let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
            
            transportstartingpathPath.moveToPoint(CGPointMake(minX + 0.4996 * w, minY))
            transportstartingpathPath.addCurveToPoint(CGPointMake(minX + w, minY + 0.5 * h), controlPoint1:CGPointMake(minX + 0.77596 * w, minY), controlPoint2:CGPointMake(minX + w, minY + 0.22386 * h))
            transportstartingpathPath.addCurveToPoint(CGPointMake(minX + 0.4996 * w, minY + h), controlPoint1:CGPointMake(minX + w, minY + 0.77614 * h), controlPoint2:CGPointMake(minX + 0.77596 * w, minY + h))
            transportstartingpathPath.addCurveToPoint(CGPointMake(minX + 0.00019 * w, minY + 0.53189 * h), controlPoint1:CGPointMake(minX + 0.23395 * w, minY + h), controlPoint2:CGPointMake(minX + 0.01665 * w, minY + 0.79317 * h))
            transportstartingpathPath.addCurveToPoint(CGPointMake(minX + 0.0005 * w, minY + 0.26452 * h), controlPoint1:CGPointMake(minX + -0.00016 * w, minY + 0.52619 * h), controlPoint2:CGPointMake(minX + -0.00001 * w, minY + 0.28875 * h))
            
            return transportstartingpathPath


        }
    }
    
    func transportstartingscorepathPathWithBounds(bounds: CGRect) -> UIBezierPath{
        if(transportscorevalue < transportmaxscorevalue){
        var f: CGFloat = (180 * (CGFloat(transportscorevalue) / CGFloat(transportmaxscorevalue)))
        f = f + (2 * (180 - f))
        print(f,transportscorevalue,transportmaxscorevalue)
        let bound = bounds
        if(f == 360){
            f = 89
        }else{
            f = f + 2
        }
        let transportstartingPath = UIBezierPath(arcCenter:CGPointMake(0, 0), radius:CGRectGetWidth(bound)/2, startAngle:-90 * CGFloat(M_PI)/180, endAngle:-f * CGFloat(M_PI)/180, clockwise:true)
        var pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound))
        pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound))
        transportstartingPath.applyTransform(pathTransform)
        return transportstartingPath
        }else{
            let transportstartingpathPath = UIBezierPath()
            let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
            
            transportstartingpathPath.moveToPoint(CGPointMake(minX + 0.4999 * w, minY))
            transportstartingpathPath.addCurveToPoint(CGPointMake(minX + w, minY + 0.5 * h), controlPoint1:CGPointMake(minX + 0.7761 * w, minY), controlPoint2:CGPointMake(minX + w, minY + 0.22386 * h))
            transportstartingpathPath.addCurveToPoint(CGPointMake(minX + 0.4999 * w, minY + h), controlPoint1:CGPointMake(minX + w, minY + 0.77614 * h), controlPoint2:CGPointMake(minX + 0.7761 * w, minY + h))
            transportstartingpathPath.addCurveToPoint(CGPointMake(minX + 0.0008 * w, minY + 0.53189 * h), controlPoint1:CGPointMake(minX + 0.23442 * w, minY + h), controlPoint2:CGPointMake(minX + 0.01725 * w, minY + 0.79317 * h))
            transportstartingpathPath.addCurveToPoint(CGPointMake(minX + 0.00059 * w, minY + 0.32168 * h), controlPoint1:CGPointMake(minX + 0.00014 * w, minY + 0.52134 * h), controlPoint2:CGPointMake(minX + -0.0005 * w, minY + 0.37437 * h))
            
            return transportstartingpathPath

        }
    }
    
    func transportarrowPathWithBounds(bounds: CGRect) -> UIBezierPath{
        let transportarrowPath = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        transportarrowPath.moveToPoint(CGPointMake(minX, minY + h))
        transportarrowPath.addLineToPoint(CGPointMake(minX + w, minY + h))
        transportarrowPath.addLineToPoint(CGPointMake(minX + w, minY))
        transportarrowPath.closePath()
        transportarrowPath.moveToPoint(CGPointMake(minX, minY + h))
        
        return transportarrowPath
    }
    
    func wastestartingpathPathWithBounds(bounds: CGRect) -> UIBezierPath{
        if(wastescorevalue < wastemaxscorevalue){
        var f: CGFloat = (180 * (CGFloat(wastescorevalue) / CGFloat(wastemaxscorevalue)))
        f = f + (2 * (180 - f))
            if(f == 360){
                f = 89
            }
        let bound = bounds
        let wastestartingPath = UIBezierPath(arcCenter:CGPointMake(0, 0), radius:CGRectGetWidth(bound)/2, startAngle:-90 * CGFloat(M_PI)/180, endAngle:-f * CGFloat(M_PI)/180, clockwise:true)
        var pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound))
        pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound))
        wastestartingPath.applyTransform(pathTransform)
        return wastestartingPath
        }else{
            let wastestartingpathPath = UIBezierPath()
            let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
            
            wastestartingpathPath.moveToPoint(CGPointMake(minX + 0.50039 * w, minY))
            wastestartingpathPath.addCurveToPoint(CGPointMake(minX + w, minY + 0.5 * h), controlPoint1:CGPointMake(minX + 0.77632 * w, minY), controlPoint2:CGPointMake(minX + w, minY + 0.22386 * h))
            wastestartingpathPath.addCurveToPoint(CGPointMake(minX + 0.50039 * w, minY + h), controlPoint1:CGPointMake(minX + w, minY + 0.77614 * h), controlPoint2:CGPointMake(minX + 0.77632 * w, minY + h))
            wastestartingpathPath.addCurveToPoint(CGPointMake(minX + 0.00116 * w, minY + 0.51987 * h), controlPoint1:CGPointMake(minX + 0.23111 * w, minY + h), controlPoint2:CGPointMake(minX + 0.01158 * w, minY + 0.7868 * h))
            wastestartingpathPath.addCurveToPoint(CGPointMake(minX, minY + 0.32278 * h), controlPoint1:CGPointMake(minX + 0.0009 * w, minY + 0.51328 * h), controlPoint2:CGPointMake(minX, minY + 0.32943 * h))
            
            return wastestartingpathPath

        }
    }
    
    
    func wastestartingscorepathPathWithBounds(bounds: CGRect) -> UIBezierPath{
        if(wastescorevalue < wastemaxscorevalue){
        var f: CGFloat = (180 * (CGFloat(wastescorevalue) / CGFloat(wastemaxscorevalue)))
        f = f + (2 * (180 - f))
        let bound = bounds
        if(f == 360){
            f = 89
        }else{
            f = f + 2
        }
        let wastestartingPath = UIBezierPath(arcCenter:CGPointMake(0, 0), radius:CGRectGetWidth(bound)/2, startAngle:-90 * CGFloat(M_PI)/180, endAngle:-f * CGFloat(M_PI)/180, clockwise:true)
        var pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound))
        pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound))
        wastestartingPath.applyTransform(pathTransform)
        return wastestartingPath
        }else{
            let wastestartingpathPath = UIBezierPath()
            let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
            
            wastestartingpathPath.moveToPoint(CGPointMake(minX + 0.50088 * w, minY))
            wastestartingpathPath.addCurveToPoint(CGPointMake(minX + w, minY + 0.5 * h), controlPoint1:CGPointMake(minX + 0.77653 * w, minY), controlPoint2:CGPointMake(minX + w, minY + 0.22386 * h))
            wastestartingpathPath.addCurveToPoint(CGPointMake(minX + 0.50088 * w, minY + h), controlPoint1:CGPointMake(minX + w, minY + 0.77614 * h), controlPoint2:CGPointMake(minX + 0.77653 * w, minY + h))
            wastestartingpathPath.addCurveToPoint(CGPointMake(minX + 0.00214 * w, minY + 0.51987 * h), controlPoint1:CGPointMake(minX + 0.23186 * w, minY + h), controlPoint2:CGPointMake(minX + 0.01255 * w, minY + 0.7868 * h))
            wastestartingpathPath.addCurveToPoint(CGPointMake(minX + 0.00001 * w, minY + 0.36157 * h), controlPoint1:CGPointMake(minX + 0.00188 * w, minY + 0.51328 * h), controlPoint2:CGPointMake(minX + -0.00014 * w, minY + 0.45724 * h))
            
            return wastestartingpathPath
        }
    }
    
    func wastearrowPathWithBounds(bounds: CGRect) -> UIBezierPath{
        let wastearrowPath = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        wastearrowPath.moveToPoint(CGPointMake(minX, minY + h))
        wastearrowPath.addLineToPoint(CGPointMake(minX + w, minY + h))
        wastearrowPath.addLineToPoint(CGPointMake(minX + w, minY))
        wastearrowPath.closePath()
        wastearrowPath.moveToPoint(CGPointMake(minX, minY + h))
        
        return wastearrowPath
    }
    
    func waterstartingpathPathWithBounds(bounds: CGRect) -> UIBezierPath{
        if(waterscorevalue < watermaxscorevalue){
        var f: CGFloat = (180 * (CGFloat(waterscorevalue) / CGFloat(watermaxscorevalue)))
        f = f + (2 * (180 - f))
            if(f == 360){
                f = 89
            }
        let bound = bounds
        let waterstartingPath = UIBezierPath(arcCenter:CGPointMake(0, 0), radius:CGRectGetWidth(bound)/2, startAngle:-90 * CGFloat(M_PI)/180, endAngle:-f * CGFloat(M_PI)/180, clockwise:true)
        var pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound))
        pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound))
        waterstartingPath.applyTransform(pathTransform)
        return waterstartingPath
        }else{
            let waterstartingpathPath = UIBezierPath()
            let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
            
            waterstartingpathPath.moveToPoint(CGPointMake(minX + 0.50003 * w, minY))
            waterstartingpathPath.addCurveToPoint(CGPointMake(minX + w, minY + 0.5 * h), controlPoint1:CGPointMake(minX + 0.77616 * w, minY), controlPoint2:CGPointMake(minX + w, minY + 0.22386 * h))
            waterstartingpathPath.addCurveToPoint(CGPointMake(minX + 0.50003 * w, minY + h), controlPoint1:CGPointMake(minX + w, minY + 0.77614 * h), controlPoint2:CGPointMake(minX + 0.77616 * w, minY + h))
            waterstartingpathPath.addCurveToPoint(CGPointMake(minX + 0.00059 * w, minY + 0.52318 * h), controlPoint1:CGPointMake(minX + 0.23167 * w, minY + h), controlPoint2:CGPointMake(minX + 0.0127 * w, minY + 0.78856 * h))
            waterstartingpathPath.addCurveToPoint(CGPointMake(minX, minY + 0.35679 * h), controlPoint1:CGPointMake(minX + 0.00024 * w, minY + 0.5155 * h), controlPoint2:CGPointMake(minX, minY + 0.36456 * h))
            
            return waterstartingpathPath

        }
    }
    
    func waterstartingscorepathPathWithBounds(bounds: CGRect) -> UIBezierPath{
        if(waterscorevalue < watermaxscorevalue){
        var f: CGFloat = (180 * (CGFloat(waterscorevalue) / CGFloat(watermaxscorevalue)))
        f = f + (2 * (180 - f))
        let bound = bounds
        if(f == 360){
            f = 89
        }else{
            f = f + 2
        }
        let waterstartingPath = UIBezierPath(arcCenter:CGPointMake(0, 0), radius:CGRectGetWidth(bound)/2, startAngle:-90 * CGFloat(M_PI)/180, endAngle:-f * CGFloat(M_PI)/180, clockwise:true)
        var pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound))
        pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound))
        waterstartingPath.applyTransform(pathTransform)
        return waterstartingPath
        }else{
            let waterstartingpathPath = UIBezierPath()
            let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
            
            waterstartingpathPath.moveToPoint(CGPointMake(minX + 0.49979 * w, minY))
            waterstartingpathPath.addCurveToPoint(CGPointMake(minX + w, minY + 0.5 * h), controlPoint1:CGPointMake(minX + 0.77605 * w, minY), controlPoint2:CGPointMake(minX + w, minY + 0.22386 * h))
            waterstartingpathPath.addCurveToPoint(CGPointMake(minX + 0.49979 * w, minY + h), controlPoint1:CGPointMake(minX + w, minY + 0.77614 * h), controlPoint2:CGPointMake(minX + 0.77605 * w, minY + h))
            waterstartingpathPath.addCurveToPoint(CGPointMake(minX + 0.00012 * w, minY + 0.52318 * h), controlPoint1:CGPointMake(minX + 0.23131 * w, minY + h), controlPoint2:CGPointMake(minX + 0.01223 * w, minY + 0.78856 * h))
            waterstartingpathPath.addCurveToPoint(CGPointMake(minX + 0.00087 * w, minY + 0.38727 * h), controlPoint1:CGPointMake(minX + -0.00024 * w, minY + 0.5155 * h), controlPoint2:CGPointMake(minX + 0.00027 * w, minY + 0.46792 * h))
            
            return waterstartingpathPath
        }
    }
    
    func waterarrowPathWithBounds(bounds: CGRect) -> UIBezierPath{
        let waterarrowPath = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        waterarrowPath.moveToPoint(CGPointMake(minX, minY + h))
        waterarrowPath.addLineToPoint(CGPointMake(minX + w, minY + h))
        waterarrowPath.addLineToPoint(CGPointMake(minX + w, minY))
        waterarrowPath.closePath()
        waterarrowPath.moveToPoint(CGPointMake(minX, minY + h))
        
        return waterarrowPath
    }
    
    func energystartingscorepathPathWithBounds(bounds: CGRect) -> UIBezierPath{
        if(energyscorevalue < energymaxscorevalue){
        var f: CGFloat = (180 * (CGFloat(energyscorevalue) / CGFloat(energymaxscorevalue)))
        f = f + (2 * (180 - f))
        let bound = bounds
        if(f == 360){
            f = 89
        }else{
            f = f + 2
        }
        let energystartingPath = UIBezierPath(arcCenter:CGPointMake(0, 0), radius:CGRectGetWidth(bound)/2, startAngle:-90 * CGFloat(M_PI)/180, endAngle:-f * CGFloat(M_PI)/180, clockwise:true)
        var pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound))
        pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound))
        energystartingPath.applyTransform(pathTransform)
        return energystartingPath
        }else{
            let energystartingpathPath = UIBezierPath()
            let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
            
            energystartingpathPath.moveToPoint(CGPointMake(minX + 0.49987 * w, minY))
            energystartingpathPath.addCurveToPoint(CGPointMake(minX + w, minY + 0.5 * h), controlPoint1:CGPointMake(minX + 0.77608 * w, minY), controlPoint2:CGPointMake(minX + w, minY + 0.22386 * h))
            energystartingpathPath.addCurveToPoint(CGPointMake(minX + 0.49987 * w, minY + h), controlPoint1:CGPointMake(minX + w, minY + 0.77614 * h), controlPoint2:CGPointMake(minX + 0.77608 * w, minY + h))
            energystartingpathPath.addCurveToPoint(CGPointMake(minX + 0.00041 * w, minY + 0.52137 * h), controlPoint1:CGPointMake(minX + 0.23082 * w, minY + h), controlPoint2:CGPointMake(minX + 0.0116 * w, minY + 0.7876 * h))
            energystartingpathPath.addCurveToPoint(CGPointMake(minX + 0.00026 * w, minY + 0.40481 * h), controlPoint1:CGPointMake(minX + 0.00011 * w, minY + 0.51429 * h), controlPoint2:CGPointMake(minX + -0.00026 * w, minY + 0.46106 * h))
            
            return energystartingpathPath

        }
    }
    
    func energystartingpathPathWithBounds(bounds: CGRect) -> UIBezierPath{
        if(energyscorevalue < energymaxscorevalue){
        var f: CGFloat = (180 * (CGFloat(energyscorevalue) / CGFloat(energymaxscorevalue)))
        f = f + (2 * (180 - f))
        let bound = bounds
        if(f == 360){
            f = 89
        }
        let energystartingPath = UIBezierPath(arcCenter:CGPointMake(0, 0), radius:CGRectGetWidth(bound)/2, startAngle:-90 * CGFloat(M_PI)/180, endAngle:-f * CGFloat(M_PI)/180, clockwise:true)
        var pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound))
        pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound))
        energystartingPath.applyTransform(pathTransform)
        return energystartingPath
        }else{
            let energystartingpathPath = UIBezierPath()
            let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
            
            energystartingpathPath.moveToPoint(CGPointMake(minX + 0.49985 * w, minY))
            energystartingpathPath.addCurveToPoint(CGPointMake(minX + w, minY + 0.5 * h), controlPoint1:CGPointMake(minX + 0.77608 * w, minY), controlPoint2:CGPointMake(minX + w, minY + 0.22386 * h))
            energystartingpathPath.addCurveToPoint(CGPointMake(minX + 0.49985 * w, minY + h), controlPoint1:CGPointMake(minX + w, minY + 0.77614 * h), controlPoint2:CGPointMake(minX + 0.77608 * w, minY + h))
            energystartingpathPath.addCurveToPoint(CGPointMake(minX + 0.00038 * w, minY + 0.52137 * h), controlPoint1:CGPointMake(minX + 0.23079 * w, minY + h), controlPoint2:CGPointMake(minX + 0.01157 * w, minY + 0.7876 * h))
            energystartingpathPath.addCurveToPoint(CGPointMake(minX, minY + 0.38295 * h), controlPoint1:CGPointMake(minX + 0.00008 * w, minY + 0.51429 * h), controlPoint2:CGPointMake(minX, minY + 0.39011 * h))
            
            return energystartingpathPath

        }
    }
    
    func energyarrowPathWithBounds(bounds: CGRect) -> UIBezierPath{
        let energyarrowPath = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        energyarrowPath.moveToPoint(CGPointMake(minX, minY + h))
        energyarrowPath.addLineToPoint(CGPointMake(minX + w, minY + h))
        energyarrowPath.addLineToPoint(CGPointMake(minX + w, minY))
        energyarrowPath.closePath()
        energyarrowPath.moveToPoint(CGPointMake(minX, minY + h))
        
        return energyarrowPath
    }
    
    
}
