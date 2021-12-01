config.load_autoconfig()
config.source('horizon-dark.py')
c.fonts.web.size.default = 14
c.fonts.default_family = 'iosevka'
c.fonts.default_size = '9pt'
c.qt.highdpi = True
c.colors.webpage.darkmode.enabled = True
c.content.blocking.method = "both"
c.content.webgl = False

config.bind("'", 'set-cmd-text -s :quickmark-load')
