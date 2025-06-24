# edgetx-widgets

A collection of reusable widgets for EdgeTX Colour Screen


# EdgeTX Widgets Installation Guide

EdgeTX widgets enhance the functionality of your controller, allowing you to
customize your interface and add valuable features. Follow this guide to install
and set up widgets on your EdgeTX-compatible device.


## Prerequisites

- **EdgeTX Firmware**: Ensure your controller is running EdgeTX firmware.
  - [Download EdgeTX](https://www.edgetx.org/)
  - See [SECURITY.md](SECURITY.md) for compatibility.
 
- **SD Card Setup**:
  - Verify that your SD card or internal memory has the correct file structure
    for EdgeTX.
  - Use the [EdgeTX Companion](https://www.edgetx.org/tools) to update your SD
    card or internal memory contents, if necessary.


## Installation Steps

### Download the Widgets

Download the widgets you want/need. You need the folders in `/widgets`.


### Copy Folders to the SD Card

Copy the folders from `/widgets` to your Controller under `/WIDGETS/` either on
the SD card or on the internal memory.


### Bind a Drone and Discover Sensors

In order to actually show telemetry in the widgets, your controller must have
that data.

- Power on the drone (preferably one with GPS) and the controller.
- Navigate to the **Model Settings** on your controller.
- Go to the **Telemetry** page.
- Select **Discover new sensors** and wait for the controller to detect all
  available sensors from the drone.


### Load the Widget on the Transmitter

- Reinsert the SD into your controller (if you don't have one with internal
  memory)
- Power on the controller and access the **Model Settings** or
  **Global Settings** (depending on the widget type).
- Navigate to the **Widgets Setup** page:
   - Long press the `Page` button until you see the screen layout setup.
- Select a screen or add a new one.
- Choose the widget slot you want to use and assign the newly installed widget.


### Configure the Widget

Currently the widgets are designed to be in a fixed size/location.

Example layout:
![View Layout Example](/widgets/img/screen_config.jpeg)


### Test the Widget

Exit the configuration menu and ensure the widget displays or functions as expected.


## Different Layouts / Setups

Currently there are two different Layouts.


### ELRS Model

For Drones using ELRS, pace the Widgets like this:  
![Widget Locations](/widgets/img/widget_layout.jpg)


### Simulator Model

For the Simulator model, place the Widgets like this:  
![Widget Locations](/widgets/img/widget_layout_sim.jpg)


### Steps to Configure a New Model

- **Create a New Model**:
  - Navigate to the **Model Settings** on your controller.
  - Select **Create New Model** and follow the prompts to set up the new model.

- **Configure the Layout**:
  - Access the **Widgets Setup** page for the new model.
  - Long press the `Page` button until you see the screen layout setup.
  - Select a screen or add a new one.
  - Choose the widget slots you want to use and assign the appropriate widgets
    for the model (ELRS or Simulator).

- **Assign Widgets**:
  - For each widget slot, select the widget you want to assign.
  - Configure the widget options as needed.

- **Save and Test**:
  - Exit the configuration menu and ensure the widgets display or function as
    expected.
  - Make any necessary adjustments to the layout or widget options.


## Known Issues

- **BetaFPV Flight Controllers**: Some BetaFPV flight controllers (e.g., Air 65
  or Air 75) report battery 0V RxBT. This may cause the voltage to not display
  properly. Ensure that if a metric is not displayed, it appears in the
  telemetry; otherwise, it will not be shown.


## Troubleshooting

- **Widget Not Showing Up**: Ensure the widget folder is placed correctly under
  `/WIDGETS/` and contains all required files.
- **SD Card Issues**: Verify the card is formatted correctly (e.g., FAT32).
- **Compatibility**: Ensure the widget is compatible with your EdgeTX version.
- **Switching Drones**: Every time you switch drones without restarting the
  radio controller, make sure you reset the telemetry. To reset telemetry:
  - Navigate to the **Model Settings** on your controller.
  - Go to the **Telemetry** page.
  - Select **Reset telemetry**.


## Uninstallation

1. Navigate to your SD card's `/WIDGETS/` directory.
2. Delete the folders corresponding to the widget you wish to remove.


## Additional Resources

- [EdgeTX Documentation](https://manual.edgetx.org)
- [EdgeTX GitHub](https://github.com/EdgeTX)
- [dbarrios83/edgetx-widgets](https://github.com/dbarrios83/edgetx-widgets)
