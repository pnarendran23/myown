//
//  PSPDFThumbnailViewController.h
//  PSPDFKit
//
//  Copyright (c) 2013-2015 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFBaseViewController.h"
#import "PSPDFSegmentedControl.h"
#import "PSPDFDocument.h"
#import "PSPDFPresentationContext.h"

@class PSPDFThumbnailViewController, PSPDFThumbnailGridViewCell, PSPDFCenteredLabelView;

// Subclass to enable `UIAppearance` rules on the filter.
@interface PSPDFThumbnailFilterSegmentedControl : PSPDFSegmentedControl @end

/// Show all thumbnails.
extern NSString *const PSPDFThumbnailViewFilterShowAll;

/// Show bookmarked thumbnails.
extern NSString *const PSPDFThumbnailViewFilterBookmarks;

/// All annotation types except links. Requires the `PSPDFFeatureMaskAnnotationEditing` feature flag.
extern NSString *const PSPDFThumbnailViewFilterAnnotations;

/// Delegate for thumbnail actions.
@protocol PSPDFThumbnailViewControllerDelegate <NSObject>

@optional

/// A thumbnail has been selected.
- (void)thumbnailViewController:(PSPDFThumbnailViewController *)thumbnailViewController didSelectPage:(NSUInteger)page inDocument:(PSPDFDocument *)document;

@end

/// The thumbnail view controller.
@interface PSPDFThumbnailViewController : UICollectionViewController <UICollectionViewDataSource, UICollectionViewDelegate>

/// Designated initializer.
/// @param layout The layout to use when loading the collection view.
/// If `nil`, this defaults to an instance of PSPDFThumbnailFlowLayout.
- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout NS_DESIGNATED_INITIALIZER;

/// Convenience initializer. Initializes the controller with the default layout and stores the document without any side-effects.
- (instancetype)initWithDocument:(PSPDFDocument *)document;

/// The collection view used for the thumbnails.
@property (nonatomic, strong) UICollectionView *collectionView;

/// Current displayed document.
@property (nonatomic, strong) PSPDFDocument *document;

/// Data source to get double page mode.
@property (nonatomic, weak) id <PSPDFPresentationContext> dataSource;

/// Delegate for the thumbnail controller.
@property (nonatomic, weak) IBOutlet id<PSPDFThumbnailViewControllerDelegate> delegate;

/// Get the cell for certain page. Compensates against open filters.
/// @note `document` is ignored in the default implementation.
- (UICollectionViewCell *)cellForPage:(NSUInteger)page document:(PSPDFDocument *)document;

/// Scrolls to specified page in the grid.
/// @note `document` is ignored in the default implementation.
- (void)scrollToPage:(NSUInteger)page document:(PSPDFDocument *)document animated:(BOOL)animated;

/// Stops an ongoing scroll animation.
- (void)stopScrolling;

/// Call to update any filter (if set) all visible cells (e.g. to show bookmark changes)
- (void)updateFilterAndVisibleCellsAnimated:(BOOL)animated;

/// Adjusts the contentInset and scrollIndicatorInsets of the collectionView based on a bar that overlaps it by the specified height.
- (void)updateInsetsForTopOverlapHeight:(CGFloat)overlapHeight;

/// Should the thumbnails be displayed in a fixed grid, or dynamically adapt to different page sizes?
/// Defaults to YES. Most documents will look better when this is set to NO.
@property (nonatomic, assign) BOOL fixedItemSizeEnabled;

/// Makes the filter bar sticky. Defaults to NO.
@property (nonatomic, assign) BOOL stickyHeaderEnabled;

/// Defines the filter options. Set to nil or empty to hide the filter bar.
/// Defaults to `PSPDFThumbnailViewFilterShowAll, PSPDFThumbnailViewFilterAnnotations, PSPDFThumbnailViewFilterBookmarks`.
@property (nonatomic, copy) NSArray *filterOptions;

/// Currently active filter. Make sure that one is also set in `filterOptions`.
@property (nonatomic, copy) NSString *activeFilter;
- (void)setActiveFilter:(NSString *)activeFilter animated:(BOOL)animated;

/// Class used for thumbnails (defaults to `PSPDFThumbnailGridViewCell`)
/// @warning Will be ignored if the layout is not a flow layout or a subclass thereof.
@property (nonatomic, strong) Class thumbnailCellClass;

@end

@interface PSPDFThumbnailViewController (SubclassingHooks)

// Subclass to customize thumbnail cell configuration.
- (void)configureCell:(PSPDFThumbnailGridViewCell *)cell forIndexPath:(NSIndexPath *)indexPath;

// Returns the page for the `indexPath`. Override if you structure the cells differently.
- (NSUInteger)pageForIndexPath:(NSIndexPath *)indexPath;

// The filter segment to filter bookmarked/annotated documents.
@property (nonatomic, strong, readonly) PSPDFThumbnailFilterSegmentedControl *filterSegment;

// The filter segment is recreated on changes; to customize subclass this class and override `updateFilterSegment`.
- (void)updateFilterSegment;

// Used to filter the document pages. Customize to tweak page display (e.g. add sorting when in bookmark mode)
- (NSArray *)pagesForFilter:(NSString *)filter;

// Return label when there's no content for the filter.
- (NSString *)emptyContentLabelForFilter:(NSString *)filter;

// Updates the empty view.
- (void)updateEmptyView;

@end
