extends MeshInstance3D

var default_rotation_degrees: Vector3 = Vector3(0, 90, 0)
var reset_timeout: float = 0.6
var slider: MeshInstance3D = null
var tween: Tween = null
var tween_timeout: float = 10


func _init(instance):
    slider = instance
    slider.image_changed.connect(on_image_changed)


func get_random_rotation_degrees() -> Vector3:
    return Vector3(randf_range(-5, 5), randf_range(85, 95), 0)


func kill_tween() -> void:
    if tween:
        tween.kill()
    # Для паузы.
    reset_rotation_degrees(default_rotation_degrees)


func loop() -> void:
    tween = slider.create_tween().set_trans(Tween.TRANS_QUAD)
    tween.tween_property(
        slider,
        'rotation_degrees',
        get_random_rotation_degrees(),
        tween_timeout,
    )
    tween.connect('finished', loop)


func on_image_changed(_path: String, _file: String, _image: Image) -> void:
    kill_tween()
    reset_rotation_degrees(get_random_rotation_degrees())
    loop()


func reset_rotation_degrees(value: Vector3) -> void:
    tween = slider.create_tween().set_trans(Tween.TRANS_QUAD)
    tween.tween_property(slider, 'rotation_degrees', value, reset_timeout)
