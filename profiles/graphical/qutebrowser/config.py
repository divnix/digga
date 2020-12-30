# Documentation:
#   qute://help/configuring.html
#   qute://help/settings.html

# Uncomment this to still load settings configured via autoconfig.yml
# config.load_autoconfig()

# Require a confirmation before quitting the application.
# Type: ConfirmQuit
# Valid values:
#   - always: Always show a confirmation.
#   - multiple-tabs: Show a confirmation if multiple tabs are opened.
#   - downloads: Show a confirmation if downloads are running
#   - never: Never show a confirmation.
c.confirm_quit = ['downloads']

# Additional arguments to pass to Qt, without leading `--`. With
# QtWebEngine, some Chromium arguments (see
# https://peter.sh/experiments/chromium-command-line-switches/ for a
# list) will work.
# Type: List of String
c.qt.args = [
    'enable-native-gpu-memory-buffers'
]

# Allow websites to request geolocations.
# Type: BoolAsk
# Valid values:
#   - true
#   - false
#   - ask
c.content.geolocation = False

# Value to send in the `DNT` header. When this is set to true,
# qutebrowser asks websites to not track your identity. If set to null,
# the DNT header is not sent at all.
# Type: Bool
c.content.headers.do_not_track = True

c.content.cookies.accept = "no-3rdparty"

c.content.canvas_reading = False

c.content.dns_prefetch = True

c.content.webrtc_ip_handling_policy = "default-public-interface-only"

# Enable host blocking.
# Type: Bool
c.content.host_blocking.enabled = False

# Allow JavaScript to read from or write to the clipboard. With
# QtWebEngine, writing the clipboard as response to a user interaction
# is always allowed.
# Type: Bool
c.content.javascript.can_access_clipboard = False

# Allow JavaScript to open new tabs without user interaction.
# Type: Bool
c.content.javascript.can_open_tabs_automatically = False

# Enable JavaScript.
# Type: Bool
c.content.javascript.enabled = True

# Enable JavaScript.
# Type: Bool
config.set('content.javascript.enabled', True, 'file://*')

# Enable JavaScript.
# Type: Bool
config.set('content.javascript.enabled', True, 'chrome://*/*')

# Enable JavaScript.
# Type: Bool
config.set('content.javascript.enabled', True, 'qute://*/*')

# Allow locally loaded documents to access remote URLs.
# Type: Bool
c.content.local_content_can_access_remote_urls = False

# Allow locally loaded documents to access other local URLs.
# Type: Bool
c.content.local_content_can_access_file_urls = True

# Enable support for HTML 5 local storage and Web SQL.
# Type: Bool
c.content.local_storage = True

# Enable plugins in Web pages.
# Type: Bool
c.content.plugins = False

# Draw the background color and images also when the page is printed.
# Type: Bool
c.content.print_element_backgrounds = True

# Open new windows in private browsing mode which does not record
# visited pages.
# Type: Bool
c.content.private_browsing = False

# Enable WebGL.
# Type: Bool
c.content.webgl = False

# Monitor load requests for cross-site scripting attempts. Suspicious
# scripts will be blocked and reported in the inspector's JavaScript
# console. Enabling this feature might have an impact on performance.
# Type: Bool
c.content.xss_auditing = True

# What to display in the download filename input.
# Type: String
# Valid values:
#   - path: Show only the download path.
#   - filename: Show only download filename.
#   - both: Show download path and filename.
c.downloads.location.suggestion = 'filename'

# Where to show the downloaded files.
# Type: VerticalPosition
# Valid values:
#   - top
#   - bottom
c.downloads.position = 'top'

# Duration (in milliseconds) to wait before removing finished downloads.
# If set to -1, downloads are never removed.
# Type: Int
c.downloads.remove_finished = 8000

# Automatically enter insert mode if an editable element is focused
# after loading the page.
# Type: Bool
c.input.insert_mode.auto_load = True

# Leave insert mode if a non-editable element is clicked.
# Type: Bool
c.input.insert_mode.auto_leave = True

# Duration (in milliseconds) to show messages in the statusbar for. Set
# to 0 to never clear messages.
# Type: Int
c.messages.timeout = 8000

# Enable smooth scrolling for web pages. Note smooth scrolling does not
# work with the `:scroll-px` command.
# Type: Bool
c.scrolling.smooth = True

# Languages to use for spell checking. You can check for available
# languages and install dictionaries using scripts/dictcli.py. Run the
# script with -h/--help for instructions.
# Type: List of String
# Valid values:
#   - af-ZA: Afrikaans (South Africa)
#   - bg-BG: Bulgarian (Bulgaria)
#   - ca-ES: Catalan (Spain)
#   - cs-CZ: Czech (Czech Republic)
#   - da-DK: Danish (Denmark)
#   - de-DE: German (Germany)
#   - el-GR: Greek (Greece)
#   - en-AU: English (Australia)
#   - en-CA: English (Canada)
#   - en-GB: English (United Kingdom)
#   - en-US: English (United States)
#   - es-ES: Spanish (Spain)
#   - et-EE: Estonian (Estonia)
#   - fa-IR: Farsi (Iran)
#   - fo-FO: Faroese (Faroe Islands)
#   - fr-FR: French (France)
#   - he-IL: Hebrew (Israel)
#   - hi-IN: Hindi (India)
#   - hr-HR: Croatian (Croatia)
#   - hu-HU: Hungarian (Hungary)
#   - id-ID: Indonesian (Indonesia)
#   - it-IT: Italian (Italy)
#   - ko: Korean
#   - lt-LT: Lithuanian (Lithuania)
#   - lv-LV: Latvian (Latvia)
#   - nb-NO: Norwegian (Norway)
#   - nl-NL: Dutch (Netherlands)
#   - pl-PL: Polish (Poland)
#   - pt-BR: Portuguese (Brazil)
#   - pt-PT: Portuguese (Portugal)
#   - ro-RO: Romanian (Romania)
#   - ru-RU: Russian (Russia)
#   - sh: Serbo-Croatian
#   - sk-SK: Slovak (Slovakia)
#   - sl-SI: Slovenian (Slovenia)
#   - sq: Albanian
#   - sr: Serbian
#   - sv-SE: Swedish (Sweden)
#   - ta-IN: Tamil (India)
#   - tg-TG: Tajik (Tajikistan)
#   - tr-TR: Turkish (Turkey)
#   - uk-UA: Ukrainian (Ukraine)
#   - vi-VN: Vietnamese (Viet Nam)
c.spellcheck.languages = []

# Position of the tab bar.
# Type: Position
# Valid values:
#   - top
#   - bottom
#   - left
#   - right
c.tabs.position = 'top'

# When to show the tab bar.
# Type: String
# Valid values:
#   - always: Always show the tab bar.
#   - never: Always hide the tab bar.
#   - multiple: Hide the tab bar if only one tab is open.
#   - switching: Show the tab bar when switching tabs.
c.tabs.show = 'switching'

# Search engines which can be used via the address bar. Maps a search
# engine name (such as `DEFAULT`, or `ddg`) to a URL with a `{}`
# placeholder. The placeholder will be replaced by the search term, use
# `{{` and `}}` for literal `{`/`}` signs. The search engine named
# `DEFAULT` is used when `url.auto_search` is turned on and something
# else than a URL was entered to be opened. Other search engines can be
# used by prepending the search engine name to the search term, e.g.
# `:open google qutebrowser`.
# Type: Dict
c.url.searchengines = {
    'DEFAULT': 'https://duckduckgo.com/?q={}',
    'y': 'https://youtube.com/results?search_query={}',
    'w': 'https://en.wikipedia.org/w/index.php?search={}',
    'aw': 'https://wiki.archlinux.org/index.php?search={}',
    'g': 'https://www.google.com/search?source=&q={}',
    'gi': 'https://www.google.com/search?tbm=isch&q={}',
    'aur': 'https://aur.archlinux.org/packages/?O=0&K={}',
    'c': 'https://en.cppreference.com/w/cpp/keyword/{}',
    'r': 'https://doc.rust-lang.org/stable/std/?search={}'
}

c.url.start_pages = ['https://nixos.org/nixos/manual/options.html']

c.hints.chars = "asdfghjklvbcntyruewom"

# Font color for hints.
# Type: QssColor
c.colors.hints.fg = '#EFF0EB'

# Background color for hints. Note that you can use a `rgba(...)` value
# for transparency.
# Type: QssColor
c.colors.hints.bg = '#1E1F29'

# Font color for the matched part of hints.
# Type: QssColor
c.colors.hints.match.fg = '#5AF78E'

# leave listed modes easily with <a-j>
for mode in\
        ['caret', 'command', 'hint',
            'insert', 'passthrough', 'prompt',
            'yesno']:
    config.bind('<Alt+j>', 'leave-mode', mode=mode)

# Bindings for normal mode
config.bind(',p', 'spawn --userscript qute-pass -M gopass')
config.bind(',P', 'set-cmd-text -s :open -p')
config.bind(',r', 'restart')
config.bind(',c', 'config-source')
config.bind(';I', 'hint images download')
config.bind('X', 'undo')
config.bind('d', 'scroll-page 0 0.5')
config.bind('u', 'scroll-page 0 -0.5')
config.bind('x', 'tab-close')
