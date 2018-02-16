//
//  PSPDFLibrary.h
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

@class PSPDFDocument, PSPDFLibrary, PSPDFTextParser;

// The library version.
extern NSUInteger const PSPDFLibraryVersion;

// `PSPDFLibrary` uses `NSNotifications` to post status updates.
extern NSString *const PSPDFLibraryWillStartIndexingDocumentNotification;
extern NSString *const PSPDFLibraryDidFinishIndexingDocumentNotification;
extern NSString *const PSPDFLibraryDidFailIndexingDocumentNotification;

typedef NS_ENUM(NSUInteger, PSPDFLibraryIndexStatus) {
    PSPDFLibraryIndexStatusUnknown, // Not in library
    PSPDFLibraryIndexStatusQueued,
    PSPDFLibraryIndexStatusPartial,
    PSPDFLibraryIndexStatusPartialAndIndexing,
    PSPDFLibraryIndexStatusFinished
};

/// `PSPDFLibrary` implements a sqlite-based full-text-search engine.
/// You can register documents to be indexed in the background and then search for keywords within that collection.
/// There can be multiple libraries, although usually one is enough for the common use case.
/// See https://github.com/PSPDFKit/PSPDFKit-Demo/wiki/Full-text-document-search for further documentation.
/// @note Requires the `PSPDFFeatureMaskIndexedFTS` feature flag.
@interface PSPDFLibrary : NSObject

/// @name Initialization

/// Returns a library for this given path.
/// If no instance for this path exists yet, this method will create and return one. All subsequent calls
/// will return the same instance. Hence there will only be one instance per path.
/// This method will return `nil` for invalid paths.
+ (instancetype)libraryWithPath:(NSString *)path;

/// @name Properties

/// Path to the current database.
@property (nonatomic, copy, readonly) NSString *path;

/// This property customizes what tokenizer should be used. Defaults to the 'unicode61' tokenizer.
/// The UNICODE61 tokenizer allows searching inside text with diacritics. http://swwritings.com/post/2013-05-04-diacritics-and-fts
/// Sadly, Apple doesn't ship this tokenizer with their sqlite builds. PSPDFKit will detect custom versions of sqlite and use the 'unicode61' tokenizer whenever possible, falling back to the default ("simple") tokenizer if not. For the default tokenizer PSPDFKit will utilize CFStringTransform() to strip combining marks and improve searchability. This is slower and modifies the content, compared to the unicode61 tokenizer. If your content only contains English language, it might not make a difference what tokenizer you are using.
/// Read more about this at https://github.com/PSPDFKit/PSPDFKit-Demo/wiki/How-to-enable-the-unicode61-tokenizer
/// @warning Once the database is created, changing the `tokenizer` property won't have any effect.
@property (nonatomic, copy) NSString *tokenizer;

/// Will save fonts and glyph position data as well. Defaults to NO.
/// @note If enabled, the sqlite cache will be about 10x bigger than with simple text indexing, but subsequent searches will be faster.
@property (atomic, assign) BOOL saveGlyphPositions;

/// Will save a reversed copy of the original page text. Defaults to YES.
/// @note If enabled, the sqlite cache will be about 2x bigger, but ends-with matches will be enabled.
@property (atomic, assign) BOOL saveReversedPageText;

/// @name Library Operations

// Option keys. Allows to limit the number of document results.
extern NSString *const PSPDFLibraryMaximumSearchResultsTotalKey;
extern NSString *const PSPDFLibraryMaximumSearchResultsPerDocumentKey;

// Set this to @YES to restrict search to exact word matches instead of beginsWith/endsWith checks.
extern NSString *const PSPDFLibraryMatchExactWordsOnlyKey;

// Set this to @YES to restrict search to exact phrase matches. This means that "Lorem ipsum dolor"
// only matches that phrase and not something like "Lorem sit ipsum dolor".
extern NSString *const PSPDFLibraryMatchExactPhrasesOnlyKey;

// Customizes the range of the preview string. Defaults to 20/160.
extern NSString *const PSPDFLibraryPreviewRangeKey;

/// See `documentUIDsMatchingString:options:completionHandler:previewTextHandler:`.
- (void)documentUIDsMatchingString:(NSString *)searchString options:(NSDictionary *)options completionHandler:(void (^)(NSString *searchString, NSDictionary *resultSet))completionHandler;

/// Query the database for a match of `searchString`. Only direct matches, begins-with and ends-with matches are supported.
/// Returns a dictionary of UID->`NSIndexSet` of page numbers in the `completionHandler`.
/// If you provide an optional `previewTextHandler`, a text preview for all search results will be
/// extracted from the matching documents and a dictionary of UID->`NSSet` of `PSPDFSearchResult`s will
/// be returned in the `previewTextHandler`.
/// @note `previewTextHandler` is optional.
/// @note Ends-with matches are only possible if `saveReversedPageText` has been YES while the document was indexed.
/// @note You can store additional metadata for an indexed document. To do so, simply enqueue documents
/// with a set `libraryMetadata` dictionary. You can then query the metadata information by using the
/// `-metadataForUID:` method.
/// @warning The completion handler might be called on a different thread.
- (void)documentUIDsMatchingString:(NSString *)searchString options:(NSDictionary *)options completionHandler:(void (^)(NSString *searchString, NSDictionary *resultSet))completionHandler previewTextHandler:(void (^)(NSString *searchString, NSDictionary *resultSet))previewTextHandler;

/// @name Index Status

/// Returns indexing status. If status is `PSPDFLibraryIndexStatusPartialAndIndexing` progress will be set as well.
- (PSPDFLibraryIndexStatus)indexStatusForUID:(NSString *)UID withProgress:(CGFloat *)outProgress;

/// Returns YES if library is currently indexing.
- (BOOL)isIndexing;

/// Returns all queued and indexing UIDs.
- (NSOrderedSet *)queuedUIDs;

/// Returns the stored metadata for a previously enqueued document UID. If no metadata has been stored,
/// this method will return `nil`.
- (NSDictionary *)metadataForUID:(NSString *)UID;

/// @name Queue Operations

/// Queue an array of `PSPDFDocument` objects for indexing.
/// @note Documents that are already queued or completely indexed will be ignored.
- (void)enqueueDocuments:(NSArray *)documents;

/// Invalidates the search index for `UID`.
- (void)removeIndexForUID:(NSString *)UID;

/// Clear all database objects. Will clear ALL content in `path`.
- (void)clearAllIndexes;

/// Cancels all pending preview text operations.
/// @note The `previewTextHandler` of cancelled operations will not be called.
- (void)cancelAllPreviewTextOperations;

@end

/// This category allows you to encrypt the database file of your `PSPDFLibrary` instances.
/// To use this functionality, you need third-party software that implement the `sqlite3_key`
/// and `sqlite3_rekey` functions. An example for this is SQLCipher: https://www.zetetic.net/sqlcipher/
/// Information on the necessary configuration and setup can be found here:
/// https://www.zetetic.net/sqlcipher/sqlcipher-binaries-ios-and-osx/
/// You also need to enable encryption support. To do this, provide register an encryption provider by
/// calling `-[PSPDFKit databaseEncryptionProvider:]`.
@interface PSPDFLibrary (EncryptionSupport)

/// Returns an encrypted library for this given path. The `encryptionKeyProvider` is used to access
/// the encryption key when necessary. This allows us to not keep the encryption key around in memory.
/// Your implementation of encryption key provider should therefore always load the key from secure storage,
/// e.g. Apple's keychain. An encryption key provider must also be side-effect free in the sense
/// that it always returns the same encryption key on every call.
/// This method will return `nil` for invalid paths.
/// @note In contrast to `libraryWithPath:`, this method will not return the same instance when calling
/// it with an already used path.
/// @warning This method will return `nil` if the given encryption key provider was invalid.
+ (instancetype)encryptedLibraryWithPath:(NSString *)path encryptionKeyProvider:(NSData *(^)(void))encryptionKeyProvider;

/// Indicates if the library instance uses encryption.
@property (nonatomic, assign, readonly, getter=isEncrypted) BOOL encrypted;

@end
