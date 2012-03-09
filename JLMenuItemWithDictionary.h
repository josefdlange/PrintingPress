//
//  JLMenuItemWithDictionary.h
//  PrintingPress
//
//  Created by Joey Lange on 6/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface JLMenuItemWithDictionary : NSMenuItem {

	NSMutableDictionary *menuItemDictionary;
	
}

-(void)setValue:(id)value forKey:(NSString *)key;
-(id)valueForKey:(NSString *)key;
-(void)addEntriesFromDictionary:(NSDictionary *)otherDictionary;



@end
