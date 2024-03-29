config.load_autoconfig()
config.source("horizon-dark.py")
c.url.start_pages = ["qute://start/"]
c.fonts.web.size.default = 14
c.fonts.default_family = "iosevka"
c.fonts.default_size = "10pt"
c.qt.highdpi = True
c.colors.webpage.darkmode.enabled = True
c.content.blocking.method = "both"
c.content.webgl = False
c.content.autoplay = False
c.content.javascript.clipboard = "access"

c.content.headers.user_agent = (
    "Mozilla/5.0 (Windows NT 10.0; rv:68.0) Gecko/20100101 Firefox/68.0"
)
c.content.headers.accept_language = "en-US,en;q=0.5"
c.content.headers.custom = {
    "accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"
}


c.content.blocking.method = "both"
c.content.blocking.adblock.lists = [
    "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/annoyances.txt",
    "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/badlists.txt",
    "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/badware.txt",
    "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/filters-2020.txt",
    "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/filters-2021.txt",
    "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/filters.txt",
    "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/privacy.txt",
    "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/resource-abuse.txt",
    "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/thirdparties/easylist-downloads.adblockplus.org/easyprivacy.txt",
    "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/thirdparties/pgl.yoyo.org/as/serverlist",
    "https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling/hosts",
    "https://raw.githubusercontent.com/AdAway/adaway.github.io/master/hosts.txt",
    "https://fanboy.co.nz/fanboy-problematic-sites.txt",
    "https://easylist.to/easylist/easylist.txt",
    "https://raw.githubusercontent.com/bogachenko/fuckfuckadblock/master/fuckfuckadblock.txt",
]
c.content.blocking.enabled = True

c.downloads.location.prompt = True
c.downloads.location.suggestion = "both"  # path, filename, both

c.scrolling.smooth = False

c.tabs.last_close = "close"
c.tabs.mode_on_change = "normal"

c.hints.chars = "arstgmneio"

c.window.hide_decoration = True

config.bind(",r", "config-source")
config.bind("M", "back")
config.bind("I", "forward")

config.bind('<left>', "move-to-prev-char" ,mode='caret')
config.bind('<right>', "move-to-next-char" ,mode='caret')
config.bind('<up>', "move-to-prev-line" ,mode='caret')
config.bind('<down>', "move-to-next-line" ,mode='caret')

c.aliases["zotero"] = "spawn --userscript qute-zotero.py"
config.bind(",z", "zotero")
c.aliases["Zotero"] = "hint links userscript qute-zotero.py"
config.bind(",Z", "Zotero")
