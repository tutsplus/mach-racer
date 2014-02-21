import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Image;

class Gas extends Entity
{
	private var image:Image; //the gas can sprite
	private var speed:Float; //the speed at which to move

	public function new(xx:Float, speed:Float)
	{
		super();

		image = new Image("gfx/gascan.png");
		graphic = image;
		layer = 12;
		setHitbox(Std.int(image.scaledWidth), Std.int(image.scaledHeight));
		type = "gas";
		x = xx - halfWidth;
		y = -image.scaledHeight;
		this.speed = speed;
	}

	override public function update():Void
	{
		if(y < HXP.screen.height)
		{
			//still onscreen, so move downward
			y += speed * HXP.elapsed;
		}
		else
		{
			//offscreen, so we can remove it
			HXP.scene.remove(this);
		}
	}

	public function gameOver():Void
	{
		speed = 0; //the gas can will appear to be sitting still on the track
	}
}