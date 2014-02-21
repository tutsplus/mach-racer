import com.haxepunk.Scene;
import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.utils.Input;
#if !mobile
import com.haxepunk.utils.Key;
#end
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Text;
import com.haxepunk.tweens.motion.LinearMotion;

class PlayScene extends Scene
{
	private var healthText:Text;          //text to display the player's health
	private var gasText:Text;             //text to display the amount of gas left
	private var distanceText:Text;        //text to display the distance traveled
	private var track1:Image;             //two images for the track to
	private var track2:Image;             //give the illusion of an infinite track
	private var playerTween:LinearMotion; //the tween used for moving the player
	private var laneWidth:Float;          //the width of an individual lane
	private var trackRightEdge:Float;     //the position of the rightmost edge of the track
	private var laneX:Array<Float>;       //an array of the x positions of each lane
	private var gameSpeed:Float;          //the current speed at which to move the track images
	private var distance:Float;           //the distance the player has traveled
	private var baseDriverTimer:Float;    //driverTimer starts at this amount
	private var driverTimer:Float;        //counts down to add a new driver
	private var baseGasTimer:Float;       //gasTimer starts at this amount
	private var gasTimer:Float;           //counts down to add a new gas can
	private var player:Player;            //the player
	private var gameover:Bool;            //whether or not the game has ended
	private var endTimer:Float;           //the amount of time to wait after the game ends

	public function new()
	{
		super();

		track1 = new Image("gfx/track.png");
		track1.y = 0;                        //placed at the top of the screen
		addGraphic(track1, 15); //addGraphic() adds an image to the scene, in this case, on layer 15. Higher layers are drawn first.
		track2 = new Image("gfx/track.png");
		track2.y = -track2.scaledHeight;     //placed immediately above the first track image
		addGraphic(track2, 15);

		laneWidth = 80;
		laneX = [20, 120, 220, 320];
		trackRightEdge = laneX[3] + laneWidth + 20;

		gameSpeed = 240;
		distance = 0;
		baseDriverTimer = 4.5;
		driverTimer = 2;
		baseGasTimer = 8.75;
		gasTimer = baseGasTimer;
		gameover = false;
		endTimer = 3;

		healthText = new Text("Health: 3");
		healthText.color = 0xffff00;
		healthText.size = 28;
		healthText.x = HXP.screen.width - ((HXP.screen.width - trackRightEdge) * .5) - (healthText.scaledWidth * .5);
		healthText.y = (HXP.screen.height * .25) - (healthText.scaledHeight * .5);
		addGraphic(healthText);

		gasText = new Text("Gas: 100");
		gasText.color = 0xffff00;
		gasText.size = 28;
		gasText.x = HXP.screen.width - ((HXP.screen.width - trackRightEdge) * .5) - (gasText.scaledWidth * .5);
		gasText.y = (HXP.screen.height * .5) - (gasText.scaledHeight * .5);
		addGraphic(gasText);

		distanceText = new Text("Distance: 0");
		distanceText.color = 0xffff00;
		distanceText.size = 28;
		distanceText.x = HXP.screen.width - ((HXP.screen.width - trackRightEdge) * .5) - (distanceText.scaledWidth * .5);
		distanceText.y = (HXP.screen.height * .75) - (distanceText.scaledHeight * .5);
		addGraphic(distanceText);

		player = new Player();
		player.x = laneX[1] + (laneWidth * .5) - player.halfWidth; //start in second lane
		player.y = HXP.screen.height * .75;
		add(player); //adds an entity to the scene

		playerTween = new LinearMotion();
		playerTween.x = player.x;
		playerTween.y = player.y;
		player.addTween(playerTween);

		#if !mobile
		Input.define("left", [Key.A, Key.LEFT]);
		Input.define("right", [Key.D, Key.RIGHT]);
		#end
	}

	override public function update():Void
	{
		super.update();

		if(gameover)
		{
			if(endTimer > 0)
			{
				endTimer -= HXP.elapsed;
			}
			else
			{
				HXP.scene.removeAll();
				HXP.scene = new TitleScene();
			}
		}
		else
		{
			//scroll track images to create the illusion of movement
			track1.y += gameSpeed * HXP.elapsed;
			track2.y += gameSpeed * HXP.elapsed;
			if(track1.y > HXP.screen.height)
			{
				track1.y = track2.y - track1.scaledHeight;
			}
			else if(track2.y > HXP.screen.height)
			{
				track2.y = track1.y - track2.scaledHeight;
			}

			if(driverTimer > 0)
			{
				driverTimer -= HXP.elapsed;
			}
			else
			{
				var d:Driver = new Driver(laneX[HXP.rand(4)] + (laneWidth * .5), gameSpeed - 60);
				add(d);
				baseDriverTimer -= .05;
				driverTimer += baseDriverTimer;
			}

			if(gasTimer > 0)
			{
				gasTimer -= HXP.elapsed;
			}
			else
			{
				var g:Gas = new Gas(laneX[HXP.rand(4)] + (laneWidth * .5), gameSpeed);
				add(g);
				baseGasTimer -= .05;
				gasTimer += baseGasTimer;
			}

			#if mobile
			if(Input.mousePressed)
			{
				if(Input.mouseX < HXP.screen.width * .5)
				{
					move("left");
				}
				else
				{
					move("right");
				}
			}
			#else
			if(Input.pressed("left"))
			{
				move("left");
			}
			if(Input.pressed("right"))
			{
				move("right");
			}
			#end

			//update the text entities
			healthText.text = "Health: " + player.health;
			healthText.x = HXP.screen.width - ((HXP.screen.width - trackRightEdge) * .5) - (healthText.scaledWidth * .5);
			gasText.text = "Gas: " + HXP.round(player.gas, 1);
			gasText.x = HXP.screen.width - ((HXP.screen.width - trackRightEdge) * .5) - (gasText.scaledWidth * .5);
			distanceText.text = "Distance: " + HXP.round(distance, 1);
			distanceText.x = HXP.screen.width - ((HXP.screen.width - trackRightEdge) * .5) - (distanceText.scaledWidth * .5);

			player.x = playerTween.x; //this actually moves the player during the tween

			if(player.gas > 0 && player.health > 0)
			{
				gameSpeed += .05 * HXP.elapsed;
				distance += 10 * HXP.elapsed;
				player.gas -= 5 * HXP.elapsed;
				if(player.gas < 0)
				{
					player.gas = 0;
				}
			}
			else
			{
				gameover = true;
				var drivers:Array<Driver> = [];
				var gascans:Array<Gas> = [];
				getType("driver", drivers);
				for(d in drivers)
				{
					d.gameOver();
				}
				getType("gas", gascans);
				for(g in gascans)
				{
					g.gameOver();
				}
			}
		}
	}

	private function move(dir:String):Void
	{
		if(dir == "left")
		{
			if(player.curLane > 0)
			{
				player.curLane -= 1;
				playerTween.setMotion(player.x, player.y, laneX[player.curLane] + (laneWidth * .5) - player.halfWidth, player.y, .25);
			}
		}
		else //assuming that dir == "right"
		{
			if(player.curLane < laneX.length - 1)
			{
				player.curLane += 1;
				playerTween.setMotion(player.x, player.y, laneX[player.curLane] + (laneWidth * .5) - player.halfWidth, player.y, .25);
			}
		}
	}
}