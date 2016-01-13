//
//  NoticeboardIndividualViewController.m
//  Blizky
//
//  Created by Dacodes on 12/01/16.
//  Copyright © 2016 Dacodes. All rights reserved.
//

#import "NoticeboardIndividualViewController.h"
#import "NoticeboardTableViewCell.h"

@interface NoticeboardIndividualViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation NoticeboardIndividualViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.rowHeight = UITableViewAutomaticDimension;
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
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 360.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellIdentifier = @"Cell";
    NoticeboardTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.date.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [cell layoutIfNeeded];
    [cell setNeedsLayout];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(NoticeboardTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.servicePic.layer.cornerRadius = 10;
    cell.servicePic.layer.borderColor = [UIColor clearColor].CGColor;
    cell.servicePic.layer.borderWidth = 2.0;
    cell.servicePic.layer.masksToBounds = YES;
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
