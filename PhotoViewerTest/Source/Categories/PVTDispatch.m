//
//  PVTDispatch.c
//  PhotoViewerTest
//
//  Created by Andrii Mykhailov on 11/16/16.
//  Copyright © 2016 Andrii Mykhailov. All rights reserved.
//

#import "PVTDispatch.h"

void PVTDispatchAsyncOnMainQueueWithBlock(dispatch_block_t block) {
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

void PVTDispatchAsyncOnDefaultQueueWithBlock(dispatch_block_t block) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
}
