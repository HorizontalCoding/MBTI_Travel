package com.mycompany.mbtitravel

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.mycompany.mbtitravel/api_key"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "get_Tour_Api_Key" -> result.success(BuildConfig.TOUR_API_KEY)
                "get_Kakao_Api_Key" -> result.success(BuildConfig.KAKAO_API_KEY)
                "get_Tour_Encoding_key" -> result.success(BuildConfig.TOUR_API_ENCODING_KEY)

                "GET_PUBLIC_PROD_URL" -> result.success(BuildConfig.PUBLIC_PROD_URL)
                "GET_LOCAL_DEV_URL" -> result.success(BuildConfig.LOCAL_DEV_URL)
                else -> result.notImplemented()
            }
        }
    }
}
