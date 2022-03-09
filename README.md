# ALVR Audio Scripts
Scripts for ALVR that help with getting audio to play on Linux.

## Requirements
- pipewire
- pipewire-jack
- pipewire-pulse
- qjackctl

## Usage
Before starting ALVR, run this script and make sure QJackCtl has started and connected. 

## First time usage
Start this script. Once QJackCtl starts, go to "Setup -> Options -> Patchbay Persistance" and set the file to alvr.xml (which comes with this repo), then apply your changes. Close QJackCtl and restart this script.
