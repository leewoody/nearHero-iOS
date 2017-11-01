//
//  UIImage+Additions.h
//
//  Created by Cory on 11/04/07.
//  Copyright 2011 Cory R. Leach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"


@interface UIImage (Additions)

- (UIImage*) imageWithThumbnailWidth:(CGFloat)thumbnailWidth;

//Fix the rotation of an image in place
//So UIImageView doesn't rotate it automatically
- (UIImage*) imageWithFixedRotation;
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
-(UIImage*)cropImageForThumb:(UIImage*)image;
-(UIImage*)cropImageWithFrame:(CGRect)rect;
@end