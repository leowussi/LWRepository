//
//  SearchViewController.m
//  telecom
//
//  Created by 郝威斌 on 15/5/19.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "SearchViewController.h"
#import "UIViewExt.h"
#import "SearchTableViewCell.h"
#import "ResultTableViewCell.h"
#import "HistoryData.h"
#import "HIstoryObj.h"
#import "MyTaskListViewController.h"
#import "MapViewController.h"

#import "AllTaskViewController.h"
#import "NetworkDetailViewController.h"
#import "RoomDetailViewController.h"
#import "JuzhanDetailViewController.h"
#import "TemporaryViewController.h"
#import "LMapViewController.h"

@interface SearchViewController ()<UITextFieldDelegate,UISearchBarDelegate,UISearchControllerDelegate>
{
    UISearchBar *mySearchBar;
    UITextField *searchField;
//    NSArray *historyArr;
    NSMutableArray *historyArr;
    UIView *backView;
    HistoryData *historyData;
    NSString *typeStr;//搜索类型
    NSString *inTypeStr;//搜索类型
    NSString *nameStr;
    NSMutableArray *typeArr;
    NSMutableDictionary *dic;
    NSMutableArray *resultArr;//搜索请求的结果
}
@end

@implementation SearchViewController

-(void)viewWillAppear:(BOOL)animated
{
    [self hiddenBottomBar:YES];
    
}

-(void)creatSql
{
    //先获取存放数据库的路径
    NSString *string = [historyData getDocPath];
    NSLog(@"数据库存放的位置 %@",string);
    
    //判断数据库是否可以打开
    [historyData initData];
    
    //创建表
    [historyData creatDataTable];
    
    NSMutableArray *myArray = [historyData selectData];
    
    if (myArray.count == 0) {
        self.historyTableView.hidden = YES;
    }else{
        
        HIstoryObj *selectObj = [myArray objectAtIndex:0];
        NSLog(@"myArray == %@",selectObj.searchText);
        NSMutableArray *arr = (NSMutableArray *)[[myArray reverseObjectEnumerator] allObjects];
        
        for (int i = 0; i < arr.count ; i++) {
            NSLog(@"%@",[[arr objectAtIndex:i] searchText]);
            NSString *strText = [[arr objectAtIndex:i] searchText];
            [historyArr addObject:strText];
            
            NSLog(@"historyArr == %@",historyArr);
        }
    }
    
}

-(void)addLeftSearchBar
{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];//allocate titleView
    titleView.backgroundColor = [UIColor clearColor];
    UIImage *searchImg = [UIImage imageNamed:@"search_bg.png"];
    UIImageView *searchImgView = [[UIImageView alloc]initWithFrame:CGRectMake(-10, 7, kScreenWidth-120, searchImg.size.height/3+5)];
    searchImgView.image = searchImg;
    searchImgView.userInteractionEnabled = YES;
    [titleView addSubview:searchImgView];
    
    searchField = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, kScreenWidth-130, searchImg.size.height/3+5)];
    searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
    searchField.backgroundColor = [UIColor clearColor];
    searchField.returnKeyType = UIReturnKeySearch;
    searchField.placeholder = @"输入局站、地址";
    searchField.textColor = [UIColor whiteColor];
    searchField.delegate = self;
    searchField.enablesReturnKeyAutomatically = YES;
    searchField.font = [UIFont systemFontOfSize:15.0];
    [searchImgView addSubview:searchField];
    
    self.navigationItem.titleView = titleView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [_baseScrollView setBackgroundColor:RGBCOLOR(235, 238, 243)];
    [self addNavigationLeftButton];
    [self addNavigationRightButton:@"头像.png"];
    [self addLeftSearchBar];
    // Do any additional setup after loading the view.
    historyArr = [[NSMutableArray alloc]initWithCapacity:10];
    typeArr = [[NSMutableArray alloc]initWithCapacity:10];
    dic = [[NSMutableDictionary alloc]initWithCapacity:10];
    resultArr = [[NSMutableArray alloc]initWithCapacity:10];
    
    historyData = [[HistoryData alloc]init];
    [self creatSql];
    
    
    [self initView];
//    historyArr = @[@"国泰路",@"四平路",@"复旦光华"];
    UIView* backVi = [self tableFootView];
    self.historyTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 120, kScreenWidth-20, 44*8) style:UITableViewStylePlain];
    self.historyTableView.dataSource = self;
    self.historyTableView.delegate = self;
    self.historyTableView.tableFooterView = backVi;
     self.historyTableView.hidden = YES;
    [_baseScrollView addSubview:self.historyTableView];
    
    self.searchTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 120, kScreenWidth-20, 55*6) style:UITableViewStylePlain];
    self.searchTableView.dataSource = self;
    self.searchTableView.delegate = self;
    self.searchTableView.hidden = YES;
    [_baseScrollView addSubview:self.searchTableView];
    _baseScrollView.scrollEnabled = NO;
}

-(void)initView
{
    backView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, kScreenWidth-20, 90)];
    backView.backgroundColor = [UIColor whiteColor];
    [_baseScrollView addSubview:backView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 45, kScreenWidth-20, 1)];
    lineView.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0];
    [backView addSubview:lineView];
    
    //名字数组
    NSMutableArray *nameArr = [[NSMutableArray alloc] initWithObjects:@"故障",@"预约",@"隐患",@"周期工作",@"局站",@"机房",@"网元",@"临时任务",nil];
    
    //
    float buttonWidth = 0.0;
    float buttonTop = 12.0;
    
    for (int i = 0; i< nameArr.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        button.frame = CGRectMake(10 +buttonWidth, buttonTop, 100, 30);
        CGRect frame = [nameArr[i] boundingRectWithSize:CGSizeMake(1000, 25) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11.0]} context:nil];
        
        button.width = frame.size.width +35;
        buttonWidth += button.width +10;
        
        if (buttonWidth > self.view.width - 7) {
            button.left = 10;
            button.top = buttonTop +25 +15;
            buttonTop = button.top;
            buttonWidth = button.width +10;
        }
        
        button.titleEdgeInsets = (UIEdgeInsets){0,0,0,0};
        NSAttributedString *titltString = [[NSAttributedString alloc] initWithString:nameArr[i] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]}];
        [button setAttributedTitle:titltString forState:UIControlStateNormal];
        
        button.backgroundColor = [UIColor clearColor];
        [button addTarget:self action:@selector(buttonAciton:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:button];
        
        UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(5 +buttonWidth, buttonTop, 1, 30)];
        lineView1.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0];
        if (i == 3||i==7) {
            lineView1.hidden = YES;
        }
        [backView addSubview:lineView1];
        
        NSLog(@"%.2f",buttonTop);
        
    }
}


#pragma mark == 搜索历史
- (void)buttonAciton:(UIButton *)button
{
    NSLog(@"%ld",(long)button.tag);
    

    inTypeStr = [NSString stringWithFormat:@"%d",button.tag];
    
    button.selected = !button.selected;
    
    
    if (button.selected == YES) {
        //被选中了
        [button setBackgroundColor:[UIColor colorWithRed:139.0/255.0 green:206.0/255.0 blue:243.0/255.0 alpha:1.0]];
        
        if (button.tag == 0) {
            inTypeStr = @"2";
        }else if (button.tag == 1) {
            inTypeStr = @"3";
        }else if (button.tag == 2) {
            inTypeStr = @"4";
        }else if (button.tag == 3) {
            inTypeStr = @"1";
        }else if (button.tag == 4) {
            inTypeStr = @"5";
        }else if (button.tag == 5) {
            inTypeStr = @"6";
        }else if (button.tag == 6) {
            inTypeStr = @"7";
        }else if (button.tag == 7) {
            inTypeStr = @"10";
        }
        [typeArr removeAllObjects];
        NSString *strKey = [NSString stringWithFormat:@"%d",button.tag];
        [dic setObject:inTypeStr forKey:strKey];
        
//        [typeArr addObject:dic];
//        NSLog(@"typeArr == %@",typeArr);
        
        
    }
    else
    {
        [button setBackgroundColor:[UIColor whiteColor]];
        NSString *strKey = [NSString stringWithFormat:@"%d",button.tag];
        [dic removeObjectForKey:strKey];
        
    }

    [typeArr removeAllObjects];
    NSArray *keys = [dic allKeys];
    id key;
    
    for (int i = 0; i < [keys count]; i++) {
        key = [keys objectAtIndex:i];
        
        NSLog(@"Key:%@",key);
        
        [typeArr addObject:[dic objectForKey:key]];
        
    }
//    NSLog(@"typeArr==>%@",typeArr);
    typeStr = [typeArr componentsJoinedByString:@","];
    
    NSLog(@"typeStr ==%@",typeStr);

 
}

-(void)leftAction
{
    [searchField resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightAction
{
    NSLog(@"点击了头像");
    AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.menuController showRightController:YES];
}
-(void)updateTable
{

    
    NSMutableArray *myArray = [historyData selectData];
    
    if (myArray.count == 0) {
        self.historyTableView.hidden = YES;
    }else{
        
        [historyArr removeAllObjects];
//        HIstoryObj *selectObj = [myArray objectAtIndex:0];
//        NSLog(@"myArray == %@",selectObj.searchText);
        NSMutableArray *arr = (NSMutableArray *)[[myArray reverseObjectEnumerator] allObjects];
        
        for (int i = 0; i < arr.count ; i++) {
            NSLog(@"%@",[[arr objectAtIndex:i] searchText]);
            NSString *strText = [[arr objectAtIndex:i] searchText];
            [historyArr addObject:strText];
            
            NSLog(@"updataArr == %@",historyArr);
        }
        self.historyTableView.hidden = NO;
        [self.historyTableView reloadData];
    }
    
}
#pragma mark == UITextField
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.historyTableView.hidden = NO;
    self.searchTableView.hidden = YES;
    [self updateTable];
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    NSLog(@"%@",textField.text);
    
    
    if (textField.text == nil || textField.text.length <= 0 ) {
        
    }else if ([self isEmpty:textField.text]){
        
    }else{
       [historyData insertData:textField.text forPassWord:100];
        [self GetSearchResult:textField.text];
    }
    
    textField.text = @"";
    self.historyTableView.hidden = YES;
    return YES;
}

//
-(void)GetSearchResult :(NSString *)str
{
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    paraDict[URL_TYPE] = @"myInfo/GetSearchResult";
    paraDict[@"inParamName"] = str;
    DLog(@"%@",str);
    if (typeStr == nil) {
        paraDict[@"inType"] = @"1,2,3,4,5,6,7,10";
    }else{
        paraDict[@"inType"] = typeStr;
        DLog(@"%@",typeStr);
    }


    httpPOST(paraDict, ^(id result) {
        NSLog(@"%@",result);
        if ([result[@"result"] isEqualToString:@"0000000"]) {
            resultArr = [result objectForKey:@"list"];
            NSLog(@"%@",resultArr);
            if (resultArr.count == 0) {
                self.historyTableView.hidden = YES;
                self.searchTableView.hidden = YES;
            }else{
                self.historyTableView.hidden = YES;
                self.searchTableView.hidden = NO;
                [self.searchTableView reloadData];
            }
            
 
        }
    }, ^(id result) {

    });
    

}

-(BOOL) isEmpty:(NSString *) str {
    
    if (!str) {
        return true;
    } else {
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        
        NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
        
        if ([trimedString length] == 0) {
            return true;
        } else {
            return false;
        }
    }
}

- (UIView*)tableFootView
{
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-20, 30)];
    view.backgroundColor = [UIColor clearColor];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-20, 1)];
    lineView.backgroundColor = [UIColor colorWithRed:227.0/255.0 green:227.0/255.0 blue:229.0/255.0 alpha:1.0];
    [view addSubview:lineView];
    
    UIButton *deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 10, kScreenWidth-20, 20)];
    [deleteBtn setTitle:@"清除历史记录" forState:UIControlStateNormal];
    [deleteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    deleteBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [deleteBtn addTarget:self action:@selector(cleanBtn) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:deleteBtn];
    return view;
}

#pragma mark ==  UITableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView == self.historyTableView) {
        return historyArr.count;
    }else{
        return resultArr.count;
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.historyTableView) {
        return 44;
    }else{
        return 55;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.historyTableView) {
        
        static NSString *identifier = @"identifier";
        
        SearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[SearchTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        cell.titleLable.text = [historyArr objectAtIndex:indexPath.row];
        
        return cell;
        
    }else{

        static NSString *resultIdentifier = @"resultIdentifier";
        ResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:resultIdentifier];
        if (!cell) {
            cell = [[ResultTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:resultIdentifier];
                    }
        
//        cell.titleLable.text = [historyArr objectAtIndex:indexPath.row];
        NSString *strType;
        if ([[[resultArr objectAtIndex:indexPath.row] objectForKey:@"type"]isEqualToString:@"1"]) {
            strType = @"周期工作";
        }else if ([[[resultArr objectAtIndex:indexPath.row] objectForKey:@"type"]isEqualToString:@"2"]) {
            strType = @"故障";
        }else if ([[[resultArr objectAtIndex:indexPath.row] objectForKey:@"type"]isEqualToString:@"3"]) {
            strType = @"预约";
        }else if ([[[resultArr objectAtIndex:indexPath.row] objectForKey:@"type"]isEqualToString:@"4"]) {
            strType = @"隐患";
        }else if ([[[resultArr objectAtIndex:indexPath.row] objectForKey:@"type"]isEqualToString:@"5"]) {
            strType = @"局站";
        }else if ([[[resultArr objectAtIndex:indexPath.row] objectForKey:@"type"]isEqualToString:@"6"]) {
            strType = @"机房";
        }else if ([[[resultArr objectAtIndex:indexPath.row] objectForKey:@"type"]isEqualToString:@"7"]) {
            strType = @"网元";
        }else if ([[[resultArr objectAtIndex:indexPath.row] objectForKey:@"type"]isEqualToString:@"10"]) {
            strType = @"临时任务";
        }

        
        if ([strType isEqualToString:@"局站"] || [strType isEqualToString:@"机房"] || [strType isEqualToString:@"网元"] ) {
            
            cell.titleLable.textColor = [UIColor colorWithRed:54.0/255.0 green:129.0/255.0 blue:0.0/255.0 alpha:1.0];
            
            cell.titleLable.text = [NSString stringWithFormat:@"%@ (%@)",[[resultArr objectAtIndex:indexPath.row] objectForKey:@"siteName"],strType];
            
            NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:cell.titleLable.text];
            NSRange redRange = NSMakeRange(0, [[noteStr string] rangeOfString:@"("].location);
            [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.0/255.0 green:164.0/255.0 blue:233.0/255.0 alpha:1.0] range:redRange];
            cell.titleLable.attributedText = noteStr;
            
            cell.contentLable.text = [[resultArr objectAtIndex:indexPath.row] objectForKey:@"address"];
            
        }else{
            cell.titleLable.text = [NSString stringWithFormat:@"%@ (%@)",[[resultArr objectAtIndex:indexPath.row] objectForKey:@"siteName"],strType];
            
            NSMutableAttributedString *noteStr1 = [[NSMutableAttributedString alloc] initWithString:cell.titleLable.text];
            NSRange redRange1 = NSMakeRange(0, [[noteStr1 string] rangeOfString:@"("].location);
            [noteStr1 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.0/255.0 green:164.0/255.0 blue:233.0/255.0 alpha:1.0] range:redRange1];
            cell.titleLable.attributedText = noteStr1;
            
            cell.contentLable.text = [NSString stringWithFormat:@"%@ 未完成(%@)",[[resultArr objectAtIndex:indexPath.row] objectForKey:@"address"],[[resultArr objectAtIndex:indexPath.row] objectForKey:@"content"]];
        }
        
        if ([[[resultArr objectAtIndex:indexPath.row] objectForKey:@"smx"] isEqualToString:@""] && [[[resultArr objectAtIndex:indexPath.row] objectForKey:@"smy"] isEqualToString:@""]) {
            
            cell.leftBtn.hidden = YES;
            cell.leftImgView.image = [UIImage imageNamed:@"search_gray_btn.png"];
            
        }else{
            
            cell.leftBtn.hidden = NO;
            cell.leftBtn.tag = indexPath.row;
            [cell.leftBtn addTarget:self action:@selector(leftBtn:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        
        
 
        
        
        return cell;
    }
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == self.historyTableView) {
        
        [searchField resignFirstResponder];
        [self GetSearchResult:[historyArr objectAtIndex:indexPath.row]];
        
    }else{

        
//        1 周期工作   2故障       3预约       4隐患     5局站  6机房  7网元  10 临时任务
        
        if ([[[resultArr objectAtIndex:indexPath.row] objectForKey:@"type"]isEqualToString:@"1"]) {

            NSDictionary *paraDict = resultArr[indexPath.row];
            MyTaskListViewController *taskCtrl = [[MyTaskListViewController alloc] init];
            taskCtrl.site = paraDict;
            [self.navigationController pushViewController:taskCtrl animated:YES];

        }else if ([[[resultArr objectAtIndex:indexPath.row] objectForKey:@"type"]isEqualToString:@"2"]) {
            
            
            NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
            paraDict[URL_TYPE] = @"myTask/GetAllTaskInfo";
            paraDict[@"taskType"] = @"2";
            paraDict[@"regionId"] = resultArr[indexPath.row][@"siteId"];
            paraDict[@"curPage"] = @"1";
            paraDict[@"pageSize"] = @"10";
            
            
            httpPOST(paraDict, ^(id result) {
                NSLog(@"%@",result);
                if ([result[@"result"] isEqualToString:@"0000000"]){
                    
                    AllTaskViewController *allVC = [[AllTaskViewController alloc] init];
                    allVC.vcTag = 100;
                    allVC.allArr = [result objectForKey:@"list"];
                    allVC.strID = resultArr[indexPath.row][@"siteId"];
                    allVC.strType = @"2";
                    [self.navigationController pushViewController:allVC animated:YES];
                    
                }else{
                    
                }
                
            }, ^(id result) {
                
            });
            

            
        }else if ([[[resultArr objectAtIndex:indexPath.row] objectForKey:@"type"]isEqualToString:@"3"]) {
            
            NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
            paraDict[URL_TYPE] = @"myTask/GetAllTaskInfo";
            paraDict[@"taskType"] = @"3";
            paraDict[@"regionId"] = resultArr[indexPath.row][@"siteId"];
            paraDict[@"curPage"] = @"1";
            paraDict[@"pageSize"] = @"10";
            
            
            httpPOST(paraDict, ^(id result) {
                NSLog(@"%@",result);
                if ([result[@"result"] isEqualToString:@"0000000"]){
                    
                    AllTaskViewController *allVC = [[AllTaskViewController alloc] init];
                    allVC.vcTag = 100;
                    allVC.allArr = [result objectForKey:@"list"];
                    allVC.strID = resultArr[indexPath.row][@"siteId"];
                    allVC.strType = @"3";
                    [self.navigationController pushViewController:allVC animated:YES];
                    
                }else{
                    
                }
                
            }, ^(id result) {
                
            });

            
        }else if ([[[resultArr objectAtIndex:indexPath.row] objectForKey:@"type"]isEqualToString:@"4"]) {
            
            
            NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
            paraDict[URL_TYPE] = @"myTask/GetAllTaskInfo";
            paraDict[@"taskType"] = @"4";
            paraDict[@"regionId"] = resultArr[indexPath.row][@"siteId"];
            paraDict[@"curPage"] = @"1";
            paraDict[@"pageSize"] = @"10";
            
            
            httpPOST(paraDict, ^(id result) {
                NSLog(@"%@",result);
                if ([result[@"result"] isEqualToString:@"0000000"]){
                    
                    AllTaskViewController *allVC = [[AllTaskViewController alloc] init];
                    allVC.vcTag = 100;
                    allVC.allArr = [result objectForKey:@"list"];
                    allVC.strID = resultArr[indexPath.row][@"siteId"];
                    allVC.strType = @"4";
                    [self.navigationController pushViewController:allVC animated:YES];
                    
                }else{
                    
                }
                
            }, ^(id result) {
                
            });

            
        }else if ([[[resultArr objectAtIndex:indexPath.row] objectForKey:@"type"]isEqualToString:@"5"]) {
            
            NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
            paraDict[URL_TYPE] = @"myRegion/GetRegionById";
            paraDict[@"regionId"] = resultArr[indexPath.row][@"siteId"];
            
            
            httpGET2(paraDict, ^(id result) {
                NSLog(@"%@",result);
                if ([result[@"result"] isEqualToString:@"0000000"])
                {
                    JuzhanDetailViewController *judVC = [[JuzhanDetailViewController alloc]init];
                    judVC.dic = [result objectForKey:@"detail"];
                    [self.navigationController pushViewController:judVC animated:YES];
                    
                }else{
                }
                
            }, ^(id result) {
                
            });

            
        }else if ([[[resultArr objectAtIndex:indexPath.row] objectForKey:@"type"]isEqualToString:@"6"]) {
            
            NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
            paraDict[URL_TYPE] = @"myRegion/GetRoomById";
            paraDict[@"roomId"] = resultArr[indexPath.row][@"roomId"];
            
            
            httpGET2(paraDict, ^(id result) {
                NSLog(@"%@",result);
                if ([result[@"result"] isEqualToString:@"0000000"])
                {
                    
                    RoomDetailViewController *roomVC = [[RoomDetailViewController alloc]init];
                    roomVC.dataArr = [result objectForKey:@"detail"];
                    [self.navigationController pushViewController:roomVC animated:YES];
                    
                }else{
                    
                }
                
            }, ^(id result) {
                
            });
            
        }else if ([[[resultArr objectAtIndex:indexPath.row] objectForKey:@"type"]isEqualToString:@"7"]) {
            

            NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
            paraDict[URL_TYPE] = @"myRegion/GetNuById";
            paraDict[@"nuId"] = resultArr[indexPath.row][@"nuId"];
            
            httpGET2(paraDict, ^(id result) {
                NSLog(@"%@",result);
                if ([result[@"result"] isEqualToString:@"0000000"])
                {
                    NetworkDetailViewController *netWorkVC = [[NetworkDetailViewController alloc]init];
                    netWorkVC.dictionary = [result objectForKey:@"detail"];
                    [self.navigationController pushViewController:netWorkVC animated:YES];
                    
                }else{
                }
                
            }, ^(id result) {
                
            });

        }else if ([[[resultArr objectAtIndex:indexPath.row] objectForKey:@"type"]isEqualToString:@"10"]) {
            
            NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
            paraDict[URL_TYPE] = @"myTask/GetAllTaskInfo";
            paraDict[@"regionId"] = resultArr[indexPath.row][@"siteId"];
            paraDict[@"taskType"] = @"10";
            paraDict[@"curPage"] = @"1";
            paraDict[@"pageSize"] = @"10";
            
            NSLog(@"%@",paraDict);
            httpPOST(paraDict, ^(id result) {
                NSLog(@"%@",result);
                if ([result[@"result"] isEqualToString:@"0000000"])
                {
                    
                    TemporaryViewController *temVC = [[TemporaryViewController alloc]init];
                    temVC.temArr = [result objectForKey:@"list"];
                    temVC.vcTag = 10;
                    temVC.strSearch = [NSString stringWithFormat:@"%@",resultArr[indexPath.row][@"siteId"]];
                    
                    [self.navigationController pushViewController:temVC animated:YES];
                    
                    
                }else{
                    
                }
                
            }, ^(id result) {
                
            });
        }

    }
}

#pragma mark == 点击UITableView 左侧按钮
-(void)leftBtn:(UIButton *)sender
{
    //需要参数   inType  左右上下经度  //myInfo/GetNearbyResult.json附近任务接口
    NSLog(@"%d",sender.tag);

    LMapViewController *mapView = [[LMapViewController alloc]init];
//    DLog(@"%@",resultArr);

    //strType包含搜索出来所有任务类型
    mapView.inType =[[resultArr objectAtIndex:sender.tag] objectForKey:@"type"];
    mapView.strType1 = typeStr;
    //设置中心点坐标
    mapView.strSmx = [[resultArr objectAtIndex:sender.tag] objectForKey:@"smx"];
    mapView.strSmy = [[resultArr objectAtIndex:sender.tag] objectForKey:@"smy"];
    
    NSUserDefaults *user1 = [NSUserDefaults standardUserDefaults];
    [user1 setObject:typeStr forKey:@"typeStr"];
    DLog(@"%@",typeStr);
    mapView.dict=[resultArr objectAtIndex:sender.tag];
    [self.navigationController pushViewController:mapView animated:YES];
    
}


-(void)cleanBtn
{
    NSLog(@"点击了清空按钮");
    for (int i = 0; i < historyArr.count; i++) {
        [historyData deleteTestList:i+1];
    }
    [historyArr removeAllObjects];
    self.historyTableView.hidden = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
