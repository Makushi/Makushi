package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.system.FlxSound;
import Reg;

class MenuState extends FlxState
{
	private var menuBg:FlxSprite;
	
	override public function create():Void
	{
		
		FlxG.camera.fade(FlxColor.BLACK, 1, true);
		super.create();
		
		FlxG.mouse.visible = false;
		
		menuBg = new FlxSprite(0, 0);
		menuBg.loadGraphic("assets/images/MainMenuBG.png", false);
		add(menuBg);
		
		Reg.musicManager = new FlxSound();
		Reg.musicManager = FlxG.sound.load("assets/music/MainMenu.ogg", 1, true);
		Reg.musicManager.persist = true;
		Reg.musicManager.play();
	}

	override public function update(elapsed:Float):Void
	{	
		super.update(elapsed);
		if (FlxG.keys.justPressed.ENTER)
		{
			FlxG.camera.fade(FlxColor.BLACK, 1, false, function()
			{
				FlxG.switchState(new TutorialState());
			});
		}
	}
}
