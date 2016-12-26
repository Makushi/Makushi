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
	private var hp:Int = 100;
	private var animationTimer:Int = 0;
	private var inAnimation:Bool = false;

	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		loadGraphic("assets/images/Waifu2.png", true, 64, 64);
		animation.add("idle", [0]);
		animation.add("blush", [1], 6, false);
		animation.add("hurt", [2], 6, false);
		animation.play("idle");
		x = (Reg.ScreenWidth / 2) - (width / 2);
		y = (Reg.ScreenHeight / 2) - (height / 2) - 50;
		hpBar = new FlxBar(100, 540, null, 400, 20);
		hpBar.createFilledBar(0xFF8e0000, 0xFFFF0000);
		hpBar.setRange(0, hp);
		hpBar.value = hp;
	}

	override public function update(elapsed:Float):Void 
	{
		ManageAnimations();
		super.update(elapsed);
	}
	
	private function ManageAnimations():Void
	{
		if(inAnimation)
		{
			animationTimer++;
			if(animationTimer == 60)
			{
				animation.play("idle");
				inAnimation = false;
				animationTimer = 0;
			}
		}
	}

	public function Blush():Void
	{
		animation.play("blush");
		inAnimation = true;
	}

	public function Damage()
	{
		hp -= 5;
		hpBar.value = hp;
		animation.play("hurt");
		inAnimation = true;
		if (hp <= 0)
		{
			FlxG.switchState(new GameOverState(false));
		}
	}
}