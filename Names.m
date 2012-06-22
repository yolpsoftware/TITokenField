//
//  Names.m
//  TokenFieldExample
//
//  Created by Tom on 06/03/2010.
//  Copyright 2010 Tom Irving. All rights reserved.
//

#import "Names.h"

@implementation Names

+ (NSArray *)listOfNames {
	
	// Generated with http://www.kleimo.com/random/name.cfm
	
	return [NSArray arrayWithObjects:
			@"Samuel Prescott",
			@"Grace Mcburney", 
			@"Rosemary Sells",
			@"Janet Canady",
			@"Gregory Leech",
			@"Geneva Mcguinness",
			@"Billy Shin",
			@"Douglass Fostlick",
			@"Roberta Pedersen",
			@"Earl Rashid",
			@"Matthew Hooks",
			@"Regina Toombs",
			@"Victor Sisneros",
			@"Beverly Covington",
			@"Steve Crews",
			@"Carlos Trejo",
			@"Victoria Delgadillo",
			@"Leah Greenberg",
			@"Deborah Depew",
			@"Jeffery Khoury",
			@"Kathryn Worsham",
			@"Olivia Brownell",
			@"Gary Pritchard",
			@"Susan Cervantes",
			@"Olvera Nipplehead",
			@"Debra Graves",
			@"Albert Deltoro",
			@"Carole Flatt",
			@"Philip Vo",
			@"Phillip Wagstaff",
			@"Xiao Jacquay",
			@"Cleotilde Vondrak",
			@"Carter Redepenning",
			@"Kaycee Wintersmith",
			@"Collin Tick",
			@"Peg Yore",
			@"Cruz Buziak",
			@"Ardath Osle",
			@"Frederic Manusyants",
			@"Collin Politowski",
			@"Hunter Wollyung",
			@"Cruz Gurke",
			@"Sulema Sholette",
			@"Denver Goetter",
			@"Chantay Phothirath",
			@"Arlean Must",
			@"Carlo Henggeler",
			@"Daughrity Maichle",
			@"Zada Wintermantel",
			@"Denver Kubu",
			@"Carlo Guzma",
			@"Emory Swires",
			@"Kirby Manas",
			@"Tobie Spirito",
			@"Lane Defaber",
			@"Sparkle Mousa",
			@"Chantay Palczynski",
			@"Denver Perfater",
			@"Tom Irving",
			nil];
}

@end

@implementation Base64Encoder
    
- (NSString*)base64forData:(NSData*)theData {
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding] autorelease];
}

@end


