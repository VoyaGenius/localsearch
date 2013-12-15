//
//  LocalSearchOperation.m
//  localsearch
//
//  Created by Harish Kashyap on 04/01/13.
//  Copyright (c) 2013 Harish Kashyap. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

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
