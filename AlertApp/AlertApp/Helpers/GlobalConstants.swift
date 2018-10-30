//
//  GlobalConstants.swift
//  Alert app
//
//  Created by Ashok on 02/02/18.
//  Copyright © 2017 Administrator. All rights reserved.

import UIKit

public enum AlertPopupType: Int {
    case success = 1
    case error = 2
    case question = 3
}

public struct GlobalConstants {
    
    struct Constants {
        static let appName = "Alert App"
    }
    
    struct API {
        
//        static let baseUrl = "http://188.166.209.231/api/"
        static let baseUrl = "https://api.placer.school/api/"
        
        static let appLogin = "v2/index.php?path=mobileapp/app_login"
        static let otpVerification = "v2/index.php?path=mobileapp/otp_verification"
        static let appMemberInfo = "v2/index.php?path=mobileapp/get_app_memberinfo"
        static let appLiveVehInfo = "v2/index.php?path=mobileapp/get_app_livevehicleinfo"
        static let alertsConfig = "/v2/index.php?path=mobileapp/app_memberalertConfig"
        static let resendOtp = "v2/index.php?path=mobileapp/otp_resend"
        static let alertsLog = "v2/index.php?path=mobileapp/app_proxialertreports"
       
         static let msgLog = "v2/index.php?path=mobileapp/app_broadcastreports"
         static let appLogout = "v2/index.php?path=mobileapp/app_logout"
    }
    
    struct Errors {
        static let internetConnectionError = "Internet connection not available."
        static let dataNotAvailable = "Data not available."
        static let emailFormatInvalid = "This email is invalid."
        static let emailConfirmationNotIdentical = "Email and email confirmation are not the same."
        static let passwordConfirmationNotIdentical = "Password does not match the repeat password."
        static let emailIsMandatory = "Please enter an email address."
        static let passwordIsMandatory = "Please enter a password."
        static let invalidCredentials = "Email or password invalid."
        static let userNotFound = "These credentials are not found, do you want to sign up this them."
    }
    
    struct DeviceType
    {
        static let iPad  = UIDevice.current.userInterfaceIdiom == .pad
        static let iPhone  = UIDevice.current.userInterfaceIdiom == .phone
        static let retina  = UIScreen.main.scale >= 2
        static let screenWidth = UIScreen.main.bounds.size.width
        static let screenHeight = UIScreen.main.bounds.size.height
        static let screenMaxLength = max(screenWidth, screenHeight)
        static let screenMinLength = min(screenWidth, screenHeight)
        static let  iPhone4 = screenMaxLength < 568.0
        static let  iPhone5 = screenMaxLength == 568.0
        static let  iPhone6 = screenMaxLength == 667.0
        static let  iPhone6P = screenMaxLength == 736.0
        static let  iPadMini = screenMaxLength == 768.0
        static let  iPadPro = screenMaxLength == 1024.0
        static let  iPadLarge = screenMaxLength == 1366.0
    }
}
