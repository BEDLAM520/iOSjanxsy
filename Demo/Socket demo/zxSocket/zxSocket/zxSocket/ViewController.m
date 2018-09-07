//
//  ViewController.m
//  zxSocket
//
//  Created by 张 玺 on 12-3-24.
//  Copyright (c) 2012年 张玺. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController
@synthesize socket;
@synthesize host;
@synthesize message;
@synthesize port;
@synthesize status;


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
-(void)addText:(NSString *)str
{
    status.text = [status.text stringByAppendingFormat:@"%@\n",str];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    host.text = @"192.168.1.105";
    port.text = @"54321";
	// Do any additional setup after loading the view, typically from a nib.
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)viewDidUnload
{
    [self setHost:nil];
    [self setMessage:nil];
    [self setStatus:nil];
    [self setPort:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)connect:(id)sender {
    socket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()]; 
    //socket.delegate = self;
    NSError *err = nil; 
    if(![socket connectToHost:host.text onPort:[port.text intValue] error:&err]) 
    { 
        [self addText:err.description];
    }else
    {
        NSLog(@"ok");
        [self addText:@"打开端口"];
    }
}
-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    [self addText:[NSString stringWithFormat:@"连接到:%@",host]];
    [socket readDataWithTimeout:-1 tag:0];
}


- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
}
- (IBAction)send:(id)sender {
    [socket writeData:[message.text dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
    
    [self addText:[NSString stringWithFormat:@"我:%@",message.text]];
    [message resignFirstResponder];
    [socket readDataWithTimeout:-1 tag:0];
}
-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSString *newMessage = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    [self addText:[NSString stringWithFormat:@"%@:%@",sock.connectedHost,newMessage]];
    //[socket readDataWithTimeout:-1 tag:0];
}










@end
