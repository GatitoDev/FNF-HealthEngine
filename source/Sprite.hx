package;

import flixel.FlxSprite;
import flixel.util.FlxColor;

class Sprite extends FlxSprite {
    public var animOffsets:Map<String, Array<Float>>;
    
    public function new(x:Float = 0, y:Float = 0) {
        super(x, y);
        animOffsets = new Map<String, Array<Float>>();
    }

    public static function create(
        image:String, x:Float = 0, y:Float = 0, 
        scrollX:Float = 1.0, scrollY:Float = 1.0,
        ?options: { 
            ?scale:Float, 
            ?antialiasing:Bool,
            ?color:FlxColor,
            ?alpha:Float
        }
    ):Sprite {
        var sprite = new Sprite(x, y);
        if (image != null) sprite.loadGraphic(Paths.image(image));
        return configureSprite(sprite, scrollX, scrollY, options);
    }

    public static function createAnimated(
        image:String, x:Float = 0, y:Float = 0,
        animationName:String, frames:Array<Int>, frameRate:Int = 24, loop:Bool = true,
        scrollX:Float = 1.0, scrollY:Float = 1.0,
        ?options: { 
            ?scale:Float, 
            ?antialiasing:Bool,
            ?color:FlxColor,
            ?alpha:Float
        }
    ):Sprite {
        var sprite = new Sprite(x, y);
        sprite.frames = Paths.getSparrowAtlas(image);
        sprite.animation.add(animationName, frames, frameRate, loop);
        sprite.animation.play(animationName);
        return configureSprite(sprite, scrollX, scrollY, options);
    }

    public static function createBG(
        image:String, x:Float = 0, y:Float = 0,
        scrollX:Float = 0.9, scrollY:Float = 0.9,
        ?options: { 
            ?scale:Float, 
            ?antialiasing:Bool,
            ?color:FlxColor,
            ?alpha:Float
        }
    ):Sprite {
        var sprite = create(image, x, y, scrollX, scrollY, options);
        sprite.active = false;
        return sprite;
    }

    public static function createMultiAnimated(
        image:String, x:Float = 0, y:Float = 0,
        scrollX:Float = 1.0, scrollY:Float = 1.0,
        animArray:Array<String>, loop:Bool = false, ?idleAnim:String,
        ?options: { 
            ?scale:Float, 
            ?antialiasing:Bool,
            ?color:FlxColor,
            ?alpha:Float
        }
    ):Sprite {
        var sprite = new Sprite(x, y);
        sprite.frames = Paths.getSparrowAtlas(image);
        
        for (anim in animArray) sprite.animation.addByPrefix(anim, anim, 24, loop);
        if (animArray.length > 0) {
            sprite.animation.play(idleAnim != null && sprite.animation.exists(idleAnim) ? idleAnim : animArray[0]);
        }
        
        return configureSprite(sprite, scrollX, scrollY, options);
    }

    public function addOffset(name:String, x:Float = 0, y:Float = 0) {animOffsets.set(name, [x, y]);}
    public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void {
        animation.play(AnimName, Force, Reversed, Frame);
        
        if (animOffsets.exists(AnimName)) {
            var daOffset = animOffsets.get(AnimName);
            offset.set(daOffset[0], daOffset[1]);
        } else offset.set(0, 0);
    }

    private static function configureSprite(
        sprite:Sprite,
        scrollX:Float, scrollY:Float,
        ?options: { 
            ?scale:Float, 
            ?antialiasing:Bool,
            ?color:FlxColor,
            ?alpha:Float
        }
    ):Sprite {
        sprite.scrollFactor.set(scrollX, scrollY);
        sprite.antialiasing = options?.antialiasing ?? true;
        
        if (options != null) {
            if (options.scale != null) {
                sprite.setGraphicSize(Std.int(sprite.width * options.scale));
                sprite.updateHitbox();
            }
            if (options.color != null) sprite.color = options.color;
            if (options.alpha != null) sprite.alpha = options.alpha;
        }
        
        return sprite;
    }

    public static function dance(sprite:Sprite, ?forceplay:Bool = false):Void {
        if (sprite.animation?.curAnim != null) sprite.playAnim(sprite.animation.curAnim.name, forceplay);
    }

    override public function destroy() {
        if (animOffsets != null) animOffsets.clear();
        super.destroy();
    }
}