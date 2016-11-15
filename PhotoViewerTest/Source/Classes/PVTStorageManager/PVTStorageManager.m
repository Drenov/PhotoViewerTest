//
//  PVTStorageManager.m
//  PhotoViewerTest
//
//  Created by Andrii Mykhailov on 11/14/16.
//  Copyright © 2016 Andrii Mykhailov. All rights reserved.
//

#import "PVTStorageManager.h"
#import "PVTImagePresentation.h"
#import "NSURL+PVTExtensions.h"
#import <AppKit/AppKit.h>
#import "PVTThumbsManager.h"

static NSString * const     kTempFolderName     = @"TEST_TEMP_FOLDER";
static NSString * const     kBuilInFilesType    = @"jpg";

@interface PVTStorageManager ()
@property (nonatomic, strong)   NSMutableArray<PVTImagePresentation*>      *mutableFolderItems;
@property (nonatomic, strong)   PVTThumbsManager                            *thumbsManager ;

@end

@implementation PVTStorageManager

#pragma mark -
#pragma mark Initializations and Deallocations

- (instancetype)init {
    self = [super init];
    if (self) {
        self.mutableFolderItems = [NSMutableArray new];
        self.thumbsManager = [PVTThumbsManager new];
    }
    
    return self;
}

#pragma mark -
#pragma mark Accessors

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

- (NSArray<NSURL*>*)tempFolderContents {
    NSFileManager *manager = [NSFileManager defaultManager];
    NSError *error = nil;
    
    NSArray *directoryContent = [manager contentsOfDirectoryAtPath:self.tempPath error:&error];
    NSURL *tempPathUrl = [NSURL fileURLWithPath:self.tempPath];
    NSMutableArray *result = [NSMutableArray new];
    
    
    for (NSString *path in directoryContent) {
        CFStringRef fileExtension = (__bridge CFStringRef) [path pathExtension];
        CFStringRef fileUTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, fileExtension, NULL);
        if (UTTypeConformsTo(fileUTI, kUTTypeImage)) {
            NSURL *resulrUrl = [tempPathUrl URLByAppendingPathComponent:path];
            [result addObject:resulrUrl];
        }
    }
    
    return result;
}

- (NSArray<PVTImagePresentation*>*)tempFolderItems {
    NSSortDescriptor *dateDescriptor = [NSSortDescriptor sortDescriptorWithKey:NSStringFromSelector(@selector(addedDate))
                                                                     ascending:YES];
    
    return [self.mutableFolderItems sortedArrayUsingDescriptors:@[dateDescriptor]];
}

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

- (void)copyToTemporaryFolderItemAtPathes:(NSArray<NSURL*>*)pathes {
    NSFileManager *manager = [NSFileManager defaultManager];
    NSURL *tempPathUrl = [NSURL fileURLWithPath:self.tempPath];
    for (NSURL *path in pathes) {
        NSError *error = nil;
        NSURL *destination = [tempPathUrl URLByAppendingPathComponent:path.filePathURL.lastPathComponent];
        
        if (![manager fileExistsAtPath:[destination path]]) {
            [manager copyItemAtURL:path
                             toURL:destination
                             error:&error];
        }
    }
    
    [self updateTempFolderItems];
}

- (void)updateTempFolderItems {
    NSArray *updatedFolderItems = [self itemsFromUrlArray:self.tempFolderContents];
    NSArray *curentFolderItems = self.tempFolderItems;
    
    if ([updatedFolderItems isEqual:curentFolderItems]) {
        return;
    }
        
    NSMutableArray *toAddItems = [NSMutableArray new];
    for (PVTImagePresentation *item in updatedFolderItems) {
        if (![curentFolderItems containsObject:item]) {
            [toAddItems addObject:item];
        }
    }
    
    NSMutableArray *toRemoveItems = [NSMutableArray new];
    for (PVTImagePresentation *item in curentFolderItems) {
        if (![updatedFolderItems containsObject:item]) {
            [toRemoveItems addObject:item];
        }
    }
    
    [self.mutableFolderItems addObjectsFromArray:toAddItems];
    [self.mutableFolderItems removeObjectsInArray:toRemoveItems];
    
    [self updateItemsData:toAddItems];
    [self.delegate storageManager:self didUpdateTempFolder:self.tempFolderItems];
}

#pragma mark -
#pragma mark Private Methods

- (void)updateItemsData:(NSArray<PVTImagePresentation*>*)items {
    for (PVTImagePresentation *item in items) {
        NSArray *imageReps = [NSBitmapImageRep imageRepsWithContentsOfURL:item.imagePath];
        NSInteger width = 0;
        NSInteger height = 0;
        for (NSImageRep * imageRep in imageReps) {
            NSInteger currentWidth = [imageRep pixelsWide];
            NSInteger currentHeight = [imageRep pixelsHigh];
            
            if (currentWidth > width){
                width = currentWidth;
            }
            
            if (currentHeight > height) {
              height = currentHeight;
            }
        }
        
        item.width = width;
        item.height = height;
        item.ratio = (float)width / (float)height;
        item.thumbnailImage = [self.thumbsManager thumbnailImageForPresentation:item];
    }
}

- (NSArray<PVTImagePresentation*>*)itemsFromUrlArray:(NSArray *)array {
    NSMutableArray *updatedFolderItems = [NSMutableArray new];
    [array enumerateObjectsUsingBlock:^(NSURL *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PVTImagePresentation *imagePresentation = [PVTImagePresentation new];
        imagePresentation.imagePath = obj;
        imagePresentation.addedDate = [NSDate date];
        [updatedFolderItems addObject:imagePresentation];
    }];
    
    return updatedFolderItems;
}

@end
