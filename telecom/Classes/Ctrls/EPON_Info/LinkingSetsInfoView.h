//
//  LinkingSetsInfoView.h
//  telecom
//
//  Created by liuyong on 15/11/2.
//  Copyright © 2015年 ZhongYun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LinkingSetsInfoViewDelegate<NSObject>
- (void)bottomSetInfoWithEquipCode:(NSString *)EquipCode EquipKind:(NSString *)EquipKind;
- (void)upperSetInfoWithEquipCode:(NSString *)EquipCode EquipKind:(NSString *)EquipKind;
@end

@interface LinkingSetsInfoView : UIView
@property(nonatomic,weak)id <LinkingSetsInfoViewDelegate> delegate;
@property (nonatomic,copy)NSString *willShowView;
- (void)setUpSetsInfoTableViewWith:(NSArray *)infoArray;
@end
