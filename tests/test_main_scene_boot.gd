extends SceneTree

var main_instance: Node

func _init() -> void:
    call_deferred("_boot_main_scene")

func _boot_main_scene() -> void:
    var packed := load("res://main.tscn") as PackedScene
    if packed == null:
        push_error("RULEBREAK main scene failed to load")
        quit(1)
        return

    main_instance = packed.instantiate()
    if main_instance == null:
        push_error("RULEBREAK main scene failed to instantiate")
        quit(1)
        return

    root.add_child(main_instance)
    await process_frame
    await process_frame

    if not is_instance_valid(main_instance):
        push_error("RULEBREAK main scene was destroyed during boot")
        quit(1)
        return

    print("RULEBREAK main scene boot: PASS — main.tscn loads and game.gd instantiates successfully")
    main_instance.queue_free()
    quit(0)
