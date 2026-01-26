---
name: implementation_ad
description: Automates ad integration with complete logic. Updates JSON configs and generates strict Kotlin code for AdsManager, AdRemoteConfig, and Activities.
---

# Implementation Ad Skill

Use this skill when the user provides ad IDs (Excel/Text) and requests integration.
**Requirement**: The agent MUST write the **complete logic** (Code) for the user, not just references.

## 1. Update Configuration (JSON)
1.  **Parse User Input**: Extract Key (e.g., `native_home`), Type (e.g., `native`), and Real ID.
2.  **Update `app/src/main/assets/ad_config.json`**: Set `id` to the **Real ID**.
3.  **Update `app/src/main/assets/ad_config_debug.json`**: Set `id` to the **Test ID** matching the type.
    *   **Banner**: `ca-app-pub-3940256099942544/6300978111`
    *   **Interstitial**: `ca-app-pub-3940256099942544/1033173712`
    *   **Native**: `ca-app-pub-3940256099942544/2247696110`
    *   **App Open**: `ca-app-pub-3940256099942544/3419835294`
    *   **Rewarded**: `ca-app-pub-3940256099942544/5224354917`

## 2. Implement Logic (Kotlin)

### Reference Files
The full implementation templates are available in the `implementation/` folder of this skill:
- `implementation/AdsManager.kt`
- `implementation/AdRemoteConfig.kt`
- `implementation/AdRemoteConfigExtensions.kt`

### Step A1: Update `AdRemoteConfig.kt`
Template: `implementation/AdRemoteConfig.kt`
Target: `app/src/main/java/com/infinity/videomaker/ads/AdRemoteConfig.kt`

For **EACH** new ad key, add a property getter in the class:
```kotlin
    val <key_name>: AdUnitConfig
        get() = getAdUnit("<key_name>")
```

### Step A2: Update/Create `AdRemoteConfigExtensions.kt`
Template: `implementation/AdRemoteConfigExtensions.kt`
Target: `app/src/main/java/com/infinity/videomaker/ads/AdRemoteConfigExtensions.kt`

If this file exists, add the extension property. If not, create it using the template.

```kotlin
val AdRemoteConfig.Companion.<key_name>: AdUnitConfig
    get() = getInstance().<key_name>
```
*Example:*
```kotlin
    val native_home_screen: AdUnitConfig
        get() = getAdUnit("native_home_screen")
```

### Step B: Update `AdsManager.kt`
Template: `implementation/AdsManager.kt`
Target: `app/src/main/java/com/infinity/videomaker/ads/AdsManager.kt`

For **EACH** new ad, add a variable and a load function.

**1. Variable Declaration:**
```kotlin
    var <variableName>Ad: ApNativeAd? = null // Change type based on ad (ApInterstitialAd, etc)
        private set
```

**2. Load Function (Native Example):**
```kotlin
    fun load<Name>Native(activity: Activity, layoutRes: Int) {
        val config = AdRemoteConfig.<key_name>
        loadNativeConfig(activity, config, layoutRes) { nativeAd ->
            <variableName>Ad = nativeAd
        }
    }
```

**3. Load Function (Interstitial Example):**
```kotlin
    fun load<Name>Inter(context: Context) {
        val config = AdRemoteConfig.<key_name>
        if (!config.isEnable || AppPurchase.getInstance().isPurchased(context)) {
            <variableName>Ad = null
            return
        }
        <variableName>Ad = NkhAd.getInstance().getInterstitialAds(context, config.id, object : AdCallback() {})
    }
```

### Step C: Update Activities
File: Target Activity (e.g., `HomeActivity.kt`)

**Note:** If the target Activity **does not exist yet**, SKIP this step. The infrastructure (`AdRemoteConfig`, `AdsManager`) is still prepared for future use.

**In `initViews` or `checkRemoteConfigResult`:**
```kotlin
    // Load the ad
    AdsManager.load<Name>Native(this, R.layout.<layout_name>)

    // Observe/Show (if using LiveData or direct view check)
    // Note: The load function in AdsManager is async but sets the variable.
    // Ensure you handle the display logic, e.g., using a preLoad callback or checking 'AdsManager.<variableName>Ad' later.
```

## 3. Verification
1.  Check JSON files for correct IDs.
2.  Check `AdRemoteConfig.kt` has the new key.
3.  Check `AdsManager.kt` has the new load function.
4.  Build project to verify strict typing.
