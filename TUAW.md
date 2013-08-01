# Terminally Geeky Time Tracking via Screenshots

<blockquote class="twitter-tweet"><p>Here’s an eye-opener: a <a href="https://twitter.com/keyboardmaestro">@keyboardmaestro</a> macro which takes a screenshot every 30 seconds. Review at the end of the day to see where it went.</p>&mdash; TJ Luoma (@TJLuoma) <a href="https://twitter.com/TJLuoma/statuses/357882327474515968">July 18, 2013</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

"Where did the time go today?" I suspect this is a question that everyone has asked themselves at some point. It happened to me enough that I decided to start tracking myself. The results have been unsettling, but helpful.

I suspect most people have similar problems and similar questions: "What did I spend my time on today? I can think of several different things, but I know I'm forgotten a lot. I was in the middle of something and then someone asked me for something else, and when I went to find the answer to that I realized that I needed to finish this other thing over here, and… Did I start something else in the middle of all this? Oh yeah, that idea I had… I know I started some notes about that somewhere… but where?

### "Have you tried…"

Yes. I've tried lots of different ways of keeping track of my time.

I've tried keeping a piece of paper at my desk that I would use to write down everything I did. That worked great… when I remembered to do it. Most of the time I found it distracting to have to stop and write down what I was doing, or what I had just done.

I've tried [Day One], I even wrote a script that automatically prompted me to write down what I was doing every 15 minutes. But that just meant more interruptions. I tried making it less intrusive (a Growl notification prompting me to make a note in Day One) but that was still a distraction, and I still didn't do it most of the time.

I've even tried apps specifically for time tracking, such as the excellent [TimeSink]. If you're interested in tracking your time and want something that looks nicer and works more easily than my setup, I would suggest trying out TimeSink. You can demo it for two weeks, and there's a 60-day money-back guarantee. Just because *I* took the nerdy route doesn't mean it's a better way for everyone.

### Set It and Forget It ###

My solution involves a shell script and Keyboard Maestro  which should come as a surprise to exactly no one. There is a way to do it without Keyboard Maestro, but it lacks some of the features. I will explain that more at the end.

The basic concept is simple: Every minute, the computer takes a screenshot and saves it to a specific folder with a specific filename. The process is completely automatic and silent, no distractions and nothing to remember. At the end of the day (or anytime during the day), I can look back through the screenshots and piece together my day.

After the initial setup, I don't have to do anything to anything to maintain it. By default, the script keep 7 days' worth of screenshots, but you can easily change that.

### Why I like this setup

I find this more helpful than just knowing how long I spent in a particular app because I could have spent 2 hours in Safari doing actual research or I could have spent 5 minutes doing research and the rest of the time chasing rabbits across Wikipedia. I could have spent 30 minutes in BBEdit working on an article, or I could have spent 90 minutes in BBEdit creating a shell script that will save me 10 seconds. And so on.

Having a screenshot library of the day also means that I have  a chance of remembering things based on vague visual memory.  I often myself wishing I could go back and find something that I read online, but can't remember if it was Twitter or Tumblr or RSS or something else. "If I could just see it again I'd remember it." If I was looking at it for more than a minute, I have a screenshot of it. I

Once a minute isn't frequent enough to catch *everything* of course, but it is the digital equivalent of breadcrumbs, and it's a good place to start. I've experimented with shorter and longer times but I keep coming back to one image per minute.

I have also added a *second* script which is triggered whenever an app takes focus, more on that below.


### Two Options ###

This script was originally designed to work with [Keyboard Maestro] for the simple reason that it works *better* in Keyboard Maestro. The script can provide more information coming from Keyboard Maestro, and Keyboard Maestro can also automatically detect when the screensaver is running *or* when your Mac's display is turned off. That means that Keyboard Maestro can prevent the script from taking a screenshot when all you're going to get is a blank screen. [^ScreenIsOff]

That being said, I realize that some people can't or won't go for Keyboard Maestro, I have added a second option using `launchd`. (Note that you should only choose one of these options, not both.)

Screenshots will be saved to **$HOME/Pictures/screenshot-journal/.** Inside that folder a new folder will automatically be created for each day. The format for those folders is YYYY-MM-DD which makes it easy to sort them in Finder.



### Option #1: Keyboard Maestro

Setting this up in Keyboard Maestro is simple. *(Note: I've only tested this with Keyboard Maestro version 6, but it may work with 5).*

1. Download [screenshot-journal.sh]
2. Save it somewhere in your $PATH such as /usr/local/bin/
3. Make sure it is executable (`chmod 755 screenshot-journal.sh`)
4. Download [SSJ-Timed.kmmacros] and double click the file to import it into Keyboard Maestro.
5. (Optional) Download [SSJ-App-Switch.kmmacros] and double click the file to import it into Keyboard Maestro.

By default the Keyboard Maestro macro [SSJ-Timed.kmmacros] is set to run once every minute when you are logged, all day long. You can adjust that in the Keyboard Maestro Editor. You can have it run every "X" minutes or seconds, and you can tell it to only run during certain hours, i.e. maybe you only want to track what you do between 9:00 a.m. and 6:00 p.m.[^OptionalKMstep]

The macro [SSJ-App-Switch.kmmacros] will run whenever a new app 'activates' (in Keyboard Maestro parlance, aka "takes focus"). This is an optional step which result in more screenshots being taken, but the end result is more complete reconstruction of your day. It's possible that you might switch to an app, write yourself an important note, and then switch back again before [SSJ-Timed.kmmacros] runs.

*N.B:* If you want to be able to track specific websites such as Facebook, I highly recommend creating Site Specific Browsers using [Fluid] and then use [Choosy] to automatically direct clicked links to those browsers. I wrote about this in [A better Google search experience with Choosy, Keyboard Maestro and Fluid] and [Protect yourself from being tracked by Google, Facebook, and others].


#### Filenames when used with Keyboard Maestro ####

When using Keyboard Maestro you will get much more descriptive filenames which will include the name of the current front-most app and the current document title (if any).

So, for example, here is one of my most recent entries in today's folder:

	15.18.02 [MultiMarkdown Composer] {TUAW.md} timed.gif

The first set of numbers is the current time (Mac OS X's filesystem does not like colons in filenames, so I use "." instead.) The [brackets] contain the name of the front-most *application* and the {braces} contain the name of the front-most *window,* both of which are recorded by Keyboard Maestro. So, even before I look at the image, I have some idea of what it will show me: it's a screeenshot of when I was writing an article for TUAW using [MultiMarkdown Composer]. 

The word 'timed' means that this screenshot was taken by [SSJ-Timed.kmmacros]. Here is a similar screenshot taken from when I *switched to* MultiMarkdown Composer from another app

	15.37.48 [MultiMarkdown Composer] {TUAW.md} switch.gif

You will notice that this filename ends with "switch" (instead of "timed") indicating this screenshot was taken by [SSJ-App-Switch.kmmacros].

The filenames are designed to be easily sorted in Finder (which will sort them chronologically due to the timestamp as the first part of the filename), as well as easily parsed later on if you want to just find certain apps or certain window names.

(Unix note: the whitespace between the fields is one tab followed by one space.)

### Option #2: launchd

If you can't / won't use Keyboard Maestro for some reason, you *can* use this script from `launchd`.

1. Download [screenshot-journal.sh]
2. Save it somewhere in your $PATH such as /usr/local/bin/
3. Make sure it is executable (chmod 755 screenshot-journal.sh)
4. Download [com.tjluoma.screenshot-journal.plist] and move it to $HOME/Library/LaunchAgents/
5. Either restart/logout or load the plist manually using `launchctl`

Those five steps are required. There is one additional optional step: Download [beengone], a free program from our very own [Brett Terpstra] which will tell you how many minutes the user has "been gone" from the computer. If `beengone` is installed, `screenshot-journal.sh` will use it to check to see if the computer is idle. (You can even set the number of minutes before the computer is considered idle just by editing one line in `screenshot-journal.sh`. By default it is 5 minutes.)

Using `launchd` means that you will not be able to add the current app and current window name in the filenames of the screenshots, or take a screenshot whenever you switch apps. For that reason I highly recommend Keyboard Maestro over `launchd` but I include it as another option.

### What happens if the computer is idle?

If you are using either Keyboard Maestro or `beengone` (meaning the script can tell if you are idle), you can use [imagesnap] to get an image captured from the iSight/FaceTime camera on your Mac, if it has one. 

I added that so I can see if I was on the phone, or talking to someone in my office, or just not in my office, any of which might provide a clue as to what I was doing when I wasn't using the computer.

If you don't have [imagesnap] installed, no image will be captured when the computer is known to be idle.

### What to *do* with this information ###

There's no reason to keep track of this information if you're not going to review it. I suggest taking some time at the end of the day to go through the folder of images. A good way to do this is to find today's folder in **$HOME/Pictures/screenshot-journal** and change to "Cover Flow" (either by pressing <kbd>⌘</kbd> + <kbd>4</kbd>  or select the "View" menu item and then the "as Cover Flow" option). Then you can use the up and down arrow keys to move through the images, and press the spacebar to take a closer "quick look" view at any particular image.

It may also be helpful to group images into *folders* describing each task, especially if you tend to go back and forth between tasks during the day. Putting all of the images together into one folder will give you an easy way to see how long you spent on a particular task. I was surprised to find that on a day when I thought I had "barely checked email" I had actually spent over 40 minutes in my email client, which might not seem like a lot, but was far more than I would have guessed.

I also learned that during the course of one day I worked on about 30 different "projects" but didn't work on any of them for very long. Most of them maxed out at about 20 minutes. But what surprised me the most was that I had switched between tasks so frequently that I was often touching three different "projects" in the span of 20 minutes, or less. But at least there was only one image in the "Facebook" folder (and it would have been zero except I had been "tagged" in an image and wanted to see what it was).

I don't plan to go through every day and make those folders, but it seems like a useful thing to do occasionally, especially if I'm having one of those "How did it get to be 8 p.m. already?!" days.

### Hard drive and CPU usage ###

On my 2.13 GHz Core 2 Duo MacBook Air, I do not even notice when the script runs, even when I had it running every 30 seconds. One day I had about 15 *hours* worth of images, with a new image every 30 seconds and it took about 160 MB of hard drive space. After reviewing the images, there's no real need to keep them, so you can just trash the entire folder. The script creates GIF images to minimize disk usage. Obviously if you have a retina MacBook Pro, those images will be larger, but again, this isn't intended as long term storage.



<!-- Footnotes -->


[^ScreenIsOff]: While it is pretty easy to check to see if the screen saver is on in a shell script (`ps cx | fgrep ' ScreenSaverEngine'`), I have not found any way to determine the status of your display(s) from a shell script. So if you have Keyboard Maestro, you will definitely want to use it for this. If you don't have it yet, I encourage you to [download the demo] and try it for 30 days.


[^OptionalKMstep]: <img align='right' border="0" src="http://www.blogcdn.com//media/2013/07/keyboardmaestroapppreferences--320x369.jpg" width="320" height="369" alt="Keyboard Maestro preferences" />There is one more which is optional, but highly recommended. [Download this launchd plist] and move it to **$HOME/Library/LaunchAgents/**. That will ensure that the Keyboard Maestro Engine stays running even if it crashes. *If you do this* be sure to go into Keyboard Maestro.app's preferences and turn ***off*** the option to "Launch Engine at Login" (as shown in the image here), otherwise you will get two copies of the Engine trying to start at the same time, which is bad.





<!-- Github Links for this Script -->

[screenshot-journal.sh]: https://github.com/tjluoma/screenshot-journal/blob/master/screenshot-journal.sh

[Download this launchd plist]: https://github.com/tjluoma/screenshot-journal/blob/master/launchd/com.tjluoma.keeprunning.keyboardmaestroengine.plist

[com.tjluoma.screenshot-journal.plist]: https://github.com/tjluoma/screenshot-journal/blob/master/launchd/com.tjluoma.screenshot-journal.plist

[SSJ-Timed.kmmacros]: https://github.com/tjluoma/screenshot-journal/blob/master/Keyboard-Maestro/SSJ-Timed.kmmacros

[SSJ-App-Switch.kmmacros]: https://github.com/tjluoma/screenshot-journal/blob/master/Keyboard-Maestro/SSJ-App-Switch.kmmacros


<!-- OS X apps -->

[Choosy]: http://www.choosyosx.com/

[Day One]: http://dayoneapp.com/

[Fluid]: http://fluidapp.com

[Keyboard Maestro]: http://KeyboardMaestro.com

[download the demo]: http://www.keyboardmaestro.com/action/download?km-kmi-2-f

[MultiMarkdown Composer]: http://multimarkdown.com/

[TimeSink]: http://manytricks.com/timesink/


<!-- Unix tools  -->

[imagesnap]: http://iharder.sourceforge.net/current/macosx/imagesnap/

[beengone]: http://brettterpstra.com/2013/02/10/beengone-a-script-friendly-way-to-check-computer-idle-time/


<!-- References -->

[Brett Terpstra]: http://www.tuaw.com/editor/brett-terpstra

[A better Google search experience with Choosy, Keyboard Maestro and Fluid]: http://www.tuaw.com/2013/02/19/a-better-google-search-experience-with-choosy-keyboard-maestro/

[Protect yourself from being tracked by Google, Facebook, and others]: http://www.tuaw.com/2012/02/23/protect-yourself-from-being-tracked-by-google-facebook-and-oth/

