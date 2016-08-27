//
//  SharePersonView.h
//  telecom
//
//  Created by liuyong on 15/4/23.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SharePersonViewDelegate <NSObject>

- (void)deliverSharePersonName:(NSString *)sharePersonName;
- (void)setSharePerson:(NSString *)userId;
- (void)cancelSharePerson;
@end

@interface SharePersonView : UIView
@property (nonatomic,copy)NSString *faultId;
@property(nonatomic,assign)id <SharePersonViewDelegate> delegate;

@property (retain, nonatomic) IBOutlet UITableView *sharePersonInfoTbView;

- (void)loadTableView;
- (void)loadSharePersonInfoWithURL:(NSString *)urlString;

@end
