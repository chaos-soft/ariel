extends Label

@onready var panel: Panel = get_parent()
var timeout_tween: float = 0.2


func show_hide(text_: String) -> void:
    text = text_
    var tween = create_tween()
    tween.tween_property(panel, 'modulate', Color.WHITE, timeout_tween)
    tween.tween_property(panel, 'modulate', Color.TRANSPARENT, timeout_tween).set_delay(1)
