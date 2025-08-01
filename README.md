# Axolotl for WhatsApp

**Hello Friends,**

it has small Paws, Gill Tufts that stick out from its Head like Hair and grins seemingly without Ceasing: The Axolotl is a Mexican Tailed Amphibian that spends most of its Life in the Water and remains in the Larval Stage its entire Life, but nevertheless becomes Sexually Mature. The Name Axolotl comes from the Aztecs: &quot;Atl&quot; means Water and &quot;Xolotl&quot; is the Aztec God of Death, Lightning and Misfortune. When fleeing from other Gods, he is said to have disappeared into a Lake in the Form of an Aquatic Animal. Axolotl therefore means something like &quot;Water God&quot; or &quot;Water Monster&quot;. The last Specimens of its Species living in the Wild do so in Lake Xochimilco and several other small Lakes west of Mexico City. It has been considered endangered since 2006, with an extremely [high Risk of Extinction](https://www.iucnredlist.org/species/1095/53947343) in the Wild in the immediate Future.

<p align="center"><img src="https://macthemes.me/developer/Axolotl_Header.png" /></p>

## Table of Contents

1.	[Introduction](#1-introduction)
2.	[Running on Device](#2-running-on-device)
3.	[Building my own Version](#3-building-my-own-version)
4.	[Made for your iDevice](#4-made-for-your-idevice)
5.	[Last Words](#5-last-words)
6.	[Greetings](#6-greetings)

## 1. Introduction

On 5th May 2025, WhatsApp Support for iOS-Versions prior to 15.1 will end, which will primarily affect many jailbroken Devices running iOS 14 or earlier Versions. &quot;Axolotl for WhatsApp&quot; starts at this Point and tricks WhatsApp into believing it is running a different Version, which will be supported in the Future.

Since I'm using an iPhone 12 Pro with iOS 14.4, I was worried about the Date and looked at the Source of [fckzck's Tweak.xm](https://github.com/ifilipis/fckzck/blob/d2272c606f5059133734fc4a5cafee572658d79d/Tweak.xm#L32) and found out that it uses a fixed Version number of `2.25.14.7`. So this Code and [blockWAUpdates](https://github.com/0xkuj/blockWAUpdates) were the Basis for this Project, but just Copying is not an Option, so I decided to extend the Basic Functionality of both with some Additions, like&nbsp;…

- the Ability to set Version Numbers yourself,&nbsp;…
- support for rootful & rootless Jailbreaks,&nbsp;…
- themed Tint Colors in the Preferences&nbsp;…

…&nbsp;and an insanely cute Icon.

## 2. Running on Device

While supporting as many WhatsApp-Versions as possible, it just begs a logical Question: We can use the second-latest Version `2.25.1.80`&nbsp;(&nbsp;WA Business: `2.25.1.81`&nbsp;), so why not just use that One&nbsp;? During Development, I also tested some Builds from 2024, but using the second-latest officially available Version reduces the Effort to find Bugs. Aall you need to do is downgrade WhatsApp to the above Versions using AppStore++.

To **get Axolotl**, just add my Repo to your Package Manager: https://macthemes.me/ …

## 3. Building my own Version

All you need is [theos](https://github.com/theos/theos). You can easily build your own Version of Axolotl by running `make` or `gmake`&nbsp;(&nbsp;requires GNU Make to be installed&nbsp;) in the Folder where you put Axolotl's Code. Why I can't explain all of theos, please refer to the [Manual](https://theos.dev/docs/installation) for additional Help.

The most important Thing you need is **Patience**.

## 4. Made for your iDevice

As a Member of the&nbsp;- former&nbsp;- Forum of &quot;MacThemes&quot; I would like to offer Theme Designers a Possibility to customize the Settings of Axolotl according to your Wishes. Have a Look at `Theme.plist` in the following Bundle:

- **Rootful:** `/Library/PreferenceBundles/AxolotlPrefs.bundle`
- **Rootless:** `/var/jb/Library/PreferenceBundles/AxolotlPrefs.bundle`

If you want to use custom Colors, simply copy the `Theme.plist` into a new Folder named `com.macthemes.axolotlprefs` inside `Bundles` of your Theme.

Open the `Theme.plist`, expand the Dictionary-Key `AXTintColors`&nbsp;(&nbsp;if you're using something like [PlistEdit Pro](https://www.fatcatsoftware.com/plisteditpro/) or Xcode's Property List Editor&nbsp;) and have a Look at the Key-Value-Pairs&nbsp;…

| Key | Description | Default-Value |
| :-: | :---------: | :-----------: |
| AXApplyButton | Navigation Bar: Apply-Button | #44c054:1.0 |
| AXApplyNo | Popover for Apply-Button: The &quot;No&quot;-Button | #44c054:1.0 |
| AXApplyYes | Popover for Apply-Button: The &quot;Yes&quot;-Button | #c04454:1.0 |
| AXDebugSwitch | The &quot;Debug Logging&quot; Switch | #44c054:1.0 |
| AXEnableSwitch | The &quot;Enable Axolotl&quot; Switch | #44c054:1.0 |
| AXNavigationBar | Navigation Bar: Color of &quot;Preferences&quot; | #3fd163:1.0 |
| AXTwitterButton | Navigation Bar: Twitter-Button | #0098c0:1.0 |
| AXWebsiteButton | Navigation Bar: MacThemes-Button | #727373:1.0 |

Every Key is using a Hex-String as Color and a Float-Value ranging from Zero to One indicating the Alpha-Component of the Color. To convert your Color from RGB to a Hex-String, use [Google Color Chooser](https://g.co/kgs/aBRkTpR) or any Image Editor, such as [Adobe Photoshop](https://www.adobe.com/de/products/photoshop.html) or [Pixelmator](https://itunes.apple.com/de/app/pixelmator/id407963104?mt=12) from the Mac App Store. You can change the Colors, to match your Theme, like Suave7 does&nbsp;…

<p align="center"><img src="https://macthemes.me/developer/Axolotl_Theming.png" /></p>

Save the File and apply the new Colorization with your Theming Engine&nbsp;- iThemer&nbsp;(&nbsp;iOS 12&nbsp;) and NeonBoard&nbsp;(&nbsp;iOS 14&nbsp;) are known to work.

## 5. Last Words

This Project comes with no Warranty, neither express nor implied. If it blows up your Device, an Axolotl eats your Children, or causes you bodily Harm, all you'll get is a little Pity and maybe an Apology.

If you respect my Work, you can help me with a small Donation via [PayPal.me](https://www.paypal.com/donate/?hosted_button_id=F5EPEFSLDBHPQ) and please don't publish the Tweak on a other Repo&nbsp;😃&nbsp;…

## 6. Greetings

I would like to thank *B4dM4Xx* for testing the rootless Version and *NightwindDev* for his amazing Work describing so many Functions and Peculiarities of Objective-C. We need more People of these in the Community.

Thank you.