tool
extends Panel

var is_hovering = false
var is_dragging = false setget _set_is_dragging

onready var animator:AnimationPlayer = $AnimationPlayer

func init(item):
	self.rect_size = Vector2(item.w, item.h)
	self.rect_position = Vector2(item.x, item.y)
	
	$Label.text = item.name

func _ready():
	animator.play("idle")

func _on_ViewItemAtlas_gui_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if event.pressed:
			_set_is_dragging(true)
		else:
			_set_is_dragging(false)

func _set_is_dragging(v):
	if is_dragging != v:
		if v: _on_drag()
		else: _on_undrag()
	is_dragging = v

func _on_drag():
	pass
func _on_undrag():
	pass

func _on_ViewItemAtlas_mouse_entered():
	if !is_hovering:
		is_hovering = true
		animator.play("hover")

func _on_ViewItemAtlas_mouse_exited():
	if is_hovering:
		is_hovering = false
		animator.play("idle")
