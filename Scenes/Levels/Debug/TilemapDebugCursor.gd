extends ColorRect
class_name TilemapDebugCursor

onready var tilemap : TileMap = get_parent()
export var active : bool = false setget set_active, is_active

#### ACCESSORS ####

func is_class(value: String): return value == "DebugCursor" or .is_class(value)
func get_class() -> String: return "DebugCursor"

func set_active(value: bool): 
	active = value
	set_visible(value)

func is_active() -> bool : return active


#### BUILT-IN ####

func _ready() -> void:
	set_visible(active)


func _physics_process(_delta: float) -> void:
	var mouse_pos = get_global_mouse_position()
	var cell = tilemap.world_to_map(mouse_pos)

	set_active(owner.is_pos_inside_chunck(mouse_pos))
	
	$VBoxContainer/Cell.set_text("cell: " + String(cell))
	set_position(cell * GAME.TILE_SIZE)


#### VIRTUALS ####



#### LOGIC ####




#### INPUTS ####



#### SIGNAL RESPONSES ####
