**Universal Inject Generator**


This script will generate an inject-ready app to inject over the Health & Safety app in the 3DS console. The package includes code by @Syphurith, CTRtool (by profi200) and 3DStool (by dnasdw). 

This is how it works:
* This is used in conjunction with most recent (mine) Decrypt9's "Dump Health&Safety" and "Inject Health&Safety" features
* Put hs.app (dumped via Decrypt9) plus as many homebrew CIAs as you like into the input folder
* Run go.bat, you'll get one inject-ready .app per CIA
* If the last one for some reason doesn't work, you may try deep-decrypting (via Decrypt9) your CIAs first.
* To inject, rename inject-ready .app to hs.app, put it into the root of your 3DS SD card and inject via Decrypt9

You should always generate your inject-ready .apps yourself and never take ones from other persons. There might be a version mismatch in the H&S app, leading to it not working otherwise.

Discuss this script here: http://gbatemp.net/threads/project-injecting-any-app-into-health-and-safety.401697/
