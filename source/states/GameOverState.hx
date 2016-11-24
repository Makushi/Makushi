package states;

import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import states.PlayState;
import flixel.system.FlxSound;

/**
 * ...
 * @author Maximiliano Viñas Craba
 */
class GameOverState extends FlxState
{	
	private var _victory:Bool;
	
	public function new(victory:Bool) 
	{
		_victory = victory;
		super();
	}
	
	override public function create():Void
	{
		super.create();
	}
	
	override public function update(elapsed:Float):Void
	{
		if (FlxG.keys.justPressed.ENTER)
		{
			Restart();
		}
		super.update(elapsed);
	}
	
	private function Restart():Void
	{
		FlxG.switchState(new PlayState());
	}
}