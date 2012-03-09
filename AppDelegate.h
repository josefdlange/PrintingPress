//
//  AppDelegate.h
//  PrintingPress
//
//  Created by Joey Lange on 5/20/09.
//  Copyright 2009 JoeyLange Designs. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/Webkit.h>


@interface AppDelegate : NSObject {
	
	// Our main window.
	IBOutlet id mainWindow;
	//Dummy tab.
	IBOutlet id dummyTab;
	// The main Tab View (hidden tabs)
	IBOutlet id tabView;
	// The tab which contains our Web View.
	IBOutlet id webViewTab;
	// The tab which contains our progress indication View.
	IBOutlet id progressViewTab;
	// The spinning wheel object in the progress indication view.
	IBOutlet id progressIndicationWheel;
	// The main Web View
	IBOutlet WebView *myWebView;
	// Our print configuration sheet.
	IBOutlet id configureSheet;
	// The cancel button on our configuration sheet.
	IBOutlet id cancelButton;
	// The Dropdown list for templates/styles
	IBOutlet id templateDropdownList;
	// The preview ImageView
	IBOutlet id previewImageView;
	// Print Button
	IBOutlet id printButton;
	// Configure Button
	IBOutlet id configureButton;
}

// Main print method.
-(IBAction)printMyView:(id)sender;
// Show configuration sheet.
-(IBAction)configurePrint:(id)sender;
// Close configuration sheet (with fun button-checking!)
-(IBAction)doneConfiguring:(id)sender;


@end



