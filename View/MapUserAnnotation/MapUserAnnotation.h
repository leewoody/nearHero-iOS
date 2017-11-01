//
//  MapUserAnnotation.h
//  nearhero
//
//  Created by Dilawer Hussain on 7/15/16.
//  Copyright © 2016 TBoxSolutionz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/Foundation.h>
#import <MapKit/MKAnnotation.h>
#import "QTreeInsertable.h"

@interface MapUserAnnotation : NSObject <MKAnnotation, QTreeInsertable>{
    CLLocationCoordinate2D coordinate;
    NSString *title;
    NSString *subtitle;
}
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, strong) NSDictionary *userData;
@property (nonatomic, assign) int index;

@end
