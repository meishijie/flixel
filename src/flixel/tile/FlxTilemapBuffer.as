package flixel.tile
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import flixel.FlxG;
	import flixel.FlxCamera;
	import flixel.util.FlxMath;

	/**
	 * A helper object to keep tilemap drawing performance decent across the new multi-camera system.
	 * Pretty much don't even have to think about this class unless you are doing some crazy hacking.
	 * 
	 * @author	Adam Atomic
	 */
	public class FlxTilemapBuffer
	{
		/**
		 * The current X position of the buffer.
		 */
		public var x:Number;
		/**
		 * The current Y position of the buffer.
		 */
		public var y:Number;
		/**
		 * The width of the buffer (usually just a few tiles wider than the camera).
		 */
		public var width:Number;
		/**
		 * The height of the buffer (usually just a few tiles taller than the camera).
		 */
		public var height:Number;
		/**
		 * Whether the buffer needs to be redrawn.
		 */
		public var dirty:Boolean;
		/**
		 * How many rows of tiles fit in this buffer.
		 */
		public var rows:uint;
		/**
		 * How many columns of tiles fit in this buffer.
		 */
		public var columns:uint;

		protected var _pixels:BitmapData;	
		protected var _flashRect:Rectangle;

		/**
		 * Instantiates a new camera-specific buffer for storing the visual tilemap data.
		 *  
		 * @param TileWidth		The width of the tiles in this tilemap.
		 * @param TileHeight	The height of the tiles in this tilemap.
		 * @param WidthInTiles	How many tiles wide the tilemap is.
		 * @param HeightInTiles	How many tiles tall the tilemap is.
		 * @param Camera		Which camera this buffer relates to.
		 */
		public function FlxTilemapBuffer(TileWidth:Number,TileHeight:Number,WidthInTiles:uint,HeightInTiles:uint,Camera:FlxCamera=null)
		{
			if(Camera == null)
				Camera = FlxG.camera;

			columns = FlxMath.ceil(Camera.width/TileWidth)+1;
			if(columns > WidthInTiles)
				columns = WidthInTiles;
			rows = FlxMath.ceil(Camera.height/TileHeight)+1;
			if(rows > HeightInTiles)
				rows = HeightInTiles;
			
			_pixels = new BitmapData(columns*TileWidth,rows*TileHeight,true,0);
			width = _pixels.width;
			height = _pixels.height;			
			_flashRect = new Rectangle(0,0,width,height);
			dirty = true;
		}
		
		/**
		 * Clean up memory.
		 */
		public function destroy():void
		{
			_pixels = null;
		}
		
		/**
		 * Fill the buffer with the specified color.
		 * Default value is transparent.
		 * 
		 * @param	Color	What color to fill with, in 0xAARRGGBB hex format.
		 */
		public function fill(Color:uint=0):void
		{
			_pixels.fillRect(_flashRect,Color);
		}
		
		/**
		 * Read-only, nab the actual buffer <code>BitmapData</code> object.
		 * 
		 * @return	The buffer bitmap data.
		 */
		public function get pixels():BitmapData
		{
			return _pixels;
		}
		
		/**
		 * Just stamps this buffer onto the specified camera at the specified location.
		 * 
		 * @param	Camera		Which camera to draw the buffer onto.
		 * @param	FlashPoint	Where to draw the buffer at in camera coordinates.
		 */
		public function draw(Camera:FlxCamera,FlashPoint:Point):void
		{
			FlxG.render.copyPixelsToBuffer(Camera, _pixels,_flashRect,FlashPoint,null,null,true);
		}
	}
}