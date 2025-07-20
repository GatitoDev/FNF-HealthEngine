package;

import flixel.FlxCamera;
import flixel.group.FlxSpriteGroup;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class AnimationDebug extends FlxState
{
	var char:Character;
	var textAnim:FlxText;
	var dumbTexts:FlxTypedGroup<FlxText>;
	var animList:Array<String> = [];
	var curAnim:Int = 0;
	var camFollow:FlxObject;
	
	// Panel variables
	var panelGroup:FlxTypedSpriteGroup<FlxSprite>;
	var selectionBox:FlxSprite;
	var panelWidth:Int = 300;
	var panelPadding:Int = 10;
	var panelHeaderHeight:Int = 30;
	var textHeight:Int = 20;
	var textSpacing:Int = 5;
	var contentIndent:Int = 10; // Sangría adicional para el contenido

	var camHUD:FlxCamera;

	public function new(daAnim:String = 'spooky')
	{
		super();
		FlxG.sound.music.stop();

		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;
		FlxG.cameras.add(camHUD, false);

		var gridBG:FlxSprite = FlxGridOverlay.create(10, 10);
		gridBG.scrollFactor.set(0.5, 0.5);
		add(gridBG);

		char = daAnim == 'bf' ? new Boyfriend(0, 0) : new Character(0, 0, daAnim);
		char.screenCenter();
		char.debugMode = true;
		char.flipX = false;
		add(char);

		initPanel();
		
		// Create selection box (full panel width)
		selectionBox = new FlxSprite(panelPadding, 0).makeGraphic(
			panelWidth, // Ahora ocupa todo el ancho del panel
			textHeight + textSpacing,
			FlxColor.GRAY
		);
		selectionBox.alpha = 0.3;
		selectionBox.scrollFactor.set();
		selectionBox.visible = false;
		panelGroup.add(selectionBox);
		
		dumbTexts = new FlxTypedGroup<FlxText>();
		add(dumbTexts);

		textAnim = new FlxText(FlxG.width - 300, 16, 300, "", 26);
		textAnim.setFormat(Paths.font('vcr.ttf'), 26, FlxColor.WHITE, RIGHT);
		textAnim.scrollFactor.set();
		add(textAnim);

		genBoyOffsets();

		camFollow = new FlxObject(0, 0, 2, 2);
		camFollow.screenCenter();
		add(camFollow);

		FlxG.camera.follow(camFollow);

		panelGroup.cameras = [camHUD];
		dumbTexts.cameras = [camHUD];
		textAnim.cameras = [camHUD];
	}

	function initPanel():Void
	{
		if (panelGroup != null && members.contains(panelGroup))
		{
			remove(panelGroup);
		}
		
		panelGroup = new FlxTypedSpriteGroup<FlxSprite>();
		
		// La altura se calculará dinámicamente en genBoyOffsets
		var panelBG = new FlxSprite(panelPadding, panelPadding).makeGraphic(
			panelWidth, 
			100, // Valor temporal, será reemplazado
			FlxColor.BLACK
		);
		panelBG.alpha = 0.7;
		panelBG.scrollFactor.set();
		panelGroup.add(panelBG);
		
		var headerBG = new FlxSprite(panelBG.x, panelBG.y).makeGraphic(
			panelWidth, 
			panelHeaderHeight, 
			FlxColor.fromRGB(40, 40, 40)
		);
		headerBG.alpha = 0.9;
		headerBG.scrollFactor.set();
		panelGroup.add(headerBG);
		
		var headerText = new FlxText(
			headerBG.x + panelPadding, 
			headerBG.y + (panelHeaderHeight - 20) / 2, 
			panelWidth - (panelPadding * 2), 
			"ANIMATION OFFSETS", 
			20
		);
		headerText.setFormat(Paths.font('vcr.ttf'), 20, FlxColor.WHITE, LEFT);
		headerText.scrollFactor.set();
		panelGroup.add(headerText);
		
		add(panelGroup);
	}

	function genBoyOffsets(pushList:Bool = true):Void
	{
		dumbTexts.clear();
		animList = pushList ? [] : animList;

		var startY:Float = panelPadding + panelHeaderHeight + textSpacing;
		var contentWidth:Int = panelWidth - (panelPadding * 2) - contentIndent;
		
		for (anim => offsets in char.animOffsets)
		{
			var text:FlxText = new FlxText(
				panelPadding + contentIndent,
				startY + (dumbTexts.length * (textHeight + textSpacing)),
				contentWidth,
				'${anim}: (${offsets[0]}, ${offsets[1]})',
				textHeight
			);
			text.offset.y += 3;
			text.setFormat(Paths.font('vcr.ttf'), textHeight, FlxColor.WHITE, LEFT);
			text.scrollFactor.set();
			dumbTexts.add(text);

			if (pushList) animList.push(anim);
		}
		
		// Calcular la nueva altura del panel
		var totalContentHeight = dumbTexts.length * (textHeight + textSpacing);
		var panelHeight = panelHeaderHeight + totalContentHeight;
		
		// Actualizar el tamaño del panelBG
		if (panelGroup.members[0] != null)
		{
			panelGroup.members[0].makeGraphic(panelWidth, Std.int(panelHeight), FlxColor.BLACK);
		}
		
		updateSelectionBox();
	}

	function updateSelectionBox():Void
	{
		if (dumbTexts.members[curAnim] != null)
		{
			// Ajuste preciso de posición vertical
			selectionBox.y = dumbTexts.members[curAnim].y - (textSpacing/2) - 2; // +1 para pequeño ajuste
			selectionBox.visible = true;
		}
		else
		{
			selectionBox.visible = false;
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		textAnim.text = char.animation.curAnim.name;

		if (FlxG.keys.justPressed.E) FlxG.camera.zoom += 0.25;
		if (FlxG.keys.justPressed.Q) FlxG.camera.zoom -= 0.25;

		camFollow.velocity.set(
			FlxG.keys.pressed.J ? -90 : (FlxG.keys.pressed.L ? 90 : 0),
			FlxG.keys.pressed.I ? -90 : (FlxG.keys.pressed.K ? 90 : 0)
		);

		var lastAnim = curAnim;
		if (FlxG.keys.justPressed.W) curAnim = (curAnim - 1 + animList.length) % animList.length;
		if (FlxG.keys.justPressed.S) curAnim = (curAnim + 1) % animList.length;
		
		if (lastAnim != curAnim)
		{
			updateSelectionBox();
		}

		var multiplier = FlxG.keys.pressed.SHIFT ? 10 : 1;
		var offsetChanged = false;
		
		if (FlxG.keys.anyJustPressed([UP, DOWN, LEFT, RIGHT]))
		{
			var offsets = char.animOffsets.get(animList[curAnim]);
			if (FlxG.keys.justPressed.UP) offsets[1] += multiplier;
			if (FlxG.keys.justPressed.DOWN) offsets[1] -= multiplier;
			if (FlxG.keys.justPressed.LEFT) offsets[0] += multiplier;
			if (FlxG.keys.justPressed.RIGHT) offsets[0] -= multiplier;
			offsetChanged = true;
		}

		if (FlxG.keys.justPressed.SPACE || FlxG.keys.justPressed.W || FlxG.keys.justPressed.S || offsetChanged)
		{
			char.playAnim(animList[curAnim]);
			genBoyOffsets(false);
		}
	}
}