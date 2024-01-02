extends Node2D
class_name Dungeon
@onready var rooms_container = $Rooms_container

var grid_x : int = 9
var grid_y : int = 8
var maxRooms : int = 14
var minRooms : int = 8
var starting_room_pos : Vector2i = Vector2i(3, 5)

var room = preload("res://Scenes/room.tscn")

var grid : Array 
var roomCount : int 

var rooms_queue : Array 
var end_rooms : Array

func _ready():
	generate()

func setup() -> void:
	grid = []
	for _y in range(grid_y):
		grid.append([])
		for _x in range(grid_x):
			grid[_y].append(0)

	rooms_queue = []
	end_rooms = []
	roomCount = 0
	for c in rooms_container.get_children():
		rooms_container.remove_child(c)

func generate() -> void:
	while true:
		setup()
		visit(starting_room_pos)
		spread()
		if roomCount > minRooms:
			break

# return the ammount of neigbours
func ncount(pos : Vector2i) -> int:
	return grid[pos.y - 1][pos.x] + grid[pos.y + 1][pos.x] + grid[pos.y][pos.x - 1] + grid[pos.y][pos.x + 1]

func visit(pos : Vector2i) -> bool:
	if grid[pos.y][pos.x] == 1 : 
		return false
		
	var neighbours = ncount(pos)
	if neighbours > 1 : return false
	
	if roomCount >= maxRooms: return false
	
	var rnd = randf()
	if rnd < 0.5 && !(pos == starting_room_pos): return false
	
	# add to queue
	var r : Room = room.instantiate()
	rooms_container.add_child(r)
	r.setup(pos)
	if (pos == starting_room_pos) : r.set_as_start_room()
	rooms_queue.push_back(r)
	grid[pos.y][pos.x] = 1
	roomCount += 1
	
	return true

func spread() -> void:
	if rooms_queue.size() == 0:
		return
	var cur_room : Room = rooms_queue.pop_back()
	var created_left : bool = false
	var created_right : bool = false
	var created_top : bool = false
	var created_bottom : bool = false
	if cur_room.grid_pos.x > 1 : 
		created_left  = visit(Vector2i(cur_room.grid_pos.x - 1, cur_room.grid_pos.y))
	if cur_room.grid_pos.x < grid_x - 2 : 
		created_right = visit(Vector2i(cur_room.grid_pos.x + 1, cur_room.grid_pos.y))
	if cur_room.grid_pos.y > 1 : 
		created_top = visit(Vector2i(cur_room.grid_pos.x, cur_room.grid_pos.y - 1))
	if cur_room.grid_pos.y < grid_y - 2 : 
		created_bottom = visit(Vector2i(cur_room.grid_pos.x, cur_room.grid_pos.y + 1))
	if not (created_left or created_right or created_top or created_bottom):
		cur_room.set_as_end_room()
		end_rooms.append(cur_room)
	spread()
