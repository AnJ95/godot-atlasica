tool
extends Node

signal resources_updated()
signal state_changed(state)

const State = preload("res://addons/atlasica/state/State.gd")
const STATE_RES_PATH = "user://atlasica.tres"

const RESOURCE_PATH = "res://atlasica"
const RESOURCE_RAW_PATH = "res://atlasica/raw"

var ei:EditorInterface

var _orphaned_resources = []
var _state
var _sprites = {}

func get_state()->State:
	# Singleton; if it does not exist, try loading from user://atlasica.tres, otherwise create new
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
	emit_signal("state_changed", get_state())
	_save_state()

func _ensure_resource_directories():
	var dir:Directory = Directory.new()
	# Create dir if not exists
	if !dir.dir_exists(RESOURCE_PATH):
		if dir.make_dir(RESOURCE_PATH) != OK:
			printerr("Atlasica: Could not create directory %s for texture resources!" % RESOURCE_PATH)
			return
	if !dir.dir_exists(RESOURCE_RAW_PATH):
		if dir.make_dir(RESOURCE_RAW_PATH) != OK:
			printerr("Atlasica: Could not create directory %s for raw spritesheet and json!" % RESOURCE_RAW_PATH)
			return
			
	ei.get_resource_filesystem().scan()

func update_resources():
	_ensure_resource_directories()
	var file_names_prev = []

	# Collect previous sprites by iterating resources in folder
	var dir:Directory = Directory.new()
	if dir.open(RESOURCE_PATH) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if !dir.current_is_dir():
				file_names_prev.append(file_name)
			file_name = dir.get_next()
	else:
		printerr("Atlasica: Could not open directory %s to check for previously existing resources!" % RESOURCE_PATH)
	
	var atlas_image = get_state()._copy_atlas_image()
	var atlas_layout = get_state()._copy_atlas_layout()
	
	for sprite_name in atlas_layout.sprites.keys():
		var sprite_data = atlas_layout.sprites[sprite_name]
		var resource = _create_sprite_resource(atlas_image, sprite_data)
		
		var path = _get_resource_path(sprite_name)
		
		# Check if resource existed earlier
		var previously_existed = ResourceLoader.exists(path, "Image")
		
		# If it does: save import settings flags
		if previously_existed:
			resource.flags = get_sprite(sprite_name).flags
		
		# Also erase this from list of previously existing files
		file_names_prev.erase(sprite_name + ".tres")
		
		# Try to save new resource
		if ResourceSaver.save(path, resource) != OK:
			printerr("Atlasica: Could not save sprite resource to %s" % path)
		
		# Update resource if it previously existed
		if previously_existed:
			Atlasica.ei.get_resource_filesystem().update_file(path)
	# Clear cache
	_sprites = {}
	
	# Update list of orphaned resources
	_orphaned_resources = []
	for orphan_name in file_names_prev:
		if orphan_name.ends_with(".tres"):
			_orphaned_resources.append(orphan_name.rstrip(".tres"))
			
	emit_signal("resources_updated")
	
func get_sprite(sprite_name):
	if !_sprites.has(sprite_name):
		var path = _get_resource_path(sprite_name)
		if !Directory.new().file_exists(path):
			printerr("Atlasica: Tried getting sprite %s but there is no resource at %s" % [sprite_name, path])
			return null
		_sprites[sprite_name] = load(path)
	return _sprites[sprite_name]

func get_layout(sprite_name):
	var atlas_layout = get_state().get_atlas_layout()
	if atlas_layout == null or !atlas_layout.sprites.has(sprite_name):
		printerr("Atlasica: Tried getting layout from sprite %s but it does not seem to exist" % [sprite_name])
		return null
	return atlas_layout.sprites[sprite_name]

func get_metadata(sprite_name):
	var atlas_layout = get_state().get_atlas_layout()
	if atlas_layout == null or !atlas_layout.sprites.has(sprite_name):
		printerr("Atlasica: Tried getting metadata from sprite %s but it does not seem to exist" % [sprite_name])
		return null
	return atlas_layout.sprites[sprite_name].metadata
		
func _get_resource_path(sprite_name)->String:
	return RESOURCE_PATH + "/" + sprite_name + ".tres"

func _create_sprite_resource(atlas_image, sprite_data)->AtlasTexture:
	var resource:AtlasTexture = AtlasTexture.new()
	resource.atlas = atlas_image.duplicate()
	resource.region = Rect2(sprite_data.x, sprite_data.y, sprite_data.w, sprite_data.h)
	return resource
