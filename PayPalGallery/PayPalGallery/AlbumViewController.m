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

static NSString * const cellReuseIdentifier = @"album";
static NSString * const segueIdentifier = @"master";

@interface AlbumViewController()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *albumTitleArray;
@property (nonatomic, strong) PPLPhotoManager *manager;

@end

@implementation AlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    dispatch_queue_t myQueue = dispatch_queue_create("My Queue",NULL);
    dispatch_async(myQueue, ^{
        if(self.manager == nil) {
            self.manager = [[PPLPhotoManager alloc] init];
        }
        
        self.albumTitleArray = [self.manager getAlbumCollection];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[self.navigationController.navigationBar setHidden:YES];
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
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PPLAlbum *album = [self.albumTitleArray objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:segueIdentifier sender:album.title];
}


@end
