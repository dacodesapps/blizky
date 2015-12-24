//
//  ViewController.m
//  Blizky
//
//  Created by Dacodes on 12/11/15.
//  Copyright © 2015 Dacodes. All rights reserved.
//

#import "ViewController.h"
#import "HomeTableViewCell.h"
#import "AFNetworking.h"
#import <Security/Security.h>
#import "KeychainItemWrapper.h"
#import "UIImageView+WebCache.h"
#import "ServiceProfileViewController.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate, UISearchBarDelegate>{
    NSArray*response;
}

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) UISearchBar *mySearchBar;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Home";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"OpenSans-Bold" size:18.0f],NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:243.0/255.0 green:44.0/255.0 blue:55.0/255.0 alpha:1.0];
    self.navigationController.navigationBar.translucent = NO;
    
    self.myTableView.delegate=self;
    self.myTableView.dataSource=self;
    
    self.mySearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 70, 320, 44)];
    self.mySearchBar.delegate=self;
    
    self.myTableView.tableHeaderView = self.mySearchBar;
    
    self.myTableView.hidden = YES;
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor colorWithRed:243.0/255.0 green:44.0/255.0 blue:55.0/255.0 alpha:1.0];
    [refreshControl addTarget:self action:@selector(fetchSaveServices:) forControlEvents:UIControlEventValueChanged];
    UITableViewController *tableVC = [[UITableViewController alloc]initWithStyle:UITableViewStylePlain];
    [tableVC setTableView:self.myTableView];
    tableVC.refreshControl = refreshControl;
    
    [self performSelector:@selector(hideSearchBar) withObject:nil afterDelay:0.0f];
    
    [self fetchSaveServices:nil];
    
    NSLog(@"%@",[self authToken]);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)hideSearchBar {
    self.myTableView.contentOffset = CGPointMake(0, 44);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Fetch Data

-(void)fetchSaveServices:(id)sender{
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    
    UIRefreshControl*refresh = (UIRefreshControl *)sender;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    // Servicios recomendados @"http://69.46.5.166:3002/api/Customers/%@/recomendationsOfServices?access_token=%@",[self idUser],[self authToken]]

    [manager GET:[NSString stringWithFormat:@"http://69.46.5.166:3002/api/Customers/%@/favouritesServices?access_token=%@",[self idUser],[self authToken]] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
        [sender endRefreshing];
        response = (NSArray *)responseObject;
        NSLog(@"%@",response);
        [self.myTableView reloadData];
        self.myTableView.hidden = NO;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
        [refresh endRefreshing];
        UIAlertView*alert=[[UIAlertView alloc] initWithTitle:@"TeleNews Pro" message:@"No se puede conectar a internet" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
        [alert show];
        NSLog(@"Error: %@", error);
    }];
}

#pragma mark - TableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [response count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellIdentifier = @"Cell";
    HomeTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    //[cell.profilePic sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://69.46.5.166:3002%@",response[indexPath.row][@"photoUrl"]]] placeholderImage:nil];
    [cell.profilePic sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://69.46.5.166:3002%@",response[indexPath.row][@"photoUrl"]]] placeholderImage:nil options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            cell.profilePic.image=image;
        }
    }];
    cell.profilePic.contentMode = UIViewContentModeScaleToFill;
    cell.username.text = response[indexPath.row][@"serviceName"];
    cell.descriptionHome.text = response[indexPath.row][@"description"];
    cell.distanceCategory.text = response[indexPath.row][@"category"][@"name"];
    cell.friends.text = [NSString stringWithFormat:@"%li friends",[response[indexPath.row][@"friendsRecomendations"] integerValue]];
    cell.buttonRecommended.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [cell.buttonRecommended setTitle:[NSString stringWithFormat:@"%li",[response[indexPath.row][@"recomendations"] integerValue]] forState:UIControlStateNormal];
    
    [cell layoutIfNeeded];
    [cell setNeedsLayout];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(HomeTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.profilePic.layer.cornerRadius = cell.profilePic.frame.size.width/2;
    cell.profilePic.layer.borderColor = [UIColor clearColor].CGColor;
    cell.profilePic.layer.borderWidth = 2.0;
    cell.profilePic.layer.masksToBounds = YES;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"showService" sender:self];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.mySearchBar resignFirstResponder];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"showService"]) {
        NSIndexPath*indexPath = [self.myTableView indexPathForSelectedRow];
        ServiceProfileViewController* destinationController = segue.destinationViewController;
        destinationController.idService = response[indexPath.row][@"id"];
        destinationController.serviceName = response[indexPath.row][@"serviceName"];
        destinationController.serviceCategory = response[indexPath.row][@"category"][@"name"];
        destinationController.servicePhoto = response[indexPath.row][@"photoUrl"];
        destinationController.serviceDescription = response[indexPath.row][@"description"];
    }
}

#pragma mark - Credentials

-(NSString*)authToken{
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"BlizkyToken" accessGroup:nil];
    return [keychainItem objectForKey:(id)kSecAttrAccount];
}

-(NSString*)idUser{
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"idUser" accessGroup:nil];
    return [keychainItem objectForKey:(id)kSecAttrAccount];
}

@end
