//
//  EpisodesViewController.m
//  
//
//  Created by Zach Whelchel on 9/15/15.
//
//

#import "EpisodesViewController.h"

@interface EpisodesViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation EpisodesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Episode 1";
            break;
        case 1:
            cell.textLabel.text = @"Episode 2";
            break;
        case 2:
            cell.textLabel.text = @"Episode 3";
            break;
        case 3:
            cell.textLabel.text = @"Episode 4";
            break;
        case 4:
            cell.textLabel.text = @"Episode 5";
            break;
        case 5:
            cell.textLabel.text = @"Episode 6";
            break;
        default:
            break;
    }
    
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}

@end
