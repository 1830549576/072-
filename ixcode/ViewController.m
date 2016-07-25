#import "AppDelegate.h"
#import "ViewController.h"
#import "i072ViewController.h"

#define TOOLBOX_ACCOUNT @"test1"
#define IXCODE_ACCOUNT @"test2"

@interface ViewController ()


@end

@implementation ViewController

@synthesize OUTPUT;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(conn_state_changed)
        name:globalConn.stateChangedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(response_received)
        name:globalConn.responseReceivedNotification object:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)conn_state_changed {
    if (globalConn.state == LOGIN_SCREEN_ENABLED) {
    
        if (globalConn.from_state == INITIAL_LOGIN || globalConn.from_state == SESSION_LOGIN) {

            return;
        }
        if (globalConn.from_state == REGISTRATION) {

            return;
        }
        
        OUTPUT.text = @"Connected!";

        [globalConn credential:IXCODE_ACCOUNT withPasswd:@"1"];
        [globalConn connect];

        
    } else if (globalConn.state == IN_SESSION) {
        OUTPUT.text = @"Login OK!";
    }
}

- (void)response_received {

    NSLog(@"response: %@:%@ uerr:%@",
        [globalConn.response objectForKey:@"obj"],
        [globalConn.response objectForKey:@"act"],
        [globalConn.response objectForKey:@"uerr"]);
    
    // {"obj":"associate","act":"mock","to_login_name":"TOOLBOX_ACCOUNT","data":{"obj":"test","act":"output1","data":"blah"}}
    if ([(NSString*)[globalConn.response objectForKey:@"obj"] isEqualToString:@"test"]) {
        if ([(NSString*)[globalConn.response objectForKey:@"act"] isEqualToString:@"output1"]) {
            //OUTPUT.text = [[[globalConn.response optJSONArray:@"data"] optJSONObject:1] optString:@"show" defaultValue:@"none"];
            //OUTPUT.text = [[globalConn.response optJSONArray:@"data"] optString:1];
            OUTPUT.text = [globalConn.response optString:@"data"];
        }
    }
    
    return;
}

-(void)input:(NSMutableDictionary*)data {
    NSMutableDictionary* req = [[NSMutableDictionary alloc] init];
    
    [req setObject:@"associate" forKey:@"obj"];
    [req setObject:@"mock" forKey:@"act"];
    [req setObject:TOOLBOX_ACCOUNT forKey:@"to_login_name"];
    [req setObject:data forKey:@"data"];
    
    [globalConn send:req];
}

- (IBAction)inputAction:(id)sender {
    NSMutableDictionary* data = [[NSMutableDictionary alloc] init];
    
    [data setObject:@"test" forKey:@"obj"];
    [data setObject:@"input1" forKey:@"act"];
    [data setObject:@"click" forKey:@"data"];
    
    [self input:data];
}

- (IBAction)eatBun:(id)sender {
    
    
    i072ViewController *eatBun = [[i072ViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:eatBun];
    //[self.navigationController pushViewController:eatBun animated:YES];
      [self presentViewController:nav animated:YES completion:nil];
    
    
}
@end
