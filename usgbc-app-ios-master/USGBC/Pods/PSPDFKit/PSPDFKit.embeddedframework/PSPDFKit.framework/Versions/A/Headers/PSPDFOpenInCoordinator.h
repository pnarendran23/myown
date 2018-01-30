//
//  PSPDFOpenInCoordinator.h
//  PSPDFKit
//
//  Copyright (c) 2014-2015 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//
#import "PSPDFDocumentSharingCoordinator.h"

// These notifications represent a small subset of `UIDocumentInteractionControllerDelegate` (but the most important ones)
// To get all callbacks, subclass `PSPDFOpenInCoordinator` and implement the callbacks (and also call super)
extern NSString *const PSPDFDocumentInteractionControllerWillBeginSendingToApplicationNotification;
extern NSString *const PSPDFDocumentInteractionControllerDidEndSendingToApplicationNotification;

@interface PSPDFOpenInCoordinator : PSPDFDocumentSharingCoordinator <UIDocumentInteractionControllerDelegate>

@end

@interface PSPDFOpenInCoordinator (SubclassingHooks)

// Instance of the document interaction controller while visible.
@property (nonatomic, weak, readonly) UIDocumentInteractionController *documentInteractionController;

@end
