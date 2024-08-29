{ config, pkgs, lib,... }:

{

#    imports = [
#        ../modules/nixvim.nix
#    ];

    home.username = "markus";
    home.homeDirectory = "/home/markus";

    home.packages = with pkgs; [
        waybar
        mako
        kdePackages.polkit-kde-agent-1
        kdePackages.kwallet
        kdePackages.kwalletmanager
        kwalletcli
        kdePackages.plasma-browser-integration
        catppuccin
        hyprpaper
        distrobox
        nyancat
        kdePackages.dolphin
        podman-tui
        podman-compose
        fzf
        gh
        github-desktop
        gamemode
    ];

    catppuccin = {
        enable = true;
        flavor = "mocha";
    };

    home.stateVersion = "24.05";
    programs.home-manager.enable = true;

    programs.kitty = {
        enable = true;
        theme = "Catppuccin-Mocha";
        font.name = "JetBrainsMono Nerd Font";
        settings = {
            background_opacity = "0.75";
            enable_audio_bell = false;
            tab_bar_edge = "top";
        };
    };

    programs.starship = {
        enable = true;
        enableBashIntegration = true;
        enableZshIntegration = true;
        settings = {
            add_newline = true;
            aws.disabled = true;
            gcloud.disabled = true;
        };
    };
  
    programs.bash = {
        enable = true;
        enableCompletion = true;
        bashrcExtra = ''
            # extra .bashrc config goes here
        '';
    };

    programs.rofi = {
        enable = true;
        #package = pkgs.rofi-wayland;
        theme = lib.mkForce "android_notification";
        terminal = "${pkgs.kitty}/bin/kitty";
        location = "center";
    };

    programs.firefox = {
        enable = true;
        nativeMessagingHosts = [ pkgs.kdePackages.plasma-browser-integration ];
        package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
            #override = { pipewireSupport = true; };
            extraPolicies = {
                AutofillAddressEnabled = false;
                AutofillCreditCardEnabled = false;
                FirefoxSuggest = false;
                OfferToSaveLogins = false;
                DisableTelemetry = true;
                DisableAppUpdate = true;
                DisableFirefoxAccounts = true;
                DisableAccounts = true;
                DisableFirefoxScreenshots = true;
                DisablePasswordReveal = true;
                DisablePocket = true;
                DisableFormHistory = true;
                DontCheckDefaultBrowser = true;
                EnableTrackingProtection = {
                    Value = true;
                    Locked = true;
                    Cryptomining = true;
                    Fingerprinting = true;
                };
                PasswordManagerEnabled = false;
                PictureInPicture = {
                    Enabled = false;
                    Locked = true;
                };
                PromptForDownloadLocation = true;
                SearchBar = "unified";
                ExtensionSettings = {
                    "*".installation_mode = "blocked"; # blocks all addons except the ones specified below
                    # uBlock Origin:
                    "uBlock0@raymondhill.net" = {
                        install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
                        installation_mode = "force_installed";
                    };
                    "78272b6fa58f4a1abaac99321d503a20@proton.me" = {
                        install_url = "https://addons.mozilla.org/firefox/downloads/latest/proton-pass/latest.xpi";
                        installation_mode = "force_installed";
                    };
                    "plasma-browser-integration@kde.org" = {
                        install_url = "https://addons.mozilla.org/firefox/downloads/latest/plasma-integration/latest.xpi";
                        installation_mode = "force_installed";
                    };
                    "jid1-BoFifL9Vbdl2zQ@jetpack" = {
                        install_url = "https://addons.mozilla.org/firefox/downloads/latest/decentraleyes/latest.xpi";
                        installation_mode = "force_installed";
                    };
                    "CanvasBlocker@kkapsner.de" = {
                        install_url = "https://addons.mozilla.org/firefox/downloads/latest/canvasBlocker/latest.xpi";
                        installation_mode = "force_installed";
                    };
                    "zotero@chnm.gmu.edu" = {
                        install_url = "https://www.zotero.org/download/connector/dl?browser=firefox&version=5.0.144";
                        installation_mode = "force_installed";
                    };
                };
                Preferences = { 
                    "browser.contentblocking.category" = { Value = "strict"; Status = "locked"; };
                    "extensions.pocket.enabled" = { Value = false; Status = "locked"; };
                    "extensions.screenshots.disabled" = { Value = true; Status = "locked"; };
                    "browser.formfill.enable" = { Value = false; Status = "locked"; };
                    "browser.topsites.contile.enabled" = { Value = false; Status = "locked"; };
                    "browser.newtabpage.activity-stream.feeds.section.topstories" = { Value = false; Status = "locked"; };
                    "browser.newtabpage.activity-stream.feeds.snippets" = { Value = false; Status = "locked"; };
                    "browser.newtabpage.activity-stream.showSponsored" = { Value = false; Status = "locked"; };
                    "browser.newtabpage.activity-stream.showSponsoredTopSites" = { Value = false; Status = "locked"; };
                    "browser.newtabpage.activity-stream.system.showSponsored" = { Value = false; Status = "locked"; };
                    "widget.use-xdg-desktop-portal.file-picker" = "1";
                };
            };
        };
        profiles.default = {
            isDefault = true;
            search.default = "DuckDuckGo";
            search.privateDefault = "DuckDuckGo";
            search.order = [ "DuckDuckGo" ];
            search.force = true;
        };
    };

    programs.librewolf = {
        enable = true;
        settings = {
            "webgl.disabled" = false;
            "privacy.resistFingerprinting" = false;
            "privacy.clearOnShutdown.history" = false;
            #"privacy.clearOnShutdown.cookies" = false;
            #"network.cookie.lifetimePolicy" = 0;
        };
    };

    programs.hyprlock = {
        enable = true;
        settings = {
            general = {
                disable_loading_bar = true;
                grace = 300;
                hide_cursor = true;
                no_fade_in = false;
            };

            background = [
            {
                path = "screenshot";
                blur_passes = 3;
                blur_size = 8;
            }
            ];

            input-field = [
            {
                size = "200, 50";
                position = "0, -80";
                monitor = "";
                dots_center = true;
                fade_on_empty = false;
                font_color = "rgb(202, 211, 245)";
                inner_color = "rgb(91, 96, 120)";
                outer_color = "rgb(24, 25, 38)";
                outline_thickness = 5;
                #placeholder_text = '\'Password...'\';
                shadow_passes = 2;
            }
            ];
        };
    };

    wayland.windowManager.hyprland = {
        enable = true;
        xwayland.enable = true;
        systemd.variables = ["--all"];
        settings = {
            env = [
                "NIXOS_OZONE_WL,1" # for any ozone-based browser & electron apps to run on wayland
                "MOZ_ENABLE_WAYLAND,1" # for firefox to run on wayland
                "MOZ_WEBRENDER,1"
                # misc
                "_JAVA_AWT_WM_NONREPARENTING,1"
                "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
                "QT_QPA_PLATFORM,wayland"
                "SDL_VIDEODRIVER,wayland"
                "GDK_BACKEND,wayland"
            ];      

            monitor = ",preferred,auto,auto";

            general = {
                gaps_in = "5";
	            gaps_out = "10";
	            border_size = "2";
	            #col.active_border = "rgba(33ccffee) rgba(00ff99ee) 45deg";
	            #col.inactive_border = "rgba(595959aa)";
	            resize_on_border = false;
	            allow_tearing = true;
	            layout = "dwindle";
            };

            decoration = {
                rounding = "3";
	            active_opacity = "1.0";
	            inactive_opacity = "0.7";
	            drop_shadow = true;
	            shadow_range = "4";
	            shadow_render_power = "3";
	            #col.shadow = "rgba(1a1a1aee)";
	            blur.enabled = true;
	            blur.size = "3";
	            blur.passes = "1";
	            blur.vibrancy = "0.1696";
            };

            animations = {
                enabled = true;
                    bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
                    animation = [
                        "windows, 1, 7, myBezier"
                        "windowsOut, 1, 7, default, popin 80%"
                        "border, 1, 10, default"
                        "fade, 1, 7, default"
                        "workspaces, 1, 6, default"
	                ];
            };

            exec-once = [
                "waybar"
                "hyprpaper"
                "mako"
                "/usr/lib/polkit-kde-authentication-agent-1"
            ];

            "$mainMod" = "ALT";
            "$menu" = "rofi -show drun";
            bind = [
                "$mainMod, Q, exec, kitty"
                "$mainMod, L, exec, hyprlock"
                "$mainMod, C, killactive"
                "$mainMod, M, exit"
                "$mainMod, V, togglefloating"
                "$mainMod, SPACE, exec, $menu"
                "$mainMod, TAB, exec, rofi -show window"
                #"$mainMod, P, pseudo"
                "$mainMod, left, movefocus, l"
                "$mainMod, right, movefocus, r"
                "$mainMod, up, movefocus, u"
                "$mainMod, down, movefocus, d"
            ];
            bindm = [
                "$mainMod, mouse:272, movewindow"
                "$mainMod, mouse:273, resizewindow"
            ];

            input = {
                kb_layout = "jp";
                follow_mouse = "1";
            };

            windowrulev2 = "suppressevent maximize, class:.*";
        };
    };

#    home.file.test = {
#        enable = false;
#        target = "testconfig/config.test";
#        text = "vim.o.number = true \nvim.o.tabstop = 4\n";
#    };

}
