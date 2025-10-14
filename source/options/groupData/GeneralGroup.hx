package options.groupData;

import shaders.ColorblindFilter;

class GeneralGroup extends OptionCata
{
	public function new(X:Float, Y:Float, width:Float, height:Float)
	{
		super(X, Y, width, height);

		var option:Option = new Option(this, 'General', TITLE);
		addOption(option);

		var option:Option = new Option(this, 'framerate', INT, [24, 1000, 'FPS']);
		addOption(option);
		option.onChange = onChangeFramerate;

		var langArray:Array<String> = languageArray();
		var option:Option = new Option(this, 'language', STRING, langArray);
		addOption(option);
		option.onChange = onChangeLanguage;

		var option:Option = new Option(this, 'gameQuality', INT, [0, 3]);
		addOption(option);

		var option:Option = new Option(this, 'lowQuality', BOOL);
		addOption(option);

		var colorblindFilterArray:Array<String> = [
			'None',
			'Protanopia',
			'Protanomaly',
			'Deuteranopia',
			'Deuteranomaly',
			'Tritanopia',
			'Tritanomaly',
			'Achromatopsia',
			'Achromatomaly'
		];

		var option:Option = new Option(this, 'colorblindMode', STRING, colorblindFilterArray);
		addOption(option, true);
		option.onChange = onChangeFilter;

		var option:Option = new Option(this, 'antialiasing', BOOL);
		addOption(option);

		var option:Option = new Option(this, 'flashing', BOOL);
		addOption(option, true);

		var option:Option = new Option(this, 'shaders', BOOL);
		addOption(option);

		var option:Option = new Option(this, 'cacheOnGPU', BOOL);
		addOption(option, true);

		var option:Option = new Option(this, 'autoPause', BOOL);
		addOption(option);
		option.onChange = onChangePause;

		var option:Option = new Option(this, 'gcFreeZone', BOOL);
		addOption(option, true);
		option.onChange = onChangeGcZone;

		changeHeight(0); //初始化真正的height
	}

	///////////////////////////////////////////////////////////////////////////

	function languageArray():Array<String> 
	{
		var output:Array<String> = [];
		var contents:Array<String> = FileSystem.readDirectory(Paths.getPath('language'));
		for (item in contents)
		{
			if (item == "JustSay")
				continue; // JustSay不能被读取为语言文件
			var itemPath = Paths.getPath('language') + '/' + item;
			if (FileSystem.isDirectory(itemPath))
			{
				output.push(item);
			}
		}
		Language.check();
		return output;
	}

	///////////////////////////////////////////////////////////////

	function onChangeFramerate()
	{
		if (ClientPrefs.data.framerate > FlxG.drawFramerate)
		{
			FlxG.updateFramerate = ClientPrefs.data.framerate;
			FlxG.drawFramerate = Std.int(Math.min(FlxG.stage.application.window.displayMode.refreshRate, ClientPrefs.data.framerate));
			FlxG.stage.window.frameRate = FlxG.drawFramerate;
		}
		else
		{
			FlxG.drawFramerate = Std.int(Math.min(FlxG.stage.application.window.displayMode.refreshRate, ClientPrefs.data.framerate));
			FlxG.updateFramerate = ClientPrefs.data.framerate;
			FlxG.stage.window.frameRate = FlxG.drawFramerate;
		}
	}

	function onChangeFilter()
	{
		ColorblindFilter.UpdateColors();
	}

	function onChangePause()
	{
		FlxG.autoPause = ClientPrefs.data.autoPause;
	}

	function onChangeLanguage()
	{
		Language.resetData();
		OptionsState.instance.changeLanguage();
	}

	function onChangeGcZone()
	{
		Main.GcZoneChange();
	}
}
