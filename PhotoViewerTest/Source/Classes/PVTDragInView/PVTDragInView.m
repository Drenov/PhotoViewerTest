//
//  PVTDragInView.m
//  PhotoViewerTest
//
//  Created by Andrii Mykhailov on 11/14/16.
//  Copyright © 2016 Andrii Mykhailov. All rights reserved.
//

#import "PVTDragInView.h"

@interface PVTDragInView ()
@property (nonatomic, assign)       BOOL            isReceivingDrag;

@end

@implementation PVTDragInView

#pragma mark -
#pragma mark Initializations and Deallocations

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self baseInit];
}

#pragma mark -
#pragma mark Overriden Methods

- (void)drawRect:(NSRect)dirtyRect {
    if (self.isReceivingDrag) {
        [NSColor.selectedControlColor set];
        
        NSBezierPath *path = [NSBezierPath bezierPathWithRect:self.bounds];
        path.lineWidth = 10.0f;
        [path stroke];
    }
}

- (NSView *)hitTest:(NSPoint)point {
    return nil;
}

#pragma mark -
#pragma mark Private Methods

- (void)baseInit {
    [self registerForDraggedTypes:@[NSURLPboardType]];
}

- (void)setIsReceivingDrag:(BOOL)isReceivingDrag {
    [self setNeedsDisplay:YES];
    _isReceivingDrag = isReceivingDrag;
}

- (BOOL)shouldAllowDrag:(id<NSDraggingInfo>)sender {
    BOOL canAccept = NO;
    
    
    NSPasteboard *pasteBoard = sender.draggingPasteboard;
    NSDictionary *options = @{NSPasteboardURLReadingContentsConformToTypesKey : [NSImage imageTypes]};
    
    
    if ([pasteBoard canReadObjectForClasses:@[[NSURL class]] options:options]){
        canAccept = YES;
    }
    
    return canAccept;
}

#pragma mark -
#pragma mark NSDraggingDestination

- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender {
    BOOL allow = [self shouldAllowDrag:sender];
    self.isReceivingDrag = allow;
    
    return allow ? NSDragOperationCopy : NSDragOperationNone;
}

- (void)draggingExited:(id<NSDraggingInfo>)sender {
    self.isReceivingDrag = NO;
}

- (BOOL)prepareForDragOperation:(id<NSDraggingInfo>)sender {
    BOOL allow = [self shouldAllowDrag:sender];
    
    return allow;
}

- (BOOL)performDragOperation:(id<NSDraggingInfo>)sender {
    self.isReceivingDrag = NO;
    
    NSPasteboard *pasteBoard = sender.draggingPasteboard;
    
    NSDictionary *options = @{NSPasteboardURLReadingContentsConformToTypesKey : [NSImage imageTypes]};
    
    
    NSArray *urls = [pasteBoard readObjectsForClasses:@[[NSURL class]]
                                              options:options];
    
    if (urls.count) {
        [self.delegate dragInViewDidReceiveImagePathes:urls];
        
        return YES;
    }
    
    return NO;
}

@end
