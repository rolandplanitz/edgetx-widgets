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

### 1. Download the Widget
1. Visit the official EdgeTX widget repository or the widget’s source (e.g., GitHub).
2. Download the widget's `.zip` or `.lua` file package.
3. Extract the files if they are zipped.

### 2. Copy Files to the SD Card
1. Insert the SD card from your transmitter into your computer.
2. Navigate to the following directory on the SD card:
3. Create a new folder inside `/WIDGETS/` with the name of the widget (e.g., `MyWidget`).
4. Copy the extracted widget files into this newly created folder.

### 3. Load the Widget on the Transmitter
1. Reinsert the SD card into your transmitter.
2. Power on the transmitter and access the **Model Settings** or **Global Settings** (depending on the widget type).
3. Navigate to the **Widgets Setup** page:
- Long press the `Page` button until you see the screen layout setup.
4. Select a screen or add a new one.
5. Choose the widget slot you want to use and assign the newly installed widget.

### 4. Configure the Widget
1. Depending on the widget, you might need to adjust its settings:
- Highlight the widget and press `Enter` to open the settings menu.
- Customize parameters (e.g., units, telemetry sources, display options).

### 5. Test the Widget
- Exit the configuration menu and ensure the widget is displaying or functioning as expected.

## Troubleshooting
- **Widget Not Showing Up**: Ensure the widget folder is placed correctly under `/WIDGETS/` and contains all required files.
- **SD Card Issues**: Verify the card is formatted correctly (e.g., FAT32).
- **Compatibility**: Ensure the widget is compatible with your EdgeTX version.

## Uninstallation
1. Navigate to the `/WIDGETS/` directory on your SD card.
2. Delete the folder corresponding to the widget you wish to remove.

## Additional Resources
- [EdgeTX Documentation](https://www.edgetx.org/documentation)
- [EdgeTX GitHub](https://github.com/EdgeTX)

