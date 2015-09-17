//
//  SearchViewController.m
//  AudioHack iOS Elements
//
//  Created by Zach Whelchel on 9/17/15.
//  Copyright © 2015 Zach Whelchel. All rights reserved.
//

#import "SearchViewController.h"
#import "AFOAuth2Manager.h"
#import "AFHTTPRequestSerializer+OAuth2.h"

#define kAudioSearchIdentifier @"audiosear.ch"

@interface SearchViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *searchSegmentedControl;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (strong, nonatomic) NSArray *shows;

@end

@implementation SearchViewController

@synthesize shows = _shows;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:kAudioSearchIdentifier];
    if (credential.accessToken && !credential.isExpired) {
        // Good to go with Audiosear.ch. Have a valid credential. 🎉!
    }
    else {
        // Don't have a valid Audiosear.ch credential... so let's get one.
        
        NSURL *baseURL = [NSURL URLWithString:@"https://www.audiosear.ch/api/"];
        AFOAuth2Manager *OAuth2Manager = [[AFOAuth2Manager alloc] initWithBaseURL:baseURL
                                                                         clientID:@"e99abb083fb6411c1681d878dc72b9c7f1e0cf64c4c5882b4ccf565319f2686b"
                                                                           secret:@"14a2280147c006303afe797fedb49f6e17d5b09e601e38cba51d22a4942babc4"];
        
        [OAuth2Manager authenticateUsingOAuthWithURLString:@"/oauth/token"
                                                      code:@"f5d1016ef971695ed8443c4a2532034350f06b4e7e9a3e20c14dff60975a362a"
                                               redirectURI:@"urn:ietf:wg:oauth:2.0:oob"
                                                   success:^(AFOAuthCredential *credential) {
                                                       [AFOAuthCredential storeCredential:credential withIdentifier:kAudioSearchIdentifier];
                                                   } failure:^(NSError *error) {
                                                       NSLog(@"Error: %@", error);
                                                   }];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)searchSelected:(id)sender
{
    NSURL *baseURL = [NSURL URLWithString:@"https://www.audiosear.ch/api/"];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
    
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:kAudioSearchIdentifier];
    [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
    
    [manager GET:[NSString stringWithFormat:@"/api/search/shows/%@", self.searchTextField.text]
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             
             
             
             NSDictionary *responseDict = responseObject;
             NSArray *shows = [responseDict valueForKey:@"results"];
             
             NSMutableArray *array = [NSMutableArray array];
             
             for (NSDictionary *show in shows) {
                 [array addObject:[show valueForKey:@"title"]];
             }
             
             self.shows = [array copy];
             
             [self.tableView reloadData];
             
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Failure: %@", error);
         }];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.shows.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textLabel.text = [self.shows objectAtIndex:indexPath.row];
    return cell;
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
