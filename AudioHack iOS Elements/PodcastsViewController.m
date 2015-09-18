//
//  PodcastsViewController.m
//  
//
//  Created by Zach Whelchel on 9/15/15.
//
//

#import "PodcastsViewController.h"
#import "ShowsViewController.h"
#import "PodcastManager.h"
#import "Podcast.h"

@interface PodcastsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) RLMResults *podcasts;

@end

@implementation PodcastsViewController

@synthesize podcasts = _podcasts;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    self.podcasts = [PodcastManager podcasts];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.podcasts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    Podcast *podcast = [self.podcasts objectAtIndex:indexPath.row];
    cell.textLabel.text = podcast.name;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"Shows" sender:self];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Shows"]) {
        ShowsViewController *showsViewController = (ShowsViewController *)segue.destinationViewController;
        showsViewController.podcast = [self.podcasts objectAtIndex:self.tableView.indexPathForSelectedRow.row];
    }
}

@end
