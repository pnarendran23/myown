//
//  PSPDFMailCoordinator.h
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
#import <MessageUI/MessageUI.h>
#import "PSPDFDocumentSharingCoordinator.h"

/// The mail coordinator shows the document sharing sheet and then the mail sheet and manages the flow during that operation.
@interface PSPDFMailCoordinator : PSPDFDocumentSharingCoordinator <MFMailComposeViewControllerDelegate>

/**
 Control what data is sent. Defaults to `PSPDFDocumentSharingOptionCurrentPageOnly|PSPDFDocumentSharingOptionAllPages|PSPDFDocumentSharingOptionEmbedAnnotations|PSPDFDocumentSharingOptionFlattenAnnotations|PSPDFDocumentSharingOptionAnnotationsSummary|PSPDFDocumentSharingOptionOfferMergeFiles`.

 If only one option is set here, no menu will be displayed.

 @note Mobile Mail/Mobile Safari in most cases does not display annotations if they are not flattened.
 (This is a technical limitation and Apple added partial but mostly incomplete support since iOS 7)
 */
@property (nonatomic, assign) PSPDFDocumentSharingOptions sharingOptions;

@end

@interface PSPDFMailCoordinator (SubclassingHooks)

// Keeps a reference to the mail compose view controller, if visible.
@property (nonatomic, weak, readonly) MFMailComposeViewController *mailComposeViewController;

@end
