//
//  PSPDFDocumentActionExecutor.h`
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
#import "PSPDFDocumentSharingCoordinator.h"
#import "PSPDFControlDelegate.h"

@class PSPDFDocument, PSPDFDocumentActionExecutor;

@protocol PSPDFDocumentActionExecutorDelegate <NSObject>

@optional

// Allows to fetch defaults for actions.
- (NSDictionary *)documentActionExecutor:(PSPDFDocumentActionExecutor *)documentActionExecutor defaultOptionsForAction:(NSString *)action;

@end

// Keys for `options`

/// Customize the sharing options. The default options will be used if not set.
extern NSString *const PSPDFDocumentActionSharingOptionsKey;

/// Allows to customize the page range. By default all pages are used. Expects an `NSOrderedSet`.
extern NSString *const PSPDFDocumentActionVisiblePagesKey;


// Available actions

/// Presents the `UIPrintInteractionController`.
extern NSString *const PSPDFDocumentActionPrint;

/// Presents the `MFMailComposeViewController`.
extern NSString *const PSPDFDocumentActionEmail;

/// Presents the `UIDocumentInteractionController`.
extern NSString *const PSPDFDocumentActionOpenIn;

/// Presents the `MFMessageComposeViewController`.
extern NSString *const PSPDFDocumentActionMessage;


/// Helper class that can invoke common actions on the document.
@interface PSPDFDocumentActionExecutor : NSObject <PSPDFDocumentSharingCoordinatorDelegate>

/// Initialize with the controller we should present on.
/// Requires the controller to implement the `<PSPDFPresentationActions>` protocol to have additional control over presentation options.
/// @warning Will return nil if `presentationController` is nil.
- (instancetype)initWithPresentationController:(UIViewController <PSPDFPresentationActions> *)presentationController;

/// The attached presentation controller. Weakly held. If this is nil, actions will no longer work.
@property (nonatomic, weak, readonly) UIViewController <PSPDFPresentationActions> *presentationController;

/// Delegate to forward errors and also fetch the currently visible pages.
@property (nonatomic, weak) id <PSPDFDocumentActionExecutorDelegate, PSPDFErrorHandler> delegate;

/// The attached document this class operates on.
@property (nonatomic, strong) PSPDFDocument *document;

/// Checks if `action` can be called. Returns NO on unknown actions, asserts if action is nil.
- (BOOL)canExecuteAction:(NSString *)action;

/// Executs `action` with `options` (optional). `sender` is optional as well.
/// Asserts if action is nil; will NOP if action is unkown.
- (void)executeAction:(NSString *)action options:(NSDictionary *)options sender:(id)sender animated:(BOOL)animated completion:(void (^)(void))completion;

@end
