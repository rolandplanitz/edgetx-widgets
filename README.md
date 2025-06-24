# edgetx-widgets
A collection of reusable widgets for EdgeTX Colour Screen

# EdgeTX Widgets Installation Guide

EdgeTX widgets enhance the functionality of your transmitter, allowing you to customize your interface and add valuable features. Follow this guide to install and set up widgets on your EdgeTX-compatible device.

## Prerequisites

1. **EdgeTX Firmware**: Ensure your transmitter is running EdgeTX firmware.
   - [Download EdgeTX](https://www.edgetx.org/)
   - See [SECURITY.md](SECURITY.md) for compatibility.
2. **SD Card Setup**:
   - Verify that your SD card has the correct file structure for EdgeTX.
   - Use the [EdgeTX Companion](https://www.edgetx.org/tools) to update your SD card contents, if necessary.

## Installation Steps

### 1. Download the Widgets
1. The widgets required are: BattWidget, ModelWidget, TXWidget, ClockWidget, and GPSWidget.
2. Download all the folders.

### 2. Copy Folders to the SD Card
1. Insert the SD card from your transmitter into your computer.
2. Navigate to the root directory on the SD card:
3. Inside the folder `/WIDGETS/`, copy all 5 folders.

### 3. Bind a Drone and Discover Sensors
1. Before setting up all the widgets, bind a drone (preferably with GPS) to your transmitter.
2. Power on the drone and the transmitter.
3. Navigate to the **Model Settings** on your transmitter.
4. Go to the **Telemetry** page.
5. Select **Discover new sensors** and wait for the transmitter to detect all available sensors from the drone.

### 4. Load the Widget on the Transmitter
1. Reinsert the SD card into your transmitter.
2. Power on the transmitter and access the **Model Settings** or **Global Settings** (depending on the widget type).
3. Navigate to the **Widgets Setup** page:
   - Long press the `Page` button until you see the screen layout setup.
4. Select a screen or add a new one.
5. Choose the widget slot you want to use and assign the newly installed widget.

### 5. Configure the Widget
1. The widgets locations are fixed right now.
2. ## View Layout
The widgets are arranged on the transmitter’s screen using this layout and screen configuration.
Below is an example layout:

![View Layout Example](/widgets/img/screen_config.jpeg)



### 6. Test the Widget
- Exit the configuration menu and ensure the widget displays or functions as expected.

## Configuring Models with Different Layouts

### ELRS Model

### Widget Locations
Place the widgets in the order specified on the next image. Location details:

![Widget Locations](/widgets/img/widget_layout.jpg)

For the ELRS Receiver model, configure the following widgets:

1. **ModelWidget**
2. **ClockWidget**
3. **BattWidget**
4. **RXWidget**
5. **GPSWidget**

### Simulator Model
For the Simulator model, configure the following widgets:

### Widget Locations
Place the widgets in the order specified on the next image. Location details:

![Widget Locations](/widgets/img/widget_layout_sim.jpg)

1. **SimModel**
2. **SimStickLayout**

### Steps to Configure a New Model

1. **Create a New Model**:
   - Navigate to the **Model Settings** on your transmitter.
   - Select **Create New Model** and follow the prompts to set up the new model.

2. **Configure the Layout**:
   - Access the **Widgets Setup** page for the new model.
   - Long press the `Page` button until you see the screen layout setup.
   - Select a screen or add a new one.
   - Choose the widget slots you want to use and assign the appropriate widgets for the model (ELRS or Simulator).

3. **Assign Widgets**:
   - For each widget slot, select the widget you want to assign (e.g., `ModelWidget`, `ClockWidget`, `BattWidget`, `RXWidget`, `GPSWidget` for ELRS model or `SimModel`, `SimStickLayout` for Simulator model).
   - Configure the widget options as needed.

4. **Save and Test**:
   - Exit the configuration menu and ensure the widgets display or function as expected.
   - Make any necessary adjustments to the layout or widget options.

## Known Issues
- **BetaFPV Flight Controllers**: Some BetaFPV flight controllers (e.g., Air 65 or Air 75) report battery 0V RxBT. This may cause the voltage to not display properly. Ensure that if a metric is not displayed, it appears in the telemetry; otherwise, it will not be shown.

## Troubleshooting
- **Widget Not Showing Up**: Ensure the widget folder is placed correctly under `/WIDGETS/` and contains all required files.
- **SD Card Issues**: Verify the card is formatted correctly (e.g., FAT32).
- **Compatibility**: Ensure the widget is compatible with your EdgeTX version.
- **Switching Drones**: Every time you switch drones without restarting the radio transmitter, make sure you reset the telemetry. To reset telemetry:
  1. Navigate to the **Model Settings** on your transmitter.
  2. Go to the **Telemetry** page.
  3. Select **Reset telemetry**.

## Uninstallation
1. Navigate to your SD card's `/WIDGETS/` directory.
2. Delete the folders corresponding to the widget you wish to remove.

## Additional Resources
- [EdgeTX Documentation](https://manual.edgetx.org)
- [EdgeTX GitHub](https://github.com/EdgeTX)
