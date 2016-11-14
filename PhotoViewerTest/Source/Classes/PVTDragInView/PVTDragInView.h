//
//  PVTDragInView.h
//  PhotoViewerTest
//
//  Created by Andrii Mykhailov on 11/14/16.
//  Copyright © 2016 Andrii Mykhailov. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol PVTDragInViewDelegate<NSObject>
- (void)dragInViewDidReceiveImagePathes:(NSArray *)pathes;

@end;

@interface PVTDragInView : NSView
@property (nonatomic, weak)   IBOutlet      id<PVTDragInViewDelegate>           delegate;

@end
