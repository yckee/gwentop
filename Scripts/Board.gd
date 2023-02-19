extends Node2D

const BoardTileScene = preload("res://Scenes/BoardTile.tscn")
export var board_size = Vector2(6, 4)


# Called when the node enters the scene tree for the first time.
func _ready():
	print (board_size.x, board_size.y)
	for x in range(board_size.x):
		for y in range(board_size.y):
			var tile = BoardTileScene.instance()
			tile.tile_size = 80
			tile.tile_pos = Vector2(x, y)
			add_child(tile)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
