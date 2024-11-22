extends Label

@onready var panel: Panel = get_parent()
var tween_timeout: float = 0.2


func show_hide(text_: String) -> void:
    text = text_
    var tween = create_tween()
    tween.tween_property(panel, 'modulate', Color.WHITE, tween_timeout)
    tween.tween_property(panel, 'modulate', Color.TRANSPARENT, tween_timeout).set_delay(1)
