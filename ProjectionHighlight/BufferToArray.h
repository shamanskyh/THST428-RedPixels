//
//  BufferToArray.h
//  ProjectionHighlight
//
//  Created by Harry Shamansky on 4/20/15.
//  Copyright (c) 2015 Harry Shamansky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreVideo/CoreVideo.h>

@interface BufferToArray : NSObject

- (NSArray *)detectPixelsInBuffer:(CVPixelBufferRef)buffer;

@end
