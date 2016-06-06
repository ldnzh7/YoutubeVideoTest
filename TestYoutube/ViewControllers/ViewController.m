//
//  ViewController.m
//  TestYoutube
//
//  Created by Vasiliy on 05.06.16.
//  Copyright © 2016 Vasiliy. All rights reserved.
//

#import "ViewController.h"
#import "VideoModel.h"
#import "VideoCollectionViewCell.h"
#import <AFNetworking.h>
#import <UIImageView+AFNetworking.h>
#import <RMYouTubeExtractor.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

static const CGFloat kItemSpacing = 8.0;
static const CGFloat kItemHeight = 218.0;
static const NSInteger kItemsInCategory = 10;

@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, weak) IBOutlet UIView *categorySelectView;

@property (nonatomic, strong) NSArray<NSArray<VideoModel *> *> *videos;
@property (nonatomic, assign) NSInteger currentCategoryIndex;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Discover Video";
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:@"https://www.googleapis.com/youtube/v3/videos?part=contentDetails%2C+snippet%2C+player&id=9IN52nIcdfM,s4WQ_9AV3TU,hbtCGkDNJds,Ryo9XbTuBdQ,a9O63CFnEk0,UCeDwcc8NkY,OG-IRxfKQu4,_bPmuJyl1Fw,AHoN5byg8m4,Rk7v7LlKd_w,wEJfLrg_6DM,HgPYasaBKss,pfHpjNZAn9Q,V9H1fyucKa8,7lrUpwi_IYI,iTGoZcxjWnc,lhzHRv_WcAI,854dOZ0cKt8,8FpXmTWc5pQ,17vWBJYQfck,jiI_XyE-i9U,P9ZjJSXp1sI,2HhI66fusF0,kqv3xcQ_s4o,uqQTRwHv1xw,h5MI57jxEhY,a-9TGz7XNPo,sNDWUDdZbDo,Za6vi_TfwYQ,JwbExFh4p8M&key=AIzaSyCyUon4Y_Q8YB-PoLiAbvc5qEYP_UnVdFo" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([responseObject[@"items"] isKindOfClass:[NSArray class]]) {
                NSMutableArray<NSMutableArray *> *items = [NSMutableArray new];
                [items addObject:[NSMutableArray new]];
                for (NSDictionary *dict in responseObject[@"items"]) {
                    if ([dict isKindOfClass:[NSDictionary class]]) {
                        if ([items lastObject].count == kItemsInCategory) {
                            [items addObject:[NSMutableArray new]];
                        }
                        [[items lastObject] addObject:[[VideoModel alloc] initWithJSONDictionary:dict]];
                    }
                }
                self.videos = items;
                [self.collectionView reloadData];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:nil message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:ac animated:YES completion:nil];
    }];
    
    self.flowLayout.itemSize = CGSizeMake(([UIScreen mainScreen].bounds.size.width - kItemSpacing * 3) / 2, kItemHeight);
    self.flowLayout.minimumInteritemSpacing = kItemSpacing;
    
    [self.categorySelectView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(categoryTap:)]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UICollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.videos[self.currentCategoryIndex].count;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, kItemSpacing, 0, kItemSpacing);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    VideoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[VideoCollectionViewCell reuseIdentifier] forIndexPath:indexPath];
    VideoModel *model = self.videos[self.currentCategoryIndex][indexPath.row];
    cell.titleLabel.text = model.title;
    cell.ownerLabel.text = [NSString stringWithFormat:@"By %@", model.channelTitle];
    [cell.thumbnailImageView setImageWithURL:model.thumbnailURL];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    VideoModel *model = self.videos[self.currentCategoryIndex][indexPath.row];
    [[RMYouTubeExtractor sharedInstance] extractVideoForIdentifier:model.videoId completion:^(NSDictionary *videoDictionary, NSError *error) {
        NSURL *videoURL = videoDictionary[@(36)];
        AVPlayer *player = [AVPlayer playerWithURL:videoURL];
        AVPlayerViewController *playerViewController = [AVPlayerViewController new];
        playerViewController.player = player;
        [self presentViewController:playerViewController animated:YES completion:nil];
    }];
}

#pragma mark - Actions

- (void)categoryTap:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        for (NSInteger i = 0; i < self.videos.count; ++i) {
            [ac addAction:[UIAlertAction actionWithTitle:[NSString stringWithFormat:@"Category %ld", (long)(i + 1)] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                self.currentCategoryIndex = i;
                [self.collectionView reloadData];
            }]];
        }
        [ac addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:ac animated:YES completion:nil];
    }
}
     

@end
