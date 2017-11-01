//
//  UIImage+Additions.m
//
//  Created by Cory on 11/04/07.
//  Copyright 2011 Cory R. Leach. All rights reserved.
//

#import "UIImage+Additions.h"


@implementation UIImage (Additions)
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(UIImage*)cropImageForThumb:(UIImage*)image{
//    float  x=0;
//    float y=0;
//    if (self.size.height<=self.size.width) {
//        x = (self.size.width-self.size.height)/2.0;
//        y=0;
//    }else{
//        x=0;
//        y = (self.size.height-self.size.width)/2.0;
//    }
    
//    what part of width is 270
    float scaleFactor = (640.0/image.size.width);
    return [image imageWithImage:self scaledToSize:CGSizeMake((image.size.width*scaleFactor), (image.size.height*scaleFactor))];
    
//    NSLog(@"width =%f",self.size.width);
//    NSLog(@"height =%f",self.size.height);
//    NSLog(@"x =%f",x);
//    NSLog(@"y =%f",y);
//    float minLength = MIN(self.size.width, self.size.height);
//    CGImageRef partOfImageAsCG = CGImageCreateWithImageInRect(self.CGImage, CGRectMake(0, y, minLength, minLength));
//    UIImage *resizedImage = [UIImage imageWithCGImage:partOfImageAsCG];
//    NSLog(@"resized width =%f",resizedImage.size.width);
//    NSLog(@"resized height =%f",resizedImage.size.height);
//    
//    resizedImage = [resizedImage imageWithImage:resizedImage scaledToSize:CGSizeMake(135, 135)];
//    
//
//    x=0;
//    y = (resizedImage.size.width-100)/2;
//    partOfImageAsCG = CGImageCreateWithImageInRect(resizedImage.CGImage, CGRectMake(x, y, resizedImage.size.width, 100));
//    resizedImage = [UIImage imageWithCGImage:partOfImageAsCG];
//    
//    return resizedImage;
}


-(UIImage*)cropImageWithFrame:(CGRect)rect{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(rect.size.width, rect.size.height), NO, 0.0);
    [self drawInRect:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage*) imageWithThumbnailWidth:(CGFloat)thumbnailWidth {
    
    CGFloat width = self.size.width;
    CGFloat height = self.size.height;
    
    //Get thumbnail scale
    CGFloat scale = thumbnailWidth/width;
    
    //Find dimensions of thumbnail with const aspect ratio
    width = thumbnailWidth;
    height = self.size.height*scale;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height), NO, 0.0);
    [self drawInRect:CGRectMake(0, 0, width, height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    size_t bitsPerComponent = 8;
//    size_t bytesPerPixel = 4;
//    size_t bytesPerRow = bytesPerPixel * width;
//    size_t totalBytes = bytesPerRow * height;
//    
//    //Allocate Image space
//    uint8_t* rawData = malloc(totalBytes);
//    
//    //Create Bitmap of same size
//    CGContextRef context = CGBitmapContextCreate(rawData,width,height,bitsPerComponent,bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
//    
//    //Draw our image to the context
//    CGContextDrawImage(context, CGRectMake(0, 0, width, height), self.CGImage);
//    
//    //Create Image
//    CGImageRef newImg = CGBitmapContextCreateImage(context);
//    
//    //Release Created Data Structs
//    CGColorSpaceRelease(colorSpace);
//    CGContextRelease(context);
//    free(rawData);
//    
//    //Create UIImage struct around image
//    UIImage* image = [UIImage imageWithCGImage:newImg];
//    
//    //Release our hold on the image
//    CGImageRelease(newImg);
    
    //return new image!
    return self;
    
}

-(UIImage*)cropImage{
    
    CGImageRef imageToBeResized = self.CGImage;
    CGImageRef partOfImageAsCG = CGImageCreateWithImageInRect(imageToBeResized, CGRectMake(0, 0, 100, 100));
    UIImage *resizedImage = [UIImage imageWithCGImage:partOfImageAsCG];
    return resizedImage;
}

- (UIImage*) imageWithFixedRotation {
    
    CGImageRef imgRef = self.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    CGFloat boundHeight;
    
    //Check orientation
    UIImageOrientation orient = self.imageOrientation;
    switch(orient) {
            
        case UIImageOrientationUp:
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);//*/
//            transform = CGAffineTransformMakeTranslation(width, height);
//            transform = CGAffineTransformRotate(transform, M_PI); //*/
            break; //No rotation to fix
            
            
        case UIImageOrientationUpMirrored:
            transform = CGAffineTransformMakeTranslation(width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0); //*/
            break;
            
        case UIImageOrientationDown:
            //transform = CGAffineTransformMakeTranslation(width, height);
            //transform = CGAffineTransformRotate(transform, M_PI); //*/
            break;
            
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformMakeTranslation(0.0, height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);//*/
            break;
            
        case UIImageOrientationLeftMirrored:
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(height, width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);//*/
            break;
            
        case UIImageOrientationLeft:
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);//*/
            break;
            
        case UIImageOrientationRightMirrored:
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            break;
            
        case UIImageOrientationRight:
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);//*/
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();  
    UIGraphicsEndImageContext();  
    
    return imageCopy;
    
} 


@end