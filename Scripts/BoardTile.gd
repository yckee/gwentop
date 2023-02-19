extends Node2D

export(String) var tile_type
var tile_size setget set_tile_size, get_tile_size
var tile_pos setget set_tile_pos, get_tile_pos

var is_clicked = false

func _ready():
	pass


func set_tile_size(_size):
	$Background.scale = Vector2(_size, _size) / $Background.texture.get_size()
	$CollisionShape2D.shape.extents = Vector2(_size, _size) / 2
	$CollisionShape2D.position = Vector2(_size, _size) / 2

func get_tile_size():
	return $Background.texture.get_width() * $Background.scale.x


func set_tile_pos(grid_pos):
	"""
	Sets tile's global position based on grid coordinates
	"""
	position = grid_pos * self.tile_size

	
func get_tile_pos():
	"""
	Return tile's position in grid coordinates
	"""
	return position / self.tile_size


func _on_BoardTile_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("left_click"):
		if is_clicked:
			modulate = Color(1,1,1,1)
			is_clicked = false
		else:
			modulate = Color(1.5,1.2,1,1)
			is_clicked = true
			
