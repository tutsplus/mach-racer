import com.haxepunk.Engine;
import com.haxepunk.HXP;

class Main extends Engine
{
	public static inline var kScreenWidth:Int = 800;
	public static inline var kScreenHeight:Int = 600;
	public static inline var kFrameRate:Int = 60;

	public function new()
	{
		super(kScreenWidth, kScreenHeight, kFrameRate, false);
	}

	override public function init()
	{
	#if debug
		#if flash
		if (flash.system.Capabilities.isDebugger)
		#end
		{
			//HXP.console.enable();
		}
	#end
		HXP.screen.scale = 1;
		HXP.scene = new TitleScene();
	}

	public static function main()
	{
		var app = new Main();
	}
}