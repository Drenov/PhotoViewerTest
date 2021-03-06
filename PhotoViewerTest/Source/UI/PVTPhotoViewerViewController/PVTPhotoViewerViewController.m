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
#import "PVTImagePresentation.h"
#import "PVTStorageManager+InitialContent.h"

static const float kSizeGap = 50.f;

@interface PVTPhotoViewerViewController ()<PVTStorageManagerDelegate, PVTDragInViewDelegate>
@property (nonatomic, strong)           NSArray             *dataSource;
@property (nonatomic, strong)           PVTStorageManager   *storageManager;
@property (nonatomic, strong)           id                  resizeObserver;

@end

@implementation PVTPhotoViewerViewController

#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

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

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self.resizeObserver];
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

- (NSSize)collectionView:(NSCollectionView *)collectionView
                  layout:(NSCollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PVTImagePresentation *imagePresentation = self.dataSource[indexPath.item];
    float ratio = imagePresentation.ratio;
    NSSize currentSize = collectionView.frame.size;
    CGFloat cellSide = (currentSize.height - kSizeGap);
    NSSize cellSize = NSMakeSize(cellSide * ratio, cellSide);
    
    return cellSize;
}

#pragma mark -
#pragma mark PVTStorageManagerDelegate

- (void)    storageManager:(PVTStorageManager *)manager
   didUpdateLibraryContent:(NSArray<PVTImagePresentation *> *)content
{
    self.dataSource = content;
    [self.collectionView reloadData];
    [NSAnimationContext currentContext].duration = 0.5f;
    [NSAnimationContext currentContext].allowsImplicitAnimation = YES;
    NSIndexPath *lastCell = [NSIndexPath indexPathForItem:self.dataSource.count - 1 inSection:0];
    [self.collectionView.animator scrollToItemsAtIndexPaths:[NSSet setWithObject:lastCell]
                                             scrollPosition:NSCollectionViewScrollPositionLeadingEdge];
    [NSAnimationContext currentContext].allowsImplicitAnimation = NO;
}

#pragma mark -
#pragma mark PVTDragInViewDelegate

- (void)dragInViewDidReceiveImagePathes:(NSArray *)pathes {
    [self.storageManager addToLibraryImagesAtPathes:pathes];
}

@end
