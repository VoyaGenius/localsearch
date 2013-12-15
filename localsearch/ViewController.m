//
//  ViewController.m
//  localsearch
//
//  Created by Harish Kashyap on 12/10/13.
//  Copyright (c) 2013 Harish Kashyap. All rights reserved.
//

#import "LocalSearchOperation.h"
#import "POIAnnotation.h"
#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, weak) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) LocalSearchOperation *searchHistoricPOIOperation;
@property (nonatomic, strong) NSMutableArray *searchResults;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mapView.delegate = self;
    
    _searchOperationQueue = [[NSOperationQueue alloc]init];
    _searchOperationQueue.name = @"Search Operation Queue";
    _searchResults = [[NSMutableArray alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addSearchResultAnnotations) name:kSearchCompleteNotification object:nil];
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:42.360383 longitude:-71.058004];
    _searchHistoricPOIOperation = [[LocalSearchOperation alloc] initWithQuery:@"Historic" atLocation:location];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [self.searchOperationQueue addOperation:_searchHistoricPOIOperation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [_searchOperationQueue cancelAllOperations];
}

- (void)addSearchResultAnnotations
{
    [self.mapView setRegion:self.searchHistoricPOIOperation.boundingRegion];
    [self.searchResults removeAllObjects];
    [self.searchResults addObjectsFromArray:self.searchHistoricPOIOperation.searchResults];
    NSMutableArray *annotations = [[NSMutableArray alloc] initWithCapacity:self.searchHistoricPOIOperation.searchResults.count];
    for (MKMapItem *mapItem in self.searchResults) {
        POIAnnotation *annotation = [[POIAnnotation alloc] init];
        NSLog(@"%@", mapItem.name);
        annotation.title = mapItem.name;
        annotation.subTitle = [mapItem.placemark.addressDictionary objectForKey:@"address"];
        annotation.coordinate = mapItem.placemark.location.coordinate;
        [annotations addObject:annotation];
    }
    [self.mapView addAnnotations:annotations];
}

#pragma mark -
#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
	MKPinAnnotationView *annotationView = nil;
	if ([annotation isKindOfClass:[POIAnnotation class]])
	{
		annotationView = (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"MapPin"];
		if (annotationView == nil)
		{
			annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MapPin"];
			annotationView.canShowCallout = YES;
			annotationView.animatesDrop = YES;
		}
	}
	return annotationView;
}

@end
