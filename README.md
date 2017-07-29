
THIS FOR IS FOR USE THE P4wnP1 WITH THE C.H.I.P FROM NEXTTHING SO DONT TRY IT ON PI ZERO/W

all start with my issue here https://github.com/mame82/P4wnP1/issues/20

All credit to ↓

P4wnP1 by MaMe82
================

P4wnP1 is a highly customizable USB attack platform, based on a low cost Raspberry Pi Zero or Raspberry Pi Zero W (required for HID backdoor).

TL;TR
-----

There isn't a short summary of this README. If you want to handle this nice tool, I'm afraid you have to read this.

The most important sections:
- HID covert channel frontdoor
- HID covert channel backdoor (**this is the new main feature**)
- Getting started section

If you are interested in which vendor was prone to Rob ‘MUBIX’ Fuller's “Snagging creds from locked machines”, see:
- Section: Snagging creds from locked machines after MS16-112 (or [here](http://www.oracle.com/technetwork/security-advisory/cpujul2017-3236622.html))



Introduction
============

Since the initial release in February 2017, P4wnP1 has come along way. 
Today advanced features are merged back into the master branch, among others:
-   the **HID covert channel backdoor** (Get remote shell access on air gapped Windows targets tunneled only through HID devices, relayed to a WiFi hotspot with SSH access with a Pi Zero W. The target doesn't see a network adapter, serial or any other communication device.)
-   the **HID covert channel frontdoor** (Get access to a python shell on P4wnP1 from a restricted Windows host, tunneled through a raw HID device with low footprint. The target doesn't see a network adapter, serial or any other communication device.)
-	refined USB, **modular USB setup**

P4wnP1 Features
===============

-	**WiFi Hotspot** for SSH access (Pi Zero W only)
-   the USB device features work in **every possible combination** with Windows **Plug and Play** support (class drivers)
-   Support for device types
	- **HID covert channel communication device** (see sections 'HID covert channel frontdoor' and 'HID covert channel backdoor')
    - **HID Keyboard**
    - **USB Mass storage** (currently only in demo setup with 128 Megabyte drive)
    - **RNDIS** (Windows Networking)
    - **CDC ECM** (MacOS / Linux Networking)
-	Raspberry Pi **LED sate feedback** with a simple bash command (`led_blink`)
-   customizeable **bash based payload scripts** (see `payloads/` subfolder for examples example)
-   includes **Responder** and a precompiled **John the Ripper Jumbo** version
-   **Auto attack:** P4wnP1 automatically boots to standard shell if an OTG adapter is attached, the current payload only runs if P4wnP1 is connected as USB device to a target (without USB OTG adapter)
	

Advanced HID keyboard features
------------------------------

-	Keyboad payloads could be **trigerred by targets main keyboard LEDs** (NUMLOCK, CAPSLOCK and SCROLLLOCK)
-   **dynamic payload branching** based on LED triggers
-   Supports **DuckyScript** (see hid_keyboard2.txt payload for an advanced example)
-   Supports **raw ASCII Output via HID Keyboard** (could be used to print out character based files via keyboard, like `cat /var/log syslog | outhid`)
-   **Multi Keyboard language layout support** (no need to worry about target language when using HID commands)
-   output starts when target keyboard driver is loaded (no need for manual delays, `onKeyboardUp` callback could be used in payloads)


Advanced network features
-------------------------

-   fake **RNDIS network interface speed up to 20GB/s** to get the lowest metric and win every fight for the dominating 'default gateway' entry in routing tables, while carrying out network attacks (patch could be found [here](https://github.com/mame82/ratepatch/commits/master) and the readme [here](https://github.com/mame82/ratepatch/blob/master/README.md))
-   **automatic link detection** and interface switching, if a payload enables both, RNDIS and ECM network
-   SSH server is running by default, so P4wnP1 could be connected on 172.16.0.1 (as long as the payload enables RNDIS, CDC ECM or both) or on 172.24.0.1 via WiFi


Advanced payload features
-------------------------

-   bash **payloads based on callbacks** (see `template.txt` payload for details)
    - **onNetworkUp** (when target host gets network link active)
	- **onTargetGotIP** (if the target received an IP, the IP could be accesed from the payload script)
	- **onKeyboardUp** (when keyboard driver installation on target has finished and keyboard is usable)
	- **onLogin** (when a user logs in to P4wnP1 via SSH)
- configuration could be done globally (`setup.cfg`) or overwritten per payload (if the same parameter is defined in the payload script)
- settings include: 
    - USB config (vendor ID, product ID, **device types to enable** ...)
    - WiFi config (access point name, password ...)
	- HID keyboard config (**target keyboard language** etc.)
	- Network and DHCP config
	- **payload selection**


HID covert channel frontdoor
============================

Video demo
----------

[![P4wnP1 HID demo youtube](https://img.youtube.com/vi/MI8DFlKLHBk/0.jpg)](https://www.youtube.com/watch?v=MI8DFlKLHBk&yt:cc=on)

HID frontdoor features
----------------------
-    Plug and Play install of HID device on Windows (tested on Windows 7 and Windows 10)
-    Covert channel based on a raw HID device
-    pure **in memory PowerShell payload** - nothing is written to disk
-    synchronous data transfer with about 32KBytes/s (fast enough for shells and small file transfers)
-    custom protocol stack to handle HID communication and deal with HID data fragmentation
-    HID based file transfer from P4wnP1 to target memory
-    **Stage 0:** P4wnP1 sits and waits, till the attacker triggers the payload stage 1 (frequently pressing NUMLOCK)
-    **Stage 1:** payload with "user space driver" for HID covert channel communication protocols is **typed out to the target via USB keyboard**
-    **Stage 2:** Communications switches to HID channel and gives access to a custom shell on P4wnP1. This could be used to upload and run PowerShell scripts, which are hosted on P4wnP1, directly into memory of the PowerShell process running on the target. This happens without touching disc or using network communications, at any time.


HID covert channel backdoor (Pi Zero W only)
============================================

Video demo
----------

[![P4wnP1 HID demo youtube](https://img.youtube.com/vi/Pft7voW5ui8/0.jpg)](https://www.youtube.com/watch?v=Pft7voW5ui8)

The video is produced by @Seytonic, you should check out his youtube channel with hacking related tutorials and various projects, if you're interested in more stuff like this (link in credits).

**@Seytonic** thanks for the great tutorial

HID backdoor features
----------------------
- Payload to bridge an Airgap target, by relaying a shell over raw HID and provide it from P4wnP1 via WiFi
- Plug and Play install of HID device on Windows (tested on Windows 7 and Windows 10)
- Covert channel based on raw HID
- pure **in memory, multi stage payload** - nothing is written to disk, small footprint (compared to typical PowerShell IOCs)
- RAT like control server with custom shell:
    - Auto completition for core commands
	- Send keystrokes on demand
	- Excute DuckyScripts (menu driven)
	- Trigger remote backdoor to bring up HID covert channel
	- creation of **multiple** remote processes (only with covert channel connection)
	- console interaction with managed remote processes (only with covert channel connection)
	- auto kill of remote payload on disconnect
	- `shell` command to  create remote shell (only with covert channel connection)
	- server could be accessed with SSH via WiFi when the `hid_backdoor.txt` payload is running

HID backdoor attack chain and usage
-----------------------------------

### 1. Preparation

- Choose the `hid_backdoor.txt` payload in `setup.cfg` (using the interactive USB OTG mode or one of the payloads with SSH network access, like `network_only.txt`)
- Attach P4wnp1 to the target host (Windows 7 to 10)

### 2. Access the P4wnP1 backdoor shell

- During boot up, P4wnP1 opens a wireless network called `P4wnP1` (password: `MaMe82-P4wnP1`)
- Connect to the network and SSH in with `pi@172.24.0.1`
- If everything went fine, you should be greeted by the interactive P4wnP1 backdoor shell (If not, it is likely that the target hasn't finished loading the USB keyboard drivers). The SSH password is the password of the user `pi`, which is `raspberry` in the default configuration.

### 3. Ad-Hoc keyboard attacks from P4wnP1 backdoor shell (without using the covert channel), could be done from here:

- Entering `help` shows available commands
- Use the `SetKeyboardLayout` to set the keyboard layout according to your targets language. **This step is important and should always be taken first, otherwise most keyboard based attacks fail.** 
- to print the current keyboard layout use `GetKeyboardLayout`. The default keyboard language for the P4wnP1 backdoor shell could be changed in `hidtools/backdoor/config.txt`
- use the `SendKeys` command followed by an ASCII key sequence to send keystrokes to the target
- As you will notice, the `SendKeys` command is somehow restricted, no control keys could be sent, even a RETURN is problematic. So for more complex key sequences the `FireDuckyScript` command comes to help.
- `FireDuckyScript` accepts the name of a script residing in the `DuckyScript/` folder. The folder is prefilled with some demo scripts. If you omit the script name behind the `FireDuckyScript` command, you will be presented with a menue to choose a script. If you wonder why one would write a DuckyScript sending an `<ALT> + <F4>` only, you're thinking in the old world of RubberDucky. With P4wnP1 and its capbility to run DuckyScripts dynamically, such short scripts come in handy. If you don't know what I'm talking about run the `P4wnP1_youtube.duck` script and you'll know where scripts like `AltF4_Return.duck` are needed ;-)

So that's all

... no just joking. Four month without commits wouldn't have been passed if there isn't more. Up till here, there was no covert channel communication, right?!

### 4. Fire stage 1 of the covert channel payload ('FireStage1' command)
- As we are able to print characters to the target, we are able to remote code run code. P4wnP1 uses this capability, to type out a PowerShell script, which builds and executes the covert channel communication stack. This attack works in multiple steps:
    1. Keystrokes are injected to start a PowerShell session and type out stage 1 of the payload. Depending on how the command `FireStage1` is used, this happens in different flavours. By default a short stub is executed, which hides the command windows from the user, followed by the stage 1 main script.
	2. The stage 1 main script comes in two fashions:
       - Type 1: A pure PowerShell script which is short and thus fast, but uses the infamous IEX command (this command has the capability to make threat hunters and blue teamers happy). This is the default stage 1 payload.
       - Type 2: A dot NET assembly, which is loaded and executed via PowerShell. This stage 1 payload takes longer to execute, as more characters are needed. But, as you may already know, it doesn't use the IEX command.
- It is worth mentioning, that the PowerShell session is started without command line arguments, so there's nothing which triggers detection mechanisms for malicious command lines. Theres no parameter like `-exec bypass`, `-enc`, `-NoProfile` or `hidden` ... nothing suspicious! The shortcoming is, that we need to wait till the PowerShell window opens before typing is continued. As we are not able to detect for input readiness and there are boxes which take years to bring up an interactive PowerShell window, the delay between running `powershell.exe` and starting of stage1 typeout could be changed with the second parameter to the `FireStage1` command (default is 1000 milliseconds).
- Last but not least, if you append `nohide` to the end of the `FireStage1` command line, the Window hiding stub isn't executed in upfront and you should be able to see all my sh**ty debug output.

### 5. Loading stage 2
- There's no rocket sience here. The stage 1 payload initializes the basic interface to the custom HID device and receives stage 2 **fully automated**. Stage 2 includes all the protocol layers and the final backdoor. It get's directly loaded into memory as dot NET assembly.
- So why dot NET ? The early versions of the backdoor have been fully developed in PowerShell. This resulted in a big mess when it comes to multi threading, PS 2.0 compatability without class inheritance and multi thread debugging with ISE. I don't want to say that is impossible (if you watched the commit history, there's the proof that it is possible), but there's no benefit. To be precise, there are disadvantages: Much more code is needed to achieve the same, the code is slower and **PowerShell Module Logging would be able to catch every single script command from the payload**. In contrast to using a dot NET assembly, where the only PowerShell commands which could get logged, are the ones which load the assembly and run the stage 2 trigger. Everything else is gone, as soon as the payload quits. So ... small footprint, yeah.
- But don't get "PowerShell inline assemlies" compiled to a temporary file on disc ?!?! Yes, they do! At least if they're written with CSharp inline code. Luckily P4wnP1 doesn't do this. The assemblies are shipped pre-compiled.
	
### 6. Using the backdoor connection
- After stage 2 has successfully ran, the prompt of the P4wnP1 backdoor shell should indicate a client connection.
- From here on, new commands are usable, these include:
    - `CreateProcess`
	- `interact`
	- `KillProcess`
	- `KillClient`
	- and ... :-) ... `shell`
- I'm too tired to explain these here, but I guess you'll find it out.

HID backdoor attack - summary
-----------------------------
1. Choose `hid_backdoor.txt` payload
2. Connect P4wnP1 device to Windows target
3. Connect to the newly spawned `P4wnP1` WiFi with a different device (could be a smartphone, as long as a SSH client is installed)
4. Set the correct target keyboard layout with `SetKeyboardLayout` (or alter `hidtools/backdoor/config.txt`)
5. On the P4wnP1 shell run `SendKeys` or `FireDuckyScript` to inject key strokes
6. To fire up the covert channel HID backdoor, issue the command `FireStage1`
7. After the target connected back, enter `shell` to create a remote shell through the covert channel

Currently missing features
--------------------------
- File transfer implementation (upload / download) ... but hey... you guys are redteamers and pentesters! You know how to deal with non-interactive remote shells, right? If not go and take an OSCP or something like that, but don't bother me with a feature request for this.
- Run TCP sockets through the HID channel. Yes, it would be really nice to have a SOCKS4a or SOCKS5 listening on P4wnP1, tunneling comms through the target client. I'm not sure when this will get done, as this PoC project consumed far too much time. But hey, the underlying communication layers are prepared to handle multiple channels and as far as I know, you're staring at the source code, right now!

Feature Comparison with BashBunny
=================================

Some days after initial P4wnP1 commit, Hak5's BashBunny was announced (and ordered by myself). Here's a little feature comparison:

| Feature                                                                         | BashBunny                                                                                               | P4wnP1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
|---------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| RNDIS, CDC ECM, HID , serial and Mass storage support                           | supported, usable in several combinations, Windows Class driver support (Plug and Play) in most modes   | supported, usable in most combinations, Windows Class driver support (Plug and Play) in all modes as composite device                                                                                                                                                                                                                                                                                                                                                                 |
| Target to device communication on covert HID channel                            | no                                                                                                      |  Raw HID device allows communication with Windows Targets (PowerShell 2.0+ present) via raw HID</br>  There's a full automated payload, allowing to access P4wnP1 bash via a custom PowerShell console from target device (see 'hid_frontdoor.txt' payload). </br> An additional payload based on this technique, allows to expose a backdoor session to P4wnP1 via HID covert channel and relaying it via WiFi/Bluetooth to any SSH capable device (bridging airgaps, payload 'hid_backdoor.txt') |
| Trigger payloads via target keyboard                                            | No                                                                                                      | Hardware based: LEDs for CAPSLOCK/SCROLLLOCK and NUMLOCK are read back and used to branch or trigger payloads (see ``hid_keyboard2.txt`` payload)                                                                                                                                                                                                                                                                                                                 |
| USB configuration changable during runtime                                      | supported                                                                                               | will maybe be implemented                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| Support for RubberDucky payloads                                                | supported                                                                                               | supported                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| Support for piping command output to HID keyboard out                           | no                                                                                                      | supported                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| Switchable payloads                                                             | Hardware switch                                                                                         | manually in interactive mode (Hardware switch could be soldered, script support is a low priority ToDo. At least till somebody prints a housing for the Pi which has such a switch and PIN connectors)                                                                                                                                                                                                                                                                                                                                                                               |
| Interactive Login with display out                                              | SSH / serial                                                                                            | SSH / serial / stand-alone (USB OTG + HDMI)                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| Performance                                                                     | High performance ARM quad core CPU, SSD Flash                                                           | Low performance single core ARM CPU, SDCARD                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| Network interface bitrate                                                       | Windows RNDIS: **2 GBit/s**</br>Linux/MacOS ECM: **100 MBit/s**</br>Real bitrate 450 MBit max (USB 2.0) | Windows RNDIS: **20 GBit/s**</br>Linux/MacOS ECM: **4 GBit/s** (detected as 1 GBit/s interface on MacOS)</br>Real bitrate 450 MBit max (USB 2.0)</br>[Here's the needed P4wnP1 patch](https://github.com/mame82/ratepatch)                                                                                                                                                                                                                                                            |
| LED indicator                                                                   | RGB Led, driven by single payload command                                                               | mono color LED, driven by a single payload command                                                                                                                                                                                                                                                                                                                                                                                                                      |
| Customization                                                                   | Debian based OS with package manager                                                                    | Debian based OS with package manager                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| External network access via WLAN (relay attacks, MitM attacks, airgap bridging) | Not possible, no external interface                                                                     | supported with Pi Zero W (payloads under development)                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| Ease of use                                                                     | Easy, change payloads based on USB drive, simple bash based scripting language                          | Medium, bash based event driven payloads, inline commands for HID (DuckyScript and ASCII keyboard printing, as well as LED control)                                                                                                                                                                                                                                                                                                                                                                                        |
| Available payloads                                                              | Fast growing github repo (big community)                                                                | Slowly growing github repo (spare time one man show ;-))                                                                                                                                                                                                                                                                                                                                                                                                                              |
| Costs                                                                           | about 99 USD                                                                                            | about 5 USD (11 USD fow WLAN capability with Pi Zero W)                                                                                                                                                                                                                                                                                                                                                                                                                               |

SumUp: BashBunny is directed to easy usage, but costs 20 times as much as the basic P4wnP1 hardware. P4wnP1 is directed to a more advanced user, but allows outbound communication on a separate network interface (routing and MitM traffic to upstream internet, hardware backdoor etc.)

Install instructions
====================

Refer to [INSTALL.md] (outdated, will be rewritten someday)

Getting started
===============

The default payload (payloads/network_only.txt) makes th Pi accessible via Ethernet over USB and WiFi.
You could SSH into P4wnP1

via USB

    pi@172.16.0.1

or via WiFi	
    
	pi@172.24.0.1 
	Network name: P4wnP1
	Key: MaMe82-P4wnP1

	
From there you could alter `setup.cfg` to change the current payload (`PAYLOAD` parameter) and keyboard language (`LANG` parameter).

Caution:
If the chosen payload overwites the global `LANG` parameter (like the hid_keyboard demo payloads), you have to change the `LANG` parameter in the payload, too. If your remove the `LANG` parameter from the payload, the setting from `setup.cfg` is taken. In short words, settings in payloads have higher priority than settings in `setup.cfg`

Requirements
============

-   Raspberry Pi Zero / Pi Zero W (other Pis don’t support USB gadget because they’re equipped with a Hub, so don’t ask)
-   Raspbian Jessie Lite pre installed (kernel is updated by the P4wnP1 installer, as the current kernel has errors in the USB gadget modules, resulting in a crash)
-   Internet connection to run the `install.sh` script
-   the project is still work in progress, so features and new payloads are added in frequently (make sure to have an updated copy of P4wnP1 repo)

Snagging creds from locked machines after MS16-112 (Oracle JAVA JRE/JDK vuln)
=============================================================================

During tests of P4wnP1 a product has been found to answer NTLM authentication requests on wpad.dat on a locked and fully patched Windows 10 machine (including patch for MS16-112). The NTLM hash of the logged in user is sent by a third party software, even if the machine isn’t domain joined. The flaw has been reported to the respective vendor. Details will be added to the readme as soon as a patch is available. For now I’ll recently update the disclosure timeline here.

Disclosure Timeline discovered NTLM hash leak:

| Date        	| Action                                       	|
|-------------	|----------------------------------------------	|
| Feb-23-2017 	| Initial report submitted to Oracle (Email)   	|
| Feb-23-2017 	| Oracle reports back, investigating the issue 	|
| Mar-01-2017 	| Oracle confirmed issue, working on fix       	|
| Mar-23-2017 	| Oracle: monthly status Update "Being fixed in main codeline"      	|
| Apr-23-2017   | Oracle: monthly status Update "Being fixed in main codeline"  (yes, Oracle statement doesn't change)      |
| May-23-2017 	| Oracle: monthly status Update "Being fixed in main codeline"      	|
| Jun-23-2017 	| Oracle: monthly status Update "Being fixed in main codeline"      	|
| Jul-14-2017 	| Oracle: released an update and registered **CVE-2017-10125**. See [link](http://www.securityfocus.com/bid/99809)      	|

So here we are now. The **vulnerable product has been the Oracle Java JRE and JDK** (1.7 Update 141 and 1.8 Update 131). The issue has been fixed with the "Oracle Critical Patch Update Advisory - July 2017", which could be found [here](http://www.oracle.com/technetwork/security-advisory/cpujul2017-3236622.html). So go and update your Java JRE/JDK.

Credits to
==========

-    Seytonic (youtube channel on hacking and hardware projects: [Seytonic]
-    Rogan Dawes (sensepost, core developer of Universal Serial Abuse - USaBUSe): [USaBUSe]
-    Samy Kamkar: [PoisonTap]
-    Rob ‘MUBIX’ Fuller: [“Snagging creds from locked machines”] and MUBIX at [github]
-    Laurent Gaffie (lgandx): [Responder]
-    Darren Kitchen (hak5darren): [DuckEncoder], time to implement a WiFi capable successor for BashBunny ;-)

  [Seytonic]: https://www.youtube.com/channel/UCW6xlqxSY3gGur4PkGPEUeA
  [PoisonTap]: https://github.com/samyk/poisontap
  [“Snagging creds from locked machines”]: https://room362.com/post/2016/snagging-creds-from-locked-machines/
  [github]: https://github.com/mubix
  [Responder]: https://github.com/lgandx/Responder
  [DuckEncoder]: https://github.com/hak5darren/USB-Rubber-Ducky/
  [INSTALL.md]: https://github.com/mame82/P4wnP1/blob/master/INSTALL.md
  [USaBUSe]: https://github.com/sensepost/USaBUSe
