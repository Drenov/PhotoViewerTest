//
//  PVTImagePresentationViewItem.h
//  PhotoViewerTest
//
//  Created by Andrii Mykhailov on 11/14/16.
//  Copyright © 2016 Andrii Mykhailov. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PVTImagePresentationViewItem : NSCollectionViewItem
@property (weak) IBOutlet NSImageView *presentationImageView;
@property (weak) IBOutlet NSTextField *infoLabel;

- (void)fillWithModel:(id)model;

@end
