package com.example.ios_playground

class AppUsageImplementation : AppUsageApi {

    override fun getPlatformVersion(callback: (Result<String?>) -> Unit) {
        // Android version (e.g., 14)
        callback(Result.success(android.os.Build.VERSION.RELEASE))
    }

    override fun getApps(callback: (Result<List<UsedApp>>) -> Unit) {
        val dummyApps = listOf(
            UsedApp("com.android.chrome", "Chrome", 120L),
            UsedApp("com.google.android.gm", "Gmail", 45L),
            UsedApp("com.google.android.apps.messaging", "Messages", 90L),
            UsedApp("com.google.android.apps.photos", "Photos", 30L),
            UsedApp("com.google.android.calendar", "Calendar", 15L),
            UsedApp("com.spotify.music", "Spotify", 180L),
            UsedApp("com.netflix.mediaclient", "Netflix", 240L),
            UsedApp("com.instagram.android", "Instagram", 95L),
            UsedApp("com.facebook.katana", "Facebook", 60L),
            UsedApp("com.twitter.android", "Twitter", 75L)
        )
        callback(Result.success(dummyApps))
    }

    override fun setAppTimeLimit(
        appId: String,
        minutesUsed: Long,
        callback: (Result<StateResult>) -> Unit
    ) {
        val appName = getAppName(appId)
        val result = StateResult(
            state = State.SUCCESS,
            message = "Time limit of $minutesUsed minutes set successfully for $appName"
        )
        callback(Result.success(result))
    }

    private fun getAppName(appId: String): String {
        return when (appId) {
            "com.android.chrome" -> "Chrome"
            "com.google.android.gm" -> "Gmail"
            "com.google.android.apps.messaging" -> "Messages"
            "com.google.android.apps.photos" -> "Photos"
            "com.google.android.calendar" -> "Calendar"
            "com.spotify.music" -> "Spotify"
            "com.netflix.mediaclient" -> "Netflix"
            "com.instagram.android" -> "Instagram"
            "com.facebook.katana" -> "Facebook"
            "com.twitter.android" -> "Twitter"
            else -> "Unknown App"
        }
    }
}