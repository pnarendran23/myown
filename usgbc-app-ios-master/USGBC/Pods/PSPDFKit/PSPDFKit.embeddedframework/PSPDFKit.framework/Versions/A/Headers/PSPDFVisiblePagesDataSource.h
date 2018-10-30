//
//  PSPDFVisiblePagesDataSource.h
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

/// Defines what page(s) are currently visible.
@protocol PSPDFVisiblePagesDataSource <NSObject>

/// The page that fills the majority of the screen.
@property (nonatomic, assign, readonly) NSUInteger page;

/// All visible page numbers (wrapped as NSNumbers)
- (NSOrderedSet *)visiblePages;

// Visible page numbers, calculated. This only includes the second page in double page mode.
// The main difference to `visiblePages` is that e.g. in continuous scroll mode, it only returns one page.
- (NSOrderedSet *)visiblePagesCalculated;

@end
