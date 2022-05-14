![](/assets/preload/images/logoHealthEngine.png)
# Friday Night Funkin': Health Engine

This is the repository for Friday Night Funkin': Heatlh Engine, this engine was created for the creation of mods, who want to use this engine.

Here is the original game, you will see the credits!
If you want to download Friday Night Funkin 'thanks to this game, I was able to create my own engine!

## Friday Night Funkin'

- Play the Newgrounds one here: https://www.newgrounds.com/portal/view/770371
- Support the project on the itch.io page: https://ninja-muffin24.itch.io/funkin

## Credits / shoutouts

### FNF Heatlh Engine
- [GatitoDev](https://www.youtube.com/c/GatitoDormilon/featured) - Programmer, Art

### Friday Night Funkin'
- [ninjamuffin99](https://twitter.com/ninja_muffin99) - Programmer
- [PhantomArcade3K](https://twitter.com/phantomarcade3k) and [Evilsk8r](https://twitter.com/evilsk8r) - Art
- [Kawaisprite](https://twitter.com/kawaisprite) - Musician

## Build instructions

Well, if you want to program and make a mod! You will have to follow these simple but difficult steps!
If you want to share the game, just read these easy and difficult steps

### Installing the Required Programs

First you need to install Haxe and HaxeFlixel. I'm too lazy to write and keep updated with that setup (which is pretty simple).
What ninjamuffin99 says is fine, I am lazy to write! so ... just follow those simple steps and download what it tells you
1. [Install Haxe 4.1.5](https://haxe.org/download/version/4.1.5/) (Download 4.1.5 instead of 4.2.0 because 4.2.0 is broken and is not working with gits properly...)
2. [Install HaxeFlixel](https://haxeflixel.com/documentation/install-haxeflixel/) after downloading Haxe

Other installations you'd need is the additional libraries, a fully updated list will be in `Project.xml` in the project root. Currently, these are all of the things you need to install:
```
flixel
flixel-addons
flixel-ui
hscript
newgrounds
```
In order to install it, all you have to do is go to the folder of this engine, then go to the top, where it says (Health-Engine) press there and write this: cmd.
Then write, haxelib install and that copies what it says below! next to that for example: haxelib install flixel, haxelib install flixel-addons, haxelib install flixel-ui, haxelib install hscript, haxelib install newgrounds
Thus! well now just read the rest.

Just read and what I wrote is for you to copy it and don't take too long!
So for each of those type `haxelib install [library]` so shit like `haxelib install newgrounds`

You'll also need to install a couple things that involve Gits. To do this, you need to do a few things first.
1. Download [git-scm](https://git-scm.com/downloads). Works for Windows, Mac, and Linux, just select your build.
2. Follow instructions to install the application properly.
3. Run `haxelib git polymod https://github.com/larsiusprime/polymod.git` to install Polymod.
4. Run `haxelib git discord_rpc https://github.com/Aidan63/linc_discord-rpc` to install Discord RPC.

You should have everything ready for compiling the game! Follow the guide below to continue!

At the moment, you can optionally fix the transition bug in songs with zoomed out cameras.
- Run `haxelib git flixel-addons https://github.com/HaxeFlixel/flixel-addons` in the terminal/command-prompt.

### Compiling game

Well, here I come in.
If I am the creator of this engine, well after having downloaded all the haxelibs and that's good, this is to your liking, I'll mention the codes you can put in:
lime test windows: used to run it as an .exe, it is literally playable and you publish it and voila! enjoy your mod!
lime test html5: it is useful for ... because it does not have so much bugs, lag and more bad things, then it only serves to test the mod
lime test windows or html -debug: it is used to modify things and move and that, ready only if you do not know, just investigate!

### Programs to schedule

Good news, remember that I downloaded it and had the installer so here I bring you the HaxeDevelop by mediafire, it is reliable because it has no virus! trust me

- [Visual Studio](https://code.visualstudio.com/) - Recommended for programming, it is a very good program
- [HaxeDevelop](https://www.mediafire.com/file/t3dqe3sa9psj391/HaxeDevelop_-_5.3.3.rar/file) - I hardly recommend it, but you can download it if you want! Only it takes time to open
