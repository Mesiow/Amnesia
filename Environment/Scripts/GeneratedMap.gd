extends Node2D

onready var grassTiles=$Tiles/GrassTileSet
onready var treeTiles=$Tiles/TreeTileSet

const TILE_SIZE = 16
const MAX_SIZE_X = 200
const MAX_SIZE_Y = 200

const START_X = -MAX_SIZE_X
const START_Y = -MAX_SIZE_Y

const WORLD_SIZE_X = MAX_SIZE_X * TILE_SIZE
const WORLD_SIZE_Y = MAX_SIZE_Y * TILE_SIZE

var grassArray = ["grass_1", "shrub_1", "shrub_2", "shrub_3"]
var treeArray = ["tree_1", "stump_1"]
var water = "water1"

onready var player = get_parent().get_node("Player")
var played = false

func _ready():
	generateMap()
	pass
	
	
func _process(delta):
	if player:
		var pos = grassTiles.world_to_map(player.global_position)
		var tile = grassTiles.get_cellv(pos)
		if tile == 4 and !played: #water index
			player.inWater = true
		else:
			player.inWater = false
	pass
	
func generateMap():
	randomize()
	var grass=grassTiles.tile_set
	var tree=treeTiles.tile_set
	
	for x in range(START_X, MAX_SIZE_X): #spawn grass tiles
		for y in range(START_Y, MAX_SIZE_Y):
			var grassTileName = grassArray[randi() %grassArray.size() + 0] #choose random tile
			var grassTile = grass.find_tile_by_name(grassTileName)
			var currCell = grassTiles.get_cell(x, y)
			if currCell == grassTiles.INVALID_CELL: #if there is no tile on the cell
				grassTiles.set_cell(x, y, grassTile)
			
			var spawn_tree = spawnTree()
			if spawn_tree:
				var stumpTile = tree.find_tile_by_name("stump_1")
				var treeTile = tree.find_tile_by_name("tree_1")
				treeTiles.set_cell(x, y, treeTile)
				treeTiles.set_cell(x, y + 8, stumpTile)
				
			var spawn_water = spawnWater()
			if spawn_water:
				var waterTile = grass.find_tile_by_name(water)
				#grassTiles.set_cell(x, y, waterTile)
	pass
	
func spawnTree():
	randomize()
	var random = randi() %1000 + 0
	if random >= 990:
		return true
	return false
	pass
	
func spawnWater():
	var random = randi() %1000 + 0
	if random % 10 == 0:
		return true
	return false
	pass
