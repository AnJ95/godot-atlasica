tool
extends EditorPlugin

const BASE_PATH = "res://addons/atlasica/"
const AUTOLOADS_PATH = BASE_PATH + "autoloads/"
const CUSTOM_TYPES_PATH = BASE_PATH + "components/"

const Dock = preload("res://addons/atlasica/dock/Dock.tscn")
var dock

var icon:Texture = preload("res://addons/atlasica/assets/logo/logo16.png")

const autoloads = {
	"Atlasica": AUTOLOADS_PATH + "Atlasica.gd",
}

var custom_types = {}


func _enter_tree():
	
	# Add singleton and wait
	for key in autoloads.keys():
		add_autoload_singleton(key, autoloads[key])
	yield(get_tree(), "idle_frame")
	
	# Add custom types
	for key in custom_types.keys():
		var type = custom_types[key]
		if type:
			add_custom_type(key, type.base, type.script, icon)

	# Add the loaded scene to the docks.
	dock = create_dock()
	add_control_to_bottom_panel(dock, "Atlasica")
	
	# Emit signal to initially update all ui
	Atlasica.call_deferred("emit_signal", "state_changed", Atlasica.get_state())
	

func create_dock():
	var dock = Dock.instance()
	dock.plugin = self
	dock.ei = get_editor_interface()
	Atlasica.connect("state_changed", dock, "_on_state_changed")
	return dock


func _exit_tree():
	for key in autoloads.keys():
		remove_autoload_singleton(key)
	for key in custom_types.keys():
		remove_custom_type(key)

	if dock:
		remove_control_from_bottom_panel(dock)
		dock.queue_free()
		dock = null
