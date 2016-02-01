//
//  AlbumViewController.m
//  PayPalGallery
//
//  Created by Shawn Wu on 1/30/16.
//  Copyright © 2016 Shawn Wu. All rights reserved.
//

#import "AlbumViewController.h"
#import "PPLAlbumTableViewCell.h"
#import "PPLAlbum.h"
#import "MasterViewController.h"
#import "Masonry.h"

#import "PPLIndicatorView.h"

static NSString * const cellReuseIdentifier = @"album";
static NSString * const segueIdentifier = @"master";

@interface AlbumViewController()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, PPLPhotoManagerDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) PPLIndicatorView *indicator;

@property (nonatomic, strong) NSArray *albumTitleArray;
@property (nonatomic, strong) PPLPhotoManager *manager;

@end

@implementation AlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.searchBar.delegate = self;
    
    [self fetchAlbum];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:segueIdentifier])
    {
        MasterViewController *masterViewController = segue.destinationViewController;
        masterViewController.manager = self.manager;
        masterViewController.galleryIdentifier = (NSString *)sender;
    }
}

- (void)fetchAlbum
{
    if(self.indicator == nil){
        self.indicator = [[PPLIndicatorView alloc] init];
        [self.view addSubview: self.indicator];
    }else{
        self.indicator.alpha = 1;
    }
    
    [self.indicator start];
    
    dispatch_queue_t myQueue = dispatch_queue_create("My Queue",NULL);
    dispatch_async(myQueue, ^{
        if(self.manager == nil) {
            self.manager = [[PPLPhotoManager alloc] init];
            self.manager.delegate = self;
        }
        
        [self.manager loadData];
        
        self.albumTitleArray = [self.manager getAlbumCollection];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            
            [self.indicator stop];
        });
    });
}

- (void)updateViewConstraints
{
   [self.indicator mas_makeConstraints:^(MASConstraintMaker *make) {
       make.center.equalTo(self.view);
       make.width.equalTo(@100);
       make.height.equalTo(@100);
   }];
    
    [super updateViewConstraints];
}

#pragma mark TableView Data Source Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.albumTitleArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PPLAlbumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier forIndexPath:indexPath];
    PPLAlbum *album = [self.albumTitleArray objectAtIndex:indexPath.row];
    [cell.title setText: album.title];
    [cell.count setText: [NSString stringWithFormat:@"%ld",(long)album.count]];
    
    [self.manager displayPhoto:album.albumPhoto size:CGSizeMake(50, 50) completion:^(UIImage *result, NSDictionary *info) {
        cell.icon.image = result;
    }];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PPLAlbum *album = [self.albumTitleArray objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:segueIdentifier sender:album.title];
}

#pragma mark - UISearchBar Delegate Methods

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}


#pragma mark - Button Methods

- (IBAction) handleAddAlbumButtonPressed:(id)sender
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Add New Gallery"
                                                                   message:@""
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"Instagram"
                                                          style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                              [self.manager fetchInstagramPhotoWithCompletion:nil];
                                                          }];
    UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@"Flicker"
                                                           style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                               [self.manager fetchFlickerPhotoWithCompletion:nil];
                                                           }];
    
    [alert addAction:firstAction];
    [alert addAction:secondAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - PPLPhoto Manager Delegate Methods

- (void) handleOauthLogin
{
}
- (void) handlePhotoChanged
{
    [self fetchAlbum];
}
@end
