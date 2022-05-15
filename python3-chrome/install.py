import sys
from undetected_chromedriver.patcher import Patcher
exec_path="/data/chromedriver" if len(sys.argv) <= 1 else int(sys.argv[1])
version_main=101 if len(sys.argv) <= 2 else int(sys.argv[2])
patcher = Patcher(exec_path, version_main=version_main)
release = patcher.fetch_release_number()
patcher.version_main = release.version[0]
patcher.version_full = release
patcher.unzip_package(patcher.fetch_package())
patcher.patch()