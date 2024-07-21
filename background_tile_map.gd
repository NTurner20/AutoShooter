extends TileMap

@export var tile_ids = [0, 1, 2]  # The IDs of the tiles in the TileSet
@export var map_width = 100  # Adjust as needed
@export var map_height = 100  # Adjust as needed

func _ready():
	randomize()
	for x in range(map_width):
		for y in range(map_height):
			var tile_id = tile_ids[randi() % tile_ids.size()]
			set_cell(0,Vector2i(x, y), tile_id,Vector2i.ZERO)
