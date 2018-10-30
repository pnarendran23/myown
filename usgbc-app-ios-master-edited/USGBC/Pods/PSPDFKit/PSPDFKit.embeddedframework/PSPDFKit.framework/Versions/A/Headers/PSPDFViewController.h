//
//  PSPDFViewController.h
//  PSPDFKit
//
//  Copyright (c) 2011-2015 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PSPDFPresentationContext.h"
#import "PSPDFAnnotation.h"
#import "PSPDFBaseViewController.h"
#import "PSPDFTextSearch.h"
#import "PSPDFPasswordView.h"
#import "PSPDFOutlineViewController.h"
#import "PSPDFTransitionProtocol.h"
#import "PSPDFWebViewController.h"
#import "PSPDFBookmarkViewController.h"

#import "PSPDFAnnotationTableViewController.h"
#import "PSPDFSearchViewController.h"
#import "PSPDFThumbnailBar.h"
#import "PSPDFHUDView.h"
#import "PSPDFConfiguration.h"
#import "PSPDFInlineSearchManager.h"
#import "PSPDFDocumentActionExecutor.h"
#import "PSPDFActionExecutor.h"
#import "PSPDFExternalURLHandler.h"
#import <MessageUI/MessageUI.h>

@protocol PSPDFViewControllerDelegate, PSPDFAnnotationSetStore, PSPDFFormSubmissionDelegate;
@class PSPDFDocument, PSPDFScrollView, PSPDFScrobbleBar, PSPDFPageView, PSPDFRelayTouchesView, PSPDFPageViewController, PSPDFSearchResult, PSPDFViewState, PSPDFPageLabelView, PSPDFDocumentLabelView, PSPDFAnnotationViewCache, PSPDFAnnotationStateManager, PSPDFSearchHighlightViewManager, PSPDFAction, PSPDFAnnotationToolbar, PSPDFInlineSearchManager, PSPDFThumbnailViewController, PSPDFAnnotationToolbarController, PSPDFDocumentInfoCoordinator;

/**
 This is the main view controller to display PDFs. Can be displayed in full-screen or embedded. Everything in PSPDFKit is based around `PSPDFViewController`. This is the class you want to override and customize.

 Make sure to correctly use view controller containment when adding this as a child view controller. If you override this class, ensure all `UIViewController` methods you're using do call super. (e.g. `viewWillAppear:`).

 For subclassing, use `overrideClass:withClass:` to register your custom subclasses.

 The best time for setting the properties is during initialization in `commonInitWithDocument:configuration:`. Some properties require a call to `reloadData` if they are changed after the controller has been displayed. Do not set properties during a rotation phase or view appearance (e.g. use `viewDidAppear:` instead of `viewWillAppear:`) since that could corrupt internal state, instead use `updateSettingsForBoundsChangeBlock`.
*/
@interface PSPDFViewController : PSPDFBaseViewController <PSPDFPresentationContext, PSPDFControlDelegate, PSPDFOverridable, PSPDFPasswordViewDelegate, PSPDFTextSearchDelegate, PSPDFInlineSearchManagerDelegate, PSPDFActionExecutorDelegate, PSPDFErrorHandler, PSPDFExternalURLHandler, PSPDFOutlineViewControllerDelegate, PSPDFBookmarkViewControllerDelegate, PSPDFWebViewControllerDelegate , PSPDFSearchViewControllerDelegate, PSPDFAnnotationTableViewControllerDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, UIPopoverControllerDelegate>

/// @name Initialization and essential properties.

/// Initialize with a document.
/// @note Document can be nil. In this case, just the background is displayed and the HUD stays visible.
/// Also supports creation via `initWithCoder:` to allow usage in Storyboards.
- (instancetype)initWithDocument:(PSPDFDocument *)document configuration:(PSPDFConfiguration *)configuration NS_REQUIRES_SUPER NS_DESIGNATED_INITIALIZER;

/// Convenience init for `initWithDocument:configuration:` that uses a default configuration set.
- (instancetype)initWithDocument:(PSPDFDocument *)document;

/// Property for the currently displayed document.
/// @note To allow easier setup via Storyboards, this property also accepts `NSString`s. (The default bundle path will be used.)
@property (nonatomic, strong) PSPDFDocument *document;

/// Register delegate to capture events, change properties.
@property (nonatomic, weak) IBOutlet id<PSPDFViewControllerDelegate> delegate;

/// Register to be informed of and direct form submissions.
@property (nonatomic, weak) IBOutlet id<PSPDFFormSubmissionDelegate> formSubmissionDelegate;

/// Recreates the complete view hierarchy. Required for most changes in the document and for configuration changes.
- (IBAction)reloadData;


/// @name Page Scrolling

/// Set current page. Page starts at 0.
@property (nonatomic, assign) NSUInteger page;

/// If we're in double page mode, this will return the current screen page, else it's equal to page.
/// e.g. if you have 50 pages, you get 25/26 "double pages" when in double page mode.
@property (nonatomic, assign, readonly) NSUInteger screenPage;

/// Set current page, optionally animated. Page starts at 0. Returns NO if page is invalid (e.g. out of bounds).
- (BOOL)setPage:(NSUInteger)page animated:(BOOL)animated;

/// Scroll to next page. Will potentially advance two pages in dualPage mode.
- (BOOL)scrollToNextPageAnimated:(BOOL)animated;

/// Scroll to previous page. Will potentially decrease two pages in dualPage mode.
- (BOOL)scrollToPreviousPageAnimated:(BOOL)animated;

/// Enable/disable scrolling. Can be used in special cases where scrolling is turned off (temporarily). Defaults to YES.
@property (nonatomic, assign, getter=isScrollingEnabled) BOOL scrollingEnabled;

/// Locks the view. Disables scrolling, zooming and gestures that would invoke scrolling/zooming. Also blocks programmatically calls to scrollToPage. This is useful if you want to invoke a "drawing mode". (e.g. Ink Annotation drawing)
/// @warning This might be disabled after a reloadData.
@property (nonatomic, assign, getter=isViewLockEnabled) BOOL viewLockEnabled;

/// @name Zooming

/// Scrolls to a specific rect on the current page. No effect if zoom is at 1.0.
/// Note that rect are *screen* coordinates. If you want to use PDF coordinates, convert them via:
/// `PSPDFConvertPDFRectToViewRect()` or `-convertPDFPointToViewPoint:` of PSPDFPageView.
- (void)scrollRectToVisible:(CGRect)rect animated:(BOOL)animated;

/// Zooms to a specific view rect, optionally animated.
- (void)zoomToRect:(CGRect)rect page:(NSUInteger)page animated:(BOOL)animated;

/// Zoom to specific scale, optionally animated.
- (void)setZoomScale:(CGFloat)scale animated:(BOOL)animated;


/// @name View State Restoration

/// Saves the view state into a serializable object. (`page`/`zoom`/`position`/`HUD`)
@property (nonatomic, strong) PSPDFViewState *viewState;

/// Restores the view state, optionally animated. (`page`/`zoom`/`position`/`HUD`)
- (void)setViewState:(PSPDFViewState *)viewState animated:(BOOL)animated;


/// @name Searching

/// Search current page, but don't show any search UI.
extern NSString *const PSPDFViewControllerSearchHeadlessKey;

/// Searches for `searchText` within the current document.
/// Opens the `PSPDFSearchViewController`, or presents inline search UI based `searchMode` in `PSPDFConfiguration`.
/// The only valid option is `PSPDFViewControllerSearchHeadlessKey` to disable the search UI.
/// `options` are also passed through to the `presentViewController:options:animated:sender:completion:` method.
/// `sender` is used to anchor the search popover, if one should be displayed (see `searchMode` in `PSPDFConfiguration`).
- (void)searchForString:(NSString *)searchText options:(NSDictionary *)options sender:(id)sender animated:(BOOL)animated;

/// Cancels search and hides search UI.
- (void)cancelSearchAnimated:(BOOL)animated;

/// Returns YES if a search UI is currently being presented.
@property (nonatomic, assign, getter=isSearchActive, readonly) BOOL searchActive;

/// The search view manager
@property (nonatomic, strong, readonly) PSPDFSearchHighlightViewManager *searchHighlightViewManager;

/// The inline search mananger used when `PSPDFSearchModeInline` is set.
@property (nonatomic, strong, readonly) PSPDFInlineSearchManager *inlineSearchManager;

/// Text extraction class for current document.
/// The delegate is set to this controller. Don't change but create your own text search class instead if you need a different delegate.
/// @note Will be recreated as the document changes. Returns nil if the document is nil. Thread safe.
@property (nonatomic, strong, readonly) PSPDFTextSearch *textSearch;


/// @name Actions

/// Executes a PDF action.
- (BOOL)executePDFAction:(PSPDFAction *)action targetRect:(CGRect)targetRect page:(NSUInteger)page animated:(BOOL)animated actionContainer:(id)actionContainer;


/// @name HUD Controls

/// View that is displayed as HUD.
/// The `HUDView` is created in viewDidLoad.
@property (nonatomic, strong, readonly) PSPDFHUDView *HUDView;

/// Show or hide HUD controls, titlebar, status bar (depending on the appearance properties).
@property (nonatomic, assign, getter=isHUDVisible) BOOL HUDVisible;

/// Show or hide HUD controls. optionally animated.
- (BOOL)setHUDVisible:(BOOL)show animated:(BOOL)animated;

/// Show the HUD. Respects `HUDViewMode`.
- (BOOL)showControlsAnimated:(BOOL)animated;

/// Hide the HUD. Respects `HUDViewMode`.
- (BOOL)hideControlsAnimated:(BOOL)animated;

/// Hide the HUD (respects `HUDViewMode`) and additional elements like page selection.
- (BOOL)hideControlsAndPageElementsAnimated:(BOOL)animated;

/// Toggles the HUD. Respects `HUDViewMode`.
- (BOOL)toggleControlsAnimated:(BOOL)animated;

/// Content view. Use this if you want to add any always-visible UI elements.
/// Created in `viewDidLoad.` `contentView` is behind `HUDView` but always visible.
/// ContentView does NOT overlay the `navigationBar`/`statusBar`, even if that one is transparent.
@property (nonatomic, strong, readonly) PSPDFRelayTouchesView *contentView;

/// The navigationBar is animated. Check this to get the proper value,
/// even if `navigationBar.navigationBarHidden` is not yet set (but will be in the animation block)
@property (nonatomic, assign, getter=isNavigationBarHidden, readonly) BOOL navigationBarHidden;

/// Locks the current set rotation. Defaults to NO.
/// If set to false, it invokes an `attemptRotationToDeviceOrientation`.
/// @warning Rotation lock is application-global, even when the controller isn't displayed.
@property (nonatomic, assign, getter=isRotationLockEnabled) BOOL rotationLockEnabled;


/// @name Class Accessors

/// Return the pageView for a given page. Returns nil if page is not Initialized (e.g. page is not visible.)
/// Usually, using the delegates is a better idea to get the current page.
- (PSPDFPageView *)pageViewForPage:(NSUInteger)page;

/// Paging scroll view. (hosts scroll views for PDF)
/// If you want to customize this, override `reloadData` and set the properties after calling super.
@property (nonatomic, strong, readonly) UIScrollView *pagingScrollView;


/// @name Thumbnail View

/// Get or set the current view mode. (`PSPDFViewModeDocument` or `PSPDFViewModeThumbnails`)
@property (nonatomic, assign) PSPDFViewMode viewMode;

/// Set the view mode, optionally animated.
- (void)setViewMode:(PSPDFViewMode)viewMode animated:(BOOL)animated;

/// Thumbnail controller. Contains the (grid) collectionView. Lazily created.
@property (nonatomic, strong, readonly) PSPDFThumbnailViewController *thumbnailController;


/// @name Helpers

/// Return an NSNumber-Array of currently visible page numbers.
/// @warning This might return more numbers than actually visible if it's queried during a scroll animation.
- (NSOrderedSet *)visiblePages;

/// Return array of all currently visible `PSPDFPageView` objects.
- (NSArray *)visiblePageViews;

/// Depending on pageMode, this returns true if two pages are displayed.
- (BOOL)isDoublePageMode;

/// Returns YES if the document is at the last page.
- (BOOL)isLastPage;

/// Returns YES if the document is at the first page.
- (BOOL)isFirstPage;

@end


@interface PSPDFViewController (Configuration)

/// The configuration. Defaults to `+[PSPDFConfiguration defaultConfiguration]`.
/// @warning You cannot set this property to `nil` since the pdf controller must always have a configuration.
@property (nonatomic, copy, readonly) PSPDFConfiguration *configuration;

/// Allows to change any value within `PSPDFConfiguration` and correctly updates the state in the controller.
- (void)updateConfigurationWithBuilder:(void (^)(PSPDFConfigurationBuilder *builder))builderBlock;

/// Allows to update the configuration without triggering a reload.
/// @warning You should know what you're doing with using this updater.
/// The `PSPDFViewController` will not be reloaded, which can bring it into a invalid state.
/// Use this for properties that don't require reloading such as `textSelectionEnabled` or `scrollOnTapPageEndEnabled`.
- (void)updateConfigurationWithoutReloadingWithBuilder:(void (^)(PSPDFConfigurationBuilder *builder))builderBlock;

@end

// See PSPDFPresentationActions.h for compatible keys for `options`.
@interface PSPDFViewController (Presentation)

/// Show a modal view controller or a popover with automatically added close button on the left side.
/// Use sender (`UIBarButtonItem` or `UIView`) OR rect in options (both only needed for the popover)
- (id)presentViewController:(UIViewController *)controller options:(NSDictionary *)options animated:(BOOL)animated sender:(id)sender error:(NSError *__autoreleasing*)error completion:(void (^)(void))completion;

/// Dismiss popover if it matches `class`. Set class to nil to dismiss all popover types.
/// @note Will also dismiss the half modal controller.
- (BOOL)dismissPopoverAnimated:(BOOL)animated class:(Class)popoverClass completion:(void (^)(void))completion;

/// Dismisses a view controller or popover controller, if class matches.
- (void)dismissViewControllerAnimated:(BOOL)animated class:(Class)controllerClass completion:(void (^)(void))completion;

/// Saves the popoverController if currently displayed.
/// @note PSPDFKit also sometimes shows controls that internally are a popover but don't expose it, like the `UIActionSheet` or the `UIPrintInteractionController`. You can dismiss those popovers with calling `[PSPDFBarButtonItem dismissPopoverAnimated:]`.
@property (nonatomic, strong) UIPopoverController *popoverController;

/// Various objects in UIKit can present controllers without us being able to get access to it.
@property (nonatomic, strong) id<PSPDFPresentableViewController> presentedController;

/// On iPhone, some controllers are displayed "half modal" as split screen and are saved here.
@property (nonatomic, strong) UIViewController *halfModalController;

// PSPDFActionExecutorDelegate

/// Invoked when a document action wants to present a new document modally. Can be subclassed to change behavior.
- (void)presentPDFViewControllerWithDocument:(PSPDFDocument *)document options:(NSDictionary *)options sender:(id)sender animated:(BOOL)animated configurationBlock:(void (^)(PSPDFViewController *pdfController))configurationBlock completion:(void (^)(void))completion;

/// Allows file preview using QuickLook. Will call `presentPDFViewControllerWithDocument:` if the pdf filetype is detected.
- (void)presentPreviewControllerForURL:(NSURL *)fileURL title:(NSString *)title options:(NSDictionary *)options sender:(id)sender animated:(BOOL)animated completion:(void (^)(void))completion;

@end


@interface PSPDFViewController (Annotations)

/// A convenience accessor for a pre-configured, persistent, annotation state manager for the controller.
@property (nonatomic, strong, readonly) PSPDFAnnotationStateManager *annotationStateManager;

@end


@interface PSPDFViewController (Toolbar)

/// @name Toolbar button items

/// Default button in leftBarButtonItems if view is presented modally.
@property (nonatomic, strong, readonly) UIBarButtonItem *closeButtonItem;

/// Presents the `PSPDFOutlineViewController` if there is an outline defined in the PDF.
/// @note Also available as activity via `PSPDFActivityTypeOutline`.
@property (nonatomic, strong, readonly) UIBarButtonItem *outlineButtonItem;

/// Presents the `PSPDFSearchViewController` or the `PSPDFInlineSearchManager` for searching text in the current `document`.
/// @see `PSPDFSearchMode` in `PSPDFConfiguration` to configure this.
/// @note Also available as activity via `PSPDFActivityTypeSearch`.
@property (nonatomic, strong, readonly) UIBarButtonItem *searchButtonItem;

/// Toggles between the document and the thumbnail view state. (See `PSPDFViewMode` and `setViewMode:animated:`)
@property (nonatomic, strong, readonly) UIBarButtonItem *viewModeButtonItem;

/// Presents the `UIPrintInteractionController` for document printing.
/// @note Only displayed if document is allowed to be printed (see `allowsPrinting` in `PSPDFDocument`)
/// @note You should use the `activityButtonItem` instead (`UIActivityTypePrint`).
@property (nonatomic, strong, readonly) UIBarButtonItem *printButtonItem;

/// Presents the `UIDocumentInteractionController` controller to open documents in other apps.
/// @note You should use the `activityButtonItem` instead (`PSPDFActivityTypeOpenIn`).
@property (nonatomic, strong, readonly) UIBarButtonItem *openInButtonItem;

/// Presents the `MFMailComposeViewController` to send the document via email.
/// @note Will only work when sending emails is configured on the device.
/// @note You should use the `activityButtonItem` instead (`UIActivityTypeMail`).
@property (nonatomic, strong, readonly) UIBarButtonItem *emailButtonItem;

/// Presents the `MFMessageComposeViewController` to send the document via SMS/iMessage.
/// @note Will only work if iMessage or SMS is configured on the device.
/// @note You should use the `activityButtonItem` instead (`UIActivityTypeMessage`).
@property (nonatomic, strong, readonly) UIBarButtonItem *messageButtonItem;

/// Shows and hides the `PSPDFAnnotationToolbar` toolbar for creating annotations.
/// @note Requires the `PSPDFFeatureMaskAnnotationEditing` feature flag.
@property (nonatomic, strong, readonly) UIBarButtonItem *annotationButtonItem;

/// Presents the `PSPDFBookmarkViewController` for creating/editing/viewing bookmarks.
/// @note Also available as activity via `PSPDFActivityTypeBookmarks`.
@property (nonatomic, strong, readonly) UIBarButtonItem *bookmarkButtonItem;

/// Presents the `PSPDFBrightnessViewController` to control screen brightness.
/// @note iOS has a similar feature in the control center, but PSPDFKit brightness includes an additional software brightener.
@property (nonatomic, strong, readonly) UIBarButtonItem *brightnessButtonItem;

/// Presents the `UIActivityViewController` for various actions, including many of the above button items.
@property (nonatomic, strong, readonly) UIBarButtonItem *activityButtonItem;

/// Bar button items displayed at the left of the toolbar. Must be `UIBarButtonItem` instances.
/// Defaults to `[closeButtonItem]` if view is presented modally.
/// @note UIKit limits the left toolbar size if space is low in the toolbar, potentially cutting off buttons in those toolbars if the title is also too long. You can either reduce the number of buttons, cut down the text or use a `titleView` to fix this problem. It also appears that UIKit focuses on the leftToolbar, the right one is cut off much later. This problem only appears on the iPad in portrait mode. You can also use `updateSettingsForBoundsChangeBlock` to adapt the toolbar for portrait/landscape mode.
/// @warning If you use any of the provided bar button items in a custom toolbar, make sure to set `leftBarButtonItems` and `rightBarButtonItems` to nil - an `UIBarButtonItem` can only ever have one parent, else some icons might "vanish" from your toolbar.
@property (nonatomic, copy) NSArray *leftBarButtonItems;

/// Bar button items displayed at the right of the toolbar. Must be `UIBarButtonItem` or `PSPDFBarButtonItem` instances.
/// Defaults to `@[self.searchButtonItem, self.outlineButtonItem, self.viewModeButtonItem]`;
/// @warning If you use any of the provided bar button items in a custom toolbar, make sure to set `leftBarButtonItems` and `rightBarButtonItems` to nil - an `UIBarButtonItem` can only ever have one parent, else some icons might "vanish" from your toolbar.
@property (nonatomic, copy) NSArray *rightBarButtonItems;

/// Add your custom `UIBarButtonItems` so that they won't be automatically enabled/disabled.
/// @warning This needs to be set before setting `left/rightBarButtonItems`.
@property (nonatomic, copy) NSArray *barButtonItemsAlwaysEnabled;

/// Handler for all document related actions.
@property (nonatomic, strong, readonly) PSPDFDocumentActionExecutor *documentActionExecutor;

/// Handles the controllers for metadata infos (outline, annotations, bookmarks, embedded files)
@property (nonatomic, strong, readonly) PSPDFDocumentInfoCoordinator *documentInfoCoordinator;

/// Accesses and manages the annotation toolbar.
/// @note Use this instead of `visibleAnnotationToolbar`.
/// To check if the toolbar is visible, check if a window is set.
@property (nonatomic, strong, readonly) PSPDFAnnotationToolbarController *annotationToolbarController;

@end


@interface PSPDFViewController (SubclassingHooks)

/// Override this initializer to allow all use cases (storyboard loading, etc)
/// @warning Do not call this method directly, except for calling super when overriding it.
- (void)commonInitWithDocument:(PSPDFDocument *)document configuration:(PSPDFConfiguration *)configuration NS_REQUIRES_SUPER;

/// Override if you're changing the toolbar to your own.
/// The toolbar is only displayed, if `PSPDFViewController` is inside a `UINavigationController`.
- (void)updateToolbarAnimated:(BOOL)animated;

/// Called in `viewWillLayoutSubviews` and `willRotateToInterfaceOrientation:`.
- (void)setUpdateSettingsForBoundsChangeBlock:(void (^)(PSPDFViewController *pdfController))block;

/// Access internal `UIViewController` for displaying the PDF content
@property (nonatomic, strong, readonly) UIViewController<PSPDFTransitionProtocol> *pageTransitionController;

// Return rect of the content view area excluding translucent toolbar/statusbar.
// This will even return the correctly compensated statusBar if that one is currently not visible.
- (CGRect)contentRect;

// Reload a specific page.
- (void)updatePage:(NSUInteger)page animated:(BOOL)animated;

@end
