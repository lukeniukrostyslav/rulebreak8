extends "res://scripts/game.gd"

# Keep the original controller stable while switching runtime rendering.
func _ready() -> void:
    var fallback := preload("res://scripts/core/extended_localization.gd").new()
    add_child(fallback)
    challenge_view = ChallengeViewV2.new()
    super._ready()
