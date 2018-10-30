//
//  ComplicationController.swift
//  LEEDOn watch app Extension
//
//  Created by Group X on 21/09/16.
//  Copyright © 2016 USGBC. All rights reserved.
//

import ClockKit


class ComplicationController: NSObject, CLKComplicationDataSource {
    
    // MARK: - Timeline Configuration
    
    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
        handler([.forward, .backward])
    }
    
    func getTimelineStartDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(nil)
    }
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(nil)
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.showOnLockScreen)
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        // Call the handler with the current timeline entry
        let prefs = UserDefaults.standard
        prefs.synchronize()
        
        let energyscore = prefs.integer(forKey:"energyscore")
        let waterscore = prefs.integer(forKey: "waterscore")
        let wastescore = prefs.integer(forKey: "wastescore")
        let transportscore = prefs.integer(forKey: "transportscore")
        let humanscore = prefs.integer(forKey: "humanscore")
        let basescore = prefs.integer(forKey: "basescore")
        print(energyscore,waterscore)
        let totalscore = energyscore+waterscore+wastescore+transportscore+humanscore+basescore
        var certlbl = ""
        if(totalscore>=60 && totalscore<=75){
            certlbl = "gold"
            //[_certificationgroup setBackgroundImageNamed:@"gold"];
            
        }
        else if (totalscore>75){
            certlbl = "platinum"
        }
        else if (totalscore>=50 && totalscore<=59){
            certlbl = "silver"
            //[_certificationgroup setBackgroundImageNamed:@"silver"];
        }
        else if(totalscore>=40 && totalscore<=49)
        {
            certlbl = "certified"
            // [_certificationgroup setBackgroundImageNamed:@"certified"];
        }
        else{
            certlbl = "Blank"
            //   [_certificationgroup setBackgroundImageNamed:@"blank"];
        }
        certlbl = certlbl.uppercased()
        switch complication.family{
        case .circularSmall:
            let template = CLKComplicationTemplateCircularSmallRingText()
            template.fillFraction = Float(totalscore)/99.0
            template.textProvider = CLKSimpleTextProvider(text: String(format: "%d", totalscore))
            handler(CLKComplicationTimelineEntry(date: NSDate() as Date, complicationTemplate: template))
            
        case .modularLarge:
            let template = CLKComplicationTemplateModularLargeStandardBody()
            template.headerTextProvider = CLKSimpleTextProvider(text: "LEEDOn app")
            template.body1TextProvider = CLKSimpleTextProvider(text: certlbl as String, shortText: nil)
            template.body2TextProvider = CLKSimpleTextProvider(text: String(format: "LEED score is %d", totalscore))
            handler(CLKComplicationTimelineEntry(date: NSDate() as Date, complicationTemplate: template))
            
        case.modularSmall:
            let template = CLKComplicationTemplateModularSmallRingText()
            template.textProvider = CLKSimpleTextProvider(text: String(format: "%d", totalscore))
            template.fillFraction = Float(totalscore)/99.0
            handler(CLKComplicationTimelineEntry(date: NSDate() as Date, complicationTemplate: template))
            
        case .utilitarianLarge:
            let template = CLKComplicationTemplateUtilitarianLargeFlat()
            template.textProvider = CLKSimpleTextProvider(text: String(format: "%d", totalscore))
            handler(CLKComplicationTimelineEntry(date: NSDate() as Date, complicationTemplate: template))
            
        case .utilitarianSmall:
            let template = CLKComplicationTemplateUtilitarianSmallRingText()
            template.textProvider = CLKSimpleTextProvider(text: String(format: "%d", totalscore))
            template.fillFraction = Float(totalscore)/99.0
            handler(CLKComplicationTimelineEntry(date: NSDate() as Date, complicationTemplate: template))
            
        default:
            break
            
        }
        
        handler(nil)
    }
    
    func getTimelineEntries(for complication: CLKComplication, before date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries prior to the given date
        handler(nil)
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries after to the given date
        handler(nil)
    }
    
    // MARK: - Placeholder Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        if complication.family == .utilitarianSmall {
            let template = CLKComplicationTemplateUtilitarianSmallRingText()
            template.textProvider = CLKSimpleTextProvider(text: "")
            template.fillFraction = 11.0/55.0
            handler(template)
        }

        handler(nil)
    }
    
}
  
