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
#import "PVTThumbsManager.h"
#import "PVTDispatch.h"

@interface PVTStorageManager ()
@property (nonatomic, strong)   NSMutableArray<PVTImagePresentation*>       *mutableLibraryItems;
@property (nonatomic, strong)   PVTThumbsManager                            *thumbsManager ;

@end

@implementation PVTStorageManager

#pragma mark -
#pragma mark Initializations and Deallocations

- (instancetype)init {
    self = [super init];
    if (self) {
        self.mutableLibraryItems = [NSMutableArray new];
        self.thumbsManager = [PVTThumbsManager new];
    }
    
    return self;
}

#pragma mark -
#pragma mark Accessors

- (NSArray<PVTImagePresentation *> *)libraryItems {
    NSSortDescriptor *dateDescriptor = [NSSortDescriptor sortDescriptorWithKey:NSStringFromSelector(@selector(addedDate))
                                                                         ascending:YES];
    
    return [self.mutableLibraryItems sortedArrayUsingDescriptors:@[dateDescriptor]];
}

#pragma mark -
#pragma mark Public methods

- (void)addToLibraryImagesAtPathes:(NSArray<NSURL*>*)pathes {
    NSArray *comingItems = [self itemsFromUrlArray:pathes];
    NSArray *curentItems = self.libraryItems;

    NSMutableArray *toAddItems = [NSMutableArray new];
    for (PVTImagePresentation *item in comingItems) {
        if (![curentItems containsObject:item]) {
            [toAddItems addObject:item];
        }
    }

    if (toAddItems.count) {
        PVTDispatchAsyncOnDefaultQueueWithBlock(^{
            [self updateItemsData:toAddItems];
            [self.mutableLibraryItems addObjectsFromArray:toAddItems];
            PVTDispatchAsyncOnMainQueueWithBlock(^{
                [self.delegate storageManager:self didUpdateLibraryContent:self.libraryItems];
                
            });
        });
    }
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
