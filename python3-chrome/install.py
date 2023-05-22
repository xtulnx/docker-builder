import sys, os
from undetected_chromedriver.patcher import Patcher
exec_path= os.environ.get('CHROME_DRIVER',"./chromedriver") if len(sys.argv) <= 1 else sys.argv[1]
version_main=108 if len(sys.argv) <= 2 else int(sys.argv[2])
patcher = Patcher(exec_path, version_main=version_main)
release = patcher.fetch_release_number()
patcher.version_main = release.version[0]
patcher.version_full = release
patcher.unzip_package(patcher.fetch_package())

if False:
    patcher.patch()

import re,io,random,string
def patch_exec_ori(new_content):
    # '$cdc_asdjflasutopfhvcZLmcfl_'
    replacement = ''.join(random.choices(string.ascii_letters, k=27)).encode()
    cr = re.compile(b'cdc_[0-9a-zA-Z]{22}_')
    m1 = cr.search(new_content, 0)
    while m1:
        target_bytes = m1[0]
        new_content = new_content.replace(target_bytes, replacement)
        m1 = cr.search(new_content, m1.end() + 1)
    return new_content


with io.open(patcher.executable_path, 'r+b') as fh:
    content = fh.read()
    # match_injected_codeblock = re.search(rb"{window.*;}", content)
    match_injected_codeblock = re.search(rb"\{window\.cdc.*?;\}", content)
    if match_injected_codeblock:
        target_bytes = match_injected_codeblock[0]
        new_target_bytes = (
            b'{console.log("undetected chromedriver 1337!")}'.ljust(
                len(target_bytes), b" "
            )
        )
        new_content = content.replace(target_bytes, new_target_bytes)
        if new_content == content:
            print("something went wrong patching the driver binary. could not find injection code block" )
        else:
            print("found block:\n%s\nreplacing with:\n%s" % (target_bytes, new_target_bytes))
        new_content = patch_exec_ori(new_content)
        fh.seek(0)
        fh.write(new_content)

if not patcher.is_binary_patched():
    print("failed")
    exit(-1)
