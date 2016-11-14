//
//  NSURL+PVTExtensions.m
//  PhotoViewerTest
//
//  Created by Andrii Mykhailov on 11/14/16.
//  Copyright © 2016 Andrii Mykhailov. All rights reserved.
//

#import "NSURL+PVTExtensions.h"

@implementation NSURL (PVTExtensions)

- (BOOL)isEqualToURL:(NSURL*)otherURL {
    return ([[self absoluteURL] isEqual:[otherURL absoluteURL]]) ||
    ([self isFileURL] && [otherURL isFileURL] && [[self path] isEqual:[otherURL path]]);
}

@end
