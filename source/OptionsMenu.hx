package;

#if desktop
import Discord.DiscordClient;
#end
import Controls.Control;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;

class OptionsMenu extends MusicBeatState
{
	public static var instance:OptionsMenu;

	var selector:FlxText;
	var curSelected:Int = 0;

	var menuBG:FlxSprite;

	var controlsStrings:Array<String> = [];

	var optionsText:FlxText;
	var optionsDesc:FlxText;

	var descText:FlxText;
	var descBG:FlxSprite;

	private var grpControls:FlxTypedGroup<Alphabet>;

	override function create()
	{
		instance = this;

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Options", null);
		#end

		FlxG.sound.playMusic(Paths.music('breakfast'));

		menuBG = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		controlsStrings = CoolUtil.coolTextFile(Paths.txt('options'));
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.color = FlxColor.GRAY; // Here you can change the background color
		menuBG.antialiasing = true;
		add(menuBG);

		optionsText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		optionsText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);
		optionsDesc = new FlxText(830, 80, 450, "", 32);
		optionsDesc.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		var optionsBG:FlxSprite = new FlxSprite(optionsText.x - 6, 0).makeGraphic(Std.int(FlxG.width * 0.55), 80, 0xFF000000);
		optionsBG.alpha = 0.6;
		add(optionsBG);
		add(optionsText);
		add(optionsDesc);

		descBG = new FlxSprite(50, 640).makeGraphic(1180, 38, FlxColor.BLACK);
		descBG.alpha = 0.6;
		descBG.scrollFactor.set();
		descText = new FlxText(62, 648, "This option is under development, possibly it has errors");
		descText.setFormat(Paths.font("vcr.ttf"), 22, FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		descText.borderSize = 1.25;
		// If you want to remove it no problem
		add(descBG);
		add(descText);

		grpControls = new FlxTypedGroup<Alphabet>();
		add(grpControls);
		controlsStrings[controlsStrings.length] = " "; // I HAVE SEVERE AUTISM LOOODALOFDALK
		for (i in 0...controlsStrings.length)
		{
			if (controlsStrings[i].indexOf('set') != -1)
			{
				var controlLabel:Alphabet = new Alphabet(0, (70 * i) + 30, controlsStrings[i].substring(3).split(" || ")[0], true, false);
				controlLabel.isMenuItem = true;
				controlLabel.targetY = i;
				grpControls.add(controlLabel);
			}
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
		}

		super.create();
		changeSelection();
		// openSubState(new OptionsSubState());
	}

	function getOption(name:String) {
		switch (name)
		{
			case "Distraction":
					return FlxG.save.data.distraction;
			case "Hide HUD":
					return FlxG.save.data.hidehud;
			case "CPU Strums":
					return FlxG.save.data.cpuStrums;
			case "Classic HUD":
				return FlxG.save.data.classichud;
		}
		return "None Found";
	}
	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if (controls.ACCEPT)
			{
					trace(controlsStrings[curSelected].substring(3).split(" || ")[0]);
				switch (controlsStrings[curSelected].substring(3).split(" || ")[0])
						{
							case "Distraction":
									FlxG.save.data.distraction = !FlxG.save.data.distraction;
									optionsText.text = FlxG.save.data.distraction;
							case "Hide HUD":
									FlxG.save.data.hidehud = !FlxG.save.data.hidehud;
									optionsText.text = FlxG.save.data.hidehud;
							case "CPU Strums":
									FlxG.save.data.cpuStrums = !FlxG.save.data.cpuStrums;
									optionsText.text = FlxG.save.data.cpuStrums;
							case "Classic HUD":
									FlxG.save.data.classichud = !FlxG.save.data.classichud;
									optionsText.text = FlxG.save.data.classichud;
							case "Reset":
									reset();
						}
			}
			if (controls.BACK)
				FlxG.switchState(new MainMenuState());
			if (controls.UP_P)
				changeSelection(-1);
			if (controls.DOWN_P)
				changeSelection(1);
	}

	function waitingInput():Void
	{
		if (FlxG.keys.getIsDown().length > 0)
		{
			PlayerSettings.player1.controls.replaceBinding(Control.LEFT, Keys, FlxG.keys.getIsDown()[0].ID, null);
		}
		// PlayerSettings.player1.controls.replaceBinding(Control)
	}

	var isSettingControl:Bool = false;

	function changeBinding():Void
	{
		if (!isSettingControl)
		{
			isSettingControl = true;
		}
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
				curSelected = grpControls.length - 1;
		if (curSelected >= grpControls.length)
				curSelected = 0;

		switch (controlsStrings[curSelected].substring(3).split(" || ")[0])
		{
			case "Distraction":
					optionsText.text = FlxG.save.data.distraction;
					descBG.visible = false;
					descText.visible = false;
			case "Hide HUD":
					optionsText.text = FlxG.save.data.hidehud;
					descBG.visible = false;
					descText.visible = false;
			case "CPU Strums":
					optionsText.text = FlxG.save.data.cpuStrums;
					descBG.visible = true;
					descText.visible = true;
			case "Classic HUD":
					optionsText.text = FlxG.save.data.classichud;
					descBG.visible = false;
					descText.visible = false;
		}
		optionsDesc.text = controlsStrings[curSelected].split(" || ")[1];

		// selector.y = (70 * curSelected) + 30;

		var bullShit:Int = 0;
		for (item in grpControls.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}

	function reset() {

	}
}
