//
//  AddViewController.m
//  Blizky
//
//  Created by Carlos Vela on 25/11/15.
//  Copyright © 2015 Dacodes. All rights reserved.
//

#import "AddViewController.h"
#import "FollowersFollowingTableViewCell.h"

@import Contacts;

@interface AddViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *contacts;
}

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIButton *addContacts;
@property (weak, nonatomic) IBOutlet UIButton *addFacebook;
@property (weak, nonatomic) IBOutlet UIButton *requests;

@end

@implementation AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    contacts = [[NSMutableArray alloc] init];
    self.title = @"Add Friend";
    
    self.addContacts.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.addFacebook.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.requests.imageView.contentMode = UIViewContentModeScaleAspectFit;

    self.myTableView.delegate=self;
    self.myTableView.dataSource=self;
    
    [self getContacts];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getContacts
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    CNContactStore *store = [[CNContactStore alloc] init];
    [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted == YES) {
            //keys with fetching properties
            NSArray *keys = @[CNContactFamilyNameKey, CNContactGivenNameKey, CNContactPhoneNumbersKey, CNContactImageDataKey, CNContactEmailAddressesKey];
            NSString *containerId = store.defaultContainerIdentifier;
            NSPredicate *predicate = [CNContact predicateForContactsInContainerWithIdentifier:containerId];
            NSError *error;
            NSArray *cnContacts = [store unifiedContactsMatchingPredicate:predicate keysToFetch:keys error:&error];
            if (error) {
                NSLog(@"error fetching contacts %@", error);
            } else {
                NSData*tempImage = UIImageJPEGRepresentation([UIImage imageNamed:@"profile.jpg"], 1.0);
                for (CNContact *contact in cnContacts) {
                    NSDictionary*person = @{@"FirstName":contact.givenName,
                                            @"LastName":contact.familyName,
                                            @"Phone":[contact.phoneNumbers count] > 0 ? [contact.phoneNumbers[0].value stringValue]: @"No available",
                                            @"Email":[contact.emailAddresses count] > 0 ? contact.emailAddresses[0].value : @"No available",
                                            @"Image":contact.imageData != nil ? contact.imageData : tempImage
                                            };
                    [contacts addObject:person];
//                    for (CNLabeledValue *label in contact.phoneNumbers) {
//                        NSString *phone = [label.value stringValue];
//                        if ([phone length] > 0) {
//                            //NSLog(@"%@",phone);
//                            //[contact.phones addObject:phone];
//                        }
//                    }
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.myTableView reloadData];
                [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
            });
        }
    }];
}

#pragma mark - TableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [contacts count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellIdentifier = @"Cell";
    FollowersFollowingTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.username.text = [NSString stringWithFormat:@"%@ %@",contacts[indexPath.row][@"FirstName"],contacts[indexPath.row][@"LastName"]];
    cell.descriptionCell.text = contacts[indexPath.row][@"Phone"];
    cell.profilePic.image = [UIImage imageWithData:contacts[indexPath.row][@"Image"]];
    
    [cell layoutIfNeeded];
    [cell setNeedsLayout];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(FollowersFollowingTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
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
