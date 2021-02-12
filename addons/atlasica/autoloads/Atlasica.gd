tool
extends Node

signal state_changed(state)

var ei:EditorInterface

const State = preload("res://addons/atlasica/state/State.gd")
const STATE_RES_PATH = "user://atlasica.tres"

const RESOURCE_PATH = "res://atlasica"

func _enter_tree():
	pass
	
func override_state(path_spritesheet_file, path_spritesheet_data):
	pass


var _state
func get_state()->State:
	if !_state:
		
		if ResourceLoader.exists(STATE_RES_PATH):
			_state = ResourceLoader.load(STATE_RES_PATH)
			if !_state:
				printerr("Atlasica: Could not load state and settings from %s, resetting to default" % STATE_RES_PATH)
				_reset_state()
		else:
			print("Atlasica: No settings found, creating new and saving to %s" % STATE_RES_PATH)
			_reset_state()
			
		_state.connect("state_changed", self, "_on_state_changed")
	return _state

func _save_state():
	if OK != ResourceSaver.save(STATE_RES_PATH, _state):
		printerr("Atlasica: Could not save state and settings to %s" % STATE_RES_PATH)
		
func _reset_state():
	_state = State.new()
	_save_state()

func _on_state_changed(): # redirect signal from resource
	var state = get_state()
	emit_signal("state_changed", state)
	_save_state()
	
func update_resources():
	var dir:Directory = Directory.new()
	
	# Create dir if not exists
	if !dir.dir_exists(RESOURCE_PATH):
		if dir.make_dir(RESOURCE_PATH) != OK:
			printerr("Atlasica: Could not create directory %s for texture resources!" % RESOURCE_PATH)
		ei.get_resource_filesystem().scan()
		
#	var list_names_prev = []
#	var list_names_new = []
#
#	# Collect previous sprites by iterating resources in folder
#	if dir.open(RESOURCE_PATH) == OK:
#		dir.list_dir_begin()
#		var file_name = dir.get_next()
#		while file_name != "":
#			if !dir.current_is_dir():
#				list_names_prev.append(file_name)
#			file_name = dir.get_next()
#	else:
#		printerr("Atlasica: Could not open directory %s to update texture resources!" % RESOURCE_PATH)
#
#	# Collect sprites as they should be after updating
#	var atlas_data = get_state().get_atlas_data()
#	for sprite_data in atlas_data:
#		list_names_new.append(sprite_data.name)
#	print("prev: ", list_names_prev)
#	print("new: ", list_names_new)
	
	var atlas_image = get_state().get_atlas_image()
	var atlas_data = get_state().get_atlas_data()
	
	for sprite_name in atlas_data.sprites.keys():
		var sprite_data = atlas_data.sprites[sprite_name]
		var resource = _create_sprite_resource(atlas_image, sprite_data)
		
		var path = RESOURCE_PATH + "/" + sprite_name + ".tres"
		if ResourceSaver.save(path, resource) != OK:
			printerr("Atlasica: Could not save sprite resource to %s" % path)
	
	

func _create_sprite_resource(atlas_image, sprite_data):
	var resource:AtlasTexture = AtlasTexture.new()
	resource.atlas = atlas_image
	resource.region = Rect2(sprite_data.x, sprite_data.y, sprite_data.w, sprite_data.h)
	return resource
