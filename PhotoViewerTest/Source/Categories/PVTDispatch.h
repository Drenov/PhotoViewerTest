//
//  PVTDispatch.h
//  PhotoViewerTest
//
//  Created by Andrii Mykhailov on 11/16/16.
//  Copyright © 2016 Andrii Mykhailov. All rights reserved.
//

#import <Foundation/Foundation.h>

void PVTDispatchAsyncOnMainQueueWithBlock(dispatch_block_t block);

void PVTDispatchAsyncOnDefaultQueueWithBlock(dispatch_block_t block);
