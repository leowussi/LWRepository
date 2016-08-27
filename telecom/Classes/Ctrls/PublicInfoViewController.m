

#import "PublicInfoViewController.h"

#import "GongGaoViewController.h"
#import "PublicInfoTableViewCell.h"
#import "JuzhanDetailViewController.h"
#import "PullTableView.h"
#import "GeJieGongGaoViewController.h"
#import "ScreenTableViewController.h"

@interface PublicInfoViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,PullTableViewDelegate>
{
    PullTableView *myTableView;
    NSString *strName;
    NSMutableArray *dataArr;
}

@end
static int a = 1;
@implementation PublicInfoViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hiddenBottomBar:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationLeftButton];
    
    UIImage* filterimage = [UIImage imageNamed:@"shaixuan.png"];
    UIButton* filter = [[UIButton alloc] initWithFrame:RECT((APP_W-10-30), (NAV_H-30)/2,
                                                            30, 30)];
    [filter setBackgroundImage:filterimage forState:0];
    [filter addTarget:self action:@selector(onClearBtnTouched) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBtnItem1 = [[UIBarButtonItem alloc] initWithCustomView:filter];
    self.navigationItem.rightBarButtonItem=barBtnItem1;
    
    
    self.title = @"公告信息";
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGBCOLOR(235, 238, 243);
    
    _baseScrollView.backgroundColor = RGBCOLOR(235, 238, 243);
    
    dataArr = [[NSMutableArray alloc]initWithCapacity:10];
    
    [self initView];
    [self loadData];
}
#pragma mark  搜索选项
-(void)onClearBtnTouched{
    ScreenTableViewController *screen = [[ScreenTableViewController alloc]init];
    screen.screen= ^(NSString *noteType,NSString *specType){
        NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
        paraDict[URL_TYPE] = @"myInfo/GetNotePageList";
        paraDict[@"noteType"] = noteType;
        paraDict[@"specType"] = specType;
        paraDict[@"curPage"] = @"1";
        paraDict[@"pageSize"] = @"10";
        DLog(@"%@",paraDict);
        httpPOST(paraDict, ^(id result) {
            NSLog(@"%@",result);
            if ([result[@"result"] isEqualToString:@"0000000"])
            {   strName = @"";
                dataArr = [result objectForKey:@"list"];
                myTableView.hidden = NO;
                [myTableView reloadData];
                DLog(@"%@",dataArr);
            }else{
                myTableView.hidden = YES;
            }
            
        }, ^(id result) {
            
        });
        
        
        
    };
    
    
    
    [self.navigationController pushViewController:screen animated:YES];
}

#pragma mark  进入页面就加载数据
-(void)loadData
{    self.vcTag = 10000;
    httpGET2(@{URL_TYPE : @"myInfo/GetNotePageList"}, ^(id result) {
        if ([result[@"result"] isEqualToString:@"0000000"]) {
            dataArr = [result objectForKey:@"list"];
            myTableView.hidden = NO;
            DLog(@"%@",dataArr);
            [myTableView reloadData];
        }
    }, ^(id result) {
        
    });
}

-(void)initView
{
    
    UILabel *rightLable = [[UILabel alloc]initWithFrame:CGRectZero];
    rightLable.text = @"      ";
    [rightLable setFont:[UIFont systemFontOfSize:13.0]];
    rightLable.alpha = 0.5;
    [rightLable sizeToFit];
    
    UITextField *seaFiled = [[UITextField alloc]initWithFrame:CGRectMake(30, 80, kScreenWidth-60, 28)];
    seaFiled.backgroundColor = [UIColor whiteColor];
    seaFiled.placeholder = @"请输入公告标题";
    seaFiled.font = [UIFont systemFontOfSize:13.0];
    seaFiled.rightViewMode = UITextFieldViewModeAlways;
    seaFiled.rightView = rightLable;
    seaFiled.layer.borderColor = [[UIColor colorWithRed:215.0 / 255.0 green:215.0 / 255.0 blue:215.0 / 255.0 alpha:1] CGColor];
    seaFiled.layer.borderWidth = 0.6f;
    seaFiled.layer.cornerRadius = 14.0f;
    seaFiled.delegate = self;
    seaFiled.returnKeyType = UIReturnKeySearch;
    [self.view addSubview:seaFiled];
    
    UIImage *btnImg = [UIImage imageNamed:@"2.9.png"];
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setImage:btnImg forState:UIControlStateNormal];
    [searchBtn setFrame:CGRectMake(kScreenWidth-30-btnImg.size.width/2, 80, btnImg.size.width/2, btnImg.size.height/1.9)];
    [searchBtn addTarget:self action:@selector(searchBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchBtn];
    
    UIImage *seaImg = [UIImage imageNamed:@"sea.png"];
    UIImageView *seaImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 1, seaImg.size.width/2, seaImg.size.height/2)];
    seaImgView.image = seaImg;
    [searchBtn addSubview:seaImgView];
    
    UIView *backview = [[UIView alloc]initWithFrame:CGRectMake(10, 120, kScreenWidth-20, kScreenHeight-64-120)];
    backview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backview];
    
    myTableView = [[PullTableView alloc]initWithFrame:CGRectMake(5, 0, kScreenWidth-30, kScreenHeight-64-120) style:UITableViewStylePlain];
    myTableView.dataSource = self;
    myTableView.delegate = self;
    myTableView.pullDelegate = self;
    myTableView.showsVerticalScrollIndicator = NO;
    if (self.vcTag == 100) {
        dataArr = (NSMutableArray *)self.juzArr;
        myTableView.hidden = NO;
    }else{
        myTableView.hidden = YES;
    }
    
    [backview addSubview:myTableView];
    
}

#pragma mark == 搜素
-(void)searchBtn
{
    self.vcTag = 10000;
    if (strName == nil || strName.length <= 0) {
        [self loadData];
    }else{
        
        NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
        paraDict[URL_TYPE] = @"myInfo/GetNotePageList";
        paraDict[@"noteType"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"noteType"];
        paraDict[@"specType"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"specType"];
        paraDict[@"name"] = strName;
        paraDict[@"curPage"] = @"1";
        paraDict[@"pageSize"] = @"10";
        
        httpPOST(paraDict, ^(id result) {
            NSLog(@"%@",result);
            if ([result[@"result"] isEqualToString:@"0000000"])
            {   strName = @"";
                dataArr = [result objectForKey:@"list"];
                myTableView.hidden = NO;
                [myTableView reloadData];
                DLog(@"%@",dataArr);
            }else{
                myTableView.hidden = YES;
            }
            
        }, ^(id result) {
            
        });
        
    }
    
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    strName = textField.text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    strName = textField.text;
    [textField resignFirstResponder];
    textField.text = @"";
    [self searchBtn];
    return YES;
}


#pragma mark == UITableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indentifier = @"juidentifier1";
    PublicInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[PublicInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    
    
    CGSize with = [self labelHight:[[[dataArr objectAtIndex:indexPath.row] objectForKey:@"createdDate"] description]];
    
    CGSize with1 =with;
    CGSize with2 =with;
    CGSize with3 =with;
    CGSize with4 =with;
    CGSize with5 =with;
    
    cell.bgV.frame = CGRectMake(0, 10, kScreenWidth-30, with.height+5);
    cell.bgV1.frame = CGRectMake(0, 38+with1.height, kScreenWidth-30, with2.height+5);//5
    cell.bgV2.frame = CGRectMake(0, 55+with1.height+with2.height+with3.height, kScreenWidth-30, with4.height+5);
    
    cell.leftLable.frame  = CGRectMake(10, 10, 80, 20);
    cell.leftLable1.frame = CGRectMake(10, 15+with.height, 80, 20);
    cell.leftLable2.frame = CGRectMake(10, 35+with1.height, 80, 20);
    cell.leftLable3.frame = CGRectMake(10, 48+with1.height*2, 80, with3.height);
    cell.leftLable6.frame = CGRectMake(10, 58+with1.height*3, 80, with4.height);
    cell.leftLable7.frame = CGRectMake(10, 68+with1.height*4, 80, with5.height);
    cell.leftLable4.frame = CGRectMake(10, 78+with1.height*5, 80, with5.height);
    cell.leftLable5.frame = CGRectMake(10, 88+with1.height*6, 80, with5.height);
    
    cell.qujuLable.numberOfLines = 1;
    cell.nameLable.numberOfLines = 1;
    cell.addressLable.numberOfLines = 1;
    cell.yongtuLable.numberOfLines = 1;
    cell.XLable.numberOfLines = 1;
    cell.YLable.numberOfLines = 1;
    cell.LqLable1.numberOfLines = 1;
    cell.LLQable.numberOfLines = 1;
    
    cell.qujuLable.frame = CGRectMake(80, 10, kScreenWidth-120, with.height);
    cell.nameLable.frame = CGRectMake(80, 17+with.height, kScreenWidth-120, with1.height);
    cell.addressLable.frame = CGRectMake(80, 37+with1.height, kScreenWidth-120, with2.height);
    cell.yongtuLable.frame = CGRectMake(80, 47+with1.height+with2.height, kScreenWidth-120, with3.height);
    cell.XLable.frame = CGRectMake(80, 57+with1.height+with2.height+with3.height, kScreenWidth-120, with4.height);
    cell.YLable.frame = CGRectMake(80, 67+with1.height+with2.height+with3.height+with4.height, kScreenWidth-120, with5.height);
    cell.LLQable.frame = CGRectMake(80, 77+with1.height*5, kScreenWidth-120, with5.height);
    cell.LqLable1.frame = CGRectMake(80, 87+with1.height*6, kScreenWidth-120, with5.height);
    
    if ([[[[dataArr objectAtIndex:indexPath.row] objectForKey:@"createdDate"] description]isEqualToString:@"<null>"]) {
        cell.qujuLable.text = @"";
    }else{
        cell.qujuLable.text = [[[dataArr objectAtIndex:indexPath.row] objectForKey:@"createdDate"] description];
    }
    
    
    if ([[[[dataArr objectAtIndex:indexPath.row] objectForKey:@"endDate"] description]isEqualToString:@"<null>"]) {
        cell.nameLable.text = @"";
    }else{
        cell.nameLable.text = [[[dataArr objectAtIndex:indexPath.row] objectForKey:@"endDate"] description];
    }
    
    
    if ([[[[dataArr objectAtIndex:indexPath.row] objectForKey:@"createdBy"] description]isEqualToString:@"<null>"]) {
        cell.addressLable.text = @"";
    }else{
        cell.addressLable.text = [[[dataArr objectAtIndex:indexPath.row] objectForKey:@"createdBy"] description];
    }
    
    
    if ([[[[dataArr objectAtIndex:indexPath.row] objectForKey:@"noteType"] description] isEqualToString:@"1"]) {
        cell.yongtuLable.text =@"割接公告";
    }else{
        cell.yongtuLable.text = @"普通公告";
    }
    
    if ([[[[dataArr objectAtIndex:indexPath.row] objectForKey:@"region"] description]isEqualToString:@"<null>"]) {
        cell.XLable.text = @"";
    }else{
        cell.XLable.text = [[[dataArr objectAtIndex:indexPath.row] objectForKey:@"region"] description];
    }
    
    
    if ([[[[dataArr objectAtIndex:indexPath.row] objectForKey:@"spec"] description]isEqualToString:@"<null>"]) {
        cell.YLable.text = @"";
    }else{
        cell.YLable.text = [[[dataArr objectAtIndex:indexPath.row] objectForKey:@"spec"] description];
    }
    
    if ([[[[dataArr objectAtIndex:indexPath.row] objectForKey:@"theme"] description]isEqualToString:@"<null>"]) {
        cell.LLQable.text = @"";
    }else{
        cell.LLQable.text = [[[dataArr objectAtIndex:indexPath.row] objectForKey:@"theme"] description];
    }
    
    if ([[[[dataArr objectAtIndex:indexPath.row] objectForKey:@"noteContent"] description]isEqualToString:@"<null>"]) {
        cell.LqLable1.text = @"";
    }else{
        cell.LqLable1.text = [[[dataArr objectAtIndex:indexPath.row] objectForKey:@"noteContent"] description];
    }
    
    DLog(@"%@",dataArr);
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //区局
    CGSize with = [self labelHight:[[[dataArr objectAtIndex:indexPath.row] objectForKey:@"createdDate"] description]];
    
    return 80+with.height*8;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([[[[dataArr objectAtIndex:indexPath.row] objectForKey:@"noteType"] description]isEqualToString:@"1"]) {//割接公告
        [ self httpSend:dataArr[indexPath.row][@"noteId"]];
    }else{
        GongGaoViewController *gongVC = [[GongGaoViewController alloc]init];//普通公告
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *dic in dataArr) {
            if ([dic[@"noteType"] isEqualToString:@"0"]) {
                [arr addObject:dic];
            }
        }
        gongVC.dataArr = arr;
        gongVC.Index = indexPath.row;
        DLog(@"%ld",(long)indexPath.row);
        [self.navigationController pushViewController:gongVC animated:YES];
    }
    
}

-(void)httpSend:(NSString *)ID{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[URL_TYPE] = @"myInfo/GetCutOverList";
    dic[@"id"] = ID;
    GeJieGongGaoViewController *gongVC = [[GeJieGongGaoViewController alloc]init];
    httpGET1(dic, ^(id result) {
        if ([result[@"result"] isEqualToString:@"0000000"]) {
            gongVC.infoDic= [NSMutableDictionary dictionaryWithDictionary:result[@"detail"]];
            gongVC.shebeiArray = result[@"deviceList"];
            gongVC.liuZhuang = result[@"logList"];
            [self.navigationController pushViewController:gongVC animated:YES];
        }
    });
}


#pragma mark - 上拉
- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    
    [self performSelector:@selector(refreshTable) withObject:nil afterDelay:3.0f];
}

- (void) refreshTable
{
    a = 1;
    NSString* str = [NSString stringWithFormat:@"%d",a];
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    paraDict[URL_TYPE] = @"myInfo/GetNotePageList";
    paraDict[@"noteType"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"noteType"];
    paraDict[@"specType"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"specType"];
    if (self.vcTag == 100) {
        paraDict[@"regionIds"] = self.strID;
    }else{
        paraDict[@"name"] = strName;
    }
    
    paraDict[@"curPage"] = str;
    paraDict[@"pageSize"] = @"10";
    
    [dataArr removeAllObjects];
    
    httpPOST(paraDict, ^(id result) {
        NSLog(@"%@",result);
        if ([result[@"result"] isEqualToString:@"0000000"])
        {
            
            dataArr = [result objectForKey:@"list"];
            myTableView.hidden = NO;
            [myTableView reloadData];
            
        }else{
            myTableView.hidden = YES;
        }
        
    }, ^(id result) {
        
    });
    
    myTableView.pullTableIsRefreshing = NO;
}

#pragma mark - 下拉
- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    [self performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:3.0f];
}

- (void) loadMoreDataToTable
{
    a++;
    NSString* str = [NSString stringWithFormat:@"%d",a];
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    paraDict[URL_TYPE] = @"myInfo/GetNotePageList";
    paraDict[@"noteType"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"noteType"];
    paraDict[@"specType"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"specType"];
    
    
    
    if (self.vcTag == 100) {
        paraDict[@"regionIds"] = self.strID;
    }else{
        paraDict[@"name"] = strName;
    }
    
    paraDict[@"curPage"] = str;
    paraDict[@"pageSize"] = @"10";
    
    httpPOST(paraDict, ^(id result) {
        NSLog(@"%@",result);
        if ([result[@"result"] isEqualToString:@"0000000"])
        {
            NSArray *arr = [result objectForKey:@"list"];
            [dataArr addObjectsFromArray:arr];
            [myTableView reloadData];
            
        }else{
            myTableView.hidden = YES;
        }
        
    }, ^(id result) {
        
    });
    myTableView.pullTableIsLoadingMore = NO;
}


- (CGSize)labelHight:(NSString*)str
{
    UIFont *font = [UIFont systemFontOfSize:12.0];
    CGSize constraint = CGSizeMake(kScreenWidth-120, 20000.0f);
    CGSize size = [str sizeWithFont:font constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping| NSLineBreakByTruncatingTail];
    return size;
}



@end
