Table of Contents
=================
A. Short and Sweet License 
B. What's in the kit?
C. Basic Usage

Note: 'Corona' as used below and throughout SSK refers to the "Corona SDK" a product
wholly owned and affiliated with Corona Labs Inc. 


A. Short and Sweet License 

==========================

1. You MAY use anything you find in Corona SSK to:

  - make applications
  - make games 

   for free or for profit ($).



2. You MAY NOT:

   - sell or distribute Corona SSK or the sampler as your own work
   - sell or distribute Corona SSK as part of a book, starter kit, etc.


3. If you intend to use the art or external code assets/resources, 
   you must read and follow the licenses found in the various associated
   readMe.txt files near those assets.


   Note: All of the art assets in this kit are free and created by me OR
   by other folks who were kind enough to distribute their work for free.
   So, please be sure to give credit where credit is due and also be sure
   to respect their licenses.

4. It would be nice if everyone who uses SSK were to give me credit, but
   I understand thay may not always be possible.  So, if you can please
   give a shout out like: "Made with Corona SSK, by Roaming Gamer LLC."
   Also, if you want to link back to my site that would awesome too:

   http://www.roaminggamer.com/



B. What's in the kit?
=====================
This kit contains the following:
\
|
|--\readMe.txt  => This file.
|
|--\frame       => Example SP/MP game framework using SSK.
|
|--\resources   => Free assets/resources (remember to read licences.)
|
|--\sampler     => A sample application containing:
|                  - Benchmarks
|                  - Sample code from forum help
|                  - Input 'devices' (Virtual Dpad/Joystick, sliders, etc.)
|                  - Sample interfaces and interface elements
|                  - Mechanics Samples
|                  - Prototypes of games and game parts from my own efforts
|                  - Miscellaneous code snippets
|                  - and more ...
|
|--\ssk         => The SSK library in standalone form.
|
|--\winScripts  => Useful scripts for Windows(C) users.  



C. Basic Usage
==============
Note: I am working on more extensive and detailed documentation, but
until such time as that is available please read the following to get
started:

The example game 'frame' and the 'sampler' will always have the latest 
version of Corona SSK embeded in them.  

However, because you may want to use Corona SSK in your own projects, 
I am also providing it in a standalone format.  To embed Corona SSK 
in your own projects do the following.

1. Download the '\ssk' folder and all of the files under it from the Github
repository.

2. Create your own project folder.
   Ex: 'C:\myProject'

3. Copy the '\ssk' folder into your project.
   Ex: 'C:\myProject\ssk'

4. Edit main.cs and add this code before you attempt to use any of the 
   Corona SSK features (so pretty early on in the file).

>> local globals = require( "ssk.globals" ) -- Load Standard Globals

>> require("ssk.loadSSK")



5. (Optional) If you are Windows(C) user, you may want to copy the contents
of the '\winScripts' folder to your project folder.  These scripts do the 
following:
  - toAndroid.bat        => Copies the icons found in 'ssk\appicons\Android\*' to
                            the root of your project directory.
  - toiPhone.bat         => Copies the icons found in 'ssk\appicons\iPhone\*' to
                            the root of your project directory.
  - toLandScapeRight.bat => Copies the file 'ssk\build.settings.landscapeRight'
                            to the file 'build.settings' in the root of your 
                            project directory.
                            WARNING! This will overwrite any existing file.
  - toPortrait.bat       => Copies the file 'ssk\build.settings.portrait'
                            to the file 'build.settings' in the root of your 
                            project directory.
                            WARNING! This will overwrite any existing file.


Thats it (for now)!

Once the library is loaded, you may want to start using Corona SSK features
to set up the collision calculator, behaviors, etc. but that is beyond the
scope of this readMe.txt file.  As mentioned above, I will be writing
extensive and detailed documents about all of this.  Also, I will be writing 
articles about Corona SSK features on my site: 

	http://www.roaminggamer.com/

be sure to visit regularly or subscribe to my RSS feed to see these articles
when they are published.

- edo out!


