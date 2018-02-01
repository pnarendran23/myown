//
//  PSPDFStyleManager.h
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
#import "PSPDFAnnotationStyle.h"
#import "PSPDFPlugin.h"

// This key will return the last used style.
extern NSString *const PSPDFStyleManagerLastUsedStylesKey;

// This key will mark styles as generic, thus they'll be returned with all other style types except the last used trait.
extern NSString *const PSPDFStyleManagerGenericStylesKey;

// Preset types
extern NSString *const PSPDFStyleManagerColorPresetKey;

/// The style manager will save UI-specific properties for annotations and apply them after creation.
/// It also offers a selection of user-defined styles.
/// There are three categories: Last used, key-specific and generic styles.
@protocol PSPDFAnnotationStyleManager <PSPDFPlugin>

/// Keeps a list of style keys we want to listen to (like `color` or `lineWidth`).
/// @note If you want to disable automatic style saving, set this to nil.
@property (atomic, copy) NSSet *styleKeys;

/// When annotations are changed and this is enabled, the defaults are updated accordingly.
/// This defaults to YES.
@property (nonatomic, assign) BOOL shouldUpdateDefaultsForAnnotationChanges;

/// Set default annotation styles.
/// This is the perfect place to set your own default annotation styles.
- (void)setupDefaultStylesIfNeeded;

/// Returns the 'last used' annotation style, a special variant that is kept per annotation string type.
/// Might return nil if there isn't anything saved yet.
- (NSArray *)stylesForKey:(NSString *)key;

/// Adds a style on the key store.
- (void)addStyle:(PSPDFAnnotationStyle *)style forKey:(NSString *)key;

/// Removes a style from the key store.
- (void)removeStyle:(PSPDFAnnotationStyle *)style forKey:(NSString *)key;

/// @name Convenience Helpers

/// Get the last used style for `key`.
- (PSPDFAnnotationStyle *)lastUsedStyleForKey:(NSString *)key;

/// Convenience method. Will fetch the last used style for `key` and fetches the styleProperty for it. Might return nil.
- (id)lastUsedProperty:(NSString *)styleProperty forKey:(NSString *)key;

/// Convenience method. Will set the last used style for `key` and `styleProperty`.
/// `value` might be a boxed CGFloat, color or whatever matches the property.
/// `styleProperty` is the NSString-name for the property (e.g. `NSStringFromSelector(@ selector(fontSize))`
/// `key` is the annotation key, e.g. PSPDFAnnotationStringFreeText.
- (void)setLastUsedValue:(id)value forProperty:(NSString *)styleProperty forKey:(NSString *)key;

/// @name Presets

/// Returns default presets for a given `key` and `type`. Override to customize.
/// @see presetsForKey:type:
/// @note The implementation should be thread safe.
- (NSArray *)defaultPresetsForKey:(NSString *)key type:(NSString *)type;

/// Get the color presets for a specified key and preset type.
/// Returns and array of objects corresponding to the preset type (e.g, `PSPDFColorPreset`).
/// @property key The annotation key, e.g. PSPDFAnnotationStringFreeText.
/// @property type The preset type, e.g. PSPDFStyleManagerColorPresetKey (see PSPDFStyleManager.h).
- (NSArray *)presetsForKey:(NSString *)key type:(NSString *)type;

/// Updates the presets for the specified key and preset type.
/// @property presets An array of presets to save. They object must conform to `NSCoding`. Setting nil removes the presets from storage and reverts to the default presets (if set). 
/// @property key The annotation key, e.g. PSPDFAnnotationStringFreeText.
/// @property type The preset type, e.g. PSPDFStyleManagerColorPresetKey (see PSPDFStyleManager.h).
- (void)setPresets:(NSArray *)presets forKey:(NSString *)key type:(NSString *)type;

@end

// The default implementation for the style manager.
@interface PSPDFDefaultAnnotationStyleManager : NSObject <PSPDFAnnotationStyleManager>
@end
