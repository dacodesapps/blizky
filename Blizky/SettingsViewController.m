//
//  SettingsViewController.m
//  BlizkyServicios
//
//  Created by Juan Carlos Toledo on 12/24/15.
//  Copyright © 2015 DaCodes. All rights reserved.
//

#import "SettingsViewController.h"
#import "NavigationViewController.h"

@interface SettingsViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView* myTableView;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [super viewDidLoad];
    self.title = @"Settings";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"OpenSans-Bold" size:18.0f],NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:243.0/255.0 green:44.0/255.0 blue:55.0/255.0 alpha:1.0];
    self.navigationController.navigationBar.translucent = NO;
    
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu"
//                                                                             style:UIBarButtonItemStylePlain
//                                                                            target:(NavigationViewController *)self.navigationController
//                                                                            action:@selector(showMenu)];
//    
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
//    imageView.image = [UIImage imageNamed:@"profile.jpg"];
//    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    imageView.contentMode = UIViewContentModeScaleAspectFill;
//    [self.view addSubview:imageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"Account";
    }else if (section == 1){
        return @"Settings";
    }else if (section == 2){
        return @"About";
    }else{
        return @"";
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellIdentifier = @"Cell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        cell.textLabel.text = @"Private Account";
        cell.accessoryType = UITableViewCellAccessoryNone;
    }else if (indexPath.section == 0 && indexPath.row == 1) {
        cell.textLabel.text = @"Edit Account";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if (indexPath.section == 1 && indexPath.row == 0){
        cell.textLabel.text = @"Push Notification Settings";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if (indexPath.section == 1 && indexPath.row == 1){
        cell.textLabel.text = @"Link Accounts";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if (indexPath.section == 2 && indexPath.row == 0){
        cell.textLabel.text = @"Privacy Policy";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if (indexPath.section == 2 && indexPath.row == 1){
        cell.textLabel.text = @"Terms of Service";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if (indexPath.section == 3 && indexPath.row == 0){
        cell.textLabel.text = @"Clear Search History";
        cell.textLabel.textColor = [UIColor colorWithRed:69.0/255.0 green:146.0/255.0 blue:247.0/255.0 alpha:1.0];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13.0];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if (indexPath.section == 3 && indexPath.row == 1){
        cell.textLabel.text = @"Log Out";
        cell.textLabel.textColor = [UIColor colorWithRed:69.0/255.0 green:146.0/255.0 blue:247.0/255.0 alpha:1.0];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13.0];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

-(IBAction)back:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
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
