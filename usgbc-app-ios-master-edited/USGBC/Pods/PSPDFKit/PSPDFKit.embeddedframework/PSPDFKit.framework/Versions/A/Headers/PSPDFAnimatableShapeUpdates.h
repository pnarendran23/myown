//
//  PSPDFAnimatableShapeUpdates.h
//  PSPDFKit
//
//  Copyright (c) 2015 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <Foundation/Foundation.h>

// Adds the ability to animate CALayers changes (mainly for auto-rotation support)
@protocol PSPDFAnimatableShapeUpdates <NSObject>

// Animate changes (enable before rotation, disable afterwards)
@property (nonatomic, assign) BOOL animateShapeBoundsChanges;

// The shape bound change animation (match this to the rotation duration)
@property (nonatomic, assign) NSTimeInterval shapeBoundsChangeAnimationDuration;

@end
