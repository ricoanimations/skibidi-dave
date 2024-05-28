package;

import sys.FileSystem;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;

using StringTools;

class Character extends FlxSprite
{
	public var animOffsets:Map<String, Array<Dynamic>>;
	public var debugMode:Bool = false;

	public var isPlayer:Bool = false;
	public var curCharacter:String = 'bf';

	public var holdTimer:Float = 0;
	public var furiosityScale:Float = 1.02;
	public var canDance:Bool = true;

	public var nativelyPlayable:Bool = false;

	public var globalOffset:Array<Float> = new Array<Float>();
	public var offsetScale:Float = 1;

	public var barColor:FlxColor;

	public var canSing:Bool = true;
	public var skins:Map<String, String> = new Map<String, String>();

	public var charList:Array<String> = [];

	public function new(x:Float, y:Float, ?character:String = "bf", ?isPlayer:Bool = false)
	{
		super(x, y);

		animOffsets = new Map<String, Array<Dynamic>>();
		curCharacter = character;
		this.isPlayer = isPlayer;
		charList = CoolUtil.coolTextFile(Paths.file('data/characterList.txt', TEXT, 'preload'));

		skins.set('normal', curCharacter);
		skins.set('gfSkin', 'gf-none');

		antialiasing = true;

		switch (curCharacter)
		{
			case 'bf':
				frames = Paths.getSparrowAtlas('characters/BOYFRIEND', 'shared');

				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);
				animation.addByPrefix('dodge', "boyfriend dodge", 24, false);
				animation.addByPrefix('scared', 'BF idle shaking', 24);
				animation.addByPrefix('hit', 'BF hit', 24, false);

				loadOffsetFile(curCharacter);

				skins.set('gfSkin', 'gf');

				barColor = FlxColor.fromRGB(49, 176, 209);

				playAnim('idle');

				nativelyPlayable = true;

				flipX = true;
			case 'bf-pixel':
				frames = Paths.getSparrowAtlas('characters/bfPixel', 'shared');
				animation.addByPrefix('idle', 'BF IDLE', 24, false);
				animation.addByPrefix('singUP', 'BF UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'BF LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'BF RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'BF DOWN NOTE', 24, false);
				animation.addByPrefix('singUPmiss', 'BF UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF DOWN MISS', 24, false);

				loadOffsetFile(curCharacter);

				skins.set('gfSkin', 'gf-pixel');

				globalOffset = [196, 163];

				barColor = FlxColor.fromRGB(49, 176, 209);

				setGraphicSize(Std.int(width * PlayState.daPixelZoom));
				updateHitbox();

				antialiasing = false;
				nativelyPlayable = true;

				playAnim('idle');
				flipX = true;
			case 'bf-pixel-dead':
				frames = Paths.getSparrowAtlas('characters/bfPixelsDEAD', 'shared');
				animation.addByPrefix('singUP', "BF Dies pixel", 24, false);
				animation.addByPrefix('firstDeath', "BF Dies pixel", 24, false);
				animation.addByPrefix('deathLoop', "Retry Loop", 24, true);
				animation.addByPrefix('deathConfirm', "RETRY CONFIRM", 24, false);

				loadOffsetFile(curCharacter);

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				antialiasing = false;
				nativelyPlayable = true;
				flipX = true;
				playAnim('firstDeath');
			case 'generic-death':
				frames = Paths.getSparrowAtlas('ui/lose', 'shared');
				animation.addByPrefix('firstDeath', "lose... instance 1", 24, false);
				animation.addByPrefix('deathLoop', "still", 24, true);
				animation.addByPrefix('deathConfirm', "still", 24, false);

				loadOffsetFile(curCharacter);
				flipX = true;
				playAnim('firstDeath');
			case 'gf':
				// GIRLFRIEND CODE
				frames = Paths.getSparrowAtlas('characters/GF_assets', 'shared');

				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				loadOffsetFile(curCharacter);

				barColor = FlxColor.fromString('#33de39');

				playAnim('danceRight');
			case 'gf-pixel':
				frames = Paths.getSparrowAtlas('characters/gfPixel', 'shared');
				animation.addByIndices('singUP', 'GF IDLE', [2], "", 24, false);
				animation.addByIndices('danceLeft', 'GF IDLE', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF IDLE', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				loadOffsetFile(curCharacter);

				globalOffset = [300, 280];

				setGraphicSize(Std.int(width * PlayState.daPixelZoom));
				updateHitbox();
				antialiasing = false;
				barColor = FlxColor.fromString('#33de39');

				playAnim('danceRight');
			case 'gf-christmas':
				frames = Paths.getSparrowAtlas('characters/gfChristmas', 'shared');
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				addOffset('cheer');
				addOffset('sad', -2, -2);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", 0, 4);
				addOffset("singRIGHT", 0, -20);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -20);
				addOffset('hairBlow', 45, -8);
				addOffset('hairFall', 0, -9);

				addOffset('scared', -2, -17);

				barColor = FlxColor.fromString('#33de39');

				playAnim('danceRight');

			case 'gf-car':
				frames = Paths.getSparrowAtlas('characters/gfCar', 'shared');

				animation.addByIndices('singUP', 'GF Dancing Beat Hair blowing CAR', [0], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat Hair blowing CAR', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat Hair blowing CAR', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24,
					false);

				addOffset('danceLeft', 0);
				addOffset('danceRight', 0);

				barColor = FlxColor.fromString('#33de39');

				playAnim('danceRight');
			case 'dad':
				// DAD ANIMATION LOADING CODE
				frames = Paths.getSparrowAtlas('characters/DADDY_DEAREST', 'shared');

				animation.addByPrefix('idle', 'Dad idle dance', 24);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);

				addOffset('idle');
				addOffset("singUP", -6, 50);
				addOffset("singRIGHT", 0, 27);
				addOffset("singLEFT", -10, 10);
				addOffset("singDOWN", 0, -30);

				barColor = FlxColor.fromString(getColorCode(curCharacter));

				playAnim('idle');
			case 'bf-car':
				frames = Paths.getSparrowAtlas('characters/bfCar', 'shared');

				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);

				addOffset('idle', -5);
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -38, -7);
				addOffset("singLEFT", 12, -6);
				addOffset("singDOWN", -10, -50);
				addOffset("singUPmiss", -29, 27);
				addOffset("singRIGHTmiss", -30, 21);
				addOffset("singLEFTmiss", 12, 24);
				addOffset("singDOWNmiss", -11, -19);

				skins.set('gfSkin', 'gf-car');

				barColor = FlxColor.fromString(getColorCode(curCharacter));

				playAnim('idle');

				nativelyPlayable = true;
				flipX = true;
			case 'squid':
				frames = Paths.getSparrowAtlas('characters/squid', 'shared');

				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singLEFT', 'left', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);

				globalOffset = [0, 170];

				barColor = FlxColor.fromRGB(187, 223, 209);
				playAnim('idle');
			case 'dave':
				frames = Paths.getSparrowAtlas('characters/dave_sheet', 'shared');
				animation.addByPrefix('idle', 'idle', 24, false);
				for (anim in ['left', 'down', 'up', 'right'])
				{
					animation.addByPrefix('sing${anim.toUpperCase()}', '${anim}0', 24, false);
					animation.addByPrefix('sing${anim.toUpperCase()}miss', '$anim miss', 24, false);
				}
				animation.addByPrefix('hey', 'hey', 24, false);
	
				globalOffset = [0, 170];

				barColor = FlxColor.fromRGB(15, 95, 255);
				
				loadOffsetFile(curCharacter);

				playAnim('idle');
			case 'amogus':
				frames = Paths.getSparrowAtlas('characters/amogus', 'shared');

				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singLEFT', 'left', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);

				globalOffset = [0, 170];

				barColor = FlxColor.fromRGB(49, 255, 234);
				
				playAnim('idle');
			case 'lankybox':
				frames = Paths.getSparrowAtlas('characters/lankybox', 'shared');

				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singLEFT', 'left', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);

				globalOffset = [0, 0];

				barColor = FlxColor.fromRGB(255, 222, 231);
				
				playAnim('idle');
			case 'bambi':
				frames = Paths.getSparrowAtlas('characters/bambiRemake', 'shared');
				animation.addByPrefix('idle', 'bambi idle', 24, false);
				for (anim in ['left', 'down', 'up', 'right'])
				{
					animation.addByPrefix('sing${anim.toUpperCase()}', 'bambi $anim', 24, false);
					animation.addByPrefix('sing${anim.toUpperCase()}miss', 'miss $anim', 24, false);
				}
				for (anim in ['left', 'right'])
				{
					animation.addByPrefix('sing${anim.toUpperCase()}-alt', 'bambi alt $anim', 24, false);
				}
				animation.addByPrefix('hey', 'bambi look', 24, false);
				animation.addByPrefix('singSmash', 'bambi phone', 24, false);
				animation.addByPrefix('singThrow', 'bambi throw', 24, false);

				barColor = FlxColor.fromRGB(37, 191, 55);

				loadOffsetFile(curCharacter);

				globalOffset = [37, 90];

				playAnim('idle');
			case 'tristan':
				frames = Paths.getSparrowAtlas('characters/TRISTAN', 'shared');

				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				for (anim in ['LEFT', 'DOWN', 'UP', 'RIGHT'])
				{
					animation.addByPrefix('sing$anim', 'BF NOTE ${anim}0', 24, false);
					animation.addByPrefix('sing${anim}miss', 'BF NOTE $anim MISS', 24, false);
				}
				animation.addByPrefix('hey', 'BF HEY!!', 24, false);
				animation.addByPrefix('scared', 'BF idle shaking', 24);
				animation.addByPrefix('dodge', "boyfriend dodge", 24, false);

				globalOffset = [0, 15];

				loadOffsetFile(curCharacter);

				barColor = FlxColor.fromRGB(255, 19, 15);
				nativelyPlayable = true;
				flipX = true;

				playAnim('idle');
			case 'sponge':
				frames = Paths.getSparrowAtlas('characters/sponge', 'shared');

				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singLEFT', 'left', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);

				globalOffset = [0, 170];

				barColor = FlxColor.fromRGB(255, 247, 107);
				
				playAnim('idle');
		}
		dance();

		if (isPlayer)
		{
			flipX = !flipX;
		}
	}

	function loadOffsetFile(character:String)
	{
		var offsetStuffs:Array<String> = CoolUtil.coolTextFile(Paths.offsetFile(character));

		for (offsetframest in offsetStuffs)
		{
			var offsetInfo:Array<String> = offsetframest.split(' ');

			addOffset(offsetInfo[0], Std.parseFloat(offsetInfo[1]), Std.parseFloat(offsetInfo[2]));
		}
	}

	override function update(elapsed:Float)
	{
		if (animation == null)
		{
			super.update(elapsed);
			return;
		}
		else if (animation.curAnim == null)
		{
			super.update(elapsed);
			return;
		}
		if (!nativelyPlayable && !isPlayer)
		{
			if (animation.curAnim.name.startsWith('sing'))
			{
				holdTimer += elapsed;
			}

			var dadVar:Float = 4;

			if (curCharacter == 'dad')
				dadVar = 6.1;
			if (holdTimer >= Conductor.stepCrochet * dadVar * 0.001)
			{
				dance();
				holdTimer = 0;
			}
		}

		switch (curCharacter)
		{
			case 'gf':
				if (animation.curAnim.name == 'hairFall' && animation.curAnim.finished)
					playAnim('danceRight');
		}

		super.update(elapsed);
	}

	private var danced:Bool = false;

	/**
	 * FOR DANCING SHIT
	 */
	public function dance()
	{
		if (!debugMode && canDance)
		{
			switch (curCharacter)
			{
				case 'gf':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}

				case 'gf-christmas':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}

				case 'gf-car':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}
				case 'gf-pixel':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}

				case 'spooky':
					danced = !danced;

					if (danced)
						playAnim('danceRight');
					else
						playAnim('danceLeft');
				default:
					playAnim('idle');
			}
		}
	}

	public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
	{
		if (animation.getByName(AnimName) == null)
		{
			return; // why wasn't this a thing in the first place
		}
		if ((AnimName.toLowerCase() == 'idle' || AnimName.toLowerCase().startsWith('dance')) && !canDance)
		{
			return;
		}

		if (AnimName.toLowerCase().startsWith('sing') && !canSing)
		{
			return;
		}

		animation.play(AnimName, Force, Reversed, Frame);

		var daOffset = animOffsets.get(AnimName);
		if (animOffsets.exists(AnimName))
		{
			offset.set(daOffset[0] * offsetScale, daOffset[1] * offsetScale);
		}
		else
			offset.set(0, 0);

		if (curCharacter == 'gf')
		{
			if (AnimName == 'singLEFT')
			{
				danced = true;
			}
			else if (AnimName == 'singRIGHT')
			{
				danced = false;
			}

			if (AnimName == 'singUP' || AnimName == 'singDOWN')
			{
				danced = !danced;
			}
		}
	}

	public function addOffset(name:String, x:Float = 0, y:Float = 0)
	{
		animOffsets[name] = [x, y];
	}

	public function getColorCode(char:String):String
	{
		var returnedString:String = '';
		for (i in 0...charList.length)
		{
			var currentValue = charList[i].trim().split(':');
			if (currentValue[0] != char)
			{
				continue;
			}
			else
			{
				returnedString = currentValue[2]; //this is the color code one
			}
		}
		if (returnedString == '')
		{
			return char;
		}
		else
		{
			return returnedString;
		}
	}
}
