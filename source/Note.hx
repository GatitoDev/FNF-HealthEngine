package;

import flixel.FlxG;
import flixel.FlxSprite;
import PlayState;

using StringTools;

class Note extends FlxSprite
{
	public var strumTime:Float = 0;

	public var mustPress:Bool = false;
	public var noteData:Int = 0;
	public var canBeHit:Bool = false;
	public var tooLate:Bool = false;
	public var wasGoodHit:Bool = false;
	public var prevNote:Note;
	public var modifiedByLua:Bool = false;
	public var sustainLength:Float = 0;
	public var isSustainNote:Bool = false;

	public var noteScore:Float = 1;

	public static var swagWidth:Float = 160 * 0.7;
	public static var PURP_NOTE:Int = 0;
	public static var GREEN_NOTE:Int = 2;
	public static var BLUE_NOTE:Int = 1;
	public static var RED_NOTE:Int = 3;

	public var rating:String = "shit";

	public function new(strumTime:Float, noteData:Int, ?prevNote:Note, ?sustainNote:Bool = false)
	{
		super();

		if (prevNote == null) prevNote = this;
		this.prevNote = prevNote;
		isSustainNote = sustainNote;

		x += 50;
		y -= 2000;
		this.strumTime = strumTime;

		if (this.strumTime < 0 ) this.strumTime = 0;
		this.noteData = noteData;
		var daStage:String = PlayState.curStage;
		var isPixel:Bool = PlayState.SONG.noteStyle == 'pixel';
		var colors:Array<String> = ['purple', 'blue', 'green', 'red'];

		if (isPixel) {
			loadGraphic(Paths.image('weeb/pixelUI/' + (isSustainNote ? 'arrowEnds' : 'arrows-pixels'), 'week6'), true, isSustainNote ? 7 : 17, isSustainNote ? 6 : 17);
			
			for (i in 0...colors.length) {
				var c = colors[i];
				animation.add(c.toLowerCase() + 'Scroll', [isSustainNote ? i : (i == 1 ? 5 : i == 2 ? 6 : i == 3 ? 7 : 4)]);
				if (isSustainNote) {
					animation.add(c.toLowerCase() + 'hold', [i % 2 == 0 ? 0 : 1]);
					animation.add(c.toLowerCase() + 'holdend', [i + 4]);
				}
			}
			
			setGraphicSize(Std.int(width * PlayState.daPixelZoom));
		} else {
			frames = Paths.getSparrowAtlas('NOTE_assets');
			for (c in colors) {
				animation.addByPrefix(c.toLowerCase() + 'Scroll', c.toLowerCase() + '0');
				animation.addByPrefix(c.toLowerCase() + 'holdend', c.toLowerCase() + ' hold end');
				animation.addByPrefix(c.toLowerCase() + 'hold', c.toLowerCase() + ' hold piece');
			}
			setGraphicSize(Std.int(width * 0.7));
			antialiasing = true;
		}
		updateHitbox();

		x += swagWidth * noteData;
		animation.play(colors[noteData] + 'Scroll');

		if (FlxG.save.data.downscroll && sustainNote) flipY = true;

		if (isSustainNote && prevNote != null) {
			noteScore *= 0.2;
			alpha = 0.6;
			
			x += width / 2;
			animation.play(['purpleholdend', 'blueholdend', 'greenholdend', 'redholdend'][noteData]);
			updateHitbox();
			x -= width / 2;
			
			if (PlayState.curStage.startsWith('school')) x += 30;
			
			if (prevNote.isSustainNote) {
				prevNote.animation.play(['purplehold', 'bluehold', 'greenhold', 'redhold'][prevNote.noteData]);
				var scrollSpeed:Float = (FlxG.save.data.scrollSpeed != 1) ? FlxG.save.data.scrollSpeed : PlayState.SONG.speed;
				prevNote.scale.y *= Conductor.stepCrochet / 100 * 1.5 * scrollSpeed;
				prevNote.updateHitbox();
			}
			if (FlxG.save.data.downscroll) {
				y -= height;
				flipY = true;
			} else y += height / 2;
		}
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
		
		if (mustPress) {
			canBeHit = (strumTime > Conductor.songPosition - Conductor.safeZoneOffset * 1.5) 
					&& (strumTime < Conductor.songPosition + Conductor.safeZoneOffset * 0.5);
			
			tooLate = !wasGoodHit && (strumTime < Conductor.songPosition - Conductor.safeZoneOffset * Conductor.timeScale);
		} else {
			canBeHit = false;
			wasGoodHit = strumTime <= Conductor.songPosition;
		}

		if (tooLate && alpha > 0.3) alpha = 0.3;
	}
}
