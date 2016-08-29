//
//
//  Created by apple on 14-4-3.
//  Copyright (c) 2014年 itcast. All rights reserved.
//
#import "TableSearchController.h"
#import "MJFriendGroup.h"
#import "MJFriend.h"
#import "MJHeaderView.h"
#import "MJFriendCell.h"
#import "ZYFHttpTool.h"
#import "MBProgressHUD+MJ.h"
#import "ZYFURLTableSearch.h"
#import "GDataXMLNode.h"
#import "ZYFSaleList.h"
#import "ZYFGroup.h"
#import "ZYFForm.h"
#import "ListController.h"

@interface TableSearchController () <MJHeaderViewDelegate>
@property (nonatomic, strong) NSArray *groups;
@end

@implementation TableSearchController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 每一行cell的高度
    self.tableView.rowHeight = 44;
    // 每一组头部控件的高度
    self.tableView.sectionHeaderHeight = 60;
    
    //为了防止导航栏遮住最上面的那个分组
    self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 44)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    self.title = @"表单分类";
    
    [self getDataFromServer];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //隐藏底部导航栏
    self.tabBarController.tabBar.hidden = YES;
}



- (void)getDataFromServer
{
    [MBProgressHUD showMessage:nil toView:self.view];
//    NSString *urlString = @"http://100.100.100.68:61113/api/Test/GetAppForm";
    NSString *urlString = kTableSearchForm;
    
    [ZYFHttpTool getWithURL:urlString params:nil success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingMutableLeaves   error:nil];
        // xml部分
        NSString *formString = dictionary[@"Msg"];
        NSArray *groupArray = [self XmlData:formString];
        self.groups = groupArray;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (NSArray *)XmlData:(NSString *)formString
{
    // 加载整个XML数据
    NSError *error = [[NSError alloc]init];
    GDataXMLDocument *doc = [[GDataXMLDocument alloc]initWithXMLString:formString encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        ZYFLog(@"error = %@",error);
    }
    
    // 获得文档的根元素 -- Group元素
    GDataXMLElement *root = doc.rootElement;
    // 获得根元素里面的所有元素
    NSArray *elements = [root elementsForName:@"Module"];
    
    // 遍历所有的video元素
    NSMutableArray *groupArray = [NSMutableArray array];
    for (GDataXMLElement *groupElement in elements) {
        ZYFGroup *group = [[ZYFGroup alloc]init];
        group.name = [[groupElement attributeForName:@"name"] stringValue];
        NSArray *formxmls = [groupElement elementsForName:@"Formxml"];

        NSMutableArray *formArray = [NSMutableArray array];
        for (GDataXMLElement *formXmlElement in formxmls) {
            ZYFForm *form = [[ZYFForm alloc]init];
            // 取出元素的属性
//            GDataXMLElement *relateElement = [[formElement elementsForName:@"Formxml"]objectAtIndex:0] ;
            ZYFRelateEntity *relateEntity = [[ZYFRelateEntity alloc]init];
            relateEntity.scheamname = [[formXmlElement attributeForName:@"name"]stringValue];
            relateEntity.logicalname = [[formXmlElement attributeForName:@"logicalname"]stringValue];
            relateEntity.formxml = [[formXmlElement attributeForName:@"formxml"]stringValue];
            relateEntity.icon = [[formXmlElement attributeForName:@"ico"]stringValue];
            relateEntity.type = [[formXmlElement attributeForName:@"type"]stringValue];

            
            form.relateEntity = relateEntity;
            [formArray addObject:form];
        }
        group.formArray = formArray;
        
        [groupArray addObject:group];
    }
    return (NSArray *)groupArray;
}


- (NSArray *)groups
{
    if (_groups == nil) {
        _groups = [NSArray array];
    }
    return _groups;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - 数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    ZYFGroup *group = self.groups[section];
    return (group.isOpened ? group.formArray.count : 0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.创建cell
    MJFriendCell *cell = [MJFriendCell cellWithTableView:tableView];
    
    // 2.设置cell的数据
    ZYFGroup *group = self.groups[indexPath.section];
    ZYFForm *form = group.formArray[indexPath.row];
    cell.form = form;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZYFGroup *group = self.groups[indexPath.section];
    ZYFForm *form = group.formArray[indexPath.row];
    NSString *urlStr = kTableSearchMain;
    NSString *urlString = [NSString stringWithFormat:@"%@?formxml=%@",urlStr,form.relateEntity.formxml];
    
    if (form.relateEntity.type == nil || form.relateEntity.type.length <= 0 || [form.relateEntity.type isEqualToString:@"1"]) {
        //通过表单页面来查询
        ListController *listCtrl = [[ListController alloc]init];
        listCtrl.urlString = urlString;
        UITableViewCell *currentCell = [self.tableView cellForRowAtIndexPath:indexPath];
        listCtrl.titleString = currentCell.textLabel.text;
        [self.navigationController pushViewController:listCtrl animated:YES];
    }else{
        //通过浏览器打开
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:form.relateEntity.formxml]];
    }

}

/**
 *  返回每一组需要显示的头部标题(字符出纳)
 */
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // 1.创建头部控件
    MJHeaderView *header = [MJHeaderView headerViewWithTableView:tableView];
    header.delegate = self;
    
    // 2.给header设置数据(给header传递模型)
    header.group = self.groups[section];
    
    return header;
}

#pragma mark - headerView的代理方法
/**
 *  点击了headerView上面的名字按钮时就会调用
 */
- (void)headerViewDidClickedNameView:(MJHeaderView *)headerView
{
    [self.tableView reloadData];
}
@end
