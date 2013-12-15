//
//  LocalSearchOperation.m
//  localsearch
//
//  Created by Harish Kashyap on 04/01/13.
//  Copyright (c) 2013 Harish Kashyap. All rights reserved.
//

#import "LocalSearchOperation.h"

NSString * const kSearchCompleteNotification = @"kSearchCompleteNotification";

@interface LocalSearchOperation()

@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) NSString *query;

@end

@implementation LocalSearchOperation

- (id)initWithQuery:(NSString *)query atLocation:(CLLocation *)location {
    if (self = [super init]) {
        _query = query;
        _location = location;
    }
    return self;
}

#pragma mark -
#pragma mark - Run search operation

- (void)main {
    @autoreleasepool {
        if (self.isCancelled) {
            return;
        }
        
        MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
        request.naturalLanguageQuery = self.query;
        request.region = MKCoordinateRegionMakeWithDistance(self.location.coordinate, 3000, 3000);
        
        MKLocalSearch *localSearch = [[MKLocalSearch alloc]initWithRequest:request];
        
        if (self.isCancelled) {
            request = nil;
            localSearch = nil;
            return;
        }
        
        NSLog(@"Starting search for %@ at %@", self.query, [self.location description]);
        
        [localSearch startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
            if (response) {
                self.boundingRegion = response.boundingRegion;
                _searchResults = [[NSArray alloc] initWithArray:response.mapItems];
                [[NSNotificationCenter defaultCenter] postNotificationName:kSearchCompleteNotification object:self];
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                for (MKMapItem *mapItem in response.mapItems) {
                    NSLog(@"%@",mapItem.name);
                }
            }
        }];
    }
}

@end
