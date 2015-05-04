//
//  BufferToArray.m
//  ProjectionHighlight
//
//  Created by Harry Shamansky on 4/20/15.
//  Copyright (c) 2015 Harry Shamansky. All rights reserved.
//

#import "BufferToArray.h"

@implementation BufferToArray

- (NSArray *)detectPixelsInBuffer:(CVPixelBufferRef)buffer {
    
    NSMutableArray *retArray = [[NSMutableArray alloc] init];
    
    // Get the pixel buffer width and height
    size_t width = CVPixelBufferGetWidth(buffer);
    size_t height = CVPixelBufferGetHeight(buffer);
    unsigned char* pixel = (unsigned char *)CVPixelBufferGetBaseAddress(buffer);
    
    for (int i = 0; i < height; i++) {
        for (int j = 0; j < width; j += 4) {
            int alpha = pixel[(i * 4 * width) + (j * 4) + 3];
            int red = pixel[(i * 4 * width) + (j * 4) + 2];
            int green = pixel[(i * 4 * width) + (j * 4) + 1];
            int blue = pixel[(i * 4 * width) + (j * 4) + 0];
            
            if (red > 70 && green < 40 && blue < 40) {
                CGPoint p = CGPointMake(width - j, height - i);
                NSValue *v = [NSValue valueWithCGPoint:p];
                [retArray addObject:v];
            }
        }
    }
    return retArray;
}

@end
