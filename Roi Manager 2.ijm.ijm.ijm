/*This macro will do the following, listed in chronological order: 
Ask the user how many channels there are.
Prompt the user for which color to set each channel.
Set the channels into the correct display colors.
Display the channels in the "Composite Projection Max" setting.
Sets the measuring tool to a segmented line.
Prompts the user to set the width of the line in pixels.
Runs the "Roi-group table" endogenous plugin.
Opens the ROI Manager, the Brightness and Contrast Menu, then the Channels Tool.
Prompts the user for how many Roi groups they will be tracing.
Leads the user through measuring different cell types determined by the settings of the Roi-group table plugin.
Prompts the user to determine which channel they would like to measure. 
Measures ROI's in designated channel. */

/*To comment out code, put a "//" at the start of every line you wish to exclude.  
For longer comments, you can start and end with the characters in this and the previous comment. 
These are "/*" and its reverse.
This also works for making comments. 
ImageJ will ignore any commented code when running the macro.*/

/*Sets channels to colors determined by user in pop-up boxes.
*/

Dialog.create("How many channels are there?  Answer must be numerical.");
Dialog.addNumber("Number of channels:", 4);
Dialog.show();
channelNumber = Dialog.getNumber();

for (i = 1; i <= channelNumber; i++) {
	Dialog.create("Channel Color");
colChoice = newArray("Red", "Green", "Blue", "Cyan", "Magenta", "Yellow", "Grays");
Dialog.addRadioButtonGroup("Channel Color", colChoice, 7, 1, "Blue");
Dialog.show();
channelColor = Dialog.getRadioButton();

function recolorChannel(channelNumber, channelColor) {
	Stack.setChannel(channelNumber);
	run(channelColor); 
}

recolorChannel(i, channelColor);

}


/*Use this block if you would like to set the color of each channel manually.
In the "Stack.setChannel(n)" command, "n" should be replaced with the number of the channel you are trying to change.  You must use a numerical value or else this will not work.
In the "run(color) command, "color" should be replaced with the color you are setting the channel to.  You must spell the channel exactly as it is shown in the Channels tool.
This chunk has been commented out because of the user input section included above*/
/*Stack.setChannel(1);
run("Blue");
Stack.setChannel(2);
run("Grays"); 
Stack.setChannel(3);
run("Green");
Stack.setChannel(4);
run("Magenta");*/

//This puts the channels into the "Composite Projection Max" mode. If using a different channel display mode, substitute this code.  
//For substitutions, the macro recorder is recommended.  Record yourself putting it into the appropriate display mode, then comment out this code and add the new code. 
Property.set("CompositeProjection", "Max");
Stack.setDisplayMode("composite");

/*This changes the line type from default (straight) to segmented line.  
ImageJ has a technical term for each type of line.  For segmented lines, this is "polyline".
To change the type of line you are tracing (i.e. segmented, straight, etc.), change out the word "polyline".
Ensure that line names are in quotation marks or else this will not work.
The ImageJ terms for each line type are as follows: 
straight line is called "line"
freehand line is called "freeLine"
arrow tool is called "arrow"
As an example, if I wanted to draw straight lines, I would write the following: 
setTool("line"); */
setTool("polyline");

/*This creates a dialog box that allows the user to input the desired line width in pixels.
The input value must be a numerical integer or else this will not work.
The "3" in "Dialog.addNumber("Width in pixels:", 3);" sets the default line width to 3.
This number can be changed according to preference.*/
Dialog.create("Enter numerical");
Dialog.addNumber("Width in pixels:", 3);
Dialog.show();
lineWidth = Dialog.getNumber();
run("Line Width...", "line=lineWidth");

/*This runs the "Roi-group table" endogenous plugin.
This plugin can be installed via the Update Site in ImageJ*/
beep();
waitForUser("The ROI Group Manager is about to appear.  Click 'Import From File' then select group name settings.  Click 'Ok' to open ROI Group Manager.")
run("Roi-group Table");

//Opens ROI Manager
run("ROI Manager...");

//Opens brightness and contrast adjuster
run("Brightness/Contrast...");

//Opens Channels Tool
run("Channels Tool...");

/*This prompts the user for how many cell groups they entered into the Roi-group table plugin, then walks them through analysis of each group, 
displaying the number of the group at the top of each message box.*/

Dialog.create("How many groups do you have?");
Dialog.addNumber("Number of groups:", 8);
Dialog.show();
numberGroups = Dialog.getNumber();

for (i=1; i<=numberGroups; i++){
	run("Roi Defaults...", "color=red stroke=0 group=i");
	//waitForUser("Leave dialog open until you finish tracing cell group.  Click 'OK' only when ready to move to next cell type");
	waitForUser(i, "Leave dialog open until you finish tracing cell group.  Click 'OK' only when ready to move to next cell type");
}


/*This prompts the user for which channel they would like to measure then takes measurements.
 * The input must be numerical or this will not work.
 * If you wish to measure more than one channel, then duplicate this chunk for each additional channel that you wish to measure.
*/
Dialog.create("Which channel do you wish to measure?  Answer must be numerical.");
Dialog.addNumber("Channel:", 4);
Dialog.show();
channelMeasured = Dialog.getNumber();
Stack.setChannel(channelMeasured);
roiManager("Measure");
