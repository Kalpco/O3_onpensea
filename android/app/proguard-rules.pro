-dontwarn proguard.annotation.Keep
-dontwarn proguard.annotation.KeepClassMembers

# Razorpay
-keep class com.razorpay.** { *; }
-dontwarn com.razorpay.**

# Razorpay-related annotations
-keep class proguard.annotation.Keep { *; }
-keep class proguard.annotation.KeepClassMembers { *; }
-keepattributes *Annotation*

# ✅ Google Pay classes used via Razorpay
-keep class com.google.android.apps.nbu.paisa.inapp.client.api.** { *; }
-dontwarn com.google.android.apps.nbu.paisa.inapp.client.api.**
