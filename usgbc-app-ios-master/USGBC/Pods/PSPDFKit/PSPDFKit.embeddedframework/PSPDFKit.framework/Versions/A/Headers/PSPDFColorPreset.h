//
//  PSPDFColorPreset.h
//  PSPDFKit
//
//  Copyright (c) 2015 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//
#import "PSPDFModel.h"

/// Model class used to define custom color presets.
/// @see `PSPDFStyleManager`
@interface PSPDFColorPreset : PSPDFModel

/// Creates a new preset with a `nil` `fillColor` and `alpha` set to 1.f.
+ (instancetype)presetWithColor:(UIColor *)color;

/// Creates a new custom preset.
+ (instancetype)presetWithColor:(UIColor *)color fillColor:(UIColor *)fillColor alpha:(CGFloat)alpha;

/// The primary preset color (the content color).
/// @note The color will be standardized to the RGB color space with an alpha value of 1.f
@property (nonatomic, readonly) UIColor *color;

/// The secondary preset color (fill color).
/// @note The color will be standardized to the RGB color space with an alpha value of 1.f
@property (nonatomic, readonly) UIColor *fillColor;

/// The preset alpha.
@property (nonatomic, readonly) CGFloat alpha;

@end
