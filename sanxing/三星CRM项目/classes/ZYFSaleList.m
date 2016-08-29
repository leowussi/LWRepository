//
//  ZYFSaleList.m
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/7/2.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import "ZYFSaleList.h"
#import "ZYFForm.h"
#import "ZYFGroup.h"
#import "CRMHelper.h"

@interface ZYFSaleList()
//按顺序排列后的ZYFAttributes数组
@property (nonatomic,strong ) NSMutableArray *orderArray;

@end

@implementation ZYFSaleList

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.Attributes forKey:@"Attributes"];
    [encoder encodeObject:self.FormattedValues forKey:@"FormattedValues"];
    [encoder encodeObject:self.Id forKey:@"Id"];
    [encoder encodeObject:self.LogicalName forKey:@"LogicalName"];
    [encoder encodeObject:self.dispalyCols forKey:@"dispalyCols"];
    [encoder encodeObject:self.attrArray forKey:@"attrArray"];
    [encoder encodeObject:self.formatValueArray forKey:@"formatValueArray"];
    [encoder encodeInteger:self.msgState forKey:@"msgState"];

//    [encoder encodeObject:self.formArray forKey:@"formArray"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.Attributes = [decoder decodeObjectForKey:@"Attributes"];
        self.FormattedValues = [decoder decodeObjectForKey:@"FormattedValues"];
        self.Id = [decoder decodeObjectForKey:@"Id"];
        self.LogicalName = [decoder decodeObjectForKey:@"LogicalName"];
        self.dispalyCols = [decoder decodeObjectForKey:@"dispalyCols"];
        self.attrArray = [decoder decodeObjectForKey:@"attrArray"];
        self.formatValueArray = [decoder decodeObjectForKey:@"formatValueArray"];
        self.msgState = [decoder decodeIntegerForKey:@"msgState"];
//        self.formArray = [decoder decodeObjectForKey:@"formArray"];

    }
    return self;
}

-(instancetype)initWithDict:(NSDictionary*)dict displayCols:(ZYFDisplayCols*)displayCol
{
    if (self = [super init]) {
        
        self.dispalyCols = displayCol;
        
        self.Id = dict[@"Id"];
        self.LogicalName = dict[@"LogicalName"];
        self.Attributes = dict[@"Attributes"];
        
        //初始化消息状态为未读
//        _msgState = MSGMessageStateClosed;
        self.msgState = MSGMessageStateClosed;

        
        //  将display中要求显示的attr解析到mutablearray中
        NSMutableArray *mutableArray = [NSMutableArray array];
        
        for (NSDictionary *dict in self.Attributes) {
            for (int i = 0; i < displayCol.keyArray.count; i ++) {
                //只解析displaycols中要求显示的字段
                if ([dict[@"Key"] isEqualToString:displayCol.keyArray[i]]) {
                    @try {
                        ZYFAttributes *attr = [ZYFAttributes attributesWithDict:dict valueType:displayCol.valueArray[i]];
                        [mutableArray addObject:attr];
                    }
                    @catch (NSException *exception) {
                        NSLog(@"sdlfjl");
                    }
                    @finally {
                    }
                }
            }
        }
        
        //  将已经解析出来的mutablearray中的attr，按顺序到orderarray中
        
        for (int i = 0; i < displayCol.keyArray.count; i++) {
            NSString *keyString = [displayCol.keyArray objectAtIndex:i];
            BOOL isContain = [self isContainString:keyString attrArray:mutableArray];
            if (isContain) {
                
            }else{
                ZYFAttributes *nilAttr = [[ZYFAttributes alloc]initWithDict:nil valueType:nil];
                [self.orderArray addObject:nilAttr];
            }
        }
        
        self.attrArray = self.orderArray;
        
        NSMutableArray *fVArray = [NSMutableArray array];
        self.FormattedValues = dict[@"FormattedValues"];
        for (NSDictionary *dict in self.FormattedValues) {
            for (int i = 0; i < displayCol.keyArray.count; i ++) {
                //只解析displaycols中要求显示的字段
                if ([dict[@"Key"] isEqualToString:displayCol.keyArray[i]]) {
                    ZYFFormattedValue *formattedValue = [ZYFFormattedValue formattedWithDict:dict];
                    [fVArray addObject:formattedValue];
                }
            }
        }
        self.formatValueArray = fVArray;
    }
    return self;
}

-(instancetype)initWithDict:(NSDictionary*)dict groupArray:(NSArray *)groupArray
{
    if (self = [super init]) {
        
        self.Id = dict[@"Id"];
        self.LogicalName = dict[@"LogicalName"];
        self.Attributes = dict[@"Attributes"];
        
        //将多个group中的formArray合并为一个group中的
        ZYFGroup *group = [[ZYFGroup alloc]init];
        NSMutableArray *formMutableArray = [NSMutableArray array];
        for (ZYFGroup *group in groupArray) {
            [formMutableArray addObjectsFromArray:group.formArray];
        }
        group.formArray = formMutableArray;
        
        //  将display中要求显示的attr解析到mutablearray中
        NSMutableArray *mutableArray = [NSMutableArray array];
        
        for (NSDictionary *dict in self.Attributes) {
            for (int i = 0; i < group.formArray.count; i ++) {
                ZYFForm *form = group.formArray[i];
                //只解析displaycols中要求显示的字段
                if ([dict[@"Key"] isEqualToString:form.ColsKey]) {
                    @try {
                        ZYFAttributes *attr = [ZYFAttributes attributesWithDict:dict valueType:form.ColsType];
                        [mutableArray addObject:attr];
                    }
                    @catch (NSException *exception) {
                        NSLog(@"sdlfjl");
                    }
                    @finally {
                    }
                }
            }
        }
        
        //  将已经解析出来的mutablearray中的attr，按顺序到orderarray中
        
        for (int i = 0; i < group.formArray.count; i++) {
            ZYFForm *form = group.formArray[i];
            NSString *keyString = form.ColsKey;
            BOOL isContain = [self isContainString:keyString attrArray:mutableArray];
            if (isContain) {
                
            }else{
                ZYFAttributes *nilAttr = [[ZYFAttributes alloc]initWithDict:nil valueType:nil];
                [self.orderArray addObject:nilAttr];
            }
        }
        
        self.attrArray = self.orderArray;
        
        NSMutableArray *fVArray = [NSMutableArray array];
        self.FormattedValues = dict[@"FormattedValues"];
        for (NSDictionary *dict in self.FormattedValues) {
            for (int i = 0; i < group.formArray.count; i ++) {
                //只解析displaycols中要求显示的字段
                ZYFForm *form = group.formArray[i];
                if ([dict[@"Key"] isEqualToString:form.ColsKey]) {
                    ZYFFormattedValue *formattedValue = [ZYFFormattedValue formattedWithDict:dict];
                    [fVArray addObject:formattedValue];
                }
            }
        }
        self.formatValueArray = fVArray;
    }

    return self;
}
-(NSMutableArray *)orderArray
{
    if (_orderArray == nil) {
        _orderArray = [NSMutableArray array];
    }
    return _orderArray;
}

/**
 *  判断attrArray数组中的字典的key是否包含keyString这个字符串
 *  @return YES表示包含，NO表示不包含
 */
-(BOOL)isContainString:(NSString *)keyString attrArray :(NSArray *)attrArray
{
    for (ZYFAttributes *attr in attrArray) {
        if ([attr.myKey isEqualToString:keyString]) {
            [self.orderArray addObject:attr];
            return YES;
        }
    }
    return NO;
}


+(instancetype)saleListWithDict:(NSDictionary*)dict displayCols:(ZYFDisplayCols*)displayCol
{
    return [[self alloc]initWithDict:dict displayCols:displayCol];
}

+(instancetype)saleListWithDict:(NSDictionary*)dict groupArray:(NSArray*)groupArray
{
    return [[self alloc]initWithDict:dict groupArray:groupArray];
}

@end
