//
//  USTMasterViewController.m
//  TMDB
//
//  Created by Vladimír Slavík on 24/01/2017.
//  Copyright © 2017 Usertech. All rights reserved.
//

#import "USTMasterViewController.h"
#import "USTDetailViewController.h"
#import "USTAppModel.h"
#import "USTAppModelMasterScreen.h"
#import "USTAppUtils.h"
#import "UITableViewCellFilm.h"

@interface USTMasterViewController ()
@property (nonatomic, strong) UISearchController* searchController;
@end

@implementation USTMasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.detailViewController = (USTDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    self.title = NSLocalizedStringFromTable(@"7bK-jq-Zjz.title", @"Main", nil);
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    [self configureTableView];
    
    [self configureSearchController];
    
    [self configureRefreshControl];
    
    [[[USTAppModel appModel] appModelMasterScreen] getPopularMoviesWithLanguage:@"en-US"
                                                                             region:nil];
    
}

- (void) configureRefreshControl {

    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshTable:) forControlEvents:UIControlEventValueChanged];
    NSDictionary *attrs = @{NSForegroundColorAttributeName : RGBCOLORMAJOR};
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Delete the list and load new", nil)
                                                                     attributes:attrs];
}

- (void) refreshTable:(UIRefreshControl*)refreshControl {
    
    // refresh repaing the table
    dispatch_after_delay_on_main_queue(1.0, ^{
        
        [[USTAppModel appModel] removePersistentStore];
    
        dispatch_after_delay_on_main_queue(0.5, ^{
            // delay the load because of the persistence store
            [[USTAppModel appModel] appModelMasterScreen].pageNumber = @(1);
            [[[USTAppModel appModel] appModelMasterScreen] getPopularMoviesWithLanguage:@"en-US"
                                                                                 region:nil];
            });
        
    });
    
    // lets end the refresh before the data can be reloaded from CD
    [refreshControl endRefreshing];
    
}

- (void)configureTableView
{
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([UITableViewCellFilm class]) bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:NSStringFromClass([UITableViewCellFilm class])];
    
    self.tableView.rowHeight = [USTAppUtils rowHeightForReusableCellIdentifier:NSStringFromClass([UITableViewCellFilm class])                                                                  andTableView:self.tableView];

    self.tableView.delegate         = self; // view setup
    self.tableView.dataSource       = [[USTAppModel appModel] appModelMasterScreen]; // model setup
}

- (void) configureSearchController {
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = [[USTAppModel appModel] appModelMasterScreen];
    self.searchController.hidesNavigationBarDuringPresentation = false;
    self.searchController.dimsBackgroundDuringPresentation = false;
    [self.searchController.searchBar sizeToFit];
    self.searchController.searchBar.barTintColor = RGBCOLORMAJOR;
    
    self.tableView.tableHeaderView = self.searchController.searchBar;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}


- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    dispatch_after_delay_on_main_queue(0.1, ^{
        [self.searchController setActive:NO];        
    });
    
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        USTDetailViewController *controller = (USTDetailViewController *)[[segue destinationViewController] topViewController];
        [controller setFilmIndex:indexPath];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}


#pragma mark - ----------------- UITableViewDelegate ------------------

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"showDetail" sender:self];
}

- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    // hide the table separators if the table is empty
    return [[UIView alloc] initWithFrame:CGRectZero];
}


/**
 Scrolls to bottom and more pages are loaded

 @param scrollView self.tableView
 */
-(void) scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat height = scrollView.frame.size.height;
    
    CGFloat contentYoffset = scrollView.contentOffset.y;
    CGFloat distanceFromBottom = scrollView.contentSize.height - contentYoffset;

    NSInteger numberOfRows = [[[USTAppModel appModel] appModelMasterScreen] tableView:self.tableView numberOfRowsInSection:0];
    
    static const NSInteger kMargin = 100;
    if(distanceFromBottom - kMargin < height
       && numberOfRows != 0) {
        
        [[[USTAppModel appModel] appModelMasterScreen] getPopularMoviesWithLanguage:@"en-US"
                                                                             region:nil];
    }
}


@end
