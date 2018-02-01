//
//  PSPDFBaseTableViewController.h
//  PSPDFKit
//
//  Copyright (c) 2013-2015 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/// Defines table view separator hiding modes.
typedef NS_ENUM(NSUInteger, PSPDFSeparatorHidingMode) {
    /// Do not hide any cell separators.
    PSPDFSeparatorHidingModeNone,
    /// Hide extra cell separators below the table view.
    PSPDFSeparatorHidingModeAfterLastCell,
    /// Hide extra cell separators below the table view, including the last cell separator.
    PSPDFSeparatorHidingModeIncludingLastCell
};

/// Generic table view controller with popover resizing code.
@interface PSPDFBaseTableViewController : UITableViewController

/// If enabled, popover size is changed as items are expanded/collapsed.
/// Defaults to NO, but will most likely be set to YES in the subclass.
@property (nonatomic, assign) BOOL automaticallyResizesPopover;

/// If `automaticallyResizesPopover` is enabled, this defines the minimum height of the popover.
/// Defaults to 310.f
@property (nonatomic, assign) CGFloat minimumHeightForAutomaticallyResizingPopover;

/// By default, UIKit will show empty separator lines in plain style mode.
/// Use this to change the default behavior and hide entrain separators.
@property (nonatomic, assign) PSPDFSeparatorHidingMode separatorHidingMode;

/// Save additional properties here. Will not be used by PSPDFKit.
@property (nonatomic, copy) NSDictionary *userInfo;

@end

@interface PSPDFBaseTableViewController (SubclassingHooks)

// By default, popover size will be the tableView size.
// Usually you want to override `requiredPopoverSize` instead.
- (void)updatePopoverSize;

// Returns the required popover size. Override to customize.
- (CGSize)requiredPopoverSize;

// Called when the font system base size is changed.
- (void)contentSizeDidChange NS_REQUIRES_SUPER;

@end
