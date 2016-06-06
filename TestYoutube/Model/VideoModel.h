//
//  VideoModel.h
//  TestYoutube
//
//  Created by Vasiliy on 06.06.16.
//  Copyright © 2016 Vasiliy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoModel : NSObject

@property (nonatomic, strong) NSString *videoId;
@property (nonatomic, strong) NSString *duration;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *channelTitle;
@property (nonatomic, strong) NSURL *thumbnailURL;

- (instancetype)initWithJSONDictionary:(NSDictionary *)dict;

@end
