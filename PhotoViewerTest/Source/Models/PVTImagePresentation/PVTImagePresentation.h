//
//  PVTImagePresentation.h
//  PhotoViewerTest
//
//  Created by Andrii Mykhailov on 11/14/16.
//  Copyright © 2016 Andrii Mykhailov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PVTImagePresentation : NSObject
@property (nonatomic, copy)         NSURL           *imagePath;
@property (nonatomic, copy)         NSDate          *addedDate;

@end
