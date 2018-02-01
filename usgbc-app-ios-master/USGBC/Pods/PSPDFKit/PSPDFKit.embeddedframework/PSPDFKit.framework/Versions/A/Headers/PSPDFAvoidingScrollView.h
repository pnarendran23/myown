//
//  PSPDFAvoidingScrollView.h
//  PSPDFKit
//
//  Copyright (c) 2011-2015 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <UIKit/UIKit.h>

/// ScrollView subclass that listens to keyboard and half modal events and moves itself up accordingly.
@interface PSPDFAvoidingScrollView : UIScrollView

/// YES if currently avoiding the keyboard or half modal.
@property (nonatomic, assign, readonly, getter=isAvoiding) BOOL avoiding;

/// YES if the keyboard is currently displayed.
/// @warning Keep in mind that there are many other ways for the keyboard. E.g. this will return NO if the keyboard is in split view mode or a physical keyboard is attached.
@property (nonatomic, assign, readonly, getter=isKeyboardVisible) BOOL keyboardVisible;

/// YES if a half modal view controller is currently visible.
@property (nonatomic, assign, readonly, getter=isHalfModalVisible) BOOL halfModalVisible;

/// Return YES if we have a first responder inside the `scrollView` that is a text input.
@property (nonatomic, assign, readonly) BOOL firstResponderIsTextInput;

/// Enable/Disable avoidance features. Defaults to YES.
/// @warning Don't change this while `isAvoiding` is YES.
@property (nonatomic, assign) BOOL enableAvoidance;

@end
