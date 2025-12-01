extends Label

@onready var panel: Panel = get_parent()
var tween: Tween = null
var tween_timeout: float = 0.2


func kill_tween() -> void:
    if tween:
        tween.kill()


func show_hide(text_: String) -> void:
    kill_tween()
    text = text_
    tween = create_tween()
    tween.tween_property(panel, 'modulate', Color.WHITE, tween_timeout)
    tween.tween_property(panel, 'modulate', Color.TRANSPARENT, tween_timeout).set_delay(3)
