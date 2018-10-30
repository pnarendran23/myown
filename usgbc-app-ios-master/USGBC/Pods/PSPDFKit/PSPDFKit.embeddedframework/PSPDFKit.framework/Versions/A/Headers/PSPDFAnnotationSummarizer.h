//
//  PSPDFAnnotationSummarizer.h
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

@class PSPDFDocument;

/// Generates an annotation summary.
@interface PSPDFAnnotationSummarizer : NSObject

/// Initialize the annotation summarizer with a document.
/// @note Will return nil if document is nil.
- (instancetype)initWithDocument:(PSPDFDocument *)document NS_DESIGNATED_INITIALIZER;

/// The attached document. Can not be nil.
@property (nonatomic, strong, readonly) PSPDFDocument *document;

/// Generates an annotation summary for all `pages` in the current set document.
- (NSAttributedString *)annotationSummaryForPages:(NSIndexSet *)pages;

@end
