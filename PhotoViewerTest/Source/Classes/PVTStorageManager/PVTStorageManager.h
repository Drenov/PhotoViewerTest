//
//  PVTStorageManager.h
//  PhotoViewerTest
//
//  Created by Andrii Mykhailov on 11/14/16.
//  Copyright © 2016 Andrii Mykhailov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PVTStorageManager;
@class PVTImagePresentation;

@protocol PVTStorageManagerDelegate <NSObject>

/*!
 Intended to notify of libriary content update. Called on main thread
 */
- (void)    storageManager:(PVTStorageManager *)manager
   didUpdateLibraryContent:(NSArray<PVTImagePresentation*>*)content;

@end

@protocol PVTContentStorageProtocol <NSObject>

/*!
 Intended to add items at provided pathes to library. Calls delegate 'storageManager:didUpdateLibraryContent:' callback
 */
- (void)addToLibraryImagesAtPathes:(NSArray<NSURL*>*)pathes;

/*!
 Current library items representation
 */
- (NSArray<PVTImagePresentation*>*)libraryItems;

@end

@interface PVTStorageManager : NSObject<PVTContentStorageProtocol>
@property (nonatomic, weak)     id<PVTStorageManagerDelegate>         delegate;

@end
