//
//  PSPDFThumbnailFlowLayout.h
//  PSPDFKit
//
//  Copyright (c) 2013-2015 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFPresentationContext.h"

typedef NS_ENUM(NSInteger, PSPDFThumbnailFlowLayoutAttributesType) {
    /// Marks attributes that relate to a single/standalone page.
    PSPDFThumbnailFlowLayoutAttributesTypeSingle,
    /// Marks attributes that relate to the left page in a two–page spread.
    PSPDFThumbnailFlowLayoutAttributesTypeLeft,
    /// Marks attributes that relate to the right page in a two–page spread.
    PSPDFThumbnailFlowLayoutAttributesTypeRight
};

@interface PSPDFThumbnailFlowLayoutAttributes : UICollectionViewLayoutAttributes
@property (nonatomic, assign) PSPDFThumbnailFlowLayoutAttributesType type;
@end

/**
 A flow layout with support for sticky headers and double-page spreads, as you’d use it for the thumbnails of a magazine.

 @note Although this is a subclass of UICollectionViewFlowLayout, a scrollDirection of UICollectionViewScrollDirectionHorizontal is unsupported.
 Attempting to set this value will result in unspecified behavior!
 */
@interface PSPDFThumbnailFlowLayout : UICollectionViewFlowLayout

/// @warning This property is inherited, but currently only UICollectionViewScrollDirectionVertical is supported.
/// Setting this to UICollectionViewScrollDirectionHorizontal will result in unspecified behavior.
@property (nonatomic, assign) UICollectionViewScrollDirection scrollDirection;

/// Enables sticky headers. @note Toggling this property invalidates the layout.
@property (nonatomic, assign) BOOL stickyHeaderEnabled;

/// Disables double page mode, when NO, it will just follow the `presentationContext`. Defaults to NO
@property (nonatomic, assign) BOOL doublePageModeDisabled;

/// Returns YES of the current layout is doubplePageMode
@property (nonatomic, assign, readonly) BOOL doublePageMode;

/// We use this object to figure out if we want to use the double page mode and how to use it
@property (nonatomic, weak) id <PSPDFPresentationContext> presentationContext;

/// Returns the attributes type for the specified indexPath
- (PSPDFThumbnailFlowLayoutAttributesType)typeForIndexPath:(NSIndexPath *)indexPath usingDoublePageMode:(BOOL)usingDoublePageMode;

/// Returns the indexPath for the other page in a double page, nil if the type is single
- (NSIndexPath *)indexPathForDoublePage:(NSIndexPath *)indexPath;

@end
