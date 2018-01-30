//
//  PSPDFAnnotationToolbarController.h
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
#import "PSPDFFlexibleToolbarContainer.h"

@class PSPDFAnnotationToolbar;

// Fired whenever the toolbar visibility changes.
extern NSString *const PSPDFAnnotationToolbarControllerVisibilityDidChangeNotification;

// Key inside the notification's userInfo.
extern NSString *const PSPDFAnnotationToolbarControllerVisibilityAnimatedKey;

/// Helper for showing/hiding the toolbar on a view controller.
/// Internally manages a `PSPDFFlexibleToolbarContainer`.
@interface PSPDFAnnotationToolbarController : NSObject

// Initialize with an annotation toolbar. Required.
- (instancetype)initWithAnnotationToolbar:(PSPDFAnnotationToolbar *)annotationToolbar NS_DESIGNATED_INITIALIZER;

/// Displayed annotation toolbar.
@property (nonatomic, strong, readonly) PSPDFAnnotationToolbar *annotationToolbar;

/// Returns YES whenever the toolbar is visible. If the toolbar is currently animating out, this will be already set to NO.
@property (nonatomic, assign, getter=isToolbarVisible, readonly) BOOL toolbarVisible;

/// Shows or hides the annotation toolbar (animated)
- (void)toggleToolbarAnimated:(BOOL)animated;

/// Show the annotation toolbar, if not currently visible.
/// @return Whether the toolbar was actually shown.
- (BOOL)showToolbarAnimated:(BOOL)animated;

/// Hide the annotation toolbar, if currently shown.
/// @return Whether the toolbar was actually hidden.
- (BOOL)hideToolbarAnimated:(BOOL)animated;

/// `hostView` can be nil unless it's an unusual setup.
/// `container` might be a UIBarButtonItem, or a UIView class that should host the `PSPDFAnnotationToolbarContainer`.
/// `viewController` can be nil; a hook will be installed if non-nil to auto-hide the toolbar as the controller disappears.
- (void)updateHostView:(UIView *)hostView container:(id)container viewController:(UIViewController *)viewController;

/// The host view for the `PSPDFAnnotationToolbarContainer`.
/// If set to nil (the default), the `PSPDFViewController`'s navigationController view or the containing `UIToolbar`'s or `UINavigationBar`'s superview will be used.
@property (nonatomic, strong, readonly) UIView *hostView;
@property (nonatomic, strong, readonly) UIView<PSPDFSystemBar> *hostToolbar;
@property (nonatomic, weak, readonly) UIViewController *hostViewController;

// Optional. Forwards calls from internal delegate handler.
@property (nonatomic, weak) id <PSPDFFlexibleToolbarContainerDelegate> delegate;

@end
