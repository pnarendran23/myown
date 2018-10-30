//
//  PSPDFConfiguration.h
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
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>
#import "PSPDFOverridable.h"
#import "PSPDFModel.h"
#import "PSPDFDocumentSharingViewController.h"

@protocol PSPDFSignatureStore;

/// Page Transition. Can be scrolling or something more fancy.
typedef NS_ENUM(NSUInteger, PSPDFPageTransition) {
    /// One scroll view per page.
    PSPDFPageTransitionScrollPerPage,
    /// Similar to `UIWebView`. Ignores `PSPDFPageModeDouble`.
    PSPDFPageTransitionScrollContinuous,
    /// Page curl mode, similar to iBooks. Not supported with variable sized PDFs.
    PSPDFPageTransitionCurl
};

/// Active page mode.
typedef NS_ENUM(NSUInteger, PSPDFPageMode) {
    /// Default on iPhone.
    PSPDFPageModeSingle,
    /// Always show double pages.
    PSPDFPageModeDouble,
    /// Single in portrait, double in landscape if the document's height > width. Default on iPad.
    PSPDFPageModeAutomatic
};

/// Active scrolling direction. Only relevant for scrolling page transitions.
typedef NS_ENUM(NSUInteger, PSPDFScrollDirection) {
    /// Default horizontal scrolling.
    PSPDFScrollDirectionHorizontal,
    /// Vertical scrolling.
    PSPDFScrollDirectionVertical
};

/// Current active view mode.
typedef NS_ENUM(NSUInteger, PSPDFViewMode) {
    /// Document is visible.
    PSPDFViewModeDocument,
    /// Thumbnails are visible.
    PSPDFViewModeThumbnails
};

/// Default action for PDF link annotations.
typedef NS_ENUM(NSUInteger, PSPDFLinkAction) {
    /// Link actions are ignored.
    PSPDFLinkActionNone,
    /// Link actions open an `UIAlertView`.
    PSPDFLinkActionAlertView,
    /// Link actions directly open Safari.
    PSPDFLinkActionOpenSafari,
    /// Link actions open in an inline browser (`PSPDFWebViewController`).
    PSPDFLinkActionInlineBrowser
};

/// Defines the text selection mode in `PSPDFTextSelectionView`.
/// Requires `PSPDFFeatureMaskTextSelection` to be enabled and `textSelectionEnabled` set to YES.
typedef NS_ENUM(NSUInteger, PSPDFTextSelectionMode) {
    /// Regular text selection mode is similar to Mobile Safari, using two different loupes.
    /// A word will be selected on touch up.
    PSPDFTextSelectionModeRegular,

    /// In simple selection mode, the selection behavior starts immediately on touch down.
    /// This is similar to iBooks and useful for applications where highlighting is a main feature.
    PSPDFTextSelectionModeSimple
};

/// Customize how a single page should be displayed.
typedef NS_ENUM(NSUInteger, PSPDFPageRenderingMode) {
    /// Load cached page async.
    PSPDFPageRenderingModeThumbnailThenFullPage,
    /// Load cached page async. Thumbnail only if in mem.
    PSPDFPageRenderingModeThumbnailIfInMemoryThenFullPage,
    /// Load cached page async, no upscaled thumb.
    PSPDFPageRenderingModeFullPage,
    /// Load cached page directly.
    PSPDFPageRenderingModeFullPageBlocking,
    /// Don't use cached page but thumb.
    PSPDFPageRenderingModeThumbnailThenRender,
    /// Don't use cached page nor thumb.
    PSPDFPageRenderingModeRender
};

/// Menu options when text is selected on this document.
typedef NS_OPTIONS(NSUInteger, PSPDFTextSelectionMenuAction) {
    /// Allow search from selected text.
    PSPDFTextSelectionMenuActionSearch    = 1 << 0,
    /// Offers to show "Define" on selected text.
    PSPDFTextSelectionMenuActionDefine    = 1 << 1,
    /// Offers a toggle for Wikipedia.
    PSPDFTextSelectionMenuActionWikipedia = 1 << 2,
    /// Allows text-to-speech
    PSPDFTextSelectionMenuActionSpeak     = 1 << 3,
    PSPDFTextSelectionMenuActionAll       = NSUIntegerMax
};

typedef NS_ENUM(NSUInteger, PSPDFThumbnailBarMode) {
    /// Don't show thumbnail bottom bar.
    PSPDFThumbnailBarModeNone,
    /// Show scrobble bar (like iBooks, `PSPDFScrobbleBar`)
    PSPDFThumbnailBarModeScrobbleBar,
    /// Show scrollable thumbnail bar (`PSPDFThumbnailBar`)
    PSPDFThumbnailBarModeScrollable
};

/// Thumbnail grouping setting for `PSPDFThumbnailBarModeScrollable` and the `PSPDFThumbnailViewController`.
typedef NS_ENUM(NSUInteger, PSPDFThumbnailGrouping) {
    /// Group double pages when `PSPDFPageModeDouble` is enabled
    PSPDFThumbnailGroupingAutomatic,
    /// Never group double pages for thumbnails.
    PSPDFThumbnailGroupingNever,
    /// Always group double pages for thumbnails.
    PSPDFThumbnailGroupingAlways
};

typedef NS_ENUM(NSUInteger, PSPDFHUDViewMode) {
    /// Always show the HUD.
    PSPDFHUDViewModeAlways,
    /// Show HUD on touch and first/last page.
    PSPDFHUDViewModeAutomatic,
    /// Show HUD on touch.
    PSPDFHUDViewModeAutomaticNoFirstLastPage,
    /// Never show the HUD.
    PSPDFHUDViewModeNever
};

typedef NS_ENUM(NSUInteger, PSPDFHUDViewAnimation) {
    /// Don't animate HUD appearance
    PSPDFHUDViewAnimationNone,
    /// Fade HUD in/out
    PSPDFHUDViewAnimationFade,
    /// Slide HUD.
    PSPDFHUDViewAnimationSlide
};

typedef NS_ENUM(NSUInteger, PSPDFSearchMode) {
    /// Display search results in a modal view
    PSPDFSearchModeModal,
    /// Display search results inline
    PSPDFSearchModeInline
};

typedef NS_ENUM(NSUInteger, PSPDFRenderStatusViewPosition) {
    /// Display render status view at the top
    PSPDFRenderStatusViewPositionTop,
    /// Display render status view at the center
    PSPDFRenderStatusViewPositionCentered
};

@class PSPDFConfigurationBuilder, PSPDFGalleryConfiguration;

/**
 A `PSPDFConfiguration` defines the behavior of a `PSPDFViewController`.
 It uses the builder pattern via `PSPDFConfigurationBuilder` to create an immutable copy via a block.
 */
@interface PSPDFConfiguration : PSPDFModel <PSPDFOverridable>

/// Returns a copy with the default configuration.
+ (instancetype)defaultConfiguration;

/// Returns a copy of the default configuration.
/// Provide a `builderBlock` to change the value of properties.
+ (instancetype)configurationWithBuilder:(void (^)(PSPDFConfigurationBuilder *builder))builderBlock;

/// Modifies an exisiting configuration with new changes.
- (instancetype)configurationUpdatedWithBuilder:(void (^)(PSPDFConfigurationBuilder *builder))builderBlock;


/// @name Appearance Properties

/// Set a PageMode defined in the enum. (Single/Double Pages)
/// Reloads the view, unless it is set while rotation is active. Thus, one can customize the rotation behavior with animations when set within `willAnimate:*`. Defaults to `PSPDFPageModeAutomatic` on iPad and `PSPDFPageModeSingle` on iPhone.
@property (nonatomic, assign, readonly) PSPDFPageMode pageMode;


/// Defines the page transition.
/// @warning If you change the property dynamically depending on the screen orientation, don't use `willRotateToInterfaceOrientation:` but `didRotateFromInterfaceOrientation:`, else the controller will get in an invalid state. Child view controllers get rotation events AFTER the parent view controller, so if you're changing this from a parent viewController, for PSPDFKit the rotation hasn't been completed yet, and your app will eventually crash. In that case, use a `dispatch_async(dispatch_get_main_queue(), ^{ ... });` to set. You might just want to set `updateSettingsForBoundsChangeBlock` and set your properties there.
/// @note , we enable the `automaticallyAdjustsScrollViewInsets` by default. If you don't want this behavior, subclass `reloadData` and set this property to NO.
@property (nonatomic, assign, readonly) PSPDFPageTransition pageTransition;

/// Shows first document page alone. Not relevant in `PSPDFPageModeSingle`. Defaults to NO.
@property (nonatomic, assign, getter=isDoublePageModeOnFirstPage, readonly) BOOL doublePageModeOnFirstPage;

/// Allow zooming of small documents to screen width/height. Defaults to YES.
@property (nonatomic, assign, getter=isZoomingSmallDocumentsEnabled, readonly) BOOL zoomingSmallDocumentsEnabled;

/// For Left-To-Right documents, this sets the page curl to go backwards. Defaults to NO.
/// @note Doesn't re-order document pages. There's currently no real LTR support in PSPDFKit.
@property (nonatomic, assign, getter=isPageCurlDirectionLeftToRight, readonly) BOOL pageCurlDirectionLeftToRight;

/// If true, pages are fit to screen width, not to either height or width (which one is larger - usually height.) Defaults to NO.
/// iPhone switches to yes in `willRotateToInterfaceOrientation:` - reset back to no if you don't want this.
/// @note `fitToWidthEnabled` is not supported for `PSPDFPageTransitionCurl`.
@property (nonatomic, assign, getter=isFitToWidthEnabled, readonly) BOOL fitToWidthEnabled;

/// If this is set to YES, the page remembers its vertical position if `fitToWidthEnabled` is enabled.
/// If NO, new pages will start at the page top position. Defaults to NO.
@property (nonatomic, assign, readonly) BOOL fixedVerticalPositionForFitToWidthEnabledMode;

/// Only useful for `PSPDFPageTransitionCurl`. Clips the page to its boundaries, not showing a pageCurl on empty background. Defaults to YES. Set to NO if your document is variably sized.
@property (nonatomic, assign, readonly) BOOL clipToPageBoundaries;

/// Enable/disable page shadow. Defaults NO.
@property (nonatomic, assign, getter=isShadowEnabled, readonly) BOOL shadowEnabled;

/// Set default shadowOpacity. Defaults to 0.7f.
@property (nonatomic, assign, readonly) CGFloat shadowOpacity;

/// Defaults to a dark gray color.
@property (nonatomic, strong, readonly) UIColor *backgroundColor;


/// @name Scroll View Configuration

/// Page scrolling direction. Defaults to `PSPDFScrollDirectionHorizontal`. Only relevant for scrolling page transitions.
@property (nonatomic, assign, readonly) PSPDFScrollDirection scrollDirection;

/// Automatically adjust the scroll view insets.
/// This is enabled by default and only evaluated for `PSPDFPageTransitionScrollContinuous` & `PSPDFScrollDirectionVertical`.
/// @note This is similar to `automaticallyAdjustsScrollViewInsets` but more tailored to PSPDFKit's use case.
/// @warning `UIViewController's` `automaticallyAdjustsScrollViewInsets` will always be disabled. Don't enable this property.
@property (nonatomic, assign, readonly) BOOL shouldAutomaticallyAdjustScrollViewInsets;

/// Always bounces pages in the set scroll direction.
/// Defaults to NO. If set, pages with only one page will still bounce left/right or up/down instead of being fixed. Corresponds to `UIScrollView's` `alwaysBounceHorizontal` or `alwaysBounceVertical` of the pagingScrollView.
/// @note Only valid for `PSPDFPageTransitionScrollPerPage` or `PSPDFPageTransitionScrollContinuous`.
@property (nonatomic, assign, readonly) BOOL alwaysBouncePages;

/// Controls if the scroll indicators are displayed. Defaults to YES.
/// @note Indicators are displayed for page zooming in `PSPDFPageTransitionScrollPerPage` and
/// always when in `PSPDFPageTransitionScrollContinuous` mode.
@property (nonatomic, assign, readonly) BOOL showsScrollIndicators;

/// Minimum zoom scale. Defaults to 1. You usually don't want to change this.
/// @warning This might break certain pageTransitions if not set to 1.
@property (nonatomic, assign, readonly) float minimumZoomScale;

/// Maximum zoom scale for the scrollview. Defaults to 10. Set before creating the view.
@property (nonatomic, assign, readonly) float maximumZoomScale;


/// @name Page Border and Rendering

/// Set margin for document pages. Defaults to `UIEdgeInsetsZero`.
/// Margin is extra space for your (always visible) UI elements. Content will be moved accordingly.
/// Area outside margin does not receive touch events, or is shown while zooming.
/// @note You need to call `reloadData` after changing this property.
@property (nonatomic, assign, readonly) UIEdgeInsets margin;

/// Padding for document pages. Defaults to `CGSizeZero`.
/// For `PSPDFPageTransitionScrollPerPage`, padding is space that is displayed around the document. (In fact, the minimum zoom is adapted; thus you can only modify `width`/`height` here (left+right/top+bottom))
/// For `PSPDFPageTransitionScrollContinuous`, top/bottom is used to allow additional space before/after the first/last document
/// When changing padding; the touch area is still fully active.
/// @note You need to call `reloadData` after changing this property.
@property (nonatomic, assign, readonly) UIEdgeInsets padding;

/// Page padding width between single/double pages or between pages for continuous scrolling. Defaults to 20.f.
@property (nonatomic, assign, readonly) CGFloat pagePadding;

/// This manages how the PDF image cache (thumbnail, full page) is used. Defaults to `PSPDFPageRenderingModeThumbnailIfInMemoryThenFullPage`.
/// `PSPDFPageRenderingModeFullPageBlocking` is a great option for `PSPDFPageTransitionCurl`.
/// @warning `PSPDFPageRenderingModeFullPageBlocking` will disable certain page scroll animations.
@property (nonatomic, assign, readonly) PSPDFPageRenderingMode renderingMode;

/// If YES, shows an `UIActivityIndicatorView` on the top right while page is rendering. Defaults to YES.
@property (nonatomic, assign, getter=isRenderAnimationEnabled, readonly) BOOL renderAnimationEnabled;

/// Position of render status view. Defaults to `PSPDFRenderStatusViewPositionTop`.
@property (nonatomic, assign, readonly) PSPDFRenderStatusViewPosition renderStatusViewPosition;

/// @name Page Behavior

/// If set to YES, tries to find the text blocks on the page and zooms into the tapped block.
/// NO will perform a generic zoom into the tap area. Defaults to YES.
@property (nonatomic, assign, getter=isSmartZoomEnabled, readonly) BOOL smartZoomEnabled;

/// If set to YES, automatically focuses on selected form elements. Defaults to NO.
@property (nonatomic, assign, getter=isFormElementZoomEnabled, readonly) BOOL formElementZoomEnabled;

/// Tap on begin/end of page scrolls to previous/next page. Defaults to YES.
@property (nonatomic, assign, getter=isScrollOnTapPageEndEnabled, readonly) BOOL scrollOnTapPageEndEnabled;

/// Page transition to next/prev page via `scrollOnTapPageEndEnabled` is enabled. Defaults to YES.
/// @warning Only effective if `scrollOnTapPageEndEnabled` is set to YES.
@property (nonatomic, assign, getter=isScrollOnTapPageEndAnimationEnabled, readonly) BOOL scrollOnTapPageEndAnimationEnabled;

/// Margin at which the scroll to next/previous tap should be invoked. Defaults to 60.
@property (nonatomic, assign, readonly) CGFloat scrollOnTapPageEndMargin;


/// @name Page Actions

/// Set the default link action for pressing on `PSPDFLinkAnnotations`. Default is `PSPDFLinkActionInlineBrowser`.
/// @note If modal is set in the link, this property has no effect.
@property (nonatomic, assign, readonly) PSPDFLinkAction linkAction;

/// Allows to customize other displayed menu actions when text is selected.
/// Defaults to `PSPDFTextSelectionMenuActionSearch|PSPDFTextSelectionMenuActionDefine`.
@property (nonatomic, assign, readonly) PSPDFTextSelectionMenuAction allowedMenuActions;


/// @name Features

/// Allows text selection. Defaults to YES.
/// @note Requires the `PSPDFFeatureMaskTextSelection` feature flag.
/// @warning This implies that the PDF file actually contains text glyphs. Sometimes text is represented via embedded images or vectors, in that case PSPDFKit can't select it.
@property (nonatomic, assign, getter=isTextSelectionEnabled, readonly) BOOL textSelectionEnabled;

/// Allows image selection. Defaults to NO.
/// @note Requires the `PSPDFFeatureMaskTextSelection` feature flag.
/// @warning Will only work if `textSelectionEnabled` is also set to YES. This implies that the image is not in vector format. Only supports a subset of all possible image types in PDF.
@property (nonatomic, assign, getter=isImageSelectionEnabled, readonly) BOOL imageSelectionEnabled;

/// Defines how the text is selected. Defaults to `PSPDFTextSelectionModeRegular`.
@property (nonatomic, assign, readonly) PSPDFTextSelectionMode textSelectionMode;

/// Enable to always try to snap to words when selecting text. Defaults to NO.
@property (nonatomic, assign, readonly) BOOL textSelectionShouldSnapToWord;

/// Shows a custom cell with configurable color presets in the color inspector. Defaults to YES.
/// @note For supported annotation types only (currently limited to free text annotations).
@property (nonatomic, assign, readonly) BOOL showsColorPresets;


/// @name HUD Settings

/// Manages the show/hide mode of the HUD view. Defaults to `PSPDFHUDViewModeAutomatic`.
/// @note The HUD consists of the thumbnail view at the bottom and the page/document label.
/// The visibility of the navigation bar of the parent navigation controller can be linked to the HUD via enabling `shouldHideNavigationBarWithHUD`.
/// @warning HUD will not change when changing this mode after controller is visible. Use `setHUDVisible:animated:` instead.
/// Does not affect manual calls to `setHUDVisible`.
@property (nonatomic, assign, readonly) PSPDFHUDViewMode HUDViewMode;

/// Sets the way the HUD will be animated. Defaults to `PSPDFHUDViewAnimationFade`.
@property (nonatomic, assign, readonly) PSPDFHUDViewAnimation HUDViewAnimation;

/// Enables/Disables the bottom document site position overlay.
/// Defaults to YES. Animatable. Will be added to the HUDView.
/// @note Requires a `setNeedsLayout` on `PSPDFHUDView` to update if there's no full reload.
@property (nonatomic, assign, getter=isPageLabelEnabled, readonly) BOOL pageLabelEnabled;

/// Enable/disable the top document label overlay. Defaults to YES on iPhone and NO on iPad.
/// (On iPad, there's enough space to show the title in the navigationBar)
/// @note Requires a `setNeedsLayout` on `PSPDFHUDView` to update if there's no full reload.
@property (nonatomic, assign, getter=isDocumentLabelEnabled, readonly) BOOL documentLabelEnabled;

/// Automatically hides the HUD when the user starts scrolling to different pages in the document. Defaults to YES.
@property (nonatomic, assign, readonly) BOOL shouldHideHUDOnPageChange;

/// Should show the HUD on `viewWillAppear:`, unless the HUD is disabled. Defaults to YES.
@property (nonatomic, assign, readonly) BOOL shouldShowHUDOnViewWillAppear;

/// Allow PSPDFKit to change the title of this viewController.
/// Defaults to NO on iPhone (no space) and YES on iPad.
@property (nonatomic, assign, readonly) BOOL allowToolbarTitleChange;

/// If YES, the navigation bar will be hidden when the HUD is hidden.
/// @warning If `UINavigationBar.translucent` is set to NO this won't work as expected.
@property (nonatomic, assign, readonly) BOOL shouldHideNavigationBarWithHUD;

/// If YES, the statusbar will always remain hidden (regardless of the `shouldHideStatusBarWithHUD` setting).
/// The setting is also passed on to internally created sub-controllers. Defaults to NO.
@property (nonatomic, assign, readonly) BOOL shouldHideStatusBar;

/// If YES, the status bar will be hidden when the HUD is hidden.
/// @note Needs to be set before the view is loaded.
/// @warning While you *can* set this to YES and leave `shouldHideNavigationBarWithHUD` at NO, this won't make much sense.
/// @warning If `UINavigationBar.translucent` is set to NO this won't work as expected.
@property (nonatomic, assign, readonly) BOOL shouldHideStatusBarWithHUD;


/// @name Thumbnail Settings

/// Sets the thumbnail bar mode. Defaults to `PSPDFThumbnailBarModeScrobbleBar`.
/// @note Requires a `setNeedsLayout` on `PSPDFHUDView` to update if there's no full reload.
@property (nonatomic, assign, readonly) PSPDFThumbnailBarMode thumbnailBarMode;

/// Controls the thumbnail grouping. Defaults to `PSPDFThumbnailGroupingAutomatic`
@property (nonatomic, assign, readonly) PSPDFThumbnailGrouping thumbnailGrouping;

/// Thumbnail size.
/// This will be different depending on the device idiom.
@property (nonatomic, assign, readonly) CGSize thumbnailSize;

/// Set margin for thumbnail view mode. Defaults depend on the device idiom.
/// Margin is extra space around the grid of thumbnails.
@property (nonatomic, assign, readonly) UIEdgeInsets thumbnailMargin;


/// @name Annotation Settings

/// Overlay annotations are faded in. Set global duration for this fade here. Defaults to 0.25f.
@property (nonatomic, assign, readonly) CGFloat annotationAnimationDuration;

/// If set to YES, you can group/ungroup annotations with the multi-select tool.
/// Defaults to YES.
@property (nonatomic, assign, readonly) BOOL annotationGroupingEnabled;

/// If set to YES, a long-tap that ends on a page area that is not a text/image will show a new menu to create annotations. Defaults to YES.
/// If set to NO, there's no menu displayed and the loupe is simply hidden.
/// Menu can be intercepted and customized with the `shouldShowMenuItems:atSuggestedTargetRect:forAnnotation:inRect:onPageView:` delegate. (when annotation is nil)
/// @note Requires the `PSPDFFeatureMaskAnnotationEditing` feature flag.
@property (nonatomic, assign, getter=isCreateAnnotationMenuEnabled, readonly) BOOL createAnnotationMenuEnabled;

/// Types allowed in the create annotations menu. Defaults to the most common annotation types. (strings)
/// Contains a list of `PSPDFAnnotationGroup` and `PSPDFAnnotationGroupItem` items.
/// @note There is no visual separation for different groups.
/// Types that are not listed in `editableAnnotationTypes` will be ignored.
@property (nonatomic, copy, readonly) NSArray *createAnnotationMenuGroups;

/// Enables natural drawing for ink annotations.
@property (nonatomic, assign, readonly) BOOL naturalDrawingAnnotationEnabled;

/// If YES, the annotation menu will be displayed after an annotation has been created. Defaults to NO.
@property (nonatomic, assign, readonly) BOOL showAnnotationMenuAfterCreation;

/// If YES, asks the user to specify a custom annotation username when first creating a new annotation
/// (triggered by the `PSPDFAnnotationStateManager` changing its state).
/// A default name will already be suggested based on the device name.
/// You can change the default username by setting `-[PSPDFDocument defaultAnnotationUsername]`.
/// Defaults to YES.
@property (nonatomic, assign, readonly) BOOL shouldAskForAnnotationUsername;

/// Controls if a second tap to an annotation that allows inline editing enters edit mode. Defaults to YES.
/// (The most probable candidate for this is `PSPDFFreeTextAnnotation`)
@property (nonatomic, assign, readonly) BOOL annotationEntersEditModeAfterSecondTapEnabled;

/// Scrolls to affected page during an undo/redo operation. Defaults to YES.
@property (nonatomic, assign, readonly) BOOL shouldScrollToChangedPage;


/// @name Annotation Saving

/// Controls if PSPDFKit should save at specific points, like when the app enters background or when the view controller disappears.
/// Defaults to YES. Implement `PSPDFDocumentDelegate` to be notified of those saving actions.
@property (nonatomic, assign, getter=isAutosaveEnabled, readonly) BOOL autosaveEnabled;

/// The save method will be invoked when the view controller is dismissed. This increases controller dismissal if enabled.
/// @note Make sure that you don't re-create the `PSPDFDocument` object if you enable background saving, else you might run into race conditions where the old object is still saving and the new one might load outdated/corrupted data.
/// Defaults to NO.
@property (nonatomic, assign, readonly) BOOL allowBackgroundSaving;


/// @name Search

/// Controls whether to display search results directly in a PDF, or as a list in a modal.
/// Defaults to `PSPDFSearchModeInline` on iPhone and `PSPDFSearchModeModal` on iPad.
@property (nonatomic, assign, readonly) PSPDFSearchMode searchMode;


/// @name Signatures

/// If this is set to NO, PSPDFKit will not differentiate between My Signature/Customer signature.
/// Defaults to YES.
@property (nonatomic, assign, readonly) BOOL signatureSavingEnabled;

/// If enabled, the signature feature will show a menu with a customer signature. (will not be saved)
/// Defaults to YES.
@property (nonatomic, assign, readonly) BOOL customerSignatureFeatureEnabled;

/// Enables natural drawing for signatures. Defaults to YES.
@property (nonatomic, assign, readonly) BOOL naturalSignatureDrawingEnabled;

/// The default signature store implementation.
@property (nonatomic, strong, readonly) id <PSPDFSignatureStore> signatureStore;


/// @name Sharing

/// Pre-Provided UIActivity subclasses.
extern NSString *const PSPDFActivityTypeGoToPage;
extern NSString *const PSPDFActivityTypeSearch;
extern NSString *const PSPDFActivityTypeOutline;
extern NSString *const PSPDFActivityTypeBookmarks;
extern NSString *const PSPDFActivityTypeOpenIn;

/// Used for the activity action when the `UIActivityViewController` is displayed.
/// Defaults to `PSPDFActivityTypeOpenIn, PSPDFActivityTypeBookmarks, PSPDFActivityTypeGoToPage`.
@property (nonatomic, copy, readonly) NSArray *applicationActivities;

/// Used for the activity action when the `UIActivityViewController` is displayed.
/// Defaults to `UIActivityTypeCopyToPasteboard`, `UIActivityTypeAssignToContact`,
/// `UIActivityTypePostToFacebook`, `UIActivityTypePostToTwitter`, `UIActivityTypePostToWeibo`.
@property (nonatomic, copy, readonly) NSArray *excludedActivityTypes;

/// The default sharing options for the print action.
@property (nonatomic, assign, readonly) PSPDFDocumentSharingOptions printSharingOptions;

/// The default sharing options for the open In action.
@property (nonatomic, assign, readonly) PSPDFDocumentSharingOptions openInSharingOptions;

/// The default sharing options for the email action.
@property (nonatomic, assign, readonly) PSPDFDocumentSharingOptions mailSharingOptions;

/// The default sharing options for the message action.
@property (nonatomic, assign, readonly) PSPDFDocumentSharingOptions messageSharingOptions;


/// @name Advanced Properties

/// Enable/Disable all internal gesture recognizers. Defaults to YES.
/// Can be useful if you're doing custom drawing on the `PSPDFPageView`.
@property (nonatomic, assign, readonly) BOOL internalTapGesturesEnabled;

/// Set this to true to allow this controller to access the parent `navigationBar`/`navigationController` to add custom buttons.
/// Has no effect if there's no `parentViewController`. Defaults to NO.
/// @note When using this feature, you should also implement both `childViewControllerForStatusBarHidden`
/// and `childViewControllerForStatusBarStyle` to return the `PSPDFViewController` instance that is embedded.
@property (nonatomic, assign, readonly) BOOL useParentNavigationBar;

/// If enabled, will request that all thumbnails are pre-cached in `viewDidAppear:`. Defaults to YES.
/// Set this to NO if you are not using thumbnails to improve speed.
/// @warning Does not delete any cache and doesn't change if set after the controller has been presented.
@property (nonatomic, assign, readonly) BOOL shouldCacheThumbnails;

/// @name Gallery Configuration

/// The configuration used for the gallery system. Defaults to `PSPDFGalleryConfiguration.defaultConfiguration`.
@property (nonatomic, strong, readonly) PSPDFGalleryConfiguration *galleryConfiguration;

@end


/// The configuration builder object offers all properties of `PSPDFConfiguration` in a writable version,
/// in order to build an immutable `PSPDFConfiguration` object.
@interface PSPDFConfigurationBuilder : NSObject

/// Use this to use specific subclasses instead of the default PSPDF* classes.
/// This works across the whole framework and allows you to subclass all usages of a class. For example add an entry of `PSPDFPageView.class` / `MyCustomPageView.class` to use the custom subclass. (`MyCustomPageView` must be a subclass of `PSPDFPageView`)
/// @throws an exception if the overriding class is not a subclass of the overridden class.
/// @note Only set from the main thread, before you first use the object.
/// Model objects will use the overrideClass entries from the set document instead.
- (void)overrideClass:(Class)builtinClass withClass:(Class)subclass;

@property (nonatomic, assign) UIEdgeInsets margin;
@property (nonatomic, assign) UIEdgeInsets padding;
@property (nonatomic, assign) CGFloat pagePadding;
@property (nonatomic, assign) PSPDFPageRenderingMode renderingMode;
@property (nonatomic, assign, getter=isSmartZoomEnabled) BOOL smartZoomEnabled;
@property (nonatomic, assign, getter=isFormElementZoomEnabled) BOOL formElementZoomEnabled;
@property (nonatomic, assign, getter=isScrollOnTapPageEndEnabled) BOOL scrollOnTapPageEndEnabled;
@property (nonatomic, assign, getter=isScrollOnTapPageEndAnimationEnabled) BOOL scrollOnTapPageEndAnimationEnabled;
@property (nonatomic, assign) CGFloat scrollOnTapPageEndMargin;
@property (nonatomic, assign, getter=isTextSelectionEnabled) BOOL textSelectionEnabled;
@property (nonatomic, assign, getter=isImageSelectionEnabled) BOOL imageSelectionEnabled;
@property (nonatomic, assign) PSPDFTextSelectionMode textSelectionMode;
@property (nonatomic, assign) BOOL textSelectionShouldSnapToWord;
@property (nonatomic, assign) BOOL showsColorPresets;
@property (nonatomic, assign) BOOL internalTapGesturesEnabled;
@property (nonatomic, assign) BOOL useParentNavigationBar;
@property (nonatomic, assign) BOOL shouldRestoreNavigationBarStyle;
@property (nonatomic, assign) PSPDFLinkAction linkAction;
@property (nonatomic, assign) PSPDFTextSelectionMenuAction allowedMenuActions;
@property (nonatomic, assign) PSPDFHUDViewMode HUDViewMode;
@property (nonatomic, assign) PSPDFHUDViewAnimation HUDViewAnimation;
@property (nonatomic, assign) PSPDFThumbnailBarMode thumbnailBarMode;
@property (nonatomic, assign, getter=isPageLabelEnabled) BOOL pageLabelEnabled;
@property (nonatomic, assign, getter=isDocumentLabelEnabled) BOOL documentLabelEnabled;
@property (nonatomic, assign) BOOL shouldHideHUDOnPageChange;
@property (nonatomic, assign) BOOL shouldShowHUDOnViewWillAppear;
@property (nonatomic, assign) BOOL allowToolbarTitleChange;
@property (nonatomic, assign, getter=isRenderAnimationEnabled) BOOL renderAnimationEnabled;
@property (nonatomic, assign) PSPDFRenderStatusViewPosition renderStatusViewPosition;
@property (nonatomic, assign) PSPDFPageMode pageMode;
@property (nonatomic, assign) PSPDFThumbnailGrouping thumbnailGrouping;
@property (nonatomic, assign) PSPDFPageTransition pageTransition;
@property (nonatomic, assign) PSPDFScrollDirection scrollDirection;
@property (nonatomic, assign) BOOL shouldAutomaticallyAdjustScrollViewInsets;
@property (nonatomic, assign, getter=isDoublePageModeOnFirstPage) BOOL doublePageModeOnFirstPage;
@property (nonatomic, assign, getter=isZoomingSmallDocumentsEnabled) BOOL zoomingSmallDocumentsEnabled;
@property (nonatomic, assign, getter=isPageCurlDirectionLeftToRight) BOOL pageCurlDirectionLeftToRight;
@property (nonatomic, assign, getter=isFitToWidthEnabled) BOOL fitToWidthEnabled;
@property (nonatomic, assign) BOOL showsScrollIndicators;
@property (nonatomic, assign) BOOL alwaysBouncePages;
@property (nonatomic, assign) BOOL fixedVerticalPositionForFitToWidthEnabledMode;
@property (nonatomic, assign) BOOL clipToPageBoundaries;
@property (nonatomic, assign) float minimumZoomScale;
@property (nonatomic, assign) float maximumZoomScale;
@property (nonatomic, assign, getter=isShadowEnabled) BOOL shadowEnabled;
@property (nonatomic, assign) CGFloat shadowOpacity;
@property (nonatomic, assign) BOOL shouldHideNavigationBarWithHUD;
@property (nonatomic, assign) BOOL shouldHideStatusBar;
@property (nonatomic, assign) BOOL shouldHideStatusBarWithHUD;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, assign) CGSize thumbnailSize;
@property (nonatomic, assign) UIEdgeInsets thumbnailMargin;
@property (nonatomic, assign) CGFloat annotationAnimationDuration;
@property (nonatomic, assign) BOOL annotationGroupingEnabled;
@property (nonatomic, assign, getter=isCreateAnnotationMenuEnabled) BOOL createAnnotationMenuEnabled;
@property (nonatomic, copy) NSArray *createAnnotationMenuGroups;
@property (nonatomic, assign) BOOL naturalDrawingAnnotationEnabled;
@property (nonatomic, assign) BOOL showAnnotationMenuAfterCreation;
@property (nonatomic, assign) BOOL shouldAskForAnnotationUsername;
@property (nonatomic, assign) BOOL annotationEntersEditModeAfterSecondTapEnabled;
@property (nonatomic, assign, getter=isAutosaveEnabled) BOOL autosaveEnabled;
@property (nonatomic, assign) BOOL allowBackgroundSaving;
@property (nonatomic, assign) BOOL shouldCacheThumbnails;
@property (nonatomic, assign) BOOL shouldScrollToChangedPage;
@property (nonatomic, assign) PSPDFSearchMode searchMode;
@property (nonatomic, assign) BOOL signatureSavingEnabled;
@property (nonatomic, assign) BOOL customerSignatureFeatureEnabled;
@property (nonatomic, assign) BOOL naturalSignatureDrawingEnabled;
@property (nonatomic, strong) id <PSPDFSignatureStore> signatureStore;
@property (nonatomic, strong) PSPDFGalleryConfiguration *galleryConfiguration;

@property (nonatomic, copy) NSArray *applicationActivities;
@property (nonatomic, copy) NSArray *excludedActivityTypes;
@property (nonatomic, assign) PSPDFDocumentSharingOptions printSharingOptions;
@property (nonatomic, assign) PSPDFDocumentSharingOptions openInSharingOptions;
@property (nonatomic, assign) PSPDFDocumentSharingOptions mailSharingOptions;
@property (nonatomic, assign) PSPDFDocumentSharingOptions messageSharingOptions;
@end
