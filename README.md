# ALVR Audio Script
Script for ALVR that helps with getting audio to play on Linux.

Note: Microphone might work out of the box, but might require some tweaking.
Important Note: I'm not actively using VR on Linux so I cannot really troubleshoot issues with this. 
If you are experienced enough, you can try to edit this so it works for your use case.
In the future this script may not be necessary if ALVR gets pipewire or pulseaudio support.

## Requirements
- pipewire
- pipewire-jack
- pipewire-pulse
- qjackctl

## Usage
Before starting ALVR, run this script and make sure QJackCtl has started and connected. 
![image](https://user-images.githubusercontent.com/32398752/169852788-0bebe334-d923-4f71-993a-3e73401089bd.png)

## First time usage
Start this script. Once QJackCtl starts, go to "Setup -> Options -> Patchbay Persistance".

Set the patchbay persistence file to alvr.xml (which comes with this repo), then apply your changes. 
![image](https://user-images.githubusercontent.com/32398752/169853167-37eacdb6-2beb-4a78-88bc-321c0d0f8bd2.png)

Go to the patchbay and click activate if persistence isn't on already.
![image](https://user-images.githubusercontent.com/32398752/169852534-2fa288b6-84b8-41db-9ece-f7dc836208a7.png)

Close QJackCtl and restart this script.

Then, open ALVR, go to Audio, set the playback device to "jack".
![image](https://user-images.githubusercontent.com/32398752/169852684-15549340-4a6f-49bd-b0f4-689d8ec84fdd.png)

## Microphone (experimental and possibly very broken)
If you want to try the microphone, set the first device to "surround21:CARD=Loopback,DEV=0", and the second device to "surround21:CARD=Loopback,DEV=1". 

Afterwards, you might need to configure pulseaudio to make the loopback device Surround 2.1 Input + Surround 2.1 Output. (Some games probably don't like surround microphones, needs a better solution)

If you find a cleaner solution to the microphone issue, please open an issue or maybe even a pull request.

