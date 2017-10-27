//
//  USTDetailViewController.m
//  TMDB
//
//  Created by Vladimír Slavík on 24/01/2017.
//  Copyright © 2017 Usertech. All rights reserved.
//

#import "USTDetailViewController.h"
#import "USTAppUtils.h"
#import "USTAppModel.h"
#import "USTAppModelMasterScreen.h"
#import "USTAppModelDetailScreen.h"
#import "USTClientRemoteService.h"
#import "USTTableViewCellPoster.h"
#import "USTTableViewCellParagraph.h"

@interface USTDetailViewController ()

@property(nonatomic, strong) USTModelEntityFilm* film;
@property(nonatomic, weak) IBOutlet UITableView* tableView;

@end

@implementation USTDetailViewController

- (void)configureView {
    
    // Update the user interface for the detail item.
    if (self.filmIndex) {
        
        self.film = [[USTAppModel appModel] appModelDetailScreenWithFilmIndex:self.filmIndex].film;
        self.navigationItem.title = self.film.title;
        self.tableView.dataSource = [[USTAppModel appModel] appModelDetailScreen];

    }
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    [self configureTableView];
}

- (void)configureTableView
{
    // the large poster
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([USTTableViewCellPoster class]) bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:NSStringFromClass([USTTableViewCellPoster class])];

    // rating, title
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([USTTableViewCell class]) bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:NSStringFromClass([USTTableViewCell class])];

    // film descriptions
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([USTTableViewCellParagraph class]) bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:NSStringFromClass([USTTableViewCellParagraph class])];
    
    self.tableView.estimatedRowHeight = [USTAppUtils rowHeightForReusableCellIdentifier:NSStringFromClass([USTTableViewCellPoster class])                                                                  andTableView:self.tableView];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.tableView.delegate         = self; // view setup
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Managing the detail item

- (void)setFilmIndex:(NSIndexPath *)newFilmIndex {
    
    if ( newFilmIndex != nil && [newFilmIndex compare:self.filmIndex] != NSOrderedSame) {
        _filmIndex = newFilmIndex;
        
        // Update the view.
        [self configureView];
    }
}

#pragma mark - ----------------- UITableViewDelegate ------------------

- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    // hide the table separators if the table is empty
    return [[UIView alloc] initWithFrame:CGRectZero];
}


@end
