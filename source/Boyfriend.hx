package;
using StringTools;
class Boyfriend extends Character {
    public var stunned:Bool = false;
    public function new(x:Float, y:Float, ?char:String = 'bf') { super(x, y, char, true); }
    override function update(elapsed:Float) {
        if (!debugMode) {
            var anim:String = animation.curAnim.name;
            if (anim.startsWith('sing')) holdTimer += elapsed;
            else holdTimer = 0;
            if (anim.endsWith('miss') && animation.curAnim.finished) playAnim('idle', true, false, 10);
            else if (anim == 'firstDeath' && animation.curAnim.finished) playAnim('deathLoop');
        }
        super.update(elapsed);
    }
}