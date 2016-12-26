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
	private var speedUpTimer:FlxTimer;
	private var spawnSpeed:Float = 3;
	private var respawnPoints = new Array();
	private var respawnGetter:FlxRandom;
	private var timeLeft:Int = 120;
	private var timeRemaining:FlxText;
	private var comboCounter:FlxText;
	private var combo:Int = 0;
	private var hype:Bool = false;
	private var hypeFactor:Float = 0.005;

	override public function create():Void
	{
		super.create();

		bgColor = 0xFFFFF0BE;
		respawnGetter = new FlxRandom();

		var loader:FlxOgmoLoader = new FlxOgmoLoader(AssetPaths.makushilvl__oel);
		loader.loadEntities(LoadRespawns, "respawns");
		FlxG.worldBounds.set(0, 0, 800, 600);
		
		var hud:FlxSprite = new FlxSprite(0, 500);
		hud.loadGraphic("assets/images/Hud.png", false, 800, 100);
		add(hud);
		
		waifu = new Waifu();
		add(waifu);
		add(waifu.hpBar);

		timeRemaining = new FlxText(530, 520, 0, "TIME LEFT\n    " + timeLeft, 20);
		timeRemaining.color = 0xFF000000;
		timeRemaining.setFormat("assets/BadaboomBB_Reg.ttf", 24, 0xFF000000);
		add(timeRemaining);
		
		comboCounter = new FlxText(680, 510, 0, "X" + combo, 50);
		comboCounter.color = 0xFF000000;
		comboCounter.setFormat("assets/BadaboomBB_Reg.ttf", 64, 0xFF000000);

		add(comboCounter);
		
		otakus = new FlxTypedGroup<Otaku>(26);
		add(otakus);

		spawnTimer = new FlxTimer();
		spawnTimer.start(spawnSpeed, SpawnEnemy, 0);
		
		clockTimer = new FlxTimer();
		clockTimer.start(1, Countdown, 0);

		speedUpTimer = new FlxTimer();
		speedUpTimer.start(20, SpeedUpRespawn, 2);
		
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

		if(hype)
		{		
			FlxG.camera.shake(hypeFactor, 0.2);
		}

		super.update(elapsed);
	}
	
	private function UpdateCombo():Void
	{
		comboCounter.text = "X" + combo;
		
		if (combo > Reg.maxCombo)
		{
			Reg.maxCombo = combo;
		}
		
		if(combo >= 15 && !hype)
		{
			GetHyped();
		}
	}

	private function GetHyped():Void
	{
		var song:Int = FlxG.random.int(1, 3);
		Reg.musicManager.stop();
		switch (song) 
		{
			case 1:
				Reg.musicManager = FlxG.sound.load("assets/music/NightOfFire.ogg", 1, true);
				Reg.musicManager.play();
			case 2:
				Reg.musicManager = FlxG.sound.load("assets/music/DejaVu.ogg", 1, true);
				Reg.musicManager.play();
			case 3:
				Reg.musicManager = FlxG.sound.load("assets/music/RunningInThe90S.ogg", 1, true);
				Reg.musicManager.play();
		}

		hype = true;
	}

	private function KillHype():Void
	{
		hype = false;
		Reg.musicManager.stop();
		Reg.musicManager = FlxG.sound.load("assets/music/MainMenu.ogg", 1, true);
		Reg.musicManager.play();
		hypeFactor = 0.001;
	}
	
	private function Countdown(Timer:FlxTimer):Void
	{
		timeLeft--;
		timeRemaining.text = "TIME LEFT\n    " + timeLeft;
		
		if(timeLeft < 30)
		{
			spawnSpeed = 0.5;
			spawnTimer.time = spawnSpeed;
		}

		if (timeLeft == 0)
		{
			FlxG.switchState(new GameOverState(true));
		}
	}

	private function SpeedUpRespawn(Timer:FlxTimer):Void
	{
		spawnSpeed -= 1;
		spawnTimer.time = spawnSpeed;
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
					Reg.otakusBeaten++;
					waifu.Blush();

					if(hype)
					{
						FlxG.camera.flash(respawnGetter.color());	
						
						if(hypeFactor < 0.01)
						{
							hypeFactor += 0.001;	
						}
						
					}
				}	
			}
			
			if (missed)
			{
				waifu.Damage();
				combo = 0;
				
				if(hype)
				{
					KillHype();	
				}
				
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
			if(otaku.alive)
			{
				otaku.Deactivate();
				waifu.Damage();
				combo = 0;
				
				if(hype)
				{
					KillHype();	
				}
				
				UpdateCombo();
				
				return true;
			}
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
		Reg.totalOtakus++;
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
