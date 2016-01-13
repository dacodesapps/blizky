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
#import "SideMenuDacodes.h"
#import "MapViewController.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate, UISearchBarDelegate>{
    NSArray* response;
    NSDictionary* profileInfo;
    NSIndexPath* selectedRow;
    NSInteger currentIndex;
    BOOL sameRow;
}

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UILabel *emptyMessage;
@property (strong, nonatomic) SideMenuDacodes *menuView;
@property (strong, nonatomic) UISearchBar *mySearchBar;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    currentIndex = 0;
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Saved",@"Recommended"]];
    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    segmentedControl.frame = CGRectMake(0, 0, 200.0f, 30.0f);
    [segmentedControl addTarget:self action:@selector(segmentedIndex:) forControlEvents:UIControlEventValueChanged];
    
    self.navigationItem.titleView = segmentedControl;

    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"OpenSans-Bold" size:18.0f],NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:243.0/255.0 green:44.0/255.0 blue:55.0/255.0 alpha:1.0];
    self.navigationController.navigationBar.translucent = NO;
    
    self.myTableView.delegate=self;
    self.myTableView.dataSource=self;
        
    [self createHeader];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor colorWithRed:243.0/255.0 green:44.0/255.0 blue:55.0/255.0 alpha:1.0];
    [refreshControl addTarget:self action:@selector(fetchSaveServices:) forControlEvents:UIControlEventValueChanged];
    UITableViewController *tableVC = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
    [tableVC setTableView:self.myTableView];
    tableVC.refreshControl = refreshControl;
    
    [self performSelector:@selector(hideSearchBar) withObject:nil afterDelay:0.0f];
    
    self.myTableView.hidden = YES;
    self.emptyMessage.hidden = YES;
    
    [self fetchSaveServices:nil];
    [self fetchProfile:nil];
    
    NSLog(@"%@",[self authToken]);
    NSLog(@"%@",[self idUser]);
    
    [self createMenu];
    
    [self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self.menuView action:@selector(panGestureRecognized:)]];
}

-(void)createMenu{
    self.menuView = [[SideMenuDacodes alloc] initWithFrame:CGRectMake(-300, 0, 300, self.view.frame.size.height+64)];
    self.menuView.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:1.0];
    self.menuView.firstName = @"Carlos";
    self.menuView.lastName = @"Vela";
    self.menuView.email = [self emailUser];

    [[UIApplication sharedApplication].keyWindow addSubview:self.menuView];
}

-(IBAction)showMenu{
    //self.myTableView.userInteractionEnabled = NO;
    //self.tabBarController.tabBar.userInteractionEnabled = NO;
    [self.menuView showMenu];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)hideSearchBar {
    self.myTableView.contentOffset = CGPointMake(0, 44);
}

-(void)createHeader{
    UIView*header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44.0)];
    header.backgroundColor = [UIColor colorWithRed:187.0/255.0 green:186.0/255.0 blue:193.0/255.0 alpha:0.81],
    
    self.mySearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-50, 44)];
    self.mySearchBar.delegate=self;
    
    [header addSubview:self.mySearchBar];
    
    UIButton* mapButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [mapButton setImage:[UIImage imageNamed:@"Pin"] forState:UIControlStateNormal];
    mapButton.tintColor = [UIColor whiteColor];
    mapButton.frame = CGRectMake(self.view.frame.size.width-50, 12, 50, 20);
    mapButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [mapButton addTarget:self action:@selector(goMap) forControlEvents:UIControlEventTouchUpInside];
    
    [header addSubview:mapButton];
    
    self.myTableView.tableHeaderView = header;
}

-(void)goMap{
    [self performSegueWithIdentifier:@"showMap" sender:self];
}

#pragma mark - SegmentedControl

- (void)segmentedIndex:(id)sender {
    switch (((UISegmentedControl *)sender).selectedSegmentIndex) {
        case 0:
            NSLog(@"Saved");
            currentIndex = 0;
            [self.myTableView reloadData];
            break;
        case 1:
            NSLog(@"Recommended");
            currentIndex = 1;
            [self servicesRecommended:nil];
            [self.myTableView reloadData];
            break;
    }
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

    [manager GET:[NSString stringWithFormat:@"http://69.46.5.166:3002/api/Customers/%@/favouritesServices?access_token=%@",[self idUser],[self authToken]] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
        [sender endRefreshing];
        response = (NSArray *)responseObject;
        NSLog(@"Saved: %@",response);
        if ([response count] == 0) {
            self.myTableView.hidden = YES;
            self.emptyMessage.hidden = NO;
        }else{
            [self.myTableView reloadData];
            self.myTableView.hidden = NO;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.myTableView.hidden = NO;
        [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
        [refresh endRefreshing];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Blizky" message:@"Connection failure" preferredStyle:UIAlertControllerStyleAlert]; // 1
        UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"Accept" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            NSLog(@"Accept");
        }];
        [alert addAction:firstAction];
        [self presentViewController:alert animated:YES completion:nil];
        NSLog(@"Error: %@", error);
    }];
}

-(void)servicesRecommended:(id)sender{
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    
    UIRefreshControl*refresh = (UIRefreshControl *)sender;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:[NSString stringWithFormat:@"http://69.46.5.166:3002/api/Customers/%@/recomendationsOfServices?access_token=%@",[self idUser],[self authToken]] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
        [sender endRefreshing];
        response = (NSArray *)responseObject;
        NSLog(@"Recommended: %@",response);
        if ([response count] == 0) {
            self.myTableView.hidden = YES;
            self.emptyMessage.hidden = NO;
        }else{
            [self.myTableView reloadData];
            self.myTableView.hidden = NO;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.myTableView.hidden = NO;
        [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
        [refresh endRefreshing];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Blizky" message:@"Connection failure" preferredStyle:UIAlertControllerStyleAlert]; // 1
        UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"Accept" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            NSLog(@"Accept");
        }];
        [alert addAction:firstAction];
        [self presentViewController:alert animated:YES completion:nil];
        NSLog(@"Error: %@", error);    }];
}

-(void)fetchProfile:(id)sender{
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    
    UIRefreshControl*refresh = (UIRefreshControl *)sender;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:[NSString stringWithFormat:@"http://69.46.5.166:3002/api/Customers/%@/profile?otherId=%@&access_token=%@",[self idUser],[self idUser],[self authToken]] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
        [sender endRefreshing];
        profileInfo  = (NSDictionary *)responseObject;
        self.menuView.firstName = profileInfo[@"firstName"];
        self.menuView.lastName = profileInfo[@"lastName"];
        self.menuView.profilePic = profileInfo[@"photoUrl"];
        [self.menuView reloadTable];
        NSLog(@"Profile: %@",profileInfo);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
        [refresh endRefreshing];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Blizky" message:@"Connection failure" preferredStyle:UIAlertControllerStyleAlert]; // 1
        UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"Accept" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            NSLog(@"Accept");
        }];
        [alert addAction:firstAction];
        [self presentViewController:alert animated:YES completion:nil];
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
    if (([indexPath compare:selectedRow] == NSOrderedSame) && !sameRow) {
        return 140.0; // Expanded height
    }
    return 82.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellIdentifier = @"Cell";
    HomeTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    [cell.profilePic sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://69.46.5.166:3002%@",response[indexPath.row][@"photoUrl"]]] placeholderImage:nil options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            cell.profilePic.image=image;
        }
    }];
    cell.profilePic.contentMode = UIViewContentModeScaleToFill;
    cell.serviceName.text = response[indexPath.row][@"serviceName"];
    cell.descriptionService.text = response[indexPath.row][@"description"];
    cell.categoryService.text = response[indexPath.row][@"category"][@"name"];
    cell.friends.text = [NSString stringWithFormat:@"%li friends",[response[indexPath.row][@"friendsRecomendations"] integerValue]];
    cell.buttonMore.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [cell.buttonMore addTarget:self action:@selector(moreAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.buttonOpenCell addTarget:self action:@selector(openCell:) forControlEvents:UIControlEventTouchUpInside];
    cell.buttonOpenCell.tag = indexPath.row;
    cell.buttonOpenCell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    cell.buttonOpenCell.transform = CGAffineTransformMakeRotation(M_PI_2);
    cell.buttonTag.imageView.contentMode = UIViewContentModeScaleAspectFit;
    cell.buttonTag.tag = indexPath.row;
    [cell.buttonTag addTarget:self action:@selector(tagSomeone:) forControlEvents:UIControlEventTouchUpInside];
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

-(void)openCell:(id)sender{
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
    HomeTableViewCell *cell = (HomeTableViewCell *)[self tableView:self.myTableView cellForRowAtIndexPath:indexPath];
    if ([indexPath compare:selectedRow] == NSOrderedSame) {
        if (cell.frame.size.height == 82.0) {
            sameRow = NO;
            selectedRow = indexPath;
            [self.myTableView reloadRowsAtIndexPaths:@[selectedRow] withRowAnimation:UITableViewRowAnimationAutomatic];
            //cell.buttonOpenCell.transform = CGAffineTransformMakeRotation(-M_PI_2);
        }else{
            sameRow = YES;
            [self.myTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:selectedRow] withRowAnimation:UITableViewRowAnimationFade];
            //cell.buttonOpenCell.transform = CGAffineTransformMakeRotation(M_PI_2);
        }
    } else {
        sameRow = NO;
        selectedRow = indexPath;
        [self.myTableView reloadRowsAtIndexPaths:@[selectedRow] withRowAnimation:UITableViewRowAnimationAutomatic];
        //cell.buttonOpenCell.transform = CGAffineTransformMakeRotation(-M_PI_2);
    }
}

-(void)tagSomeone:(id)sender{
    NSLog(@"%li",(long)[sender tag]);
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Blizky"
                                          message:@"Tag Someone"
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         textField.placeholder = NSLocalizedString(@"Tags", @"Tags");
     }];
    
    UIAlertAction *acceptAction = [UIAlertAction actionWithTitle:@"Accept" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
        NSLog(@"Accept");
        UITextField *tags = alertController.textFields.firstObject;
        NSLog(@"%@",tags.text);
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        NSLog(@"Cancel");
    }];
    
    [alertController addAction:acceptAction];
    [alertController addAction:cancelAction];

    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)moreAction:(id)sender{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Blizky" message:@"More actions" preferredStyle:UIAlertControllerStyleActionSheet]; // 1
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"Share" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        NSLog(@"Share");
    }];
    
    UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@"Tag Someone" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        NSLog(@"Tag");
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
        NSLog(@"Cancel");
    }];
    
    [alert addAction:firstAction];
    [alert addAction:secondAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSegueWithIdentifier:@"showService" sender:self];
    });
}

#pragma mark - Search Bar

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
    if ([segue.identifier isEqualToString:@"showMap"]) {
        MapViewController* destinationController = segue.destinationViewController;
        destinationController.services = response;
        self.tabBarController.tabBar.hidden=YES;
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

-(NSString*)emailUser{
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"emailUser" accessGroup:nil];
    return [keychainItem objectForKey:(id)kSecAttrAccount];
}

@end
