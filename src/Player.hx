import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Image;

class Player extends Entity
{
	public var health:Int; //the health of the player's vehicle
	public var gas:Float; //the amount of gas the player has left
	public var curLane:Int; //the lane number that the player is currently in
	private var image:Image; //the player sprite

	public function new()
	{
		super();

		image = new Image("gfx/player.png");
		graphic = image;
		layer = 9;
		setHitbox(Std.int(image.scaledWidth), Std.int(image.scaledHeight));
		type = "player";
		curLane = 1;
		health = 3;
		gas = 100;
	}

	override public function update():Void
	{
		var collobj:Entity = collide("driver", x, y);
		if(collobj != null)
		{
			//collided with a driver
			health -= 1;
			HXP.scene.remove(collobj);
		}
		collobj = collide("gas", x, y);
		if(collobj != null)
		{
			//collided with a gas can
			gas += 50;
			if(gas > 100)
			{
				gas = 100;
			}
			HXP.scene.remove(collobj);
		}
	}
}