//
//  LocalSearchOperation.h
//  localsearch
//
//  Created by Harish Kashyap on 04/01/13.
//  Copyright (c) 2013 Harish Kashyap. All rights reserved.
//
#import <MapKit/MapKit.h>

extern NSString * const kSearchCompleteNotification;

@interface LocalSearchOperation : NSOperation

@property (nonatomic, assign) MKCoordinateRegion boundingRegion;
@property (nonatomic, strong) NSArray *searchResults;

- (id)initWithQuery:(NSString *)query atLocation:(CLLocation *)location;

@end
