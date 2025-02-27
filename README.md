# Route Generator

Route Generator is a tool to draw routes on a map and generate a movie from it.
This movie can be imported in your video editing software, so you can add it to
your own movies.

I have cloned this repository from SourceForge, to have the source code available
on GitHub as well, with the intention that more people are willing to contribute
to it.
	  
## Installation
On Windows use the distributed installer named routegen-winxx-x.x.exe
On Linux and Mac OS the program has to be build from source code (see below)

## Building Route Generator from the source code
Since version 1.8 Route Generator should be built using Qt 5.12 or higher. 
So Qt 5.12 or higher should be downloaded and installed. 
After your Qt build environment is setup correctly, all you need to do is:
- unzip or clone the source code in a new directory
- open a command shell with the Qt build environment correctly set-up
- cd to the the directory where you unzipped the source code
  (e.g. cd routegen/src)
- execute the following commands:
  - qmake routegen.pro  
  - make/gmake (on Linux)
  - whatever build command on other OS's

## Version history
- 1.0   -Initial version
- 1.1   -Added custom vehicle icons by adding icons (image files, e.g. *.png,
         *.jpg, etc.) to the vehicles sub-folder of routegen.
        -Added custom color selection for route path.
- 1.2   -Vehicle icon now rotates with route direction
        -Added vehicle angle correction spinbox and preview
        -Animated vehicle icons
        -Showing scrollbars for large input maps
        -Added stop button while playing back
- 1.2.1 -Bugfix in route width initialization (not released on SourceForge)
- 1.2.2 -Error checking and logging of bmp2avi execution (bmp2avi.log)
- 1.2.3 -Bugfix in frame naming, causing routes over 1000 frames to be added
         in wrong order in AVI file (during bmp2avi conversion)
- 1.3   -Route interpolation and variable route speed.
        -Preferences (bmp2avi)
        -Undo buffer
        -Route style selection
- 1.3.1 -Smooth curves experiment disabled (buggy) (see new RGRoute constructor)
        -Added advanced tab to settings dialog to:
          -Enable the buggy smooth curves code
          -Change radius of curves
          -Modify vehicle orientation parameters
        -Automatically disable draw mode, when user clicks Preview or
         Generate route.
        -Show first route point as will after first click (interpolation mode)
- 1.4   -Import from Google Maps
- 1.5   -Route generation improvements (smooth route, using bezier curves)
        -Start new route button on toolbar
        -Vehicle orientation and settings improved
        -Generate iconless begin/end frames checkbox moved to preferences dialog
        -Google maps importer fix (map scrollable and zoomable)
- 1.6   -Route editable (selected points can be moved or deleted)
        -Redo buffer
        -Codec selection for video encoding under linux 
        -Installation command for linux
        -Improvements of edit dialog for vehicle settings
        -Vehicle orientation (yes/no) is now a setting
        -Deleting files in directory when not empty (when generating movie)
        -Adding custom vehicles from vehicle settings dialog
- 1.7   -Using ffmpeg codec on Windows
        -URL format of new version of google maps now supported
        -Line width and style saved again
        -Option to add N seconds still frame before/after movie
- 1.7.1 -FFmpeg for Windows is now distributed with the Windows version of
         Route Generator and will be selected as the default at installation.
         The Zeranoe FFmpeg Windows builds are provided by Kyle Schwarz from:
		 http://ffmpeg.zeranoe.com/builds/
		 NOTE: To safe space the executables ffplay.exe and ffprobe.exe are
               removed from the distribution.
- 1.8  -Route Generator ported to Qt 5.
       -No main functional changes, however import from Google maps now works again
       -Updated Zeranoe FFmpeg to 4.1.3
- 1.8.1 -Pixel format always yuv420p (when supported by selected codec)	   -
- 1.9 release
  - GPX Import (both routes and tracks)
  - Map and route can now be saved and loaded from project files
  - Storing Geo coordinates with map and route
  - Manually enter FFMpeg commandline options
  - Maximize button of google maps
  - Increased maximum resolution of google map to 8K
  - Default output format of video files now configurable for ffmpeg (default still avi)
  - Added map and route status indicators (icons) in status bar
  - SVG format support for custom vehicles
- 1.9.1 release
  - Maximum size for custom vehicles increased
  - Vehicle movement less jerky when route moves around direct north or south
  - Fix when map boundaries cross the 180 degrees longitude boundary
  - Lat/lon to x,y using Google maps (web mercator) projection algorithm
  - More options after importing route from GPX file
  - Prevent zoomlevels with decimal numbers in Google map URL's
  - Google maps dialog geometry saved and restored
- 1.10.0 release
  - Panning and zooming of map using mouse (and wheel)
  - Possible to select map type during Google Maps import (roadmap, sattelite, terrain, etc.)
  - GPX import now automatically zooms map to boundaries of route
  - Always create new empty folder when files are detected (to prevent that
    files are lost coincidentally)
  - Fixed default location of ffmpeg on linux (removed /usr/bin); assume it
    can always be found in the PATH
  - Added more default (animated) vehicles (source: gifsanimes.com)

 
## Technical details

Route Generator is developed using the GPL version of Qt 5.15
(Copyright (C) 2008-2021  The Qt Company Ltd. All rights reserved).
Qt can be [downloaded](https://www.qt.io/download) from The Qt Company website.


On Linux, Route Generator makes use of a 3rdparty tool:
FFmpeg licensed under the LGPLv2.1.
This tool is not included in the source, so you will have to install it on
your computer before running Route Generator. Make sure it is installed if you
want to be able to generate a movie.

FFmpeg for Windows is also distributed with Route Generator for Windows
and will be selected as the default at installation.
The CODEX FFmpeg Windows builds are provided by Gyan Doshi from:
https://www.gyan.dev/ffmpeg/builds/

On Windows, Route Generator can also make use of a freeware 3rdparty tool:
Bmp2Avi (Copyright (C) Paul Roberts 1996 - 1998)
This tool is available in the subdirectory bmp2avi. By default Route Generator
tries to find bmp2avi.exe in that directory, so you can leave it there.
Route Generator will automatically check for bmp2avi.exe in this directory
when it starts up. If it cannot find it in the default location, it will ask
you to browse to a different location.
Bmp2Avi can freely be re-distributed as long as you provide the documentation
with it (also located in the bmp2avi sub-directory).

## Availability
Route Generator is build for Windows and Linux by default.
However, it's developed using the cross-platform GUI toolkit, Qt,
which is also available for other Mac. So it is also possible
to build and run Route Generator on Mac as well, but you have to build it
yourself from the source code (see building instructions below).
NOTE: Route Generator makes use of a video encoder (Bmp2Avi on Windows and 
ffmpeg on linux)! However, the video encoder is not required to run Route
Generator. The only thing that will not work without the video encoder is the
last stage of the generation process:converting a list of bmp files to an avi
file.

## License
This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

For more details about GPL see the LICENSE file 

## Contact
If you have any more questions about or problems with using and or building
Route Generator, you can contact me at: info@routegenerator.net
Of course, suggestions for improvement are also welcome!

Michiel Jansen
