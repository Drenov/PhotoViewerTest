//
//  PVTStorageManager+InitialContent.h
//  PhotoViewerTest
//
//  Created by Andrii Mykhailov on 11/16/16.
//  Copyright © 2016 Andrii Mykhailov. All rights reserved.
//

#import "PVTStorageManager.h"

@interface PVTStorageManager (InitialContent)

/*!
 Method intended to add bult in images to library. Calls delegate 'storageManager:didUpdateLibraryContent:' callback
 */
- (void)configureTemporaryFolder;

@end
