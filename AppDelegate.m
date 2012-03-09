//
//  AppDelegate.m
//  PrintingPress
//
//  Created by Joey Lange on 5/20/09.
//  Copyright 2009 JoeyLange Designs. All rights reserved.
//

#import "AppDelegate.h"
#import "JLMenuItemWithDictionary.h"

@implementation AppDelegate



//
//
//	METHOD: configurePrint
//	ARGUMENTS: (id)sender
//
//
// This rolls out our configuration sheet. Nothing trivial.
- (IBAction)configurePrint:(id)sender {
	
	[NSApp beginSheet:configureSheet modalForWindow:mainWindow
        modalDelegate:self didEndSelector:NULL contextInfo:nil];
    
}



//
//
//	METHOD: renderWebView
//	ARGUMENTS: none
//
//
// This method (renderWebView) is the meat of the app. It finds the XML document in /tmp, and takes care of
// translating it into a pretty layout in a Web View.
-(void) renderWebView {
	
	
	// Create xmlDoc, which is our Cocoa XML Document object.
	NSXMLDocument *xmlDoc;
	
	// Create err, which is just sort of a placeholder for any errors that occur. Not very important.
	NSError *err = nil;
	
	// Get the browser-friendly local URL from the filepath of the export XML file.
	NSURL *furl = [NSURL fileURLWithPath:@"/tmp/books-export/books-export.xml"];
	
	
	// Set xmlDoc to the actual XML document at the previously mentioned path.
	xmlDoc = [[NSXMLDocument alloc] initWithContentsOfURL:furl
												  options:(NSXMLNodePreserveWhitespace|NSXMLNodePreserveCDATA)
													error:&err];
	
	
	
	// Get what template we are using
	
	NSUserDefaults *myDefaults = [NSUserDefaults standardUserDefaults];
	
	
	NSString *templateIdentifier = [myDefaults stringForKey:@"currentTemplateIdentifier"];
	
	
	NSBundle *templateBundle = [NSBundle bundleWithIdentifier:templateIdentifier];
	
	
	NSString *xsltFilePath = [templateBundle pathForResource:@"printTemplate" ofType:@"xsl"];

	
	// OLDOLDOLD	Get the filepath of the XSLT file inside the app bundle and return it as an NSString named xsltFilePath.
	// OLDOLDOLD	NSString *xsltFilePath = [[NSBundle mainBundle] pathForResource:@"printTemplate" ofType:@"xsl"];
	
	
	// Take that filepath and turn it into an NSURL named xsltURL.
	
	
	NSURL *xsltURL = [NSURL fileURLWithPath:xsltFilePath];
	
	
	// Make NSString (myXSLTPiece) of the XML tag that will go into books-export.xml, to declare that it has said stylesheet.
	NSString *myXSLTPiece = [NSString stringWithFormat:@"type=\"text/xsl\" href=\"%@\"", [xsltURL description]];
	
	
	// Create an XML Node name styleSheetNode from that string we just generated.
	NSXMLNode *styleSheetNode = [NSXMLNode processingInstructionWithName:@"xml-stylesheet" stringValue:myXSLTPiece];
	// OLD DEBUG CODE --- NSLog(@"Node Created.");
	
	// Insert the node into our XML Document.
	[xmlDoc insertChild:styleSheetNode atIndex:0];
	// OLD DEBUG CODE --- NSLog(@"Child Inserted.");
	
	
	// Get a nice big NSString (displayString) that will be written to our new temporary XML file.
	NSString *displayString = [xmlDoc XMLStringWithOptions:NSXMLNodePrettyPrint];
	
	// Convert displayString into binary data (NSData instance tempFileContents), using UTF8 encoding, then write it to a file in /tmp.
	NSData *tempFileContents = [displayString dataUsingEncoding:NSUTF8StringEncoding];
	[tempFileContents writeToFile:@"/tmp/books_print_export.xml" atomically:YES];
	
	// SIDETRACK: Let's grab our no-image picture and drop it into /tmp/books-export/ so that our Web View will display it upon rendering.
	NSString *noimagePath = [[NSBundle mainBundle] pathForResource:@"no-image" ofType:@"png"];
	NSFileManager *fm = [NSFileManager defaultManager];
	[fm copyPath:noimagePath toPath:@"/tmp/books-export/no-image.png" handler:fm];
	
	// Get the URL of the XML file we just wrote to, and put it in a NSURL, WebViewFileURL.
	NSURL *WebViewFileURL = [NSURL fileURLWithPath:@"/tmp/books_print_export.xml"];
	
	// Make a NSURLRequest from that URL (which, I'm assuming, is the headers responsible for a HTTP request).
	NSURLRequest *WebViewFileRequest = [NSURLRequest requestWithURL:WebViewFileURL];
	[[myWebView mainFrame] loadRequest:WebViewFileRequest];


	
	// OLD DEBUG CODE --- NSLog([WebViewFileURL description]);
	
	
	// Load the file request into the Web View. We _should_ be done now!
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinish:) name:WebViewProgressFinishedNotification object:nil];
	

	
}


//
//
//	METHOD: didFinish:
//	ARGUMENTS:  (NSNotification *)notification
//
//
//	This method will switch back to the Web View that's been working in the background
//	and stop the animation of our ProgressIndicator.
-(void)didFinish:(NSNotification *)notification {
	[progressIndicationWheel stopAnimation:self];
	[tabView selectTabViewItem:webViewTab];	
	[printButton setEnabled:YES];
	[configureButton setEnabled:YES];
}


//
//
//	METHOD: doneConfiguring
//	ARGUMENTS: (id)sender
//
//
// This method's a little tricky. It's called when the user either
// clicks "Generate" or "Cancel" on the exposed sheet. If the user
// clicks "Generate", then the sheet will roll away, the Web View
// will be rendered, and the cancel button will be activated
// (because at launch, it's de-activated, and it's easier and harmless
// to just activate it regardless of state rather than checking first.
// If the user just clicked "Cancel, then the sheet rolls away. This
// was a really long explanation. Oh well.

- (IBAction)doneConfiguring:(id)sender {
    [configureSheet orderOut:nil];
	[NSApp endSheet:configureSheet];
	if ([[sender title] isEqual:@"Generate"]) {
		[configureButton setEnabled:NO];
		[tabView selectTabViewItem:progressViewTab];
		[progressIndicationWheel setUsesThreadedAnimation:YES];
		[progressIndicationWheel startAnimation:self];
		NSTimer *justASecond = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(renderWebView) userInfo:nil repeats:NO];
		[justASecond retain];
		[cancelButton setEnabled:YES];

	}
}



//
//
//	METHOD: startup
//	ARGUMENTS: (NSTimer *)theTimer
//
//
// This is the method our timer calls when it is fired. The method itself
// calls "configurePrint", which rolls out our configuration sheet, then
// it releases the theTimer object (which, in this case, is myTimer.)

-(void) startup:(NSTimer *)theTimer {
	[self configurePrint:self];
	[theTimer release];
}


//
//
//	METHOD: printMyView
//	ARGUMENTS: (id)sender
//
//
// This method sends the print message to the proper nested view in our WebView.
-(IBAction) printMyView:(id)sender {
	
	[[[[myWebView mainFrame] frameView] documentView] print:sender];
	
}


//
//
//	METHOD: setSelectedTemplate
//
//
//	This method takes the selected menu item and sets the NSDefaults value for xsl file
//	to that of the newly-selected menu item, as well as changing the preview image to the
// same.
-(void)setSelectedTemplate:(id)sender {
	
	NSString *itemIdent = [NSString stringWithFormat:@"%@",[sender valueForKey:@"templateIdentifier"]];
	NSImage *itemImage = [sender valueForKey:@"previewImageFile"];
	[previewImageView setImage:itemImage];
	NSUserDefaults *myDefaults = [NSUserDefaults standardUserDefaults];
	[myDefaults setValue:itemIdent forKey:@"currentTemplateIdentifier"];
	
	// NSLog(@"%@", [myDefaults valueForKey:@"currentTemplateIdentifier"]);
	
	}


//
//
//	METHOD: populateStyleList
//
//
// This method will look in the bundle and find all the styles included. 
// We're using bundles with the extension: ".booksprintstyle"
-(void) populateStyleList {

	NSArray *bundleTemplatesPaths = [[NSBundle mainBundle] pathsForResourcesOfType:@"booksprintstyle" inDirectory:nil];
	[bundleTemplatesPaths retain];
	
	NSEnumerator *enumerator = [bundleTemplatesPaths objectEnumerator];
	id originalFilePath;
	
	NSMutableArray *templateDictionaries = [NSMutableArray array];
	
	while (originalFilePath = [enumerator nextObject]) {
		NSBundle *myBundle = [NSBundle bundleWithPath:originalFilePath]; 
		NSString *templateIdentifier = [myBundle bundleIdentifier];
		NSString *templateName = [myBundle objectForInfoDictionaryKey:@"CFBundleDisplayName"];
		NSImage *previewImageFile = [[NSImage alloc] initWithContentsOfFile:[myBundle pathForResource:@"preview-image" ofType:@"png" inDirectory:nil]];
		NSArray *keys = [NSArray arrayWithObjects:@"templateName", @"templateIdentifier", @"previewImageFile", nil];
		NSArray *values = [NSArray arrayWithObjects:templateName, templateIdentifier, previewImageFile, nil];
		NSDictionary *templateBundlesDictionary = [NSDictionary dictionaryWithObjects:values forKeys:keys];
		[templateDictionaries addObject:templateBundlesDictionary];
	}
	
	NSEnumerator *dropDownEnumerator = [templateDictionaries objectEnumerator];
	id currentDropDownItem;
	
	NSMenu *myMenu = [[NSMenu alloc] initWithTitle:@"Choose a Template"];
	
	while(currentDropDownItem = [dropDownEnumerator nextObject]) {
		
		NSString *earlyItemName = [NSString stringWithFormat:@"%@",[currentDropDownItem objectForKey:@"templateName"]];
		NSString *itemName = [earlyItemName substringFromIndex:20];
		JLMenuItemWithDictionary *myMenuItem = [[JLMenuItemWithDictionary alloc] initWithTitle:itemName
															action:@selector(setSelectedTemplate:)
													 keyEquivalent:@""];
		
		[myMenuItem addEntriesFromDictionary:currentDropDownItem];
		[myMenu addItem:myMenuItem];
		
		
		
	}
	
	[templateDropdownList setMenu:myMenu];
	[templateDropdownList selectItemWithTitle:@"Rounded"];
	int genericIndex = [templateDropdownList indexOfItemWithTitle:@"Rounded"];
	[myMenu performActionForItemAtIndex:genericIndex];
	

	
}


//
//
//	METHOD: awakeFromNib
//	ARGUMENTS: none
//
//
// This is what's going on when we awake from our NIB: First, we'll populate 
// the style listing. Then, we set the cancel button's enabled property to NO 
// (it's obviously the most important thing in the app, right? Anyway, then 
// it makes sure the progress indication view is showing, then it initializes 
// a timer to ensure that the window is completely initialized before opening
// up the sheet.
-(void) awakeFromNib {
	[printButton setEnabled:NO];
	
	// Populate style list.
	[self populateStyleList];
	
	// Put up the dummy view.
	[tabView selectTabViewItem:dummyTab];
	
	
			NSTimer *myTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startup:) userInfo:nil repeats:NO];
			[myTimer retain];
	[mainWindow setDelegate:self];
	
}

- (void)windowWillClose:(NSNotification *)aNotification {
	[NSApp terminate:self];
}


@end
