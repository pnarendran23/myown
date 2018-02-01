//
//  individual.swift
//
//  Code generated using QuartzCode 1.52.0 on 19/01/17.
//  www.quartzcodeapp.com
//

import UIKit


class individual: UIView {
    var localavgscorevalue = 0
    var globalavgscorevalue = 0
    var outerscorevalue = 0
    var outermaxscorevalue = 0
    var middlescorevalue = 0
    var middlemaxscorevalue = 0
    var innerscorevalue = 0
    var innerstrokes = UIColor.whiteColor()
    var innermaxscorevalue = 0
    var layers : Dictionary<String, AnyObject> = [:]
    var completionBlocks : Dictionary<CAAnimation, (Bool) -> Void> = [:]
    var updateLayerValueForCompletedAnimation : Bool = false
    var middlelabelvalue = ""
    var innerlabelvalue = ""
    var titlevalue = ""
    var context1value = ""
    var context2value = ""
    var strokecolor = UIColor.blackColor()
    var categoryimg = UIImage.init(named: "energy")!
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
        self.backgroundColor = UIColor.clearColor()
        //.lineWidth = (0.127 * self.frame.size.width)/3
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.LongStyle
        formatter.dateFormat = "MMMM"
        let dateString = formatter.stringFromDate(NSDate())
        
        print("date string",dateString)
        var date = NSDate()
        let unitFlags: NSCalendarUnit = [.Hour, .Day, .Month, .Year]
        var components = NSCalendar.currentCalendar().components(unitFlags, fromDate: date)
        print(components.year-1)
        innerlabelvalue = "\(dateString.uppercaseString) \(components.year - 1)"
        components.month = components.month - 1
        var d = NSCalendar.currentCalendar().dateFromComponents(components)
        formatter.dateFormat = "MMMM yyyy"
        print(formatter.stringFromDate(d!))
        middlelabelvalue = "\(formatter.stringFromDate(d!).uppercaseString)"
        if let Group : CALayer = layers["Group"] as? CALayer{
            Group.frame = CGRectMake(0.08667 * Group.superlayer!.bounds.width, 0.08667 * Group.superlayer!.bounds.height, 0.87833 * Group.superlayer!.bounds.width, 0.84 * Group.superlayer!.bounds.height)
        }
        
        if let oval : CAShapeLayer = layers["oval"] as? CAShapeLayer{
            oval.frame = CGRectMake(0.37951 * oval.superlayer!.bounds.width, 0.39683 * oval.superlayer!.bounds.height, 0.19734 * oval.superlayer!.bounds.width, 0.20635 * oval.superlayer!.bounds.height)
            oval.path  = ovalPathWithBounds((layers["oval"] as! CAShapeLayer).bounds).CGPath
        }
        
        if let innerback : CAShapeLayer = layers["innerback"] as? CAShapeLayer{
            innerback.frame = CGRectMake(0.0898 * innerback.superlayer!.bounds.width, 0.36124 * innerback.superlayer!.bounds.height, 0.5212 * innerback.superlayer!.bounds.width, 0.27765 * innerback.superlayer!.bounds.height)
            innerback.path  = innerbackPathWithBounds((layers["innerback"] as! CAShapeLayer).bounds).CGPath
            innerback.lineWidth = (0.127 * self.frame.size.width)/3
        }
        
        if let middleback : CAShapeLayer = layers["middleback"] as? CAShapeLayer{
            middleback.frame = CGRectMake(0.09056 * middleback.superlayer!.bounds.width, 0.30204 * middleback.superlayer!.bounds.height, 0.57737 * middleback.superlayer!.bounds.width, 0.39637 * middleback.superlayer!.bounds.height)
            middleback.path  = middlebackPathWithBounds((layers["middleback"] as! CAShapeLayer).bounds).CGPath
            middleback.lineWidth = (0.127 * self.frame.size.width)/3
        }
        
        if let outerback : CAShapeLayer = layers["outerback"] as? CAShapeLayer{
            outerback.frame = CGRectMake(0.09143 * outerback.superlayer!.bounds.width, 0.18254 * outerback.superlayer!.bounds.height, 0.69035 * outerback.superlayer!.bounds.width, 0.63492 * outerback.superlayer!.bounds.height)
            outerback.path  = outerbackPathWithBounds((layers["outerback"] as! CAShapeLayer).bounds).CGPath
            outerback.lineWidth = (0.143 * self.frame.size.width)
        }
        
        if let innerstart : CAShapeLayer = layers["innerstart"] as? CAShapeLayer{
            innerstart.frame = CGRectMake(0.0898 * innerstart.superlayer!.bounds.width, 0.36124 * innerstart.superlayer!.bounds.height, 0.5212 * innerstart.superlayer!.bounds.width, 0.27765 * innerstart.superlayer!.bounds.height)
            innerstart.path  = innerstartPathWithBounds((layers["innerstart"] as! CAShapeLayer).bounds).CGPath
            innerstart.lineWidth = (0.127 * self.frame.size.width)/3
            if(innerscorevalue == 0 ){
                innerstart.hidden = true
            }else{
                innerstart.hidden = false
            }
            innerstart.strokeColor = innerstrokes.CGColor
        }
        
        if let middlestart : CAShapeLayer = layers["middlestart"] as? CAShapeLayer{
            middlestart.frame = CGRectMake(0.09056 * middlestart.superlayer!.bounds.width, 0.30204 * middlestart.superlayer!.bounds.height, 0.57737 * middlestart.superlayer!.bounds.width, 0.39637 * middlestart.superlayer!.bounds.height)
            middlestart.path  = middlestartPathWithBounds((layers["middlestart"] as! CAShapeLayer).bounds).CGPath
            middlestart.lineWidth = (0.127 * self.frame.size.width)/3
            if(middlescorevalue == 0 ){
                middlestart.hidden = true
            }else{
                middlestart.hidden = false
            }
            middlestart.strokeColor = innerstrokes.CGColor
        }
        
        if let outerstart : CAShapeLayer = layers["outerstart"] as? CAShapeLayer{
            outerstart.frame = CGRectMake(0.09143 * outerstart.superlayer!.bounds.width, 0.18254 * outerstart.superlayer!.bounds.height, 0.69035 * outerstart.superlayer!.bounds.width, 0.63492 * outerstart.superlayer!.bounds.height)
            outerstart.path  = outerstartPathWithBounds((layers["outerstart"] as! CAShapeLayer).bounds).CGPath
            outerstart.lineWidth = (0.143 * self.frame.size.width)
            if(outerscorevalue == 0 ){
                outerstart.hidden = true
            }else{
                outerstart.hidden = false
            }
            outerstart.strokeColor = strokecolor.CGColor
        }
        
        if let innerstarting : CAShapeLayer = layers["innerstarting"] as? CAShapeLayer{
            innerstarting.frame = CGRectMake(0.34535 * innerstarting.superlayer!.bounds.width, 0.36111 * innerstarting.superlayer!.bounds.height, 0.26565 * innerstarting.superlayer!.bounds.width, 0.27778 * innerstarting.superlayer!.bounds.height)
            innerstarting.path  = innerstartingPathWithBounds((layers["innerstarting"] as! CAShapeLayer).bounds).CGPath
            innerstarting.lineWidth = (0.127 * self.frame.size.width)/3
            if(innerscorevalue == 0 ){
                innerstarting.hidden = true
            }else{
                innerstarting.hidden = false
            }
            innerstarting.strokeColor = innerstrokes.CGColor
        }
        
        if let middlestarting : CAShapeLayer = layers["middlestarting"] as? CAShapeLayer{
            middlestarting.frame = CGRectMake(0.28843 * middlestarting.superlayer!.bounds.width, 0.30159 * middlestarting.superlayer!.bounds.height, 0.37951 * middlestarting.superlayer!.bounds.width, 0.39683 * middlestarting.superlayer!.bounds.height)
            middlestarting.path  = middlestartingPathWithBounds((layers["middlestarting"] as! CAShapeLayer).bounds).CGPath
            middlestarting.lineWidth = (0.127 * self.frame.size.width)/3
            if(middlescorevalue == 0 ){
                middlestarting.hidden = true
            }else{
                middlestarting.hidden = false
            }
            middlestarting.strokeColor = innerstrokes.CGColor
        }
        
        if let outerstarting : CAShapeLayer = layers["outerstarting"] as? CAShapeLayer{
            outerstarting.frame = CGRectMake(0.17457 * outerstarting.superlayer!.bounds.width, 0.18254 * outerstarting.superlayer!.bounds.height, 0.60721 * outerstarting.superlayer!.bounds.width, 0.63492 * outerstarting.superlayer!.bounds.height)
            outerstarting.path  = outerstartingPathWithBounds((layers["outerstarting"] as! CAShapeLayer).bounds).CGPath
            outerstarting.lineWidth = (0.143 * self.frame.size.width)
            if(outerscorevalue == 0 ){
                outerstarting.hidden = true
            }else{
                outerstarting.hidden = false
            }
            outerstarting.strokeColor = strokecolor.CGColor
        }
        
        if let title : CATextLayer = layers["title"] as? CATextLayer{
            title.frame = CGRectMake(0.39455 * title.superlayer!.bounds.width, 0.47046 * title.superlayer!.bounds.height, 0.17527 * title.superlayer!.bounds.width, 0.07308 * title.superlayer!.bounds.height)
            title.fontSize = (0.52 * title.bounds.height)/2.4
            title.string = titlevalue            
        }
        
        if let img : CALayer = layers["img"] as? CALayer{
            img.frame = CGRectMake(0.09810 * img.superlayer!.bounds.width, 0.10762 * img.superlayer!.bounds.height, 0.03439 * img.superlayer!.bounds.height, 0.03439 * img.superlayer!.bounds.height)
            img.contents = categoryimg.CGImage
        }
        
        if let context1 : CATextLayer = layers["context1"] as? CATextLayer{
            context1.frame = CGRectMake(0.13674 * context1.superlayer!.bounds.width, 0.11536 * context1.superlayer!.bounds.height, 0.26001 * context1.superlayer!.bounds.width, 0.03968 * context1.superlayer!.bounds.height)
            context1.fontSize = (0.25 * context1.superlayer!.bounds.height)/11
            context1.string = context1value
        }
        
        if let context2 : CATextLayer = layers["context2"] as? CATextLayer{
            context2.frame = CGRectMake(0.13195 * context2.superlayer!.bounds.width, 0.151 * context2.superlayer!.bounds.height, 0.2848 * context2.superlayer!.bounds.width, 0.07285 * context2.superlayer!.bounds.height)
            context2.fontSize = (0.25 * context2.superlayer!.bounds.height)/13
            context2.string = context2value
        }
        
        if let middlelabel : CATextLayer = layers["middlelabel"] as? CATextLayer{
            middlelabel.frame = CGRectMake(0.11195 * middlelabel.superlayer!.bounds.width, 0.2922 * middlelabel.superlayer!.bounds.height, 0.18975 * middlelabel.superlayer!.bounds.width, 0.03968 * middlelabel.superlayer!.bounds.height)
            middlelabel.fontSize = (0.25 * middlelabel.superlayer!.bounds.height)/11
            middlelabel.string = middlelabelvalue
        }
        
        if let innerlabel : CATextLayer = layers["innerlabel"] as? CATextLayer{
            innerlabel.frame = CGRectMake(0.11195 * innerlabel.superlayer!.bounds.width, 0.35524 * innerlabel.superlayer!.bounds.height, 0.18975 * innerlabel.superlayer!.bounds.width, 0.03968 * innerlabel.superlayer!.bounds.height)
            innerlabel.fontSize = (0.25 * innerlabel.superlayer!.bounds.height)/11
            innerlabel.string = innerlabelvalue
        }
        
        if let outermaxscore : CATextLayer = layers["outermaxscore"] as? CATextLayer{
            outermaxscore.frame = CGRectMake(0.1575 * outermaxscore.superlayer!.bounds.width, 0.4127 * outermaxscore.superlayer!.bounds.height, 0.03036 * outermaxscore.superlayer!.bounds.width, 0.03175 * outermaxscore.superlayer!.bounds.height)
            outermaxscore.fontSize = (0.25 * outermaxscore.superlayer!.bounds.height)/10
            outermaxscore.string = "\(outermaxscorevalue)"
        }
        
        if let middlemaxscore : CATextLayer = layers["middlemaxscore"] as? CATextLayer{
            middlemaxscore.frame = CGRectMake(0.27434 * middlemaxscore.superlayer!.bounds.width, 0.4127 * middlemaxscore.superlayer!.bounds.height, 0.03036 * middlemaxscore.superlayer!.bounds.width, 0.03175 * middlemaxscore.superlayer!.bounds.height)
            middlemaxscore.fontSize = (0.25 * middlemaxscore.superlayer!.bounds.height)/10
            middlemaxscore.string = "\(middlemaxscorevalue)"
        }
        
        if let innermaxscore : CATextLayer = layers["innermaxscore"] as? CATextLayer{
            innermaxscore.frame = CGRectMake(0.33017 * innermaxscore.superlayer!.bounds.width, 0.4127 * innermaxscore.superlayer!.bounds.height, 0.03036 * innermaxscore.superlayer!.bounds.width, 0.03175 * innermaxscore.superlayer!.bounds.height)
            innermaxscore.fontSize = (0.25 * innermaxscore.superlayer!.bounds.height)/10
            innermaxscore.string = "\(innermaxscorevalue)"
        }
        
        if let innerarrow : CAShapeLayer = layers["innerarrow"] as? CAShapeLayer{
            innerarrow.transform = CATransform3DIdentity
            innerarrow.frame     = CGRectMake(0.4611 * innerarrow.superlayer!.bounds.width, 0.34681 * innerarrow.superlayer!.bounds.height, 0.03036 * innerarrow.superlayer!.bounds.width, 0.03175 * innerarrow.superlayer!.bounds.height)
            innerarrow.setValue(-45 * CGFloat(M_PI)/180, forKeyPath:"transform.rotation")
            innerarrow.path      = innerarrowPathWithBounds((layers["innerarrow"] as! CAShapeLayer).bounds).CGPath
            if(innerscorevalue == 0 ){
                innerarrow.hidden = true
            }else{
                innerarrow.hidden = false
            }
            innerarrow.fillColor = innerstrokes.CGColor
        }
        
        if let innerstartingpath : CAShapeLayer = layers["innerstartingpath"] as? CAShapeLayer{
            innerstartingpath.frame = CGRectMake(0.34535 * innerstartingpath.superlayer!.bounds.width, 0.36111 * innerstartingpath.superlayer!.bounds.height, 0.26565 * innerstartingpath.superlayer!.bounds.width, 0.27778 * innerstartingpath.superlayer!.bounds.height)
            innerstartingpath.path  = innerstartingpathPathWithBounds((layers["innerstartingpath"] as! CAShapeLayer).bounds).CGPath
        }
        
        if let middlestartingpath : CAShapeLayer = layers["middlestartingpath"] as? CAShapeLayer{
            middlestartingpath.frame = CGRectMake(0.28843 * middlestartingpath.superlayer!.bounds.width, 0.30159 * middlestartingpath.superlayer!.bounds.height, 0.37951 * middlestartingpath.superlayer!.bounds.width, 0.39683 * middlestartingpath.superlayer!.bounds.height)
            middlestartingpath.path  = middlestartingpathPathWithBounds((layers["middlestartingpath"] as! CAShapeLayer).bounds).CGPath
        }
        
        if let outerstartingpath : CAShapeLayer = layers["outerstartingpath"] as? CAShapeLayer{
            outerstartingpath.frame = CGRectMake(0.17457 * outerstartingpath.superlayer!.bounds.width, 0.18254 * outerstartingpath.superlayer!.bounds.height, 0.60721 * outerstartingpath.superlayer!.bounds.width, 0.63492 * outerstartingpath.superlayer!.bounds.height)
            outerstartingpath.path  = outerstartingpathPathWithBounds((layers["outerstartingpath"] as! CAShapeLayer).bounds).CGPath
        }
        
        if let middlearrow : CAShapeLayer = layers["middlearrow"] as? CAShapeLayer{
            middlearrow.transform = CATransform3DIdentity
            middlearrow.frame     = CGRectMake(0.4611 * middlearrow.superlayer!.bounds.width, 0.34681 * middlearrow.superlayer!.bounds.height, 0.03036 * middlearrow.superlayer!.bounds.width, 0.03175 * middlearrow.superlayer!.bounds.height)
            middlearrow.setValue(-45 * CGFloat(M_PI)/180, forKeyPath:"transform.rotation")
            middlearrow.path      = middlearrowPathWithBounds((layers["middlearrow"] as! CAShapeLayer).bounds).CGPath
            if(middlescorevalue == 0 ){
                middlearrow.hidden = true
            }else{
                middlearrow.hidden = false
            }
            middlearrow.fillColor = innerstrokes.CGColor
        }
        
        if let outerarrow : CAShapeLayer = layers["outerarrow"] as? CAShapeLayer{
            outerarrow.transform = CATransform3DIdentity
            outerarrow.frame     = CGRectMake(0.4439 * outerarrow.superlayer!.bounds.width, 0.76744 * outerarrow.superlayer!.bounds.height, 0.11385 * outerarrow.superlayer!.bounds.width, 0.11905 * outerarrow.superlayer!.bounds.height)
            outerarrow.setValue(-45 * CGFloat(M_PI)/180, forKeyPath:"transform.rotation")
            outerarrow.path      = outerarrowPathWithBounds((layers["outerarrow"] as! CAShapeLayer).bounds).CGPath
            if(outerscorevalue == 0 ){
                outerarrow.hidden = true
            }else{
                outerarrow.hidden = false
            }
            outerarrow.fillColor = strokecolor.CGColor
        }
        
        if let global : CALayer = layers["global"] as? CALayer{
            global.frame = CGRectMake(0.90512 * global.superlayer!.bounds.width, 0.46055 * global.superlayer!.bounds.height, 0.09488 * global.superlayer!.bounds.width, 0.09921 * global.superlayer!.bounds.height)
        }
        
        if let local : CALayer = layers["local"] as? CALayer{
            local.frame = CGRectMake(0.5023 * local.superlayer!.bounds.width, 0.27901 * local.superlayer!.bounds.height, 0.09488 * local.superlayer!.bounds.width, 0.09921 * local.superlayer!.bounds.height)
        }
        
        if let globalneedle : CALayer = layers["globalneedle"] as? CALayer{
            globalneedle.transform = CATransform3DIdentity
            globalneedle.frame     = CGRectMake(0.96584 * globalneedle.superlayer!.bounds.width, 0.2822 * globalneedle.superlayer!.bounds.height, 0.03036 * globalneedle.superlayer!.bounds.width, 0.0254 * globalneedle.superlayer!.bounds.height)
            globalneedle.setValue(-60 * CGFloat(M_PI)/180, forKeyPath:"transform.rotation")
        }
        
        if let localneedle : CALayer = layers["localneedle"] as? CALayer{
            localneedle.transform = CATransform3DIdentity
            localneedle.frame     = CGRectMake(0.87097 * localneedle.superlayer!.bounds.width, 0.20206 * localneedle.superlayer!.bounds.height, 0.03036 * localneedle.superlayer!.bounds.width, 0.0254 * localneedle.superlayer!.bounds.height)
            localneedle.setValue(-60 * CGFloat(M_PI)/180, forKeyPath:"transform.rotation")
        }
        
        if let localavgscorepath : CAShapeLayer = layers["localavgscorepath"] as? CAShapeLayer{
            localavgscorepath.frame = CGRectMake(0.17457 * localavgscorepath.superlayer!.bounds.width, 0.18254 * localavgscorepath.superlayer!.bounds.height, 0.60721 * localavgscorepath.superlayer!.bounds.width, 0.63492 * localavgscorepath.superlayer!.bounds.height)
            localavgscorepath.path  = localavgscorepathPathWithBounds((layers["localavgscorepath"] as! CAShapeLayer).bounds).CGPath
        }
        
        if let globalavgscorepath : CAShapeLayer = layers["globalavgscorepath"] as? CAShapeLayer{
            globalavgscorepath.frame = CGRectMake(0.17457 * globalavgscorepath.superlayer!.bounds.width, 0.18254 * globalavgscorepath.superlayer!.bounds.height, 0.60721 * globalavgscorepath.superlayer!.bounds.width, 0.63492 * globalavgscorepath.superlayer!.bounds.height)
            globalavgscorepath.path  = globalavgscorepathPathWithBounds((layers["globalavgscorepath"] as! CAShapeLayer).bounds).CGPath
        }
        
        if let outerscore : CATextLayer = layers["outerscore"] as? CATextLayer{
            outerscore.frame = CGRectMake(0.33017 * outerscore.superlayer!.bounds.width, 0.4127 * outerscore.superlayer!.bounds.height, 0.03175 * outerscore.superlayer!.bounds.height, 0.03175 * outerscore.superlayer!.bounds.height)
            outerscore.fontSize = (0.77 * outerscore.bounds.height)
            outerscore.string = "\(outerscorevalue)"
            if(outerscorevalue == 0 ){
                outerscore.hidden = true
            }else{
                outerscore.hidden = false
            }
        }
        
        if let localavgscore : CATextLayer = layers["localavgscore"] as? CATextLayer{
            localavgscore.frame = CGRectMake(0.33017 * localavgscore.superlayer!.bounds.width, 0.4127 * localavgscore.superlayer!.bounds.height, 0.03036 * localavgscore.superlayer!.bounds.width, 0.03175 * localavgscore.superlayer!.bounds.height)
            localavgscore.fontSize = (0.25 * localavgscore.superlayer!.bounds.height)/10
            localavgscore.string = "\(localavgscorevalue)"
            if(outerscorevalue == 0 ){
                localavgscore.hidden = true
            }else{
                localavgscore.hidden = false
            }
        }
        
        if let globalavgscore : CATextLayer = layers["globalavgscore"] as? CATextLayer{
            globalavgscore.frame = CGRectMake(0.33017 * globalavgscore.superlayer!.bounds.width, 0.4127 * globalavgscore.superlayer!.bounds.height, 0.03036 * globalavgscore.superlayer!.bounds.width, 0.03175 * globalavgscore.superlayer!.bounds.height)
            globalavgscore.fontSize = (0.25 * globalavgscore.superlayer!.bounds.height)/10
            globalavgscore.string = "\(globalavgscorevalue)"
            if(outerscorevalue == 0 ){
                globalavgscore.hidden = true
            }else{
                globalavgscore.hidden = false
            }
        }
        
        if let localavgneedlepath : CAShapeLayer = layers["localavgneedlepath"] as? CAShapeLayer{
            localavgneedlepath.frame = CGRectMake(0.06072 * localavgneedlepath.superlayer!.bounds.width, 0.06349 * localavgneedlepath.superlayer!.bounds.height, 0.83491 * localavgneedlepath.superlayer!.bounds.width, 0.87302 * localavgneedlepath.superlayer!.bounds.height)
            localavgneedlepath.path  = localavgneedlepathPathWithBounds((layers["localavgneedlepath"] as! CAShapeLayer).bounds).CGPath
        }
        
        if let localavgpath : CAShapeLayer = layers["localavgpath"] as? CAShapeLayer{
            localavgpath.frame = CGRectMake(0, 0, 0.95636 * localavgpath.superlayer!.bounds.width,  localavgpath.superlayer!.bounds.height)
            localavgpath.path  = localavgpathPathWithBounds((layers["localavgpath"] as! CAShapeLayer).bounds).CGPath
        }
        
        if let globalavgneedlepath : CAShapeLayer = layers["globalavgneedlepath"] as? CAShapeLayer{
            globalavgneedlepath.frame = CGRectMake(0.06072 * globalavgneedlepath.superlayer!.bounds.width, 0.06349 * globalavgneedlepath.superlayer!.bounds.height, 0.83491 * globalavgneedlepath.superlayer!.bounds.width, 0.87302 * globalavgneedlepath.superlayer!.bounds.height)
            globalavgneedlepath.path  = globalavgneedlepathPathWithBounds((layers["globalavgneedlepath"] as! CAShapeLayer).bounds).CGPath
        }
        
        if let globalavgpath : CAShapeLayer = layers["globalavgpath"] as? CAShapeLayer{
            globalavgpath.frame = CGRectMake(0, 0, 0.95636 * globalavgpath.superlayer!.bounds.width,  globalavgpath.superlayer!.bounds.height)
            globalavgpath.path  = globalavgpathPathWithBounds((layers["globalavgpath"] as! CAShapeLayer).bounds).CGPath
        }
        
        if let middlescore : CATextLayer = layers["middlescore"] as? CATextLayer{
            middlescore.frame = CGRectMake(0.33017 * middlescore.superlayer!.bounds.width, 0.4127 * middlescore.superlayer!.bounds.height, 0.03175 * middlescore.superlayer!.bounds.height, 0.03175 * middlescore.superlayer!.bounds.height)
            middlescore.fontSize = (0.77 * middlescore.bounds.width)
            middlescore.string = "\(middlescorevalue)"
            if(middlescorevalue == 0 ){
                middlescore.hidden = true
            }else{
                middlescore.hidden = false
            }
        }
        
        if let innerscore : CATextLayer = layers["innerscore"] as? CATextLayer{
            innerscore.frame = CGRectMake(0.33017 * innerscore.superlayer!.bounds.width, 0.4127 * innerscore.superlayer!.bounds.height, 0.03175 * innerscore.superlayer!.bounds.height, 0.03175 * innerscore.superlayer!.bounds.height)
            innerscore.fontSize = (0.77 * innerscore.bounds.width)
            innerscore.string = "\(innerscorevalue)"
            if(innerscorevalue == 0 ){
                innerscore.hidden = true
            }else{
                innerscore.hidden = false
            }
        }

        
        
    }
    
    func setupLayers(){
        self.backgroundColor = UIColor.blackColor()
        
        let Group = CALayer()
        self.layer.addSublayer(Group)
        
        layers["Group"] = Group
        let oval = CAShapeLayer()
        Group.addSublayer(oval)
        oval.fillColor   = UIColor(red:0.835, green: 0.835, blue:0.835, alpha:1).CGColor
        oval.strokeColor = UIColor(red:1, green: 0.376, blue:0.313, alpha:1).CGColor
        oval.lineWidth   = 0
        layers["oval"] = oval
        let innerback = CAShapeLayer()
        Group.addSublayer(innerback)
        innerback.fillColor   = nil
        innerback.strokeColor = UIColor(red:0.835, green: 0.835, blue:0.835, alpha:1).CGColor
        innerback.lineWidth   = 13
        layers["innerback"] = innerback
        let middleback = CAShapeLayer()
        Group.addSublayer(middleback)
        middleback.fillColor   = nil
        middleback.strokeColor = UIColor(red:0.835, green: 0.835, blue:0.835, alpha:1).CGColor
        middleback.lineWidth   = 12
        layers["middleback"] = middleback
        let outerback = CAShapeLayer()
        Group.addSublayer(outerback)
        outerback.fillColor   = nil
        outerback.strokeColor = UIColor(red:0.835, green: 0.835, blue:0.835, alpha:1).CGColor
        outerback.lineWidth   = 43
        layers["outerback"] = outerback
        let innerstart = CAShapeLayer()
        Group.addSublayer(innerstart)
        innerstart.fillColor   = nil
        innerstart.strokeColor = UIColor(red:0.544, green: 0.502, blue:0.921, alpha:1).CGColor
        innerstart.lineWidth   = 13
        innerstart.strokeEnd   = 0.33
        layers["innerstart"] = innerstart
        let middlestart = CAShapeLayer()
        Group.addSublayer(middlestart)
        middlestart.fillColor   = nil
        middlestart.strokeColor = UIColor(red:0.544, green: 0.502, blue:0.921, alpha:1).CGColor
        middlestart.lineWidth   = 12
        middlestart.strokeEnd   = 0.26
        layers["middlestart"] = middlestart
        let outerstart = CAShapeLayer()
        Group.addSublayer(outerstart)
        outerstart.fillColor   = nil
        outerstart.strokeColor = UIColor(red:0.544, green: 0.502, blue:0.921, alpha:1).CGColor
        outerstart.lineWidth   = 43
        outerstart.strokeEnd   = 0.19
        layers["outerstart"] = outerstart
        
        let title = CATextLayer()
        Group.addSublayer(title)
        title.contentsScale   = UIScreen.mainScreen().scale
        title.string          = "Hello World!"
        title.font            = "GothamBook"
        title.fontSize        = 6
        title.alignmentMode   = kCAAlignmentCenter;
        title.foregroundColor = UIColor.blackColor().CGColor;
        title.wrapped         = true
        layers["title"] = title
        let img = CALayer()
        Group.addSublayer(img)
        img.contents = UIImage(named:"img")?.CGImage
        layers["img"] = img
        let context1 = CATextLayer()
        Group.addSublayer(context1)
        context1.contentsScale   = UIScreen.mainScreen().scale
        context1.string          = "Hello World!"
        context1.font            = "GothamBook"
        context1.fontSize        = 8
        context1.alignmentMode   = kCAAlignmentLeft;
        context1.foregroundColor = UIColor.blackColor().CGColor;
        layers["context1"] = context1
        let context2 = CATextLayer()
        Group.addSublayer(context2)
        context2.contentsScale   = UIScreen.mainScreen().scale
        context2.string          = "Hello World!"
        context2.font            = "GothamBook"
        context2.fontSize        = 8
        context2.alignmentMode   = kCAAlignmentLeft;
        context2.foregroundColor = UIColor.blackColor().CGColor;
        layers["context2"] = context2
        let middlelabel = CATextLayer()
        Group.addSublayer(middlelabel)
        middlelabel.contentsScale   = UIScreen.mainScreen().scale
        middlelabel.string          = "Hello World!"
        middlelabel.font            = "GothamBook"
        middlelabel.fontSize        = 8
        middlelabel.alignmentMode   = kCAAlignmentCenter;
        middlelabel.foregroundColor = UIColor.blackColor().CGColor;
        layers["middlelabel"] = middlelabel
        let innerlabel = CATextLayer()
        Group.addSublayer(innerlabel)
        innerlabel.contentsScale   = UIScreen.mainScreen().scale
        innerlabel.string          = "Hello World!"
        innerlabel.font            = "GothamBook"
        innerlabel.fontSize        = 8
        innerlabel.alignmentMode   = kCAAlignmentCenter;
        innerlabel.foregroundColor = UIColor.blackColor().CGColor;
        layers["innerlabel"] = innerlabel
        let outermaxscore = CATextLayer()
        Group.addSublayer(outermaxscore)
        outermaxscore.contentsScale   = UIScreen.mainScreen().scale
        outermaxscore.string          = "Hello World!"
        outermaxscore.font            = "GothamBook"
        outermaxscore.fontSize        = 7
        outermaxscore.alignmentMode   = kCAAlignmentCenter;
        outermaxscore.foregroundColor = UIColor.blackColor().CGColor;
        layers["outermaxscore"] = outermaxscore
        let middlemaxscore = CATextLayer()
        Group.addSublayer(middlemaxscore)
        middlemaxscore.contentsScale   = UIScreen.mainScreen().scale
        middlemaxscore.string          = "Hello World!"
        middlemaxscore.font            = "GothamBook"
        middlemaxscore.fontSize        = 7
        middlemaxscore.alignmentMode   = kCAAlignmentCenter;
        middlemaxscore.foregroundColor = UIColor.blackColor().CGColor;
        layers["middlemaxscore"] = middlemaxscore
        let innermaxscore = CATextLayer()
        Group.addSublayer(innermaxscore)
        innermaxscore.contentsScale   = UIScreen.mainScreen().scale
        innermaxscore.string          = "Hello World!"
        innermaxscore.font            = "GothamBook"
        innermaxscore.fontSize        = 7
        innermaxscore.alignmentMode   = kCAAlignmentCenter;
        innermaxscore.foregroundColor = UIColor.blackColor().CGColor;
        layers["innermaxscore"] = innermaxscore
        let innerstarting = CAShapeLayer()
        Group.addSublayer(innerstarting)
        innerstarting.fillColor   = nil
        innerstarting.strokeColor = UIColor(red:0.543, green: 0.501, blue:0.923, alpha:1).CGColor
        innerstarting.lineWidth   = 13
        innerstarting.strokeEnd   = 0
        layers["innerstarting"] = innerstarting
        let middlestarting = CAShapeLayer()
        Group.addSublayer(middlestarting)
        middlestarting.fillColor   = nil
        middlestarting.strokeColor = UIColor(red:0.543, green: 0.501, blue:0.923, alpha:1).CGColor
        middlestarting.lineWidth   = 12
        middlestarting.strokeEnd   = 0
        layers["middlestarting"] = middlestarting
        let outerstarting = CAShapeLayer()
        Group.addSublayer(outerstarting)
        outerstarting.fillColor   = nil
        outerstarting.strokeColor = UIColor(red:0.543, green: 0.501, blue:0.923, alpha:1).CGColor
        outerstarting.lineWidth   = 43
        outerstarting.strokeEnd   = 0
        layers["outerstarting"] = outerstarting
        let innerarrow = CAShapeLayer()
        Group.addSublayer(innerarrow)
        innerarrow.setValue(-45 * CGFloat(M_PI)/180, forKeyPath:"transform.rotation")
        innerarrow.fillColor   = UIColor(red:0.544, green: 0.502, blue:0.921, alpha:1).CGColor
        innerarrow.strokeColor = UIColor(red:0.835, green: 0.835, blue:0.835, alpha:1).CGColor
        innerarrow.lineWidth   = 0
        layers["innerarrow"] = innerarrow
        let innerstartingpath = CAShapeLayer()
        Group.addSublayer(innerstartingpath)
        innerstartingpath.hidden      = true
        innerstartingpath.fillColor   = nil
        innerstartingpath.strokeColor = UIColor(red:0.543, green: 0.501, blue:0.923, alpha:1).CGColor
        innerstartingpath.lineWidth   = 13
        innerstartingpath.strokeEnd   = 0
        layers["innerstartingpath"] = innerstartingpath
        let middlestartingpath = CAShapeLayer()
        Group.addSublayer(middlestartingpath)
        middlestartingpath.hidden      = true
        middlestartingpath.fillColor   = nil
        middlestartingpath.strokeColor = UIColor(red:0.543, green: 0.501, blue:0.923, alpha:1).CGColor
        middlestartingpath.lineWidth   = 12
        layers["middlestartingpath"] = middlestartingpath
        let outerstartingpath = CAShapeLayer()
        Group.addSublayer(outerstartingpath)
        outerstartingpath.hidden      = true
        outerstartingpath.fillColor   = nil
        outerstartingpath.strokeColor = UIColor(red:0.543, green: 0.501, blue:0.923, alpha:1).CGColor
        outerstartingpath.lineWidth   = 43
        layers["outerstartingpath"] = outerstartingpath
        let middlearrow = CAShapeLayer()
        Group.addSublayer(middlearrow)
        middlearrow.setValue(-45 * CGFloat(M_PI)/180, forKeyPath:"transform.rotation")
        middlearrow.fillColor   = UIColor(red:0.544, green: 0.502, blue:0.921, alpha:1).CGColor
        middlearrow.strokeColor = UIColor(red:0.835, green: 0.835, blue:0.835, alpha:1).CGColor
        middlearrow.lineWidth   = 0
        layers["middlearrow"] = middlearrow
        let outerarrow = CAShapeLayer()
        Group.addSublayer(outerarrow)
        outerarrow.setValue(-45 * CGFloat(M_PI)/180, forKeyPath:"transform.rotation")
        outerarrow.fillColor   = UIColor(red:0.544, green: 0.502, blue:0.921, alpha:1).CGColor
        outerarrow.strokeColor = UIColor(red:0.835, green: 0.835, blue:0.835, alpha:1).CGColor
        outerarrow.lineWidth   = 0
        layers["outerarrow"] = outerarrow
        let global = CALayer()
        Group.addSublayer(global)
        global.contents = UIImage(named:"global")?.CGImage
        layers["global"] = global
        let local = CALayer()
        Group.addSublayer(local)
        local.contents = UIImage(named:"local")?.CGImage
        layers["local"] = local
        let globalneedle = CALayer()
        Group.addSublayer(globalneedle)
        globalneedle.setValue(-60 * CGFloat(M_PI)/180, forKeyPath:"transform.rotation")
        globalneedle.contents = UIImage(named:"globalneedle")?.CGImage
        layers["globalneedle"] = globalneedle
        let localneedle = CALayer()
        Group.addSublayer(localneedle)
        localneedle.setValue(-60 * CGFloat(M_PI)/180, forKeyPath:"transform.rotation")
        localneedle.contents = UIImage(named:"localneedle")?.CGImage
        layers["localneedle"] = localneedle
        let localavgscorepath = CAShapeLayer()
        Group.addSublayer(localavgscorepath)
        localavgscorepath.hidden      = true
        localavgscorepath.fillColor   = nil
        localavgscorepath.strokeColor = UIColor(red:0.543, green: 0.501, blue:0.923, alpha:1).CGColor
        localavgscorepath.strokeEnd = 1
        localavgscorepath.strokeStart = 0
        localavgscorepath.lineWidth   = 43
        layers["localavgscorepath"] = localavgscorepath
        let globalavgscorepath = CAShapeLayer()
        Group.addSublayer(globalavgscorepath)
        globalavgscorepath.hidden      = true
        globalavgscorepath.fillColor   = nil
        globalavgscorepath.strokeColor = UIColor(red:0.543, green: 0.501, blue:0.923, alpha:1).CGColor
        globalavgscorepath.lineWidth   = 43
        layers["globalavgscorepath"] = globalavgscorepath
        let outerscore = CATextLayer()
        Group.addSublayer(outerscore)
        outerscore.contentsScale   = UIScreen.mainScreen().scale
        outerscore.string          = "Hello World!"
        outerscore.font            = "GothamBook"
        outerscore.fontSize        = 7
        outerscore.alignmentMode   = kCAAlignmentCenter;
        outerscore.foregroundColor = UIColor.blackColor().CGColor;
        layers["outerscore"] = outerscore
        let localavgscore = CATextLayer()
        Group.addSublayer(localavgscore)
        localavgscore.contentsScale   = UIScreen.mainScreen().scale
        localavgscore.string          = "Hello World!"
        localavgscore.font            = "GothamBook"
        localavgscore.fontSize        = 7
        localavgscore.alignmentMode   = kCAAlignmentCenter;
        localavgscore.foregroundColor = UIColor.blackColor().CGColor;
        layers["localavgscore"] = localavgscore
        let globalavgscore = CATextLayer()
        Group.addSublayer(globalavgscore)
        globalavgscore.contentsScale   = UIScreen.mainScreen().scale
        globalavgscore.string          = "Hello World!"
        globalavgscore.font            = "GothamBook"
        globalavgscore.fontSize        = 7
        globalavgscore.alignmentMode   = kCAAlignmentCenter;
        globalavgscore.foregroundColor = UIColor.blackColor().CGColor;
        layers["globalavgscore"] = globalavgscore
        let localavgneedlepath = CAShapeLayer()
        Group.addSublayer(localavgneedlepath)
        localavgneedlepath.hidden      = true
        localavgneedlepath.fillColor   = nil
        localavgneedlepath.strokeColor = UIColor(red:0.543, green: 0.501, blue:0.923, alpha:1).CGColor
        layers["localavgneedlepath"] = localavgneedlepath
        let localavgpath = CAShapeLayer()
        Group.addSublayer(localavgpath)
        localavgpath.hidden      = true
        localavgpath.fillColor   = nil
        localavgpath.strokeColor = UIColor(red:0.543, green: 0.501, blue:0.923, alpha:1).CGColor
        layers["localavgpath"] = localavgpath
        let globalavgneedlepath = CAShapeLayer()
        Group.addSublayer(globalavgneedlepath)
        globalavgneedlepath.hidden      = true
        globalavgneedlepath.fillColor   = nil
        globalavgneedlepath.strokeColor = UIColor(red:0.543, green: 0.501, blue:0.923, alpha:1).CGColor
        layers["globalavgneedlepath"] = globalavgneedlepath
        let globalavgpath = CAShapeLayer()
        Group.addSublayer(globalavgpath)
        globalavgpath.hidden      = true
        globalavgpath.fillColor   = nil
        globalavgpath.strokeColor = UIColor(red:0.543, green: 0.501, blue:0.923, alpha:1).CGColor
        layers["globalavgpath"] = globalavgpath
        let middlescore = CATextLayer()
        Group.addSublayer(middlescore)
        middlescore.contentsScale   = UIScreen.mainScreen().scale
        middlescore.string          = "Hello World!"
        middlescore.font            = "GothamBook"
        middlescore.fontSize        = 7
        middlescore.alignmentMode   = kCAAlignmentCenter;
        middlescore.foregroundColor = UIColor.blackColor().CGColor;
        layers["middlescore"] = middlescore
        let innerscore = CATextLayer()
        Group.addSublayer(innerscore)
        innerscore.contentsScale   = UIScreen.mainScreen().scale
        innerscore.string          = "Hello World!"
        innerscore.font            = "GothamBook"
        innerscore.fontSize        = 7
        innerscore.alignmentMode   = kCAAlignmentCenter;
        innerscore.foregroundColor = UIColor.blackColor().CGColor;
        layers["innerscore"] = innerscore
        setupLayerFrames()
    }
    
    func setupLayerFrames(){
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        if let Group : CALayer = layers["Group"] as? CALayer{
            Group.frame = CGRectMake(0.08667 * Group.superlayer!.bounds.width, 0.08667 * Group.superlayer!.bounds.height, 0.87833 * Group.superlayer!.bounds.width, 0.84 * Group.superlayer!.bounds.height)
        }
        
        if let oval : CAShapeLayer = layers["oval"] as? CAShapeLayer{
            oval.frame = CGRectMake(0.37951 * oval.superlayer!.bounds.width, 0.39683 * oval.superlayer!.bounds.height, 0.19734 * oval.superlayer!.bounds.width, 0.20635 * oval.superlayer!.bounds.height)
            oval.path  = ovalPathWithBounds((layers["oval"] as! CAShapeLayer).bounds).CGPath
        }
        
        if let innerback : CAShapeLayer = layers["innerback"] as? CAShapeLayer{
            innerback.frame = CGRectMake(0.0898 * innerback.superlayer!.bounds.width, 0.36124 * innerback.superlayer!.bounds.height, 0.5212 * innerback.superlayer!.bounds.width, 0.27765 * innerback.superlayer!.bounds.height)
            innerback.path  = innerbackPathWithBounds((layers["innerback"] as! CAShapeLayer).bounds).CGPath
        }
        
        if let middleback : CAShapeLayer = layers["middleback"] as? CAShapeLayer{
            middleback.frame = CGRectMake(0.09056 * middleback.superlayer!.bounds.width, 0.30204 * middleback.superlayer!.bounds.height, 0.57737 * middleback.superlayer!.bounds.width, 0.39637 * middleback.superlayer!.bounds.height)
            middleback.path  = middlebackPathWithBounds((layers["middleback"] as! CAShapeLayer).bounds).CGPath
        }
        
        if let outerback : CAShapeLayer = layers["outerback"] as? CAShapeLayer{
            outerback.frame = CGRectMake(0.09143 * outerback.superlayer!.bounds.width, 0.18254 * outerback.superlayer!.bounds.height, 0.69035 * outerback.superlayer!.bounds.width, 0.63492 * outerback.superlayer!.bounds.height)
            outerback.path  = outerbackPathWithBounds((layers["outerback"] as! CAShapeLayer).bounds).CGPath
        }
        
        if let innerstart : CAShapeLayer = layers["innerstart"] as? CAShapeLayer{
            innerstart.frame = CGRectMake(0.0898 * innerstart.superlayer!.bounds.width, 0.36124 * innerstart.superlayer!.bounds.height, 0.5212 * innerstart.superlayer!.bounds.width, 0.27765 * innerstart.superlayer!.bounds.height)
            innerstart.path  = innerstartPathWithBounds((layers["innerstart"] as! CAShapeLayer).bounds).CGPath
        }
        
        if let middlestart : CAShapeLayer = layers["middlestart"] as? CAShapeLayer{
            middlestart.frame = CGRectMake(0.09056 * middlestart.superlayer!.bounds.width, 0.30204 * middlestart.superlayer!.bounds.height, 0.57737 * middlestart.superlayer!.bounds.width, 0.39637 * middlestart.superlayer!.bounds.height)
            middlestart.path  = middlestartPathWithBounds((layers["middlestart"] as! CAShapeLayer).bounds).CGPath
        }
        
        if let outerstart : CAShapeLayer = layers["outerstart"] as? CAShapeLayer{
            outerstart.frame = CGRectMake(0.09143 * outerstart.superlayer!.bounds.width, 0.18254 * outerstart.superlayer!.bounds.height, 0.69035 * outerstart.superlayer!.bounds.width, 0.63492 * outerstart.superlayer!.bounds.height)
            outerstart.path  = outerstartPathWithBounds((layers["outerstart"] as! CAShapeLayer).bounds).CGPath
        }
        
        if let innerstarting : CAShapeLayer = layers["innerstarting"] as? CAShapeLayer{
            innerstarting.frame = CGRectMake(0.34535 * innerstarting.superlayer!.bounds.width, 0.36111 * innerstarting.superlayer!.bounds.height, 0.26565 * innerstarting.superlayer!.bounds.width, 0.27778 * innerstarting.superlayer!.bounds.height)
            innerstarting.path  = innerstartingPathWithBounds((layers["innerstarting"] as! CAShapeLayer).bounds).CGPath
        }
        
        if let middlestarting : CAShapeLayer = layers["middlestarting"] as? CAShapeLayer{
            middlestarting.frame = CGRectMake(0.28843 * middlestarting.superlayer!.bounds.width, 0.30159 * middlestarting.superlayer!.bounds.height, 0.37951 * middlestarting.superlayer!.bounds.width, 0.39683 * middlestarting.superlayer!.bounds.height)
            middlestarting.path  = middlestartingPathWithBounds((layers["middlestarting"] as! CAShapeLayer).bounds).CGPath
        }
        
        if let outerstarting : CAShapeLayer = layers["outerstarting"] as? CAShapeLayer{
            outerstarting.frame = CGRectMake(0.17457 * outerstarting.superlayer!.bounds.width, 0.18254 * outerstarting.superlayer!.bounds.height, 0.60721 * outerstarting.superlayer!.bounds.width, 0.63492 * outerstarting.superlayer!.bounds.height)
            outerstarting.path  = outerstartingPathWithBounds((layers["outerstarting"] as! CAShapeLayer).bounds).CGPath
        }
        
        if let title : CATextLayer = layers["title"] as? CATextLayer{
            title.frame = CGRectMake(0.40055 * title.superlayer!.bounds.width, 0.46346 * title.superlayer!.bounds.height, 0.15527 * title.superlayer!.bounds.width, 0.07308 * title.superlayer!.bounds.height)
        }
        
        if let img : CALayer = layers["img"] as? CALayer{
            img.frame = CGRectMake(0.10816 * img.superlayer!.bounds.width, 0.11862 * img.superlayer!.bounds.height, 0.02277 * img.superlayer!.bounds.width, 0.04039 * img.superlayer!.bounds.height)
        }
        
        if let context1 : CATextLayer = layers["context1"] as? CATextLayer{
            context1.frame = CGRectMake(0.13674 * context1.superlayer!.bounds.width, 0.11536 * context1.superlayer!.bounds.height, 0.26001 * context1.superlayer!.bounds.width, 0.03968 * context1.superlayer!.bounds.height)
        }
        
        if let context2 : CATextLayer = layers["context2"] as? CATextLayer{
            context2.frame = CGRectMake(0.11195 * context2.superlayer!.bounds.width, 0.161 * context2.superlayer!.bounds.height, 0.2848 * context2.superlayer!.bounds.width, 0.07285 * context2.superlayer!.bounds.height)
        }
        
        if let middlelabel : CATextLayer = layers["middlelabel"] as? CATextLayer{
            middlelabel.frame = CGRectMake(0.11195 * middlelabel.superlayer!.bounds.width, 0.2822 * middlelabel.superlayer!.bounds.height, 0.18975 * middlelabel.superlayer!.bounds.width, 0.03968 * middlelabel.superlayer!.bounds.height)
        }
        
        if let innerlabel : CATextLayer = layers["innerlabel"] as? CATextLayer{
            innerlabel.frame = CGRectMake(0.11195 * innerlabel.superlayer!.bounds.width, 0.34524 * innerlabel.superlayer!.bounds.height, 0.18975 * innerlabel.superlayer!.bounds.width, 0.03968 * innerlabel.superlayer!.bounds.height)
        }
        
        if let outermaxscore : CATextLayer = layers["outermaxscore"] as? CATextLayer{
            outermaxscore.frame = CGRectMake(0.1575 * outermaxscore.superlayer!.bounds.width, 0.4127 * outermaxscore.superlayer!.bounds.height, 0.03036 * outermaxscore.superlayer!.bounds.width, 0.03175 * outermaxscore.superlayer!.bounds.height)
        }
        
        if let middlemaxscore : CATextLayer = layers["middlemaxscore"] as? CATextLayer{
            middlemaxscore.frame = CGRectMake(0.27434 * middlemaxscore.superlayer!.bounds.width, 0.4127 * middlemaxscore.superlayer!.bounds.height, 0.03036 * middlemaxscore.superlayer!.bounds.width, 0.03175 * middlemaxscore.superlayer!.bounds.height)
        }
        
        if let innermaxscore : CATextLayer = layers["innermaxscore"] as? CATextLayer{
            innermaxscore.frame = CGRectMake(0.33017 * innermaxscore.superlayer!.bounds.width, 0.4127 * innermaxscore.superlayer!.bounds.height, 0.03036 * innermaxscore.superlayer!.bounds.width, 0.03175 * innermaxscore.superlayer!.bounds.height)
        }
        
        if let innerarrow : CAShapeLayer = layers["innerarrow"] as? CAShapeLayer{
            innerarrow.transform = CATransform3DIdentity
            innerarrow.frame     = CGRectMake(0.4611 * innerarrow.superlayer!.bounds.width, 0.34681 * innerarrow.superlayer!.bounds.height, 0.03036 * innerarrow.superlayer!.bounds.width, 0.03175 * innerarrow.superlayer!.bounds.height)
            innerarrow.setValue(-45 * CGFloat(M_PI)/180, forKeyPath:"transform.rotation")
            innerarrow.path      = innerarrowPathWithBounds((layers["innerarrow"] as! CAShapeLayer).bounds).CGPath
        }
        
        if let innerstartingpath : CAShapeLayer = layers["innerstartingpath"] as? CAShapeLayer{
            innerstartingpath.frame = CGRectMake(0.34535 * innerstartingpath.superlayer!.bounds.width, 0.36111 * innerstartingpath.superlayer!.bounds.height, 0.26565 * innerstartingpath.superlayer!.bounds.width, 0.27778 * innerstartingpath.superlayer!.bounds.height)
            innerstartingpath.path  = innerstartingpathPathWithBounds((layers["innerstartingpath"] as! CAShapeLayer).bounds).CGPath
        }
        
        if let middlestartingpath : CAShapeLayer = layers["middlestartingpath"] as? CAShapeLayer{
            middlestartingpath.frame = CGRectMake(0.28843 * middlestartingpath.superlayer!.bounds.width, 0.30159 * middlestartingpath.superlayer!.bounds.height, 0.37951 * middlestartingpath.superlayer!.bounds.width, 0.39683 * middlestartingpath.superlayer!.bounds.height)
            middlestartingpath.path  = middlestartingpathPathWithBounds((layers["middlestartingpath"] as! CAShapeLayer).bounds).CGPath
        }
        
        if let outerstartingpath : CAShapeLayer = layers["outerstartingpath"] as? CAShapeLayer{
            outerstartingpath.frame = CGRectMake(0.17457 * outerstartingpath.superlayer!.bounds.width, 0.18254 * outerstartingpath.superlayer!.bounds.height, 0.60721 * outerstartingpath.superlayer!.bounds.width, 0.63492 * outerstartingpath.superlayer!.bounds.height)
            outerstartingpath.path  = outerstartingpathPathWithBounds((layers["outerstartingpath"] as! CAShapeLayer).bounds).CGPath
        }
        
        if let middlearrow : CAShapeLayer = layers["middlearrow"] as? CAShapeLayer{
            middlearrow.transform = CATransform3DIdentity
            middlearrow.frame     = CGRectMake(0.4611 * middlearrow.superlayer!.bounds.width, 0.34681 * middlearrow.superlayer!.bounds.height, 0.03036 * middlearrow.superlayer!.bounds.width, 0.03175 * middlearrow.superlayer!.bounds.height)
            middlearrow.setValue(-45 * CGFloat(M_PI)/180, forKeyPath:"transform.rotation")
            middlearrow.path      = middlearrowPathWithBounds((layers["middlearrow"] as! CAShapeLayer).bounds).CGPath
        }
        
        if let outerarrow : CAShapeLayer = layers["outerarrow"] as? CAShapeLayer{
            outerarrow.transform = CATransform3DIdentity
            outerarrow.frame     = CGRectMake(0.4439 * outerarrow.superlayer!.bounds.width, 0.76744 * outerarrow.superlayer!.bounds.height, 0.11385 * outerarrow.superlayer!.bounds.width, 0.11905 * outerarrow.superlayer!.bounds.height)
            outerarrow.setValue(-45 * CGFloat(M_PI)/180, forKeyPath:"transform.rotation")
            outerarrow.path      = outerarrowPathWithBounds((layers["outerarrow"] as! CAShapeLayer).bounds).CGPath
        }
        
        if let global : CALayer = layers["global"] as? CALayer{
            global.frame = CGRectMake(0.90512 * global.superlayer!.bounds.width, 0.46055 * global.superlayer!.bounds.height, 0.09488 * global.superlayer!.bounds.width, 0.09921 * global.superlayer!.bounds.height)
        }
        
        if let local : CALayer = layers["local"] as? CALayer{
            local.frame = CGRectMake(0.5023 * local.superlayer!.bounds.width, 0.27901 * local.superlayer!.bounds.height, 0.09488 * local.superlayer!.bounds.width, 0.09921 * local.superlayer!.bounds.height)
        }
        
        if let globalneedle : CALayer = layers["globalneedle"] as? CALayer{
            globalneedle.transform = CATransform3DIdentity
            globalneedle.frame     = CGRectMake(0.96584 * globalneedle.superlayer!.bounds.width, 0.2822 * globalneedle.superlayer!.bounds.height, 0.03036 * globalneedle.superlayer!.bounds.width, 0.0254 * globalneedle.superlayer!.bounds.height)
            globalneedle.setValue(-60 * CGFloat(M_PI)/180, forKeyPath:"transform.rotation")
        }
        
        if let localneedle : CALayer = layers["localneedle"] as? CALayer{
            localneedle.transform = CATransform3DIdentity
            localneedle.frame     = CGRectMake(0.87097 * localneedle.superlayer!.bounds.width, 0.20206 * localneedle.superlayer!.bounds.height, 0.03036 * localneedle.superlayer!.bounds.width, 0.0254 * localneedle.superlayer!.bounds.height)
            localneedle.setValue(-60 * CGFloat(M_PI)/180, forKeyPath:"transform.rotation")
        }
        
        if let localavgscorepath : CAShapeLayer = layers["localavgscorepath"] as? CAShapeLayer{
            localavgscorepath.frame = CGRectMake(0.17457 * localavgscorepath.superlayer!.bounds.width, 0.18254 * localavgscorepath.superlayer!.bounds.height, 0.60721 * localavgscorepath.superlayer!.bounds.width, 0.63492 * localavgscorepath.superlayer!.bounds.height)
            localavgscorepath.path  = localavgscorepathPathWithBounds((layers["localavgscorepath"] as! CAShapeLayer).bounds).CGPath
        }
        
        if let globalavgscorepath : CAShapeLayer = layers["globalavgscorepath"] as? CAShapeLayer{
            globalavgscorepath.frame = CGRectMake(0.17457 * globalavgscorepath.superlayer!.bounds.width, 0.18254 * globalavgscorepath.superlayer!.bounds.height, 0.60721 * globalavgscorepath.superlayer!.bounds.width, 0.63492 * globalavgscorepath.superlayer!.bounds.height)
            globalavgscorepath.path  = globalavgscorepathPathWithBounds((layers["globalavgscorepath"] as! CAShapeLayer).bounds).CGPath
        }
        
        if let outerscore : CATextLayer = layers["outerscore"] as? CATextLayer{
            outerscore.frame = CGRectMake(0.33017 * outerscore.superlayer!.bounds.width, 0.4127 * outerscore.superlayer!.bounds.height, 0.03036 * outerscore.superlayer!.bounds.width, 0.03175 * outerscore.superlayer!.bounds.height)
        }
        
        if let localavgscore : CATextLayer = layers["localavgscore"] as? CATextLayer{
            localavgscore.frame = CGRectMake(0.33017 * localavgscore.superlayer!.bounds.width, 0.4127 * localavgscore.superlayer!.bounds.height, 0.03036 * localavgscore.superlayer!.bounds.width, 0.03175 * localavgscore.superlayer!.bounds.height)
        }
        
        if let globalavgscore : CATextLayer = layers["globalavgscore"] as? CATextLayer{
            globalavgscore.frame = CGRectMake(0.33017 * globalavgscore.superlayer!.bounds.width, 0.4127 * globalavgscore.superlayer!.bounds.height, 0.03036 * globalavgscore.superlayer!.bounds.width, 0.03175 * globalavgscore.superlayer!.bounds.height)
        }
        
        if let localavgneedlepath : CAShapeLayer = layers["localavgneedlepath"] as? CAShapeLayer{
            localavgneedlepath.frame = CGRectMake(0.06072 * localavgneedlepath.superlayer!.bounds.width, 0.06349 * localavgneedlepath.superlayer!.bounds.height, 0.83491 * localavgneedlepath.superlayer!.bounds.width, 0.87302 * localavgneedlepath.superlayer!.bounds.height)
            localavgneedlepath.path  = localavgneedlepathPathWithBounds((layers["localavgneedlepath"] as! CAShapeLayer).bounds).CGPath
        }
        
        if let localavgpath : CAShapeLayer = layers["localavgpath"] as? CAShapeLayer{
            localavgpath.frame = CGRectMake(0, 0, 0.95636 * localavgpath.superlayer!.bounds.width,  localavgpath.superlayer!.bounds.height)
            localavgpath.path  = localavgpathPathWithBounds((layers["localavgpath"] as! CAShapeLayer).bounds).CGPath
        }
        
        if let globalavgneedlepath : CAShapeLayer = layers["globalavgneedlepath"] as? CAShapeLayer{
            globalavgneedlepath.frame = CGRectMake(0.06072 * globalavgneedlepath.superlayer!.bounds.width, 0.06349 * globalavgneedlepath.superlayer!.bounds.height, 0.83491 * globalavgneedlepath.superlayer!.bounds.width, 0.87302 * globalavgneedlepath.superlayer!.bounds.height)
            globalavgneedlepath.path  = globalavgneedlepathPathWithBounds((layers["globalavgneedlepath"] as! CAShapeLayer).bounds).CGPath
        }
        
        if let globalavgpath : CAShapeLayer = layers["globalavgpath"] as? CAShapeLayer{
            globalavgpath.frame = CGRectMake(0, 0, 0.95636 * globalavgpath.superlayer!.bounds.width,  globalavgpath.superlayer!.bounds.height)
            globalavgpath.path  = globalavgpathPathWithBounds((layers["globalavgpath"] as! CAShapeLayer).bounds).CGPath
        }
        
        if let middlescore : CATextLayer = layers["middlescore"] as? CATextLayer{
            middlescore.frame = CGRectMake(0.33017 * middlescore.superlayer!.bounds.width, 0.4127 * middlescore.superlayer!.bounds.height, 0.03036 * middlescore.superlayer!.bounds.width, 0.03175 * middlescore.superlayer!.bounds.height)
        }
        
        if let innerscore : CATextLayer = layers["innerscore"] as? CATextLayer{
            innerscore.frame = CGRectMake(0.33017 * innerscore.superlayer!.bounds.width, 0.4127 * innerscore.superlayer!.bounds.height, 0.03036 * innerscore.superlayer!.bounds.width, 0.03175 * innerscore.superlayer!.bounds.height)
        }
        
        CATransaction.commit()
        setupProperties()
    }
    
    //MARK: - Animation Setup
    func addUntitled1Animation(){
        addUntitled1AnimationCompletionBlock(nil)
    }
    
    
    
    func addUntitled1AnimationCompletionBlock(completionBlock: ((finished: Bool) -> Void)? = nil){
        if completionBlock != nil{
            let completionAnim = CABasicAnimation(keyPath:"completionAnim")
            completionAnim.duration = 2.577
            completionAnim.setValue("Untitled1", forKey:"animId")
            completionAnim.setValue(false, forKey:"needEndAnim")
            layer.addAnimation(completionAnim, forKey:"Untitled1")
            if let anim = layer.animationForKey("Untitled1"){
                completionBlocks[anim] = completionBlock
            }
        }

        let fillMode : String = kCAFillModeForwards
        let innerscoreOpacityAnim            = CAKeyframeAnimation(keyPath:"opacity")
        innerscoreOpacityAnim.values         = [1, 1, 0]
        innerscoreOpacityAnim.keyTimes       = [0, 0.757, 1]
        innerscoreOpacityAnim.duration       = 2.58
        innerscoreOpacityAnim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)
        ////Innerstarting animation
        let innerstartingStrokeEndAnim      = CAKeyframeAnimation(keyPath:"strokeEnd")
        innerstartingStrokeEndAnim.values   = [0, 1]
        innerstartingStrokeEndAnim.keyTimes = [0, 1]
        innerstartingStrokeEndAnim.duration = 2.5
        innerstartingStrokeEndAnim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        
        let innerstartingUntitled1Anim : CAAnimationGroup = QCMethod.groupAnimations([innerstartingStrokeEndAnim], fillMode:fillMode)
        layers["innerstarting"]?.addAnimation(innerstartingUntitled1Anim, forKey:"innerstartingUntitled1Anim")
        
        ////Middlestarting animation
        let middlestartingStrokeEndAnim      = CAKeyframeAnimation(keyPath:"strokeEnd")
        middlestartingStrokeEndAnim.values   = [0, 1]
        middlestartingStrokeEndAnim.keyTimes = [0, 1]
        middlestartingStrokeEndAnim.duration = 2.5
        middlestartingStrokeEndAnim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        
        let middlestartingUntitled1Anim : CAAnimationGroup = QCMethod.groupAnimations([middlestartingStrokeEndAnim], fillMode:fillMode)
        layers["middlestarting"]?.addAnimation(middlestartingUntitled1Anim, forKey:"middlestartingUntitled1Anim")
        
        ////Outerstarting animation
        let outerstartingStrokeEndAnim      = CAKeyframeAnimation(keyPath:"strokeEnd")
        outerstartingStrokeEndAnim.values   = [0, 1]
        outerstartingStrokeEndAnim.keyTimes = [0, 1]
        outerstartingStrokeEndAnim.duration = 2.5
        outerstartingStrokeEndAnim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        
        let outerstartingUntitled1Anim : CAAnimationGroup = QCMethod.groupAnimations([outerstartingStrokeEndAnim], fillMode:fillMode)
        layers["outerstarting"]?.addAnimation(outerstartingUntitled1Anim, forKey:"outerstartingUntitled1Anim")
        
        let innerarrow = layers["innerarrow"] as! CAShapeLayer
        
        ////Innerarrow animation
        let innerarrowPositionAnim             = CAKeyframeAnimation(keyPath:"position")
        innerarrowPositionAnim.path            = innerstartingpathPathWithBounds((layers["innerstartingpath"] as! CAShapeLayer).frame).CGPath
        innerarrowPositionAnim.rotationMode    = kCAAnimationRotateAutoReverse
        innerarrowPositionAnim.calculationMode = kCAAnimationCubicPaced
        innerarrowPositionAnim.duration        = 2.5
        innerarrowPositionAnim.timingFunction  = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        
        if(innerscorevalue < innermaxscorevalue){
        let innerarrowUntitled1Anim : CAAnimationGroup = QCMethod.groupAnimations([innerarrowPositionAnim], fillMode:fillMode)
        innerarrow.addAnimation(innerarrowUntitled1Anim, forKey:"innerarrowUntitled1Anim")
        }else{
            let innerarrowUntitled1Anim : CAAnimationGroup = QCMethod.groupAnimations([innerarrowPositionAnim, innerscoreOpacityAnim], fillMode:fillMode)
            innerarrow.addAnimation(innerarrowUntitled1Anim, forKey:"innerarrowUntitled1Anim")
        }
        
        ////Innerstartingpath animation
        let innerstartingpathStrokeEndAnim    = CAKeyframeAnimation(keyPath:"strokeEnd")
        innerstartingpathStrokeEndAnim.values = [0, 1]
        innerstartingpathStrokeEndAnim.keyTimes = [0, 1]
        innerstartingpathStrokeEndAnim.duration = 2.5
        innerstartingpathStrokeEndAnim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        
        let innerstartingpathUntitled1Anim : CAAnimationGroup = QCMethod.groupAnimations([innerstartingpathStrokeEndAnim], fillMode:fillMode)
        layers["innerstartingpath"]?.addAnimation(innerstartingpathUntitled1Anim, forKey:"innerstartingpathUntitled1Anim")
        
        let middlearrow = layers["middlearrow"] as! CAShapeLayer
        
        ////Middlearrow animation
        let middlearrowPositionAnim            = CAKeyframeAnimation(keyPath:"position")
        middlearrowPositionAnim.path           = middlestartingpathPathWithBounds((layers["middlestartingpath"] as! CAShapeLayer).frame).CGPath
        middlearrowPositionAnim.rotationMode   = kCAAnimationRotateAutoReverse
        middlearrowPositionAnim.calculationMode = kCAAnimationCubicPaced
        middlearrowPositionAnim.duration       = 2.5
        middlearrowPositionAnim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        
        if(middlescorevalue < middlemaxscorevalue){
        let middlearrowUntitled1Anim : CAAnimationGroup = QCMethod.groupAnimations([middlearrowPositionAnim], fillMode:fillMode)
        middlearrow.addAnimation(middlearrowUntitled1Anim, forKey:"middlearrowUntitled1Anim")
        }else{
            let middlearrowUntitled1Anim : CAAnimationGroup = QCMethod.groupAnimations([middlearrowPositionAnim, innerscoreOpacityAnim], fillMode:fillMode)
            middlearrow.addAnimation(middlearrowUntitled1Anim, forKey:"middlearrowUntitled1Anim")
        }
        
        let outerarrow = layers["outerarrow"] as! CAShapeLayer
        
        ////Outerarrow animation
        let outerarrowPositionAnim             = CAKeyframeAnimation(keyPath:"position")
        outerarrowPositionAnim.rotationMode    = kCAAnimationRotateAutoReverse
        outerarrowPositionAnim.calculationMode = kCAAnimationCubicPaced
        outerarrowPositionAnim.duration        = 2.5
        outerarrowPositionAnim.timingFunction  = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        
        if(outerscorevalue < outermaxscorevalue){
            outerarrowPositionAnim.path            = outerstartingpathPathWithBounds((layers["outerstartingpath"] as! CAShapeLayer).frame).CGPath
            let outerarrowUntitled1Anim : CAAnimationGroup = QCMethod.groupAnimations([outerarrowPositionAnim], fillMode:fillMode)
            outerarrow.addAnimation(outerarrowUntitled1Anim, forKey:"outerarrowUntitled1Anim")
        }else{
            outerarrowPositionAnim.path            = outerstartingPathWithBounds((layers["outerstarting"] as! CAShapeLayer).frame).CGPath
            let outerarrowUntitled1Anim : CAAnimationGroup = QCMethod.groupAnimations([outerarrowPositionAnim, innerscoreOpacityAnim], fillMode:fillMode)
            outerarrow.addAnimation(outerarrowUntitled1Anim, forKey:"outerarrowUntitled1Anim")
        }
        
        
        let global = layers["global"] as! CALayer
        
        ////Global animation
        let globalPositionAnim             = CAKeyframeAnimation(keyPath:"position")
        globalPositionAnim.path            = globalavgpathPathWithBounds((layers["globalavgpath"] as! CAShapeLayer).frame).CGPath
        globalPositionAnim.calculationMode = kCAAnimationCubicPaced
        globalPositionAnim.duration        = 2.5
        globalPositionAnim.timingFunction  = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        
        let globalHiddenAnim      = CAKeyframeAnimation(keyPath:"hidden")
        if(globalavgscorevalue > 0 && outerscorevalue > 0){
            globalHiddenAnim.values   = [true, true, false]
        }else{
            globalHiddenAnim.values   = [true, true, true]
        }
        globalHiddenAnim.keyTimes = [0, 0.943, 1]
        globalHiddenAnim.duration = 2.58
        
        let globalUntitled1Anim : CAAnimationGroup = QCMethod.groupAnimations([globalPositionAnim, globalHiddenAnim], fillMode:fillMode)
        global.addAnimation(globalUntitled1Anim, forKey:"globalUntitled1Anim")
        
        let local = layers["local"] as! CALayer
        
        ////Local animation
        let localPositionAnim             = CAKeyframeAnimation(keyPath:"position")
        localPositionAnim.path            = localavgpathPathWithBounds((layers["localavgpath"] as! CAShapeLayer).frame).CGPath
        localPositionAnim.calculationMode = kCAAnimationCubicPaced
        localPositionAnim.duration        = 2.5
        localPositionAnim.timingFunction  = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        
        let localHiddenAnim      = CAKeyframeAnimation(keyPath:"hidden")
        if(localavgscorevalue > 0 && outerscorevalue > 0){
            localHiddenAnim.values   = [true, true, false]
        }else{
            localHiddenAnim.values   = [true, true, true]
        }
        localHiddenAnim.keyTimes = [0, 0.943, 1]
        localHiddenAnim.duration = 2.58
        
        let localUntitled1Anim : CAAnimationGroup = QCMethod.groupAnimations([localPositionAnim, localHiddenAnim], fillMode:fillMode)
        local.addAnimation(localUntitled1Anim, forKey:"localUntitled1Anim")
        
        let globalneedle = layers["globalneedle"] as! CALayer
        
        ////Globalneedle animation
        let globalneedlePositionAnim          = CAKeyframeAnimation(keyPath:"position")
        globalneedlePositionAnim.path         = globalavgneedlepathPathWithBounds((layers["globalavgneedlepath"] as! CAShapeLayer).frame).CGPath
        globalneedlePositionAnim.rotationMode = kCAAnimationRotateAutoReverse
        globalneedlePositionAnim.calculationMode = kCAAnimationCubicPaced
        globalneedlePositionAnim.duration     = 2.5
        globalneedlePositionAnim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        
        let globalneedleHiddenAnim      = CAKeyframeAnimation(keyPath:"hidden")
        if(globalavgscorevalue > 0 && outerscorevalue > 0){
            globalneedleHiddenAnim.values   = [true, true, false]
        }else{
            globalneedleHiddenAnim.values   = [true, true, true]
        }
        globalneedleHiddenAnim.keyTimes = [0, 0.943, 1]
        globalneedleHiddenAnim.duration = 2.58
        
        let globalneedleUntitled1Anim : CAAnimationGroup = QCMethod.groupAnimations([globalneedlePositionAnim, globalneedleHiddenAnim], fillMode:fillMode)
        globalneedle.addAnimation(globalneedleUntitled1Anim, forKey:"globalneedleUntitled1Anim")
        
        let localneedle = layers["localneedle"] as! CALayer
        
        ////Localneedle animation
        let localneedlePositionAnim            = CAKeyframeAnimation(keyPath:"position")
        localneedlePositionAnim.path           = localavgneedlepathPathWithBounds((layers["localavgneedlepath"] as! CAShapeLayer).frame).CGPath
        localneedlePositionAnim.rotationMode   = kCAAnimationRotateAutoReverse
        localneedlePositionAnim.calculationMode = kCAAnimationCubicPaced
        localneedlePositionAnim.duration       = 2.5
        localneedlePositionAnim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        
        let localneedleHiddenAnim      = CAKeyframeAnimation(keyPath:"hidden")
        if(localavgscorevalue > 0 && outerscorevalue > 0){
        localneedleHiddenAnim.values   = [true, true, false]
        }else{
        localneedleHiddenAnim.values   = [true, true, true]
        }
        localneedleHiddenAnim.keyTimes = [0, 0.943, 1]
        localneedleHiddenAnim.duration = 2.58
        
        let localneedleUntitled1Anim : CAAnimationGroup = QCMethod.groupAnimations([localneedlePositionAnim, localneedleHiddenAnim], fillMode:fillMode)
        localneedle.addAnimation(localneedleUntitled1Anim, forKey:"localneedleUntitled1Anim")
        
        let outerscore = layers["outerscore"] as! CATextLayer
        
        ////Outerscore animation
        let outerscorePositionAnim             = CAKeyframeAnimation(keyPath:"position")
        outerscorePositionAnim.calculationMode = kCAAnimationCubicPaced
        outerscorePositionAnim.duration        = 2.5
        outerscorePositionAnim.timingFunction  = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        if(outerscorevalue < outermaxscorevalue && outerscorevalue > 0){
            outerscorePositionAnim.path            = outerstartingpathPathWithBounds((layers["outerstartingpath"] as! CAShapeLayer).frame).CGPath
        let outerscoreUntitled1Anim : CAAnimationGroup = QCMethod.groupAnimations([outerscorePositionAnim], fillMode:fillMode)
        outerscore.addAnimation(outerscoreUntitled1Anim, forKey:"outerscoreUntitled1Anim")
        }else{
            outerscorePositionAnim.path            = outerstartingpathPathWithBounds((layers["outerstartingpath"] as! CAShapeLayer).frame).CGPath
            let outerscoreUntitled1Anim : CAAnimationGroup = QCMethod.groupAnimations([outerscorePositionAnim], fillMode:fillMode)
            outerscore.addAnimation(outerscoreUntitled1Anim, forKey:"outerscoreUntitled1Anim")
        }
        let localavgscore = layers["localavgscore"] as! CATextLayer
        
        ////Localavgscore animation
        let localavgscorePositionAnim      = CAKeyframeAnimation(keyPath:"position")
        localavgscorePositionAnim.path     = localavgscorepathPathWithBounds((layers["localavgscorepath"] as! CAShapeLayer).frame).CGPath
        localavgscorePositionAnim.calculationMode = kCAAnimationCubicPaced
        localavgscorePositionAnim.duration = 2.5
        localavgscorePositionAnim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        
        let localavgscoreHiddenAnim      = CAKeyframeAnimation(keyPath:"hidden")
        if(localavgscorevalue > 0) && outerscorevalue > 0{
            localavgscoreHiddenAnim.values   = [true, true, false]
        }else{
            localavgscoreHiddenAnim.values   = [true, true, true]
        }
        localavgscoreHiddenAnim.keyTimes = [0, 0.943, 1]
        localavgscoreHiddenAnim.duration = 2.58
        
        let localavgscoreUntitled1Anim : CAAnimationGroup = QCMethod.groupAnimations([localavgscorePositionAnim, localavgscoreHiddenAnim], fillMode:fillMode)
        localavgscore.addAnimation(localavgscoreUntitled1Anim, forKey:"localavgscoreUntitled1Anim")
        
        let globalavgscore = layers["globalavgscore"] as! CATextLayer
        
        ////Globalavgscore animation
        let globalavgscorePositionAnim      = CAKeyframeAnimation(keyPath:"position")
        globalavgscorePositionAnim.path     = globalavgscorepathPathWithBounds((layers["globalavgscorepath"] as! CAShapeLayer).frame).CGPath
        globalavgscorePositionAnim.calculationMode = kCAAnimationCubicPaced
        globalavgscorePositionAnim.duration = 2.5
        globalavgscorePositionAnim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        
        let globalavgscoreHiddenAnim      = CAKeyframeAnimation(keyPath:"hidden")
        if(outerscorevalue > 0 && globalavgscorevalue > 0 && globalavgscorevalue != localavgscorevalue && globalavgscorevalue != outermaxscorevalue){
            globalavgscoreHiddenAnim.values   = [true, true, false]
        }else{
            globalavgscoreHiddenAnim.values   = [true, true, true]
        }
        globalavgscoreHiddenAnim.keyTimes = [0, 0.943, 1]
        globalavgscoreHiddenAnim.duration = 2.58
        
        let globalavgscoreUntitled1Anim : CAAnimationGroup = QCMethod.groupAnimations([globalavgscorePositionAnim, globalavgscoreHiddenAnim], fillMode:fillMode)
        globalavgscore.addAnimation(globalavgscoreUntitled1Anim, forKey:"globalavgscoreUntitled1Anim")
        
        let middlescore = layers["middlescore"] as! CATextLayer
        
        ////Middlescore animation
        let middlescorePositionAnim            = CAKeyframeAnimation(keyPath:"position")
        middlescorePositionAnim.path           = middlestartingscorepathPathWithBounds((layers["middlestartingpath"] as! CAShapeLayer).frame).CGPath
        middlescorePositionAnim.calculationMode = kCAAnimationCubicPaced
        middlescorePositionAnim.duration       = 2.5
        middlescorePositionAnim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        
        let middlescoreUntitled1Anim : CAAnimationGroup = QCMethod.groupAnimations([middlescorePositionAnim], fillMode:fillMode)
        middlescore.addAnimation(middlescoreUntitled1Anim, forKey:"middlescoreUntitled1Anim")
        
        let innerscore = layers["innerscore"] as! CATextLayer
        
        ////Innerscore animation
        let innerscorePositionAnim             = CAKeyframeAnimation(keyPath:"position")
        innerscorePositionAnim.path            = innerstartingscorepathPathWithBounds((layers["innerstartingpath"] as! CAShapeLayer).frame).CGPath
        innerscorePositionAnim.calculationMode = kCAAnimationCubicPaced
        innerscorePositionAnim.duration        = 2.5
        innerscorePositionAnim.timingFunction  = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        if(innerscorevalue < innermaxscorevalue){
        let innerscoreUntitled1Anim : CAAnimationGroup = QCMethod.groupAnimations([innerscorePositionAnim], fillMode:fillMode)
        innerscore.addAnimation(innerscoreUntitled1Anim, forKey:"innerscoreUntitled1Anim")
        }else{
            let innerscoreUntitled1Anim : CAAnimationGroup = QCMethod.groupAnimations([innerscorePositionAnim], fillMode:fillMode)
            innerscore.addAnimation(innerscoreUntitled1Anim, forKey:"innerscoreUntitled1Anim")
        }
    }
    
    //MARK: - Animation Cleanup
    
    func updateLayerValuesForAnimationId(identifier: String){
        if identifier == "Untitled1"{
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["innerstarting"] as! CALayer).animationForKey("innerstartingUntitled1Anim"), theLayer:(layers["innerstarting"] as! CALayer))
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["middlestarting"] as! CALayer).animationForKey("middlestartingUntitled1Anim"), theLayer:(layers["middlestarting"] as! CALayer))
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["outerstarting"] as! CALayer).animationForKey("outerstartingUntitled1Anim"), theLayer:(layers["outerstarting"] as! CALayer))
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["innerarrow"] as! CALayer).animationForKey("innerarrowUntitled1Anim"), theLayer:(layers["innerarrow"] as! CALayer))
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["innerstartingpath"] as! CALayer).animationForKey("innerstartingpathUntitled1Anim"), theLayer:(layers["innerstartingpath"] as! CALayer))
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["middlearrow"] as! CALayer).animationForKey("middlearrowUntitled1Anim"), theLayer:(layers["middlearrow"] as! CALayer))
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["outerarrow"] as! CALayer).animationForKey("outerarrowUntitled1Anim"), theLayer:(layers["outerarrow"] as! CALayer))
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["global"] as! CALayer).animationForKey("globalUntitled1Anim"), theLayer:(layers["global"] as! CALayer))
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["local"] as! CALayer).animationForKey("localUntitled1Anim"), theLayer:(layers["local"] as! CALayer))
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["globalneedle"] as! CALayer).animationForKey("globalneedleUntitled1Anim"), theLayer:(layers["globalneedle"] as! CALayer))
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["localneedle"] as! CALayer).animationForKey("localneedleUntitled1Anim"), theLayer:(layers["localneedle"] as! CALayer))
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["outerscore"] as! CALayer).animationForKey("outerscoreUntitled1Anim"), theLayer:(layers["outerscore"] as! CALayer))
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["localavgscore"] as! CALayer).animationForKey("localavgscoreUntitled1Anim"), theLayer:(layers["localavgscore"] as! CALayer))
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["globalavgscore"] as! CALayer).animationForKey("globalavgscoreUntitled1Anim"), theLayer:(layers["globalavgscore"] as! CALayer))
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["middlescore"] as! CALayer).animationForKey("middlescoreUntitled1Anim"), theLayer:(layers["middlescore"] as! CALayer))
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["innerscore"] as! CALayer).animationForKey("innerscoreUntitled1Anim"), theLayer:(layers["innerscore"] as! CALayer))
        }
    }
    
    func removeAnimationsForAnimationId(identifier: String){
        if identifier == "Untitled1"{
            (layers["innerstarting"] as! CALayer).removeAnimationForKey("innerstartingUntitled1Anim")
            (layers["middlestarting"] as! CALayer).removeAnimationForKey("middlestartingUntitled1Anim")
            (layers["outerstarting"] as! CALayer).removeAnimationForKey("outerstartingUntitled1Anim")
            (layers["innerarrow"] as! CALayer).removeAnimationForKey("innerarrowUntitled1Anim")
            (layers["innerstartingpath"] as! CALayer).removeAnimationForKey("innerstartingpathUntitled1Anim")
            (layers["middlearrow"] as! CALayer).removeAnimationForKey("middlearrowUntitled1Anim")
            (layers["outerarrow"] as! CALayer).removeAnimationForKey("outerarrowUntitled1Anim")
            (layers["global"] as! CALayer).removeAnimationForKey("globalUntitled1Anim")
            (layers["local"] as! CALayer).removeAnimationForKey("localUntitled1Anim")
            (layers["globalneedle"] as! CALayer).removeAnimationForKey("globalneedleUntitled1Anim")
            (layers["localneedle"] as! CALayer).removeAnimationForKey("localneedleUntitled1Anim")
            (layers["outerscore"] as! CALayer).removeAnimationForKey("outerscoreUntitled1Anim")
            (layers["localavgscore"] as! CALayer).removeAnimationForKey("localavgscoreUntitled1Anim")
            (layers["globalavgscore"] as! CALayer).removeAnimationForKey("globalavgscoreUntitled1Anim")
            (layers["middlescore"] as! CALayer).removeAnimationForKey("middlescoreUntitled1Anim")
            (layers["innerscore"] as! CALayer).removeAnimationForKey("innerscoreUntitled1Anim")
        }
    }
    
    func removeAllAnimations(){
        for layer in layers.values{
            (layer as! CALayer).removeAllAnimations()
        }
    }
    
    //MARK: - Bezier Path
    
    func ovalPathWithBounds(bounds: CGRect) -> UIBezierPath{
        let ovalPath = UIBezierPath(ovalInRect:bounds)
        return ovalPath
    }
    
    func innerbackPathWithBounds(bounds: CGRect) -> UIBezierPath{
        let innerbackPath = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        innerbackPath.moveToPoint(CGPointMake(minX, minY + 0.00012 * h))
        innerbackPath.addCurveToPoint(CGPointMake(minX + 0.75898 * w, minY + 0.00025 * h), controlPoint1:CGPointMake(minX + 0.00464 * w, minY + 0.00012 * h), controlPoint2:CGPointMake(minX + 0.7544 * w, minY + -0.00023 * h))
        innerbackPath.addCurveToPoint(CGPointMake(minX + w, minY + 0.49977 * h), controlPoint1:CGPointMake(minX + 0.8933 * w, minY + 0.01435 * h), controlPoint2:CGPointMake(minX + w, minY + 0.2326 * h))
        innerbackPath.addCurveToPoint(CGPointMake(minX + 0.74515 * w, minY + h), controlPoint1:CGPointMake(minX + w, minY + 0.77604 * h), controlPoint2:CGPointMake(minX + 0.8859 * w, minY + h))
        innerbackPath.addCurveToPoint(CGPointMake(minX + 0.49078 * w, minY + 0.53057 * h), controlPoint1:CGPointMake(minX + 0.60967 * w, minY + h), controlPoint2:CGPointMake(minX + 0.49889 * w, minY + 0.79249 * h))
        innerbackPath.addCurveToPoint(CGPointMake(minX + 0.49031 * w, minY + 0.14132 * h), controlPoint1:CGPointMake(minX + 0.49047 * w, minY + 0.52038 * h), controlPoint2:CGPointMake(minX + 0.49031 * w, minY + 0.15166 * h))
        
        return innerbackPath
    }
    
    func middlebackPathWithBounds(bounds: CGRect) -> UIBezierPath{
        let middlebackPath = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        middlebackPath.moveToPoint(CGPointMake(minX, minY + 0.00047 * h))
        middlebackPath.addCurveToPoint(CGPointMake(minX + 0.69815 * w, minY + 0.00049 * h), controlPoint1:CGPointMake(minX + 0.00902 * w, minY + 0.00047 * h), controlPoint2:CGPointMake(minX + 0.68931 * w, minY + -0.0006 * h))
        middlebackPath.addCurveToPoint(CGPointMake(minX + w, minY + 0.49942 * h), controlPoint1:CGPointMake(minX + 0.86712 * w, minY + 0.02126 * h), controlPoint2:CGPointMake(minX + w, minY + 0.23671 * h))
        middlebackPath.addCurveToPoint(CGPointMake(minX + 0.67135 * w, minY + h), controlPoint1:CGPointMake(minX + w, minY + 0.77588 * h), controlPoint2:CGPointMake(minX + 0.85286 * w, minY + h))
        middlebackPath.addCurveToPoint(CGPointMake(minX + 0.34446 * w, minY + 0.55164 * h), controlPoint1:CGPointMake(minX + 0.50142 * w, minY + h), controlPoint2:CGPointMake(minX + 0.36161 * w, minY + 0.80356 * h))
        middlebackPath.addCurveToPoint(CGPointMake(minX + 0.3427 * w, minY + 0.25027 * h), controlPoint1:CGPointMake(minX + 0.3433 * w, minY + 0.53448 * h), controlPoint2:CGPointMake(minX + 0.3427 * w, minY + 0.2679 * h))
        
        return middlebackPath
    }
    
    func outerbackPathWithBounds(bounds: CGRect) -> UIBezierPath{
        let outerbackPath = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        outerbackPath.moveToPoint(CGPointMake(minX, minY))
        outerbackPath.addCurveToPoint(CGPointMake(minX + 0.58912 * w, minY + 0.00106 * h), controlPoint1:CGPointMake(minX + 0.00971 * w, minY), controlPoint2:CGPointMake(minX + 0.57957 * w, minY + 0.00036 * h))
        outerbackPath.addCurveToPoint(CGPointMake(minX + w, minY + 0.5 * h), controlPoint1:CGPointMake(minX + 0.81853 * w, minY + 0.01798 * h), controlPoint2:CGPointMake(minX + w, minY + 0.2349 * h))
        outerbackPath.addCurveToPoint(CGPointMake(minX + 0.56022 * w, minY + h), controlPoint1:CGPointMake(minX + w, minY + 0.77614 * h), controlPoint2:CGPointMake(minX + 0.8031 * w, minY + h))
        outerbackPath.addCurveToPoint(CGPointMake(minX + 0.1216 * w, minY + 0.53664 * h), controlPoint1:CGPointMake(minX + 0.32817 * w, minY + h), controlPoint2:CGPointMake(minX + 0.1381 * w, minY + 0.79567 * h))
        outerbackPath.addCurveToPoint(CGPointMake(minX + 0.11903 * w, minY + 0.34524 * h), controlPoint1:CGPointMake(minX + 0.12083 * w, minY + 0.52454 * h), controlPoint2:CGPointMake(minX + 0.11903 * w, minY + 0.35756 * h))
        
        return outerbackPath
    }
    
    func innerstartPathWithBounds(bounds: CGRect) -> UIBezierPath{
        let innerstartPath = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        innerstartPath.moveToPoint(CGPointMake(minX, minY + 0.00012 * h))
        innerstartPath.addCurveToPoint(CGPointMake(minX + 0.75898 * w, minY + 0.00025 * h), controlPoint1:CGPointMake(minX + 0.00464 * w, minY + 0.00012 * h), controlPoint2:CGPointMake(minX + 0.7544 * w, minY + -0.00023 * h))
        innerstartPath.addCurveToPoint(CGPointMake(minX + w, minY + 0.49977 * h), controlPoint1:CGPointMake(minX + 0.8933 * w, minY + 0.01435 * h), controlPoint2:CGPointMake(minX + w, minY + 0.2326 * h))
        innerstartPath.addCurveToPoint(CGPointMake(minX + 0.74515 * w, minY + h), controlPoint1:CGPointMake(minX + w, minY + 0.77604 * h), controlPoint2:CGPointMake(minX + 0.8859 * w, minY + h))
        innerstartPath.addCurveToPoint(CGPointMake(minX + 0.49078 * w, minY + 0.53057 * h), controlPoint1:CGPointMake(minX + 0.60967 * w, minY + h), controlPoint2:CGPointMake(minX + 0.49889 * w, minY + 0.79249 * h))
        innerstartPath.addCurveToPoint(CGPointMake(minX + 0.49031 * w, minY + 0.14132 * h), controlPoint1:CGPointMake(minX + 0.49047 * w, minY + 0.52038 * h), controlPoint2:CGPointMake(minX + 0.49031 * w, minY + 0.15166 * h))
        
        return innerstartPath
    }
    
    func middlestartPathWithBounds(bounds: CGRect) -> UIBezierPath{
        let middlestartPath = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        middlestartPath.moveToPoint(CGPointMake(minX, minY + 0.00047 * h))
        middlestartPath.addCurveToPoint(CGPointMake(minX + 0.69815 * w, minY + 0.00049 * h), controlPoint1:CGPointMake(minX + 0.00902 * w, minY + 0.00047 * h), controlPoint2:CGPointMake(minX + 0.68931 * w, minY + -0.0006 * h))
        middlestartPath.addCurveToPoint(CGPointMake(minX + w, minY + 0.49942 * h), controlPoint1:CGPointMake(minX + 0.86712 * w, minY + 0.02126 * h), controlPoint2:CGPointMake(minX + w, minY + 0.23671 * h))
        middlestartPath.addCurveToPoint(CGPointMake(minX + 0.67135 * w, minY + h), controlPoint1:CGPointMake(minX + w, minY + 0.77588 * h), controlPoint2:CGPointMake(minX + 0.85286 * w, minY + h))
        middlestartPath.addCurveToPoint(CGPointMake(minX + 0.34446 * w, minY + 0.55164 * h), controlPoint1:CGPointMake(minX + 0.50142 * w, minY + h), controlPoint2:CGPointMake(minX + 0.36161 * w, minY + 0.80356 * h))
        middlestartPath.addCurveToPoint(CGPointMake(minX + 0.3427 * w, minY + 0.25027 * h), controlPoint1:CGPointMake(minX + 0.3433 * w, minY + 0.53448 * h), controlPoint2:CGPointMake(minX + 0.3427 * w, minY + 0.2679 * h))
        
        return middlestartPath
    }
    
    func outerstartPathWithBounds(bounds: CGRect) -> UIBezierPath{
        let outerstartPath = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        outerstartPath.moveToPoint(CGPointMake(minX, minY))
        outerstartPath.addCurveToPoint(CGPointMake(minX + 0.58912 * w, minY + 0.00106 * h), controlPoint1:CGPointMake(minX + 0.00971 * w, minY), controlPoint2:CGPointMake(minX + 0.57957 * w, minY + 0.00036 * h))
        outerstartPath.addCurveToPoint(CGPointMake(minX + w, minY + 0.5 * h), controlPoint1:CGPointMake(minX + 0.81853 * w, minY + 0.01798 * h), controlPoint2:CGPointMake(minX + w, minY + 0.2349 * h))
        outerstartPath.addCurveToPoint(CGPointMake(minX + 0.56022 * w, minY + h), controlPoint1:CGPointMake(minX + w, minY + 0.77614 * h), controlPoint2:CGPointMake(minX + 0.8031 * w, minY + h))
        outerstartPath.addCurveToPoint(CGPointMake(minX + 0.1216 * w, minY + 0.53664 * h), controlPoint1:CGPointMake(minX + 0.32817 * w, minY + h), controlPoint2:CGPointMake(minX + 0.1381 * w, minY + 0.79567 * h))
        outerstartPath.addCurveToPoint(CGPointMake(minX + 0.11903 * w, minY + 0.34524 * h), controlPoint1:CGPointMake(minX + 0.12083 * w, minY + 0.52454 * h), controlPoint2:CGPointMake(minX + 0.11903 * w, minY + 0.35756 * h))
        
        return outerstartPath
    }
    
    func innerstartingPathWithBounds(bounds: CGRect) -> UIBezierPath{
        if(innerscorevalue < innermaxscorevalue){
        var f: CGFloat = (180 * (CGFloat(innerscorevalue) / CGFloat(innermaxscorevalue)))
        f = f + (2 * (180 - f))
        let bound = bounds
        let ovalstartingPath = UIBezierPath(arcCenter:CGPointMake(0, 0), radius:CGRectGetWidth(bound)/2, startAngle:-90 * CGFloat(M_PI)/180, endAngle:-f * CGFloat(M_PI)/180, clockwise:true)
        var pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound))
        pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound))
        ovalstartingPath.applyTransform(pathTransform)
        return ovalstartingPath
        }else{
            let innerstartingPath = UIBezierPath()
            let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
            
            innerstartingPath.moveToPoint(CGPointMake(minX + 0.49965 * w, minY))
            innerstartingPath.addCurveToPoint(CGPointMake(minX + w, minY + 0.5 * h), controlPoint1:CGPointMake(minX + 0.77598 * w, minY), controlPoint2:CGPointMake(minX + w, minY + 0.22386 * h))
            innerstartingPath.addCurveToPoint(CGPointMake(minX + 0.49965 * w, minY + h), controlPoint1:CGPointMake(minX + w, minY + 0.77614 * h), controlPoint2:CGPointMake(minX + 0.77598 * w, minY + h))
            innerstartingPath.addCurveToPoint(CGPointMake(minX + 0.00092 * w, minY + 0.54054 * h), controlPoint1:CGPointMake(minX + 0.23697 * w, minY + h), controlPoint2:CGPointMake(minX + 0.02157 * w, minY + 0.79772 * h))
            innerstartingPath.addCurveToPoint(CGPointMake(minX + 0.00001 * w, minY + 0.14193 * h), controlPoint1:CGPointMake(minX + -0.00016 * w, minY + 0.52717 * h), controlPoint2:CGPointMake(minX + 0.00001 * w, minY + 0.15558 * h))
            
            return innerstartingPath
        }
    }
    
    
    func middlestartingPathWithBounds(bounds: CGRect) -> UIBezierPath{
        if(middlescorevalue < middlemaxscorevalue){
        var f: CGFloat = (180 * (CGFloat(middlescorevalue) / CGFloat(middlemaxscorevalue)))
        f = f + (2 * (180 - f))
        let bound = bounds
        let ovalstartingPath = UIBezierPath(arcCenter:CGPointMake(0, 0), radius:CGRectGetWidth(bound)/2, startAngle:-90 * CGFloat(M_PI)/180, endAngle:-f * CGFloat(M_PI)/180, clockwise:true)
        var pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound))
        pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound))
        ovalstartingPath.applyTransform(pathTransform)
        return ovalstartingPath
        }else{
        let middlestartingPath = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        middlestartingPath.moveToPoint(CGPointMake(minX + 0.50002 * w, minY))
        middlestartingPath.addCurveToPoint(CGPointMake(minX + w, minY + 0.5 * h), controlPoint1:CGPointMake(minX + 0.77615 * w, minY), controlPoint2:CGPointMake(minX + w, minY + 0.22386 * h))
        middlestartingPath.addCurveToPoint(CGPointMake(minX + 0.50002 * w, minY + h), controlPoint1:CGPointMake(minX + w, minY + 0.77614 * h), controlPoint2:CGPointMake(minX + 0.77615 * w, minY + h))
        middlestartingPath.addCurveToPoint(CGPointMake(minX + 0.00061 * w, minY + 0.52402 * h), controlPoint1:CGPointMake(minX + 0.23195 * w, minY + h), controlPoint2:CGPointMake(minX + 0.01315 * w, minY + 0.78901 * h))
        middlestartingPath.addCurveToPoint(CGPointMake(minX, minY + 0.24959 * h), controlPoint1:CGPointMake(minX + 0.00024 * w, minY + 0.51606 * h), controlPoint2:CGPointMake(minX, minY + 0.25764 * h))
        
        return middlestartingPath
        }

    }
    
    func outerstartingPathWithBounds(bounds: CGRect) -> UIBezierPath{
        if(outerscorevalue < outermaxscorevalue){
        var f: CGFloat = (180 * (CGFloat(outerscorevalue) / CGFloat(outermaxscorevalue)))
        f = f + (2 * (180 - f))
        let bound = bounds
        let ovalstartingPath = UIBezierPath(arcCenter:CGPointMake(0, 0), radius:CGRectGetWidth(bound)/2, startAngle:-90 * CGFloat(M_PI)/180, endAngle:-f * CGFloat(M_PI)/180, clockwise:true)
        var pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound))
        pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound))
        ovalstartingPath.applyTransform(pathTransform)
        return ovalstartingPath
        }else{
            let outerstartingPath = UIBezierPath()
            let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;            
            outerstartingPath.moveToPoint(CGPointMake(minX + 0.5015 * w, minY))
            outerstartingPath.addCurveToPoint(CGPointMake(minX + w, minY + 0.5 * h), controlPoint1:CGPointMake(minX + 0.77681 * w, minY), controlPoint2:CGPointMake(minX + w, minY + 0.22386 * h))
            outerstartingPath.addCurveToPoint(CGPointMake(minX + 0.5015 * w, minY + h), controlPoint1:CGPointMake(minX + w, minY + 0.77614 * h), controlPoint2:CGPointMake(minX + 0.77681 * w, minY + h))
            outerstartingPath.addCurveToPoint(CGPointMake(minX + 0.00379 * w, minY + 0.5284 * h), controlPoint1:CGPointMake(minX + 0.23569 * w, minY + h), controlPoint2:CGPointMake(minX + 0.01847 * w, minY + 0.79133 * h))
            outerstartingPath.addCurveToPoint(CGPointMake(minX, minY + 0.34544 * h), controlPoint1:CGPointMake(minX + 0.00326 * w, minY + 0.519 * h), controlPoint2:CGPointMake(minX, minY + 0.35497 * h))
            return outerstartingPath
        }

    }
    
    func innerarrowPathWithBounds(bounds: CGRect) -> UIBezierPath{
        let innerarrowPath = UIBezierPath(rect:bounds)
        return innerarrowPath
    }
    
    func innerstartingpathPathWithBounds(bounds: CGRect) -> UIBezierPath{
        if(innerscorevalue < innermaxscorevalue){
            var f: CGFloat = (180 * (CGFloat(innerscorevalue) / CGFloat(innermaxscorevalue)))
            f = f + (2 * (180 - f))
            let bound = bounds
            let ovalstartingPath = UIBezierPath(arcCenter:CGPointMake(0, 0), radius:CGRectGetWidth(bound)/2, startAngle:-90 * CGFloat(M_PI)/180, endAngle:-f * CGFloat(M_PI)/180, clockwise:true)
            var pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound))
            pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound))
            ovalstartingPath.applyTransform(pathTransform)
            return ovalstartingPath
        }else{
            let innerstartingPath = UIBezierPath()
            let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
            
            innerstartingPath.moveToPoint(CGPointMake(minX + 0.49974 * w, minY))
            innerstartingPath.addCurveToPoint(CGPointMake(minX + w, minY + 0.5 * h), controlPoint1:CGPointMake(minX + 0.77603 * w, minY), controlPoint2:CGPointMake(minX + w, minY + 0.22386 * h))
            innerstartingPath.addCurveToPoint(CGPointMake(minX + 0.49974 * w, minY + h), controlPoint1:CGPointMake(minX + w, minY + 0.77614 * h), controlPoint2:CGPointMake(minX + 0.77603 * w, minY + h))
            innerstartingPath.addCurveToPoint(CGPointMake(minX + 0.00111 * w, minY + 0.54054 * h), controlPoint1:CGPointMake(minX + 0.23711 * w, minY + h), controlPoint2:CGPointMake(minX + 0.02175 * w, minY + 0.79772 * h))
            innerstartingPath.addCurveToPoint(CGPointMake(minX, minY + 0.24981 * h), controlPoint1:CGPointMake(minX + 0.00003 * w, minY + 0.52717 * h), controlPoint2:CGPointMake(minX + 0.00351 * w, minY + 0.3749 * h))
            
            return innerstartingPath
       }


    }

    
    func innerstartingscorepathPathWithBounds(bounds: CGRect) -> UIBezierPath{
        if(innerscorevalue < innermaxscorevalue){
            var f: CGFloat = (180 * (CGFloat(Float(innerscorevalue) - 0.5) / CGFloat(innermaxscorevalue)))
            f = f + (2 * (180 - f))
            let bound = bounds            
            let ovalstartingPath = UIBezierPath(arcCenter:CGPointMake(0, 0), radius:CGRectGetWidth(bound)/2, startAngle:-90 * CGFloat(M_PI)/180, endAngle:-f * CGFloat(M_PI)/180, clockwise:true)
            var pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound))
            pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound))
            ovalstartingPath.applyTransform(pathTransform)
            return ovalstartingPath
        }else{
            let innerstartingPath = UIBezierPath()
            let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
            
            innerstartingPath.moveToPoint(CGPointMake(minX + 0.49974 * w, minY))
            innerstartingPath.addCurveToPoint(CGPointMake(minX + w, minY + 0.5 * h), controlPoint1:CGPointMake(minX + 0.77603 * w, minY), controlPoint2:CGPointMake(minX + w, minY + 0.22386 * h))
            innerstartingPath.addCurveToPoint(CGPointMake(minX + 0.49974 * w, minY + h), controlPoint1:CGPointMake(minX + w, minY + 0.77614 * h), controlPoint2:CGPointMake(minX + 0.77603 * w, minY + h))
            innerstartingPath.addCurveToPoint(CGPointMake(minX + 0.00111 * w, minY + 0.54054 * h), controlPoint1:CGPointMake(minX + 0.23711 * w, minY + h), controlPoint2:CGPointMake(minX + 0.02175 * w, minY + 0.79772 * h))
            innerstartingPath.addCurveToPoint(CGPointMake(minX, minY + 0.24981 * h), controlPoint1:CGPointMake(minX + 0.00003 * w, minY + 0.52717 * h), controlPoint2:CGPointMake(minX + 0.00351 * w, minY + 0.3749 * h))
            
            return innerstartingPath
        }
        
        
    }

    
    func middlestartingpathPathWithBounds(bounds: CGRect) -> UIBezierPath{
        if(middlescorevalue < middlemaxscorevalue){
            var f: CGFloat = (180 * (CGFloat(middlescorevalue) / CGFloat(middlemaxscorevalue)))
            f = f + (2 * (180 - f))
            let bound = bounds
            let ovalstartingPath = UIBezierPath(arcCenter:CGPointMake(0, 0), radius:CGRectGetWidth(bound)/2, startAngle:-90 * CGFloat(M_PI)/180, endAngle:-f * CGFloat(M_PI)/180, clockwise:true)
            var pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound))
            pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound))
            ovalstartingPath.applyTransform(pathTransform)
            return ovalstartingPath
        }else{
            let middlestartingPath = UIBezierPath()
            let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
            
            middlestartingPath.moveToPoint(CGPointMake(minX + 0.50167 * w, minY))
            middlestartingPath.addCurveToPoint(CGPointMake(minX + w, minY + 0.5 * h), controlPoint1:CGPointMake(minX + 0.77689 * w, minY), controlPoint2:CGPointMake(minX + w, minY + 0.22386 * h))
            middlestartingPath.addCurveToPoint(CGPointMake(minX + 0.50167 * w, minY + h), controlPoint1:CGPointMake(minX + w, minY + 0.77614 * h), controlPoint2:CGPointMake(minX + 0.77689 * w, minY + h))
            middlestartingPath.addCurveToPoint(CGPointMake(minX + 0.00391 * w, minY + 0.52402 * h), controlPoint1:CGPointMake(minX + 0.23448 * w, minY + h), controlPoint2:CGPointMake(minX + 0.0164 * w, minY + 0.78901 * h))
            middlestartingPath.addCurveToPoint(CGPointMake(minX, minY + 0.32451 * h), controlPoint1:CGPointMake(minX + 0.00354 * w, minY + 0.51606 * h), controlPoint2:CGPointMake(minX, minY + 0.33256 * h))
            
            return middlestartingPath
        }
    }

    func middlestartingscorepathPathWithBounds(bounds: CGRect) -> UIBezierPath{
        if(middlescorevalue < middlemaxscorevalue){
            var f: CGFloat = (180 * (CGFloat(Float(middlescorevalue) - 0.3) / CGFloat(middlemaxscorevalue)))
            f = f + (2 * (180 - f))
            let bound = bounds
            let ovalstartingPath = UIBezierPath(arcCenter:CGPointMake(0, 0), radius:CGRectGetWidth(bound)/2, startAngle:-90 * CGFloat(M_PI)/180, endAngle:-f * CGFloat(M_PI)/180, clockwise:true)
            var pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound))
            pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound))
            ovalstartingPath.applyTransform(pathTransform)
            return ovalstartingPath
        }else{
            let middlestartingPath = UIBezierPath()
            let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
            
            middlestartingPath.moveToPoint(CGPointMake(minX + 0.50167 * w, minY))
            middlestartingPath.addCurveToPoint(CGPointMake(minX + w, minY + 0.5 * h), controlPoint1:CGPointMake(minX + 0.77689 * w, minY), controlPoint2:CGPointMake(minX + w, minY + 0.22386 * h))
            middlestartingPath.addCurveToPoint(CGPointMake(minX + 0.50167 * w, minY + h), controlPoint1:CGPointMake(minX + w, minY + 0.77614 * h), controlPoint2:CGPointMake(minX + 0.77689 * w, minY + h))
            middlestartingPath.addCurveToPoint(CGPointMake(minX + 0.00391 * w, minY + 0.52402 * h), controlPoint1:CGPointMake(minX + 0.23448 * w, minY + h), controlPoint2:CGPointMake(minX + 0.0164 * w, minY + 0.78901 * h))
            middlestartingPath.addCurveToPoint(CGPointMake(minX, minY + 0.32451 * h), controlPoint1:CGPointMake(minX + 0.00354 * w, minY + 0.51606 * h), controlPoint2:CGPointMake(minX, minY + 0.33256 * h))
            
            return middlestartingPath
        }
    }

    
    func outerstartingpathPathWithBounds(bounds: CGRect) -> UIBezierPath{
        print(outerscorevalue,outermaxscorevalue)
        if(outerscorevalue < outermaxscorevalue){
            var f: CGFloat = (180 * (CGFloat(outerscorevalue) / CGFloat(outermaxscorevalue)))
            f = f + (2 * (180 - f))
            print("outer",f)
            let bound = bounds
            let ovalstartingPath = UIBezierPath(arcCenter:CGPointMake(0, 0), radius:CGRectGetWidth(bound)/2, startAngle:-90 * CGFloat(M_PI)/180, endAngle:-f * CGFloat(M_PI)/180, clockwise:true)
            var pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound))
            pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound))
            ovalstartingPath.applyTransform(pathTransform)
            return ovalstartingPath
        }else{
            let outerstartingPath = UIBezierPath()
            let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
            
            outerstartingPath.moveToPoint(CGPointMake(minX + 0.50075 * w, minY))
            outerstartingPath.addCurveToPoint(CGPointMake(minX + w, minY + 0.5 * h), controlPoint1:CGPointMake(minX + 0.77648 * w, minY), controlPoint2:CGPointMake(minX + w, minY + 0.22386 * h))
            outerstartingPath.addCurveToPoint(CGPointMake(minX + 0.50075 * w, minY + h), controlPoint1:CGPointMake(minX + w, minY + 0.77614 * h), controlPoint2:CGPointMake(minX + 0.77648 * w, minY + h))
            outerstartingPath.addCurveToPoint(CGPointMake(minX + 0.00229 * w, minY + 0.5284 * h), controlPoint1:CGPointMake(minX + 0.23454 * w, minY + h), controlPoint2:CGPointMake(minX + 0.01699 * w, minY + 0.79133 * h))
            outerstartingPath.addCurveToPoint(CGPointMake(minX, minY + 0.39062 * h), controlPoint1:CGPointMake(minX + 0.00177 * w, minY + 0.519 * h), controlPoint2:CGPointMake(minX, minY + 0.40015 * h))
            
            return outerstartingPath

        }

    }
    
    func middlearrowPathWithBounds(bounds: CGRect) -> UIBezierPath{
        let middlearrowPath = UIBezierPath(rect:bounds)
        return middlearrowPath
    }
    
    func outerarrowPathWithBounds(bounds: CGRect) -> UIBezierPath{
        let outerarrowPath = UIBezierPath(rect:bounds)
        return outerarrowPath
    }
    
    func localavgscorepathPathWithBounds(bounds: CGRect) -> UIBezierPath{
        if(localavgscorevalue != outermaxscorevalue){
        var f: CGFloat = (180 * (CGFloat(localavgscorevalue) / CGFloat(outermaxscorevalue)))        
        f = f + (2 * (180 - f))
        let bound = bounds
        let ovalstartingPath = UIBezierPath(arcCenter:CGPointMake(0, 0), radius:CGRectGetWidth(bound)/2, startAngle:-90 * CGFloat(M_PI)/180, endAngle:-f * CGFloat(M_PI)/180, clockwise:true)
        var pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound))
        pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound))
        ovalstartingPath.applyTransform(pathTransform)
        return ovalstartingPath
        }else{
            let outerstartingPath = UIBezierPath()
            let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
            
            outerstartingPath.moveToPoint(CGPointMake(minX + 0.50075 * w, minY))
            outerstartingPath.addCurveToPoint(CGPointMake(minX + w, minY + 0.5 * h), controlPoint1:CGPointMake(minX + 0.77648 * w, minY), controlPoint2:CGPointMake(minX + w, minY + 0.22386 * h))
            outerstartingPath.addCurveToPoint(CGPointMake(minX + 0.50075 * w, minY + h), controlPoint1:CGPointMake(minX + w, minY + 0.77614 * h), controlPoint2:CGPointMake(minX + 0.77648 * w, minY + h))
            outerstartingPath.addCurveToPoint(CGPointMake(minX + 0.00229 * w, minY + 0.5284 * h), controlPoint1:CGPointMake(minX + 0.23454 * w, minY + h), controlPoint2:CGPointMake(minX + 0.01699 * w, minY + 0.79133 * h))
            outerstartingPath.addCurveToPoint(CGPointMake(minX, minY + 0.39062 * h), controlPoint1:CGPointMake(minX + 0.00177 * w, minY + 0.519 * h), controlPoint2:CGPointMake(minX, minY + 0.40015 * h))
            
            return outerstartingPath
        }

    }
    
    func globalavgscorepathPathWithBounds(bounds: CGRect) -> UIBezierPath{
        if(globalavgscorevalue != outermaxscorevalue){
        var f: CGFloat = (180 * (CGFloat(globalavgscorevalue) / CGFloat(outermaxscorevalue)))
        f = f + (2 * (180 - f))
        if(localavgscorevalue == globalavgscorevalue){
            f = f - 2.5
        }
        let bound = bounds
        let ovalstartingPath = UIBezierPath(arcCenter:CGPointMake(0, 0), radius:CGRectGetWidth(bound)/2, startAngle:-90 * CGFloat(M_PI)/180, endAngle:-f * CGFloat(M_PI)/180, clockwise:true)
        var pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound))
        pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound))
        ovalstartingPath.applyTransform(pathTransform)
        return ovalstartingPath
        }else{
            let outerstartingPath = UIBezierPath()
            let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
            
            outerstartingPath.moveToPoint(CGPointMake(minX + 0.50075 * w, minY))
            outerstartingPath.addCurveToPoint(CGPointMake(minX + w, minY + 0.5 * h), controlPoint1:CGPointMake(minX + 0.77648 * w, minY), controlPoint2:CGPointMake(minX + w, minY + 0.22386 * h))
            outerstartingPath.addCurveToPoint(CGPointMake(minX + 0.50075 * w, minY + h), controlPoint1:CGPointMake(minX + w, minY + 0.77614 * h), controlPoint2:CGPointMake(minX + 0.77648 * w, minY + h))
            outerstartingPath.addCurveToPoint(CGPointMake(minX + 0.00229 * w, minY + 0.5284 * h), controlPoint1:CGPointMake(minX + 0.23454 * w, minY + h), controlPoint2:CGPointMake(minX + 0.01699 * w, minY + 0.79133 * h))
            outerstartingPath.addCurveToPoint(CGPointMake(minX, minY + 0.39062 * h), controlPoint1:CGPointMake(minX + 0.00177 * w, minY + 0.519 * h), controlPoint2:CGPointMake(minX, minY + 0.40015 * h))
            
            return outerstartingPath
        }
    }
    
    func localavgneedlepathPathWithBounds(bounds: CGRect) -> UIBezierPath{
        if(localavgscorevalue != outermaxscorevalue){
        var f: CGFloat = (180 * (CGFloat(localavgscorevalue) / CGFloat(outermaxscorevalue)))
        f = f + (2 * (180 - f))
        let bound = bounds
        let ovalstartingPath = UIBezierPath(arcCenter:CGPointMake(0, 0), radius:CGRectGetWidth(bound)/2, startAngle:-90 * CGFloat(M_PI)/180, endAngle:-f * CGFloat(M_PI)/180, clockwise:true)
        var pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound))
        pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound))
        ovalstartingPath.applyTransform(pathTransform)
        return ovalstartingPath
        }else{
            let outerstartingPath = UIBezierPath()
            let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
            
            outerstartingPath.moveToPoint(CGPointMake(minX + 0.50075 * w, minY))
            outerstartingPath.addCurveToPoint(CGPointMake(minX + w, minY + 0.5 * h), controlPoint1:CGPointMake(minX + 0.77648 * w, minY), controlPoint2:CGPointMake(minX + w, minY + 0.22386 * h))
            outerstartingPath.addCurveToPoint(CGPointMake(minX + 0.50075 * w, minY + h), controlPoint1:CGPointMake(minX + w, minY + 0.77614 * h), controlPoint2:CGPointMake(minX + 0.77648 * w, minY + h))
            outerstartingPath.addCurveToPoint(CGPointMake(minX + 0.00229 * w, minY + 0.5284 * h), controlPoint1:CGPointMake(minX + 0.23454 * w, minY + h), controlPoint2:CGPointMake(minX + 0.01699 * w, minY + 0.79133 * h))
            outerstartingPath.addCurveToPoint(CGPointMake(minX, minY + 0.39062 * h), controlPoint1:CGPointMake(minX + 0.00177 * w, minY + 0.519 * h), controlPoint2:CGPointMake(minX, minY + 0.40015 * h))
            
            return outerstartingPath
        }
    }
    
    func localavgpathPathWithBounds(bounds: CGRect) -> UIBezierPath{
        if(localavgscorevalue != outermaxscorevalue){
        var f: CGFloat = (180 * (CGFloat(localavgscorevalue) / CGFloat(outermaxscorevalue)))
        f = f + (2 * (180 - f))
        let bound = bounds
        let ovalstartingPath = UIBezierPath(arcCenter:CGPointMake(0, 0), radius:CGRectGetWidth(bound)/2, startAngle:-90 * CGFloat(M_PI)/180, endAngle:-f * CGFloat(M_PI)/180, clockwise:true)
        var pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound))
        pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound))
        ovalstartingPath.applyTransform(pathTransform)
        return ovalstartingPath
    }else{
    let outerstartingPath = UIBezierPath()
    let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
    
    outerstartingPath.moveToPoint(CGPointMake(minX + 0.50075 * w, minY))
    outerstartingPath.addCurveToPoint(CGPointMake(minX + w, minY + 0.5 * h), controlPoint1:CGPointMake(minX + 0.77648 * w, minY), controlPoint2:CGPointMake(minX + w, minY + 0.22386 * h))
    outerstartingPath.addCurveToPoint(CGPointMake(minX + 0.50075 * w, minY + h), controlPoint1:CGPointMake(minX + w, minY + 0.77614 * h), controlPoint2:CGPointMake(minX + 0.77648 * w, minY + h))
    outerstartingPath.addCurveToPoint(CGPointMake(minX + 0.00229 * w, minY + 0.5284 * h), controlPoint1:CGPointMake(minX + 0.23454 * w, minY + h), controlPoint2:CGPointMake(minX + 0.01699 * w, minY + 0.79133 * h))
    outerstartingPath.addCurveToPoint(CGPointMake(minX, minY + 0.39062 * h), controlPoint1:CGPointMake(minX + 0.00177 * w, minY + 0.519 * h), controlPoint2:CGPointMake(minX, minY + 0.40015 * h))
    
    return outerstartingPath
    }
    }

    func globalavgneedlepathPathWithBounds(bounds: CGRect) -> UIBezierPath{
        if(globalavgscorevalue != outermaxscorevalue){
        var f: CGFloat = (180 * (CGFloat(globalavgscorevalue) / CGFloat(outermaxscorevalue)))
        f = f + (2 * (180 - f))
        let bound = bounds
        print("Global",f)
        if(globalavgscorevalue == localavgscorevalue){
        f = f - 4.5
        }
        let ovalstartingPath = UIBezierPath(arcCenter:CGPointMake(0, 0), radius:CGRectGetWidth(bound)/2, startAngle:-90 * CGFloat(M_PI)/180, endAngle:-f * CGFloat(M_PI)/180, clockwise:true)
        var pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound))
        pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound))
        ovalstartingPath.applyTransform(pathTransform)
        return ovalstartingPath
    }else{
            let outerstartingPath = UIBezierPath()
            let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
            
            outerstartingPath.moveToPoint(CGPointMake(minX + 0.50075 * w, minY))
            outerstartingPath.addCurveToPoint(CGPointMake(minX + w, minY + 0.5 * h), controlPoint1:CGPointMake(minX + 0.77648 * w, minY), controlPoint2:CGPointMake(minX + w, minY + 0.22386 * h))
            outerstartingPath.addCurveToPoint(CGPointMake(minX + 0.50075 * w, minY + h), controlPoint1:CGPointMake(minX + w, minY + 0.77614 * h), controlPoint2:CGPointMake(minX + 0.77648 * w, minY + h))
            outerstartingPath.addCurveToPoint(CGPointMake(minX + 0.00229 * w, minY + 0.5284 * h), controlPoint1:CGPointMake(minX + 0.23454 * w, minY + h), controlPoint2:CGPointMake(minX + 0.01699 * w, minY + 0.79133 * h))
            outerstartingPath.addCurveToPoint(CGPointMake(minX, minY + 0.39062 * h), controlPoint1:CGPointMake(minX + 0.00177 * w, minY + 0.519 * h), controlPoint2:CGPointMake(minX, minY + 0.40015 * h))
            
            return outerstartingPath
        }

    }
    
    func globalavgpathPathWithBounds(bounds: CGRect) -> UIBezierPath{
        if(globalavgscorevalue != outermaxscorevalue){
        var f: CGFloat = (180 * (CGFloat(globalavgscorevalue) / CGFloat(outermaxscorevalue)))
        f = f + (2 * (180 - f))
        if(globalavgscorevalue == localavgscorevalue){
            f = f - 4.5
        }
        let bound = bounds
        let ovalstartingPath = UIBezierPath(arcCenter:CGPointMake(0, 0), radius:CGRectGetWidth(bound)/2, startAngle:-90 * CGFloat(M_PI)/180, endAngle:-f * CGFloat(M_PI)/180, clockwise:true)
        var pathTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(bound), CGRectGetMidY(bound))
        pathTransform = CGAffineTransformScale(pathTransform, 1, CGRectGetHeight(bound)/CGRectGetWidth(bound))
        ovalstartingPath.applyTransform(pathTransform)
        return ovalstartingPath
        }else{
            let outerstartingPath = UIBezierPath()
            let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
            
            outerstartingPath.moveToPoint(CGPointMake(minX + 0.50075 * w, minY))
            outerstartingPath.addCurveToPoint(CGPointMake(minX + w, minY + 0.5 * h), controlPoint1:CGPointMake(minX + 0.77648 * w, minY), controlPoint2:CGPointMake(minX + w, minY + 0.22386 * h))
            outerstartingPath.addCurveToPoint(CGPointMake(minX + 0.50075 * w, minY + h), controlPoint1:CGPointMake(minX + w, minY + 0.77614 * h), controlPoint2:CGPointMake(minX + 0.77648 * w, minY + h))
            outerstartingPath.addCurveToPoint(CGPointMake(minX + 0.00229 * w, minY + 0.5284 * h), controlPoint1:CGPointMake(minX + 0.23454 * w, minY + h), controlPoint2:CGPointMake(minX + 0.01699 * w, minY + 0.79133 * h))
            outerstartingPath.addCurveToPoint(CGPointMake(minX, minY + 0.39062 * h), controlPoint1:CGPointMake(minX + 0.00177 * w, minY + 0.519 * h), controlPoint2:CGPointMake(minX, minY + 0.40015 * h))
            
            return outerstartingPath
        }
    }
    
    
}
