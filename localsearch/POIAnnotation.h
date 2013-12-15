//
//  POIAnnotation.h
//  localsearch
//
//  Created by Harish Kashyap on 04/01/13.
//  Copyright (c) 2013 Harish Kashyap. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface POIAnnotation : NSObject<MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSString *subTitle;

@end
