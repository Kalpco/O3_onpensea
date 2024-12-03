-dontwarn proguard.annotation.Keep
-dontwarn proguard.annotation.KeepClassMembers
# Razorpay and related annotations
-keep class com.razorpay.** { *; }
-keep class proguard.annotation.Keep { *; }
-keep class proguard.annotation.KeepClassMembers { *; }
-keepattributes *Annotation*
