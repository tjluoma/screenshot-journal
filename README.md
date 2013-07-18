screenshot-journal
==================

Take a screenshot every minute and see how you're spending your day

### Background / Purpose / etc ###

I am very easily distracted, and when I get distracted I often forget what I was working on when I got distracted. Sometimes this can get nested several layers deep so I'm actually on 3-4 different tangents from where I started, with no hope of remembering what I was doing.

I've tried journalling, I even made a Keyboard Maestro macro which would prompt me every 15 minutes and log things to Day One, but I found it distracting (NOT WHAT I NEEDED) and not helpful.

I needed something completely passive, something which would just work, in the background, without bothering me, and without requiring me to do anything.

It is impractical to take a video screen-recording all day long, but what about screenshots?

### How it works ###

There are two parts:

1. [screenshot-journal.kmmacros] is a Keyboard Maestro macro which runs every minute.
2. [screenshot-journal.sh] is a shell script which takes the screenshots using [screencapture] tool in Mac OS X.


### Why Keyboard Maestro? ###

This seems like a perfect job for `launchd` but Keyboard Maestro offers a feature that I really like: the ability to tell when the screensaver is on (which is fairly easy to replicate in a shell script) ***and*** the ability to tell when the display is turned OFF (which is *not*). 

This allows us to *avoid* taking screenshots when the screensaver is *on* or the display is *off*.

### Installation ###

1. Save [screenshot-journal.sh] to /usr/local/bin/screenshot-journal.sh
2. Make it executable: 
> chmod 755 /usr/local/bin/screenshot-journal.sh
3. Import [screenshot-journal.kmmacros] to Keyboard Maestro (note: tested in Keyboard Maestro 6, not sure if it will work with earlier versions).
4. ***(Optional But Recommended)***: Install [com.tjluoma.keeprunning.keyboardmaestroengine.plist] to 
"$HOME/Library/LaunchAgents/" which will automatically launch Keyboard Maestro Engine on login, and restart it if it crashes. ***NOTE:*** If you do this, be sure to ***uncheck*** the Keyboard Maestro preference "Launch Engine At Login" to avoid having two copies of it trying to launch when you log in.



### More Options ###

* If you want to log when the computer goes to sleep and wakes up, see [SleepWatcher] 

* If your Mac has a iSight/FaceTime/Whatever camera and you want it to take pictures whenever the computer is idle, install [imagesnap].








<!-- Reference Links -->




[screencapture]: http://developer.apple.com/library/mac/#documentation/Darwin/Reference/ManPages/man1/screencapture.1.html



[screenshot-journal.sh]: screenshot-journal.sh



[screenshot-journal.kmmacros]: screenshot-journal.kmmacros
 
[SleepWatcher]: http://www.bernhard-baehr.de/

[imagesnap]: http://iharder.sourceforge.net/current/macosx/imagesnap/

[com.tjluoma.keeprunning.keyboardmaestroengine.plist]: com.tjluoma.keeprunning.keyboardmaestroengine.plist
