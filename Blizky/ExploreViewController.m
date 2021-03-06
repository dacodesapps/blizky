//
//  ExploreViewController.m
//  Blizky
//
//  Created by Carlos Vela on 25/11/15.
//  Copyright © 2015 Dacodes. All rights reserved.
//

#import "ExploreViewController.h"

@interface ExploreViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) UISearchBar *mySearchBar;
@property (weak, nonatomic) IBOutlet UISegmentedControl*segmentedControl;

@end

@implementation ExploreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"OpenSans-Bold" size:18.0f],NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:243.0/255.0 green:44.0/255.0 blue:55.0/255.0 alpha:1.0];
    self.navigationController.navigationBar.translucent = NO;
    
    self.title = @"Explore";
    self.myTableView.delegate=self;
    self.myTableView.dataSource=self;
    
    self.mySearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 70, 320, 44)];
    
    self.myTableView.tableHeaderView = self.mySearchBar;
    
    [self.segmentedControl setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"OpenSans-Semibold" size:13.0], NSForegroundColorAttributeName : [UIColor colorWithRed:48.0/255.0 green:46.0/255.0 blue:47.0/255.0 alpha:1.0]} forState:UIControlStateNormal];
    [self.segmentedControl setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"OpenSans-Semibold" size:13.0], NSForegroundColorAttributeName : [UIColor colorWithRed:48.0/255.0 green:46.0/255.0 blue:47.0/255.0 alpha:1.0]} forState:UIControlStateSelected];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellIdentifier = @"Cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text=@"Service";
    cell.detailTextLabel.text=@"Addres";
    cell.imageView.image = [UIImage imageNamed:@"profile.jpg"];
    
    return cell;
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
