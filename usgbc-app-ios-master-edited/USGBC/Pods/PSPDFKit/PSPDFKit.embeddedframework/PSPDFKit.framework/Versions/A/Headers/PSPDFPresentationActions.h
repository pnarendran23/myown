//
//  PSPDFPresentationActions.h
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

typedef NS_ENUM(NSUInteger, PSPDFPresentationStyle) {
    PSPDFPresentationStyleDefault,  /// Chooses automatically.
    PSPDFPresentationStyleModal,    /// Always presents the view controller modally.
    PSPDFPresentationStyleHalfModal /// Presents the view controller in a half modal mode. (`UIUserInterfaceSizeClassCompact` only)
};

// Presentation style.
extern NSString *const PSPDFPresentationStyleKey;                  // See `PSPDFPresentationStyle`.
extern NSString *const PSPDFPresentationModalStyleKey;             // See `UIModalPresentationStyle`.

// Persistent hooks for dismissal.
extern NSString *const PSPDFPresentationWillDismissBlockKey;        // Block called when the controller is being dismissed.
extern NSString *const PSPDFPresentationDidDismissBlockKey;         // Block called when the controller has been dismissed.

// Specific for popovers:

// Target rect, if sender is nil for `UIPopoverController`.
// Needs to be relative to the view controller.
extern NSString *const PSPDFPresentationRectKey;

// A block than can be queried to get an updated version of the presentation rect.
// Used by the half modal to make sure the relevant content stays visible on screen.
extern NSString *const PSPDFPresentationRectBlockKey;

// The view in which the popover will be presented.
extern NSString *const PSPDFPresentationTargetViewKey;

// Content size for `UIPopoverController` or for `UIModalPresentationFormSheet`.
extern NSString *const PSPDFPresentationContentSizeKey;

// Customize default arrow directions for popover.
extern NSString *const PSPDFPresentationPopoverArrowDirectionsKey;

// Customize the popover click-through views.
extern NSString *const PSPDFPresentationPopoverPassthroughViewsKey;

// Navigation Controller and close button logic.
extern NSString *const PSPDFPresentationInNavigationControllerKey;  // Set to YES to embedd the controller into a navigation controller.
extern NSString *const PSPDFPresentationCloseButtonKey;             // Set to YES to add a close button.
extern NSString *const PSPDFPresentationPersistentCloseButtonKey;   // See `PSPDFPersistentCloseButtonMode`

// Allows detection if the current OS environment suports displaying native popovers.
// This will always return YES with the exception of iOS 7 / iPhone.
// (iOS allows using popovers on iPhone since iOS 8 if they are created using regular `presentViewController:` syntax)
extern BOOL PSPDFSupportsPopover(void);

@protocol PSPDFPresentableViewController <NSObject> @end
@interface UIViewController                (PSPDFPresentableViewController) <PSPDFPresentableViewController> @end
@interface UIPrintInteractionController    (PSPDFPresentableViewController) <PSPDFPresentableViewController> @end
@interface UIDocumentInteractionController (PSPDFPresentableViewController) <PSPDFPresentableViewController> @end
@interface UIActionSheet                   (PSPDFPresentableViewController) <PSPDFPresentableViewController> @end

@protocol PSPDFHostableViewController <NSObject> @end
@interface UINavigationController (PSPDFHostableViewController) <PSPDFHostableViewController> @end
@interface UIPopoverController    (PSPDFHostableViewController) <PSPDFHostableViewController> @end

// Methods to present/dismiss view controllers.
// UIViewController doesn't expose enough to conveniently present/dismiss controllers, so this protcol extends it.
@protocol PSPDFPresentationActions <NSObject>

// Presents a controller modally or in a popover, depending on the platform and options set.
- (id)presentViewController:(id<PSPDFPresentableViewController>)controller options:(NSDictionary *)options animated:(BOOL)animated sender:(id)sender error:(NSError *__autoreleasing*)error completion:(void (^)(void))completion;

// Dismiss popover/controller.
- (BOOL)dismissPopoverAnimated:(BOOL)animated class:(Class)controllerClass completion:(void (^)(void))completion;

// Dismisses a view controller or popover controller, if class matches.
- (void)dismissViewControllerAnimated:(BOOL)animated class:(Class)controllerClass completion:(void (^)(void))completion;

@optional

- (BOOL)sender:(id)sender shouldShowController:(id<PSPDFPresentableViewController>)controller embeddedInController:(id<PSPDFHostableViewController>)hostController options:(NSDictionary *)options animated:(BOOL)animated;

@end
