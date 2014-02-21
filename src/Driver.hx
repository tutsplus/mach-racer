import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Image;

class Driver extends Entity
{
	private var image:Image; //the driver sprite
	private var speed:Float; //the speed at which to move

	public function new(xx:Float, speed:Float)
	{
		super();

		image = new Image("gfx/driver.png");
		graphic = image;
		setHitbox(Std.int(image.scaledWidth), Std.int(image.scaledHeight));
		type = "driver";
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
		speed *= -1; //the vehicle will appear to drive away
	}
}