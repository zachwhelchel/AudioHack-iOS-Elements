//
//  PodcastsViewController.m
//  
//
//  Created by Zach Whelchel on 9/15/15.
//
//

#import "PodcastsViewController.h"
#import "ShowsViewController.h"

@interface PodcastsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *podcasts;

@end

@implementation PodcastsViewController

@synthesize podcasts = _podcasts;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.podcasts = [NSArray arrayWithObjects:
                     @"This American Life",
                     @"Show 2",
                     @"Show 3",
                     @"Show 4", nil];
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
    cell.textLabel.text = [self.podcasts objectAtIndex:indexPath.row];
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
        if ([[self.podcasts objectAtIndex:self.tableView.indexPathForSelectedRow.row] isEqualToString:@"This American Life"]) {
            ShowsViewController *showsViewController = (ShowsViewController *)segue.destinationViewController;
            showsViewController.podcast = @"This American Life";
        }
    }
}

@end
