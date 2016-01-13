//
//  ServiceReferralsViewController.m
//  Blizky
//
//  Created by Dacodes on 27/12/15.
//  Copyright © 2015 Dacodes. All rights reserved.
//

#import "ServiceReferralsViewController.h"
#import "HomeTableViewCell.h"

@interface ServiceReferralsViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation ServiceReferralsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Referrals";
    
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellIdentifier = @"Cell";
    HomeTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    //[cell.profilePic sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://69.46.5.166:3002%@",response[indexPath.row][@"photoUrl"]]] placeholderImage:nil];
    cell.profilePic.image = [UIImage imageNamed:@"profile.jpg"];
    cell.profilePic.contentMode = UIViewContentModeScaleToFill;
    cell.serviceName.text = @"Carlos Vela";
    cell.descriptionService.text = @"Bio";
    cell.categoryService.text = @"sdiucbsakhcbhvbsdfkjhvbfjhkvbsdjkhvbjsdbvkhdsfbvk";
    cell.buttonRecommended.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
