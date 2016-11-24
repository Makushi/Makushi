package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.math.FlxRandom;
import flixel.input.keyboard.FlxKeyList;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxVelocity;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxTimer;
import flixel.util.FlxSort;
import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.FlxObject;
import sprites.Otaku;
import sprites.Waifu;

class PlayState extends FlxState
{
	private var waifu:Waifu;
	private var otakus:FlxTypedGroup<Otaku>;
	private var pressedKey:FlxKey;
	private var spawnTimer:FlxTimer;
	private var clockTimer:FlxTimer;
	private var spawnSpeed:Float = 3;
	private var nextSpawnSpeedUp:Int = 20;
	private var respawnPoints = new Array();
	private var respawnGetter:FlxRandom;
	private var timeLeft:Int = 120;
	private var timeRemaining:FlxText;
	private var comboCounter:FlxText;
	private var combo:Int = 0;

	override public function create():Void
	{
		super.create();
		
		respawnGetter = new FlxRandom();
		var loader:FlxOgmoLoader = new FlxOgmoLoader(AssetPaths.makushilvl__oel);
		loader.loadEntities(LoadRespawns, "respawns");
		FlxG.worldBounds.set(0, 0, 800, 600);
		
		var hud:FlxSprite = new FlxSprite(0, 500);
		hud.makeGraphic(800, 100);
		add(hud);
		
		waifu = new Waifu(400, 250);
		add(waifu);
		add(waifu.hpBar);

		timeRemaining = new FlxText(530, 520, 0, "TIME LEFT\n    " + timeLeft, 20);
		timeRemaining.color = 0xFF000000;
		add(timeRemaining);
		
		comboCounter = new FlxText(700, 520, 0, "X" + combo, 50);
		comboCounter.color = 0xFF000000;
		add(comboCounter);
		
		otakus = new FlxTypedGroup<Otaku>(26);
		add(otakus);

		spawnTimer = new FlxTimer();
		spawnTimer.start(spawnSpeed, SpawnEnemy, 0);
		
		clockTimer = new FlxTimer();
		clockTimer.start(1, Countdown, 0);
		
		var letterCode:Int = 65;
		
		for(i in 0...26)
		{
			var otaku:Otaku = new Otaku(null, null, letterCode);
			otakus.add(otaku);
			letterCode++;
		}
	}

	override public function update(elapsed:Float):Void
	{	
		FlxG.overlap(otakus, waifu, null, CollsionHandler);
		MoveOtakus();
		CheckKeyPress();
		
		super.update(elapsed);
	}
	
	private function UpdateCombo():Void
	{
		comboCounter.text = "X" + combo;
	}
	
	private function Countdown(Timer:FlxTimer):Void
	{
		timeLeft--;
		nextSpawnSpeedUp--;
		timeRemaining.text = "TIME LEFT\n    " + timeLeft;
		
		if (timeLeft == 0)
		{
			FlxG.switchState(new GameOverState(true));
		}
		
		if (nextSpawnSpeedUp == 0)
		{
			spawnSpeed -= 0.4;
			spawnTimer.time = spawnSpeed;
			nextSpawnSpeedUp = 20;
		}
	}
	
	private function MoveOtakus():Void
	{
		for(otaku in otakus)
		{
			if(otaku.exists)
			{
				FlxVelocity.moveTowardsObject(otaku, waifu, 120);				
			}	
		}	
	}
	
	private function CheckKeyPress():Void
	{		
		if(FlxG.keys.firstJustPressed() != -1)
		{
			var missed:Bool = true;

			pressedKey = FlxG.keys.firstJustPressed();
			
			for(otaku in otakus)
			{
				if(pressedKey == otaku.KillTrigger && otaku.exists)
				{
					missed = false;
					otaku.Deactivate();
					combo++;
					UpdateCombo();
				}	
			}
			
			if (missed)
			{
				waifu.Damage();
				combo = 0;
				UpdateCombo();
			}
		}
	}
	
	private function Collisions():Void
	{	
		FlxG.overlap(otakus, waifu, null, CollsionHandler);
	}
	
	private function CollsionHandler(Sprite1:FlxObject, Sprite2:FlxObject):Bool
	{
		var sprite1ClassName:String = Type.getClassName(Type.getClass(Sprite1));
		var sprite2ClassName:String = Type.getClassName(Type.getClass(Sprite2));
		
		if (sprite1ClassName == "sprites.Otaku" && sprite2ClassName == "sprites.Waifu")
		{			
			var otaku: Dynamic = cast(Sprite1, Otaku);
			otaku.Deactivate();
			waifu.Damage();
			combo = 0;
			UpdateCombo();
			
			return true;
		}
		
		return false;
	}

	public function SpawnEnemy(Timer:FlxTimer):Void
	{	
		var otaku:Otaku = otakus.getRandom();
		
		while (otaku.exists)
		{
			otaku = otakus.getRandom();
		}
		
		var spawn:FlxPoint = respawnGetter.getObject(respawnPoints);
		
		otaku.Reuse(spawn.x, spawn.y);
		otakus.add(otaku);
	}
	
	private function LoadRespawns( entityName:String, entityData:Xml):Void
	{
		if (entityName == "Respawn")
		{
			var X:Float = Std.parseFloat(entityData.get("x"));
			var Y:Float = Std.parseFloat(entityData.get("y"));
			
			var respawnPoint = new FlxPoint(X, Y);
			
			respawnPoints.push(respawnPoint);
		}
	}
}
