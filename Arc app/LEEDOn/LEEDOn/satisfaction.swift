//
//  chartview.swift
//
//  Code generated using QuartzCode 1.52.0 on 22/11/16.
//  www.quartzcodeapp.com
//

import UIKit

class satisfaction: UIView {
    
    var layers : Dictionary<String, AnyObject> = [:]
    
    var maxarraysize = 0
    var maxvalue = 0
    //MARK: - Life Cycle
    var data:[Int] = [Int]()
    var data2:[Int] = [Int]()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupProperties()
        //data2 = NSUserDefaults.standardUserDefaults().objectForKey("data2") as! [Int]
        data = NSUserDefaults.standardUserDefaults().objectForKey("satisfaction") as! [Int]
        if(data2.count==0){
            data2 = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
        }
        if(data.count==0){
            data = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
        }        
        print(data,data2)
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
        var temp1 = 0
        var temp2 = 0
        temp1 = data.maxElement()!
        temp2 = data2.maxElement()!
        maxvalue = 10
        temp2 = data2.count
        temp1 = data.count
        maxarraysize = [temp1,temp2].maxElement()!
        
        let rectangle = CAShapeLayer()
        self.layer.addSublayer(rectangle)
        rectangle.fillColor   = UIColor(red:0.922, green: 0.922, blue:0.922, alpha:1).CGColor
        rectangle.strokeColor = UIColor(red:0.329, green: 0.329, blue:0.329, alpha:1).CGColor
        layers["rectangle"] = rectangle
        
        let measurescales = CALayer()
        self.layer.addSublayer(measurescales)
        
        layers["measurescales"] = measurescales
        let rectangle2 = CAShapeLayer()
        measurescales.addSublayer(rectangle2)
        rectangle2.opacity         = 0.46
        rectangle2.fillColor       = UIColor(red:0.922, green: 0.922, blue:0.922, alpha:1).CGColor
        rectangle2.strokeColor     = UIColor(red:0.329, green: 0.329, blue:0.329, alpha:1).CGColor
        rectangle2.lineWidth       = 0.2
        rectangle2.lineDashPattern = [2, 7]
        layers["rectangle2"] = rectangle2
        let rectangle3 = CAShapeLayer()
        measurescales.addSublayer(rectangle3)
        rectangle3.opacity         = 0.46
        rectangle3.fillColor       = UIColor(red:0.922, green: 0.922, blue:0.922, alpha:1).CGColor
        rectangle3.strokeColor     = UIColor(red:0.329, green: 0.329, blue:0.329, alpha:1).CGColor
        rectangle3.lineWidth       = 0.2
        rectangle3.lineDashPattern = [2, 7]
        layers["rectangle3"] = rectangle3
        let rectangle4 = CAShapeLayer()
        measurescales.addSublayer(rectangle4)
        rectangle4.opacity         = 0.46
        rectangle4.fillColor       = UIColor(red:0.922, green: 0.922, blue:0.922, alpha:1).CGColor
        rectangle4.strokeColor     = UIColor(red:0.329, green: 0.329, blue:0.329, alpha:1).CGColor
        rectangle4.lineWidth       = 0.2
        rectangle4.lineDashPattern = [2, 7]
        layers["rectangle4"] = rectangle4
        let rectangle5 = CAShapeLayer()
        measurescales.addSublayer(rectangle5)
        rectangle5.opacity         = 0.46
        rectangle5.fillColor       = UIColor(red:0.922, green: 0.922, blue:0.922, alpha:1).CGColor
        rectangle5.strokeColor     = UIColor(red:0.329, green: 0.329, blue:0.329, alpha:1).CGColor
        rectangle5.lineWidth       = 0.2
        rectangle5.lineDashPattern = [2, 7]
        layers["rectangle5"] = rectangle5
        let rectangle6 = CAShapeLayer()
        measurescales.addSublayer(rectangle6)
        rectangle6.opacity         = 0.46
        rectangle6.fillColor       = UIColor(red:0.922, green: 0.922, blue:0.922, alpha:1).CGColor
        rectangle6.strokeColor     = UIColor(red:0.329, green: 0.329, blue:0.329, alpha:1).CGColor
        rectangle6.lineWidth       = 0.2
        rectangle6.lineDashPattern = [2, 7]
        layers["rectangle6"] = rectangle6
        let rectangle7 = CAShapeLayer()
        measurescales.addSublayer(rectangle7)
        rectangle7.opacity         = 0.46
        rectangle7.fillColor       = UIColor(red:0.922, green: 0.922, blue:0.922, alpha:1).CGColor
        rectangle7.strokeColor     = UIColor(red:0.329, green: 0.329, blue:0.329, alpha:1).CGColor
        rectangle7.lineWidth       = 0.2
        rectangle7.lineDashPattern = [2, 7]
        layers["rectangle7"] = rectangle7
        let rectangle8 = CAShapeLayer()
        measurescales.addSublayer(rectangle8)
        rectangle8.opacity         = 0.46
        rectangle8.fillColor       = UIColor(red:0.922, green: 0.922, blue:0.922, alpha:1).CGColor
        rectangle8.strokeColor     = UIColor(red:0.329, green: 0.329, blue:0.329, alpha:1).CGColor
        rectangle8.lineWidth       = 0.2
        rectangle8.lineDashPattern = [2, 7]
        layers["rectangle8"] = rectangle8
        let rectangle9 = CAShapeLayer()
        measurescales.addSublayer(rectangle9)
        rectangle9.opacity         = 0.46
        rectangle9.fillColor       = UIColor(red:0.922, green: 0.922, blue:0.922, alpha:1).CGColor
        rectangle9.strokeColor     = UIColor(red:0.329, green: 0.329, blue:0.329, alpha:1).CGColor
        rectangle9.lineWidth       = 0.2
        rectangle9.lineDashPattern = [2, 7]
        layers["rectangle9"] = rectangle9
        let rectangle10 = CAShapeLayer()
        measurescales.addSublayer(rectangle10)
        rectangle10.opacity         = 0.46
        rectangle10.fillColor       = UIColor(red:0.922, green: 0.922, blue:0.922, alpha:1).CGColor
        rectangle10.strokeColor     = UIColor(red:0.329, green: 0.329, blue:0.329, alpha:1).CGColor
        rectangle10.lineWidth       = 0.2
        rectangle10.lineDashPattern = [2, 7]
        layers["rectangle10"] = rectangle10
        let rectangle11 = CAShapeLayer()
        measurescales.addSublayer(rectangle11)
        rectangle11.opacity         = 0.46
        rectangle11.fillColor       = UIColor(red:0.922, green: 0.922, blue:0.922, alpha:1).CGColor
        rectangle11.strokeColor     = UIColor(red:0.329, green: 0.329, blue:0.329, alpha:1).CGColor
        rectangle11.lineWidth       = 0.2
        rectangle11.lineDashPattern = [2, 7]
        layers["rectangle11"] = rectangle11
        
        let bar = CALayer()
        self.layer.addSublayer(bar)
        
        layers["bar"] = bar
        let back = CAShapeLayer()
        bar.addSublayer(back)
        back.fillColor   = nil
        back.strokeColor = UIColor(red:0.662, green: 0.625, blue:0.539, alpha:1).CGColor
        back.lineWidth   = 10
        layers["back"] = back
        
        let front = CAShapeLayer()
        bar.addSublayer(front)
        front.fillColor   = nil
        front.strokeColor = UIColor.init(red: 0.92, green: 0.609, blue: 0.236, alpha: 1).CGColor
        front.lineWidth   = 10
        front.strokeEnd   = 0
        layers["front"] = front
        
        let bar2 = CALayer()
        self.layer.addSublayer(bar2)
        
        layers["bar2"] = bar2
        let back2 = CAShapeLayer()
        bar2.addSublayer(back2)
        back2.fillColor   = nil
        back2.strokeColor = UIColor(red:0.662, green: 0.625, blue:0.539, alpha:1).CGColor
        back2.lineWidth   = 10
        back2.strokeEnd   = 0
        layers["back2"] = back2
        let front2 = CAShapeLayer()
        bar2.addSublayer(front2)
        front2.fillColor   = nil
        front2.strokeColor = UIColor.init(red: 0.92, green: 0.609, blue: 0.236, alpha: 1).CGColor
        front2.lineWidth   = 10
        front2.strokeEnd   = 0
        layers["front2"] = front2
        
        let bar3 = CALayer()
        self.layer.addSublayer(bar3)
        
        layers["bar3"] = bar3
        let back3 = CAShapeLayer()
        bar3.addSublayer(back3)
        back3.fillColor   = nil
        back3.strokeColor = UIColor(red:0.662, green: 0.625, blue:0.539, alpha:1).CGColor
        back3.lineWidth   = 10
        back3.strokeEnd   = 0
        layers["back3"] = back3
        let front3 = CAShapeLayer()
        bar3.addSublayer(front3)
        front3.fillColor   = nil
        front3.strokeColor = UIColor.init(red: 0.92, green: 0.609, blue: 0.236, alpha: 1).CGColor
        front3.lineWidth   = 10
        front3.strokeEnd   = 0
        layers["front3"] = front3
        
        let bar4 = CALayer()
        self.layer.addSublayer(bar4)
        
        layers["bar4"] = bar4
        let back4 = CAShapeLayer()
        bar4.addSublayer(back4)
        back4.fillColor   = nil
        back4.strokeColor = UIColor(red:0.662, green: 0.625, blue:0.539, alpha:1).CGColor
        back4.lineWidth   = 10
        back4.strokeEnd   = 0
        layers["back4"] = back4
        let front4 = CAShapeLayer()
        bar4.addSublayer(front4)
        front4.fillColor   = nil
        front4.strokeColor = UIColor.init(red: 0.92, green: 0.609, blue: 0.236, alpha: 1).CGColor
        front4.lineWidth   = 10
        front4.strokeEnd   = 0
        layers["front4"] = front4
        
        let bar5 = CALayer()
        self.layer.addSublayer(bar5)
        
        layers["bar5"] = bar5
        let back5 = CAShapeLayer()
        bar5.addSublayer(back5)
        back5.fillColor   = nil
        back5.strokeColor = UIColor(red:0.662, green: 0.625, blue:0.539, alpha:1).CGColor
        back5.lineWidth   = 10
        back5.strokeEnd   = 0
        layers["back5"] = back5
        let front5 = CAShapeLayer()
        bar5.addSublayer(front5)
        front5.fillColor   = nil
        front5.strokeColor = UIColor.init(red: 0.92, green: 0.609, blue: 0.236, alpha: 1).CGColor
        front5.lineWidth   = 10
        front5.strokeEnd   = 0
        layers["front5"] = front5
        
        let bar6 = CALayer()
        self.layer.addSublayer(bar6)
        
        layers["bar6"] = bar6
        let back6 = CAShapeLayer()
        bar6.addSublayer(back6)
        back6.fillColor   = nil
        back6.strokeColor = UIColor(red:0.662, green: 0.625, blue:0.539, alpha:1).CGColor
        back6.lineWidth   = 10
        back6.strokeEnd   = 0
        layers["back6"] = back6
        let front6 = CAShapeLayer()
        bar6.addSublayer(front6)
        front6.fillColor   = nil
        front6.strokeColor = UIColor.init(red: 0.92, green: 0.609, blue: 0.236, alpha: 1).CGColor
        front6.lineWidth   = 10
        front6.strokeEnd   = 0
        layers["front6"] = front6
        
        let bar7 = CALayer()
        self.layer.addSublayer(bar7)
        
        layers["bar7"] = bar7
        let back7 = CAShapeLayer()
        bar7.addSublayer(back7)
        back7.fillColor   = nil
        back7.strokeColor = UIColor(red:0.662, green: 0.625, blue:0.539, alpha:1).CGColor
        back7.lineWidth   = 10
        back7.strokeEnd   = 0
        layers["back7"] = back7
        let front7 = CAShapeLayer()
        bar7.addSublayer(front7)
        front7.fillColor   = nil
        front7.strokeColor = UIColor.init(red: 0.92, green: 0.609, blue: 0.236, alpha: 1).CGColor
        front7.lineWidth   = 10
        front7.strokeEnd   = 0
        layers["front7"] = front7
        
        let bar8 = CALayer()
        self.layer.addSublayer(bar8)
        
        layers["bar8"] = bar8
        let back8 = CAShapeLayer()
        bar8.addSublayer(back8)
        back8.fillColor   = nil
        back8.strokeColor = UIColor(red:0.662, green: 0.625, blue:0.539, alpha:1).CGColor
        back8.lineWidth   = 10
        back8.strokeEnd   = 0
        layers["back8"] = back8
        let front8 = CAShapeLayer()
        bar8.addSublayer(front8)
        front8.fillColor   = nil
        front8.strokeColor = UIColor.init(red: 0.92, green: 0.609, blue: 0.236, alpha: 1).CGColor
        front8.lineWidth   = 10
        front8.strokeEnd   = 0
        layers["front8"] = front8
        
        let bar9 = CALayer()
        self.layer.addSublayer(bar9)
        
        layers["bar9"] = bar9
        let back9 = CAShapeLayer()
        bar9.addSublayer(back9)
        back9.fillColor   = nil
        back9.strokeColor = UIColor(red:0.662, green: 0.625, blue:0.539, alpha:1).CGColor
        back9.lineWidth   = 10
        back9.strokeEnd   = 0
        layers["back9"] = back9
        let front9 = CAShapeLayer()
        bar9.addSublayer(front9)
        front9.fillColor   = nil
        front9.strokeColor = UIColor.init(red: 0.92, green: 0.609, blue: 0.236, alpha: 1).CGColor
        front9.lineWidth   = 10
        front9.strokeEnd   = 0
        layers["front9"] = front9
        
        let bar10 = CALayer()
        self.layer.addSublayer(bar10)
        
        layers["bar10"] = bar10
        let back10 = CAShapeLayer()
        bar10.addSublayer(back10)
        back10.fillColor   = nil
        back10.strokeColor = UIColor(red:0.662, green: 0.625, blue:0.539, alpha:1).CGColor
        back10.lineWidth   = 10
        back10.strokeEnd   = 0
        layers["back10"] = back10
        let front10 = CAShapeLayer()
        bar10.addSublayer(front10)
        front10.fillColor   = nil
        front10.strokeColor = UIColor.init(red: 0.92, green: 0.609, blue: 0.236, alpha: 1).CGColor
        front10.lineWidth   = 10
        front10.strokeEnd   = 0
        layers["front10"] = front10
        
        let bar11 = CALayer()
        self.layer.addSublayer(bar11)
        
        layers["bar11"] = bar11
        let back11 = CAShapeLayer()
        bar11.addSublayer(back11)
        back11.fillColor   = nil
        back11.strokeColor = UIColor(red:0.662, green: 0.625, blue:0.539, alpha:1).CGColor
        back11.lineWidth   = 10
        back11.strokeEnd   = 0
        layers["back11"] = back11
        let front11 = CAShapeLayer()
        bar11.addSublayer(front11)
        front11.fillColor   = nil
        front11.strokeColor = UIColor.init(red: 0.92, green: 0.609, blue: 0.236, alpha: 1).CGColor
        front11.lineWidth   = 10
        front11.strokeEnd   = 0
        layers["front11"] = front11
        
        let bar12 = CALayer()
        self.layer.addSublayer(bar12)
        
        layers["bar12"] = bar12
        let back12 = CAShapeLayer()
        bar12.addSublayer(back12)
        back12.fillColor   = nil
        back12.strokeColor = UIColor(red:0.662, green: 0.625, blue:0.539, alpha:1).CGColor
        back12.lineWidth   = 10
        back12.strokeEnd   = 0
        layers["back12"] = back12
        let front12 = CAShapeLayer()
        bar12.addSublayer(front12)
        front12.fillColor   = nil
        front12.strokeColor = UIColor.init(red: 0.92, green: 0.609, blue: 0.236, alpha: 1).CGColor
        front12.lineWidth   = 10
        front12.strokeEnd   = 0
        layers["front12"] = front12
        
        let bar13 = CALayer()
        self.layer.addSublayer(bar13)
        
        layers["bar13"] = bar13
        let back13 = CAShapeLayer()
        bar13.addSublayer(back13)
        back13.fillColor   = nil
        back13.strokeColor = UIColor(red:0.662, green: 0.625, blue:0.539, alpha:1).CGColor
        back13.lineWidth   = 10
        back13.strokeEnd   = 0
        layers["back13"] = back13
        let front13 = CAShapeLayer()
        bar13.addSublayer(front13)
        front13.fillColor   = nil
        front13.strokeColor = UIColor.init(red: 0.92, green: 0.609, blue: 0.236, alpha: 1).CGColor
        front13.lineWidth   = 10
        front13.strokeEnd   = 0
        layers["front13"] = front13
        
        let bar14 = CALayer()
        self.layer.addSublayer(bar14)
        
        layers["bar14"] = bar14
        let back14 = CAShapeLayer()
        bar14.addSublayer(back14)
        back14.fillColor   = nil
        back14.strokeColor = UIColor(red:0.662, green: 0.625, blue:0.539, alpha:1).CGColor
        back14.lineWidth   = 10
        back14.strokeEnd   = 0
        layers["back14"] = back14
        let front14 = CAShapeLayer()
        bar14.addSublayer(front14)
        front14.fillColor   = nil
        front14.strokeColor = UIColor.init(red: 0.92, green: 0.609, blue: 0.236, alpha: 1).CGColor
        front14.lineWidth   = 10
        front14.strokeEnd   = 0
        layers["front14"] = front14
        
        let bar15 = CALayer()
        self.layer.addSublayer(bar15)
        
        layers["bar15"] = bar15
        let back15 = CAShapeLayer()
        bar15.addSublayer(back15)
        back15.fillColor   = nil
        back15.strokeColor = UIColor(red:0.662, green: 0.625, blue:0.539, alpha:1).CGColor
        back15.lineWidth   = 10
        back15.strokeEnd   = 0
        layers["back15"] = back15
        let front15 = CAShapeLayer()
        bar15.addSublayer(front15)
        front15.fillColor   = nil
        front15.strokeColor = UIColor.init(red: 0.92, green: 0.609, blue: 0.236, alpha: 1).CGColor
        front15.lineWidth   = 10
        front15.strokeEnd   = 0
        layers["front15"] = front15
        
        let text = CATextLayer()
        self.layer.addSublayer(text)
        text.contentsScale   = UIScreen.mainScreen().scale
        text.string          = "1\n"
        text.font            = "Helvetica"
        text.fontSize        = 7
        text.alignmentMode   = kCAAlignmentRight;
        text.foregroundColor = UIColor.blackColor().CGColor;
        layers["text"] = text
        
        let text2 = CATextLayer()
        self.layer.addSublayer(text2)
        text2.contentsScale   = UIScreen.mainScreen().scale
        text2.string          = "2\n"
        text2.font            = "Helvetica"
        text2.fontSize        = 7
        text2.alignmentMode   = kCAAlignmentRight;
        text2.foregroundColor = UIColor.blackColor().CGColor;
        layers["text2"] = text2
        
        let text3 = CATextLayer()
        self.layer.addSublayer(text3)
        text3.contentsScale   = UIScreen.mainScreen().scale
        text3.string          = "3\n"
        text3.font            = "Helvetica"
        text3.fontSize        = 7
        text3.alignmentMode   = kCAAlignmentRight;
        text3.foregroundColor = UIColor.blackColor().CGColor;
        layers["text3"] = text3
        
        let text4 = CATextLayer()
        self.layer.addSublayer(text4)
        text4.contentsScale   = UIScreen.mainScreen().scale
        text4.string          = "4\n"
        text4.font            = "Helvetica"
        text4.fontSize        = 7
        text4.alignmentMode   = kCAAlignmentRight;
        text4.foregroundColor = UIColor.blackColor().CGColor;
        layers["text4"] = text4
        
        let text5 = CATextLayer()
        self.layer.addSublayer(text5)
        text5.contentsScale   = UIScreen.mainScreen().scale
        text5.string          = "5\n"
        text5.font            = "Helvetica"
        text5.fontSize        = 7
        text5.alignmentMode   = kCAAlignmentRight;
        text5.foregroundColor = UIColor.blackColor().CGColor;
        layers["text5"] = text5
        
        let text6 = CATextLayer()
        self.layer.addSublayer(text6)
        text6.contentsScale   = UIScreen.mainScreen().scale
        text6.string          = "6\n"
        text6.font            = "Helvetica"
        text6.fontSize        = 7
        text6.alignmentMode   = kCAAlignmentRight;
        text6.foregroundColor = UIColor.blackColor().CGColor;
        layers["text6"] = text6
        
        let text7 = CATextLayer()
        self.layer.addSublayer(text7)
        text7.contentsScale   = UIScreen.mainScreen().scale
        text7.string          = "7\n"
        text7.font            = "Helvetica"
        text7.fontSize        = 7
        text7.alignmentMode   = kCAAlignmentRight;
        text7.foregroundColor = UIColor.blackColor().CGColor;
        layers["text7"] = text7
        
        let text8 = CATextLayer()
        self.layer.addSublayer(text8)
        text8.contentsScale   = UIScreen.mainScreen().scale
        text8.string          = "8\n"
        text8.font            = "Helvetica"
        text8.fontSize        = 7
        text8.alignmentMode   = kCAAlignmentRight;
        text8.foregroundColor = UIColor.blackColor().CGColor;
        layers["text8"] = text8
        
        let text9 = CATextLayer()
        self.layer.addSublayer(text9)
        text9.contentsScale   = UIScreen.mainScreen().scale
        text9.string          = "9\n"
        text9.font            = "Helvetica"
        text9.fontSize        = 7
        text9.alignmentMode   = kCAAlignmentRight;
        text9.foregroundColor = UIColor.blackColor().CGColor;
        layers["text9"] = text9
        
        let text10 = CATextLayer()
        self.layer.addSublayer(text10)
        text10.contentsScale   = UIScreen.mainScreen().scale
        text10.string          = "10\n"
        text10.font            = "Helvetica"
        text10.fontSize        = 7
        text10.alignmentMode   = kCAAlignmentRight;
        text10.foregroundColor = UIColor.blackColor().CGColor;
        layers["text10"] = text10
        
        let durationtext = CATextLayer()
        self.layer.addSublayer(durationtext)
        durationtext.contentsScale   = UIScreen.mainScreen().scale
        durationtext.string          = "Satisfaction ratings (1-10)\n"
        durationtext.font            = "Helvetica"
        durationtext.fontSize        = 7
        durationtext.alignmentMode   = kCAAlignmentCenter;
        durationtext.foregroundColor = UIColor.blackColor().CGColor;
        layers["durationtext"] = durationtext
        
        let title = CATextLayer()
        self.layer.addSublayer(title)
        title.contentsScale   = UIScreen.mainScreen().scale
        title.string          = "Satisfaction"
        title.font            = "Helvetica-Bold"
        title.fontSize        = 9
        title.alignmentMode   = kCAAlignmentCenter;
        title.foregroundColor = UIColor.blackColor().CGColor;
        layers["title"] = title
        

        
        
        
        setupLayerFrames()
    }
    
    func setupLayerFrames(){
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        var container = CAShapeLayer()
        if let rectangle : CAShapeLayer = layers["rectangle"] as? CAShapeLayer{
            rectangle.frame = CGRectMake(0.16937 * rectangle.superlayer!.bounds.width, 0.10812 * rectangle.superlayer!.bounds.height, 0.73333 * rectangle.superlayer!.bounds.width, 0.73333 * rectangle.superlayer!.bounds.height)
            rectangle.path  = rectanglePathWithBounds((layers["rectangle"] as! CAShapeLayer).bounds).CGPath
            container = rectangle
        }
        
        if let measurescales : CALayer = layers["measurescales"] as? CALayer{
            measurescales.frame = CGRectMake(0.15844 * measurescales.superlayer!.bounds.width, 0.10833 * measurescales.superlayer!.bounds.height, 0.73929 * measurescales.superlayer!.bounds.width, 0.66333 * measurescales.superlayer!.bounds.height)
        }
        
        if let rectangle2 : CAShapeLayer = layers["rectangle2"] as? CAShapeLayer{
            rectangle2.frame = CGRectMake(0, 0, 1 * rectangle2.superlayer!.bounds.width, 0.00503 * rectangle2.superlayer!.bounds.height)
            rectangle2.path  = rectangle2PathWithBounds((layers["rectangle2"] as! CAShapeLayer).bounds).CGPath
        }
        
        if let rectangle3 : CAShapeLayer = layers["rectangle3"] as? CAShapeLayer{
            rectangle3.frame = CGRectMake(0, 0.11055 * rectangle3.superlayer!.bounds.height, 1 * rectangle3.superlayer!.bounds.width, 0.00503 * rectangle3.superlayer!.bounds.height)
            rectangle3.path  = rectangle3PathWithBounds((layers["rectangle3"] as! CAShapeLayer).bounds).CGPath
        }
        
        if let rectangle4 : CAShapeLayer = layers["rectangle4"] as? CAShapeLayer{
            rectangle4.frame = CGRectMake(0, 0.22111 * rectangle4.superlayer!.bounds.height, 1 * rectangle4.superlayer!.bounds.width, 0.00503 * rectangle4.superlayer!.bounds.height)
            rectangle4.path  = rectangle4PathWithBounds((layers["rectangle4"] as! CAShapeLayer).bounds).CGPath
        }
        
        if let rectangle5 : CAShapeLayer = layers["rectangle5"] as? CAShapeLayer{
            rectangle5.frame = CGRectMake(0, 0.33166 * rectangle5.superlayer!.bounds.height, 1 * rectangle5.superlayer!.bounds.width, 0.00503 * rectangle5.superlayer!.bounds.height)
            rectangle5.path  = rectangle5PathWithBounds((layers["rectangle5"] as! CAShapeLayer).bounds).CGPath
        }
        
        if let rectangle6 : CAShapeLayer = layers["rectangle6"] as? CAShapeLayer{
            rectangle6.frame = CGRectMake(0, 0.44221 * rectangle6.superlayer!.bounds.height, 1 * rectangle6.superlayer!.bounds.width, 0.00503 * rectangle6.superlayer!.bounds.height)
            rectangle6.path  = rectangle6PathWithBounds((layers["rectangle6"] as! CAShapeLayer).bounds).CGPath
        }
        
        if let rectangle7 : CAShapeLayer = layers["rectangle7"] as? CAShapeLayer{
            rectangle7.frame = CGRectMake(0, 0.55276 * rectangle7.superlayer!.bounds.height, 1 * rectangle7.superlayer!.bounds.width, 0.00503 * rectangle7.superlayer!.bounds.height)
            rectangle7.path  = rectangle7PathWithBounds((layers["rectangle7"] as! CAShapeLayer).bounds).CGPath
        }
        
        if let rectangle8 : CAShapeLayer = layers["rectangle8"] as? CAShapeLayer{
            rectangle8.frame = CGRectMake(0, 0.66332 * rectangle8.superlayer!.bounds.height, 1 * rectangle8.superlayer!.bounds.width, 0.00503 * rectangle8.superlayer!.bounds.height)
            rectangle8.path  = rectangle8PathWithBounds((layers["rectangle8"] as! CAShapeLayer).bounds).CGPath
        }
        
        if let rectangle9 : CAShapeLayer = layers["rectangle9"] as? CAShapeLayer{
            rectangle9.frame = CGRectMake(0, 0.77387 * rectangle9.superlayer!.bounds.height, 1 * rectangle9.superlayer!.bounds.width, 0.00503 * rectangle9.superlayer!.bounds.height)
            rectangle9.path  = rectangle9PathWithBounds((layers["rectangle9"] as! CAShapeLayer).bounds).CGPath
        }
        
        if let rectangle10 : CAShapeLayer = layers["rectangle10"] as? CAShapeLayer{
            rectangle10.frame = CGRectMake(0, 0.88442 * rectangle10.superlayer!.bounds.height, 1 * rectangle10.superlayer!.bounds.width, 0.00503 * rectangle10.superlayer!.bounds.height)
            rectangle10.path  = rectangle10PathWithBounds((layers["rectangle10"] as! CAShapeLayer).bounds).CGPath
        }
        
        if let rectangle11 : CAShapeLayer = layers["rectangle11"] as? CAShapeLayer{
            rectangle11.frame = CGRectMake(0, 0.99497 * rectangle11.superlayer!.bounds.height, 1 * rectangle11.superlayer!.bounds.width, 0.00503 * rectangle11.superlayer!.bounds.height)
            rectangle11.path  = rectangle11PathWithBounds((layers["rectangle11"] as! CAShapeLayer).bounds).CGPath
        }
        
        if let bar : CALayer = layers["bar"] as? CALayer{
            bar.frame = CGRectMake(0.20333 * bar.superlayer!.bounds.width, 0.10707 * bar.superlayer!.bounds.height, 0, 0.73333 * bar.superlayer!.bounds.height)
        }
        
        if let back : CAShapeLayer = layers["back"] as? CAShapeLayer{
            back.frame = CGRectMake( back.superlayer!.bounds.width, 0, 0, 1 * back.superlayer!.bounds.height)
            back.path  = backPathWithBounds((layers["back"] as! CAShapeLayer).bounds).CGPath
            back.lineWidth = 0.05*container.frame.size.width
        }
        
        if let front : CAShapeLayer = layers["front"] as? CAShapeLayer{
            front.frame = CGRectMake( front.superlayer!.bounds.width, 0, 0, 1 * front.superlayer!.bounds.height)
            front.path  = frontPathWithBounds((layers["front"] as! CAShapeLayer).bounds).CGPath
            front.lineWidth = (0.05*container.frame.size.width)
        }
        
        if let bar2 : CALayer = layers["bar2"] as? CALayer{
            bar2.frame = CGRectMake(0.25142 * bar2.superlayer!.bounds.width, 0.10707 * bar2.superlayer!.bounds.height, 0, 0.73333 * bar2.superlayer!.bounds.height)
            
        }
        
        if let back2 : CAShapeLayer = layers["back2"] as? CAShapeLayer{
            back2.frame = CGRectMake( back2.superlayer!.bounds.width, 0, 0,  back2.superlayer!.bounds.height)
            back2.path  = back2PathWithBounds((layers["back2"] as! CAShapeLayer).bounds).CGPath
            back2.lineWidth = 0.05*container.frame.size.width
        }
        
        if let front2 : CAShapeLayer = layers["front2"] as? CAShapeLayer{
            front2.frame = CGRectMake( front2.superlayer!.bounds.width, 0, 0,  front2.superlayer!.bounds.height)
            front2.path  = front2PathWithBounds((layers["front2"] as! CAShapeLayer).bounds).CGPath
            front2.lineWidth = 0.05*container.frame.size.width
        }
        
        if let bar3 : CALayer = layers["bar3"] as? CALayer{
            bar3.frame = CGRectMake(0.29808 * bar3.superlayer!.bounds.width, 0.10707 * bar3.superlayer!.bounds.height, 0, 0.73333 * bar3.superlayer!.bounds.height)
        }
        
        if let back3 : CAShapeLayer = layers["back3"] as? CAShapeLayer{
            back3.frame = CGRectMake( back3.superlayer!.bounds.width, 0, 0,  back3.superlayer!.bounds.height)
            back3.path  = back3PathWithBounds((layers["back3"] as! CAShapeLayer).bounds).CGPath
            back3.lineWidth = 0.05*container.frame.size.width
        }
        
        if let front3 : CAShapeLayer = layers["front3"] as? CAShapeLayer{
            front3.frame = CGRectMake( front3.superlayer!.bounds.width, 0, 0,  front3.superlayer!.bounds.height)
            front3.path  = front3PathWithBounds((layers["front3"] as! CAShapeLayer).bounds).CGPath
            front3.lineWidth = 0.05*container.frame.size.width
        }
        
        if let bar4 : CALayer = layers["bar4"] as? CALayer{
            bar4.frame = CGRectMake(0.34475 * bar4.superlayer!.bounds.width, 0.10707 * bar4.superlayer!.bounds.height, 0, 0.73333 * bar4.superlayer!.bounds.height)
            
        }
        
        if let back4 : CAShapeLayer = layers["back4"] as? CAShapeLayer{
            back4.frame = CGRectMake( back4.superlayer!.bounds.width, 0, 0,  back4.superlayer!.bounds.height)
            back4.path  = back4PathWithBounds((layers["back4"] as! CAShapeLayer).bounds).CGPath
            back4.lineWidth = 0.05*container.frame.size.width
        }
        
        if let front4 : CAShapeLayer = layers["front4"] as? CAShapeLayer{
            front4.frame = CGRectMake( front4.superlayer!.bounds.width, 0, 0,  front4.superlayer!.bounds.height)
            front4.path  = front4PathWithBounds((layers["front4"] as! CAShapeLayer).bounds).CGPath
            front4.lineWidth = 0.05*container.frame.size.width
        }
        
        if let bar5 : CALayer = layers["bar5"] as? CALayer{
            bar5.frame = CGRectMake(0.39142 * bar5.superlayer!.bounds.width, 0.10707 * bar5.superlayer!.bounds.height, 0, 0.73333 * bar5.superlayer!.bounds.height)
        }
        
        if let back5 : CAShapeLayer = layers["back5"] as? CAShapeLayer{
            back5.frame = CGRectMake( back5.superlayer!.bounds.width, 0, 0,  back5.superlayer!.bounds.height)
            back5.path  = back5PathWithBounds((layers["back5"] as! CAShapeLayer).bounds).CGPath
            back5.lineWidth = 0.05*container.frame.size.width
        }
        
        if let front5 : CAShapeLayer = layers["front5"] as? CAShapeLayer{
            front5.frame = CGRectMake( front5.superlayer!.bounds.width, 0, 0,  front5.superlayer!.bounds.height)
            front5.path  = front5PathWithBounds((layers["front5"] as! CAShapeLayer).bounds).CGPath
            front5.lineWidth = 0.05*container.frame.size.width
        }
        
        if let bar6 : CALayer = layers["bar6"] as? CALayer{
            bar6.frame = CGRectMake(0.43808 * bar6.superlayer!.bounds.width, 0.10707 * bar6.superlayer!.bounds.height, 0, 0.73333 * bar6.superlayer!.bounds.height)
        }
        
        if let back6 : CAShapeLayer = layers["back6"] as? CAShapeLayer{
            back6.frame = CGRectMake( back6.superlayer!.bounds.width, 0, 0,  back6.superlayer!.bounds.height)
            back6.path  = back6PathWithBounds((layers["back6"] as! CAShapeLayer).bounds).CGPath
            back6.lineWidth = 0.05*container.frame.size.width
        }
        
        if let front6 : CAShapeLayer = layers["front6"] as? CAShapeLayer{
            front6.frame = CGRectMake( front6.superlayer!.bounds.width, 0, 0,  front6.superlayer!.bounds.height)
            front6.path  = front6PathWithBounds((layers["front6"] as! CAShapeLayer).bounds).CGPath
            front6.lineWidth = 0.05*container.frame.size.width
        }
        
        if let bar7 : CALayer = layers["bar7"] as? CALayer{
            bar7.frame = CGRectMake(0.48475 * bar7.superlayer!.bounds.width, 0.10707 * bar7.superlayer!.bounds.height, 0, 0.73333 * bar7.superlayer!.bounds.height)
        }
        
        if let back7 : CAShapeLayer = layers["back7"] as? CAShapeLayer{
            back7.frame = CGRectMake( back7.superlayer!.bounds.width, 0, 0,  back7.superlayer!.bounds.height)
            back7.path  = back7PathWithBounds((layers["back7"] as! CAShapeLayer).bounds).CGPath
            back7.lineWidth = 0.05*container.frame.size.width
        }
        
        if let front7 : CAShapeLayer = layers["front7"] as? CAShapeLayer{
            front7.frame = CGRectMake( front7.superlayer!.bounds.width, 0, 0,  front7.superlayer!.bounds.height)
            front7.path  = front7PathWithBounds((layers["front7"] as! CAShapeLayer).bounds).CGPath
            front7.lineWidth = 0.05*container.frame.size.width
        }
        
        if let bar8 : CALayer = layers["bar8"] as? CALayer{
            bar8.frame = CGRectMake(0.53142 * bar8.superlayer!.bounds.width, 0.10707 * bar8.superlayer!.bounds.height, 0, 0.73333 * bar8.superlayer!.bounds.height)
        }
        
        if let back8 : CAShapeLayer = layers["back8"] as? CAShapeLayer{
            back8.frame = CGRectMake( back8.superlayer!.bounds.width, 0, 0,  back8.superlayer!.bounds.height)
            back8.path  = back8PathWithBounds((layers["back8"] as! CAShapeLayer).bounds).CGPath
            back8.lineWidth = 0.05*container.frame.size.width
        }
        
        if let front8 : CAShapeLayer = layers["front8"] as? CAShapeLayer{
            front8.frame = CGRectMake( front8.superlayer!.bounds.width, 0, 0,  front8.superlayer!.bounds.height)
            front8.path  = front8PathWithBounds((layers["front8"] as! CAShapeLayer).bounds).CGPath
            front8.lineWidth = 0.05*container.frame.size.width
        }
        
        if let bar9 : CALayer = layers["bar9"] as? CALayer{
            bar9.frame = CGRectMake(0.57808 * bar9.superlayer!.bounds.width, 0.10707 * bar9.superlayer!.bounds.height, 0, 0.73333 * bar9.superlayer!.bounds.height)
        }
        
        if let back9 : CAShapeLayer = layers["back9"] as? CAShapeLayer{
            back9.frame = CGRectMake( back9.superlayer!.bounds.width, 0, 0,  back9.superlayer!.bounds.height)
            back9.path  = back9PathWithBounds((layers["back9"] as! CAShapeLayer).bounds).CGPath
            back9.lineWidth = 0.05*container.frame.size.width
        }
        
        if let front9 : CAShapeLayer = layers["front9"] as? CAShapeLayer{
            front9.frame = CGRectMake( front9.superlayer!.bounds.width, 0, 0,  front9.superlayer!.bounds.height)
            front9.path  = front9PathWithBounds((layers["front9"] as! CAShapeLayer).bounds).CGPath
            front9.lineWidth = 0.05*container.frame.size.width
        }
        
        if let bar10 : CALayer = layers["bar10"] as? CALayer{
            bar10.frame = CGRectMake(0.62475 * bar10.superlayer!.bounds.width, 0.10707 * bar10.superlayer!.bounds.height, 0, 0.73333 * bar10.superlayer!.bounds.height)
        }
        
        if let back10 : CAShapeLayer = layers["back10"] as? CAShapeLayer{
            back10.frame = CGRectMake( back10.superlayer!.bounds.width, 0, 0,  back10.superlayer!.bounds.height)
            back10.path  = back10PathWithBounds((layers["back10"] as! CAShapeLayer).bounds).CGPath
            back10.lineWidth = 0.05*container.frame.size.width
        }
        
        if let front10 : CAShapeLayer = layers["front10"] as? CAShapeLayer{
            front10.frame = CGRectMake( front10.superlayer!.bounds.width, 0, 0,  front10.superlayer!.bounds.height)
            front10.path  = front10PathWithBounds((layers["front10"] as! CAShapeLayer).bounds).CGPath
            front10.lineWidth = 0.05*container.frame.size.width
        }
        
        if let bar11 : CALayer = layers["bar11"] as? CALayer{
            bar11.frame = CGRectMake(0.67142 * bar11.superlayer!.bounds.width, 0.10707 * bar11.superlayer!.bounds.height, 0, 0.73333 * bar11.superlayer!.bounds.height)
        }
        
        if let back11 : CAShapeLayer = layers["back11"] as? CAShapeLayer{
            back11.frame = CGRectMake( back11.superlayer!.bounds.width, 0, 0,  back11.superlayer!.bounds.height)
            back11.path  = back11PathWithBounds((layers["back11"] as! CAShapeLayer).bounds).CGPath
            back11.lineWidth = 0.05*container.frame.size.width
        }
        
        if let front11 : CAShapeLayer = layers["front11"] as? CAShapeLayer{
            front11.frame = CGRectMake( front11.superlayer!.bounds.width, 0, 0,  front11.superlayer!.bounds.height)
            front11.path  = front11PathWithBounds((layers["front11"] as! CAShapeLayer).bounds).CGPath
            front11.lineWidth = 0.05*container.frame.size.width
        }
        
        if let bar12 : CALayer = layers["bar12"] as? CALayer{
            bar12.frame = CGRectMake(0.71808 * bar12.superlayer!.bounds.width, 0.10707 * bar12.superlayer!.bounds.height, 0, 0.73333 * bar12.superlayer!.bounds.height)
        }
        
        if let back12 : CAShapeLayer = layers["back12"] as? CAShapeLayer{
            back12.frame = CGRectMake( back12.superlayer!.bounds.width, 0, 0,  back12.superlayer!.bounds.height)
            back12.path  = back12PathWithBounds((layers["back12"] as! CAShapeLayer).bounds).CGPath
            back12.lineWidth = 0.05*container.frame.size.width
        }
        
        if let front12 : CAShapeLayer = layers["front12"] as? CAShapeLayer{
            front12.frame = CGRectMake( front12.superlayer!.bounds.width, 0, 0,  front12.superlayer!.bounds.height)
            front12.path  = front12PathWithBounds((layers["front12"] as! CAShapeLayer).bounds).CGPath
            front12.lineWidth = 0.05*container.frame.size.width
        }
        
        if let bar13 : CALayer = layers["bar13"] as? CALayer{
            bar13.frame = CGRectMake(0.76475 * bar13.superlayer!.bounds.width, 0.10707 * bar13.superlayer!.bounds.height, 0, 0.73333 * bar13.superlayer!.bounds.height)
        }
        
        if let back13 : CAShapeLayer = layers["back13"] as? CAShapeLayer{
            back13.frame = CGRectMake( back13.superlayer!.bounds.width, 0, 0,  back13.superlayer!.bounds.height)
            back13.path  = back13PathWithBounds((layers["back13"] as! CAShapeLayer).bounds).CGPath
            back13.lineWidth = 0.05*container.frame.size.width
        }
        
        if let front13 : CAShapeLayer = layers["front13"] as? CAShapeLayer{
            front13.frame = CGRectMake( front13.superlayer!.bounds.width, 0, 0,  front13.superlayer!.bounds.height)
            front13.path  = front13PathWithBounds((layers["front13"] as! CAShapeLayer).bounds).CGPath
            front13.lineWidth = 0.05*container.frame.size.width
        }
        
        if let bar14 : CALayer = layers["bar14"] as? CALayer{
            bar14.frame = CGRectMake(0.81142 * bar14.superlayer!.bounds.width, 0.10707 * bar14.superlayer!.bounds.height, 0, 0.73333 * bar14.superlayer!.bounds.height)
        }
        
        if let back14 : CAShapeLayer = layers["back14"] as? CAShapeLayer{
            back14.frame = CGRectMake( back14.superlayer!.bounds.width, 0, 0,  back14.superlayer!.bounds.height)
            back14.path  = back14PathWithBounds((layers["back14"] as! CAShapeLayer).bounds).CGPath
            back14.lineWidth = 0.05*container.frame.size.width
        }
        
        if let front14 : CAShapeLayer = layers["front14"] as? CAShapeLayer{
            front14.frame = CGRectMake( front14.superlayer!.bounds.width, 0, 0,  front14.superlayer!.bounds.height)
            front14.path  = front14PathWithBounds((layers["front14"] as! CAShapeLayer).bounds).CGPath
            front14.lineWidth = 0.05*container.frame.size.width
        }
        
        if let bar15 : CALayer = layers["bar15"] as? CALayer{
            bar15.frame = CGRectMake(0.85808 * bar15.superlayer!.bounds.width, 0.10707 * bar15.superlayer!.bounds.height, 0, 0.73333 * bar15.superlayer!.bounds.height)
        }
        
        if let back15 : CAShapeLayer = layers["back15"] as? CAShapeLayer{
            back15.frame = CGRectMake( back15.superlayer!.bounds.width, 0, 0,  back15.superlayer!.bounds.height)
            back15.path  = back15PathWithBounds((layers["back15"] as! CAShapeLayer).bounds).CGPath
            back15.lineWidth = 0.05*container.frame.size.width
        }
        
        if let front15 : CAShapeLayer = layers["front15"] as? CAShapeLayer{
            front15.frame = CGRectMake( front15.superlayer!.bounds.width, 0, 0,  front15.superlayer!.bounds.height)
            front15.path  = front15PathWithBounds((layers["front15"] as! CAShapeLayer).bounds).CGPath
            front15.lineWidth = 0.05*container.frame.size.width
        }
        
        if let text : CATextLayer = layers["text"] as? CATextLayer{
            text.frame = CGRectMake(0.02677 * text.superlayer!.bounds.width, 0.75833 * text.superlayer!.bounds.height, 0.13333 * text.superlayer!.bounds.width, 0.02333 * text.superlayer!.bounds.height)
        }
        
        if let text2 : CATextLayer = layers["text2"] as? CATextLayer{
            text2.frame = CGRectMake(0.02677 * text2.superlayer!.bounds.width, 0.685 * text2.superlayer!.bounds.height, 0.13333 * text2.superlayer!.bounds.width, 0.02333 * text2.superlayer!.bounds.height)
        }
        
        if let text3 : CATextLayer = layers["text3"] as? CATextLayer{
            text3.frame = CGRectMake(0.02677 * text3.superlayer!.bounds.width, 0.61167 * text3.superlayer!.bounds.height, 0.13333 * text3.superlayer!.bounds.width, 0.02333 * text3.superlayer!.bounds.height)
        }
        
        if let text4 : CATextLayer = layers["text4"] as? CATextLayer{
            text4.frame = CGRectMake(0.02677 * text4.superlayer!.bounds.width, 0.53833 * text4.superlayer!.bounds.height, 0.13333 * text4.superlayer!.bounds.width, 0.02333 * text4.superlayer!.bounds.height)
        }
        
        if let text5 : CATextLayer = layers["text5"] as? CATextLayer{
            text5.frame = CGRectMake(0.02677 * text5.superlayer!.bounds.width, 0.465 * text5.superlayer!.bounds.height, 0.13333 * text5.superlayer!.bounds.width, 0.02333 * text5.superlayer!.bounds.height)
        }
        
        if let text6 : CATextLayer = layers["text6"] as? CATextLayer{
            text6.frame = CGRectMake(0.02677 * text6.superlayer!.bounds.width, 0.39167 * text6.superlayer!.bounds.height, 0.13333 * text6.superlayer!.bounds.width, 0.02333 * text6.superlayer!.bounds.height)
        }
        
        if let text7 : CATextLayer = layers["text7"] as? CATextLayer{
            text7.frame = CGRectMake(0.02677 * text7.superlayer!.bounds.width, 0.31833 * text7.superlayer!.bounds.height, 0.13333 * text7.superlayer!.bounds.width, 0.02333 * text7.superlayer!.bounds.height)
        }
        
        if let text8 : CATextLayer = layers["text8"] as? CATextLayer{
            text8.frame = CGRectMake(0.02677 * text8.superlayer!.bounds.width, 0.245 * text8.superlayer!.bounds.height, 0.13333 * text8.superlayer!.bounds.width, 0.02333 * text8.superlayer!.bounds.height)
        }
        
        if let text9 : CATextLayer = layers["text9"] as? CATextLayer{
            text9.frame = CGRectMake(0.02677 * text9.superlayer!.bounds.width, 0.17167 * text9.superlayer!.bounds.height, 0.13333 * text9.superlayer!.bounds.width, 0.02333 * text9.superlayer!.bounds.height)
        }
        
        if let text10 : CATextLayer = layers["text10"] as? CATextLayer{
            text10.frame = CGRectMake(0.02677 * text10.superlayer!.bounds.width, 0.09833 * text10.superlayer!.bounds.height, 0.13333 * text10.superlayer!.bounds.width, 0.02333 * text10.superlayer!.bounds.height)
        }
        
        if let durationtext : CATextLayer = layers["durationtext"] as? CATextLayer{
            durationtext.frame = CGRectMake(0.1601 * durationtext.superlayer!.bounds.width, 0.85312 * durationtext.superlayer!.bounds.height, 0.7426 * durationtext.superlayer!.bounds.width, 0.03 * durationtext.superlayer!.bounds.height)
        }
        if let title : CATextLayer = layers["title"] as? CATextLayer{
            title.frame = CGRectMake(0.0377 * title.superlayer!.bounds.width, 0.03708 * title.superlayer!.bounds.height, 0.22667 * title.superlayer!.bounds.width, 0.03861 * title.superlayer!.bounds.height)
        }
        
        CATransaction.commit()
        addBarchartAnimation()
    }
    
    //MARK: - Animation Setup
    
    func addBarchartAnimation(){
        let fillMode : String = kCAFillModeForwards
        
        ////Back animation
        let backStrokeEndAnim            = CAKeyframeAnimation(keyPath:"strokeEnd")
        if(data2.count>=1){
            var f1 = Float(data2[0]) as! Float
            var f2 = Float(maxvalue) as! Float
            var f3 = f1/f2 as! Float
            print("f3 is",f3)
            backStrokeEndAnim.values         = [0, f3/2]
        }else{
            backStrokeEndAnim.values         = [0, 0]
        }
        backStrokeEndAnim.keyTimes       = [0, 1]
        backStrokeEndAnim.duration       = 0.6
        backStrokeEndAnim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)
        
        let backBarchartAnim : CAAnimationGroup = QCMethod.groupAnimations([backStrokeEndAnim], fillMode:fillMode)
        layers["back"]?.addAnimation(backBarchartAnim, forKey:"backBarchartAnim")
        
        ////Front animation
        let frontStrokeEndAnim            = CAKeyframeAnimation(keyPath:"strokeEnd")
        if(data.count>=1){
            var f1 = Float(data[0]) as! Float
            var f2 = Float(maxvalue) as! Float
            var f3 = f1/f2 as! Float
            print("f3 is",f3)
            frontStrokeEndAnim.values         = [0, f3/2]
        }else{
            frontStrokeEndAnim.values         = [0, 0]
        }
        frontStrokeEndAnim.keyTimes       = [0, 1]
        frontStrokeEndAnim.duration       = 0.6
        frontStrokeEndAnim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)
        
        let frontBarchartAnim : CAAnimationGroup = QCMethod.groupAnimations([frontStrokeEndAnim], fillMode:fillMode)
        layers["front"]?.addAnimation(frontBarchartAnim, forKey:"frontBarchartAnim")
        
        ////Back2 animation
        let back2StrokeEndAnim            = CAKeyframeAnimation(keyPath:"strokeEnd")
        if(data2.count>=2){
            var f1 = Float(data2[1]) as! Float
            var f2 = Float(maxvalue) as! Float
            var f3 = f1/f2 as! Float
            print("f3 is",f3)
            back2StrokeEndAnim.values         = [0, f3/2]
        }else{
            back2StrokeEndAnim.values         = [0, 0]
        }
        back2StrokeEndAnim.keyTimes       = [0, 1]
        back2StrokeEndAnim.duration       = 0.6
        back2StrokeEndAnim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)
        
        let back2BarchartAnim : CAAnimationGroup = QCMethod.groupAnimations([back2StrokeEndAnim], fillMode:fillMode)
        layers["back2"]?.addAnimation(back2BarchartAnim, forKey:"back2BarchartAnim")
        
        ////Front2 animation
        let front2StrokeEndAnim            = CAKeyframeAnimation(keyPath:"strokeEnd")
        if(data.count>=2){
            var f1 = Float(data[1]) as! Float
            var f2 = Float(maxvalue) as! Float
            var f3 = f1/f2 as! Float
            print("f3 is",f3)
            front2StrokeEndAnim.values         = [0, f3/2]
        }else{
            front2StrokeEndAnim.values         = [0, 0]
        }
        front2StrokeEndAnim.keyTimes       = [0, 1]
        front2StrokeEndAnim.duration       = 0.6
        front2StrokeEndAnim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)
        
        let front2BarchartAnim : CAAnimationGroup = QCMethod.groupAnimations([front2StrokeEndAnim], fillMode:fillMode)
        layers["front2"]?.addAnimation(front2BarchartAnim, forKey:"front2BarchartAnim")
        
        ////Back3 animation
        let back3StrokeEndAnim            = CAKeyframeAnimation(keyPath:"strokeEnd")
        if(data2.count>=3){
            var f1 = Float(data2[2]) as! Float
            var f2 = Float(maxvalue) as! Float
            var f3 = f1/f2 as! Float
            print("f3 is",f3)
            back3StrokeEndAnim.values         = [0, f3/2]
        }else{
            back3StrokeEndAnim.values         = [0, 0]
        }
        back3StrokeEndAnim.keyTimes       = [0, 1]
        back3StrokeEndAnim.duration       = 0.6
        back3StrokeEndAnim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)
        
        let back3BarchartAnim : CAAnimationGroup = QCMethod.groupAnimations([back3StrokeEndAnim], fillMode:fillMode)
        layers["back3"]?.addAnimation(back3BarchartAnim, forKey:"back3BarchartAnim")
        
        ////Front3 animation
        let front3StrokeEndAnim            = CAKeyframeAnimation(keyPath:"strokeEnd")
        if(data.count>=3){
            var f1 = Float(data[2]) as! Float
            var f2 = Float(maxvalue) as! Float
            var f3 = f1/f2 as! Float
            print("f3 is",f3)
            front3StrokeEndAnim.values         = [0, f3/2]
        }else{
            front3StrokeEndAnim.values         = [0, 0]
        }
        front3StrokeEndAnim.keyTimes       = [0, 1]
        front3StrokeEndAnim.duration       = 0.6
        front3StrokeEndAnim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)
        
        let front3BarchartAnim : CAAnimationGroup = QCMethod.groupAnimations([front3StrokeEndAnim], fillMode:fillMode)
        layers["front3"]?.addAnimation(front3BarchartAnim, forKey:"front3BarchartAnim")
        
        ////Back4 animation
        let back4StrokeEndAnim            = CAKeyframeAnimation(keyPath:"strokeEnd")
        if(data2.count>=4){
            var f1 = Float(data2[3]) as! Float
            var f2 = Float(maxvalue) as! Float
            var f3 = f1/f2 as! Float
            print("f3 is",f3)
            back4StrokeEndAnim.values         = [0, f3/2]
        }else{
            back4StrokeEndAnim.values         = [0, 0]
        }
        back4StrokeEndAnim.keyTimes       = [0, 1]
        back4StrokeEndAnim.duration       = 0.6
        back4StrokeEndAnim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)
        
        let back4BarchartAnim : CAAnimationGroup = QCMethod.groupAnimations([back4StrokeEndAnim], fillMode:fillMode)
        layers["back4"]?.addAnimation(back4BarchartAnim, forKey:"back4BarchartAnim")
        
        ////Front4 animation
        let front4StrokeEndAnim            = CAKeyframeAnimation(keyPath:"strokeEnd")
        if(data.count>=4){
            var f1 = Float(data[3]) as! Float
            var f2 = Float(maxvalue) as! Float
            var f3 = f1/f2 as! Float
            print("f3 is",f3)
            front4StrokeEndAnim.values         = [0, f3/2]
        }else{
            front4StrokeEndAnim.values         = [0, 0]
        }
        front4StrokeEndAnim.keyTimes       = [0, 1]
        front4StrokeEndAnim.duration       = 0.6
        front4StrokeEndAnim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)
        
        let front4BarchartAnim : CAAnimationGroup = QCMethod.groupAnimations([front4StrokeEndAnim], fillMode:fillMode)
        layers["front4"]?.addAnimation(front4BarchartAnim, forKey:"front4BarchartAnim")
        
        ////Back5 animation
        let back5StrokeEndAnim            = CAKeyframeAnimation(keyPath:"strokeEnd")
        if(data2.count>=5){
            var f1 = Float(data2[4]) as! Float
            var f2 = Float(maxvalue) as! Float
            var f3 = f1/f2 as! Float
            print("f3 is",f3)
            back5StrokeEndAnim.values         = [0, f3/2]
        }else{
            back5StrokeEndAnim.values         = [0, 0]
        }
        back5StrokeEndAnim.keyTimes       = [0, 1]
        back5StrokeEndAnim.duration       = 0.6
        back5StrokeEndAnim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)
        
        let back5BarchartAnim : CAAnimationGroup = QCMethod.groupAnimations([back5StrokeEndAnim], fillMode:fillMode)
        layers["back5"]?.addAnimation(back5BarchartAnim, forKey:"back5BarchartAnim")
        
        ////Front5 animation
        let front5StrokeEndAnim            = CAKeyframeAnimation(keyPath:"strokeEnd")
        if(data.count>=5){
            var f1 = Float(data[4]) as! Float
            var f2 = Float(maxvalue) as! Float
            var f3 = f1/f2 as! Float
            print("f3 is",f3)
            front5StrokeEndAnim.values         = [0, f3/2]
        }else{
            front5StrokeEndAnim.values         = [0, 0]
        }
        front5StrokeEndAnim.keyTimes       = [0, 1]
        front5StrokeEndAnim.duration       = 0.6
        front5StrokeEndAnim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)
        
        let front5BarchartAnim : CAAnimationGroup = QCMethod.groupAnimations([front5StrokeEndAnim], fillMode:fillMode)
        layers["front5"]?.addAnimation(front5BarchartAnim, forKey:"front5BarchartAnim")
        
        ////Back6 animation
        let back6StrokeEndAnim            = CAKeyframeAnimation(keyPath:"strokeEnd")
        if(data2.count>=6){
            var f1 = Float(data2[5]) as! Float
            var f2 = Float(maxvalue) as! Float
            var f3 = f1/f2 as! Float
            print("f3 is",f3)
            back6StrokeEndAnim.values         = [0, f3/2]
        }else{
            back6StrokeEndAnim.values         = [0, 0]
        }
        back6StrokeEndAnim.keyTimes       = [0, 1]
        back6StrokeEndAnim.duration       = 0.6
        back6StrokeEndAnim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)
        
        let back6BarchartAnim : CAAnimationGroup = QCMethod.groupAnimations([back6StrokeEndAnim], fillMode:fillMode)
        layers["back6"]?.addAnimation(back6BarchartAnim, forKey:"back6BarchartAnim")
        
        ////Front6 animation
        let front6StrokeEndAnim            = CAKeyframeAnimation(keyPath:"strokeEnd")
        if(data.count>=6){
            var f1 = Float(data[5]) as! Float
            var f2 = Float(maxvalue) as! Float
            var f3 = f1/f2 as! Float
            print("f3 is",f3)
            front6StrokeEndAnim.values         = [0, f3/2]
        }else{
            front6StrokeEndAnim.values         = [0, 0]
        }
        front6StrokeEndAnim.keyTimes       = [0, 1]
        front6StrokeEndAnim.duration       = 0.6
        front6StrokeEndAnim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)
        
        let front6BarchartAnim : CAAnimationGroup = QCMethod.groupAnimations([front6StrokeEndAnim], fillMode:fillMode)
        layers["front6"]?.addAnimation(front6BarchartAnim, forKey:"front6BarchartAnim")
        
        ////Back7 animation
        let back7StrokeEndAnim            = CAKeyframeAnimation(keyPath:"strokeEnd")
        if(data2.count>=7){
            var f1 = Float(data2[6]) as! Float
            var f2 = Float(maxvalue) as! Float
            var f3 = f1/f2 as! Float
            print("f3 is",f3)
            back7StrokeEndAnim.values         = [0, f3/2]
        }else{
            back7StrokeEndAnim.values         = [0, 0]
        }
        back7StrokeEndAnim.keyTimes       = [0, 1]
        back7StrokeEndAnim.duration       = 0.6
        back7StrokeEndAnim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)
        
        let back7BarchartAnim : CAAnimationGroup = QCMethod.groupAnimations([back7StrokeEndAnim], fillMode:fillMode)
        layers["back7"]?.addAnimation(back7BarchartAnim, forKey:"back7BarchartAnim")
        
        ////Front7 animation
        let front7StrokeEndAnim            = CAKeyframeAnimation(keyPath:"strokeEnd")
        if(data.count>=7){
            var f1 = Float(data[6]) as! Float
            var f2 = Float(maxvalue) as! Float
            var f3 = f1/f2 as! Float
            print("f3 is",f3)
            front7StrokeEndAnim.values         = [0, f3/2]
        }else{
            front7StrokeEndAnim.values         = [0, 0]
        }
        front7StrokeEndAnim.keyTimes       = [0, 1]
        front7StrokeEndAnim.duration       = 0.6
        front7StrokeEndAnim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)
        
        let front7BarchartAnim : CAAnimationGroup = QCMethod.groupAnimations([front7StrokeEndAnim], fillMode:fillMode)
        layers["front7"]?.addAnimation(front7BarchartAnim, forKey:"front7BarchartAnim")
        
        ////Back8 animation
        let back8StrokeEndAnim            = CAKeyframeAnimation(keyPath:"strokeEnd")
        if(data2.count>=8){
            var f1 = Float(data2[7]) as! Float
            var f2 = Float(maxvalue) as! Float
            var f3 = f1/f2 as! Float
            print("f3 is",f3)
            back8StrokeEndAnim.values         = [0, f3/2]
        }else{
            back8StrokeEndAnim.values         = [0, 0]
        }
        back8StrokeEndAnim.keyTimes       = [0, 1]
        back8StrokeEndAnim.duration       = 0.6
        back8StrokeEndAnim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)
        
        let back8BarchartAnim : CAAnimationGroup = QCMethod.groupAnimations([back8StrokeEndAnim], fillMode:fillMode)
        layers["back8"]?.addAnimation(back8BarchartAnim, forKey:"back8BarchartAnim")
        
        ////Front8 animation
        let front8StrokeEndAnim            = CAKeyframeAnimation(keyPath:"strokeEnd")
        if(data.count>=8){
            var f1 = Float(data[7]) as! Float
            var f2 = Float(maxvalue) as! Float
            var f3 = f1/f2 as! Float
            print("f3 is",f3)
            front8StrokeEndAnim.values         = [0, f3/2]
        }else{
            front8StrokeEndAnim.values         = [0, 0]
        }
        front8StrokeEndAnim.keyTimes       = [0, 1]
        front8StrokeEndAnim.duration       = 0.6
        front8StrokeEndAnim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)
        
        let front8BarchartAnim : CAAnimationGroup = QCMethod.groupAnimations([front8StrokeEndAnim], fillMode:fillMode)
        layers["front8"]?.addAnimation(front8BarchartAnim, forKey:"front8BarchartAnim")
        
        ////Back9 animation
        let back9StrokeEndAnim            = CAKeyframeAnimation(keyPath:"strokeEnd")
        if(data2.count>=9){
            var f1 = Float(data2[8]) as! Float
            var f2 = Float(maxvalue) as! Float
            var f3 = f1/f2 as! Float
            print("f3 is",f3)
            back9StrokeEndAnim.values         = [0, f3/2]
        }else{
            back9StrokeEndAnim.values         = [0, 0]
        }
        back9StrokeEndAnim.keyTimes       = [0, 1]
        back9StrokeEndAnim.duration       = 0.6
        back9StrokeEndAnim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)
        
        let back9BarchartAnim : CAAnimationGroup = QCMethod.groupAnimations([back9StrokeEndAnim], fillMode:fillMode)
        layers["back9"]?.addAnimation(back9BarchartAnim, forKey:"back9BarchartAnim")
        
        ////Front9 animation
        let front9StrokeEndAnim            = CAKeyframeAnimation(keyPath:"strokeEnd")
        if(data.count>=9){
            var f1 = Float(data[8]) as! Float
            var f2 = Float(maxvalue) as! Float
            var f3 = f1/f2 as! Float
            print("f3 is",f3)
            front9StrokeEndAnim.values         = [0, f3/2]
        }else{
            front9StrokeEndAnim.values         = [0, 0]
        }
        front9StrokeEndAnim.keyTimes       = [0, 1]
        front9StrokeEndAnim.duration       = 0.6
        front9StrokeEndAnim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)
        
        let front9BarchartAnim : CAAnimationGroup = QCMethod.groupAnimations([front9StrokeEndAnim], fillMode:fillMode)
        layers["front9"]?.addAnimation(front9BarchartAnim, forKey:"front9BarchartAnim")
        
        ////Back10 animation
        let back10StrokeEndAnim            = CAKeyframeAnimation(keyPath:"strokeEnd")
        if(data2.count>=10){
            var f1 = Float(data2[9]) as! Float
            var f2 = Float(maxvalue) as! Float
            var f3 = f1/f2 as! Float
            print("f3 is",f3)
            back10StrokeEndAnim.values         = [0, f3/2]
        }else{
            back10StrokeEndAnim.values         = [0, 0]
        }
        back10StrokeEndAnim.keyTimes       = [0, 1]
        back10StrokeEndAnim.duration       = 0.6
        back10StrokeEndAnim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)
        
        let back10BarchartAnim : CAAnimationGroup = QCMethod.groupAnimations([back10StrokeEndAnim], fillMode:fillMode)
        layers["back10"]?.addAnimation(back10BarchartAnim, forKey:"back10BarchartAnim")
        
        ////Front10 animation
        let front10StrokeEndAnim            = CAKeyframeAnimation(keyPath:"strokeEnd")
        if(data.count>=10){
            var f1 = Float(data[9]) as! Float
            var f2 = Float(maxvalue) as! Float
            var f3 = f1/f2 as! Float
            print("f3 is",f3)
            front10StrokeEndAnim.values         = [0, f3/2]
        }else{
            front10StrokeEndAnim.values         = [0, 0]
        }
        front10StrokeEndAnim.keyTimes       = [0, 1]
        front10StrokeEndAnim.duration       = 0.6
        front10StrokeEndAnim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)
        
        let front10BarchartAnim : CAAnimationGroup = QCMethod.groupAnimations([front10StrokeEndAnim], fillMode:fillMode)
        layers["front10"]?.addAnimation(front10BarchartAnim, forKey:"front10BarchartAnim")
        
        ////Back11 animation
        let back11StrokeEndAnim            = CAKeyframeAnimation(keyPath:"strokeEnd")
        if(data2.count>=11){
            var f1 = Float(data2[10]) as! Float
            var f2 = Float(maxvalue) as! Float
            var f3 = f1/f2 as! Float
            print("f3 is",f3)
            back11StrokeEndAnim.values         = [0, f3/2]
        }else{
            back11StrokeEndAnim.values         = [0, 0]
        }
        back11StrokeEndAnim.keyTimes       = [0, 1]
        back11StrokeEndAnim.duration       = 0.6
        back11StrokeEndAnim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)
        
        let back11BarchartAnim : CAAnimationGroup = QCMethod.groupAnimations([back11StrokeEndAnim], fillMode:fillMode)
        layers["back11"]?.addAnimation(back11BarchartAnim, forKey:"back11BarchartAnim")
        
        ////Front11 animation
        let front11StrokeEndAnim            = CAKeyframeAnimation(keyPath:"strokeEnd")
        if(data.count>=11){
            var f1 = Float(data[10]) as! Float
            var f2 = Float(maxvalue) as! Float
            var f3 = f1/f2 as! Float
            print("f3 is",f3)
            front11StrokeEndAnim.values         = [0, f3/2]
        }else{
            front11StrokeEndAnim.values         = [0, 0]
        }
        front11StrokeEndAnim.keyTimes       = [0, 1]
        front11StrokeEndAnim.duration       = 0.6
        front11StrokeEndAnim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)
        
        let front11BarchartAnim : CAAnimationGroup = QCMethod.groupAnimations([front11StrokeEndAnim], fillMode:fillMode)
        layers["front11"]?.addAnimation(front11BarchartAnim, forKey:"front11BarchartAnim")
        
        ////Back12 animation
        let back12StrokeEndAnim            = CAKeyframeAnimation(keyPath:"strokeEnd")
        if(data2.count>=12){
            var f1 = Float(data2[11]) as! Float
            var f2 = Float(maxvalue) as! Float
            var f3 = f1/f2 as! Float
            print("f3 is",f3)
            back12StrokeEndAnim.values         = [0, f3/2]
        }else{
            back12StrokeEndAnim.values         = [0, 0]
        }
        back12StrokeEndAnim.keyTimes       = [0, 1]
        back12StrokeEndAnim.duration       = 0.6
        back12StrokeEndAnim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)
        
        let back12BarchartAnim : CAAnimationGroup = QCMethod.groupAnimations([back12StrokeEndAnim], fillMode:fillMode)
        layers["back12"]?.addAnimation(back12BarchartAnim, forKey:"back12BarchartAnim")
        
        ////Front12 animation
        let front12StrokeEndAnim            = CAKeyframeAnimation(keyPath:"strokeEnd")
        if(data.count>=12){
            var f1 = Float(data[11]) as! Float
            var f2 = Float(maxvalue) as! Float
            var f3 = f1/f2 as! Float
            print("f3 is",f3)
            front12StrokeEndAnim.values         = [0, f3/2]
        }else{
            front12StrokeEndAnim.values         = [0, 0]
        }
        front12StrokeEndAnim.keyTimes       = [0, 1]
        front12StrokeEndAnim.duration       = 0.6
        front12StrokeEndAnim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)
        
        let front12BarchartAnim : CAAnimationGroup = QCMethod.groupAnimations([front12StrokeEndAnim], fillMode:fillMode)
        layers["front12"]?.addAnimation(front12BarchartAnim, forKey:"front12BarchartAnim")
        
        ////Back13 animation
        let back13StrokeEndAnim            = CAKeyframeAnimation(keyPath:"strokeEnd")
        if(data2.count>=13){
            var f1 = Float(data2[12]) as! Float
            var f2 = Float(maxvalue) as! Float
            var f3 = f1/f2 as! Float
            print("f3 is",f3)
            back13StrokeEndAnim.values         = [0, f3/2]
        }else{
            back13StrokeEndAnim.values         = [0, 0]
        }
        back13StrokeEndAnim.keyTimes       = [0, 1]
        back13StrokeEndAnim.duration       = 0.6
        back13StrokeEndAnim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)
        
        let back13BarchartAnim : CAAnimationGroup = QCMethod.groupAnimations([back13StrokeEndAnim], fillMode:fillMode)
        layers["back13"]?.addAnimation(back13BarchartAnim, forKey:"back13BarchartAnim")
        
        ////Front13 animation
        let front13StrokeEndAnim            = CAKeyframeAnimation(keyPath:"strokeEnd")
        if(data.count>=13){
            var f1 = Float(data[12]) as! Float
            var f2 = Float(maxvalue) as! Float
            var f3 = f1/f2 as! Float
            print("f3 is",f3)
            front13StrokeEndAnim.values         = [0, f3/2]
        }else{
            front13StrokeEndAnim.values         = [0, 0]
        }
        front13StrokeEndAnim.keyTimes       = [0, 1]
        front13StrokeEndAnim.duration       = 0.6
        front13StrokeEndAnim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)
        
        let front13BarchartAnim : CAAnimationGroup = QCMethod.groupAnimations([front13StrokeEndAnim], fillMode:fillMode)
        layers["front13"]?.addAnimation(front13BarchartAnim, forKey:"front13BarchartAnim")
        
        ////Back14 animation
        let back14StrokeEndAnim            = CAKeyframeAnimation(keyPath:"strokeEnd")
        if(data2.count>=14){
            var f1 = Float(data2[13]) as! Float
            var f2 = Float(maxvalue) as! Float
            var f3 = f1/f2 as! Float
            print("f3 is",f3)
            back14StrokeEndAnim.values         = [0, f3/2]
        }else{
            back14StrokeEndAnim.values         = [0, 0]
        }
        back14StrokeEndAnim.keyTimes       = [0, 1]
        back14StrokeEndAnim.duration       = 0.6
        back14StrokeEndAnim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)
        
        let back14BarchartAnim : CAAnimationGroup = QCMethod.groupAnimations([back14StrokeEndAnim], fillMode:fillMode)
        layers["back14"]?.addAnimation(back14BarchartAnim, forKey:"back14BarchartAnim")
        
        ////Front14 animation
        let front14StrokeEndAnim            = CAKeyframeAnimation(keyPath:"strokeEnd")
        if(data.count>=14){
            var f1 = Float(data[13]) as! Float
            var f2 = Float(maxvalue) as! Float
            var f3 = f1/f2 as! Float
            print("f3 is",f3)
            front14StrokeEndAnim.values         = [0, f3/2]
        }else{
            front14StrokeEndAnim.values         = [0, 0]
        }
        front14StrokeEndAnim.keyTimes       = [0, 1]
        front14StrokeEndAnim.duration       = 0.6
        front14StrokeEndAnim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)
        
        let front14BarchartAnim : CAAnimationGroup = QCMethod.groupAnimations([front14StrokeEndAnim], fillMode:fillMode)
        layers["front14"]?.addAnimation(front14BarchartAnim, forKey:"front14BarchartAnim")
        
        ////Back15 animation
        let back15StrokeEndAnim            = CAKeyframeAnimation(keyPath:"strokeEnd")
        if(data2.count>=15){
            var f1 = Float(data2[14]) as! Float
            var f2 = Float(maxvalue) as! Float
            var f3 = f1/f2 as! Float
            print("f3 is",f3)
            back15StrokeEndAnim.values         = [0, f3/2]
        }else{
            back15StrokeEndAnim.values         = [0, 0]
        }
        back15StrokeEndAnim.keyTimes       = [0, 1]
        back15StrokeEndAnim.duration       = 0.6
        back15StrokeEndAnim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)
        
        let back15BarchartAnim : CAAnimationGroup = QCMethod.groupAnimations([back15StrokeEndAnim], fillMode:fillMode)
        layers["back15"]?.addAnimation(back15BarchartAnim, forKey:"back15BarchartAnim")
        
        ////Front15 animation
        let front15StrokeEndAnim            = CAKeyframeAnimation(keyPath:"strokeEnd")
        if(data.count>=15){
            var f1 = Float(data[14]) as! Float
            var f2 = Float(maxvalue) as! Float
            var f3 = f1/f2 as! Float
            print("f3 is",f3)
            front15StrokeEndAnim.values         = [0, f3/2]
        }else{
            front15StrokeEndAnim.values         = [0, 0]
        }
        front15StrokeEndAnim.keyTimes       = [0, 1]
        front15StrokeEndAnim.duration       = 0.6
        front15StrokeEndAnim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)
        
        let front15BarchartAnim : CAAnimationGroup = QCMethod.groupAnimations([front15StrokeEndAnim], fillMode:fillMode)
        layers["front15"]?.addAnimation(front15BarchartAnim, forKey:"front15BarchartAnim")
    }
    
    //MARK: - Animation Cleanup
    
    func updateLayerValuesForAnimationId(identifier: String){
        if identifier == "barchart"{
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["back"] as! CALayer).animationForKey("backBarchartAnim"), theLayer:(layers["back"] as! CALayer))
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["front"] as! CALayer).animationForKey("frontBarchartAnim"), theLayer:(layers["front"] as! CALayer))
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["back2"] as! CALayer).animationForKey("back2BarchartAnim"), theLayer:(layers["back2"] as! CALayer))
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["front2"] as! CALayer).animationForKey("front2BarchartAnim"), theLayer:(layers["front2"] as! CALayer))
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["back3"] as! CALayer).animationForKey("back3BarchartAnim"), theLayer:(layers["back3"] as! CALayer))
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["front3"] as! CALayer).animationForKey("front3BarchartAnim"), theLayer:(layers["front3"] as! CALayer))
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["back4"] as! CALayer).animationForKey("back4BarchartAnim"), theLayer:(layers["back4"] as! CALayer))
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["front4"] as! CALayer).animationForKey("front4BarchartAnim"), theLayer:(layers["front4"] as! CALayer))
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["back5"] as! CALayer).animationForKey("back5BarchartAnim"), theLayer:(layers["back5"] as! CALayer))
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["front5"] as! CALayer).animationForKey("front5BarchartAnim"), theLayer:(layers["front5"] as! CALayer))
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["back6"] as! CALayer).animationForKey("back6BarchartAnim"), theLayer:(layers["back6"] as! CALayer))
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["front6"] as! CALayer).animationForKey("front6BarchartAnim"), theLayer:(layers["front6"] as! CALayer))
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["back7"] as! CALayer).animationForKey("back7BarchartAnim"), theLayer:(layers["back7"] as! CALayer))
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["front7"] as! CALayer).animationForKey("front7BarchartAnim"), theLayer:(layers["front7"] as! CALayer))
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["back8"] as! CALayer).animationForKey("back8BarchartAnim"), theLayer:(layers["back8"] as! CALayer))
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["front8"] as! CALayer).animationForKey("front8BarchartAnim"), theLayer:(layers["front8"] as! CALayer))
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["back9"] as! CALayer).animationForKey("back9BarchartAnim"), theLayer:(layers["back9"] as! CALayer))
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["front9"] as! CALayer).animationForKey("front9BarchartAnim"), theLayer:(layers["front9"] as! CALayer))
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["back10"] as! CALayer).animationForKey("back10BarchartAnim"), theLayer:(layers["back10"] as! CALayer))
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["front10"] as! CALayer).animationForKey("front10BarchartAnim"), theLayer:(layers["front10"] as! CALayer))
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["back11"] as! CALayer).animationForKey("back11BarchartAnim"), theLayer:(layers["back11"] as! CALayer))
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["front11"] as! CALayer).animationForKey("front11BarchartAnim"), theLayer:(layers["front11"] as! CALayer))
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["back12"] as! CALayer).animationForKey("back12BarchartAnim"), theLayer:(layers["back12"] as! CALayer))
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["front12"] as! CALayer).animationForKey("front12BarchartAnim"), theLayer:(layers["front12"] as! CALayer))
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["back13"] as! CALayer).animationForKey("back13BarchartAnim"), theLayer:(layers["back13"] as! CALayer))
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["front13"] as! CALayer).animationForKey("front13BarchartAnim"), theLayer:(layers["front13"] as! CALayer))
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["back14"] as! CALayer).animationForKey("back14BarchartAnim"), theLayer:(layers["back14"] as! CALayer))
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["front14"] as! CALayer).animationForKey("front14BarchartAnim"), theLayer:(layers["front14"] as! CALayer))
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["back15"] as! CALayer).animationForKey("back15BarchartAnim"), theLayer:(layers["back15"] as! CALayer))
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["front15"] as! CALayer).animationForKey("front15BarchartAnim"), theLayer:(layers["front15"] as! CALayer))
        }
    }
    
    func removeAnimationsForAnimationId(identifier: String){
        if identifier == "barchart"{
            (layers["back"] as! CALayer).removeAnimationForKey("backBarchartAnim")
            (layers["front"] as! CALayer).removeAnimationForKey("frontBarchartAnim")
            (layers["back2"] as! CALayer).removeAnimationForKey("back2BarchartAnim")
            (layers["front2"] as! CALayer).removeAnimationForKey("front2BarchartAnim")
            (layers["back3"] as! CALayer).removeAnimationForKey("back3BarchartAnim")
            (layers["front3"] as! CALayer).removeAnimationForKey("front3BarchartAnim")
            (layers["back4"] as! CALayer).removeAnimationForKey("back4BarchartAnim")
            (layers["front4"] as! CALayer).removeAnimationForKey("front4BarchartAnim")
            (layers["back5"] as! CALayer).removeAnimationForKey("back5BarchartAnim")
            (layers["front5"] as! CALayer).removeAnimationForKey("front5BarchartAnim")
            (layers["back6"] as! CALayer).removeAnimationForKey("back6BarchartAnim")
            (layers["front6"] as! CALayer).removeAnimationForKey("front6BarchartAnim")
            (layers["back7"] as! CALayer).removeAnimationForKey("back7BarchartAnim")
            (layers["front7"] as! CALayer).removeAnimationForKey("front7BarchartAnim")
            (layers["back8"] as! CALayer).removeAnimationForKey("back8BarchartAnim")
            (layers["front8"] as! CALayer).removeAnimationForKey("front8BarchartAnim")
            (layers["back9"] as! CALayer).removeAnimationForKey("back9BarchartAnim")
            (layers["front9"] as! CALayer).removeAnimationForKey("front9BarchartAnim")
            (layers["back10"] as! CALayer).removeAnimationForKey("back10BarchartAnim")
            (layers["front10"] as! CALayer).removeAnimationForKey("front10BarchartAnim")
            (layers["back11"] as! CALayer).removeAnimationForKey("back11BarchartAnim")
            (layers["front11"] as! CALayer).removeAnimationForKey("front11BarchartAnim")
            (layers["back12"] as! CALayer).removeAnimationForKey("back12BarchartAnim")
            (layers["front12"] as! CALayer).removeAnimationForKey("front12BarchartAnim")
            (layers["back13"] as! CALayer).removeAnimationForKey("back13BarchartAnim")
            (layers["front13"] as! CALayer).removeAnimationForKey("front13BarchartAnim")
            (layers["back14"] as! CALayer).removeAnimationForKey("back14BarchartAnim")
            (layers["front14"] as! CALayer).removeAnimationForKey("front14BarchartAnim")
            (layers["back15"] as! CALayer).removeAnimationForKey("back15BarchartAnim")
            (layers["front15"] as! CALayer).removeAnimationForKey("front15BarchartAnim")
        }
    }
    
    func removeAllAnimations(){
        for layer in layers.values{
            (layer as! CALayer).removeAllAnimations()
        }
    }
    
    //MARK: - Bezier Path
    
    func rectanglePathWithBounds(bounds: CGRect) -> UIBezierPath{
        let rectanglePath = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        rectanglePath.moveToPoint(CGPointMake(minX, minY + h))
        rectanglePath.addLineToPoint(CGPointMake(minX + w, minY + h))
        rectanglePath.addLineToPoint(CGPointMake(minX, minY + h))
        rectanglePath.addLineToPoint(CGPointMake(minX, minY))
        rectanglePath.closePath()
        rectanglePath.moveToPoint(CGPointMake(minX, minY + h))
        
        return rectanglePath
    }
    
    func rectangle2PathWithBounds(bounds: CGRect) -> UIBezierPath{
        let rectangle2Path = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        rectangle2Path.moveToPoint(CGPointMake(minX + w, minY + h))
        rectangle2Path.addLineToPoint(CGPointMake(minX, minY))
        rectangle2Path.closePath()
        rectangle2Path.moveToPoint(CGPointMake(minX + w, minY + h))
        
        return rectangle2Path
    }
    
    func rectangle3PathWithBounds(bounds: CGRect) -> UIBezierPath{
        let rectangle3Path = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        rectangle3Path.moveToPoint(CGPointMake(minX + w, minY + h))
        rectangle3Path.addLineToPoint(CGPointMake(minX, minY))
        rectangle3Path.closePath()
        rectangle3Path.moveToPoint(CGPointMake(minX + w, minY + h))
        
        return rectangle3Path
    }
    
    func rectangle4PathWithBounds(bounds: CGRect) -> UIBezierPath{
        let rectangle4Path = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        rectangle4Path.moveToPoint(CGPointMake(minX + w, minY + h))
        rectangle4Path.addLineToPoint(CGPointMake(minX, minY))
        rectangle4Path.closePath()
        rectangle4Path.moveToPoint(CGPointMake(minX + w, minY + h))
        
        return rectangle4Path
    }
    
    func rectangle5PathWithBounds(bounds: CGRect) -> UIBezierPath{
        let rectangle5Path = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        rectangle5Path.moveToPoint(CGPointMake(minX + w, minY + h))
        rectangle5Path.addLineToPoint(CGPointMake(minX, minY))
        rectangle5Path.closePath()
        rectangle5Path.moveToPoint(CGPointMake(minX + w, minY + h))
        
        return rectangle5Path
    }
    
    func rectangle6PathWithBounds(bounds: CGRect) -> UIBezierPath{
        let rectangle6Path = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        rectangle6Path.moveToPoint(CGPointMake(minX + w, minY + h))
        rectangle6Path.addLineToPoint(CGPointMake(minX, minY))
        rectangle6Path.closePath()
        rectangle6Path.moveToPoint(CGPointMake(minX + w, minY + h))
        
        return rectangle6Path
    }
    
    func rectangle7PathWithBounds(bounds: CGRect) -> UIBezierPath{
        let rectangle7Path = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        rectangle7Path.moveToPoint(CGPointMake(minX + w, minY + h))
        rectangle7Path.addLineToPoint(CGPointMake(minX, minY))
        rectangle7Path.closePath()
        rectangle7Path.moveToPoint(CGPointMake(minX + w, minY + h))
        
        return rectangle7Path
    }
    
    func rectangle8PathWithBounds(bounds: CGRect) -> UIBezierPath{
        let rectangle8Path = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        rectangle8Path.moveToPoint(CGPointMake(minX + w, minY + h))
        rectangle8Path.addLineToPoint(CGPointMake(minX, minY))
        rectangle8Path.closePath()
        rectangle8Path.moveToPoint(CGPointMake(minX + w, minY + h))
        
        return rectangle8Path
    }
    
    func rectangle9PathWithBounds(bounds: CGRect) -> UIBezierPath{
        let rectangle9Path = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        rectangle9Path.moveToPoint(CGPointMake(minX + w, minY + h))
        rectangle9Path.addLineToPoint(CGPointMake(minX, minY))
        rectangle9Path.closePath()
        rectangle9Path.moveToPoint(CGPointMake(minX + w, minY + h))
        
        return rectangle9Path
    }
    
    func rectangle10PathWithBounds(bounds: CGRect) -> UIBezierPath{
        let rectangle10Path = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        rectangle10Path.moveToPoint(CGPointMake(minX + w, minY + h))
        rectangle10Path.addLineToPoint(CGPointMake(minX, minY))
        rectangle10Path.closePath()
        rectangle10Path.moveToPoint(CGPointMake(minX + w, minY + h))
        
        return rectangle10Path
    }
    
    func rectangle11PathWithBounds(bounds: CGRect) -> UIBezierPath{
        let rectangle11Path = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        rectangle11Path.moveToPoint(CGPointMake(minX + w, minY + h))
        rectangle11Path.addLineToPoint(CGPointMake(minX, minY))
        rectangle11Path.closePath()
        rectangle11Path.moveToPoint(CGPointMake(minX + w, minY + h))
        
        return rectangle11Path
    }
    
    func backPathWithBounds(bounds: CGRect) -> UIBezierPath{
        let backPath = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        backPath.moveToPoint(CGPointMake(minX + 0 * w, minY + h))
        backPath.addLineToPoint(CGPointMake(minX + 0 * w, minY))
        backPath.closePath()
        backPath.moveToPoint(CGPointMake(minX + 0 * w, minY + h))
        
        return backPath
    }
    
    func frontPathWithBounds(bounds: CGRect) -> UIBezierPath{
        let frontPath = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        frontPath.moveToPoint(CGPointMake(minX + 0 * w, minY + h))
        frontPath.addLineToPoint(CGPointMake(minX + 0 * w, minY))
        frontPath.closePath()
        frontPath.moveToPoint(CGPointMake(minX + 0 * w, minY + h))
        
        return frontPath
    }
    
    func back2PathWithBounds(bounds: CGRect) -> UIBezierPath{
        let back2Path = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        back2Path.moveToPoint(CGPointMake(minX + 0 * w, minY + h))
        back2Path.addLineToPoint(CGPointMake(minX + 0 * w, minY))
        back2Path.closePath()
        back2Path.moveToPoint(CGPointMake(minX + 0 * w, minY + h))
        
        return back2Path
    }
    
    func front2PathWithBounds(bounds: CGRect) -> UIBezierPath{
        let front2Path = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        front2Path.moveToPoint(CGPointMake(minX + 0 * w, minY + h))
        front2Path.addLineToPoint(CGPointMake(minX + 0 * w, minY))
        front2Path.closePath()
        front2Path.moveToPoint(CGPointMake(minX + 0 * w, minY + h))
        
        return front2Path
    }
    
    func back3PathWithBounds(bounds: CGRect) -> UIBezierPath{
        let back3Path = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        back3Path.moveToPoint(CGPointMake(minX + 0 * w, minY + h))
        back3Path.addLineToPoint(CGPointMake(minX + 0 * w, minY))
        back3Path.closePath()
        back3Path.moveToPoint(CGPointMake(minX + 0 * w, minY + h))
        
        return back3Path
    }
    
    func front3PathWithBounds(bounds: CGRect) -> UIBezierPath{
        let front3Path = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        front3Path.moveToPoint(CGPointMake(minX + 0 * w, minY + h))
        front3Path.addLineToPoint(CGPointMake(minX + 0 * w, minY))
        front3Path.closePath()
        front3Path.moveToPoint(CGPointMake(minX + 0 * w, minY + h))
        
        return front3Path
    }
    
    func back4PathWithBounds(bounds: CGRect) -> UIBezierPath{
        let back4Path = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        back4Path.moveToPoint(CGPointMake(minX + 0 * w, minY + h))
        back4Path.addLineToPoint(CGPointMake(minX + 0 * w, minY))
        back4Path.closePath()
        back4Path.moveToPoint(CGPointMake(minX + 0 * w, minY + h))
        
        return back4Path
    }
    
    func front4PathWithBounds(bounds: CGRect) -> UIBezierPath{
        let front4Path = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        front4Path.moveToPoint(CGPointMake(minX + 0 * w, minY + h))
        front4Path.addLineToPoint(CGPointMake(minX + 0 * w, minY))
        front4Path.closePath()
        front4Path.moveToPoint(CGPointMake(minX + 0 * w, minY + h))
        
        return front4Path
    }
    
    func back5PathWithBounds(bounds: CGRect) -> UIBezierPath{
        let back5Path = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        back5Path.moveToPoint(CGPointMake(minX + 0 * w, minY + h))
        back5Path.addLineToPoint(CGPointMake(minX + 0 * w, minY))
        back5Path.closePath()
        back5Path.moveToPoint(CGPointMake(minX + 0 * w, minY + h))
        
        return back5Path
    }
    
    func front5PathWithBounds(bounds: CGRect) -> UIBezierPath{
        let front5Path = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        front5Path.moveToPoint(CGPointMake(minX + 0 * w, minY + h))
        front5Path.addLineToPoint(CGPointMake(minX + 0 * w, minY))
        front5Path.closePath()
        front5Path.moveToPoint(CGPointMake(minX + 0 * w, minY + h))
        
        return front5Path
    }
    
    func back6PathWithBounds(bounds: CGRect) -> UIBezierPath{
        let back6Path = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        back6Path.moveToPoint(CGPointMake(minX + 0 * w, minY + h))
        back6Path.addLineToPoint(CGPointMake(minX + 0 * w, minY))
        back6Path.closePath()
        back6Path.moveToPoint(CGPointMake(minX + 0 * w, minY + h))
        
        return back6Path
    }
    
    func front6PathWithBounds(bounds: CGRect) -> UIBezierPath{
        let front6Path = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        front6Path.moveToPoint(CGPointMake(minX + 0 * w, minY + h))
        front6Path.addLineToPoint(CGPointMake(minX + 0 * w, minY))
        front6Path.closePath()
        front6Path.moveToPoint(CGPointMake(minX + 0 * w, minY + h))
        
        return front6Path
    }
    
    func back7PathWithBounds(bounds: CGRect) -> UIBezierPath{
        let back7Path = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        back7Path.moveToPoint(CGPointMake(minX + 0 * w, minY + h))
        back7Path.addLineToPoint(CGPointMake(minX + 0 * w, minY))
        back7Path.closePath()
        back7Path.moveToPoint(CGPointMake(minX + 0 * w, minY + h))
        
        return back7Path
    }
    
    func front7PathWithBounds(bounds: CGRect) -> UIBezierPath{
        let front7Path = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        front7Path.moveToPoint(CGPointMake(minX + 0 * w, minY + h))
        front7Path.addLineToPoint(CGPointMake(minX + 0 * w, minY))
        front7Path.closePath()
        front7Path.moveToPoint(CGPointMake(minX + 0 * w, minY + h))
        
        return front7Path
    }
    
    func back8PathWithBounds(bounds: CGRect) -> UIBezierPath{
        let back8Path = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        back8Path.moveToPoint(CGPointMake(minX + 0 * w, minY + h))
        back8Path.addLineToPoint(CGPointMake(minX + 0 * w, minY))
        back8Path.closePath()
        back8Path.moveToPoint(CGPointMake(minX + 0 * w, minY + h))
        
        return back8Path
    }
    
    func front8PathWithBounds(bounds: CGRect) -> UIBezierPath{
        let front8Path = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        front8Path.moveToPoint(CGPointMake(minX + 0 * w, minY + h))
        front8Path.addLineToPoint(CGPointMake(minX + 0 * w, minY))
        front8Path.closePath()
        front8Path.moveToPoint(CGPointMake(minX + 0 * w, minY + h))
        
        return front8Path
    }
    
    func back9PathWithBounds(bounds: CGRect) -> UIBezierPath{
        let back9Path = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        back9Path.moveToPoint(CGPointMake(minX + 0 * w, minY + h))
        back9Path.addLineToPoint(CGPointMake(minX + 0 * w, minY))
        back9Path.closePath()
        back9Path.moveToPoint(CGPointMake(minX + 0 * w, minY + h))
        
        return back9Path
    }
    
    func front9PathWithBounds(bounds: CGRect) -> UIBezierPath{
        let front9Path = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        front9Path.moveToPoint(CGPointMake(minX + 0 * w, minY + h))
        front9Path.addLineToPoint(CGPointMake(minX + 0 * w, minY))
        front9Path.closePath()
        front9Path.moveToPoint(CGPointMake(minX + 0 * w, minY + h))
        
        return front9Path
    }
    
    func back10PathWithBounds(bounds: CGRect) -> UIBezierPath{
        let back10Path = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        back10Path.moveToPoint(CGPointMake(minX + 0 * w, minY + h))
        back10Path.addLineToPoint(CGPointMake(minX + 0 * w, minY))
        back10Path.closePath()
        back10Path.moveToPoint(CGPointMake(minX + 0 * w, minY + h))
        
        return back10Path
    }
    
    func front10PathWithBounds(bounds: CGRect) -> UIBezierPath{
        let front10Path = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        front10Path.moveToPoint(CGPointMake(minX + 0 * w, minY + h))
        front10Path.addLineToPoint(CGPointMake(minX + 0 * w, minY))
        front10Path.closePath()
        front10Path.moveToPoint(CGPointMake(minX + 0 * w, minY + h))
        
        return front10Path
    }
    
    func back11PathWithBounds(bounds: CGRect) -> UIBezierPath{
        let back11Path = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        back11Path.moveToPoint(CGPointMake(minX + 0 * w, minY + h))
        back11Path.addLineToPoint(CGPointMake(minX + 0 * w, minY))
        back11Path.closePath()
        back11Path.moveToPoint(CGPointMake(minX + 0 * w, minY + h))
        
        return back11Path
    }
    
    func front11PathWithBounds(bounds: CGRect) -> UIBezierPath{
        let front11Path = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        front11Path.moveToPoint(CGPointMake(minX + 0 * w, minY + h))
        front11Path.addLineToPoint(CGPointMake(minX + 0 * w, minY))
        front11Path.closePath()
        front11Path.moveToPoint(CGPointMake(minX + 0 * w, minY + h))
        
        return front11Path
    }
    
    func back12PathWithBounds(bounds: CGRect) -> UIBezierPath{
        let back12Path = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        back12Path.moveToPoint(CGPointMake(minX + 0 * w, minY + h))
        back12Path.addLineToPoint(CGPointMake(minX + 0 * w, minY))
        back12Path.closePath()
        back12Path.moveToPoint(CGPointMake(minX + 0 * w, minY + h))
        
        return back12Path
    }
    
    func front12PathWithBounds(bounds: CGRect) -> UIBezierPath{
        let front12Path = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        front12Path.moveToPoint(CGPointMake(minX + 0 * w, minY + h))
        front12Path.addLineToPoint(CGPointMake(minX + 0 * w, minY))
        front12Path.closePath()
        front12Path.moveToPoint(CGPointMake(minX + 0 * w, minY + h))
        
        return front12Path
    }
    
    func back13PathWithBounds(bounds: CGRect) -> UIBezierPath{
        let back13Path = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        back13Path.moveToPoint(CGPointMake(minX + 0 * w, minY + h))
        back13Path.addLineToPoint(CGPointMake(minX + 0 * w, minY))
        back13Path.closePath()
        back13Path.moveToPoint(CGPointMake(minX + 0 * w, minY + h))
        
        return back13Path
    }
    
    func front13PathWithBounds(bounds: CGRect) -> UIBezierPath{
        let front13Path = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        front13Path.moveToPoint(CGPointMake(minX + 0 * w, minY + h))
        front13Path.addLineToPoint(CGPointMake(minX + 0 * w, minY))
        front13Path.closePath()
        front13Path.moveToPoint(CGPointMake(minX + 0 * w, minY + h))
        
        return front13Path
    }
    
    func back14PathWithBounds(bounds: CGRect) -> UIBezierPath{
        let back14Path = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        back14Path.moveToPoint(CGPointMake(minX + 0 * w, minY + h))
        back14Path.addLineToPoint(CGPointMake(minX + 0 * w, minY))
        back14Path.closePath()
        back14Path.moveToPoint(CGPointMake(minX + 0 * w, minY + h))
        
        return back14Path
    }
    
    func front14PathWithBounds(bounds: CGRect) -> UIBezierPath{
        let front14Path = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        front14Path.moveToPoint(CGPointMake(minX + 0 * w, minY + h))
        front14Path.addLineToPoint(CGPointMake(minX + 0 * w, minY))
        front14Path.closePath()
        front14Path.moveToPoint(CGPointMake(minX + 0 * w, minY + h))
        
        return front14Path
    }
    
    func back15PathWithBounds(bounds: CGRect) -> UIBezierPath{
        let back15Path = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        back15Path.moveToPoint(CGPointMake(minX + 0 * w, minY + h))
        back15Path.addLineToPoint(CGPointMake(minX + 0 * w, minY))
        back15Path.closePath()
        back15Path.moveToPoint(CGPointMake(minX + 0 * w, minY + h))
        
        return back15Path
    }
    
    func front15PathWithBounds(bounds: CGRect) -> UIBezierPath{
        let front15Path = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        front15Path.moveToPoint(CGPointMake(minX + 0 * w, minY + h))
        front15Path.addLineToPoint(CGPointMake(minX + 0 * w, minY))
        front15Path.closePath()
        front15Path.moveToPoint(CGPointMake(minX + 0 * w, minY + h))
        
        return front15Path
    }
    
    
}





