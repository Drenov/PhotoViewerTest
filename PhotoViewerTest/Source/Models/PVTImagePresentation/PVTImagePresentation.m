//
//  PVTImagePresentation.m
//  PhotoViewerTest
//
//  Created by Andrii Mykhailov on 11/14/16.
//  Copyright © 2016 Andrii Mykhailov. All rights reserved.
//

#import "PVTImagePresentation.h"
#import "NSURL+PVTExtensions.h"

@implementation PVTImagePresentation

#pragma mark -
#pragma mark Overriden Methods

- (BOOL)isEqualToPresentation:(PVTImagePresentation *)presentation {
    if (!presentation) {
        return NO;
    }
    
    BOOL hasEqualPath = (!self.imagePath && !presentation.imagePath) || [self.imagePath isEqualToURL:presentation.imagePath];
    
    return hasEqualPath;
}

- (NSUInteger)hash {
    return self.imagePath.hash;
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[self class]]) {
        return NO;
    }
    
    return [self isEqualToPresentation:object];
}

@end
