//
//  MatchesTableViewController.m
//  Spicer
//
//  Created by Pierre-Yves Touzain on 11/12/2014.
//  Copyright (c) 2014 Spicer. All rights reserved.
//

#import "SPRMatchesTableViewController.h"
#import "SPRMatchTableViewCell.h"

#import "SPRFantaisyViewController.h"
#import "SPRFantaisyViewModel.h"

@implementation SPRMatchesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = NSLocalizedString(@"To do", nil);
    
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : kSpicerColorDarkRed}];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.notificationsNumber;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SPRMatchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MatchCellIdentifier" forIndexPath:indexPath];
    
    cell.viewModel = [self.viewModel matchViewModelForIndexPath:indexPath];
    [cell configureCell];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.viewModel updateNotificationStatus:YES forIndexPath:indexPath];
    SPRFantaisyViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"fantaisyViewController"];
    SPRFantaisyViewModel *viewModel = [self.viewModel fantaisyViewModelForIndexPath:indexPath];
    vc.viewModel = viewModel;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - SPRMatchesViewModel Delegate Methods

- (void)getNotificationSuccess {
    [self.tableView reloadData];
}

- (void)getNotificationFail {
    
}

@end
