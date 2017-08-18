//
//  justPostedFlickrPhotosTVC.m
//  Shutterbug
//
//  Created by nitesh.vi on 18/08/17.
//  Copyright © 2017 nitesh.vi. All rights reserved.
//

#import "justPostedFlickrPhotosTVC.h"
#import "FlickrFetcher.h"
@interface justPostedFlickrPhotosTVC ()

@end

@implementation justPostedFlickrPhotosTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchPhotos];
}

- (IBAction)fetchPhotos
{
    [self.refreshControl beginRefreshing];
    NSURL *url = [FlickrFetcher URLforRecentGeoreferencedPhotos];
    dispatch_queue_t fetchQ = dispatch_queue_create("flickr fetcher", NULL);
    dispatch_async(fetchQ, ^{
        NSData *jsonResults = [NSData dataWithContentsOfURL:url];
        NSDictionary *propertyListDetails = [NSJSONSerialization JSONObjectWithData:jsonResults options:0 error:NULL];
        NSLog(@"Flickr results = %@",propertyListDetails);
        NSArray *photos = [propertyListDetails valueForKeyPath:FLICKR_RESULTS_PHOTOS];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.refreshControl endRefreshing];
            self.photos = photos;
        });
    });
    
}

@end
