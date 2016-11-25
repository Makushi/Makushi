package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class TutorialState extends FlxState
{

	private var tutorialBg:FlxSprite;
	
	override public function create():Void
	{
		FlxG.camera.fade(FlxColor.BLACK, 1, true);
		super.create();
		tutorialBg = new FlxSprite(0, 0);
		tutorialBg.loadGraphic("assets/images/TutorialBG.png", false);
		add(tutorialBg);
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
