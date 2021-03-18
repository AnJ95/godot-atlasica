tool
extends Resource

signal state_changed()

export(String) var path_zip = null setget _set_path_zip
export(bool) var autoupdate = false setget _set_autoupdate

const FILE_LAYOUT = "layout.json"
const FILE_ATLAS = "spritesheet.png"

var _atlas_image
var _atlas_layout
var _loaded_gdunzip

func has_configured_zip_path():
	return path_zip != null
func has_valid_zip_path():
	return Directory.new().file_exists(path_zip)
func has_valid_zip(get_result=false):
	var f:File = File.new()
	
	# Instance the gdunzip script
	_loaded_gdunzip = load("res://addons/atlasica/scripts/gdunzip.gd").new()

	# Check if zip can be opened and if files are present
	if !_loaded_gdunzip.load(path_zip):
		printerr("Atlasica: Could not uncompress zip file")
		return null if get_result else false
	if !_loaded_gdunzip.files.has(FILE_LAYOUT):
		printerr("Atlasica: Could not find %s in zip file" % FILE_LAYOUT)
		return null if get_result else false
	if !_loaded_gdunzip.files.has(FILE_ATLAS):
		printerr("Atlasica: Could not find %s in zip file" % FILE_ATLAS)
		return null if get_result else false
	
	return _loaded_gdunzip if get_result else true

func _copy_atlas_image():
	if _uncompress_and_save(FILE_ATLAS):
		_atlas_image = load(Atlasica.RESOURCE_RAW_PATH + "/" + FILE_ATLAS)
		Atlasica.ei.get_resource_filesystem().update_file(Atlasica.RESOURCE_RAW_PATH + "/" + FILE_ATLAS)
	return _atlas_image
func _copy_atlas_layout():
	if _uncompress_and_save(FILE_LAYOUT):
		_atlas_layout = _parse_json(Atlasica.RESOURCE_RAW_PATH + "/" + FILE_LAYOUT)
	return _atlas_layout

func _parse_json(path):
	# open File as string
	var file = File.new()
	file.open(path, file.READ)
	var text = file.get_as_text()
	file.close()
	
	# Check if parsing goes well
	var result = JSON.parse(text)
	if result.error != OK:
		printerr("Atlasica: Could load parse atlas data json!")
		return null
	
	return result.result

func get_atlas_image():
	if !_atlas_image:
		var path = Atlasica.RESOURCE_RAW_PATH + "/" + FILE_ATLAS
		if Directory.new().file_exists(path):
			_atlas_image = load(path)
	return _atlas_image
func get_atlas_layout():
	if !_atlas_layout:
		var path = Atlasica.RESOURCE_RAW_PATH + "/" + FILE_LAYOUT
		if Directory.new().file_exists(path):
			_atlas_layout = _parse_json(path)
	return _atlas_layout

func _uncompress_and_save(file_name):
	if !_loaded_gdunzip:
		printerr("Atlasica: Tried getting atlas data before uncompressing zip file. Try pressing the update button in the settings tab!")
		return false
		
	Atlasica._ensure_resource_directories()
	var result = _loaded_gdunzip.uncompress(file_name)
	
	if !result:
		printerr("Atlasica: Could not uncompress %s/%s. Try re-exporting the zip from the SpriteBuilder!" % [path_zip, file_name])
		return false
	
	var f:File = File.new()
	f.open(Atlasica.RESOURCE_RAW_PATH + "/" + file_name, f.WRITE)
	f.store_buffer(result)
	f.close()
	return true

func _set_autoupdate(v):
	autoupdate = v
	emit_signal("state_changed")
func _set_path_zip(v):
	path_zip = v
	_loaded_gdunzip = null
	_atlas_image = null
	_atlas_layout = null
	emit_signal("state_changed")
