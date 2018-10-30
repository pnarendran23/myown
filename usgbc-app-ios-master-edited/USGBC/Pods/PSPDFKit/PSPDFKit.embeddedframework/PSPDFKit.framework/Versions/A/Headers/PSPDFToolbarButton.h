//
//  PSPDFToolbarButton.h
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
#import "PSPDFFlexibleToolbar.h"

typedef NS_OPTIONS(NSUInteger, PSPDFToolbarButtonControlEvents) {
    // @see UIControlEventApplicationReserved
    PSPDFControlEventTick = 1 << 24
};

/// A UIButton subclass that mimic the appearance of plain style UIBarButtonItems.
@interface PSPDFToolbarButton : UIButton

/// Styles the provided image and sets it as the button image for several button states.
- (void)setImage:(UIImage *)image;

/// Toggles the appearance between the highlighted and normal state.
- (void)styleForHighlightedState:(BOOL)highlighted;

/// General purpose user data storage.
@property (nonatomic, strong) id userInfo;

/// @name Metrics

/// Designates the button to be collapsible into one item, if toolbar space is limited.
/// Defaults to YES.
@property (nonatomic, assign, getter = isCollapsible) BOOL collapsible;

/// The fixed length value. Will become the button width or height depending on the toolbar orientation.
/// Set to -1.f to use the default toolbar length (the default).
@property (nonatomic, assign) CGFloat length;

/// Automatically sets the length to the intrinsic size width.
- (void)setLengthToFit;

/// If YES, the actual button space will be computed dynamically by counting all button instances
/// and dividing the remaining available toolbar space with that number. Otherwise the length will be
/// taken from the `length` property. Defaults to NO.
@property (nonatomic, assign, getter = isFlexible) BOOL flexible;

@end

/// Buttons that can be used as spacers for the  toolbar
/// (similar to UIBarButtonSystemItemFlexibleSpace and UIBarButtonSystemItemFixedSpace).
/// Does not allow user interaction and is not visible, but takes up space on the toolbar.
/// Use the properties described under "Metrics" form `PSPDFToolbarButton` for sizing.
@interface PSPDFToolbarSpacerButton : PSPDFToolbarButton @end

/// Sends out `PSPDFControlEventTick` events while the button is pressed.
@interface PSPDFToolbarTickerButton : PSPDFToolbarButton

/// The time interval between subsequent tick events.
@property (nonatomic) NSTimeInterval timeInterval;

/// Ignore standard control events after the ticker starts. Defaults to YES.
@property (nonatomic) BOOL ignoreEventsAfterTickerFired;

@end

/// A custom spacer button that visually separates button groups.
@interface PSPDFToolbarSeparatorButton : PSPDFToolbarSpacerButton

/// The tinted separator view.
@property (nonatomic, readonly) UIView *hairlineView;

@end

@interface PSPDFToolbarSelectableButton : PSPDFToolbarButton

/// Shows the selected state, optionally animating the change.
- (void)setSelected:(BOOL)selected animated:(BOOL)animated;

/// @name Styling

/// Selected tint color.
/// Inferred from the parent toolbar by default.
@property (nonatomic) UIColor *selectedTintColor UI_APPEARANCE_SELECTOR;

/// Selection indicator bezel color.
/// Defaults to `tintColor` (matches `tintColor` when set to nil).
@property (nonatomic) UIColor *selectedBackgroundColor UI_APPEARANCE_SELECTOR;

/// The selection view padding from the button edge.
/// Automatically set to an appropriate value for `PSPDFToolbar` when negative (default).
@property (nonatomic) CGFloat selectionPadding UI_APPEARANCE_SELECTOR;

/// If yes, a the selection indicator will be faded in when the button is highlighted.
/// Defaults to NO.
@property (nonatomic) BOOL highlightsSelection;

@end

/// PSPDFToolbarButton with a grouping disclosure indicator.
@interface PSPDFFlexibleToolbarGroupButton : PSPDFToolbarButton

/// An implicitly added gesture long press recognizer (can be used to display the group contents).
@property (nonatomic, readonly) UILongPressGestureRecognizer *longPressRecognizer;

/// The location of the disclosure indicator on the button.
@property (nonatomic) PSPDFFlexibleToolbarGroupButtonIndicatorPosition groupIndicatorPosition;

@end

/// Special `PSPDFFlexibleToolbarGroupButton` used for the collapsed button item.
@interface PSPDFFlexibleToolbarCollapsedButton : PSPDFFlexibleToolbarGroupButton

/// A button whose appearance is mimicked.
@property (nonatomic) UIButton *mimickedButton;

@end
