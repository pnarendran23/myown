//
//  PSPDFDocumentSharingViewController.h
//  PSPDFKit
//
//  Copyright (c) 2011-2015 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFStaticTableViewController.h"
#import "PSPDFStyleable.h"
#import "PSPDFOverridable.h"
#import "PSPDFProcessor.h"

@class PSPDFDocument;

typedef NS_OPTIONS(NSUInteger, PSPDFDocumentSharingOptions) {
    /// The default option. Will share all available optons via embedding annotations.
    PSPDFDocumentSharingOptionNone                        = 0,

    /// Only page set in `page` of `PSPDFViewController`.
    PSPDFDocumentSharingOptionCurrentPageOnly             = 1 << 0,
    /// All visible pages. (ignored if only one visible)
    PSPDFDocumentSharingOptionVisiblePages                = 1 << 1,
    // Send whole document.
    PSPDFDocumentSharingOptionAllPages                    = 1 << 2,

    /// Save annotations in the PDF.
    PSPDFDocumentSharingOptionEmbedAnnotations            = 1 << 3,
    /// Render annotations into the PDF.
    PSPDFDocumentSharingOptionFlattenAnnotations          = 1 << 4,
    /// Save annotations + add summary.
    PSPDFDocumentSharingOptionAnnotationsSummary          = 1 << 5,
    /// Remove all annotations.
    PSPDFDocumentSharingOptionRemoveAnnotations           = 1 << 6,

    /// Allow to choose between multiple files or merging.
    PSPDFDocumentSharingOptionOfferMergeFiles             = 1 << 8,
    /// Forces file merging.
    PSPDFDocumentSharingOptionForceMergeFiles             = 2 << 8
};

@class PSPDFDocumentSharingViewController;

/// The delegate for the `PSPDFDocumentSharingViewController`.
@protocol PSPDFDocumentSharingViewControllerDelegate <PSPDFOverridable>

/// Content has been prepared.
/// `resultingObjects` can either be `NSURL` or `NSData`.
- (void)documentSharingViewController:(PSPDFDocumentSharingViewController *)shareController didFinishWithSelectedOptions:(PSPDFDocumentSharingOptions)selectedSharingOption files:(NSArray *)files annotationSummary:(NSAttributedString *)annotationSummary error:(NSError *)error;

@optional

/// Controller has been cancelled.
- (void)documentSharingViewControllerDidCancel:(PSPDFDocumentSharingViewController *)shareController;

/// Commit button has been pressed. Defaults to YES if not implemented.
- (BOOL)documentSharingViewController:(PSPDFDocumentSharingViewController *)shareController shouldPrepareWithSelectedOptions:(PSPDFDocumentSharingOptions)selectedSharingOption selectedPages:(NSIndexSet *)selectedPages;

/// Allows to override the default title string for a specific option.
- (NSString *)documentSharingViewController:(PSPDFDocumentSharingViewController *)shareController titleForOption:(PSPDFDocumentSharingOptions)option;

/// Allows to override the default subtitle string for a specific option.
- (NSString *)documentSharingViewController:(PSPDFDocumentSharingViewController *)shareController subtitleForOption:(PSPDFDocumentSharingOptions)option;

/// Allows to return custom options for `PSPDFProcessor`, such as watermarking.
- (NSDictionary *)processorOptionsForDocumentSharingViewController:(PSPDFDocumentSharingViewController *)shareController;

/// Allows to return a custom temporary directory that is used during the export process.
- (NSString *)temporaryDirectoryForDocumentSharingViewController:(PSPDFDocumentSharingViewController *)shareController;

@end

/// Shows an interface to select the way the PDF should be exported.
/// @note Using the sharing controller will automatically save the document.
@interface PSPDFDocumentSharingViewController : PSPDFStaticTableViewController <PSPDFStyleable>

/// Initialize with a `document` and optionally `visiblePages`.
/// `completionHandler` will be called if the user selects an option. Will not be called in case of cancellation.
/// @note Will be nil if `document` is nil.
- (instancetype)initWithDocument:(PSPDFDocument *)document visiblePages:(NSOrderedSet *)visiblePages allowedSharingOptions:(PSPDFDocumentSharingOptions)sharingOptions delegate:(id <PSPDFDocumentSharingViewControllerDelegate>)delegate NS_DESIGNATED_INITIALIZER;

/// Checks if the controller has options *at all* - and simply calls the delegate if not.
/// This prevents showing the controller without any options and just a commit button.
/// Will return YES if the controller has options available, NO if the delegate has been called.
- (BOOL)checkIfControllerHasOptionsAvailableAndCallDelegateIfNot;

/// Will take the current settings and start the file crunching. Will call back on the `PSPDFDocumentSharingViewControllerDelegate` unless this returns NO.
- (BOOL)commitWithCurrentSettings;

/// The current document.
@property (nonatomic, strong, readonly) PSPDFDocument *document;

/// The currently visible page numbers. Can be nil.
/// @warning Modify before the view is loaded.
@property (nonatomic, copy) NSOrderedSet *visiblePages;

/// The active sharing option combinations, as numbers in an ordered set.
/// @warning Modify before the view is loaded.
@property (nonatomic, assign) PSPDFDocumentSharingOptions sharingOptions;

/// Allows to set the default selection. This property will change as the user changes the selection.
/// @note Make sure that `selectedOptions` does not contain any values that are missing from `sharingOptions` or multiple ones per set.
@property (nonatomic, assign) PSPDFDocumentSharingOptions selectedOptions;

/// Button title for "commit".
@property (nonatomic, copy) NSString *commitButtonTitle;

/// The document sharing controller delegate.
@property (nonatomic, weak) id <PSPDFDocumentSharingViewControllerDelegate> delegate;

// Controller is in a popover. `PSPDFStyleable` attribute.
// @warning Needs to be set before the view is initialized. (Thus, before you even set this to an UIPopoverController)
@property (nonatomic, assign) BOOL isInPopover;

@end

@interface PSPDFDocumentSharingViewController (SubclassingHooks)

// Will query the delegate for `processorOptionsForDocumentSharingViewController:`.
// Subclass this method if you want to add options to all sharing actions.
- (NSDictionary *)delegateProcessorOptions;

@end
