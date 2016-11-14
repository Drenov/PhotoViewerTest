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

- (void)storageManager:(PVTStorageManager *)manager
   didUpdateTempFolder:(NSArray<PVTImagePresentation*>*)folderContents;

@end

@interface PVTStorageManager : NSObject
@property (nonatomic, readonly)     NSString                        *tempPath;
@property (nonatomic, readonly)     NSArray<NSURL*>                 *tempFolderContents;
@property (nonatomic, readonly)     NSArray<PVTImagePresentation*>  *tempFolderItems;

@property (nonatomic, weak)     id<PVTStorageManagerDelegate>         delegate;

/*!
 Method intended to add bult in images to temp folder. Calls delegate 'storageManager:didUpdateTempFolder:' callback
 */
- (void)configureTemporaryFolder;

/*!
 Intended to copy items at provided pathes. Calls delegate 'storageManager:didUpdateTempFolder:' callback
 */
- (void)copyToTemporaryFolderItemAtPathes:(NSArray<NSURL*>*)pathes;

/*!
 Intended to update 'tempFolderItems' to actual folder state. Calls delegate 'storageManager:didUpdateTempFolder:' callback
 */
- (void)updateTempFolderItems;

@end
