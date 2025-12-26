extends Control

signal guard_guess_selected(value)

func _on_select_pressed() -> void:
	var node = get_node("Panel/VBoxContainer/OptionButton")
	#-1 for enum support
	emit_signal("guard_guess_selected",node.get_item_id(node.selected) - 1)
	pass # Replace with function body.

#Enable select only after selecting the card
func _on_option_button_item_selected(index: int) -> void:
	$Panel/VBoxContainer/Select.disabled=false
	pass # Replace with function body.
