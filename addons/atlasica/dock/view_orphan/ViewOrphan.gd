tool
extends VBoxContainer

signal item_hovered(item_name, item)
signal item_unhovered(item_name, item)

signal orphans_exist()
signal orphans_do_not_exist()

const ViewItem = preload("res://addons/atlasica/dock/view_orphan/ViewItemOrphan.tscn")
onready var orphanRoot:Control = $OrphanRoot

func update_orphans(orphan_names:Array):
	for prev_viewItem in orphanRoot.get_children():
		prev_viewItem.queue_free()
	
	for orphan_name in orphan_names:
		var item = ViewItem.instance()
		item.init(self, orphan_name, null)
		orphanRoot.add_child(item)
	
	visible = !orphan_names.empty()
	
	emit_signal("orphans_do_not_exist" if orphan_names.empty() else "orphans_exist")

func item_removed():
	if orphanRoot.get_children().empty():
		visible = false
		emit_signal("orphans_do_not_exist")
