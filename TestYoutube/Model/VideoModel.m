//
//  VideoModel.m
//  TestYoutube
//
//  Created by Vasiliy on 06.06.16.
//  Copyright © 2016 Vasiliy. All rights reserved.
//

#import "VideoModel.h"

@implementation VideoModel

- (instancetype)initWithJSONDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        _videoId = [self stringOrEmpty:dict[@"id"]];
        
        if ([dict[@"snippet"] isKindOfClass:[NSDictionary class]]) {
            NSDictionary *snippetDict = (NSDictionary *)dict[@"snippet"];
            _channelTitle = [self stringOrEmpty:snippetDict[@"channelTitle"]];
            _title = [self stringOrEmpty:snippetDict[@"title"]];
            
            if ([snippetDict[@"thumbnails"] isKindOfClass:[NSDictionary class]]) {
                if ([snippetDict[@"thumbnails"][@"medium"] isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *thumbnailsDict = (NSDictionary *)snippetDict[@"thumbnails"][@"medium"];
                    _thumbnailURL = [NSURL URLWithString:[self stringOrEmpty:thumbnailsDict[@"url"]]];
                }
            }
        }
        
        if ([dict[@"contentDetails"] isKindOfClass:[NSDictionary class]]) {
            NSDictionary *contentDict = (NSDictionary *)dict[@"contentDetails"];
            NSString *duration = [self stringOrEmpty:contentDict[@"duration"]];
            int days = 0, hours = 0, minutes = 0, seconds = 0;
            
            const char *ptr = duration.UTF8String;
            while (*ptr) {
                if (*ptr == 'P' || *ptr == 'T') {
                    ptr++;
                    continue;
                }
                
                int value, charsRead;
                char type;
                if (sscanf(ptr, "%d%c%n", &value, &type, &charsRead) != 2) {
                    _duration = @"";
                    break;
                }
                
                if (type == 'D') {
                    days = value;
                }
                else if (type == 'H') {
                    hours = value;
                }
                else if (type == 'M') {
                    minutes = value;
                }
                else if (type == 'S') {
                    seconds = value;
                }
                else {
                    break;
                }
                
                ptr += charsRead;
            }
            
            if (days > 0) {
                _duration = [NSString stringWithFormat:@"%d:%d:%d:%d", days, hours, minutes, seconds];
            }
            else if (hours > 0) {
                _duration = [NSString stringWithFormat:@"%d:%d:%d", hours, minutes, seconds];
            }
            else {
                _duration = [NSString stringWithFormat:@"%d:%d", minutes, seconds];
            }
        }
    }
    
    return self;
}

- (NSString *)stringOrEmpty:(id)object
{
    return [object isKindOfClass:[NSString class]] ? (NSString *)object : [object isKindOfClass:[NSNumber class]] ? [(NSNumber *)object stringValue] : @"";
}

@end
