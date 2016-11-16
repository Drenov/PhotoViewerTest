//
//  PVTStorageManager+InitialContent.m
//  PhotoViewerTest
//
//  Created by Andrii Mykhailov on 11/16/16.
//  Copyright © 2016 Andrii Mykhailov. All rights reserved.
//

#import "PVTStorageManager+InitialContent.h"

static NSString * const     kTempFolderName     = @"TEST_TEMP_FOLDER";
static NSString * const     kBuilInFilesType    = @"jpg";

@implementation PVTStorageManager (InitialContent)

#pragma mark -
#pragma mark Public methods

- (void)configureTemporaryFolder {
    NSArray *testImages = [[NSBundle mainBundle] pathsForResourcesOfType:kBuilInFilesType
                                                             inDirectory:nil];
    
    NSMutableArray *testImagesUrls = [NSMutableArray new];
    [testImages enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        [testImagesUrls addObject:[NSURL fileURLWithPath:obj]];
    }];
    
    [self copyToTemporaryFolderItemAtPathes:testImagesUrls];
    NSLog(@"Temp folder ready");
}

#pragma mark -
#pragma mark Private Methods

- (void)copyToTemporaryFolderItemAtPathes:(NSArray<NSURL*>*)pathes {
    NSFileManager *manager = [NSFileManager defaultManager];
    NSURL *tempPathUrl = [NSURL fileURLWithPath:self.tempPath];
    NSMutableArray *tempImagesPathes = [NSMutableArray new];
    
    for (NSURL *path in pathes) {
        NSError *error = nil;
        NSURL *destination = [tempPathUrl URLByAppendingPathComponent:path.filePathURL.lastPathComponent];
        [tempImagesPathes addObject:destination];
        if (![manager fileExistsAtPath:[destination path]]) {
            [manager copyItemAtURL:path
                             toURL:destination
                             error:&error];
        }
    }
    
    [self addToLibraryImagesAtPathes:tempImagesPathes];
}

- (NSString *)tempPath {
    NSArray * paths = NSSearchPathForDirectoriesInDomains (NSDesktopDirectory, NSUserDomainMask, YES);
    NSString * desktopPath = [paths objectAtIndex:0];
    desktopPath = [desktopPath stringByAppendingPathComponent:kTempFolderName];
    NSError *error = nil;
    BOOL isFolder = YES;
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:desktopPath isDirectory:&isFolder] && isFolder) {
        [manager createDirectoryAtPath:desktopPath
           withIntermediateDirectories:YES
                            attributes:nil
                                 error:&error];
    }
    
    return error ? nil : desktopPath;
}

@end
