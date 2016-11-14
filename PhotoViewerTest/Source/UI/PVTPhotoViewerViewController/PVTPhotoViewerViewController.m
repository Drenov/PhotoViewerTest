//
//  PVTPhotoViewerViewController.m
//  PhotoViewerTest
//
//  Created by Andrii Mykhailov on 11/14/16.
//  Copyright © 2016 Andrii Mykhailov. All rights reserved.
//

#import "PVTPhotoViewerViewController.h"
#import "PVTImagePresentationViewItem.h"

@interface PVTPhotoViewerViewController ()
@property (nonatomic, assign)           float               cellRatio;
@property (nonatomic, strong)           NSArray             *dataSource;
@property (nonatomic, strong)           id                  resizeObserver;

@end

@implementation PVTPhotoViewerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.cellRatio = 1;
    id observation = [[NSNotificationCenter defaultCenter] addObserverForName:NSWindowDidResizeNotification
                                                                       object:nil
                                                                        queue:nil
                                                                   usingBlock:^(NSNotification * _Nonnull note) {
                                                                       [self.collectionView reloadData];                                                                   }];
    self.resizeObserver = observation;
    
    self.view.wantsLayer = YES;
    self.view.layer.backgroundColor = [NSColor blackColor].CGColor;
}


#pragma mark
#pragma mark - NSCollectionViewDataSource

- (NSInteger)collectionView:(NSCollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

- (NSCollectionViewItem *)collectionView:(NSCollectionView *)collectionView
     itemForRepresentedObjectAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *ident = NSStringFromClass([PVTImagePresentationViewItem class]);
    PVTImagePresentationViewItem *item = [collectionView makeItemWithIdentifier:ident
                                                                   forIndexPath:indexPath];
    
    item.infoLabel.stringValue = @"SDS";
    return item;
}

#pragma mark
#pragma mark - NSCollectionViewDelegateFlowLayout

- (NSSize)collectionView:(NSCollectionView *)collectionView layout:(NSCollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSSize currentSize = collectionView.frame.size;
    
    CGFloat cellSide = (currentSize.height - 50);
    NSSize cellSize = NSMakeSize(cellSide * self.cellRatio, cellSide);
    
    return cellSize;
}

@end
