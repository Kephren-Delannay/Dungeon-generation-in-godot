extends Node2D

class_name Room

var grid_pos : Vector2i

var roomSize : Vector2i = Vector2i(128, 80)
var offset : Vector2i = Vector2i(-384, -400) # -3 * roomSize.x, -5 * roomSize.y

enum type {START, BASE, END}
var roomType : type

func setup(pos : Vector2i) -> void:
	grid_pos = pos
	roomType = type.BASE
	position = Vector2i(offset.x + grid_pos.x * roomSize.x, offset.y + grid_pos.y * roomSize.y)

func set_as_start_room() -> void:
	roomType = type.START
	modulate = Color.RED
	
func set_as_end_room() -> void:
	roomType = type.END

