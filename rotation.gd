extends MeshInstance3D

var object: MeshInstance3D = null
var timeout_tween: float = 10
var tween: Tween = null


func _init(instance):
    object = instance
    loop()


func get_rotationX() -> float:
    return randf_range(-5, 5)


func get_rotationY() -> float:
    return randf_range(85, 95)


func loop() -> void:
    while not object.get_tree().paused:
        tween = object.create_tween().set_trans(Tween.TRANS_QUAD)
        tween.tween_property(
            object,
            'rotation_degrees',
            Vector3(get_rotationX(), get_rotationY(), 0),
            timeout_tween,
        )
        await object.get_tree().create_timer(timeout_tween).timeout
