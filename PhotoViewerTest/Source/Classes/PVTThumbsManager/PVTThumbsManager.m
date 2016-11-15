//
//  PVTThumbsManager.m
//  PhotoViewerTest
//
//  Created by Andrii Mykhailov on 11/15/16.
//  Copyright © 2016 Andrii Mykhailov. All rights reserved.
//

#import "PVTThumbsManager.h"
#import "PVTImagePresentation.h"

static const float kMaxThumbHeight = 300;

@interface PVTThumbsManager ()
@property (nonatomic, strong)           NSMutableDictionary    *thumbsStorage;

@end

@implementation PVTThumbsManager

#pragma mark -
#pragma mark Public methods

- (NSImage *)thumbnailImageForPresentation:(PVTImagePresentation *)presentation {
    NSURL *key = presentation.imagePath;
    NSImage *thumb = [self.thumbsStorage objectForKey:key];
    if (!thumb) {
        thumb = [self thumbnailImageFromPresentation:presentation];
        [self.thumbsStorage setObject:thumb forKey:key];
    }
    
    return thumb;
}

#pragma mark -
#pragma mark Private

- (NSImage *)thumbnailImageFromPresentation:(PVTImagePresentation *)presentation {
    float thumbScale = kMaxThumbHeight / presentation.height;
    NSSize thumbSize = NSMakeSize(presentation.width * thumbScale, presentation.height * thumbScale);
    
    CFURLRef cfurl = (__bridge CFURLRef)presentation.imagePath;
    CGImageSourceRef sourceRef = CGImageSourceCreateWithURL(cfurl, nil);
    NSDictionary *options = @{(__bridge NSString*)kCGImageSourceThumbnailMaxPixelSize : @(MAX(thumbSize.width, thumbSize.height)),
                              (__bridge NSString*)kCGImageSourceCreateThumbnailFromImageIfAbsent: @(YES)};
    
    CFDictionaryRef optionsRef = (__bridge CFDictionaryRef)options;
    CGImageRef result =  CGImageSourceCreateThumbnailAtIndex(sourceRef, 0, optionsRef);
    
    NSImage *image = [[NSImage alloc] initWithCGImage:result size:thumbSize];
    
    return image;
}

@end
