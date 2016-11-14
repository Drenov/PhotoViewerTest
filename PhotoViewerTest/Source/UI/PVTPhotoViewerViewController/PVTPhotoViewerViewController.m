//
//  PVTPhotoViewerViewController.m
//  PhotoViewerTest
//
//  Created by Andrii Mykhailov on 11/14/16.
//  Copyright © 2016 Andrii Mykhailov. All rights reserved.
//

#import "PVTPhotoViewerViewController.h"
#import "PVTImagePresentationViewItem.h"
#import "PVTStorageManager.h"
#import "PVTDragInView.h"

@interface PVTPhotoViewerViewController ()<PVTStorageManagerDelegate, PVTDragInViewDelegate>
@property (nonatomic, assign)           float               cellRatio;
@property (nonatomic, strong)           NSArray             *dataSource;
@property (nonatomic, strong)           PVTStorageManager   *storageManager;
@property (nonatomic, strong)           id                  resizeObserver;

@end

@implementation PVTPhotoViewerViewController

#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.cellRatio = 1;
    id observation = [[NSNotificationCenter defaultCenter] addObserverForName:NSWindowDidResizeNotification
                                                                       object:nil
                                                                        queue:nil
                                                                   usingBlock:^(NSNotification * _Nonnull note) {
                                                                       [self.collectionView reloadData];                                                                   }];
    self.resizeObserver = observation;
    
    [self.storageManager configureTemporaryFolder];

    self.view.wantsLayer = YES;
    self.view.layer.backgroundColor = [NSColor blackColor].CGColor;
}

#pragma mark -
#pragma mark Accessors

- (PVTStorageManager *)storageManager {
    if (!_storageManager) {
        _storageManager = [PVTStorageManager new];
        _storageManager.delegate = self;
    }
    
    return _storageManager;
}

#pragma mark
#pragma mark - NSCollectionViewDataSource

- (NSInteger)collectionView:(NSCollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (NSCollectionViewItem *)collectionView:(NSCollectionView *)collectionView
     itemForRepresentedObjectAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *ident = NSStringFromClass([PVTImagePresentationViewItem class]);
    PVTImagePresentationViewItem *viewItem = [collectionView makeItemWithIdentifier:ident
                                                                   forIndexPath:indexPath];
    
    PVTImagePresentationViewItem *item = self.dataSource[indexPath.item];
    [viewItem fillWithModel:item];

    return viewItem;
}

#pragma mark
#pragma mark - NSCollectionViewDelegateFlowLayout

- (NSSize)collectionView:(NSCollectionView *)collectionView layout:(NSCollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSSize currentSize = collectionView.frame.size;
    
    CGFloat cellSide = (currentSize.height - 50);
    NSSize cellSize = NSMakeSize(cellSide * self.cellRatio, cellSide);
    
    return cellSize;
}

#pragma mark -
#pragma mark PVTStorageManagerDelegate

- (void)storageManager:(PVTStorageManager *)manager
   didUpdateTempFolder:(NSArray<PVTImagePresentation*>*)folderContents
{
    self.dataSource = folderContents;
    [self.collectionView reloadData];
    [NSAnimationContext currentContext].allowsImplicitAnimation = YES;
    NSIndexPath *lastCell = [NSIndexPath indexPathForItem:self.dataSource.count - 1 inSection:0];
    [self.collectionView.animator scrollToItemsAtIndexPaths:[NSSet setWithObject:lastCell]
                                             scrollPosition:NSCollectionViewScrollPositionLeadingEdge];
    [NSAnimationContext currentContext].allowsImplicitAnimation = NO;
}

#pragma mark -
#pragma mark PVTDragInViewDelegate

- (void)dragInViewDidReceiveImagePathes:(NSArray *)pathes {
    [self.storageManager copyToTemporaryFolderItemAtPathes:pathes];
    [self.storageManager updateTempFolderItems];
}

@end
