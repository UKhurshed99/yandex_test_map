package com.example.yandex_map_test

import android.app.Application

import com.yandex.mapkit.MapKitFactory

class MainApplication: Application() {
    override fun onCreate() {
        super.onCreate()
        MapKitFactory.setLocale("ru_RU") // Your preferred language. Not required, defaults to system language
        MapKitFactory.setApiKey("41c142ba-42f3-4ffc-8231-7451a35c6355") // Your generated API key
    }
}