//
//  VideoCollectionViewCell.m
//  TestYoutube
//
//  Created by Vasiliy on 06.06.16.
//  Copyright © 2016 Vasiliy. All rights reserved.
//

#import "VideoCollectionViewCell.h"

@implementation VideoCollectionViewCell

+ (UINib *)nib
{
    return [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
}

+ (NSString *)reuseIdentifier
{
    return NSStringFromClass([self class]);
}

@end
