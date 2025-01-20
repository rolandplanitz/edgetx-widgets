# edgetx-widgets
A collection of reusable widgets for  EdgeTX Colour Screen 

# EdgeTX Widgets Installation Guide

EdgeTX widgets enhance the functionality of your transmitter, allowing you to customize your interface and add valuable features. Follow this guide to install and set up widgets on your EdgeTX-compatible device.

## Prerequisites

1. **EdgeTX Firmware**: Ensure your transmitter is running EdgeTX firmware.
   - [Download EdgeTX](https://www.edgetx.org/)
2. **SD Card Setup**:
   - Verify that your SD card has the correct file structure for EdgeTX.
   - Use the [EdgeTX Companion](https://www.edgetx.org/tools) to update your SD card contents, if necessary.

## Installation Steps

### 1. Download the Widgets
1. The widgets required are: BattWidget, ModelWidget, TXWidget, ClockWidget, and GPSWidget.
2. Download the download all the folders.

### 2. Copy Folders to the SD Card
1. Insert the SD card from your transmitter into your computer.
2. Navigate to the root directory on the SD card:
3. Inside the folder `/WIDGETS/` Copy all 5 folders.

### 3. Load the Widget on the Transmitter
1. Reinsert the SD card into your transmitter.
2. Power on the transmitter and access the **Model Settings** or **Global Settings** (depending on the widget type).
3. Navigate to the **Widgets Setup** page:
- Long press the `Page` button until you see the screen layout setup.
4. Select a screen or add a new one.
5. Choose the widget slot you want to use and assign the newly installed widget.

### 4. Configure the Widget
1. The widgets locations are fixed right now.
2. ## View Layout
The widgets are arranged on the transmitter’s screen using this layout  and screen configuration.
Below is an example layout:

![View Layout Example](path/to/view-layout-image.png)

### Widget Locations
Place the widgets in the order specified on the next image. Location details:

![Widget Locations](path/to/widget-locations-image.png) 

### 5. Test the Widget
- Exit the configuration menu and ensure the widget displays or functions as expected.

## Troubleshooting
- **Widget Not Showing Up**: Ensure the widget folder is placed correctly under `/WIDGETS/` and contains all required files.
- **SD Card Issues**: Verify the card is formatted correctly (e.g., FAT32).
- **Compatibility**: Ensure the widget is compatible with your EdgeTX version.

## Uninstallation
1. Navigate to your SD card's `/WIDGETS/` directory.
2. Delete the folders corresponding to the widget you wish to remove.

## Additional Resources
- [EdgeTX Documentation](https://www.edgetx.org/documentation)
- [EdgeTX GitHub](https://github.com/EdgeTX)

