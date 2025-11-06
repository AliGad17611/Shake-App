package com.example.shake_quote_app
import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import kotlin.math.sqrt

class MainActivity : FlutterActivity(), SensorEventListener {
    private val EVENT_CHANNEL = "shake_event"
    private val METHOD_CHANNEL = "shake_control"
    private var eventSink: EventChannel.EventSink? = null
    private lateinit var sensorManager: SensorManager
    private var lastTime: Long = 0
    private var shakeThreshold = 12f
    private var isListening = false

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        EventChannel(flutterEngine.dartExecutor.binaryMessenger, EVENT_CHANNEL).setStreamHandler(
            object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    eventSink = events
                    if (isListening) {
                        startListening()
                    }
                }

                override fun onCancel(arguments: Any?) {
                    stopListening()
                }
            }
        )

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, METHOD_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "startListening" -> {
                    if (!isListening) {
                        isListening = true
                        startListening()
                        result.success("Listening started")
                    } else {
                        result.success("Already listening")
                    }
                }
                "stopListening" -> {
                    if (isListening) {
                        isListening = false
                        stopListening()
                        result.success("Listening stopped")
                    } else {
                        result.success("Already stopped")
                    }
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun startListening() {
        sensorManager = getSystemService(Context.SENSOR_SERVICE) as SensorManager
        val accelerometer = sensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER)
        sensorManager.registerListener(this, accelerometer, SensorManager.SENSOR_DELAY_NORMAL)
    }

    private fun stopListening() {
        sensorManager.unregisterListener(this)
    }

    override fun onSensorChanged(event: SensorEvent?) {
        event?.let {
            val x = it.values[0]
            val y = it.values[1]
            val z = it.values[2]

            val acceleration = sqrt((x * x + y * y + z * z).toDouble()).toFloat()
            val currentTime = System.currentTimeMillis()

            if (acceleration > shakeThreshold && currentTime - lastTime > 1000) {
                lastTime = currentTime
                eventSink?.success("SHAKE")
            }
        }
    }

    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {}
}