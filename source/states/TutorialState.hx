package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class TutorialState extends FlxState
{

	private	var text:FlxText;
	
	override public function create():Void
	{
		FlxG.camera.fade(FlxColor.BLACK, 1, true);
		super.create();
		text = new FlxText(0, (FlxG.height / 2), 0, "Tutorial");
		text.alignment = CENTER;
		text.screenCenter(X);
		text.color = 0xff00ffff;
		add(text);
	}

	override public function update(elapsed:Float):Void
	{	
		super.update(elapsed);
		if (FlxG.keys.justPressed.ENTER)
		{
			FlxG.camera.fade(FlxColor.BLACK, 1, false, function()
			{
				FlxG.switchState(new PlayState());
			});
		}
	}
}
