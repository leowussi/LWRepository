//
//  ZYFEditStringController.m
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/7/8.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import "ZYFEditStringController.h"
#import "CRMHelper.h"

@interface ZYFEditStringController ()
//保存的字符串
@property (nonatomic,copy) NSString *finishedString;

@end

@implementation ZYFEditStringController

-(void)loadView
{
    self.tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
        
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(save)];
    saveItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = saveItem;
    
}
/**
 *  重写touchBegin 方法是不行的，在UITableView/UIScrollView中
 */
//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [self.tableView endEditing:YES];
//}

-(void)save
{
    NSLog(@"%s,save",__func__)  ;
    if ([self.delegate respondsToSelector:@selector(editStringController:editString:)]) {
        NSIndexPath *indexPath =[NSIndexPath indexPathForRow:0 inSection:0];
        ZYFEditableCell *cell = (ZYFEditableCell*)[self.tableView cellForRowAtIndexPath:indexPath];
        [self.delegate editStringController:self editString:cell.textfield.text];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZYFEditableCell *cell = [[ZYFEditableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    if (self.isShowNumKeyboard) {
        cell.showNumKeyboard = YES;
    }
    if (self.cellData.count > 0) {
        cell.label.text = self.cellData[0];
        cell.textfield.text = self.cellData[1];
        cell.textfield.textColor = [UIColor grayColor];
        cell.textfield.font = [UIFont systemFontOfSize:18.0];

    }

    self.cell = cell;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.cell.textfield becomeFirstResponder];

}



@end
