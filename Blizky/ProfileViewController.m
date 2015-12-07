//
//  ProfileViewController.m
//  Blizky
//
//  Created by Carlos Vela on 14/11/15.
//  Copyright © 2015 Dacodes. All rights reserved.
//

#import "ProfileViewController.h"
#import "ProfileInfoTableViewCell.h"
#import "MapViewController.h"
#import "FollowersFollowingViewController.h"
#import "HomeTableViewCell.h"
#import "AFNetworking.h"

@interface ProfileViewController ()<UITableViewDataSource,UITableViewDelegate>{
    BOOL button1;
    BOOL button2;
    BOOL button3;
    BOOL button4;
    CGFloat offsetSection;
    NSString* selectedIndex;
}

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Network";
    self.myTableView.delegate=self;
    self.myTableView.dataSource=self;
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor colorWithRed:243.0/255.0 green:44.0/255.0 blue:55.0/255.0 alpha:1.0];
    [refreshControl addTarget:self action:@selector(fetchProfile:) forControlEvents:UIControlEventValueChanged];
    UITableViewController *tableVC = [[UITableViewController alloc]initWithStyle:UITableViewStylePlain];
    [tableVC setTableView:self.myTableView];
    tableVC.refreshControl = refreshControl;
    
    button1 = YES;
    button2 = NO;
    button3 = NO;
    button4 = NO;
    
    [self fetchProfile:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.shadowImage = nil;
//    self.navigationController.navigationBar.translucent = YES;
}

#pragma mark - Fetch Data

-(void)fetchProfile:(id)sender{
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
        NSArray*temp  = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",temp);
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
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        NSString*string=@"BiodcbjsbdbjsdhbfjashbdfjasdhfbssBiodcbjsbdbjsdhbfjashbdfjasdhfbssBiodcbjsbdbjsdhbfjashbdfjasdhfbss";
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:13.0]};
        CGRect rect = [string boundingRectWithSize:CGSizeMake(282, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
        CGFloat height = rect.size.height;
        if (offsetSection <= 200.0) {
            offsetSection = 115+height+50;
        }else{
            offsetSection = 115+height+42;
        }
        return offsetSection;
    }else{
        return 90.0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellIdentifier;
    if (indexPath.row == 0) {
        cellIdentifier = @"CellProfile";
        ProfileInfoTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        
        cell.profilePic.layer.cornerRadius = cell.profilePic.frame.size.width/2;
        cell.profilePic.layer.borderColor = [UIColor clearColor].CGColor;
        cell.profilePic.layer.borderWidth = 2.0;
        cell.profilePic.image = [UIImage imageNamed:@"profile.jpg"];
        
        cell.bio.text = @"BiodcbjsbdbjsdhbfjashbdfjasdhfbssBiodcbjsbdbjsdhbfjashbdfjasdhfbssBiodcbjsbdbjsdhbfjashbdfjasdhfbss";
        
        [cell.services addTarget:self action:@selector(goServices:) forControlEvents:UIControlEventTouchUpInside];
        [cell.followers addTarget:self action:@selector(goFollowers:) forControlEvents:UIControlEventTouchUpInside];
        [cell.following addTarget:self action:@selector(goFollowing:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.button1 addTarget:self action:@selector(button1:) forControlEvents:UIControlEventTouchUpInside];
        cell.button1.imageView.contentMode = UIViewContentModeScaleAspectFit;
        //[cell.button2 addTarget:self action:@selector(goMap:) forControlEvents:UIControlEventTouchUpInside];
        cell.button2.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [cell.button3 addTarget:self action:@selector(button3:) forControlEvents:UIControlEventTouchUpInside];
        [cell.button4 addTarget:self action:@selector(button4:) forControlEvents:UIControlEventTouchUpInside];
        cell.button4.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [cell layoutIfNeeded];
        [cell setNeedsLayout];
        
        return cell;
    }else{
        cellIdentifier = @"Cell";
        
        HomeTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        if (button1) {
            cell.textLabel.text=@"Service Recommended";
            cell.imageView.image = [UIImage imageNamed:@"profile.jpg"];
        }else if (button2){
            cell.textLabel.text=@"2";
        }else if (button3){
            cell.textLabel.text=@"News";
            cell.imageView.image = nil;
        }else if (button4){
            cell.textLabel.text=@"Hashtags";
            cell.imageView.image = nil;
        }
        
        cell.username.text = @"Carlos Vela";
        cell.descriptionHome.text = @"shbxjsdcbdjsahchjbdsjhcbsdjhcbsdhcbasjbdsajchsdbcjadshbcdsajhbdajchd";
        cell.distanceCategory.text = @"2Km, Categoría";
        cell.friends.text = @"5 friends";
        cell.profilePic.layer.cornerRadius = cell.profilePic.frame.size.width/2;
        cell.profilePic.layer.borderColor = [UIColor clearColor].CGColor;
        cell.profilePic.layer.borderWidth = 2.0;
        cell.buttonRecommended.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [cell layoutIfNeeded];
        [cell setNeedsLayout];
        
        return cell;
    }
}

#pragma mark - Actions

-(void)goServices:(id)sender{
    [self.myTableView setContentOffset:CGPointMake(0, offsetSection) animated:YES];
    //NSLog(@"Services");
}

-(void)goFollowers:(id)sender{
    //NSLog(@"Followers");
    selectedIndex=@"Followers";
    [self performSegueWithIdentifier:@"open" sender:self];
}

-(void)goFollowing:(id)sender{
    //NSLog(@"Following");
    selectedIndex=@"Following";
    [self performSegueWithIdentifier:@"open" sender:self];
}

-(void)button1:(id)sender{
    button1 = YES;
    button2 = NO;
    button3 = NO;
    button4 = NO;
    //NSLog(@"Button 1");
    [self.myTableView reloadData];
}

-(void)button2:(id)sender{
    button1 = NO;
    button2 = YES;
    button3 = NO;
    button4 = NO;
    //NSLog(@"Button 2");
    [self.myTableView reloadData];
}

-(void)button3:(id)sender{
    button1 = NO;
    button2 = NO;
    button3 = YES;
    button4 = NO;
    //NSLog(@"Button 3");
    [self.myTableView reloadData];
}

-(void)button4:(id)sender{
    button1 = NO;
    button2 = NO;
    button3 = NO;
    button4 = YES;
    //NSLog(@"Button 4");
    [self.myTableView reloadData];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"map"]) {
        self.tabBarController.tabBar.hidden=YES;
    }
    if ([segue.identifier isEqualToString:@"open"]) {
        FollowersFollowingViewController* destinationController = segue.destinationViewController;
        destinationController.fromWhereTitle=selectedIndex;
    }
}


@end
