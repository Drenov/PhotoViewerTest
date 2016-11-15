//
//  PVTImagePresentationViewItem.m
//  PhotoViewerTest
//
//  Created by Andrii Mykhailov on 11/14/16.
//  Copyright © 2016 Andrii Mykhailov. All rights reserved.
//

#import "PVTImagePresentationViewItem.h"
#import "PVTImagePresentation.h"

@interface PVTImagePresentationViewItem ()

@end

@implementation PVTImagePresentationViewItem

#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark -
#pragma mark Public methods

- (void)fillWithModel:(PVTImagePresentation *)model {
    self.presentationImageView.image = model.thumbnailImage;
    self.infoLabel.stringValue = model.imagePath.lastPathComponent;
}

@end
