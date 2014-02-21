import com.haxepunk.Scene;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Text;
import com.haxepunk.utils.Input;
#if !mobile
import com.haxepunk.utils.Key;
#end

class TitleScene extends Scene
{
	public function new()
	{
		super();

		var title:Text = new Text("Mach Racer");
		title.color = 0xff5500;
		title.size = 48;
		title.x = (HXP.screen.width * .5) - (title.scaledWidth * .5); //center horizontally
		title.y = 0;
		addGraphic(title);

		var description:Text = new Text("Arrow keys or A/D to move.\nAvoid cars, collect gas.\nPress Enter to begin");
		description.color = 0x00aaff;
		description.size = 32;
		description.x = (HXP.screen.width * .5) - (description.scaledWidth * .5);   //center horizontally
		description.y = (HXP.screen.height * .5) - (description.scaledHeight * .5); //center vertically
		addGraphic(description);
	}

	override public function update():Void
	{
		super.update();

		#if mobile
		if(Input.mousePressed)
		{
			HXP.scene.removeAll();
			HXP.scene = new PlayScene();
		}
		#else
		if(Input.pressed(Key.ENTER))
		{
			HXP.scene.removeAll();
			HXP.scene = new PlayScene();
		}
		#end
	}
}