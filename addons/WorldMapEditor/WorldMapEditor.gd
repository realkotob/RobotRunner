tool
extends EditorPlugin
class_name WorldMapEditor

var last_lvl_node_selected : LevelNode = null
var current_lvl_node_selected : LevelNode = null

var bound_button : Button = null
var confirm_bind_button : Button = null
var abort_bind_button : Button = null

var bind_origin = LevelNode
var bind_dest_array : Array = []

var bind_mode : bool = false setget set_bind_mode

#### ACCESSORS ####

func is_class(value: String): return value == "WorldMapEditor" or .is_class(value)
func get_class() -> String: return "WorldMapEditor"

func set_bind_mode(value: bool):
	if value != bind_mode:
		bind_mode = value
		
		if bind_mode == false:
			bind_mode = false
			_unselect_all_level_nodes()
			bind_origin = null
			bind_dest_array = []

#### BUILT-IN ####



func _enter_tree() -> void:
	pass

func _exit_tree() -> void:
	destroy_every_buttons()

func handles(obj: Object) -> bool:
	if obj is LevelNode:
		generate_button("bound_button", "Create Bound")
	else:
		destroy_every_buttons()
	
	return obj is LevelNode


func edit(object: Object) -> void:
	last_lvl_node_selected = current_lvl_node_selected
	current_lvl_node_selected = object
	
	if bind_mode:
		current_lvl_node_selected.set_editor_select_state(LevelNode.EDITOR_SELECTED.BIND_DESTINATION)
		add_destination(current_lvl_node_selected)


func add_destination(level_node: LevelNode):
	if not level_node in bind_dest_array && level_node != bind_origin:
		bind_dest_array.append(level_node)
		generate_button("confirm_bind_button", "Confirm bind")
		generate_button("abort_bind_button", "Abort bind")


func destroy_every_buttons():
	destroy_button(bound_button)
	destroy_button(confirm_bind_button)
	destroy_button(abort_bind_button)


#### VIRTUALS ####



#### LOGIC ####

func generate_button(variable_name: String, button_text: String):
	if get(variable_name) == null:
		set(variable_name, Button.new())
		var button = get(variable_name)
		button.set_text(button_text)
		add_control_to_container(EditorPlugin.CONTAINER_CANVAS_EDITOR_MENU, button)
		var _err = button.connect("pressed", self, "_on_" + variable_name + "_pressed")


func destroy_button(button: Button):
	if button != null:
		button.queue_free()


func _unselect_all_level_nodes():
	if bind_origin != null:
		bind_origin.set_editor_select_state(LevelNode.EDITOR_SELECTED.UNSELECTED)
	
	for node in bind_dest_array:
		node.set_editor_select_state(LevelNode.EDITOR_SELECTED.UNSELECTED)

#### INPUTS ####



#### SIGNAL RESPONSES ####

func _on_bound_button_pressed():
	if !bind_mode:
		bind_mode = true
		print("Bind mode on")
		bind_origin = current_lvl_node_selected
		current_lvl_node_selected.set_editor_select_state(LevelNode.EDITOR_SELECTED.BIND_ORIGIN)


func _on_confirm_bind_button_pressed():
	print("Confirm bind")
	
	var output = "create bound from " + bind_origin.name + " to "
	for bind_dest in bind_dest_array:
		output += bind_dest.name + " "
		bind_origin.emit_signal("add_bind_query", bind_origin, bind_dest)
	
	print(output)
	
	set_bind_mode(false)


func _on_abort_bind_button_pressed():
	print("Abort bind")
	set_bind_mode(false)
