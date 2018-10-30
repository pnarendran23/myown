//
//  CourseDetails.swift
//  USGBC
//
//  Created by Vishal on 30/04/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import Foundation
import SwiftyJSON

class CourseDetails{
    var courseid = ""
    var title = ""
    var path = ""
    var published_date = ""
    var price = ""
    var image = ""
    var course_name = ""
    var type = ""
    var gbci_number = ""
    var course_leed_versions = [String]()
    var course_credentials = [String]()
    var summary = ""
    var body = ""
    var objectives = [String]()
    var subscription = ""
    var course_level = ""
    var eligible_for_ce = ""
    var ce_hours = ""
    var hosted_on_usgbc = ""
    var star_rating = ""
    var quiz_title = ""
    var course_modules = [String]()
    var crs_level_tid = ""
    var quiz_path = ""
    var aia_hours = ""
    var aia_credit_designation = ""
    var external_course_url = ""
    var video_url = ""
    var scorm_file = ""
    var resources = [Resources]()
    var leaders = [Leader]()
    var providers = [Providers]()
    var sessions = [Session]()
    var access = false
    
    init() {}
    
    init(json: JSON) {
        courseid = json["courseid"].stringValue
        title = json["title"].stringValue
        path = json["path"].stringValue
        published_date = json["published_date"].stringValue
        price = json["price"].stringValue
        image = json["image"].stringValue
        course_name = json["course_name"].stringValue
        type = json["type"].stringValue
        gbci_number = json["gbci_number"].stringValue
        let tempVersions = json["course_leed_versions"].stringValue
        if(tempVersions.isEmpty){
            for (_,course_leed_version):(String, JSON) in json["course_leed_versions"] {
                course_leed_versions.append(course_leed_version.stringValue)
            }
        }else{
            course_leed_versions.append(tempVersions)
        }
        let tempCreds = json["course_credentials"].stringValue
        if(tempCreds.isEmpty){
            for (_,course_credential):(String, JSON) in json["course_credentials"] {
                course_credentials.append(course_credential.stringValue)
            }
        }else{
            course_credentials.append(tempCreds)
        }
        summary = json["summary"].stringValue
        body = json["body"].stringValue
        for (_,objective):(String, JSON) in json["objectives"] {
            objectives.append(objective.stringValue)
        }
        subscription = json["subscription"].stringValue
        course_level = json["course_level"].stringValue
        eligible_for_ce = json["eligible_for_ce"].stringValue
        ce_hours = json["ce_hours"].stringValue
        hosted_on_usgbc = json["hosted_on_usgbc"].stringValue
        star_rating = json["star_rating"].stringValue
        quiz_title = json["quiz_title"].stringValue
        for (_,courseModule):(String, JSON) in json["course_modules"] {
            course_modules.append(courseModule.stringValue)
        }
        course_modules = course_modules.sorted{ $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending }
        crs_level_tid = json["crs_level_tid"].stringValue
        quiz_path = json["quiz_path"].stringValue
        aia_credit_designation = json["aia_credit_designation"].stringValue
        external_course_url = json["external_course_url"].stringValue
        quiz_title = json["quiz_title"].stringValue
        aia_hours = json["aia_hours"].stringValue
        video_url = json["video_url"].stringValue
        scorm_file = json["scorm_file"].stringValue
    }
    
    func getCourseDetailsHtmlContents(contents: String) -> String {
        var contents = contents
        //MARK: - Sign In Message
        var msg = ""
        if(Utility().getTokenDetail() == ""){
            msg = "<div class='box' style='text-align:center; background:#eee'><p>Please sign in above to access this course.</p></div>"
        }
        contents = contents.replacingOccurrences(of: "{{sign-in}}", with: msg)
        //MARK: - Course Title
        contents = contents.replacingOccurrences(of: "{{title}}", with: title)
        //MARK: - GBCI Number
        contents = contents.replacingOccurrences(of: "{{gbci-number}}", with: (gbci_number != " ") ? "GBCI Number: " + gbci_number : "")
        //MARK: - LEED Version
        let leedVersions = course_leed_versions.joined(separator: ",")
        contents = contents.replacingOccurrences(of: "{{leed-version}}", with: (leedVersions != "") ? "LEED Version: " + leedVersions + "<br>" : "")
        //MARK: - Published Date
        contents = contents.replacingOccurrences(of: "{{published-date}}", with: "Published on: " + published_date)
        //MARK: - Course Level
        contents = contents.replacingOccurrences(of: "{{level}}", with: course_level)
        //MARK: - CE Hours
        contents = contents.replacingOccurrences(of: "{{ce-hours}}", with: "<ul class='ce-hours'>" +
            "<li><span class='ce-left'>" + ce_hours + "</span><span class='ce-right'><small style='margin-top: 4pt;'>C</small><small style='margin-top: -3pt;'>E</small></span></li></ul>")
        //MARK: - Course Credentials
        var leedAPHomes = ""
        var leedAPAll = ""
        var leedAPBdc = ""
        var leedAPIdc = ""
        var leedAPOm = ""
        var leedAPNd = ""
        //var fellow = ""
        var ga = ""
        var aia = ""
        course_credentials.forEach { creds in
            switch(creds){
                case "LEED AP Homes":
                    leedAPHomes = "<li class='crs_cert-ap-homes' title='LU/HSW'>LEED AP Homes</li>"
                case "LEED AP All":
                    leedAPAll = "<li class='crs_cert-ap-all' title='LU/HSW'>LEED AP All</li>"
                case "LEED AP BD+C":
                    leedAPBdc = "<li class='crs_cert-ap-bdc' title='LU/HSW'>LEED AP BDC</li>"
                case "LEED AP ID+C":
                    leedAPIdc = "<li class='crs_cert-ap-idc' title='LU/HSW'>LEED AP IDC</li>"
                case "LEED AP O+M":
                    leedAPOm = "<li class='crs_cert-ap-om' title='LU/HSW'>LEED AP OM</li>"
                case "LEED AP N+D":
                    leedAPNd = "<li class='crs_cert-ap-nd' title='LU/HSW'>LEED AP ND</li>"
                default:
                    break
            }
        }
        if (!leedAPHomes.isEmpty || !leedAPAll.isEmpty || !leedAPBdc.isEmpty || !leedAPIdc.isEmpty || !leedAPNd.isEmpty || !leedAPOm.isEmpty) {
            ga = "<li class='crs_cert-ga' title='LU/HSW'>LEED Green Associate</li>"
        }
        if (!aia_credit_designation.isEmpty) {
            aia = "<li class='crs_cert-aia' title='LU/HSW'>AIA</li>"
        }
        contents = contents.replacingOccurrences(of: "{{crs_cert-ap-all}}", with: leedAPAll)
        contents = contents.replacingOccurrences(of: "{{crs_cert-ap-bdc}}", with: leedAPBdc)
        contents = contents.replacingOccurrences(of: "{{crs_cert-ap-homes}}", with: leedAPHomes)
        contents = contents.replacingOccurrences(of: "{{crs_cert-ap-idc}}", with: leedAPIdc)
        contents = contents.replacingOccurrences(of: "{{crs_cert-ap-om}}", with: leedAPOm)
        contents = contents.replacingOccurrences(of: "{{crs_cert-ap-nd}}", with: leedAPNd)
        contents = contents.replacingOccurrences(of: "{{crs_cert-ga}}", with: ga)
        contents = contents.replacingOccurrences(of: "{{crs_cert-aia}}", with: aia)
        contents = contents.replacingOccurrences(of: "{{crs_cert-fellow}}", with: "")
        //MARK: - Course Summary
        contents = contents.replacingOccurrences(of: "{{summary}}", with: summary)
        //MARK: - Subscription Image
        var subsImage = ""
        if (subscription.lowercased() == "included" && subscription != "") {
            subsImage = "<p class='cert-flag'>&nbsp;</p>"
        }
        if (type.lowercased() == "parent" && type != "") {
            subsImage = "<p class='cert-flag-series'>&nbsp;</p>"
        }
        //MARK: - Course Image
        var image_video = ""
        var videoDownloadUrl = ""
        if (Utility().getTokenDetail() != "" && access == true) {
            if (!hosted_on_usgbc.isEmpty && hosted_on_usgbc.contains("Yes")) {
                if (!video_url.isEmpty) {
                    image_video = "<video controls='' preload='none' width='100%' poster='" + image + "' data-setup='{&quot;example_option&quot;:true}'> <source src='" + video_url + "' type='video/mp4'></video>"
                    videoDownloadUrl = "<br><a href='" + video_url + "' target='_blank'><strong>Download Video</strong></a><br>"
                } else if (!scorm_file.isEmpty) {
                    let scromPlay = "<a href = 'http://www.usgbc.org/view/scrom?nid=" + courseid + "' target='_blank'> <div class='play-button'><i class='fa fa-youtube-play'></i></div> </a>"
                    image_video = subsImage + "<img src='" + image + "'>" + scromPlay
                } else {
                    if (!image.isEmpty){
                        image_video = subsImage + "<img src='" + image + "'>"
                    }
                }
            } else {
                if (!image.isEmpty){
                    image_video = subsImage + "<img src='" + image + "'>"
                }
            }
        } else {
            if (!image.isEmpty){
                image_video = subsImage + "<img src='" + image + "'>"
            }
        }
        contents = contents.replacingOccurrences(of: "{{image-video}}", with: image_video + "<br>")
        contents = contents.replacingOccurrences(of: "{{video-download-url}}", with: videoDownloadUrl + "<br>")
        //MARK: - Course Quiz
        var quiz = ""
        if (!hosted_on_usgbc.isEmpty && hosted_on_usgbc.contains("No")) {
            if (!external_course_url.isEmpty) {
                quiz = "<div class='box' style='text-align:center; background:#eee'>" +
                    "<a class='jumbo-button-dark' id='redirect-link' href='" + external_course_url + "' target='_blank'>Learn more</a>" +
                "<p>Please note: This course is offered on another organization's website, which means that you must leave the USGBC app to view this course.</p></div>"
            }
        }
        if (Utility().getTokenDetail() != "" && access == true) {
            if (!quiz_title.isEmpty) {
                let email = Utility().getUserDetail()
                quiz = "<div class='box' style='text-align:center; background:#eee'>" +
                    "<a id='btn_register' class='jumbo-button-dark' href='" +
                    "http://www.usgbc.org/mobile/services/usgbc-quiz-access/" + courseid + "/" + email + "' target='_blank'>Take the Quiz</a>" +
                "</div>"
            }
        }
        contents = contents.replacingOccurrences(of: "{{quiz}}", with: quiz)
        //MARK: - Course Body
        contents = contents.replacingOccurrences(of: "{{about}}", with: "<h2>About</h2> <p>" + body + "</p>")
        //MARK: - Course Objectives
        var finalObjectives = "<p></p><ol>"
        for objective in objectives {
            finalObjectives = finalObjectives + "<li>" + objective + "</li>"
        }
        finalObjectives += "</ol><p></p>"
        contents = contents.replacingOccurrences(of: "{{objectives}}", with: "<h2>Objectives</h2>" + finalObjectives)
        //MARK: - Course Modules
        var finalCourseModule = ""
        if (Utility().getTokenDetail() != "" && access == true) {
            for module in course_modules {
                var courseModuleParts = module.components(separatedBy: "\n")
                let temp2 = "<b>" + courseModuleParts[0] + "</b><br><b>" + courseModuleParts[1] + "</b><br><br>" + "<video controls='' preload='none' width='100%' poster='" + image + "' data-setup='{&quot;example_option&quot;:true}'> <source src='" + courseModuleParts[2] + "' type='video/mp4'></video><hr>"
                finalCourseModule += temp2
            }
        }
        if(!finalCourseModule.isEmpty){
            finalCourseModule = "<h3>Course Modules</h3><br>" + finalCourseModule
        }
        contents = contents.replacingOccurrences(of: "{{course-module}}", with: finalCourseModule)
        //MARK: - Course Provider
//        var createdBy = ""
//        var educationPartner = ""
//        providers.forEach { provider in
//            createdBy = "<h3>Created by</h3><br><img src='" + provider.image + "'> <br><strong>" + provider.title + "</strong><br>"
//            if (!provider.city.isEmpty) {
//                createdBy += provider.city
//            }
//            if (!provider.state.isEmpty) {
//                createdBy += ", " + provider.state
//            }
//            if (!provider.country.isEmpty) {
//                createdBy += "<br>" + provider.country + "<br><br>"
//            }
//            provider.associations.forEach({ association in
//                if(association.contains("Education Partner")){
//                    educationPartner = "<img style='width: 125px; height:37px;' src='http://admin.usgbc.org/sites/default/files/imagecache/max-both_250-75/sites/all/themes/usgbc/lib/img/education-partner.png'> <p class='partner-text'>USGBC Education Partners are leaders and trusted voices and reputable providers of green building and sustainability education. <a href='http://www.usgbc.org/education#become-a-partner' target='_blank'>Learn more.</a></p><br>"
//                }
//            })
//        }
//        contents = contents.replacingOccurrences(of: "{{created-by}}", with: createdBy)
//        contents = contents.replacingOccurrences(of: "{{education-partner}}", with: educationPartner)
//        //MARK: - Course Leaders
//        var finalLeaders = ""
//        leaders.forEach { leader in
//            finalLeaders = "<div class='ag-item'><div class='ag-data'><h3 class='ag-item-title'>" + leader.first_name + " " + leader.last_name + "</h3>"
//            if (!leader.job_title.isEmpty) {
//                finalLeaders += "<span class='ag-item-detail'><strong>" + leader.job_title + "</strong></span><br>"
//            }
//            if (!leader.org_name.isEmpty) {
//                finalLeaders += "<span class='ag-item-detail'>" + leader.org_name + "</span><br></div></div>"
//            }
//        }
//        if(!finalLeaders.isEmpty){
//            finalLeaders = "<br><h3>Leaders</h3><br>" + finalLeaders
//        }
//        contents = contents.replacingOccurrences(of: "{{leaders}}", with: finalLeaders)
//        //MARK: - Course Resources
//        var finalResources = ""
//        if (Utility().getTokenDetail() != "" && access == true) {
//            resources.forEach { resource in
//                finalResources += "<ul><li><a href='" + resource.url + "' target='_blank' >" + resource.description + "</a></li></ul>"
//            }
//        }
//        if(!finalResources.isEmpty){
//            finalResources = "<h3>Resources</h3>" + finalResources
//        }
//        contents = contents.replacingOccurrences(of: "{{resources}}", with: finalResources)
//        //MARK: - Course Included Sessions
//        var includedSessions = ""
//        sessions.forEach { session in
//            includedSessions += "<div id='session-image-container' onclick='handleSession("+session.courseid+")'><img src='" + session.image + "' width=100% height=70%><br><p style= 'margin-left: 10px; font-size:12px; display: block'><b>" + session.title +
//            "</b></p><p style= 'margin-left: 10px; font-size:10px; display: block'>" + session.provider_name + "</</p></div><br>"
//        }
//        if(!includedSessions.isEmpty){
//            includedSessions = "<h3>Included Sessions</h3><br>" + includedSessions
//        }
//        contents = contents.replacingOccurrences(of: "{{sessions}}", with: includedSessions)
        return contents
    }
    
    func getCourseLeadersHtmlContents(contents: String) -> String {
        var contents = contents
        var finalLeaders = ""
        leaders.forEach { leader in
            finalLeaders = "<div class='ag-item'><div class='ag-data'><h3 class='ag-item-title'>" + leader.first_name + " " + leader.last_name + "</h3>"
            if (!leader.job_title.isEmpty) {
                finalLeaders += "<span class='ag-item-detail'><strong>" + leader.job_title + "</strong></span><br>"
            }
            if (!leader.org_name.isEmpty) {
                finalLeaders += "<span class='ag-item-detail'>" + leader.org_name + "</span><br></div></div>"
            }
        }
        if(!finalLeaders.isEmpty){
            finalLeaders = "<br><h3>Leaders</h3><br>" + finalLeaders
        }
        contents = contents.replacingOccurrences(of: "{{leaders}}", with: finalLeaders)
        return contents
    }
    
    func getCourseProvidersHtmlContents(contents: String) -> String {
        var contents = contents
        var createdBy = ""
        var educationPartner = ""
        providers.forEach { provider in
            createdBy = "<h3>Created by</h3><br><img src='" + provider.image + "'> <br><strong>" + provider.title + "</strong><br>"
            if (!provider.city.isEmpty) {
                createdBy += provider.city
            }
            if (!provider.state.isEmpty) {
                createdBy += ", " + provider.state
            }
            if (!provider.country.isEmpty) {
                createdBy += "<br>" + provider.country + "<br><br>"
            }
            provider.associations.forEach({ association in
                if(association.contains("Education Partner")){
                    educationPartner = "<img style='width: 125px; height:37px;' src='http://admin.usgbc.org/sites/default/files/imagecache/max-both_250-75/sites/all/themes/usgbc/lib/img/education-partner.png'> <p class='partner-text'>USGBC Education Partners are leaders and trusted voices and reputable providers of green building and sustainability education. <a href='http://www.usgbc.org/education#become-a-partner' target='_blank'>Learn more.</a></p><br>"
                }
            })
        }
        contents = contents.replacingOccurrences(of: "{{created-by}}", with: createdBy)
        contents = contents.replacingOccurrences(of: "{{education-partner}}", with: educationPartner)
        return contents
    }
    
    func getCourseSessionsHtmlContents(contents: String) -> String {
        var contents = contents
        var includedSessions = ""
        sessions.forEach { session in
            includedSessions += "<div id='session-image-container' onclick='handleSession("+session.courseid+")'><img src='" + session.image + "' width=100% height=70%><br><p style= 'margin-left: 10px; font-size:12px; display: block'><b>" + session.title +
                "</b></p><p style= 'margin-left: 10px; font-size:10px; display: block'>" + session.provider_name + "</</p></div><br>"
        }
        if(!includedSessions.isEmpty){
            includedSessions = "<h3>Included Sessions</h3><br>" + includedSessions
        }
        contents = contents.replacingOccurrences(of: "{{sessions}}", with: includedSessions)
        return contents
    }
    
    func getCourseResourcesHtmlContents(contents: String) -> String {
        var contents = contents
        var finalResources = ""
        if (Utility().getTokenDetail() != "" && access == true) {
            resources.forEach { resource in
                finalResources += "<ul><li><a href='" + resource.url + "' target='_blank' >" + resource.description + "</a></li></ul>"
            }
        }
        if(!finalResources.isEmpty){
            finalResources = "<h3>Resources</h3>" + finalResources
        }
        contents = contents.replacingOccurrences(of: "{{resources}}", with: finalResources)
        return contents
    }
}
