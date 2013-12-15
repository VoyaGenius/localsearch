//
//  ViewController.h
//  localsearch
//
//  Created by Harish Kashyap on 12/10/13.
//  Copyright (c) 2013 Harish Kashyap. All rights reserved.
//
#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotation.h>

@class LocalSearchOperation;
@class POIAnnotation;

@interface ViewController : UIViewController<MKMapViewDelegate>

@property (nonatomic, strong) NSOperationQueue *searchOperationQueue;

@end
