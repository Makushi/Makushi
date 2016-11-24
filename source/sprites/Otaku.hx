package sprites;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.input.keyboard.FlxKeyList;
import flixel.math.FlxRandom;
import flixel.input.keyboard.FlxKey;
import flixel.text.FlxText;
import flixel.FlxG;
/**
 * ...
 * @author Maximiliano Viñas Craba
 */
class Otaku extends FlxSprite
{
	public var keyToKill:Int;
	public var KillTrigger:FlxKey;
	public var prompt:FlxText;
	
	public function new(?X:Float=0, ?Y:Float=0, letterCode:Int) 
	{		
		super(X, Y);	
		makeGraphic(32, 32, 0xFF00FF00);
		keyToKill = letterCode;
		KillTrigger = keyToKill;
		prompt = new FlxText(x, y - 10, 16, KillTrigger.toString());
		exists = false;
	}

	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		prompt.x = x + (width / 2);
		prompt.y = y - 15;
	}
	
	public function Reuse(spawnX:Float, spawnY:Float):Void
	{
		x = spawnX;
		y = spawnY;
		prompt.x = x + (width / 2);
		prompt.y = y - 15;
		exists = true;
		FlxG.state.add(prompt);
	}
	
	public function Deactivate():Void
	{
		exists = false;
		FlxG.state.remove(prompt);
	}
}