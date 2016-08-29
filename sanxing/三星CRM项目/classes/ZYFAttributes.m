//
//  ZYFAttributes.m
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/7/2.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import "ZYFAttributes.h"
#import "CRMHelper.h"

@implementation ZYFAttributes

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.myKey forKey:@"myKey"];
    [encoder encodeObject:self.myValueString forKey:@"myValueString"];
    [encoder encodeObject:self.myDateTime forKey:@"myDateTime"];
    [encoder encodeObject:self.lookUp forKey:@"lookUp"];
    [encoder encodeObject:self.pickList forKey:@"pickList"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.myKey = [decoder decodeObjectForKey:@"myKey"];
        self.myValueString = [decoder decodeObjectForKey:@"myValueString"];
        self.myDateTime = [decoder decodeObjectForKey:@"myDateTime"];
        self.lookUp = [decoder decodeObjectForKey:@"lookUp"];
        self.pickList = [decoder decodeObjectForKey:@"pickList"];
    }
    return self;
}


-(instancetype)initWithDict:(NSDictionary*)dict valueType:(NSString*)valueType
{
    ZYFLog(@"valueType == %@",valueType);
    if (self = [super init]) {
        self.myKey = dict[@"Key"];
        //下面也可以根据传过来的类型来判断
        if ([valueType isEqualToString:@"string"]) {
//            if ([self.myKey rangeOfString:@"."].location != NSNotFound) {
//                NSDictionary *dictString = dict[@"Value"];
//                NSString *NSNumberTypeToNSString = [NSString stringWithFormat:@"%@",dictString[@"Value"]];
//
//                self.myValueString = NSNumberTypeToNSString;
//            }else{
                //将服务器穿过来的NSNumber类型转换为NSString类型
                NSString *NSNumberTypeToNSString = [NSString stringWithFormat:@"%@",dict[@"Value"]];
                self.myValueString = NSNumberTypeToNSString;
//            }

            
        }else if ([valueType isEqualToString: @"lookup"]){
            ZYFLookUp *lookUp = [[ZYFLookUp alloc]initWithDict:dict[@"Value"]];
            self.lookUp = lookUp;
        }else if ([valueType isEqualToString:@"picklist"]){
            ZYFPickList *pickList = [ZYFPickList pickListWithDict:dict[@"Value"]];
            self.pickList = pickList;
        }else if([valueType isEqualToString:@"datetime"]){
            self.myDateTime = dict[@"Value"];
            self.myDateTime = [self formatedDateString:self.myDateTime];
        }else  if ([valueType isEqualToString:@"stringtel"] || [valueType isEqualToString:@"stringemail"] || [valueType isEqualToString:@"stringurl"]) {
            //将服务器穿过来的NSNumber类型转换为NSString类型
            NSString *NSNumberTypeToNSString = [NSString stringWithFormat:@"%@",dict[@"Value"]];
            self.myValueString = NSNumberTypeToNSString;
        }else if([valueType isEqualToString:@"stringtestarea"]){
            //将服务器穿过来的NSNumber类型转换为NSString类型
            NSString *NSNumberTypeToNSString = [NSString stringWithFormat:@"%@",dict[@"Value"]];
            self.myValueString = NSNumberTypeToNSString;
        }else if([valueType isEqualToString:@"picklistbool"]){
            //将服务器穿过来的NSNumber类型转换为NSString类型
            NSString *NSNumberTypeToNSString = [NSString stringWithFormat:@"%@",dict[@"Value"]];
            self.myValueString = NSNumberTypeToNSString;
        }else if([valueType isEqualToString:@"wholenumber"]){
            //将服务器穿过来的NSNumber类型转换为NSString类型
            NSString *NSNumberTypeToNSString = [NSString stringWithFormat:@"%@",dict[@"Value"]];
            self.myValueString = NSNumberTypeToNSString;
        }else if([valueType isEqualToString:@"decimal"]){
            //将服务器穿过来的NSNumber类型转换为NSString类型
            NSString *NSNumberTypeToNSString = [NSString stringWithFormat:@"%@",dict[@"Value"]];
            self.myValueString = NSNumberTypeToNSString;
        }else if([valueType isEqualToString:@"float"]){
            //将服务器穿过来的NSNumber类型转换为NSString类型
            NSString *NSNumberTypeToNSString = [NSString stringWithFormat:@"%@",dict[@"Value"]];
            self.myValueString = NSNumberTypeToNSString;
        }else if([valueType isEqualToString:@"status"]){
            NSString *NSNumberTypeToNSString = [NSString stringWithFormat:@"%@",dict[@"Value"]];
            ZYFPickList *pickList = [ZYFPickList pickListWithDict:dict[@"Value"]];
            self.pickList = pickList;
        }
        else{
            NSLog(@"显示的是一个未先定义的类型，请和后端协商好==%@",self.myKey);
        }
    }
    return self;
}

-(NSString *)formatedDateString:(NSString *)str
{
    if (str.length > 0) {
        NSRange range = NSMakeRange(0, 10);
        str =[str substringWithRange:range];
//        return str;
    }
    return str;

}

+(instancetype)attributesWithDict:(NSDictionary*)dict valueType:(NSString*)valueType
{
    return [[self alloc]initWithDict:dict valueType:valueType];
}


@end
