//
//  HNIconDownloadController.m
//  HN Zero
//
//  Created by Matt Stanford on 7/8/14.
//  Copyright (c) 2014 Matthew Stanford. All rights reserved.
//

#import "HNIconDownloadController.h"
#import "AFHTTPRequestOperation.h"

@implementation HNIconDownloadController

static const int HNMinPixelDensity = 16 * 16;

NSString *const HNTopLevelJsonObject = @"icons";
NSString *const HNImageInfoUrlKey = @"url";
NSString *const HNImageInfoWidthKey = @"width";
NSString *const HNImageInfoHeightKey = @"height";

NSString *const HNGoogleIconUrl = @"http://www.google.com/s2/favicons?domain=%@";
NSString *const HNIconServUrl = @"http://10.0.0.10:9292/%@";

- (void)getGoogleIcon:(NSString *)domain success:(void (^)(UIImage *))completionBlock
{
    if (domain)
    {
    
        NSString *urlString = [NSString stringWithFormat:HNGoogleIconUrl, domain];
        //NSLog(@"Getting google url: %@", urlString);
        NSURL *favIconInfoUrl = [NSURL URLWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:favIconInfoUrl];
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSData *imageData = (NSData *)responseObject;
            UIImage *responseImage = [[UIImage alloc] initWithData:imageData];
            
            completionBlock(responseImage);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           
            completionBlock([self getDefaultImage]);
            
        }];
        
        [operation start];
        
    }
    else
    {
        completionBlock([self getDefaultImage]);
    }
}

- (UIImage *)getDefaultImage
{
     UIImage *image = [UIImage imageNamed:@"default_icon.png"];
    
    return image;
}

- (void) downloadIcon:(NSString *)domain success:(void (^)(NSData *))successBlock
{
    NSString *urlString = [NSString stringWithFormat:HNIconServUrl, domain];
    NSLog(@"Getting url: %@", urlString);
    NSURL *favIconInfoUrl = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:favIconInfoUrl];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:
     ^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"success!");
         
         //Parse JSON that was returned from server
         NSError *error = nil;
         id jsonObject = [NSJSONSerialization
                          JSONObjectWithData:responseObject
                          options:0
                          error:&error];
         
         if ([jsonObject isKindOfClass:[NSDictionary class]])
         {
             NSDictionary *jsonDict = (NSDictionary *)jsonObject;
             
             if ([jsonDict count] > 0)
             {
                 [self getIconImageDataForJson:jsonDict withSuccessBlock:successBlock];
             }
         }
     }
    failure:^(AFHTTPRequestOperation *operation, NSError *erro)
     {
         NSLog(@"Failed to get icon info!");
     }];
    
    [operation start];
}

-(void) getIconImageDataForJson:(NSDictionary *)jsonData
               withSuccessBlock:(void (^)(NSData *))successBlock
{
    NSDictionary *bestImageInfo = [self getBestIconFromJsonData:jsonData];
    
    if (bestImageInfo &&
        [bestImageInfo objectForKey:HNImageInfoUrlKey] &&
        [[bestImageInfo objectForKey:HNImageInfoUrlKey] isKindOfClass:[NSString class]])
    {
        NSString *urlString = [bestImageInfo objectForKey:HNImageInfoUrlKey];
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            successBlock((NSData *)responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Failed to get image from url");
        }];
        
        [operation start];
    }
}

-(NSDictionary *) getBestIconFromJsonData:(NSDictionary *)jsonData
{
    NSDictionary *bestImageInfo = nil;
    
    for (NSDictionary *imageInfo in [jsonData objectForKey:HNTopLevelJsonObject])
    {
        NSInteger iconHeight;
        NSInteger iconWidth;
        
        //Get icon height
        if ([imageInfo objectForKey:HNImageInfoHeightKey] &&
            [[imageInfo objectForKey:HNImageInfoHeightKey] isKindOfClass:[NSNumber class]])
        {
            iconHeight = [[imageInfo objectForKey:HNImageInfoHeightKey] integerValue];
        }
        else
        {
            continue;
        }
        
        //Get icon width
        if ([imageInfo objectForKey:HNImageInfoWidthKey] &&
            [[imageInfo objectForKey:HNImageInfoWidthKey] isKindOfClass:[NSNumber class]])
        {
            iconWidth = [[imageInfo objectForKey:HNImageInfoWidthKey] integerValue];
        }
        else
        {
            continue;
        }
        
        //Make sure icon is square
        if (iconWidth != iconHeight)
        {
            continue;
        }
        
        //Get pixel densities
        NSInteger currentBestPixelDensity =
        [[bestImageInfo objectForKey:HNImageInfoWidthKey] integerValue] *
        [[bestImageInfo objectForKey:HNImageInfoWidthKey] integerValue];
        
        NSInteger candidatePixelDensity = iconHeight * iconWidth;
        
        //We want to specify a minimum pixel density so icons don't look blocky
        if (candidatePixelDensity < HNMinPixelDensity)
        {
            continue;
        }
        
        //Use the image with the highest pixel density
        if (bestImageInfo == nil)
        {
            bestImageInfo = imageInfo;
        }
        else
        {
            if (candidatePixelDensity > currentBestPixelDensity)
            {
                bestImageInfo = imageInfo;
            }
        }
    }
    
    return bestImageInfo;
    
}


@end
