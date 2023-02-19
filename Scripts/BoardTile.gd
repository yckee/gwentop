extends Node2D

export(String) var tile_type
var tile_size setget set_tile_size, get_tile_size
var tile_pos setget set_tile_pos, get_tile_pos

func _ready():
	pass


func set_tile_size(_size):
	$Background.scale = Vector2(_size, _size) / $Background.texture.get_size()


func get_tile_size():
	return $Background.texture.get_width() * $Background.scale.x


func set_tile_pos(grid_pos):
	"""
	Sets tile's global position based on grid coordinates
	"""
	print (grid_pos * self.tile_size)
	position = grid_pos * self.tile_size

	
func get_tile_pos():
	"""
	Return tile's position in grid coordinates
	"""
	return position / self.tile_size
