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
	private var otakuSprite:FlxSprite;

	public function new(?X:Float=0, ?Y:Float=0, letterCode:Int) 
	{		
		super(X, Y);	
		otakuSprite = new FlxSprite();
		otakuSprite.loadGraphic("assets/images/Letter.png", true, 64, 32);
		otakuSprite.animation.add("breaking", [1, 2, 3], 15, false);
		loadGraphicFromSprite(otakuSprite);

		keyToKill = letterCode;
		KillTrigger = keyToKill;
		prompt = new FlxText(x, y - 10, 20, KillTrigger.toString());
		prompt.setFormat("assets/BadaboomBB_Reg.ttf", 24, 0xFF000000);
		exists = false;
	}

	override public function update(elapsed:Float):Void 
	{
		prompt.x = x + (width / 2) - (prompt.width / 2);
		prompt.y = y - 25;

		if(!alive && animation.finished)
		{
			exists = false;	
		}

		super.update(elapsed);
	}
	
	public function Reuse(spawnX:Float, spawnY:Float):Void
	{
		x = spawnX;
		y = spawnY;
		prompt.x = x + (width / 2);
		prompt.y = y - 15;
		exists = true;
		alive = true;
		otakuSprite = new FlxSprite();
		otakuSprite.loadGraphic("assets/images/Letter.png", true, 64, 32);
		otakuSprite.animation.add("breaking", [1, 2, 3], 15, false);
		loadGraphicFromSprite(otakuSprite);
		FlxG.state.add(prompt);
	}
	
	public function Deactivate():Void
	{
		alive = false;
		animation.play("breaking");
		FlxG.state.remove(prompt);
	}
}