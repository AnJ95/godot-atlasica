tool
extends Resource

signal state_changed()

export(String) var path_zip = null setget _set_path_zip

export(String) var path_spritesheet_image = null setget _set_path_spritesheet_image
export(String) var path_spritesheet_data = null setget _set_path_spritesheet_data

func is_valid():
	return has_valid_spritesheet_image() and has_valid_spritesheet_data()

func has_valid_zip_path():
	return Directory.new().file_exists(path_zip)
func has_valid_zip(get_result=false):
	var f:File = File.new()
	
	# Instance the gdunzip script
	var gdunzip = load("res://addons/atlasica/scripts/gdunzip.gd").new()

	# Check if zip can be opened and if files are present
	if !gdunzip.load(path_zip):
		return null if get_result else false
	if !gdunzip.files.has("layout.json"):
		return null if get_result else false
	if !gdunzip.files.has("spritesheet.png"):
		return null if get_result else false
	
	return gdunzip if get_result else true

func has_configured_spritesheet_image_path():
	return path_spritesheet_image != null
func has_valid_spritesheet_image_path():
	return has_configured_spritesheet_image_path() and Directory.new().file_exists(path_spritesheet_image)
func has_valid_spritesheet_image(get_result=false):
	if !has_configured_spritesheet_image_path() or !ResourceLoader.exists(path_spritesheet_image, "Image"): return false	
	var result = ResourceLoader.load(path_spritesheet_image, "Image")
	
	# return actual result if required by flag
	if get_result:	return result
	else:			return result != null
	
func has_configured_spritesheet_data_path():
	return path_spritesheet_data != null
func has_valid_spritesheet_data_path():
	return has_configured_spritesheet_data_path() and Directory.new().file_exists(path_spritesheet_data)
func has_valid_spritesheet_data(get_result=false):
	if !has_valid_spritesheet_data_path(): return false
		
	# Load file contents
	var file = File.new()
	file.open(path_spritesheet_data, file.READ)
	var text = file.get_as_text()
	file.close()
	
	# Check if parsing goes well
	var result = JSON.parse(text)
	if result.error != OK:
		printerr("Atlasica: Could load parse atlas data json!")
	
	# Return json if required by flag
	if get_result:	return result.result
	else:			return result.error == OK


func get_atlas_image():
	return has_valid_spritesheet_image(true)
	
func get_atlas_data():
	return has_valid_spritesheet_data(true)

func _set_path_spritesheet_image(v):
	path_spritesheet_image = v
	emit_signal("state_changed")

func _set_path_spritesheet_data(v):
	path_spritesheet_data = v
	emit_signal("state_changed")

func _set_path_zip(v):
	path_zip = v
	emit_signal("state_changed")
