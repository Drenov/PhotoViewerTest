//
//  PVTThumbsManager.h
//  PhotoViewerTest
//
//  Created by Andrii Mykhailov on 11/15/16.
//  Copyright © 2016 Andrii Mykhailov. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class PVTImagePresentation;

@protocol PVTThumbsProtocol <NSObject>

- (NSImage *)thumbnailImageForPresentation:(PVTImagePresentation *)presentation;

@end

@interface PVTThumbsManager : NSObject<PVTThumbsProtocol>

@end
