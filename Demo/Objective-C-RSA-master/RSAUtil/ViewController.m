//
//  ViewController.m
//  RSAUtil
//
//  Created by ideawu on 7/14/15.
//  Copyright (c) 2015 ideawu. All rights reserved.
//

#import "ViewController.h"
#import "RSA.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];

//    NSString *pubkey =  @"-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDutVFeIo3mYNcFW36n26XfrF7d\njBuZmZih4a7mkKyyR9GRkmtCCYrsJJbsxLbRYixfrrVWpXnjV+hzzCBgwMwI+Tui\n7XruYfxsaVk5Bm4lmtFtnZEOEKZzwPk4RVxJIj5E7Ke/vFJeAMzIF3lm5RjqIega\naxs2NBY4KTSeFoDYWwIDAQAB\n-----END PUBLIC KEY-----";
////
//    NSString *privkey =   @"-----BEGIN PRIVATE KEY-----\nMIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAO61UV4ijeZg1wVb\nfqfbpd+sXt2MG5mZmKHhruaQrLJH0ZGSa0IJiuwkluzEttFiLF+utValeeNX6HPM\nIGDAzAj5O6Lteu5h/GxpWTkGbiWa0W2dkQ4QpnPA+ThFXEkiPkTsp7+8Ul4AzMgX\neWblGOoh6BprGzY0FjgpNJ4WgNhbAgMBAAECgYAVjT9MbXg8TY/8Rtd3lkgymqBy\nBj1Tr99s9jBRVsyQyBUuvHZ8ntnxGhiaReRvoRp6hQ6QRR5tHTm6grqFocKJ/DXO\nutp+tIF2TT1DH4j4NgpkW19yeqMfhpdScuIJG7RQMhbcNhqxbimE6XRipOMrs9PV\nDpwyjPu2bKPgRuL/AQJBAP71p1uAfPWuueGRV6IP9jzA3n/HlyM7+A8LJXCwgGF3\n1r/gZOHQhr7CjRZ/+yVKssBDWZnGOgvdPhI7QE5DQdsCQQDvrq/e7/LfVp5LkxTM\nw0NxKWtYotXN5JIIQCVW4NPiKFgBd8b5iE64J/NQhq1p+bcv0n1ODe/GhLdyNRNr\nbMuBAkAOSwM40/ktZMAy7wz0nuR0/3L5wtysMv5zCXLt4FcyH5/AXfoJ1sDXDN0P\n99jCfG+M67moLz6tz5ddOkkemhKlAkEAmaDXu8cDXuIvTnO1FlZmaSdKViLxdip2\n6/DpvhkX1tNTLYWvtQwIoQOCcvAQQWg9YdrCVICcWxuAViTtEKNIgQJBAKM7Y5P2\nYZbT410yYW8msOkUFNVhSV8PdI1DZ7QS7CZPwSfy97oojyg5NP2AeC+cZnyKr3Md\ndd7InlIp0TPzt4k=\n-----END PRIVATE KEY-----";
    
////
//	NSString *pubkey = @"-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDEChqe80lJLTTkJD3X3Lyd7Fj+\nzuOhDZkjuLNPog3YR20e5JcrdqI9IFzNbACY/GQVhbnbvBqYgyql8DfPCGXpn0+X\nNSxELIUw9Vh32QuhGNr3/TBpechrVeVpFPLwyaYNEk1CawgHCeQqf5uaqiaoBDOT\nqeox88Lc1ld7MsfggQIDAQAB\n-----END PUBLIC KEY-----";
//	NSString *privkey = @"-----BEGIN RSA PRIVATE KEY-----\nMIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAMQKGp7zSUktNOQk\nPdfcvJ3sWP7O46ENmSO4s0+iDdhHbR7klyt2oj0gXM1sAJj8ZBWFudu8GpiDKqXw\nN88IZemfT5c1LEQshTD1WHfZC6EY2vf9MGl5yGtV5WkU8vDJpg0STUJrCAcJ5Cp/\nm5qqJqgEM5Op6jHzwtzWV3syx+CBAgMBAAECgYEApSzqPzE3d3uqi+tpXB71oY5J\ncfB55PIjLPDrzFX7mlacP6JVKN7dVemVp9OvMTe/UE8LSXRVaFlkLsqXC07FJjhu\nwFXHPdnUf5sanLLdnzt3Mc8vMgUamGJl+er0wdzxM1kPTh0Tmq+DSlu5TlopAHd5\nIqF3DYiORIen3xIwp0ECQQDj6GFaXWzWAu5oUq6j1msTRV3mRZnx8Amxt1ssYM0+\nJLf6QYmpkGFqiQOhHkMgVUwRFqJC8A9EVR1eqabcBXbpAkEA3DQfLVr94vsIWL6+\nVrFcPJW9Xk28CNY6Xnvkin815o2Q0JUHIIIod1eVKCiYDUzZAYAsW0gefJ49sJ4Y\niRJN2QJAKuxeQX2s/NWKfz1rRNIiUnvTBoZ/SvCxcrYcxsvoe9bAi7KCMdxObJkn\nhNXFQLav39wKbV73ESCSqnx7P58L2QJABmhR2+0A5EDvvj1WpokkqPKmfv7+ELfD\nHQq33LvU4q+N3jPn8C85ZDedNHzx57kru1pyb/mKQZANNX10M1DgCQJBAMKn0lEx\nQH2GrkjeWgGVpPZkp0YC+ztNjaUMJmY5g0INUlDgqTWFNftxe8ROvt7JtUvlgtKC\nXdXQrKaEnpebeUQ=\n-----END RSA PRIVATE KEY-----";
//    NSLog(@"\n%@",pubkey);
//    NSLog(@"\n%@",privkey);

	NSString *originString = @"123456";
    NSLog(@"%ld",originString.length);
    
    NSString *encStr = [RSA encryptString:originString];
    NSLog(@"enr   \n%@",encStr);
    
    NSString *decStr = [RSA decryptString:encStr];
    NSLog(@"decStr   \n%@",decStr);
    

    
//    NSString *pri_encStr = [RSA  dec];
	
//	// by PHP
//    encWithPubKey = @"SR55KyfDkRioUS8djCLFHp716ngDsMLy0Y+ih86U9ia1dPAK+/gqM764vo7VKI9Nk3+kvDS0QION5467CAR8ioN8IXpEUSrZWVTem2v6xUI6WgXOPw98sSh6lNjgMLhJstFhLJaTBTTudcNP7XuBzyKqK3MOXublZ8Zo2bSbIxE=";
//	decWithPrivKey = [RSA decryptString:encWithPubKey privateKey:privkey];
//	NSLog(@"(PHP enc)Decrypted with private key: %@", decWithPrivKey);
//	
//	// Demo: encrypt with private key
//	// TODO: encryption with private key currently NOT WORKING YET!
	//encWithPrivKey = [RSA encryptString:originString privateKey:privkey];
//	//NSLog(@"Enctypted with private key: %@", encWithPrivKey);
//
//	// Demo: decrypt with public key
//    encWithPrivKey = @"SR55KyfDkRioUS8djCLFHp716ngDsMLy0Y+ih86U9ia1dPAK+/gqM764vo7VKI9Nk3+kvDS0QION5467CAR8ioN8IXpEUSrZWVTem2v6xUI6WgXOPw98sSh6lNjgMLhJstFhLJaTBTTudcNP7XuBzyKqK3MOXublZ8Zo2bSbIxE=";
//	decWithPublicKey = [RSA decryptString:encWithPrivKey publicKey:pubkey];
//	NSLog(@"(PHP enc)Decrypted with public key: %@", decWithPublicKey);
    
    
}

@end
