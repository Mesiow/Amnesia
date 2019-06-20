extends Node2D

onready var grassTiles=$Tiles/GrassTileSet
onready var treeTiles=$Tiles/TreeTileSet

const TILE_SIZE = 16
const MAX_SIZE_X = 300
const MAX_SIZE_Y = 200

const START_X = -100
const START_Y = -100

var grassArray = ["grass_1", "shrub_1", "shrub_2", "shrub_3"]
var treeArray = ["tree_1", "stump_1"]

func _ready():
	generateMap()
	pass
	
	
func generateMap():
	randomize()
	var grass=grassTiles.tile_set
	var tree=treeTiles.tile_set
	
	for x in range(START_X, MAX_SIZE_X): #spawn grass tiles
		for y in range(START_Y, MAX_SIZE_Y):
			var grassTileName = grassArray[randi() %grassArray.size() + 0] #choose random tile
			var grassTile = grass.find_tile_by_name(grassTileName)
			grassTiles.set_cell(x, y, grassTile)
			
			var spawn = spawnTree()
			if spawn:
				var stumpTile = tree.find_tile_by_name("stump_1")
				var treeTile = tree.find_tile_by_name("tree_1")
				treeTiles.set_cell(x, y, treeTile)
				treeTiles.set_cell(x, y + 8, stumpTile)
	pass
	
func spawnTree():
	randomize()
	var random = randi() %1000 + 0
	if random >= 990:
		return true
	return false
	pass
