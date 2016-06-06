//
//  VideoCollectionViewCell.h
//  TestYoutube
//
//  Created by Vasiliy on 06.06.16.
//  Copyright © 2016 Vasiliy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UIImageView *thumbnailImageView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *ownerLabel;

+ (UINib *)nib;
+ (NSString *)reuseIdentifier;

@end
