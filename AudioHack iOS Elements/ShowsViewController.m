//
//  ShowsViewController.m
//  
//
//  Created by Zach Whelchel on 9/15/15.
//
//

#import "ShowsViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "Show.h"

@interface ShowsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *shows;

@end

@implementation ShowsViewController

@synthesize podcast = _podcast;
@synthesize shows = _shows;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([self.podcast isEqualToString:@"This American Life"]) {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:@"http://hackathon.thisamericanlife.org/api/episodes" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {

            // Parse each of these incoming feeds into the objects we like. So no matter where we pull each of these things from we can save them for ourselves.
            
            NSDictionary *responseDict = responseObject;
            NSArray *episodes = [responseDict valueForKey:@"data"];
            
            NSMutableArray *array = [NSMutableArray array];
            
            for (NSDictionary *episode in episodes) {
                
                Show *show = [[Show alloc] init];
                show.name = [episode valueForKey:@"title"];
                
                // check if we already have the object with that id first before adding it.
                
                /*
                RLMRealm *realm = [RLMRealm defaultRealm];
                [realm transactionWithBlock:^{
                    [realm addObject:show];
                }];
                */
                
                [array addObject:show];
                
                NSLog(@"----");
                NSLog(@"%@", episode);
                NSLog(@"----");

            }
            
            self.shows = [array copy];

            [self.tableView reloadData];
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
    }
    else {
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.shows.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    Show *show = [self.shows objectAtIndex:indexPath.row];
    cell.textLabel.text = show.name;
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}

@end
