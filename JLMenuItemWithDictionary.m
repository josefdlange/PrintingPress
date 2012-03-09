//
//  JLMenuItemWithDictionary.m
//  PrintingPress
//
//  Created by Joey Lange on 6/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "JLMenuItemWithDictionary.h"


@implementation JLMenuItemWithDictionary

-(id)initWithTitle:(NSString *)title action:(SEL)selector keyEquivalent:(NSString *)charCode {
	if(self=[super initWithTitle:title action:selector keyEquivalent:charCode]) {
		menuItemDictionary = [[NSMutableDictionary alloc] init];
	}
	return self;
}

-(void)setValue:(id)myValue forKey:(NSString *)myKey {

	[menuItemDictionary setValue:myValue forKey:myKey];
	
}

-(id)valueForKey:(NSString *)myKey {
	
	return [menuItemDictionary valueForKey:myKey];
	
}


-(void)addEntriesFromDictionary:(NSDictionary *)otherDictionary {

	[menuItemDictionary addEntriesFromDictionary:otherDictionary];
	
}

@end
