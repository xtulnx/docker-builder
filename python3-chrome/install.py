import sys
from undetected_chromedriver.patcher import Patcher
patcher = Patcher("/data/chromedriver", version_main=100 if len(sys.argv) <= 1 else int(sys.argv[1]))
release = patcher.fetch_release_number()
patcher.version_main = release.version[0]
patcher.version_full = release
patcher.unzip_package(patcher.fetch_package())
patcher.patch()