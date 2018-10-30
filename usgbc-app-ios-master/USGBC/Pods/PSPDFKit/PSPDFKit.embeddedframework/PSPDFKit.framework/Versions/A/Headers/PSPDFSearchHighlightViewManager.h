//
//  PSPDFSearchViewManager.h
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
#import "PSPDFOverridable.h"

@class PSPDFSearchResult;

/// The data source for the `PSPDFSearchHighlightViewManager` to coodinate animations and highlighting.
@protocol PSPDFSearchHighlightViewManagerDataSource <PSPDFOverridable>

/// Control if we should add search highlight views at all.
- (BOOL)shouldHighlightSearchResults;

/// Returns an array of PSPDFPageView objects.
- (NSArray *)visiblePageViews;

@end

/// Manages views added on `PSPDFPageView`.
@interface PSPDFSearchHighlightViewManager : NSObject

/// Designated initializer.
- (instancetype)initWithDataSource:(id<PSPDFSearchHighlightViewManagerDataSource>)dataSource NS_DESIGNATED_INITIALIZER;

/// The data source for the search highlight manager.
@property (nonatomic, weak, readonly) id<PSPDFSearchHighlightViewManagerDataSource> dataSource;

/// Returns YES if there are search results displayed on a page view.
- (BOOL)hasVisibleSearchResults;

/// Hide search results.
/// @note `animated` is currently ignored.
- (void)clearHighlightedSearchResultsAnimated:(BOOL)animated;

/// Add search results of type `PSPDFSearchResult`.
- (void)addHighlightSearchResults:(NSArray *)searchResults animated:(BOOL)animated;

/// Animate search results.
- (void)animateSearchHighlight:(PSPDFSearchResult *)searchResult;

@end
