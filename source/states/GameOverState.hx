package states;

import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.system.FlxSound;
import states.PlayState;

/**
 * ...
 * @author Maximiliano Viñas Craba
 */
class GameOverState extends FlxState
{	
	private var _victory:Bool;
	private var otakuScore:FlxText;
	private var maxComboScore:FlxText;
	private var gameOverBg:FlxSprite;

	public function new(victory:Bool) 
	{
		_victory = victory;
		super();
	}
	
	override public function create():Void
	{
		super.create();
	
		Reg.musicManager.persist = false;
		Reg.musicManager.stop();
	
		gameOverBg = new FlxSprite(0, 0);
		if (_victory)
		{
			gameOverBg.loadGraphic("assets/images/GameOverWinBG.png", false);
			Reg.musicManager = FlxG.sound.load("assets/sounds/WinFanfare.ogg", 1, false);
			Reg.musicManager.play();
		}
		else
		{
			gameOverBg.loadGraphic("assets/images/GameOverLoseBG.png", false);
			Reg.musicManager = FlxG.sound.load("assets/music/SadViolin.ogg", 1, false);
			Reg.musicManager.play();
		}
		add(gameOverBg);
		
		otakuScore = new FlxText(0, FlxG.height / 2, 0, "Otakus Beaten : " + Reg.otakusBeaten + "/" + Reg.totalOtakus);
		otakuScore.alignment = CENTER;
		otakuScore.screenCenter(X);
		otakuScore.setFormat("assets/BadaboomBB_Reg.ttf", 24, 0xFF000000);
		add(otakuScore);

		maxComboScore = new FlxText(0, (FlxG.height / 2) + 20 , 0, "Best Combo : X" + Reg.maxCombo);
		maxComboScore.alignment = CENTER;
		maxComboScore.screenCenter(X);
		maxComboScore.setFormat("assets/BadaboomBB_Reg.ttf", 24, 0xFF000000);
		add(maxComboScore);
	}
	
	override public function update(elapsed:Float):Void
	{
		if (FlxG.keys.justPressed.ENTER)
		{
			Reg.musicManager.destroy();
			FlxG.camera.fade(FlxColor.BLACK, 1, false, function()
			{
				FlxG.switchState(new MenuState());
			});
		}
		super.update(elapsed);
	}
}