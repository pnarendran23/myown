//
//  PSPDFDocumentSharingCoordinator.h
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
#import "PSPDFDocumentSharingViewController.h"
#import "PSPDFOverridable.h"
#import "PSPDFPresentationActions.h"
#import "PSPDFApplicationPolicy.h"
#import "PSPDFFileManager.h"

@class PSPDFDocument, PSPDFDocumentSharingCoordinator;
@protocol PSPDFApplicationPolicy;

@protocol PSPDFDocumentSharingCoordinatorDelegate <PSPDFOverridable>

- (void)documentSharingCoordinator:(PSPDFDocumentSharingCoordinator *)coordinator didFailWithError:(NSError *)error;

@end

/// A document sharing coordinator represents a document action.
/// This is an abstract class - see concrete implementations such as `PSPDFMailCoordinator` or `PSPDFPrintCoordinator`.
@interface PSPDFDocumentSharingCoordinator : NSObject <PSPDFDocumentSharingViewControllerDelegate>

// Initialize with a document.
- (instancetype)initWithDocument:(PSPDFDocument *)document NS_DESIGNATED_INITIALIZER;

/// The document this coordinator operates on.
@property (nonatomic, strong, readonly) PSPDFDocument *document;

/// Pages that should be offered for the sharing. (`NSNumber`s)
@property (nonatomic, copy) NSOrderedSet *visiblePages;

/// Attached delegate.
@property (nonatomic, weak) id <PSPDFDocumentSharingCoordinatorDelegate> delegate;

/// Defines what sharing options should be displayed.
@property (nonatomic, assign) PSPDFDocumentSharingOptions sharingOptions;

/// Allows to check if the action can be performed.
@property (nonatomic, assign, getter=isAvailable, readonly) BOOL available;

/// Indicates that a background operation is running.
@property (atomic, assign, getter=isExecuting, readonly) BOOL executing;

/// Presents the view controller to `targetController`.
/// @note Might work on a background thread to crunch the document before presenting the final view controller.
- (id)presentToViewController:(UIViewController <PSPDFPresentationActions> *)targetController options:(NSDictionary *)options sender:(id)sender animated:(BOOL)animated completion:(void (^)(void))completion;

@end

@interface PSPDFDocumentSharingCoordinator (SubclassingHooks)

// Title and action button are different for each subclass.
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString *commitButtonTitle;
@property (nonatomic, copy, readonly) NSString *policyEvent;

// Subclass to add custom checks.
- (BOOL)isAvailableUserInvoked:(BOOL)userInvoked;

// Hook to customize the sharing controller.
- (BOOL)configureSharingController:(PSPDFDocumentSharingViewController *)sharingController NS_REQUIRES_SUPER;

@property (nonatomic, strong, readonly) PSPDFDocumentSharingViewController *sharingController;

- (void)showActionControllerToViewController:(UIViewController <PSPDFPresentationActions> *)targetController sender:(id)sender sendOptions:(PSPDFDocumentSharingOptions)sendOptions files:(NSArray *)files annotationSummary:(NSAttributedString *)annotationSummary animated:(BOOL)animated;

@end

@interface PSPDFDocumentSharingCoordinator (Dependencies)

@property (nonatomic, strong) id<PSPDFApplicationPolicy> policy;
@property (nonatomic, strong) id<PSPDFFileManager> fileManager;

@end
