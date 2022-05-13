package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.graphics.frames.FlxAtlasFrames;
import lime.app.Application;

class OutdatedSubState extends MusicBeatState
{
	public static var leftState:Bool = false;

	override function create()
	{
		super.create();

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);

		var ver = "v" + Application.current.meta.get('version');

		var txt:FlxText = new FlxText(0, 0, FlxG.width,
			"HEY! You are running an outdated version of the engine!"
			+ "\nThe current version is "
			+ ver
			+ "while the most recent version is "
			+ NGio.GAME_VER
			+ "\n¡Press enter or space to go to Menu!",
			32);
		txt.setFormat("VCR OSD Mono", 26, FlxColor.WHITE, CENTER);
		txt.screenCenter();
		add(txt);

		var Logo:FlxSprite = new FlxSprite(FlxG.width, 0).loadGraphic(Paths.image('logoHealthEngine'));
		Logo.screenCenter(X);
		Logo.scale.y = 0.3;
		Logo.scale.x = 0.3;
		Logo.x -= 0;
		Logo.y -= 0;
		Logo.alpha = 0.8;
		add(Logo);
		
		FlxTween.angle(Logo, Logo.angle, -10, 2, {ease: FlxEase.quartInOut});
		
		new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			if(Logo.angle == -10) FlxTween.angle(Logo, Logo.angle, 10, 2, {ease: FlxEase.quartInOut});
			else FlxTween.angle(Logo, Logo.angle, -10, 2, {ease: FlxEase.quartInOut});
		}, 0);
		
		new FlxTimer().start(0.8, function(tmr:FlxTimer)
		{
			if(Logo.alpha == 0.8) FlxTween.tween(Logo, {alpha: 1}, 0.8, {ease: FlxEase.quartInOut});
			else FlxTween.tween(Logo, {alpha: 0.8}, 0.8, {ease: FlxEase.quartInOut});
		}, 0);
	}

	override function update(elapsed:Float)
	{
		if (controls.ACCEPT)
		{
			FlxG.openURL("https://github.com/MiguelJr777/FNF-Health-Engine");
		}
		if (controls.BACK)
		{
			leftState = true;
			FlxG.switchState(new MainMenuState());
		}
		super.update(elapsed);
	}
}
