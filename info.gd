extends Label

@onready var panel: Panel = self.get_parent()


func show_hide(text_: String) -> void:
    self.text = text_
    var tween = create_tween()
    tween.tween_property(panel, 'modulate', Color.WHITE, 0.2)
    tween.tween_property(panel, 'modulate', Color.TRANSPARENT, 0.2).set_delay(1)
