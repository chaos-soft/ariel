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


func loop() -> void:
    tween = slider.create_tween().set_trans(Tween.TRANS_QUAD)
    tween.tween_property(
        slider,
        'rotation_degrees',
        get_random_rotation_degrees(),
        tween_timeout,
    )
    tween.connect('finished', loop)


func on_image_changed(_path: String, _file: String, image: Image) -> void:
    kill_tween()
    var ratio = snappedf(float(image.get_width()) / image.get_height(), 0.1)
    if ratio >= 0.7 and ratio <= 3.0:
        await reset_rotation_degrees(get_random_rotation_degrees())
        loop()
    # Длинные картинки.
    else:
        reset_rotation_degrees(default_rotation_degrees)


func reset_rotation_degrees(value: Vector3) -> void:
    tween = slider.create_tween().set_trans(Tween.TRANS_QUAD)
    tween.tween_property(slider, 'rotation_degrees', value, reset_timeout)
    await tween.finished
