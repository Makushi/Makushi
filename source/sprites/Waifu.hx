package sprites;

import flash.events.GameInputEvent;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.ui.FlxBar;
import flixel.FlxState;
import flixel.FlxG;
import states.GameOverState;
/**
 * ...
 * @author Maximiliano Viñas Craba
 */
class Waifu extends FlxSprite
{
	public var hpBar:FlxBar;
	public var hp:Int = 10000;

	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		makeGraphic(32, 32, 0xFF00FFFF);
		hpBar = new FlxBar(100, 540, null, 400, 20);
		hpBar.createFilledBar(0xFF8e0000, 0xFFFF0000);
		hpBar.setRange(0, hp);
		hpBar.value = hp;
	}
	
	public function Damage()
	{
		hp -= 500;
		hpBar.value = hp;
		if (hp <= 0)
		{
			FlxG.switchState(new GameOverState(false));
		}
		
	}
}