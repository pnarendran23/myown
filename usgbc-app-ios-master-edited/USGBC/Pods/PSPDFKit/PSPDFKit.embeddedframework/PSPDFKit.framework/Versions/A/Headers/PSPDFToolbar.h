//
//  PSPDFToolbar.h
//  PSPDFKit
//
//  Copyright (c) 2015 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <UIKit/UIKit.h>

/// Managed and displays an array of buttons as a toolbar.
/// Similar to UIToolbar, but operates on UIButtons directly and allows for a bit more flexibility during layout.
/// Also provides some more advanced functionality like smart automatic overflow handling.
@interface PSPDFToolbar : UIView

/// Currently set buttons. Needs to be an array of UIButton instances.
/// For best results use `PSPDFToolbarButton` and its subclasses.
/// Use `PSPDFToolbarSpacerButton` to add fixed or flexible space to the toolbar.
@property (nonatomic, copy) NSArray *buttons;

/// Sets the buttons and optionally performs a cross-fade animation between the previous and new button set.
- (void)setButtons:(NSArray *)buttons animated:(BOOL)animated;

/// @name Styling

/// A view placed behind the toolbar items.
/// Defaults to a custom view that mimics the system toolbar / navigation bars design.
@property (nonatomic, strong) UIView *backgroundView;

/// The container view for all toolbar buttons.
@property (nonatomic, strong, readonly) UIView *contentView;

/// The bar tint color. Gets passed on to the background view (setting its `barTintColor` if implemented,
/// otherwise its backgroundColor).
@property (nonatomic, strong) UIColor *barTintColor UI_APPEARANCE_SELECTOR;

/// @name Overflow handling

/// An array of buttons that have been collapsed into `collapsedButton` due to lack of toolbar space.
/// Collapsible buttons need to be `PSPDFToolbarButton` with the `collapsible` flag set to yes.
@property (nonatomic, copy, readonly) NSArray *collapsedButtons;

/// Added to the toolbar when toolbar buttons get collapsed due to lack of toolbar space.
/// @see collapsedButtons
@property (nonatomic, strong, readonly) UIButton *collapsedButton;

@end

@interface PSPDFToolbar (SubclassingHooks)

// Override to adjust the content view layout before button layout is called.
- (void)layoutMainSubviews;

// Called when the collapsed button is added or removed
- (void)setCollapsedButtonVisible:(BOOL)visible;

// The fixed toolbar dimension (height of width depending on the orientation).
// Defaults to 44.f
- (CGFloat)fixedDimension;

// Indicates if the toolbar buttons should be laid out vertically or horizontally.
// Based on the frame size by default.
- (BOOL)isHorizontal;

@end
