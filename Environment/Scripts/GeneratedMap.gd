extends Node2D

onready var grassTiles=$Tiles/GrassTileSet
onready var treeTiles=$Tiles/TreeTileSet

var grassArray = ["grass_1", "shrub_1", "shrub_2", "shrub_3"]
var treeArray = ["tree_1"]

func _ready():
	randomize()
	var grass=grassTiles.tile_set
	
	for x in range(0, 50): #spawn grass tiles
		for y in range(0, 50):
			var tileName = grassArray[randi() %grassArray.size() + 0] #choose random tile
			var tile = grass.find_tile_by_name(tileName)
			grassTiles.set_cell(x, y, tile)
	pass
	
