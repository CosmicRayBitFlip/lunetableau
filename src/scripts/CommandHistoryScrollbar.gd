extends ScrollContainer

func on_history_changed():
	call_deferred("scroll_to_bottom")

func scroll_to_bottom():
	yield(get_tree().create_timer(0.01), "timeout")
	scroll_vertical = get_v_scrollbar().max_value
