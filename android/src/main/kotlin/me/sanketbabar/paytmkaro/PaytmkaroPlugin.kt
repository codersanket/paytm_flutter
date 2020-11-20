package me.sanketbabar.paytmkaro


import android.app.Activity
import android.content.Context
import android.content.Intent
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.PluginRegistry.Registrar
import me.sanketbabar.paytmkaro.AllInOneSDKPlugin


/** PaytmKaroPlugin */
class PaytmkaroPlugin:FlutterPlugin, MethodCallHandler, ActivityAware, PluginRegistry.ActivityResultListener {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This loc
  // al reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var plugin : AllInOneSDKPlugin

  private lateinit var context: Context
  lateinit var activity: Activity


  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    context = flutterPluginBinding.applicationContext
    channel = MethodChannel(flutterPluginBinding.flutterEngine.dartExecutor, "WAP")
    channel.setMethodCallHandler(this)
  }

  fun registerWith(registrar: Registrar) {
    activity = registrar.activity()
    val channel = MethodChannel(registrar.messenger(), "Wap")
    val paytmPlugin = PaytmkaroPlugin()
    channel.setMethodCallHandler(paytmPlugin)
    registrar.addActivityResultListener(paytmPlugin)
  }




  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    if(call.method.equals("startTransaction"))
    {
      plugin= AllInOneSDKPlugin(activity, call, result)
    }else{
      result.notImplemented()

    }
  }


  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null);
  }


  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    activity = binding.activity;
    binding.addActivityResultListener(this);
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity;
    binding.addActivityResultListener(this);

  }

  override fun onDetachedFromActivity() {

  }

  override fun onDetachedFromActivityForConfigChanges() {

  }

  override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
    plugin.onActivityResult(requestCode,resultCode,data)
    return  true
  }

}







