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

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate, UISearchBarDelegate>

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
//    for (int i=0; i<[[UIFont familyNames] count]; i++) {
//        if ([[UIFont familyNames][i] containsString:@"Semibold"]) {
//            NSLog(@"Semibold: %@",[UIFont familyNames][i]);
//        }
//    }

    //NSLog (@"Font families: %@", [UIFont familyNames]);
//    NSLog (@"Courier New family fonts: %@", [UIFont fontNamesForFamilyName:@"Open Sans"]);
//    
    NSArray *fontFamilies = [UIFont familyNames];
    
    for (int i = 0; i < [fontFamilies count]; i++)
    {
        NSString *fontFamily = [fontFamilies objectAtIndex:i];
        NSArray *fontNames = [UIFont fontNamesForFamilyName:fontFamily];
        for (int i=0; i<[fontNames count]; i++) {
            if ([fontNames[i] containsString:@"Sans"]) {
                NSLog(@"Semibold: %@",fontNames[i]);
            }
        }
        //NSLog (@"%@: %@", fontFamily, fontNames);
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)hideSearchBar {
    //self.myTableView.contentOffset = CGPointMake(0, 44);
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

    NSString *urlAsString = @"http://dacodes.com/Apps/NoticiasAsercom/news.php";
    NSDictionary*parameters = @{@"countries": @[@"México"],
                                @"newsletters": @[@"Síntesis Regional",@"Seguimiento a la Competencia"]};
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:urlAsString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
        [sender endRefreshing];
//        NSArray*temp  = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
//        NSLog(@"%@",temp);
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
    return 20;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellIdentifier = @"Cell";
    HomeTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];

//    cell.profilePic.layer.cornerRadius = cell.profilePic.frame.size.width/2;
//    cell.profilePic.layer.borderColor = [UIColor clearColor].CGColor;
//    cell.profilePic.layer.borderWidth = 2.0;
    
    cell.username.text = @"Carlos Vela";
    cell.descriptionHome.text = @"shbxjsdcbdjsahchjbdsjhcbsdjhcbsdhcbasjbdsajchsdbcjadshbcdsajhbdajchd";
    cell.distanceCategory.text = @"2Km, Categoría";
    cell.friends.text = @"5 friends";
    cell.buttonRecommended.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
//    cell.textLabel.text=@"Service";
//    cell.detailTextLabel.text=@"Addres";
//    
//    cell.imageView.image = [UIImage imageNamed:@"profile.jpg"];
//    [cell layoutIfNeeded];
//    [cell setNeedsLayout];
//
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

@end
