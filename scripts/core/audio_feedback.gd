class_name AudioFeedback
extends Node

const SAMPLE_RATE := 22050
const DEFAULT_VOLUME := 0.16

var player: AudioStreamPlayer
var generator: AudioStreamGenerator
var playback: AudioStreamGeneratorPlayback

func _ready() -> void:
    generator = AudioStreamGenerator.new()
    generator.mix_rate = SAMPLE_RATE
    generator.buffer_length = 0.18
    player = AudioStreamPlayer.new()
    player.stream = generator
    player.volume_db = linear_to_db(DEFAULT_VOLUME)
    add_child(player)
    player.play()
    playback = player.get_stream_playback() as AudioStreamGeneratorPlayback

func play_correct() -> void:
    _play_tone(740.0, 0.08, 0.12)
    get_tree().create_timer(0.055).timeout.connect(_play_second_correct_tone, CONNECT_ONE_SHOT)

func _play_second_correct_tone() -> void:
    _play_tone(988.0, 0.07, 0.09)

func play_wrong() -> void:
    _play_tone(220.0, 0.11, 0.10)

func _play_tone(frequency: float, duration: float, amplitude: float) -> void:
    _push_tone(frequency, duration, amplitude)

func _push_tone(frequency: float, duration: float, amplitude: float) -> void:
    if playback == null:
        return
    var requested_frames := maxi(1, int(SAMPLE_RATE * duration))
    var available_frames := playback.get_frames_available()
    var frame_count := mini(requested_frames, available_frames)
    if frame_count <= 0:
        return

    var frames := PackedVector2Array()
    frames.resize(frame_count)
    for i in frame_count:
        var t := float(i) / float(SAMPLE_RATE)
        var envelope := 1.0 - (float(i) / float(frame_count))
        var sample := sin(TAU * frequency * t) * amplitude * envelope
        frames[i] = Vector2(sample, sample)
    playback.push_buffer(frames)
