//
//  ProductListViewController.m
//  FCRM
//
//  Created by song jiekun on 15/7/30.
//  Copyright (c) 2015年 song jiekun. All rights reserved.
//

#import "ProductListViewController.h"
#import "ProductTableViewCell.h"
#import "ProductDetailViewController.h"
#import "ViewHelper.h"

@interface ProductListViewController ()

@end

@implementation ProductListViewController

- (id)initWithCoder:(NSCoder *)aDecoder{
    
    if((self=[super initWithCoder:aDecoder])){
        

        
    }
    
    return self;
    
}

- (void)viewDidAppear:(BOOL)animated{

    [ProductT reloadProducts:self action:@selector(reloadProductList:) category:self.category];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //注册 custom tableviewcell
    UINib *nib = [UINib nibWithNibName:@"ProductTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"ProductTableViewCell"];
    
    //ios 8设置tableview的高度
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(isRegisteredForRemoteNotifications)]){
        
        self.tableView.rowHeight= UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight=65+20+10;
    }
    
    //去掉系统默认分割线
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    //设置navigation bar的标题
    self.navigationItem.title=self.category;
    
#warning 动态获取filter数据
    //设置filter数据和代理
    self.levelFilterView.filterArray=[[NSMutableArray alloc] initWithArray:@[@"高风险",@"折中型",@"稳定型"]] ;
    self.levelFilterView.delegate=self;
    
    self.sortFilterView.filterArray=[[NSMutableArray alloc] initWithArray:@[@"收益率由高到低",@"认购额由低到高",@"用户评分由高到低"]] ;
    self.sortFilterView.delegate=self;
    
    //设置filter constraint初始高度
    self.levelFilterView.viewHeight.constant=0;
    self.sortFilterView.viewHeight.constant=0;
    //保存filter高度
    self.levelFilterView.height=120;
    self.sortFilterView.height=120;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - target action回调方法
/*!
 *@discussion 更新tableview
 */
-(void)reloadProductList:(NSMutableArray*)reloadedProducts{
    
    //重新载入tableview数据
    self.products=reloadedProducts;
    [self.tableView reloadData];
    
    //灰色view隐藏掉
    self.grayView.hidden=YES;
    
}


#pragma mark - SimpleFilterPicker Delegate 根据风险高低来筛选
-(void)selectRowAtIndexPath:(NSIndexPath *)indexPath sender:(id)sender{
    
    //根据风险度来筛选
    if (self.levelFilterView==(SimpleFilterPicker*)sender) {
        
        if (indexPath.row==0) {
            
            [ProductT reloadProducts:self action:@selector(reloadProductList:) category:self.category level:[NSNumber numberWithInt:1] sort:nil];
            
        }
        else if (indexPath.row==1) {
            
            [ProductT reloadProducts:self action:@selector(reloadProductList:) category:self.category level:[NSNumber numberWithInt:2] sort:nil];
            
        }
        else if (indexPath.row==2) {
            
            [ProductT reloadProducts:self action:@selector(reloadProductList:) category:self.category level:[NSNumber numberWithInt:3] sort:nil];
            
        }
        
        //根据条件来排序
    } else if (self.sortFilterView==(SimpleFilterPicker*)sender){
        
        if (indexPath.row==0) {
            
            [ProductT reloadProducts:self action:@selector(reloadProductList:) category:self.category level:nil sort:@"productYieldRate"];
            
        }
        else if (indexPath.row==1) {
            
            [ProductT reloadProducts:self action:@selector(reloadProductList:) category:self.category level:nil sort:@"productMinAmount"];
            
        }
        else if (indexPath.row==2) {
            
            [ProductT reloadProducts:self action:@selector(reloadProductList:) category:self.category level:nil sort:@"userScore"];
            
        }
        
    }
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    if (self.products==nil) {
        
        return 0;
        
    }
    else{
        
        return [self.products count];
        
    }
    
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProductTableViewCell" forIndexPath:indexPath];

    //获取对应的product
    ProductT *product = [self.products objectAtIndex:indexPath.row];
    
    [ViewHelper configureProductCell:cell product:product];
    
    return cell;
}

//通过xib来定义的cell 必须通过didSelectRowAtIndexPath来触发segue
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self performSegueWithIdentifier:@"ProductDetailSegue" sender:tableView];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(isRegisteredForRemoteNotifications)]){
        
        return UITableViewAutomaticDimension;
    }
    else {
        
        return 65+20+10;//图片大小65x65 上下空挡各10;
    }
    
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


 #pragma mark - prepareForSegue传递数据
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
     
     ProductDetailViewController *destinationVC=segue.destinationViewController;
     
     if ([[segue identifier] isEqualToString:@"ProductDetailSegue"]) {
         
         NSIndexPath *indexPath= [self.tableView indexPathForSelectedRow];
         
         //传递数据
         destinationVC.product=self.products[indexPath.row];
         
     }
 }


#pragma mark - helper 方法
/*

- (void)configureCell:(ProductTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    //获取对应的product
    ProductT *product = [self.products objectAtIndex:indexPath.row];
    
    //更新Cell
    cell.categoryLabel.text=[NSString stringWithFormat:@"类型:%@",product.productCategory];
    cell.yieldRateLabel.text=[NSString stringWithFormat:@"%@%%",product.productYieldRate];
    cell.productNameLabel.text=product.productName;
    cell.periodLabel.text=[NSString stringWithFormat:@"认购期限:%@",product.productPeriod];
    cell.minAmount.text=[NSString stringWithFormat:@"起购额:%@万",product.productMinAmount];
    cell.investorRateLabel.text=[NSString stringWithFormat:@"用户评分:%@分",product.userScore];
    
    //不同level的product不同的背景图
    switch ([product.productLevel integerValue]) {
        case 1:
            cell.levelImageView.image=[UIImage imageNamed:@"high"];
            break;
            
        case 2:
            cell.levelImageView.image=[UIImage imageNamed:@"middle"];
            break;
            
        case 3:
            cell.levelImageView.image=[UIImage imageNamed:@"low"];
            break;
            
        default:
            cell.levelImageView.image=[UIImage imageNamed:@"high"];
            break;
    }
    
}
*/



#pragma mark - click action 方法

- (IBAction)clickLevelFilter:(id)sender{
    
    [self.levelFilterView switchView:self.grayView];
    
    [self.sortFilterView hideView];
    
}


- (IBAction)clickSortFilter:(id)sender{
    
    [self.sortFilterView switchView:self.grayView];
    
    [self.levelFilterView hideView];
    
}

- (IBAction)hideAllFilter:(UITapGestureRecognizer*)recognize{
    
    [self.sortFilterView toggleOffView];
    
    [self.levelFilterView toggleOffView];
    
    self.grayView.hidden=YES;
    
}


@end
