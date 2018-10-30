//
//  PSPDFApplicationPolicy.h
//  PSPDFKit
//
//  Copyright (c) 2014-2015 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <Foundation/Foundation.h>
#import "PSPDFPlugin.h"
#import "PSPDFMacros.h"

PSPDF_EXTERN NSString *const PSPDFPolicyEventOpenIn;
PSPDF_EXTERN NSString *const PSPDFPolicyEventPrint;
PSPDF_EXTERN NSString *const PSPDFPolicyEventEmail;
PSPDF_EXTERN NSString *const PSPDFPolicyEventMessage;
PSPDF_EXTERN NSString *const PSPDFPolicyEventQuickLook;
PSPDF_EXTERN NSString *const PSPDFPolicyEventAudioRecording;
PSPDF_EXTERN NSString *const PSPDFPolicyEventCamera;
PSPDF_EXTERN NSString *const PSPDFPolicyEventPhotoLibrary;
PSPDF_EXTERN NSString *const PSPDFPolicyEventPasteboard;
PSPDF_EXTERN NSString *const PSPDFPolicyEventSubmitForm;
PSPDF_EXTERN NSString *const PSPDFPolicyEventNetwork;

/// The security auditor protocol allows to define a custom set of overrides for various security related tasks.
@protocol PSPDFApplicationPolicy <PSPDFPlugin>

// Returns YES when the `PSPDFPolicyEvent` is allowed.
// `isUserAction` is a hint that indicates if we're in a user action or an automated test.
// If it's a user action, it is appropriate to present an alert explaining the lack of permissions.
- (BOOL)hasPermissionForEvent:(NSString *)event isUserAction:(BOOL)isUserAction;

@end

// The default security auditor simply returns YES for every request.
@interface PSPDFDefaultApplicationPolicy : NSObject <PSPDFApplicationPolicy>
@end
